Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B426C804D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 15:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjCXOts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 10:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbjCXOtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 10:49:33 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769361990;
        Fri, 24 Mar 2023 07:49:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eh3so8774048edb.11;
        Fri, 24 Mar 2023 07:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679669360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w8i/6q7CgrLLxreHR0W5NCOW5wTxfi6u94FOfCVLsm0=;
        b=Zk3c3TRL/FP6vnqOFa4Destc9U8oW93K0Tt67Z9wd8D4dQ8SwzRZe2DksNhRPQYo3M
         SP5nzHrVR//sGHv8YdyGR/OvPSRSh1piHbPqnf4bZIVkpZRYMlF4UhaJ8UikcX/8JeID
         eRtxVf7ZdEgW7Di2K5k9VRpp1sMdEZ42o2masVQfalkmq3tCFsYaYVDhU1Rij1hzphbI
         50YeqcoutdXco//y6pkv2/5qVsbMxpLD4JMSvUQES629ddgu0aEYmVgIPjDLodE8xiPO
         HYiczflbpiSGtqQbRVc1V74NRXBiyC24TrdpSgr9n2BZvXKqh0gGSJ1Iw2dRHonvziUU
         PdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679669360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8i/6q7CgrLLxreHR0W5NCOW5wTxfi6u94FOfCVLsm0=;
        b=wMLjy4bX1K3ej5plzWa2L8kg69O6w45QG1YS7E8vpSsmVy4rcdo7nzghfL300Ckc9K
         j8HfQ0Qup46E3x/Lr3NHG0oZbW6f5kFJLXQVVKRPpPqulFs3u2qOFKIu2M6GpFFOXrrJ
         03SfH08QNlofwScCvdy0HegmG0vWEY8smZD0xhwdPaJfqtvtDMJnrEG538vSVaHxt+Zl
         mLNd8u2kbkE/Ul7HTrZPlqvbqQDdIFVuBpvviG1ebOk/7KN6c+iNEUE09fyAIPh3AFXD
         js/VEeyLxWb65w/aBgWTu3dJY7y56k76tmFneb8zoOQBbiLT+zg6YjMG9WpsT7tABTO6
         /VRg==
X-Gm-Message-State: AAQBX9dCTjK8p9v028a2ejWs6A+TH20cw/2UFhWlQDgHPbEUCYn6iu4L
        EYiHJ6vTAm33V7SVUpQcWn4=
X-Google-Smtp-Source: AKy350Yt9ORwSKr6rDmFFL+TjE6JGDQXOT5DwEjo0i0zFaFZ/QBM9rM/2TGTQZC/fPHNSa3HG177bw==
X-Received: by 2002:a50:ed11:0:b0:4fc:b51f:ff50 with SMTP id j17-20020a50ed11000000b004fcb51fff50mr3102806eds.30.1679669359773;
        Fri, 24 Mar 2023 07:49:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id xf9-20020a17090731c900b0093debb9990esm1303227ejb.212.2023.03.24.07.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:49:19 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:49:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: What is the best way to provide FDB related metrics to user
 space?
Message-ID: <20230324144917.32lnpgtw5auuyovy@skbuf>
References: <20230324140622.GB28424@pengutronix.de>
 <20230324144351.54kyejvgqvkozuvp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324144351.54kyejvgqvkozuvp@skbuf>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 04:43:51PM +0200, Vladimir Oltean wrote:
> Also, some DSA switches have a VLAN-unaware FDB, and if the bridge is
> VLAN-aware, it will have one FDB entry per each VLAN, whereas the
> hardware table will have a single FDB entry.

Sorry, imprecise language. I shouldn't have expressed this in terms of
"VLAN-unaware" and "VLAN-aware", but rather, in terms of "Shared VLAN
learning" and "Independent VLAN learning". Where the software bridge
implementation uses IVL, certain switches might use SVL.

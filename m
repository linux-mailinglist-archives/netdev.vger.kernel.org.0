Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5EEA5777FA
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiGQT13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiGQT12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:27:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1537412AE3
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:27:27 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c139so2669238pfc.2
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 12:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=trkZrmYpY+khegOgYDK1guKOl3Aw6WZ4Aeip3o84Kjs=;
        b=WWfnO1hO/0V0C5iOZQK7atk2J7R2xl5spB5r2/3//RcdGhhV1OCmVDFmWNfXb4gYQ/
         l2tzuQ0hbNbS7dLHLT8hzsFj+J54OwFl05fvnY4AgN97hPGBwS9uPWDVzQGVt8dlXeIG
         fd94bQK1sS9kK5kt4WcCpqjUwKsZHsz/bWfBuV+rIxjlGa1LFAkuMyTdxdn9h+zrg0YS
         TkIdEWhKq6DmNFRmUKa4b1o+/ktlSy8k2oyxQ3nIELCYIxhe6J5XiWfyQ+LXA4cRlGTX
         T/+B5WnnXc2B49KFgWUeT6f3/LWCS65dD7Tf73XKoz+UWki5aw0SnFyr42zTJsJZoUTV
         vEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=trkZrmYpY+khegOgYDK1guKOl3Aw6WZ4Aeip3o84Kjs=;
        b=22jkAFR4hN05uMMJsuAUlW+v+zCR4PNz/CcSng1/Ush5sACYOSx6aYD9JUi9BQLSjm
         3Ypn/mzZA1xGN1RbELvgdR6oGlnSSD2K3pGAdSc1ywzG5luyWcDtHxqbrlxF43qPv95R
         8CiyiVvR5b7dqqFtuFOiAPSRM27KxO3QHhwoU5cbNHTTq49dmmyXRztqVmBazaDsIgGK
         reevC4+vf2KrxFZcxhheZXPurCuN89FxW63/dVRjD1ISVvOkzlbrTMINY5F8ngWSlH5F
         ifyWGQB4qChtBPhpDwWCwytd40ZIQ43bqfmxmXR7GcVQPGzg7FdFSFcMTFvsW7qX0dRa
         Zh5Q==
X-Gm-Message-State: AJIora8jVzQFppat8S5xTsY4beNGJ+94aECGsBz2RFD3qJokVT7/kAIF
        amsVEfPyeBtng/tQR4djus8=
X-Google-Smtp-Source: AGRyM1vuOBvCu+AUAsb77GQyDGbEDCFMBO9xXhmqnCVM196U5qRcZGIpOxEcUaP4DHY50DTUuCwsPg==
X-Received: by 2002:a63:481a:0:b0:411:7951:cbcd with SMTP id v26-20020a63481a000000b004117951cbcdmr21560222pga.66.1658086046461;
        Sun, 17 Jul 2022 12:27:26 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id rj1-20020a17090b3e8100b001ecfa85c8f0sm9784878pjb.26.2022.07.17.12.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 12:27:26 -0700 (PDT)
Message-ID: <c8acab95-cbff-93c9-e83d-31f6dc7e7e8d@gmail.com>
Date:   Sun, 17 Jul 2022 12:27:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 14/15] docs: net: dsa: delete misinformation about
 -EOPNOTSUPP for FDB/MDB/VLAN
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-15-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-15-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> Returning -EOPNOTSUPP does *NOT* mean anything special.
> 
> port_vlan_add() is actually called from 2 code paths, one is
> vlan_vid_add() from 8021q module and the other is
> br_switchdev_port_vlan_add() from switchdev.
> 
> The bridge has a wrapper __vlan_vid_add() which first tries via
> switchdev, then if that returns -EOPNOTSUPP, tries again via the VLAN RX
> filters in the 8021q module. But DSA doesn't distinguish between one
> call path and the other when calling the driver's port_vlan_add(), so if
> the driver returns -EOPNOTSUPP to switchdev, it also returns -EOPNOTSUPP
> to the 8021q module. And the latter is a hard error.
> 
> port_fdb_add() is called from the deferred dsa_owq only, so obviously
> its return code isn't propagated anywhere, and cannot be interpreted in
> any way.
> 
> The return code from port_mdb_add() is propagated to the bridge, but
> again, this doesn't do anything special when -EOPNOTSUPP is returned,
> but rather, br_switchdev_mdb_notify() returns void.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F6D6C0211
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 14:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCSNfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 09:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjCSNfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 09:35:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12D213D;
        Sun, 19 Mar 2023 06:35:43 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r11so37250447edd.5;
        Sun, 19 Mar 2023 06:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679232942;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OONIH1D7qhWXmBLsQSfk+4Z7i5B3RC/IvZy6Bcubp2A=;
        b=Npf9iEDWWvQ5MGBmJdUO1PLLTxfKmG7zkXlCzIsqV91a2j668WG3XyaYgArWmjYYZe
         uYqcp1kTOKvk/LT6BgiyW4trh5AI0TXHRa2ySeAUwlu3qkJC9JAEKc2Tf5pPkKRu7Hev
         GEI7qbwpcLVP+rMn/qis2Wszq49Co8mMxF7T8M0Zg282slbZ253QZK5pvSVB6hqq1J8P
         7WBlF2rFKm47uVIJyQzY0KGzt8aQGCfNM3Efm2Gy8fvAHBtVTjPNLCnbfs00cCjzMbIv
         YBOivUhrz5gf2EKxp4/vUY6nbgFLhs48dQuSg/vnhull26vjOna46wlSVwAXsZFaFPwa
         0rTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679232942;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OONIH1D7qhWXmBLsQSfk+4Z7i5B3RC/IvZy6Bcubp2A=;
        b=tSNtU0mkzKhwCCG3effS4OpsT1ikbE+KyjtADs+gk19AcJEmN5/So3kmnYOUvKZCzw
         cXaU6nSkw4hPoS/Uauw+6Opy2FY7ZgkjvpULaRWcumao+jWkx9jAobdFwwuhZtyE++aD
         TBCXNDcieT/FXyf/y8T/q+/nSuPlw2Z5I6HqUv8wlCUllUuhA+EHdAuVRRtNlMHyivd1
         t1Pd6m1C0JZ4Zve1hMm9NMtynFMRigXf2NMoaP2uQodjCG9FrQyrQaWBYRYyc7chwZZD
         9PvjhLCNHu9U1FJokbG2TzNTNq75CUTl6TeIWPKSfGcd9ViEdl5184iAwXZ7U9JIGuou
         m3aA==
X-Gm-Message-State: AO0yUKVIrNO4KuFURarYRl/ctlQ/lGSY3oBKxYZVANmwj78/UdUH0bso
        LgmxMQf96U5lI9Kqr4AzF2w=
X-Google-Smtp-Source: AK7set+B8LPEKjULFdvHlWgYfG6M20ZKjWli5A0+zCb2CEo7sCX+Go+G4oJf1/FZ/tbGoC+s/1sp6A==
X-Received: by 2002:a17:906:361b:b0:932:35b1:47fa with SMTP id q27-20020a170906361b00b0093235b147famr5760948ejb.64.1679232941960;
        Sun, 19 Mar 2023 06:35:41 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709064f0700b008cda6560404sm3250587eju.193.2023.03.19.06.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 06:35:41 -0700 (PDT)
Date:   Sun, 19 Mar 2023 15:35:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     Klaus Kudielka <klaus.kudielka@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 4/4] net: dsa: mv88e6xxx: mask apparently
 non-existing phys during probing
Message-ID: <20230319133539.qc24xztkwfuadrn7@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-5-klaus.kudielka@gmail.com>
 <20230319110606.23e30050@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230319110606.23e30050@thinkpad>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:06:06AM +0100, Marek Behún wrote:
>   ~GENMASK(chip->info->phy_base_addr + mv88e6xxx_num_ports(chip),
>            chip->info->phy_base_addr)

But it needs to be ~GENMASK(base + num - 1, base), no?

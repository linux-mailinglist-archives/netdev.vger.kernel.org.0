Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82AF4C43A6
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240133AbiBYL2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240129AbiBYL2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:28:23 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29F718CC2B
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:27:50 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a8so10206519ejc.8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 03:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RcIi8o0xfj3kYcRpCQyfLo/UcL5v1LpiNtc6/v0lBz4=;
        b=fQOw+XPzEWdIwwzG3PFYopmWfg2kqAnni1+WnJOUuObo99HspD2g2r2eqb+gR5f4Xq
         os+aB5XbplrwrJNTuxGP9wfqK3oszQ54k8NfZXfLZPkdz0dXy/GIefOXMbPwowwM/qEY
         sDJR7fgt8TMaDSYIsm91Sc1slxAyBkbOoU4meDzATB1sn1otjO3EAtL9tRTso/1dQBBG
         V6LhDqnqgVYPPPJXI1tqP121EH0MBBuWEar4jcjSg53wL52W7sVVlPuWsiHHbbvyr8en
         OGVpPH2RT9TWrk5VHeMUzgIX+37PqvCAY+7DK+69vJ76dMPiGV/I43UIUa8l8JW+mkdU
         NnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RcIi8o0xfj3kYcRpCQyfLo/UcL5v1LpiNtc6/v0lBz4=;
        b=M2gKzdjr5KyBKGodFTtDLpMrSwvBnoAmI8KpVDqKcxkPq7D18bcblrgZQoBZcqhDgE
         l166K0FMRI1APS7rhFADPsrpPRZhQLb3+gNg1HdksfE89Zyd/uPKiery97J2Uy8p7uwG
         pFH+SUc1xwZRpVAqzLx8EFJOX07FyLTHXS2VL7ksGFunM8PI/IzqrraNP5LD2JNBz3CP
         VKNewhJ2eoO8HvLnCM1rUMdqQrR+sYqzjkdM1sR2P/73RPTNridinhi/pBE3WY7FPTzN
         QNfDk0Now+JLdZROQnE5rAMFIFFWmO09g7Q9Vb2EaXj+CB+tB3JaRjxqqinqeQtSFEaL
         rRrg==
X-Gm-Message-State: AOAM533loNik4Bjk62Of0AP2gV7T4PT8Vw+ToTfVDeXlwv9t8D7+QF7G
        5VjG0wmajGFStu5hjEAmN+E=
X-Google-Smtp-Source: ABdhPJwiKldGj2DDSsE5qJKoRBJYJcaucHV3I5R687lro3RBsN/3S4RiP0Q81ED+12x/gulAoM4C0Q==
X-Received: by 2002:a17:906:4f0a:b0:6ce:e4fc:34d0 with SMTP id t10-20020a1709064f0a00b006cee4fc34d0mr5723281eju.717.1645788469150;
        Fri, 25 Feb 2022 03:27:49 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id ju22-20020a17090798b600b006ce70fa8e4fsm885061ejc.187.2022.02.25.03.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 03:27:48 -0800 (PST)
Date:   Fri, 25 Feb 2022 13:27:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 6/6] net: dsa: sja1105: support switching
 between SGMII and 2500BASE-X
Message-ID: <20220225112747.ts3v6bcasq3b4ibi@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGmL-00AOjC-HP@rmk-PC.armlinux.org.uk>
 <20220225111649.pkmq3jxo6mm4qzfv@skbuf>
 <Yhi8KKOMlqbvkhDA@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yhi8KKOMlqbvkhDA@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 11:23:20AM +0000, Russell King (Oracle) wrote:
> The comment above comes directly from your patch back in November.
> Are you suggesting you aren't happy with your own comment? If you
> would like to update it, please let me have a suitable replacement
> for it.

Yes, I'm not happy with my own comment, just remove the text between the
parentheses. Thanks.

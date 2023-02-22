Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F5169FE89
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 23:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjBVWbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 17:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjBVWbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 17:31:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B473CE28;
        Wed, 22 Feb 2023 14:31:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id ee7so21427658edb.2;
        Wed, 22 Feb 2023 14:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k5e76QDVcXIFAd0Wkb0OTH38rJMSIKjvA8VReCJRnCM=;
        b=FZbeJXNAq1ZsDZMtQqSBgZzgeOzDT1glYOxlCoaLwFGqV9L/dftqlTd0I7ehrQ+pKK
         NXTXYuL9yLdZdN0+R/MLJPx6uyWN8QtoHDKVjT1RUPoakmLeaxqZqOD0wbc47sQGiCCL
         qPGWftrPHIASA4w+Pkmp18E1GonRqRA/pysKtTWOWyw77j+PkGf/qc7yo9kM8H2eNaxq
         ILRWWRqs657ee+Dlq/nUwBFUmnTMpCpbTvLtf+utsnbuBJaA83mp8McC0hROMH3qk4xF
         Fz3jKhE4Q5jJkdCgd+1DCxFeG19i64HcvvzHgvbdViYaTALiVpNkAGW7QStqzdLpcUnr
         jXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k5e76QDVcXIFAd0Wkb0OTH38rJMSIKjvA8VReCJRnCM=;
        b=1LZ1bmQIPWheA+x0BTStzkGwtpCGcD9fqo+rrlJLiUs0lPrj4uPr+2yU1OX7Mfdjlt
         uGbkRTlVB2rPetu3F8CQfQ3WnleyAiimtye05JwKyqVN2tNzW/2TUBRZaClElUYUG6Yx
         Wj0EwFU6lBwpAC9MoQnCNFfDr+38Z/UbmK/8atv/T1CB1fBFjwuexb4eUTs6KPG3Q+fV
         DuU4I/IqU9ffwFx9JLfj1dUH4lWgNeInK7oueVGSFDCb6IWRFfm6PIpnfIghncjQVHTW
         ohQReMsNFvWWEruKLCcUj60FVfbq1xoUdBCt8M0fFpR4sYUNfrXEhXkwIB0oMxo+FKwj
         KMEQ==
X-Gm-Message-State: AO0yUKXdJCDWnwKQ6gagrmOvmET7xslc8gxzuQ2YBXWmoW7tBd3HTn6h
        EIqZozPoXYh4agL0AWN8QO8=
X-Google-Smtp-Source: AK7set8BlOncWd056GOkQPVWChHsHxYj28qyzeN+uwnIYK1vOCj97T1zhAIso/flv8rKNv4S8lEMsw==
X-Received: by 2002:a17:907:6e87:b0:88c:4f0d:85af with SMTP id sh7-20020a1709076e8700b0088c4f0d85afmr23959066ejc.75.1677105104005;
        Wed, 22 Feb 2023 14:31:44 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lr12-20020a170906fb8c00b008d69458d374sm4067586ejb.95.2023.02.22.14.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 14:31:43 -0800 (PST)
Date:   Thu, 23 Feb 2023 00:31:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <20230222223141.ozeis33beq5wpkfy@skbuf>
References: <20230222031738.189025-1-marex@denx.de>
 <20230222210853.pilycwhhwmf7csku@skbuf>
 <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed05fc85-72a8-e694-b829-731f6d720347@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 11:05:10PM +0100, Marek Vasut wrote:
> On 2/22/23 22:08, Vladimir Oltean wrote:
> > Please summarize in the commit title what is the user-visible impact of
> > the problem that is being fixed. Short and to the point.
> 
> Can you suggest a Subject which is acceptable ?

Nope. The thing is, I don't know what you're seeing, only you do. I can
only review and comment if it's plausible or not. I'm sure you can come
up with something.

> > > Currently, the driver uses PORT read function on register P_XMII_CTRL_1
> > > to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.
> > 
> > Provably false. The driver does do that, but not for KSZ87xx.
> 
> The driver uses port read function with register value 0x56 instead of 0x06
> , which means the remapping happens twice, which provably breaks the driver
> since commit Fixes below .

The sentence is false in the context of ksz87xx, which is what is the
implied context of this patch (see commit title written by yourself).
The P_GMII_1GBIT_M field is not accessed, and that is a bug in itself.
Also, the (lack of) access to the P_GMII_1GBIT_M field is not what
causes the breakage that you see, but to other fields from that register.

> > There is no call site other than ksz_set_xmii(). Please delete false
> > information from the commit message.
> 
> $ git grep P_XMII_CTRL_1 drivers/net/dsa/microchip/
> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x06,
> drivers/net/dsa/microchip/ksz_common.c: [P_XMII_CTRL_1] = 0x0301,
> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> drivers/net/dsa/microchip/ksz_common.c: ksz_pread8(dev, port, regs[P_XMII_CTRL_1], &data8);
> drivers/net/dsa/microchip/ksz_common.c: ksz_pwrite8(dev, port, regs[P_XMII_CTRL_1], data8);
> drivers/net/dsa/microchip/ksz_common.h: P_XMII_CTRL_1,
> 
> I count 6.

So your response to 2 reviewers wasting their time to do a detailed
analysis of the code paths that apply to the KSZ87xx model in particular,
to tell you precisely why your commit message is incorrect is "git grep"?

> OK, to make this simple, can you write a commit message which you consider
> acceptable, to close this discussion ?

Nope. The thing is, I'm sure you can, too. Maybe you need to take a
break and think about this some more.

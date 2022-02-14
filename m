Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BB24B4173
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 06:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiBNFlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 00:41:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiBNFlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 00:41:05 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01454EA17
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 21:40:57 -0800 (PST)
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5934540053
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 05:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644817256;
        bh=UtvxLt+fpaGCh4jLiStzvvcYAH2mUcrQBrILFyvETHQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ezWhJ7mibNiVfEkqGAmR3CVoUbO10dpwmIurNNYXl8JEMqH7/62A9MSisC2MXcNiU
         ryrIpQyl20etJAcvwnKLL0yUBaFKAJeSbyaa54brjuPy695i7FJj7+A9JEJuEqY9dm
         Qhz7uTHB1hyXDg4NF1e9S0ToxLOnN88BEaT6itQnDV77o1nAmGJ66b6FKXb+VZNmgB
         9uVkzjxAk+OgO8MtqGmaeCKZkqpf5u3JCJjZrG4Ddh2YaGVWYvGb53JoFXCkUxa55n
         XMy53vNcphoBLBhHheHx9axc5FlH2b8adu5tjctetZN4Z9ydMcT8o1FLslbw0cJy8M
         cPUcyKufiizZQ==
Received: by mail-oi1-f197.google.com with SMTP id s42-20020a05680820aa00b002cfd10820b7so3279840oiw.4
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 21:40:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UtvxLt+fpaGCh4jLiStzvvcYAH2mUcrQBrILFyvETHQ=;
        b=WkgfWSSZM9aFMPWF2Lpk2ZfrPb2Acwq36ZGUYM2xMds+jdLALEWx4pJ1JdENco6Au3
         WZk5qvtB5CxdV0TNZtHOJ3maOCAoZ1wZaJclZSrKcPZ9sfRJBW/2IFVrAH+Fhyw6RLLb
         EcfddrVvZ/dwMfSw0ccUdpBgDa8083U8xzhurEnXbkKhmRGzovy5ucjjfFmOvkRTma2l
         LSsBX3r/fRFjy7Ik59KOT6JCkK6aZTg43rRdj+GG1bxwW7Zmx6raSj6Jmb6vrCUeDXB5
         lD95E3yWxUwt2G+bRjNWujPC6bH31UTVefcMvB7Ym6OC9iVUtuACdHYkhpmRjRPlbPAK
         KQTQ==
X-Gm-Message-State: AOAM530vnAppecEgXDUdJIXyHQw5BX8ievlDhvBKH1HxxR6hfS742j7I
        18/xwoSV2GDoKDkowbIzYEan3XLhshlOR2lzND8ioxkCGzSCrEXU7d7gnkCeDKCIj2ZIZLb8ce1
        1peT/c7ZMGwKk9MLh6yb0Te/mD4hcnjNFE0ThjJ5lTSAKfiaJsw==
X-Received: by 2002:a05:6870:a3c5:: with SMTP id h5mr3402026oak.247.1644817255190;
        Sun, 13 Feb 2022 21:40:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwPCy9bN1oZ8Fb+tXY12LBK9yr/J6dD3YY1lBryjJfZAi/D4hbOhXWOqdMlquheJmLDAjefs+nJoK4ul/gBG5s=
X-Received: by 2002:a05:6870:a3c5:: with SMTP id h5mr3402014oak.247.1644817254878;
 Sun, 13 Feb 2022 21:40:54 -0800 (PST)
MIME-Version: 1.0
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch> <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch> <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch> <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com> <Yex0rZ0wRWQH/L4n@lunn.ch>
In-Reply-To: <Yex0rZ0wRWQH/L4n@lunn.ch>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Mon, 14 Feb 2022 13:40:43 +0800
Message-ID: <CAAd53p6pfuYDor3vgm_bHFe_o7urNhv7W6=QGxVz6c=htt7wLg@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 23, 2022 at 5:18 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > One more idea:
> > The hw reset default for register 16 is 0x101e. If the current value
> > is different when entering config_init then we could preserve it
> > because intentionally a specific value has been set.
> > Only if we find the hw reset default we'd set the values according
> > to the current code.
>
> We can split the problem into two.
>
> 1) I think saving LED configuration over suspend/resume is not an
> issue. It is probably something we will be needed if we ever get PHY
> LED configuration via sys/class/leds.
>
> 2) Knowing something else has configured the LEDs and the Linux driver
> should not touch it. In general, Linux tries not to trust the
> bootloader, because experience has shown bad things can happen when
> you do. We cannot tell if the LED configuration is different to
> defaults because something has deliberately set it, or it is just
> messed up, maybe from the previous boot/kexec, maybe by the
> bootloader. Even this Dell system BIOS gets it wrong, it configures
> the LED on power on, but not resume !?!?!. And what about reboot?

The LED will be reconfigured correctly after each reboot.
The platform firmware folks doesn't want to restore the value on
resume because the Windows driver already does that. They are afraid
it may cause regression if firmware does the same thing.

>
> So i really would like the bootloader to explicitly say it has
> configured the LEDs and it takes full responsibility for any and all
> bad behaviour as a result.

This is an ACPI based platform and we are working on new firmware
property "use-firmware-led" to give driver a hint:
...
    Scope (_SB.PC00.OTN0)
    {
        Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
        {
            ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device
Properties for _DSD */,
            Package (0x01)
            {
                Package (0x02)
                {
                    "use-firmware-led",
                    One
                }
            }
        })
    }
...

Because the property is under PCI device namespace, I am not sure how
to (cleanly) bring the property from the phylink side to phydev side.
Do you have any suggestion?

Kai-Heng

>
>           Andrew

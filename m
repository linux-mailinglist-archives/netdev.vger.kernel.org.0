Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C22CA6A67A1
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 07:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCAG3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 01:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCAG3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 01:29:10 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1721B166FE
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:29:09 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ck15so49846026edb.0
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=id8UmxtnQcNh3noS8r466VqMaQOj1QzBiEu58jCXArs=;
        b=i2gsPuhTLQesSE2mQSEWv6OiWXJZLc0k7dD4XEpBzrI1q8nhVEewr+AHuFehSxPkxT
         /yVSiyMfIiYAql9+TlZG629agD1dL9eV+x+3bTtcrIYjqRgzDT2+T8vbQRwz8JUbI6CF
         FDmrqP7oMMFafZrvnbwXlF+vlZWwXshue2ktx8tTCsPJ1eY3PWkRfQf61ITFdC7tOUrV
         nmDEAyvnijq/91Pil+VInMqpHWu79enFd6ubRzGvfbW/eqN7GuAekXbE2AyxdMMU7F/X
         UIjlV0IZRMNoOYAvssBRLk6TlDWddYPThLa+GUs/9EG+1SPUXxwtu61u1+eRoM0VAZ3U
         BtgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=id8UmxtnQcNh3noS8r466VqMaQOj1QzBiEu58jCXArs=;
        b=YbiOSyyqeLgP/KLsnxUk6cMCZz2lGg7b8H2L8L68ItG7sNTB2X2MG4sEZO2YPkr0RX
         xmENFowRtoXTl4m4oJl4VtqTAym4+S9Gio9hmFUzOAj1RDzrAv0KM8op7Y0NAA5GeKam
         lcS8dnbnS+eQSXMo6QA5DLmrtcUnsDY7vxic9hwv62u3AptLauFotLdIAR0y7Z4kWALG
         daoMAyl9z7b2/myWxcp5bxNUgNZQgqGeOjRZJgWqXXsnsuwJFDfqo5zeaN2wVX7Foj2d
         NfuhkLuVv4LaznhwGQtcBVywjZ5rpvgTwgw4qzeC/hbgiLqn9S0bwEWyFVUviv08ihVD
         6Klg==
X-Gm-Message-State: AO0yUKXolclAIJf+oMDOg5RWfC0VOKJ7xpNwZmNgF0JNMM/kESFTAKc9
        uFX9p1LGdR00igCMGF5nFRY=
X-Google-Smtp-Source: AK7set94XyBgO5Gew3POCQiPc8F4PcJ65zStp9i8tatKiCgOTpp0ROdmtIXEAnA0ocnSQEbpgn95mQ==
X-Received: by 2002:a17:907:7244:b0:879:ab3:93d1 with SMTP id ds4-20020a170907724400b008790ab393d1mr7766611ejc.4.1677652147388;
        Tue, 28 Feb 2023 22:29:07 -0800 (PST)
Received: from ?IPV6:2a01:c22:771e:1d00:bcb0:d3fd:5ada:db40? (dynamic-2a01-0c22-771e-1d00-bcb0-d3fd-5ada-db40.c22.pool.telefonica.de. [2a01:c22:771e:1d00:bcb0:d3fd:5ada:db40])
        by smtp.googlemail.com with ESMTPSA id r7-20020a170906350700b008b2e4f88ed7sm5375139eja.111.2023.02.28.22.29.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 22:29:06 -0800 (PST)
Message-ID: <1489eb86-908f-88ac-8f6f-c895a32a8c23@gmail.com>
Date:   Wed, 1 Mar 2023 07:29:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org
References: <20230228133412.7662-1-alexander.stein@ew.tq-group.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH 1/1] net: phy: dp83867: Disable IRQs on suspend
In-Reply-To: <20230228133412.7662-1-alexander.stein@ew.tq-group.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.02.2023 14:34, Alexander Stein wrote:
> Before putting the PHY into IEEE power down mode, disable IRQs to
> prevent accessing the PHY once MDIO has already been shutdown.
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> I get this backtrace when trying to put the system into 'mem' powersaving
> state.
> 
I would have expected the following commit to prevent this scenario:
1758bde2e4aa ("net: phy: Don't trigger state machine while in suspend")

Can you check whether phydev->irq_suspended gets set in
mdio_bus_phy_suspend() in your case?

Which MAC driver do you use with this PHY?

> [   31.355468] ------------[ cut here ]------------
> [   31.360089] WARNING: CPU: 1 PID: 77 at drivers/net/phy/phy.c:1183 phy_error+0x10/0x54
> [   31.367932] Modules linked in: bluetooth 8021q garp stp mrp llc snd_soc_tlv320aic32x4_spi hantro_vpu snd_soc_fsl_
> asoc_card snd_soc_fsl_sai snd_soc_imx_audmux snd_soc_fsl_utils snd_soc_tlv320aic32x4_i2c snd_soc_simple_card_utils i
> mx_pcm_dma snd_soc_tlv320aic32x4 snd_soc_core v4l2_vp9 snd_pcm_dmaengine v4l2_h264 videobuf2_dma_contig v4l2_mem2mem
>  videobuf2_memops videobuf2_v4l2 videobuf2_common snd_pcm crct10dif_ce governor_userspace snd_timer imx_bus snd cfg8
> 0211 soundcore pwm_imx27 imx_sdma virt_dma qoriq_thermal pwm_beeper fuse ipv6
> [   31.372014] PM: suspend devices took 0.184 seconds
> [   31.415246] CPU: 1 PID: 77 Comm: irq/39-0-0025 Not tainted 6.2.0-next-20230228+ #1425 2e0329a68388c493d090f81d406
> 77fb8aeac52cf
> [   31.415257] Hardware name: TQ-Systems GmbH i.MX8MQ TQMa8MQ on MBa8Mx (DT)
> [   31.415261] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   31.445168] pc : phy_error+0x10/0x54
> [   31.448749] lr : dp83867_handle_interrupt+0x78/0x88
> [   31.453633] sp : ffff80000a353cb0
> [   31.456947] x29: ffff80000a353cb0 x28: 0000000000000000 x27: 0000000000000000
> [   31.464091] x26: 0000000000000000 x25: ffff800008dbb408 x24: ffff800009885568
> [   31.471235] x23: ffff0000c0e4b860 x22: ffff0000c0e4b8dc x21: ffff0000c0a46d18
> [   31.478380] x20: ffff8000098d18a8 x19: ffff0000c0a46800 x18: 0000000000000007
> [   31.485525] x17: 6f63657320313030 x16: 2e30206465737061 x15: 6c65282064657465
> [   31.492669] x14: 6c706d6f6320736b x13: 2973646e6f636573 x12: 0000000000000000
> [   31.499815] x11: ffff800009362180 x10: 0000000000000a80 x9 : ffff80000a3537a0
> [   31.506959] x8 : 0000000000000000 x7 : 0000000000000930 x6 : ffff0000c1494700
> [   31.514104] x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff0000c0a3d480
> [   31.521248] x2 : 0000000000000000 x1 : ffff0000c0f3d700 x0 : ffff0000c0a46800
> [   31.528393] Call trace:
> [   31.530840]  phy_error+0x10/0x54
> [   31.534071]  dp83867_handle_interrupt+0x78/0x88
> [   31.538605]  phy_interrupt+0x98/0xd8
> [   31.542183]  handle_nested_irq+0xcc/0x148
> [   31.546199]  pca953x_irq_handler+0xc8/0x154
> [   31.550389]  irq_thread_fn+0x28/0xa0
> [   31.553966]  irq_thread+0xcc/0x180
> [   31.557371]  kthread+0xf4/0xf8
> [   31.560429]  ret_from_fork+0x10/0x20
> [   31.564009] ---[ end trace 0000000000000000 ]---
> 
> $ ./scripts/faddr2line build_arm64/vmlinux dp83867_handle_interrupt+0x78/0x88
> dp83867_handle_interrupt+0x78/0x88:
> dp83867_handle_interrupt at drivers/net/phy/dp83867.c:332
> 
>  drivers/net/phy/dp83867.c | 30 ++++++++++++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 89cd821f1f46..ed7e3df7dfd1 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -693,6 +693,32 @@ static int dp83867_of_init(struct phy_device *phydev)
>  }
>  #endif /* CONFIG_OF_MDIO */
>  
> +static int dp83867_suspend(struct phy_device *phydev)
> +{
> +	/* Disable PHY Interrupts */
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->interrupts = PHY_INTERRUPT_DISABLED;
> +		if (phydev->drv->config_intr)
> +			phydev->drv->config_intr(phydev);
> +	}
> +
> +	return genphy_suspend(phydev);
> +}
> +
> +static int dp83867_resume(struct phy_device *phydev)
> +{
> +	genphy_resume(phydev);
> +
> +	/* Enable PHY Interrupts */
> +	if (phy_interrupt_is_valid(phydev)) {
> +		phydev->interrupts = PHY_INTERRUPT_ENABLED;
> +		if (phydev->drv->config_intr)
> +			phydev->drv->config_intr(phydev);
> +	}
> +
> +	return 0;
> +}
> +
>  static int dp83867_probe(struct phy_device *phydev)
>  {
>  	struct dp83867_private *dp83867;
> @@ -968,8 +994,8 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_intr	= dp83867_config_intr,
>  		.handle_interrupt = dp83867_handle_interrupt,
>  
> -		.suspend	= genphy_suspend,
> -		.resume		= genphy_resume,
> +		.suspend	= dp83867_suspend,
> +		.resume		= dp83867_resume,
>  
>  		.link_change_notify = dp83867_link_change_notify,
>  		.set_loopback	= dp83867_loopback,


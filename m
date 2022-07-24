Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F3A57F7B4
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiGXXiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiGXXiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:38:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D11FD22;
        Sun, 24 Jul 2022 16:38:11 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ss3so17548635ejc.11;
        Sun, 24 Jul 2022 16:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zry4/Dnu3duQwGon0guy4XCJ4bIwk7GLsI711tvINGE=;
        b=mXLbCdtnED17zPc6VHdf4G2FqaK+372fB1thKbOBo4XMR+ekH2taFb0C7L4C67lC9i
         GaqdlIFBnTzJITyUrBwLIaq+McdQgaIeo0FIeUAGhu/TXkTNqO6Hz4uTjZVfhUp2qAu9
         5Mm7tY4PYLZ+hZWQ0j295Hy/hPl1x8vgXGiqj3mChvBVTGKUolD2YGOegi+9a2BuZfK+
         FTxKitQBTU4mF0xOos365ML7J0MOXS0kV8Bkzb/xshn36m4Qyjv4u4BCYmxWR6tYlmbI
         qXEKGHDAzHN9lHQG+imHrovn5XTBM6JZMzCAfv80yBzz3/q2jaAEfTvfXMStzbnXZ+Ri
         s7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zry4/Dnu3duQwGon0guy4XCJ4bIwk7GLsI711tvINGE=;
        b=vbpyiA5WEgw+7yJUZSDljdy3NQu9x7gXyJINAWbWlJ9l7jDV7QicMBvUAEgYhTJwTY
         VMtg9Nz+mlcHJahkZiOiXApmzte04kvP6Ywv6T3i+K68vSdZmQMWFrlXehX4HIvPhiIk
         0sq6iE8PBewnwbdC/x09u9Z7SNtmnnfUz1p6vbrkyQCbMsxW8Y7mptAYJkkSwyRXVYoq
         h/5lUh7RPFzg2oW2cW9VmDbzDwRzwYF0KIBG/56V9Rn1vLbJ1i+Y5a0RGUhUkc1b+0x3
         th4nORlLaZd4zbFp/PPKYUtRYwSnolo01bJWYPaGw7JY91055XyZ/4VKlI9UKuIXB5ZF
         Bj/Q==
X-Gm-Message-State: AJIora/ay+6+Z0H+AJz2nnqgg8JsqdLPqAb15S4idV8CdS1TcNly9fOT
        FL1hxM30YnbCyW97ZNBFN00=
X-Google-Smtp-Source: AGRyM1tHmMp0RqSfGlUzi/WFEL62th3+01CTxKT+PYryHncJ+6BdWa6F15F8VqTPwVdmgvaniVt/KQ==
X-Received: by 2002:a17:907:7fa5:b0:72b:755a:b77e with SMTP id qk37-20020a1709077fa500b0072b755ab77emr7895461ejc.474.1658705890282;
        Sun, 24 Jul 2022 16:38:10 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id ez20-20020a056402451400b0043bc61348casm6132674edb.65.2022.07.24.16.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:38:09 -0700 (PDT)
Date:   Mon, 25 Jul 2022 02:38:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, jaz@semihalf.com,
        tn@semihalf.com
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
Message-ID: <20220724233807.bthah6ctjadl35by@skbuf>
References: <20220714010021.1786616-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714010021.1786616-1-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcin,

On Thu, Jul 14, 2022 at 03:00:21AM +0200, Marcin Wojtas wrote:
> Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> stopped relying on SPEED_MAX constant and hardcoded speed settings
> for the switch ports and rely on phylink configuration.
> 
> It turned out, however, that when the relevant code is called,
> the mac_capabilites of CPU/DSA port remain unset.
> mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> dsa_tree_setup_switches(), which precedes setting the caps in
> phylink_get_caps down in the chain of dsa_tree_setup_ports().
> 
> As a result the mac_capabilites are 0 and the default speed for CPU/DSA
> port is 10M at the start. To fix that execute phylink_get_caps() callback
> which fills port's mac_capabilities before they are processed.
> 
> Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX setting")
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 37b649501500..9fab76f256bb 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3293,7 +3293,12 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	 * port and all DSA ports to their maximum bandwidth and full duplex.
>  	 */
>  	if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port)) {
> -		unsigned long caps = dp->pl_config.mac_capabilities;
> +		unsigned long caps;
> +
> +		if (ds->ops->phylink_get_caps)
> +			ds->ops->phylink_get_caps(ds, port, &dp->pl_config);
> +
> +		caps = dp->pl_config.mac_capabilities;

We'll need this bug fixed in net-next one way or another.
If you resend this patch, please change the following:

(1) it's silly to (a) check for the presence of ds->ops->phylink_get_caps and
    (b) do an indirect function call when you know that the implementation is
    mv88e6xxx_get_caps(). So just call that.

(2) please don't touch &dp->pl_config, just create an on-stack
    struct phylink_config pl_config, and let DSA do its thing with
    &dp->pl_config whenever the timing of dsa_port_phylink_create() is.

>  
>  		if (chip->info->ops->port_max_speed_mode)
>  			mode = chip->info->ops->port_max_speed_mode(port);
> -- 
> 2.29.0
> 

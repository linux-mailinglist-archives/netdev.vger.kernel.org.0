Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991693E1518
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbhHEMxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241504AbhHEMxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 08:53:10 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E2CC061765;
        Thu,  5 Aug 2021 05:52:56 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z2so10916271lft.1;
        Thu, 05 Aug 2021 05:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BMHRHVG7FV528k0alS+dFJLWxY6mPvYTCXb2YBLZf+s=;
        b=kEa5CSWKVFwS77IGuDPqemqQ99clYWFylqTxEnL25Hyq+COpjNrBCXnKqH/Z7sVVlt
         ZFa4fHBYiVNjylDse/cLP9w9EII8/egPufYcYzDE3AmVWaaoV1yf2oN2R8SfuVhAngbT
         y4h1Dc3m4Va/nC1f6Isa7D7xz24cyUOrIi0uwge7cgL5EZOe8gV9FT7Yqne1xded4uQ0
         A+BJY4ThHNFwHUXZ76qFW04q3TXO+hEPTL+mpkIVRe9qZANnckcQj6ja+L6TxDwKi610
         8r3wtm8Ow/eTn0dDNBtiCEgmqKU1AbbnLteA6e4Nh5y8vqXjqyGwJdER/aK+13TrvlZp
         VDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BMHRHVG7FV528k0alS+dFJLWxY6mPvYTCXb2YBLZf+s=;
        b=ibwmpYC0ycykXD4ieACFJjnh5VTME137TweBMaC3osrKH1eUYRjJ5RHb3blwou1bdH
         5aP260B9ccQh7tkW7qowQj3/iSoYF5uld8HqiQJzlp+tL65UIOtlbbQ2VcXh+fblC998
         iPLSLCpvfUG0k8LJQvtjcp7YU6sdmsGp4bgpRGYapPe+rZOtZPzauL28dzUV/lQpJEKq
         aHUdsShyFcJ+WeNcXx/0TxPTT0ZmXdLKQNQhq3V+qvYUqrcVnyAuE0SpA4trgoIl/fNC
         6DZaZFRNXn8lfI1zJOLqvQ+3Uh7EDBZt2nv1Z/lPiMCs1li/34D/nIi7u3r7TDz11SjN
         sXuw==
X-Gm-Message-State: AOAM530b5EZqusfwEdfhDEZQ2jvQqfef3WbbeQAnNZjq2fzlUTCjpNoY
        zBEWygbWbZMZ5ysott1wbjuYfwANKdW/eIsYsL0=
X-Google-Smtp-Source: ABdhPJxPzVm6PuHZq3Z7RvCJpNktxLGos0h4n76WxvP0EJ2+mKO+ociYgvIFu92nnZx+dZTHvB1KPrZBPPxvucel0/g=
X-Received: by 2002:a05:6512:3255:: with SMTP id c21mr3633829lfr.179.1628167973678;
 Thu, 05 Aug 2021 05:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210805082253.3654591-1-arnd@kernel.org>
In-Reply-To: <20210805082253.3654591-1-arnd@kernel.org>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Thu, 5 Aug 2021 22:52:41 +1000
Message-ID: <CAGRGNgV89tdRvUXyfBCgmYMa3CXQV4oYeMeCq_-g5u1MtUkdKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] ethernet: fix PTP_1588_CLOCK dependencies
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <snelson@pensando.io>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        drivers@pensando.io, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>, Karen Xie <kxie@chelsio.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Aug 5, 2021 at 9:49 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent
> it from being disabled manually or built as a loadable module when the
> user is built-in. In the ICE driver, the latter now causes a link failure:
>
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_eth_ioctl':
> ice_main.c:(.text+0x13b0): undefined reference to `ice_ptp_get_ts_config'
> ice_main.c:(.text+0x13b0): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_get_ts_config'
> aarch64-linux-ld: ice_main.c:(.text+0x13bc): undefined reference to `ice_ptp_set_ts_config'
> ice_main.c:(.text+0x13bc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_set_ts_config'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_prepare_for_reset':
> ice_main.c:(.text+0x31fc): undefined reference to `ice_ptp_release'
> ice_main.c:(.text+0x31fc): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `ice_ptp_release'
> aarch64-linux-ld: drivers/net/ethernet/intel/ice/ice_main.o: in function `ice_rebuild':
>
> This is a recurring problem in many drivers, and we have discussed
> it several times befores, without reaching a consensus. I'm providing
> a link to the previous email thread for reference, which discusses
> some related problems.
>
> To solve the dependency issue better than the 'imply' keyword, introduce a
> separate Kconfig symbol "CONFIG_PTP_1588_CLOCK_OPTIONAL" that any driver
> can depend on if it is able to use PTP support when available, but works
> fine without it. Whenever CONFIG_PTP_1588_CLOCK=m, those drivers are
> then prevented from being built-in, the same way as with a 'depends on
> PTP_1588_CLOCK || !PTP_1588_CLOCK' dependency that does the same trick,
> but that can be rather confusing when you first see it.
>
> Since this should cover the dependencies correctly, the IS_REACHABLE()
> hack in the header is no longer needed now, and can be turned back
> into a normal IS_ENABLED() check. Any driver that gets the dependency
> wrong will now cause a link time failure rather than being unable to use
> PTP support when that is in a loadable module.
>
> However, the two recently added ptp_get_vclocks_index() and
> ptp_convert_timestamp() interfaces are only called from builtin code with
> ethtool and socket timestamps, so keep the current behavior by stubbing
> those out completely when PTP is in a loadable module. This should be
> addressed properly in a follow-up.
>
> As Richard suggested, we may want to actually turn PTP support into a
> 'bool' option later on, preventing it from being a loadable module
> altogether, which would be one way to solve the problem with the ethtool
> interface.
>
> Fixes: 06c16d89d2cb ("ice: register 1588 PTP clock device object for E810 devices")
> Link: https://lore.kernel.org/netdev/20210804121318.337276-1-arnd@kernel.org/
> Link: https://lore.kernel.org/netdev/CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/
> Link: https://lore.kernel.org/netdev/20210726084540.3282344-1-arnd@kernel.org/
> Acked-by: Shannon Nelson <snelson@pensando.io>
> Acked-by: Jacob Keller <jacob.e.keller@intel.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

> diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> index 8b0deece9758..e78c07f08cdf 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> +++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> @@ -2,6 +2,7 @@
>  config SCSI_CXGB4_ISCSI
>         tristate "Chelsio T4 iSCSI support"
>         depends on PCI && INET && (IPV6 || IPV6=n)
> ++      depends on PTP_1588_CLOCK_OPTIONAL

Extra +?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

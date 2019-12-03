Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31035110238
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfLCQ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:27:08 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42159 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727249AbfLCQ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:27:07 -0500
Received: by mail-lj1-f195.google.com with SMTP id e28so4497942ljo.9
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 08:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h9C2n+MHCjplzHYnNi07BHb4f1XYr4XT9zBJ/ZBs22c=;
        b=eIH8jyxl5W3h1DNl28UBcSMT9HKOFP7K3WZtBxuP8SA78R3JAGPhqIETRpC0p/0PnZ
         6ImPtiSM2Iq25bO33IRP3XLGPaVqDgB1s0E3mSRYiYbP8aVzat/G+marOMRwudFknMnQ
         ytEA9H80R2CTGSCu//DBHTUsbUAF08b4h/sI6jZDdF96k7qplucYdFKMTZWQ7qdZa453
         acmqwidQRarMm51DY4jWQi+whkoycdu+5FTudxuzELEVeKkkpjtrF8dY5or8cbSaKTKo
         XAGIDW5akXNKwp2q4Z4K41ydX/jGmBqn1tu1ddWK0VJJuXxHPpmHs3EvVByPDMkjIt/M
         qCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=h9C2n+MHCjplzHYnNi07BHb4f1XYr4XT9zBJ/ZBs22c=;
        b=IwvHjXAtuayNzceFCywtkjx4iZgYjetqt4R6jbKZ1Ml8HI3jRs2JatWrknXXEFFROu
         3MI+8dhqLkcxfHz+NiV+U6leNT5T3TO7CvppH6i/ZBW0KusTznzEgpku95KZbB4A3ysZ
         I4Ei53umLDExrehnoTeO7vIRsUnTuzNjmUBIygx+wS5z62JNXVR6zkWvG9t8nyF+Rw5W
         87boYUDdq5aUvFUgE7v9bAUXXeWXqfDjVVS05CkhSgpq8qfN7k1fTXlHBAuf7RHZjH5W
         DhYSjRlOg2mKFubNqi45m3yNmZyO753lrSQmAtvQ+S4v9mljtA/uZwP3QW2UK48HlQrT
         hh/A==
X-Gm-Message-State: APjAAAVu/GOldflUIhgp/kb5+JTmqg1V4Xw9FdTPWQwKwMfoX89lZ+d7
        TPtZYKmfdj7pBwPRh3K85LXFqw==
X-Google-Smtp-Source: APXvYqyAardmg0NrXumsDAT1FVgwWqwgEG/0hNYWrn+HLp1R+TiUT2+UT6Y2ooYr1rAqJuzrRW5Aqg==
X-Received: by 2002:a05:651c:208:: with SMTP id y8mr3188448ljn.36.1575390424112;
        Tue, 03 Dec 2019 08:27:04 -0800 (PST)
Received: from khorivan (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id f13sm1578745ljp.104.2019.12.03.08.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:27:03 -0800 (PST)
Date:   Tue, 3 Dec 2019 18:27:01 +0200
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Po Liu <po.liu@nxp.com>
Cc:     "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [v1,ethtool] ethtool: add setting frame preemption of traffic
 classes
Message-ID: <20191203162659.GC2680@khorivan>
Mail-Followup-To: Po Liu <po.liu@nxp.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094448.6206-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191127094448.6206-1-Po.Liu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 09:58:52AM +0000, Po Liu wrote:

Hi Po Liu,

>IEEE Std 802.1Qbu standard defined the frame preemption of port
>trffic classes. User can set a value to hardware. The value will
>be translated to a binary, each bit represent a traffic class.
>Bit "1" means preemptable traffic class. Bit "0" means express
>traffic class.  MSB represent high number traffic class.
>
>ethtool -k devname
>
>This command would show if the tx-preemption feature is available.
>If hareware set preemption feature. The property would be a fixed
>value 'on' if hardware support the frame preemption. Feature would
>show a fixed value 'off' if hardware don't support the frame preemption.
>
>ethtool devname
>
>This command would show include an item 'preemption'. A following
>value '0' means all traffic classes are 'express'. A value none zero
>means traffic classes preemption capabilities. The value will be
>translated to a binary, each bit represent a traffic class. Bit '1'
>means preemptable traffic class. Bit '0' means express traffic class.
>MSB represent high number traffic class.
>
>ethtool -s devname preemption N

What about other potential parameters like MAC fragment size, mac hold?
Shouldn't be it considered along with other FP parameters to provide correct
interface later?

Say, preemption, lets name it fp-mask or frame-preemption-mask.
Then other potential setting can be similar and added later:

frame-preemption-mask
frame-preemption-fragsize
frame-preemption-machold
....

mac-hold it's rather flag, at least I've used it as priv-flag.
so can or so

frame-preemption-flags

>
>This command would set which traffic classes are frame preemptable.
>The value will be translated to a binary, each bit represent a
>traffic class. Bit '1' means preemptable traffic class. Bit '0'
>means express traffic class. MSB represent high number traffic class.
>
>Signed-off-by: Po Liu <Po.Liu@nxp.com>
>---
> ethtool-copy.h |  6 +++++-
> ethtool.8.in   |  8 ++++++++
> ethtool.c      | 18 ++++++++++++++++++
> 3 files changed, 31 insertions(+), 1 deletion(-)
>
>diff --git a/ethtool-copy.h b/ethtool-copy.h
>index 9afd2e6..e04bdf3 100644
>--- a/ethtool-copy.h
>+++ b/ethtool-copy.h
>@@ -1662,6 +1662,9 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
> #define AUTONEG_DISABLE		0x00
> #define AUTONEG_ENABLE		0x01
>
>+/* Disable preemtion. */
>+#define PREEMPTION_DISABLE	0x0
>+
> /* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
>  * the driver is required to renegotiate link
>  */
>@@ -1878,7 +1881,8 @@ struct ethtool_link_settings {
> 	__s8	link_mode_masks_nwords;
> 	__u8	transceiver;
> 	__u8	reserved1[3];
>-	__u32	reserved[7];
>+	__u32	preemption;
>+	__u32	reserved[6];
> 	__u32	link_mode_masks[0];
> 	/* layout of link_mode_masks fields:
> 	 * __u32 map_supported[link_mode_masks_nwords];
>diff --git a/ethtool.8.in b/ethtool.8.in
>index 062695a..7d612b2 100644
>--- a/ethtool.8.in
>+++ b/ethtool.8.in
>@@ -236,6 +236,7 @@ ethtool \- query or control network driver and hardware settings
> .B2 autoneg on off
> .BN advertise
> .BN phyad
>+.BN preemption
> .B2 xcvr internal external
> .RB [ wol \ \*(WO]
> .RB [ sopass \ \*(MA]
>@@ -703,6 +704,13 @@ lB	l	lB.
> .BI phyad \ N
> PHY address.
> .TP
>+.BI preemption \ N
>+Set preemptable traffic classes by bits.
>+.B A
>+value will be translated to a binary, each bit represent a traffic class.
>+Bit "1" means preemptable traffic class. Bit "0" means express traffic class.
>+MSB represent high number traffic class.
>+.TP
> .A2 xcvr internal external
> Selects transceiver type. Currently only internal and external can be
> specified, in the future further types might be added.
>diff --git a/ethtool.c b/ethtool.c
>index acf183d..d5240f8 100644
>--- a/ethtool.c
>+++ b/ethtool.c
>@@ -928,6 +928,12 @@ dump_link_usettings(const struct ethtool_link_usettings *link_usettings)
> 		}
> 	}
>
>+	if (link_usettings->base.preemption == PREEMPTION_DISABLE)
>+		fprintf(stdout, "	Preemption: 0x0 (off)\n");
>+	else
>+		fprintf(stdout, "	Preemption: 0x%x\n",
>+			link_usettings->base.preemption);
>+
> 	return 0;
> }
>
>@@ -2869,6 +2875,7 @@ static int do_sset(struct cmd_context *ctx)
> 	int port_wanted = -1;
> 	int mdix_wanted = -1;
> 	int autoneg_wanted = -1;
>+	int preemption_wanted = -1;
> 	int phyad_wanted = -1;
> 	int xcvr_wanted = -1;
> 	u32 *full_advertising_wanted = NULL;
>@@ -2957,6 +2964,12 @@ static int do_sset(struct cmd_context *ctx)
> 			} else {
> 				exit_bad_args();
> 			}
>+		} else if (!strcmp(argp[i], "preemption")) {
>+			gset_changed = 1;
>+			i += 1;
>+			if (i >= argc)
>+				exit_bad_args();
>+			preemption_wanted = get_u32(argp[i], 16);
> 		} else if (!strcmp(argp[i], "advertise")) {
> 			gset_changed = 1;
> 			i += 1;
>@@ -3094,6 +3107,9 @@ static int do_sset(struct cmd_context *ctx)
> 			}
> 			if (autoneg_wanted != -1)
> 				link_usettings->base.autoneg = autoneg_wanted;
>+			if (preemption_wanted != -1)
>+				link_usettings->base.preemption
>+					= preemption_wanted;
> 			if (phyad_wanted != -1)
> 				link_usettings->base.phy_address = phyad_wanted;
> 			if (xcvr_wanted != -1)
>@@ -3186,6 +3202,8 @@ static int do_sset(struct cmd_context *ctx)
> 				fprintf(stderr, "  not setting transceiver\n");
> 			if (mdix_wanted != -1)
> 				fprintf(stderr, "  not setting mdix\n");
>+			if (preemption_wanted != -1)
>+				fprintf(stderr, "  not setting preemption\n");
> 		}
> 	}
>
>-- 
>2.17.1
>

-- 
Regards,
Ivan Khoronzhuk

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D53937030A
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhD3VjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:39:06 -0400
Received: from p3plsmtpa06-05.prod.phx3.secureserver.net ([173.201.192.106]:47920
        "EHLO p3plsmtpa06-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231197AbhD3VjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:39:05 -0400
Received: from chrisHP110 ([76.103.216.188])
        by :SMTPAUTH: with ESMTPA
        id capzl7fsLJOFrcaq0lTT1H; Fri, 30 Apr 2021 14:38:16 -0700
X-CMAE-Analysis: v=2.4 cv=BYkdbph2 c=1 sm=1 tr=0 ts=608c78c8
 a=ZkbE6z54K4jjswx6VoHRvg==:117 a=ZkbE6z54K4jjswx6VoHRvg==:17
 a=kj9zAlcOel0A:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=eUCHAjWJAAAA:8
 a=PLrtAydwnW_onDDdDCIA:9 a=uiu3g-sycPq5sosQ:21 a=jdTVGM-ruMEDijtt:21
 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=e1s5y4BJLze_2YVawdyF:22
X-SECURESERVER-ACCT: don@thebollingers.org
From:   "Don Bollinger" <don@thebollingers.org>
To:     "'Moshe Shemesh'" <moshe@nvidia.com>,
        "'Michal Kubecek'" <mkubecek@suse.cz>,
        "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Jakub Kicinski'" <kuba@kernel.org>, <netdev@vger.kernel.org>
Cc:     "'Vladyslav Tarasiuk'" <vladyslavt@nvidia.com>
References: <1619162596-23846-1-git-send-email-moshe@nvidia.com> <1619162596-23846-3-git-send-email-moshe@nvidia.com>
In-Reply-To: <1619162596-23846-3-git-send-email-moshe@nvidia.com>
Subject: RE: [PATCH ethtool-next 2/4] ethtool: Refactor human-readable module EEPROM output
Date:   Fri, 30 Apr 2021 14:38:15 -0700
Message-ID: <008601d73e09$211d11e0$635735a0$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIoIhiQoNl9y+8EvClCms9DfxFPhwLFIp6xqhWi2WA=
Content-Language: en-us
X-CMAE-Envelope: MS4xfP72E0OT1WHNNBmWsxsvHNQrNnrX5OdtYYRwyQcILvxQOQvjEPLRfDdFQtdOH8eEVWepVnITOBFgx/cSv7aljwJ+RiXWyaYZOERK3eqCcf2Dl3vl2+Ai
 6qi5OsBIZZKmKght+OC2ZrvURofVr5nSZS6DL5kyNDFGcFDirOg2FhE7AjzVayOm3gDDEdShZy6CeIdcwvlnX2EHnA2wyodg6COce8JouAsZJKfQ4Epf+7Tk
 HDvMk2QBW8te764Rk2R562ZoBXMOL8FqVGOl/7N5GNOZkI4bAnshG36eItP4yMgYUDw7Y80/lXUbo9sMZBwgXDNyqNOKNA2YIZOiHSziLbM=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Moshe Shemesh [mailto:moshe@nvidia.com]
> Sent: Friday, April 23, 2021 12:23 AM
> To: Michal Kubecek <mkubecek@suse.cz>; Andrew Lunn
> <andrew@lunn.ch>; Jakub Kicinski <kuba@kernel.org>; Don Bollinger
> <don@thebollingers.org>; netdev@vger.kernel.org
> Cc: Vladyslav Tarasiuk <vladyslavt@nvidia.com>; Moshe Shemesh
> <moshe@nvidia.com>
> Subject: [PATCH ethtool-next 2/4] ethtool: Refactor human-readable module
> EEPROM output
> 
> From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> 
> Reuse existing SFF8636 and QSFP-DD infrastructures to implement EEPROM
> decoders, which work with paged memory. Add support for human-readable
> output for QSFP, QSFP28, QSFP Plus, QSFP-DD and DSFP transreceivers from
> netlink 'ethtool -m' handler.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> ---
>  internal.h              |   2 +
>  netlink/module-eeprom.c |  13 ++++
>  qsfp-dd.c               |  44 +++++++++++---
>  qsfp-dd.h               |  29 +++++----
>  qsfp.c                  | 127 +++++++++++++++++++++++-----------------
>  qsfp.h                  |  52 ++++++++--------
>  sff-common.c            |   3 +
>  sff-common.h            |   3 +-
>  8 files changed, 171 insertions(+), 102 deletions(-)
> 
> diff --git a/internal.h b/internal.h
> index 2affebe..33e619b 100644
> --- a/internal.h
> +++ b/internal.h
> @@ -391,6 +391,8 @@ void sff8472_show_all(const __u8 *id);
> 
>  /* QSFP Optics diagnostics */
>  void sff8636_show_all(const __u8 *id, __u32 eeprom_len);
> +void sff8636_show_all_paged(const struct ethtool_module_eeprom
> *page_zero,
> +			    const struct ethtool_module_eeprom
> *page_three);
> 
>  /* FUJITSU Extended Socket network device */  int fjes_dump_regs(struct
> ethtool_drvinfo *info, struct ethtool_regs *regs); diff --git
a/netlink/module-
> eeprom.c b/netlink/module-eeprom.c index 7298087..768a261 100644
> --- a/netlink/module-eeprom.c
> +++ b/netlink/module-eeprom.c
> @@ -291,6 +291,7 @@ static bool page_available(struct
> ethtool_module_eeprom *which)
>  	case SFF8024_ID_QSFP_PLUS:
>  		return (!which->bank && which->page <= 3);
>  	case SFF8024_ID_QSFP_DD:
> +	case SFF8024_ID_DSFP:
>  		return !(flat_mem && which->page);
>  	default:
>  		return true;
> @@ -323,6 +324,7 @@ static int decoder_prefetch(struct nl_context *nlctx)
>  		request.page = 3;
>  		break;
>  	case SFF8024_ID_QSFP_DD:
> +	case SFF8024_ID_DSFP:
>  		memset(&request, 0, sizeof(request));
>  		request.i2c_address = ETH_I2C_ADDRESS_LOW;
>  		request.offset = 128;
> @@ -336,13 +338,24 @@ static int decoder_prefetch(struct nl_context
> *nlctx)
> 
>  static void decoder_print(void)
>  {
> +	struct ethtool_module_eeprom *page_three = cache_get(3, 0,
> +ETH_I2C_ADDRESS_LOW);
>  	struct ethtool_module_eeprom *page_zero = cache_get(0, 0,
> ETH_I2C_ADDRESS_LOW);
> +	struct ethtool_module_eeprom *page_one = cache_get(1, 0,
> +ETH_I2C_ADDRESS_LOW);
>  	u8 module_id = page_zero->data[SFF8636_ID_OFFSET];
> 
>  	switch (module_id) {
>  	case SFF8024_ID_SFP:
>  		sff8079_show_all(page_zero->data);
>  		break;
> +	case SFF8024_ID_QSFP:
> +	case SFF8024_ID_QSFP28:
> +	case SFF8024_ID_QSFP_PLUS:
> +		sff8636_show_all_paged(page_zero, page_three);
> +		break;
> +	case SFF8024_ID_QSFP_DD:
> +	case SFF8024_ID_DSFP:
> +		cmis4_show_all(page_zero, page_one);
> +		break;
>  	default:
>  		dump_hex(stdout, page_zero->data, page_zero->length,
> page_zero->offset);
>  		break;
> diff --git a/qsfp-dd.c b/qsfp-dd.c
> index 900bbb5..5c2e4a0 100644
> --- a/qsfp-dd.c
> +++ b/qsfp-dd.c
> @@ -274,6 +274,20 @@ static void qsfp_dd_show_mod_lvl_monitors(const
> __u8 *id)
>  		  OFFSET_TO_U16(QSFP_DD_CURR_CURR_OFFSET));
>  }
> 
> +static void qsfp_dd_show_link_len_from_page(const __u8
> *page_one_data)
> +{
> +	qsfp_dd_print_smf_cbl_len(page_one_data);
> +	sff_show_value_with_unit(page_one_data,
> QSFP_DD_OM5_LEN_OFFSET,
> +				 "Length (OM5)", 2, "m");
> +	sff_show_value_with_unit(page_one_data,
> QSFP_DD_OM4_LEN_OFFSET,
> +				 "Length (OM4)", 2, "m");
> +	sff_show_value_with_unit(page_one_data,
> QSFP_DD_OM3_LEN_OFFSET,
> +				 "Length (OM3 50/125um)", 2, "m");
> +	sff_show_value_with_unit(page_one_data,
> QSFP_DD_OM2_LEN_OFFSET,
> +				 "Length (OM2 50/125um)", 1, "m");
> +}
> +
> +
>  /**
>   * Print relevant info about the maximum supported fiber media length
>   * for each type of fiber media at the maximum module-supported bit rate.
> @@ -283,15 +297,7 @@ static void qsfp_dd_show_mod_lvl_monitors(const
> __u8 *id)
>   */
>  static void qsfp_dd_show_link_len(const __u8 *id)  {
> -	qsfp_dd_print_smf_cbl_len(id);
> -	sff_show_value_with_unit(id, QSFP_DD_OM5_LEN_OFFSET,
> -				 "Length (OM5)", 2, "m");
> -	sff_show_value_with_unit(id, QSFP_DD_OM4_LEN_OFFSET,
> -				 "Length (OM4)", 2, "m");
> -	sff_show_value_with_unit(id, QSFP_DD_OM3_LEN_OFFSET,
> -				 "Length (OM3 50/125um)", 2, "m");
> -	sff_show_value_with_unit(id, QSFP_DD_OM2_LEN_OFFSET,
> -				 "Length (OM2 50/125um)", 1, "m");
> +	qsfp_dd_show_link_len_from_page(id + PAG01H_UPPER_OFFSET);
>  }
> 
>  /**
> @@ -331,3 +337,23 @@ void qsfp_dd_show_all(const __u8 *id)
>  	qsfp_dd_show_vendor_info(id);
>  	qsfp_dd_show_rev_compliance(id);
>  }
> +
> +void cmis4_show_all(const struct ethtool_module_eeprom *page_zero,
> +		    const struct ethtool_module_eeprom *page_one) {
> +	const __u8 *page_zero_data = page_zero->data;
> +
> +	qsfp_dd_show_identifier(page_zero_data);
> +	qsfp_dd_show_power_info(page_zero_data);
> +	qsfp_dd_show_connector(page_zero_data);
> +	qsfp_dd_show_cbl_asm_len(page_zero_data);
> +	qsfp_dd_show_sig_integrity(page_zero_data);
> +	qsfp_dd_show_mit_compliance(page_zero_data);
> +	qsfp_dd_show_mod_lvl_monitors(page_zero_data);
> +
> +	if (page_one)
> +		qsfp_dd_show_link_len_from_page(page_one->data);
> +
> +	qsfp_dd_show_vendor_info(page_zero_data);
> +	qsfp_dd_show_rev_compliance(page_zero_data);
> +}
> diff --git a/qsfp-dd.h b/qsfp-dd.h
> index f589c4e..fddb188 100644
> --- a/qsfp-dd.h
> +++ b/qsfp-dd.h
> @@ -96,30 +96,33 @@
>  /*-----------------------------------------------------------------------
>   * Upper Memory Page 0x01: contains advertising fields that define
> properties
>   * that are unique to active modules and cable assemblies.
> - * RealOffset = 1 * 0x80 + LocalOffset
> + * GlobalOffset = 2 * 0x80 + LocalOffset
>   */
> -#define PAG01H_UPPER_OFFSET			(0x01 * 0x80)
> +#define PAG01H_UPPER_OFFSET			(0x02 * 0x80)
> 
>  /* Supported Link Length (Page 1) */
> -#define QSFP_DD_SMF_LEN_OFFSET
> 	(PAG01H_UPPER_OFFSET + 0x84)
> -#define QSFP_DD_OM5_LEN_OFFSET
> 	(PAG01H_UPPER_OFFSET + 0x85)
> -#define QSFP_DD_OM4_LEN_OFFSET
> 	(PAG01H_UPPER_OFFSET + 0x86)
> -#define QSFP_DD_OM3_LEN_OFFSET
> 	(PAG01H_UPPER_OFFSET + 0x87)
> -#define QSFP_DD_OM2_LEN_OFFSET
> 	(PAG01H_UPPER_OFFSET + 0x88)
> +#define QSFP_DD_SMF_LEN_OFFSET			0x4
> +#define QSFP_DD_OM5_LEN_OFFSET			0x5
> +#define QSFP_DD_OM4_LEN_OFFSET			0x6
> +#define QSFP_DD_OM3_LEN_OFFSET			0x7
> +#define QSFP_DD_OM2_LEN_OFFSET			0x8

I see here you have switched from offsets from the beginning of flat linear
memory to offsets within the upper half page.  I recommend actually using
the values in the spec, which are offset from the base of the page.  I know
the first 128 bytes are just copies of page 0, and aren't being used.  But
the specs all describe these register offsets in the range 128-255.  This is
also the actual values the driver is sending to the device.  There is
actually no good reason to redefine these values as if they were offsets
from 128.

Thus, QSFP_DD_SMF_LEN_OFFSET should be 0x84, just like the spec says, and
just like the offset the driver would send to the module to get this byte.
It will be MUCH easier to compare hundreds of hard coded values to the spec
if you aren't mentally translating them every time they are copied or
reviewed.

Don


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C35349F50A
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347197AbiA1IVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:21:10 -0500
Received: from mail-eopbgr140088.outbound.protection.outlook.com ([40.107.14.88]:8009
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232172AbiA1IVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 03:21:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e0M1zc2lzSGs0HxkBgInIc0jeTk6fX6Jf3rqb818Eaz8P4hZvpolWSufBqeM34iBOFZPCEA+BMy6xDudrvW/zj/xHP5P6P+h8Y3W9vFxJcwSRLhpXKyk/yzNk/ibID7dYe/6ldkfA2qEaqxXzMovFY9O+1ZWWSILlhkDfHtIr6FTC7zDf8feO1Nl83nM2XuntpF5jwt5g6X1u22zXOv1OmHkIwmeOhSyL19dDgUfGglV1By/qLMl1K1Yg3Cn1c0RlIYshZTgVEsvJwHQnALvyrSvEiv7y5Ot/RraPdd64PbeMRHDPO2XFBloNzF53cWAIiTly41uZtuQ8uhPe64fqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=myUa6KS+fvfl2KHfPBqPIVd0c3OdeJQfo6SGTIsPJhs=;
 b=ES4iNIMvHXypi6Lter8YQLpacnAlxX/2UbqRgD3n57JHxWRWkHs4m0Og6OcwaTagezVwf6R788PSDhXPIv1U9MZh3qGM5e2LMkqwximkPQPddnth88ydEUnN5sH3jc1AExg3JkqYx98uONbojJM9i5ez76OEyiPpzXba9jZdPjE0719/i/Yg+hSPaouJAo18jC1iplshXa5qqAPoc7wmDqZjLvEqQSRLxud0lm+VeYMQB8KqDMPzTN0AkorV23BrFd0GDPRsj+EHD5IW3VZ922hl5GLuGmhM2xRWYAjJqaHkUqpXvRgkPHRkQ802vdDj2e4DkBnSC0FDrG4j4BEMtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=myUa6KS+fvfl2KHfPBqPIVd0c3OdeJQfo6SGTIsPJhs=;
 b=ou7shNotEzRXSnBDecg0pRD7dOexpQtVhP++qoHWbLeczTIPsBSESuzTlIove1BgbMeuShGD6oc3k6W4hAp/zwNFtku6iPyLJtFP9VJrHhkvfMxD9aTjKqTQ9Pgspx8VU3TIHbrCxayQytb/FNX0anADrEmgT0nYItd/FhMAvESHnikSsqRKej8rot/iCIsQjltH4svs4CdUkFLLLt2kHFPFof/eS952SszPx1g/ouegKADHWH9w+NzFYSgbuYTRgGy/QIZLfE74UnxAZ66I3mg4owWfzEOOIQbLdFBaoGueDBFQZXrewW/QmVKsxI07btdk3CGVnBlADK1BEe6soQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:155::20)
 by VI1PR1001MB1214.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:800:64::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Fri, 28 Jan
 2022 08:21:06 +0000
Received: from AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0]) by AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::95cb:ffb4:beca:fac0%3]) with mapi id 15.20.4930.019; Fri, 28 Jan 2022
 08:21:06 +0000
Date:   Fri, 28 Jan 2022 09:21:03 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
Cc:     Mario.Limonciello@amd.com, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: Re: [PATCH v3] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Message-ID: <20220128092103.1fa2a661@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220128043207.14599-1-aaron.ma@canonical.com>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
        <20220128043207.14599-1-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0023.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::28) To AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:155::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c40d29b5-07e3-482d-445b-08d9e237213b
X-MS-TrafficTypeDiagnostic: VI1PR1001MB1214:EE_
X-Microsoft-Antispam-PRVS: <VI1PR1001MB12140D3C50CC7B4AC03A718D85229@VI1PR1001MB1214.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tzmIGljSjScRkg7TieCkIrAQCMQbF9Gc68sbUKqH8oPS+pGyPWRUGN5N5UJHbtv4C/D7cXTYhiTGT+ToERghACvYcPIxRp2hr/bYdHcDUD2SbP55pRXwI8zGPpDYz3bQde/noNKGkuvvji/hlcY2WBAN59Nzy2suzvfmzIXIfeb25o6+gSt5n2n5ygvIKN/M7wxICH8FqDmCGB/DlOS4ZDVxmDSmgE1gn56i3gSOqgx8JvCsJ1QIAN1vCV/lWSiB8MbfymeVjO4c49/eM031KJoLRTbIqGTsNXHjmcfUiaoWiUtQedbxQX7pQ2EL83gOYOzIHljZOV8+A8+iIXDYmFn3uqmh9dM6nT6FsP9ZpczobzUA79VidhdjXBvDSP4T2F2OwiDzen17PfGFnWvD/iLSK1snGU0KVha/jV5AkBpp7xXgtokdUZT0U9PDKkRNsrrgueqEdxiCNvMNi5UO8jkdZ1z262Bd3BEOJC7KByiLajK3fXUSM/KGkgGuLY/gsCKny/t3tcAHJXb0Qq4Gqa0GlIoKbgBYct+/qgluJEiuQ84hukY0afEt6ahCm+Z4IGMmLPyDhNhSzdmMzqX3xxEECRoaYR0/z+abd/Lt87TBu0o1dACVnv6smFRm7W/C7npPUGIYsptWHO01IaIfqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(8936002)(1076003)(2906002)(83380400001)(82960400001)(316002)(7416002)(508600001)(8676002)(6506007)(4326008)(186003)(6486002)(5660300002)(66946007)(66476007)(66556008)(6666004)(86362001)(6512007)(44832011)(6916009)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ng/H61NBfilsfl+Rw/TBeh9XG2mnvdTtY5D/yr7WQKeuap2XqkjEuQDDtgeM?=
 =?us-ascii?Q?OcmvOyD+iymRwsv3zE17yrjEmtFAMgE7bdHbf96UX4fnzggoSwiSjvTy3JQN?=
 =?us-ascii?Q?3yQ9UswTNBPmj4eHiBEqx8fTQ3e33WM+SbUp6kPoMEeyVJlvnfMk+Z4c/r7r?=
 =?us-ascii?Q?LGwIG8mTiOCIw1zTxi+RJWmEkWGRXCDKXo6WI0PblCBx/O5fonD3nYnzZc6p?=
 =?us-ascii?Q?/WwSqTzm9bcsG0cr3GbXp7/WXXvHqc6JNLdsPF1XQcKSNhD5pz6Gv/8EIxhr?=
 =?us-ascii?Q?eu9UER1hPMpCUV3ZAU80d42tyg6YiPhs2O8iWi9gIbYt1o6/eCR+pBPuOrTF?=
 =?us-ascii?Q?XTPdLo7RlCJ/VMIzI4kckmfYbTPBB567Yd97MG0L2704DThunCEO35hqxQOh?=
 =?us-ascii?Q?wPnLlXZFZYH5IpfUDF40tgkyQj0qnmAPWndJIpcaZDKmhK8R1nqclZu5p3fy?=
 =?us-ascii?Q?zG4NeshDiNogVwtePglxv7wBTu33c5WFLxEBgHXDq6/5hftXFmb72AouCYYR?=
 =?us-ascii?Q?Ax718iauKGfOzNd7gEqwu5DPfctpi9Y7v4vnIfEBbhkeiieVhYiIGXQ9aIOQ?=
 =?us-ascii?Q?eYRwQcqJ3nfthjzL2CFoUtMTMzIYFRf0K9MfxlzTEAJG/s4tUqf0Q3hmBeXx?=
 =?us-ascii?Q?XrrWhJkSNCf1dChlEp2MFf85hTQUClpSoiZXHqAnwMsezwbpsVFeXUJQl75T?=
 =?us-ascii?Q?WJR3ejMCy6o8DFGLMXXw0W9z2UQWBQK4BXr6PfJcz8JTTk6P8+0qFDC93Tan?=
 =?us-ascii?Q?IE96+ryx8a/lRj/Nq4A2SA2xF7CUALSaE1ROcXKsY81ukcrBmYD/9YD5iIgN?=
 =?us-ascii?Q?RLvMaWLRKvpAOHAsnrJDkfbGQlPMFbwvMHe9efLM6cR0/xWQ8AWGu1a/ncXT?=
 =?us-ascii?Q?+Ebm26+dGu9hVkHvdVK5ejRmR1R19eopgSSaQLUk2M3XwO/5SngV71o3EuFs?=
 =?us-ascii?Q?MNAq9x255vpqLAvk9ZWJdC2ODvX1RCx5D/Iyhf31jhLS5MGvOKwpMRAaVSoR?=
 =?us-ascii?Q?xuGsOhhCYGfhuMvDvrFW3+NB37ypirWGxy6+hXa7f0G4+bvO+9zwfEhGBYtc?=
 =?us-ascii?Q?rlKItKC6CYUqIlzbRn4pnfm5ZCIv7sjyoIFvqI373wOvMHCWeQ0n3w8HJFc4?=
 =?us-ascii?Q?8fVEoBW3EZuwf0j+2LeZBxZfvMYXktBQfaGsoXYHZyyYfNdxXuzVLl3oQPFc?=
 =?us-ascii?Q?2Hw22jSz5g1y1z64oJoA5OQd+uMgZdWYva+EXD2jsoWAbiUPjvWromua2YS2?=
 =?us-ascii?Q?gvERaWKfaZVz4+z3enN6vj705BK1PKlcTwlsEcwy6GQHWYzLfZe4ESGp/gly?=
 =?us-ascii?Q?kQQuJV93HWsV30AT3ehXKvSiOusXHGy4kwgA2jSWzTlaEdF4cz0gL/ZPsoFR?=
 =?us-ascii?Q?5DCu7OQy/OTKHMtrLl/S2Z5XlH+zs2lI+v1BZIu6isBJ+f5Wm7Wl2GRlQQHQ?=
 =?us-ascii?Q?KmWK8WqIJg68aqnOZYFcqiaU8OGKQHS5/M5YeBh2cMyjvUnTlQNNsJHevn39?=
 =?us-ascii?Q?rEKml7iqV1ss71imSEZHbYg3Sd38S/DsuVRvtyDjtUf+53hNDKHjwV+g2Og5?=
 =?us-ascii?Q?nIxGYfVYXMVIoF3nrF/K5luO+Ockyz0Oi0fuN5LpWOVf1Bm2wpIM7N8ORDMF?=
 =?us-ascii?Q?4+fKLDfml2BPRGAP+8DJGj1+5Cb7suoYHYJyiK0iuGIvdileguJChXBeQxiL?=
 =?us-ascii?Q?ev9iA1wnCTs+Eu5BN/3ZWX0lEk2x6IL9zA+sFb7tjXEQKAaIJ1jO7OhZR7Ii?=
 =?us-ascii?Q?855+Vp128Q=3D=3D?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40d29b5-07e3-482d-445b-08d9e237213b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB3459.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 08:21:05.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPyi86RVTIT5Kk+5D1OodXY0+7iMZVhyipl/dYUEFtlotwjsOSirOJxNLyg0Bsij/eM7F1/equ1kngTuhL9jsbWnmCxlwfDSG1AUa4kWxpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR1001MB1214
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am still very much against any patches in that direction. The feature
as the vendors envision it does not seem to be really understood or
even explained.
Just narrowing down the device matching caters for vendor lock-in and
confusion when that pass through is happening and when not. And seems
to lead to unmaintainable spaghetti-code. 
People that use this very dock today will see an unexpected mac-change
once they update to a kernel with this patch applied.

But given that some people seem to want that feature in the kernel, i
will stop here and simply disable the feature in the bios. And i will
make sure _not_ get any lenovo gear for my lenovo laptop, not sure that
matches the vendor-vision.

Henning

Am Fri, 28 Jan 2022 12:32:07 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> RTL8153-BL is used in Lenovo Thunderbolt4 dock.
> Add the support of MAC passthrough.
> This is ported from Realtek Outbox driver r8152.53.56-2.15.0.
> 
> There are 2 kinds of rules for MAC passthrough of Lenovo products,
> 1st USB vendor ID belongs to Lenovo, 2nd the chip of RTL8153-BL
> is dedicated for Lenovo. Check flag and the ocp data first,
> then set ACPI object names.
> 
> Suggested-by: Hayes Wang <hayeswang@realtek.com>
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
> v1 -> v2: fix whitespace in definition.
> v2 -> v3: check flag of vendor/product ID to avoid it return error
>  drivers/net/usb/r8152.c | 45
> +++++++++++++++++++++++------------------ 1 file changed, 25
> insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index ee41088c5251..d8350d229f5c 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -718,6 +718,7 @@ enum spd_duplex {
>  #define AD_MASK			0xfee0
>  #define BND_MASK		0x0004
>  #define BD_MASK			0x0001
> +#define BL_MASK			BIT(3)
>  #define EFUSE			0xcfdb
>  #define PASS_THRU_MASK		0x1
>  
> @@ -1606,31 +1607,35 @@ static int
> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
> acpi_object_type mac_obj_type; int mac_strlen;
>  
> +	/* test for -AD variant of RTL8153 */
> +	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
> +	if ((ocp_data & AD_MASK) == 0x1000) {
> +		/* test for MAC address pass-through bit */
> +		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
> +		if ((ocp_data & PASS_THRU_MASK) != 1) {
> +			netif_dbg(tp, probe, tp->netdev,
> +					"No efuse for RTL8153-AD MAC
> pass through\n");
> +			return -ENODEV;
> +		}
> +	} else {
> +		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB,
> USB_MISC_1);
> +		if (tp->lenovo_macpassthru ||
> +				(tp->version == RTL_VER_09 &&
> (ocp_data & BL_MASK))) {
> +			/* test for Lenovo vender/product ID or
> RTL8153BL */
> +			tp->lenovo_macpassthru = 1;
> +		} else if ((ocp_data & BND_MASK) == 0 && (ocp_data &
> BD_MASK) == 0) {
> +			/* test for RTL8153-BND and RTL8153-BD */
> +			netif_dbg(tp, probe, tp->netdev,
> +					"Invalid variant for MAC
> pass through\n");
> +			return -ENODEV;
> +		}
> +	}
> +
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
>  		mac_obj_type = ACPI_TYPE_STRING;
>  		mac_strlen = 0x16;
>  	} else {
> -		/* test for -AD variant of RTL8153 */
> -		ocp_data = ocp_read_word(tp, MCU_TYPE_USB,
> USB_MISC_0);
> -		if ((ocp_data & AD_MASK) == 0x1000) {
> -			/* test for MAC address pass-through bit */
> -			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB,
> EFUSE);
> -			if ((ocp_data & PASS_THRU_MASK) != 1) {
> -				netif_dbg(tp, probe, tp->netdev,
> -						"No efuse for
> RTL8153-AD MAC pass through\n");
> -				return -ENODEV;
> -			}
> -		} else {
> -			/* test for RTL8153-BND and RTL8153-BD */
> -			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB,
> USB_MISC_1);
> -			if ((ocp_data & BND_MASK) == 0 && (ocp_data
> & BD_MASK) == 0) {
> -				netif_dbg(tp, probe, tp->netdev,
> -						"Invalid variant for
> MAC pass through\n");
> -				return -ENODEV;
> -			}
> -		}
> -
>  		mac_obj_name = "\\_SB.AMAC";
>  		mac_obj_type = ACPI_TYPE_BUFFER;
>  		mac_strlen = 0x17;


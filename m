Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AE49C520
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiAZIUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:20:15 -0500
Received: from mail-dm6nam12on2087.outbound.protection.outlook.com ([40.107.243.87]:54624
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238316AbiAZIUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 03:20:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ7aK1rSFJg2EA0mUjzx+U3TMKCGzonNkoSccroVCgXG/iV/g31MfWT/+9tJORCmJo2uR/QK1o85EWuBZewE+qZ2NIiLHhb/v3eDMZYGXP71+SanpP/FV/mf5GjIgP0frPgwyRBt0yW09uIEF+pCHBgvmuZTIhrrO9jJxvnfJVxzV0CjrzjdM0H6WILlfX/jIvLWMIB2PivsyYygRlWApQp106p04A3rWDhIejrhtY30MhTRjbQSZugEeYHbLY4LzP/dK8ozN2IdjNxCaRHtbQePV5H9qKq3eDkhnCAz4wc7hHPVoIWmABH/O2WbnaKHu1iv404XNMGFhiIgcZ+qoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPnABG6rAc8rXvROwJ1CgCwusE//Cf5Cqp2dTrXJuxY=;
 b=gCVcAmIuj7oPPk8CnDoJ5OQxfid6yPzIroZn7yfgYRzfFO7FpwoTY0XxinisMBiXTrgAJqA8pJjCNIfPA4vPTfyYq5m3IrM44SAwrNRKYl9n+7tE4dCIw8MSIRAPW19i0OPt5tjE0TQ612AX3Vra3ezzBby1ntBov+VltXpcXxYsRJDINqhrtLLtOSQuZ0NUO7edrxtLcp41qbyNoK2U1/eFaaJQiJa0bxipySf6A+lWdyBqmWpdxmwLBKKkyzn8MnWfkeHVSSKYELdk4xR7DqngA5BaEQ90cVt/A3UAEJ+Fd+QuCbRNYQVYbNLTT7PJq7nC3oT6wgeiLITXEp9u0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPnABG6rAc8rXvROwJ1CgCwusE//Cf5Cqp2dTrXJuxY=;
 b=nUm1P7BmOsj83DMtxPd1c7WJ/+02CM/yxtEkTUyEPgPuy/USoMPyjZqCYub1kXEjQHCM5906zlJCxOO3QZ45Ip817t48Ir0vAApTPfomYNruhCcLdnG8A5Vf8pUngqqgDhMsoHBFC5tsry5dyiEPmR2chZgiLnkkcC2bXEhdDWs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 08:20:11 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::2025:8f0a:6ccc:2bfb]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::2025:8f0a:6ccc:2bfb%4]) with mapi id 15.20.4930.017; Wed, 26 Jan 2022
 08:20:11 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
Date:   Wed, 26 Jan 2022 09:20:05 +0100
Message-ID: <2898137.rlL8Y2EFai@pc-42>
Organization: Silicon Labs
In-Reply-To: <20220111171424.862764-6-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-6-Jerome.Pouiller@silabs.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: SN1PR12CA0048.namprd12.prod.outlook.com
 (2603:10b6:802:20::19) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 578762b5-a4be-44f1-1613-08d9e0a4ab62
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_
X-Microsoft-Antispam-PRVS: <MW3PR11MB4538E8F9008DE5DF971C100A93209@MW3PR11MB4538.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XDyZ3BSIf1LQBUhR4EmlG2WmjkxcgWbx5LshK7A8xFmG+PuOvtUQL90GE+0QAD8Q6n3EEBhKob/y7W4A9vrnh0ZEfii9g7qjSrL3i7oOpAsz2lrioSvgC7561M2vkxUB4G5AfQ5ChavvPfpwvTUne7g3SdASbEoYDpgurHgDDEtnxX59tP6ErE/kQ88qX2qkILVhJR+Zl4zRdE+WAdqaaVnX3oaKEN4oyRQy4pdMOBTCTpt9RaL+sTPbUZBGxRP3tTcfX5qFd5a1pcY2zCCVZjWl/f4b3CvdT075UhLV4NDoetcFX1s3prsUyQxuxA9UC4CFNExIf2COFgKXDQ2rTMTT+fwagtV1EMh3JE1OAld4DrNhoSDWnHLlBf44Kb0hykGuaThO9Os3RZixARToVSFezZSTNeNXm4Y0RO0M93Sh5llmiHcrP3EOx+xjjngRyYipqyOm66ptDhxsgf6s3IP8PSMZRP1x43eezQur+BVABDjepV5CuGSY2x3Yjgw5cH9CzsoSfNh1S1pQJlIemjNeHN2NKKaTOfeFoO7IU4+L2Q2KCuNZNuU/OsQbXhrshWTT0Vq4GHlP7u9B4PtkAqtRgBGHW6G6+0f2DYLHTM7+fX8hZ+5NhpbzH/FO9p1qsucVE/T2+RoDUi/dtdotH3rrviPkiIfq4AsOw1jN2EE2RrNwn925igpYTsAqJVZd4SjNj/HhKk+eNum8g/iezlYpfTl1FFKtF5Hl7T4PKfKZ0K7qVkbez2CN8WafONUZfi37RWoMyvMSxEJ1PXrfzCEGQvSOKX394c4PTw/3qBg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66574015)(6916009)(316002)(33716001)(54906003)(186003)(2906002)(38100700002)(8936002)(8676002)(86362001)(6486002)(66946007)(4326008)(6512007)(6666004)(6506007)(7416002)(36916002)(5660300002)(9686003)(66556008)(66476007)(84970400001)(52116002)(508600001)(39026012)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Dp8JjTq1aZgvPS3hTIbUt44TMQeBBNG7P899yQfaZIWLitegUpfoEAYLwD?=
 =?iso-8859-1?Q?yACOJehuYy1TNstc23a9VbtTdHibnjr7ogWPUchrqzBPLeUgBzlulKdKt5?=
 =?iso-8859-1?Q?SC2MumhgnjNRhqM05HGlJle5/shMJRMeNlyADuUMB6YA2A3g44e2brwo9d?=
 =?iso-8859-1?Q?4Y5P1fY0ppzi1Gpp5HG+BSrtxBY9s40Neer8yLLilGiQ+1OAY9dY3NnehC?=
 =?iso-8859-1?Q?QkwnYNMXGJg6QXhy4pOY7pFWyODlqP7DChS4CSpn++bPnfUzy2BQFyoHpG?=
 =?iso-8859-1?Q?PW9xmK8SqwFS3gUb3FhErSWLugt8BUIdJ8tHaKmWEgbIT+Os7C/8SbIoxW?=
 =?iso-8859-1?Q?K+DeQDAKwZZuMeECikhED/fsf41hmFed7dhQgkMwx7x6rhrerZaGQf3qo1?=
 =?iso-8859-1?Q?utv+Y2hR3lOH0eh7wlWJNs/KfMBhHzXAYKoDtSwoXtvvxWZwpUREwyMkor?=
 =?iso-8859-1?Q?O156TxLTof/aas9uR6qHlybQL0upTA6pDD854VwncVVQamnZu6Cse1RBOk?=
 =?iso-8859-1?Q?dI6tHltjQRoI1YzoA2EGrlyxN6J/LBWYztsf92/aMqGcXsf0uoEQqvCRCu?=
 =?iso-8859-1?Q?GRN20gCkInBonZRY0bFynT5t7oFUgibeakmCwlbTyvKJKm3uwXLIX62oYW?=
 =?iso-8859-1?Q?bECRSgrEsrUEuYxuWwhnLHHGagEpsGdHDbnylMCbr0UzYJiYDJIWRkNcW1?=
 =?iso-8859-1?Q?fcO7iykAWzZWR33Lr2MkudCsCCq5O9l2r12Gm74CCJhBTLPhycwLKF9MIA?=
 =?iso-8859-1?Q?ndmaLWxFeQbYEwlGM4M0SfuPD7rWnZ7HFtQ8BV8jZFMS6TuTmyZmJy+ynF?=
 =?iso-8859-1?Q?L9ag7x7/aNhyTwaPm9vhDncWiwnH3+xEjtz4D+lDLo4tApDOMQsVDVJ+jM?=
 =?iso-8859-1?Q?7LEenvRyZEb0zh2kxA2O4N5L3AhKwUA6L+IKSoNmc3WLYo3CyKKD7iUrpe?=
 =?iso-8859-1?Q?JiBECurH1KGGaaKBL3CPAmjA2JbAWCAtnxVQSr6P50+eu4lZ7CmXbf/ErU?=
 =?iso-8859-1?Q?atf2kOFJw7Zsn57/txBWCyhsYkQoV2XPOP8JiWXfQYE6mrOAEsmoaAFKca?=
 =?iso-8859-1?Q?Mc9eR2hUvNKwzjLxJoGBSGEQpNj5pibxbLQLQU6KvOLKepJhgEENnbwTQY?=
 =?iso-8859-1?Q?xR1ZvdAfpqfaSBP8AKX48rQPUvBbVJKVPYrs2WLw2O69HGPsCRN1cDLPRi?=
 =?iso-8859-1?Q?c7xlHBKhet7ilLunNZete62SA1YUYetL1SrhYs8gDI/CPHKFyOnsKDuzGu?=
 =?iso-8859-1?Q?vutMCXFgswDa1y0gPlqwEn/DTtsj1jYUgX7tkRFHOqqYhgCEJInKdrVQt/?=
 =?iso-8859-1?Q?2c/C0cKK2PsUoZ4Q0HcE93+qC6VSK9L1PxIlmccg5G0qRmTowRGet8/q5Y?=
 =?iso-8859-1?Q?sipQPuuO98V1Q9lLU4HCBsmnkUa1H6ih8z/s1IqtcUz+3gkgHBPGIKx/E5?=
 =?iso-8859-1?Q?3gG6B3Oc4rMilUl6+Odjht9NE8peuYf4YYVzn23cIsewXgiqtwzYNxf1a0?=
 =?iso-8859-1?Q?lavBUjQQndaisv+CPjNhV65YeprEmJh1+Jic8Nfd3F9tFoTCvBwmLL94Fl?=
 =?iso-8859-1?Q?po3pCOAlOvvP1zXEFEQSa4vd3hFMeMItDqip8SWSyvWzVbEkBm00fzJ81l?=
 =?iso-8859-1?Q?OYwg+kxsbSGJ4PSW0RtYC7k1pC7EYd0TD56byVN2SmZy1gLmSHzpccFssV?=
 =?iso-8859-1?Q?RbWp3QxK9ysRKNaAeMQ6E1TYauS/2W06QAKhCPxUeZ9f08cQuUx+d3GknH?=
 =?iso-8859-1?Q?AfjefNYM7bfmvjzejny11+sjw=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 578762b5-a4be-44f1-1613-08d9e0a4ab62
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 08:20:11.0006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxaLm+M1LxoXShTL21RS9Nr2sor45DxuXaGpe+91bMNGa8CyZcBjRB+f8wNb1Ovmpd+S8hOsSe/9lGe+aMdpgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Tuesday 11 January 2022 18:14:05 CET Jerome Pouiller wrote:
> From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
>=20
> Signed-off-by: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/net/wireless/silabs/wfx/main.c | 485 +++++++++++++++++++++++++
>  drivers/net/wireless/silabs/wfx/main.h |  42 +++
>  2 files changed, 527 insertions(+)
>  create mode 100644 drivers/net/wireless/silabs/wfx/main.c
>  create mode 100644 drivers/net/wireless/silabs/wfx/main.h
>=20
[...]
> +/* The device needs data about the antenna configuration. This informati=
on in
> + * provided by PDS (Platform Data Set, this is the wording used in WF200
> + * documentation) files. For hardware integrators, the full process to c=
reate
> + * PDS files is described here:
> + *   https:github.com/SiliconLabs/wfx-firmware/blob/master/PDS/README.md
> + *
> + * The PDS file is an array of Time-Length-Value structs.
> + */
> + int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
> +{
> +	int ret, chunk_type, chunk_len, chunk_num =3D 0;
> +
> +	if (*buf =3D=3D '{') {
> +		dev_err(wdev->dev, "PDS: malformed file (legacy format?)\n");
> +		return -EINVAL;
> +	}
> +	while (len > 0) {
> +		chunk_type =3D get_unaligned_le16(buf + 0);
> +		chunk_len =3D get_unaligned_le16(buf + 2);
> +		if (chunk_len > len) {
> +			dev_err(wdev->dev, "PDS:%d: corrupted file\n", chunk_num);
> +			return -EINVAL;
> +		}
> +		if (chunk_type !=3D WFX_PDS_TLV_TYPE) {
> +			dev_info(wdev->dev, "PDS:%d: skip unknown data\n", chunk_num);
> +			goto next;
> +		}
> +		if (chunk_len > WFX_PDS_MAX_CHUNK_SIZE)
> +			dev_warn(wdev->dev, "PDS:%d: unexpectly large chunk\n", chunk_num);
> +		if (buf[4] !=3D '{' || buf[chunk_len - 1] !=3D '}')
> +			dev_warn(wdev->dev, "PDS:%d: unexpected content\n", chunk_num);
> +
> +		ret =3D wfx_hif_configuration(wdev, buf + 4, chunk_len - 4);
> +		if (ret > 0) {
> +			dev_err(wdev->dev, "PDS:%d: invalid data (unsupported options?)\n",
> +				chunk_num);
> +			return -EINVAL;
> +		}
> +		if (ret =3D=3D -ETIMEDOUT) {
> +			dev_err(wdev->dev, "PDS:%d: chip didn't reply (corrupted file?)\n",
> +				chunk_num);
> +			return ret;
> +		}
> +		if (ret) {
> +			dev_err(wdev->dev, "PDS:%d: chip returned an unknown error\n", chunk_=
num);
> +			return -EIO;
> +		}
> +next:
> +		chunk_num++;
> +		len -=3D chunk_len;
> +		buf +=3D chunk_len;
> +	}
> +	return 0;
> +}

Kalle, is this function what you expected? If it is right for you, I am
going to send it to the staging tree.


--=20
J=E9r=F4me Pouiller



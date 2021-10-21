Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E2E435E60
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbhJUJ5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:57:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:55839 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231334AbhJUJ5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 05:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1634810106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2LpkHj0mN06+Aq9r40n8DawLz3pJJKf+u3kHKfJ05p0=;
        b=jkJDwUaQakADsuTOaYjU75dN2aamEUiEhJFCfHJvnY5ognBGyDJ5loe2RMX79RbPVtiopp
        5pFWdXDxAWnhtzFvZSCMuDQ2cPjv5PQ6AI5VmMEOAdu8h4/buAI6L4x9easJ3MKRxovp0g
        g3k5oguoTDZPxTlY52WSyEVNUcV3AWw=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2056.outbound.protection.outlook.com [104.47.6.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-U74NcIs_Mr2B0y7sFHMq2w-1; Thu, 21 Oct 2021 11:55:05 +0200
X-MC-Unique: U74NcIs_Mr2B0y7sFHMq2w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFv0oolc1/+pMk2gh/BOPd03CzjVNsTCt7zk2K0SQP4lt4S2SgYE+MNt1ABmw8TskqqeK9dN8MQNoWD+nTB7cfs64lrdDFttqMI3VitbiLRl5XGSIdeyjWQ6nldCubpScASLXqs+I1Pjp8TLvo5UP/G9x5BW25yBCBb06QMT8jBQcpIy7QoXrSkVZFh02i/DoKY6KSJJHNbtPT0JR0XSo7OtGf79cBeF9zw3vLdDMQnadW8qNPvMErzVGgaM/jidsTBH9Ji0mwnV4JRDlVb7EShv9N/Lfr9gBJEN6K9FuE7HNYgBsmwEgAhxvnXV9QuvIjUwJGzoiNCHP3g+d0b+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=357mJdmhYJGo63ERW5gFxzcfUBLU+WyqEi7xnD3ejKo=;
 b=O3u27szJYBUfvmqQABdFtdTrasaS87MJnayvYs76qJYbWwlfadMThCGciYZJDgZEYgaafuGi6oZrPvdcNQ+V3e1z+xfkoQk+32Wvz2fijtjCNxugQZ+MV9PR9J2VHJ8cot/mcMTIVdBBQvMo7mSiXLYoFoohe3HmemMpOdxhs7qcm2ov9FbTrq4Tm/8lRXoRAcDOzMsDnDG11XKV0tb5CjQIuvOd8W7ZrtzHGhcaaAXl4lGYCiMQX7OkawspDuvR+TIOJNiKHSVCGle3vTn3B0RNSk/2dkAsC7Hot4kJf2DjEINUV+cK62Z5kb76njLMXB+97nMdI1PSYKy4/Lm2Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Thu, 21 Oct
 2021 09:55:02 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 09:55:02 +0000
Subject: Re: [PATCH net-next 04/12] net: usb: don't write directly to
 netdev->dev_addr
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
CC:     netdev@vger.kernel.org, oneukum@suse.com, linux-usb@vger.kernel.org
References: <20211020155617.1721694-1-kuba@kernel.org>
 <20211020155617.1721694-5-kuba@kernel.org>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <be00cea5-3074-5a27-3e04-97c08ae60fd8@suse.com>
Date:   Thu, 21 Oct 2021 11:55:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211020155617.1721694-5-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6P192CA0024.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::37) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6P192CA0024.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Thu, 21 Oct 2021 09:55:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5cfd3b91-fe9c-4859-8da7-08d99478d9f6
X-MS-TrafficTypeDiagnostic: DB7PR04MB5177:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB7PR04MB5177B7E8EE72E9929AEE178DC7BF9@DB7PR04MB5177.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1JZckdZFaNvZOJZW6Da5GQmPtC8Zof+ppca9WZAhjLuIXS+NGqm/3QpPVD/v2QwP98BIihsAsaZs2njBVXTQsrdfT7pA7jmImrThkPe7bLnEIco+UlGW72tad7Urd7u8wn2vGxpzdWVzl1nwZgxN6gdZJX15IFEESlHVLqshPahkQjQXkXX/pBDIU9i1QIIiohZtzd/tsLG6YbRetH2BXT070p3UMp7WiDcm6p6szDg1sMt7HzejXXfv7fmOvADnTfUu9Ivn3DNEsCAJ566qL3nUDDtSLmc+zoWPp1CFnMmf+EE4tpaVUU3GNzr8SxUQSfd12mBm/QPSOSBgd39p+PTiTF/IHKSQSGU3qe5rwTb064s21dPkJNY7JwotBfYOi/uIX/IdqEneAjFn40B0DFpnH7SWnf9MQE4hElyoYEn1HOxJyVcQt2ierdQkhpTu+FgGeewaRQZ5/CYOWWUk/e61h9NAlfxX+OFx5xa7IrOUtYtan/PHJk1UUC756mkm/PK9mOT/By7MQocPOaTGUjbuqXzeD8KdRMxghJ/TshlHc0oBq81jIDrrSEoNF4/sEzmFu94dPCFD8qkoubzUzEtUxGeEAkpg3aiUKucv6kGGHWqfwMcVBtwyk3R7xalLWmhDw7K8UdRuX/a+czg5Ravb0A+u1f43sUDiY514VDRDTg64cfxLqgT3VIGUAF4s9zetPgLPclydNuP7Z98HeauUE4FEekoyOZMUACduKW4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(316002)(6512007)(2616005)(4326008)(66946007)(38100700002)(508600001)(5660300002)(8936002)(86362001)(2906002)(6486002)(186003)(36756003)(66556008)(31696002)(66476007)(31686004)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ivvgpAnpi0Rq/P5olND6raqmWzeHxlhX+gZotugf6od4DOmD/Who5rOYkB+V?=
 =?us-ascii?Q?P5uNm9P1lhhZEP8m54T9Q9uS63qnMwjp3e7snh+uh958n3b6JslXwnJ7+Iqb?=
 =?us-ascii?Q?QeqTMlnlYlwPIAOHuuO+X8KK/d/Agcp/fdPhjU/XcPFhdGeH4Jxr1p5Id1H6?=
 =?us-ascii?Q?d//14L4fcvmCjj3rVHCYN+BLRDPtnWlzq3XAWDyDTkJDKWgS1gLdUi35oMWg?=
 =?us-ascii?Q?MjqDsMM8TRuW8TvdlPAQoo3LzTdTz8OC5k4YCRX13JRXN2u15sACl4rMkFQN?=
 =?us-ascii?Q?AdSBxCl59S3cp+QCc6DJvNCyNXM4qT+PCyHrquK121QfxuyJY7l7mJHc7QTC?=
 =?us-ascii?Q?06uIh2mhJhAiBHPRtGOwSsSnhPQLtpfKfLjntazJ4iqLySmw2St4wmS5ZLjo?=
 =?us-ascii?Q?2qgKkTa2PT1pLRivIFtCQe5zOYqnYLPk6RTHCbznj8owT71Wj9F+sDh68YsM?=
 =?us-ascii?Q?RNADnBOSnq255l3JOoJjejlpiU2MAqFVUq/DFcJD5j4LphJ5fIUMwFY31iAh?=
 =?us-ascii?Q?kn1Vi843D+3IHXJBHwheG3IosOsUSM2XzjrcwML9CfCPC4seHFOv5e/fYCWK?=
 =?us-ascii?Q?EXYxVhXFUEKx00bBQIASjwg4Jfy2W4NoFGzbbmkSKxJIqJK219mlOtf4dw4B?=
 =?us-ascii?Q?gwc1gvxNhA022ela6dhlPOdwimsY/sU9RlI2CgctTIrEfz3erZ2YckKRZtsC?=
 =?us-ascii?Q?bUh3H+eMCVmfFlmH7LMKX/XAHi44Os46Lpi/kxoHEkZWnK5aOXpqLTkTOKVn?=
 =?us-ascii?Q?0aEX5z6d0vVyWKBrTjK6Jyjm5sp5eyXztRxNHCTItnEMZOarjRw+ryj5qT3p?=
 =?us-ascii?Q?GC/hcZWl4V2SGf79M8t0jvwpe10zihiFIIFviKV+NAucc2YkDNPMDsgCXm5r?=
 =?us-ascii?Q?N2tthdnuwqZ9XSjdSlin5e1VIvTRiFBBQuQ7tMzs89e9jWA7y6oRuYq8z8U8?=
 =?us-ascii?Q?9FTM7ZsNAFnJJGsON9w1fWvrbiBFRcmczaAMEezhkc3TTXdtIFD9KmHsF7mp?=
 =?us-ascii?Q?KHwNBN0njOKBkUxSrRsDbSQFGDO/CIsQeOA8sc0suOfRWGzBHNwF55AaOTdN?=
 =?us-ascii?Q?iYEc5mYTXZh4fCnw9aVanDby3nP/ns1jKysggDlMrfzQtjw6Ty3+FtlrHFr1?=
 =?us-ascii?Q?9Ewthhnm79J6C0v+JUwcLPMROZLSTRj+njvGXOqMjUN8h5k0SfCZzdABZKWM?=
 =?us-ascii?Q?AcIftp3CuSRejYDR5M1BzxSaMIjfo1lpz/foVV8O1pIANbmyYfdxZW4ZPezc?=
 =?us-ascii?Q?vjpsxqhAutsEqJTDrcJM+YOT85M4JPY/BZkMbG6Jb9drkhiLFB3dGCCEfD2G?=
 =?us-ascii?Q?nv08kuAFdbeoL2akY/cAV/sxcxO4ksywrlUM7xgIFH+lQiQuEWRYNjQyuCTo?=
 =?us-ascii?Q?COGgHZZscbTDAY5RhwVDlNqQkmBc4wI+Y07tYygCNO2UJuyRHR5MXUU1QXZW?=
 =?us-ascii?Q?xE3rHtlfj1lDXGq2cXWQq/Zvu10taUfaL5R9UimZQB1/oQb++L08l2ekoLpJ?=
 =?us-ascii?Q?EdnchcP/Iul8FLE=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfd3b91-fe9c-4859-8da7-08d99478d9f6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 09:55:02.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oneukum@suse.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5177
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20.10.21 17:56, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
>
> Manually fix all net/usb drivers without separate maintainers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Hi,


this looks good except for catc, which needs a more complicated fix.
Do you want me to do it and drop it from this patch?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

> --- a/drivers/net/usb/catc.c
> +++ b/drivers/net/usb/catc.c
> @@ -770,6 +770,7 @@ static int catc_probe(struct usb_interface *intf, con=
st struct usb_device_id *id
>  	struct net_device *netdev;
>  	struct catc *catc;
>  	u8 broadcast[ETH_ALEN];
> +	u8 addr[ETH_ALEN];
>  	int pktsz, ret;
> =20
>  	if (usb_set_interface(usbdev,
> @@ -870,7 +871,8 @@ static int catc_probe(struct usb_interface *intf, con=
st struct usb_device_id *id
>  	 =20
>  		dev_dbg(dev, "Getting MAC from SEEROM.\n");
>  	 =20
> -		catc_get_mac(catc, netdev->dev_addr);
> +		catc_get_mac(catc, addr);
DMA on the stack.
> +		eth_hw_addr_set(netdev, addr);
>  	=09
>  		dev_dbg(dev, "Setting MAC into registers.\n");
>  	 =20
> @@ -899,8 +901,9 @@ static int catc_probe(struct usb_interface *intf, con=
st struct usb_device_id *id
>  	} else {
>  		dev_dbg(dev, "Performing reset\n");
>  		catc_reset(catc);
> -		catc_get_mac(catc, netdev->dev_addr);
> -	=09
> +		catc_get_mac(catc, addr);
DMA on the stack.
> +		eth_hw_addr_set(netdev, addr);
> +
>  		dev_dbg(dev, "Setting RX Mode\n");
>  		catc->rxmode[0] =3D RxEnable | RxPolarity | RxMultiCast;
>  		catc->rxmode[1] =3D 0;
>
>


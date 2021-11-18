Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9600F456462
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 21:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhKRUlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 15:41:11 -0500
Received: from mail-eopbgr140055.outbound.protection.outlook.com ([40.107.14.55]:5284
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231732AbhKRUlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 15:41:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hamEY9lzpA4t5U5zk5KBe6YuDUCcI/R5zKra9ONzC1xkVC5+Eq3SQbF77+fJSja8319G7IPB6yL+hewuEAUSs3e65DxTDzHl286iHz8dvDgEv05hP6r+VV+vrglbUKrGzmenQ/4NzZF9Sw1mqJ69LV3jrJM55yBQsQ6gr/IlQ+LsQFDzJQieFlyNgiKW6hTkxVb1gMoVCJwRdnsvSomUGsZ5fqhNfUIYq32ZHrCcVsw2Uuok+3U+koxG2TEA8PQJDjfGQ2IQpJKjl0VIJ2ysS3XG7pi7Z1WasyfnYA2kWeR/uACpgpRFckp1QjQtBsEUF2rCXxs2bOYnHPAS22wqCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAn85Hbxa/ItnlQS5KeMIDcRO6cLAETN9KZiD4Ljf4A=;
 b=mMT/R0OT8vKQf7edI3Ifl196TyLu5Z8pN6QDi82SlqqTMiYN7tJcKw+P3nA9NWekEVs1xukOU1rnbGer9AnTuz0b4ZCXVxzcPoKAXXCw8w5jgRdg5/QSJKY8MFuhXg+HxGEdE/vSSOBO48Yb5GKpovW+Vam/TsRLiTp/cAhWflPTXPuV6EouAFUK1/R/jAdYwahyPVJ/hUAoNaGvoHhUOyx37neMyAlV/j4bE13qd3Q3+/apkoKpB4vqGJZx40GYSbDur81yhypb9L8O8+kZCo7qQRWD9ck2kctiokEsJSoftp4aXSXuCp5B6q6wt10tShn5OXpIiWoSnoFl696bOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAn85Hbxa/ItnlQS5KeMIDcRO6cLAETN9KZiD4Ljf4A=;
 b=NrJiCdgVdylc67+OYJPH/+pxIyluIZlHTWnCsp2WcCnQpJfj9vOA0Yj8HYGXcRMznH84hv5vVj6pOtfBvEkpHhyp8TswprNSJZlCKdd9kw4//CakdtAW+0TU3HHsBaezZvDIn1v5N4344goCVkq0f/ze6qbp589aGN8oVUd9nic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB6PR03MB2965.eurprd03.prod.outlook.com (2603:10a6:6:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Thu, 18 Nov
 2021 20:38:07 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 20:38:07 +0000
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-5-kabel@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <9b557a13-080a-853b-e65e-a39b75e1026f@seco.com>
Date:   Thu, 18 Nov 2021 15:38:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20211117225050.18395-5-kabel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR22CA0024.namprd22.prod.outlook.com
 (2603:10b6:208:238::29) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from [172.27.1.65] (50.195.82.171) by MN2PR22CA0024.namprd22.prod.outlook.com (2603:10b6:208:238::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 20:38:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1c86340-7d19-4d1f-fbbe-08d9aad353d2
X-MS-TrafficTypeDiagnostic: DB6PR03MB2965:
X-Microsoft-Antispam-PRVS: <DB6PR03MB2965CECAA9CBD3FAA85FAB83969B9@DB6PR03MB2965.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KCv+r04QXgGiqQPQpWYFPtjU+fQCRAkxXCmWFh1GPKEhqjO/xEgvSmeyt+ZDI3EJIEDc8yFzS5q7kdvjjNbiMjvfpIgStK9offh8vIxs/1yR7F1+yG8gDhlUraKu5FvvED//6SKNhJd7Ge5dyb55qBghbM7gzpWu4E9LPQ7D+Z+iwpo/eriHDH/9n+KmngxPDx3pdpotY/UmiSvJzu1Gwhc/kskNpAHSK6Y5j5+suhnvdDs3RrOfrF9Hy1iQdQGYz9w4yFBfljUsxKny5jzl6frHkWUIAg6Pd9FYLKtaFPKHiGe5XGe9uSqSz72ZxUOEAf6njVC2jC3bE4wDm/hgsZOoxqrHQtc0kRopYWF0UHqpt6SMopdY/oE385GMuxh6jfGGwoZgErMP8/4FFHy4bI6T0/8xmdiHBlkrOc3insh5+FEBxJzYGtYP4h+dzZT+gNdar9N10tgpDwoW9DXEo+mpi2M/PVUw52p6Vk0efN1uiVdmMnTyW4TFvDI8Ei+g4rVxAM4N5nkoP8WY7NezCQCE2Q7McESOjegp+sBBYZwwzYO4URppKQAyzHXXlfRHghjrtYwvD76tX1kTom0CovDYtFP+QW7MuPHmhCAAL43ivQLFSok3aUwWIpBZv/4V4yOHDpDRQUiZrojbTJ4lJ13UxfrD5W7PBEftT/R5b+Z8nagwAb1/SkqcHu5nYJ/erYnC92ksyELi9s2k9k1FGzEb+Mb0lvrIKMOkjt7Cjl+SYvDqoz3tG6fWb5JnOswAX/aJj0xb2F3aCupWjzuxvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(110136005)(83380400001)(86362001)(38350700002)(2616005)(66476007)(956004)(16576012)(31696002)(316002)(66574015)(2906002)(44832011)(508600001)(66946007)(36756003)(66556008)(4326008)(6486002)(38100700002)(5660300002)(186003)(8676002)(26005)(8936002)(15650500001)(31686004)(6666004)(54906003)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V04zd2NJazFjOGtKdUc1OVNMditkdGNMMmVtME5KQjVrVGFRMzdUSGZlVU0z?=
 =?utf-8?B?YXVCTnM4NTdQS3hpQ01YSjRzcDNETEU2RVNCTGhWNGJua2F3UCtJQXRpR2dS?=
 =?utf-8?B?cWdkNldPeFpVQXg1eTRGSTBwQ1JUUThORWEzNm9rY0h5dGxDV0ZiTElQWnZy?=
 =?utf-8?B?Z2ZaNnJwci9PNVBBTXlpbmxmSXhBTUIxamE3aytKRnUvT3dpRmhDZ29CWUNX?=
 =?utf-8?B?NVBRTG13dWUxWDczZGMzdDh5R1dWUGZzNW1rV1lLd3hGRUIrNDVEeWRHUlFn?=
 =?utf-8?B?WWVmK2VUTHVKWkhVRnBhcEx3VFk2LzFjQTRmYmlhTXJ0M3FGUGs1cXRJN0Fm?=
 =?utf-8?B?KzJ5VStpekh4bVFHaVhOWDJGNWhTSG5xdS9uVGdHVjdER3c5UC8wTVBmUUs5?=
 =?utf-8?B?NXZGT0RMUk1TL3hTZWRuRjQwdVUyalhXZTI1b1FhbU5OTEY3WVByL3dSMkpO?=
 =?utf-8?B?cDFiZkhqeXBOcHc0T3BFOTlhVnROOVdCUjVTTVQrWUlwMTF1R3VTUGpuSlI1?=
 =?utf-8?B?dVhPdyt1bGQrTFlmWnFtWnN3VWNLMUZSK2k2YUVTSnFFL0Y1M2Q3Q3hsbm1C?=
 =?utf-8?B?SFNwZVRQRSs0ME9WRFZlWm5oT1pCVWVwRTJzVlAzWDF1WWhMOUdVaEE2VVRl?=
 =?utf-8?B?bFU0L1NRWndKRkRCQ3NVVXlzcmI4OXJOSzdCNmJ3K241akFJOEFWQlVGVml1?=
 =?utf-8?B?YUhxZFdaZ3V2QldOSVR1V3hMZm1vaUZXUUhyVHhjYUNxdWVGekNKTkpBVFNl?=
 =?utf-8?B?WC9aNXpTMG9YanVnUTI1NFVYeUYwaWN1M1VpTTM1THRmQWlzTDVTUS9oVzU2?=
 =?utf-8?B?K0FQcVJZU0hjYzNKVGVkUkhEc2xaNzd1dWtIb3RKcHJsVUtrMHdNaHBPZjY1?=
 =?utf-8?B?OUpaZU1FZkR1THJNYWVsZFNmZzhqNFdQaFczdHhMakxkMkUvNjVxUEQrL1cv?=
 =?utf-8?B?Wm13VGZaSnMyWmppRFh4SHVoZnQrcEJmL0dyZHVtQlN4dnp5dlRITThTeXdZ?=
 =?utf-8?B?MmhzNUtUbERwaUF2WmN6dWhjK25jVkh0U3pzeVZza0IwZFBFMVYvZGhJa0N0?=
 =?utf-8?B?Q3BHYUZCRUFKbzNCaUptdG5iSTJyM3VWWlFjZkNiQkpnWSt3eG95V0RZWUVS?=
 =?utf-8?B?OW1yT21WaWZXLyt6M2RzK2hjWkN1ZFc3R21kYi9wdGRPa0hueG9qYzF0dVVU?=
 =?utf-8?B?UlVZVmtSbmxLbXRuYmx3cTU0cXI1YnZQa0hsSW83VDNLdmtFZys1eXZuN0dT?=
 =?utf-8?B?S3pRUUkxMzhZOUhzSzQ4UTZxKzhZR3RiaUZyZ0ZtdWNlbjFKMHMrRTBONHc0?=
 =?utf-8?B?TnBDZUM2dUEwMEF3c3NJdnpTL3BKSWZlVDNhOU5nSXE0VHZERk9SK0p2Z2pm?=
 =?utf-8?B?RFVnOXF5Y3hUUzFlY3BSZjE1NEZqK2Rjbm5hNTlkVGtpWVFVRzJuS0hkQ0lO?=
 =?utf-8?B?alc1SDdPaC9vUzlyVFVUT1JqaDR4dDRPYVBDQkNWQXhZeUFUL2J1RmZFeGVi?=
 =?utf-8?B?dFdaUGpGRWtHUEtnMUUwWjdEZ2VFdGNoT2JDWEEzUTVFY3ZuU1M4czlZbFpK?=
 =?utf-8?B?L2kvUWJrYzY4SkhxQ3o0Vno2cHJXaVQvMHhSMCtlSC9PTjY0djEzRjFZRHRz?=
 =?utf-8?B?QjI0eTNEdmhKUFdIdWtNc2Y3R1czTEZTVlkvSS9Pb1gvZjMvZ1hiTElmWmRF?=
 =?utf-8?B?VEcwWFVDY3NiRXV3SHkrSXY1R2NySzIxbDBFb2wwbWpRbGkrb1dZUmdHY1hh?=
 =?utf-8?B?S0FVU084N1dzM1ZjTjQ2VUJjRWg5VWc2ZnpvdkhOajNJMlZtNkF4ZStNTXBv?=
 =?utf-8?B?MkoyL1hSQ1dqdUVLQ0xZajRBQVBFMitnbkJXUFBPOGlreU1QR2VCRmJDcklq?=
 =?utf-8?B?d2p1ais0ZTQzMVZ6UTU3UnVmMFpHbUJtbnlVS0FiMUREbmszc3NzQ0pKR05n?=
 =?utf-8?B?alVMV0ZNQ1FsWSs0dGNZQjloa0RYSHA4TmpSMlZOZXY1ckxaUGpwNUFzeDdC?=
 =?utf-8?B?L0lleFpWTmlSK1ZxMGduUFUvMGZ1RDRBN1lheHE4MVRKYWxmZ2NLRVpXSkZD?=
 =?utf-8?B?R2g3ZlNLSE1KTnh0MmxYdTkyU3JKbTRlb0NmTnR2enhMVXV1VmE2SzNHWWc1?=
 =?utf-8?B?Znl0VGZVdTJLUHAwZlZSUGRGMXZsdzBPNS91RG8vTWc5Tlp0ajFmNStjeWk3?=
 =?utf-8?Q?MtuEL6xo7B/QWp3oNhbw8WA=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c86340-7d19-4d1f-fbbe-08d9aad353d2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 20:38:07.2132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ph+l/ZHoD7V9Fa0GL1nWnNBgIMX7HxC6EIB6Vj2EYNtRYYa0dQi9moVchGnvLJt6qF/LjM4Khq0QZxX8JY1Hmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/21 5:50 PM, Marek Behún wrote:
> Now that the 'phy-mode' property can be a string array containing more
> PHY modes (all that are supported by the board), update the bitmap of
> interfaces supported by the MAC with this property.
> 
> Normally this would be a simple intersection (of interfaces supported by
> the current implementation of the driver and interfaces supported by the
> board), but we need to keep being backwards compatible with older DTs,
> which may only define one mode, since, as Russell King says,
>    conventionally phy-mode has meant "this is the mode we want to operate
>    the PHY interface in" which was fine when PHYs didn't change their
>    mode depending on the media speed
> 
> An example is DT defining
>    phy-mode = "sgmii";
> but the board supporting also 1000base-x and 2500base-x.
> 
> Add the following logic to keep this backwards compatiblity:
> - if more PHY modes are defined, do a simple intersection
> - if one PHY mode is defined:
>    - if it is sgmii, 1000base-x or 2500base-x, add all three and then do
>      the intersection
>    - if it is 10gbase-r or usxgmii, add both, and also 5gbase-r,
>      2500base-x, 1000base-x and sgmii, and then do the intersection
> 
> This is simple enough and should work for all boards.
> 
> Nonetheless it is possible (although extremely unlikely, in my opinion)
> that a board will be found that (for example) defines
>    phy-mode = "sgmii";
> and the MAC drivers supports sgmii, 1000base-x and 2500base-x, but the
> board DOESN'T support 2500base-x, because of electrical reasons (since
> the frequency is 2.5x of sgmii).
> Our code will in this case incorrectly infer also support for
> 2500base-x. To avoid this, the board maintainer should either change DTS
> to
>    phy-mode = "sgmii", "1000base-x";
> and update device tree on all boards, or, if that is impossible, add a
> fix into the function we are introducing in this commit.

Can you touch on the 5G/10G stuff as well in the message?

> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>   drivers/net/phy/phylink.c | 63 +++++++++++++++++++++++++++++++++++++++
>   include/linux/phy.h       |  6 ++++
>   2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index f7156b6868e7..6d7c216a5dea 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -563,6 +563,67 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>   	return 0;
>   }
>   
> +static void phylink_update_phy_modes(struct phylink *pl,
> +				     struct fwnode_handle *fwnode)
> +{
> +	unsigned long *supported = pl->config->supported_interfaces;
> +	DECLARE_PHY_INTERFACE_MASK(modes);
> +
> +	if (fwnode_get_phy_modes(fwnode, modes) < 0)
> +		return;
> +
> +	if (phy_interface_empty(modes))
> +		return;
> +
> +	/* If supported is empty, just copy modes defined in fwnode. */
> +	if (phy_interface_empty(supported))
> +		return phy_interface_copy(supported, modes);
> +
> +	/* We want the intersection of given supported modes with those defined
> +	 * in DT.
> +	 *
> +	 * Some older device-trees mention only one of `sgmii`, `1000base-x` or
> +	 * `2500base-x`, while supporting all three. Other mention `10gbase-r`
> +	 * or `usxgmii`, while supporting both, and also `sgmii`, `1000base-x`,
> +	 * `2500base-x` and `5gbase-r`.
> +	 * For backwards compatibility with these older DTs, make it so that if
> +	 * one of these modes is mentioned in DT and MAC supports more of them,
> +	 * keep all that are supported according to the logic above.
> +	 *
> +	 * Nonetheless it is possible that a device may support only one mode,
> +	 * for example 1000base-x, due to strapping pins or some other reasons.
> +	 * If a specific device supports only the mode mentioned in DT, the
> +	 * exception should be made here with of_machine_is_compatible().
> +	 */
> +	if (bitmap_weight(modes, PHY_INTERFACE_MODE_MAX) == 1) {
> +		bool lower = false;
> +
> +		if (test_bit(PHY_INTERFACE_MODE_10GBASER, modes) ||
> +		    test_bit(PHY_INTERFACE_MODE_USXGMII, modes)) { > +			if (test_bit(PHY_INTERFACE_MODE_5GBASER, supported))
> +				__set_bit(PHY_INTERFACE_MODE_5GBASER, modes);
> +			if (test_bit(PHY_INTERFACE_MODE_10GBASER, supported))
> +				__set_bit(PHY_INTERFACE_MODE_10GBASER, modes);
> +			if (test_bit(PHY_INTERFACE_MODE_USXGMII, supported))
> +				__set_bit(PHY_INTERFACE_MODE_USXGMII, modes);	
How about

	DECLARE_PHY_INTERFACE_MASK(upper_modes);

	__set_bit(upper_modes, PHY_INTERFACE_MODE_5GBASER);
	__set_bit(upper_modes, PHY_INTERFACE_MODE_10GBASER);
	__set_bit(upper_modes, PHY_INTERFACE_MODE_USXGMII);
	phy_interface_and(upper_modes, supported, upper_modes);
	phy_interface_or(modes, modes, upper_modes);

same linecount but less duplication

> +			lower = true;
> +		}
> +
> +		if (lower || (test_bit(PHY_INTERFACE_MODE_SGMII, modes) ||
> +			      test_bit(PHY_INTERFACE_MODE_1000BASEX, modes) ||
> +			      test_bit(PHY_INTERFACE_MODE_2500BASEX, modes))) {
> +			if (test_bit(PHY_INTERFACE_MODE_SGMII, supported))
> +				__set_bit(PHY_INTERFACE_MODE_SGMII, modes);
> +			if (test_bit(PHY_INTERFACE_MODE_1000BASEX, supported))
> +				__set_bit(PHY_INTERFACE_MODE_1000BASEX, modes);
> +			if (test_bit(PHY_INTERFACE_MODE_2500BASEX, supported))
> +				__set_bit(PHY_INTERFACE_MODE_2500BASEX, modes);

ditto

--Sean

> +		}
> +	}
> +
> +	phy_interface_and(supported, supported, modes);
> +}
> +
>   static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
>   {
>   	struct fwnode_handle *dn;
> @@ -1156,6 +1217,8 @@ struct phylink *phylink_create(struct phylink_config *config,
>   	__set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
>   	timer_setup(&pl->link_poll, phylink_fixed_poll, 0);
>   
> +	phylink_update_phy_modes(pl, fwnode);
> +
>   	bitmap_fill(pl->supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>   	linkmode_copy(pl->link_config.advertising, pl->supported);
>   	phylink_validate(pl, pl->supported, &pl->link_config);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 1e57cdd95da3..83ae15ab1676 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -169,6 +169,12 @@ static inline bool phy_interface_empty(const unsigned long *intf)
>   	return bitmap_empty(intf, PHY_INTERFACE_MODE_MAX);
>   }
>   
> +static inline void phy_interface_copy(unsigned long *dst,
> +				      const unsigned long *src)
> +{
> +	bitmap_copy(dst, src, PHY_INTERFACE_MODE_MAX);
> +}
> +
>   static inline void phy_interface_and(unsigned long *dst, const unsigned long *a,
>   				     const unsigned long *b)
>   {
> 

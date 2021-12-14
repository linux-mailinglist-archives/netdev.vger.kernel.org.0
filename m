Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B069474EC8
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhLNXy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:54:26 -0500
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:19104
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhLNXyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:54:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bROCkRV3XWGKx8HROahXxaJPVyjHbWOYGYaQgfvmLp1VoxxD07UOx35XjSy9HuGf/kH03NCQ/9T+6yCa4o0Gk8H0TxmE6MORBnJNzDe+67gCqBfbPDxgUOSY3mTJyPseN/yiDWBC5NMeIaCG7uBvr84wG4zha1bcuByXi64IPTJz1MogXeQfelNT7qxe37QttFw2wmcTGnhc6KfQHoYa2igDsk4AdtUY090VghbEkP0lZSHB0ksDFYeVAJOzm4GfMxhQy8n2CnrZ4V+P+Ac+Nz6vXxdgND21+BAVllcFTs/Luat/ykT1yDj2qIarthiBcdpXpdcPq/PymqC00GsQaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxeXYgHavR4toG2OytiSylxHs0PggNYOqOFczsNwfxM=;
 b=gAVBDWMzCoojmSCW9TS5cbmYy0/xMGjF4QGYX7etVTVkRczls0HVNLVAFDUZDjNcfGvgBeuUgrwe2ubKq1TwfPRoVd6LQRaCc+K3noDb9eWFwH4TSj2h0YvoMW+zuWoFjjbHwGBqL6tNAsGmtLX0niCxCBfHzYj1vqG+6gLi6jqRsbJHypiHk8lVEDBLw4Q5zrWx2F0ltuARRelMxf9K37T9UNvOGgy0JAs7FzdLpBPd0I0ALPWKECDb0UnoDjlOCxuB9OI/6uDmHbkQ5JrUwHsTdqtDEXSYRowJ2et//M8Td6UqeIxwjL8DCL3wASNJd92c3K35s7GOsW/hqTQoXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxeXYgHavR4toG2OytiSylxHs0PggNYOqOFczsNwfxM=;
 b=AtGphHWwa4TdHt8Ev82DEf5zoQh0AEe4Tu9YmOjszWKfK+93fgLBlLC5e2om/5JOiweyr3dgVKxs2HezyKb5NKEErqWXx0yPPog7e+dYcdBbsG2duLG+qX/0hJQN0wOHJUe/81Q+Ae8NDXjhstAVl8KsyqMvqlqt+Fsorw6EaN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB6027.eurprd03.prod.outlook.com (2603:10a6:10:ec::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 23:54:21 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::9093:a60b:46b7:32ee%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 23:54:21 +0000
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next 2/7] net: phylink: add pcs_validate() method
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <Ybiue1TPCwsdHmV4@shell.armlinux.org.uk>
 <E1mx96A-00GCdF-Ei@rmk-PC.armlinux.org.uk>
 <0d7361a9-ea74-ce75-b5e0-904596fbefd1@seco.com>
 <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
Message-ID: <3a3716a1-54be-e218-5c1e-a794b208aa53@seco.com>
Date:   Tue, 14 Dec 2021 18:54:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YbkoWsMPgw5RsQCo@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0303.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::8) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17895464-82b9-47e8-4e65-08d9bf5d0ca2
X-MS-TrafficTypeDiagnostic: DB8PR03MB6027:EE_
X-Microsoft-Antispam-PRVS: <DB8PR03MB60270A08310467466A18D56D96759@DB8PR03MB6027.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yNXJsHcrNefjfovZWUG50A2Y0VebJlKVqW7WWoqs30Ddi+dv4mwGMwWOmgwUiJxzNflaBSi26+85wjctrOVaWFU1zxNfW34Pss7c1N4PjphsOZipMnjUX0lF5B0HtEbJzkd31gAz2vVQ0LjGgCvElpllKzS6UK7R7CzLFKlIKW8Bf40gMorIw7jFkqXRXOgh/7k9vcfwdReo9FVjfawSe/sbGz/0fnpjFi2/xfaQx5EB3CM20eHZhRBISdY78UGZAv2fDw5F2tzOKWxabexZPPmddkzfGZ+RStqdAS7f5pjGdo6C+XK7BDUEETObWWPu72OXENE4t8iWEu/IQ3kQEHZclaU/vHYrKCnyXikQ5fl0NiKPE8+Yk4f/IFL685f4t5H4K9zQweDPkHe3Z06Ru92lEY17tgcUyLI7/dwU4AWF3wVJ1ijYx3MH3pg179WiWu/SXmzRYbt9raef2KETIksKjJu3OuK/xHw0gq3JmntnD06A/KENNsx3qhV1I/GJhFsK1SsamXTBWKnEj+5rdynAsZojD8dEhLGkVeRiJ1T0k1jfF0D9SOf21/DvjwM3DUTBL9W02MbLSuZDJJnmwaDvHsL63MHVwCnR/lcrELRco02Q1wtsqBaJfTtn/Gu8i1vHteHdhRkE6SBesksEaGRlFIXi9j1hTVa11jZw3UiytYqBzho0+hLKOzWwYdPL/Gk/C7Hm5gfisDj+4K/c1LSaKbPPRjz+2W0jIRz3AM2BZfaTpw0hfDoZIAzBXXb/A0gJg0TRcRLuSKoWNzG7RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(31696002)(86362001)(6506007)(316002)(6512007)(5660300002)(508600001)(26005)(54906003)(66946007)(66476007)(8676002)(66556008)(53546011)(186003)(83380400001)(2906002)(8936002)(36756003)(6916009)(52116002)(6666004)(2616005)(44832011)(4326008)(38100700002)(38350700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVU1ZDZ2aFliMCtCNVVGUndQbVJhSEhIZzVlWlhTZHlnZE8xcmVSblRWSDdH?=
 =?utf-8?B?VEd3WWJJNWdsRDcwVUxSRHVxSzl2emhmd1JtajVldDFSeTlscnhhVkRZSVVp?=
 =?utf-8?B?VVJCcCtQT0JFYW81dmhvam9rS0lobzd5QXpCY3hxZm5UTm9LUlQ1RVJKODlp?=
 =?utf-8?B?OStsR3MvSHJwTzJaUnlkRWhDQXFjK05jM01GVldlSyszTDBZczBRQ0V4czAx?=
 =?utf-8?B?WHI3NXRNaFJaVUM2TENNZE4vRXR2M1NsSGF0VFkvYXlEYWtkQ3JLRGliaTJT?=
 =?utf-8?B?MW94V2FEY2tmL3l6RFhPOHgwVlZYTDRQN09Da2g0cVQwWVlGSEhSRlFVMnhr?=
 =?utf-8?B?MG5lUmJZNjBJS2Y4T3lzRHlWUlVzU2hObGZsZElQQmFzejEzMCtLVWkxbDQ0?=
 =?utf-8?B?b2J3d3Q2NFBxWTNhdEZNNnQyaW41TzVralQrVUNtV2t2YlY2YWowNDN6eVpF?=
 =?utf-8?B?MjJ4RTNqNUFwczcyNmZkUlFZTmhpVDNSdm9hM1VLNmdFYWpKbUk0a0JNTW4x?=
 =?utf-8?B?MHZ1TUUvaVF3RWhwZkhSWUUvZXVvcnJ1R2hVaHA5cmVmb2E0S0VMYnl4MEJ4?=
 =?utf-8?B?dFhSb2tsOHQwMUZXL0tYZDhZLzZ3K2tRQ0hUeERKbG1jSktUekMwaGFMRHkv?=
 =?utf-8?B?eGFCNmhmcTdFc3VMM29KNDh6RVdiV3lEVFVnZWRNSzVnalpBNnNLK2VucjFx?=
 =?utf-8?B?eVd4Z3pNREJuWkxjRVE0UWo3QThkbGs2S09hU3BmVWlxN0N4bmFsTUhXcDF1?=
 =?utf-8?B?cG5Ja1p0Q2YvTzVHZnRKNWd3RldtQjBBQlc0U29CZHJWUkhDaXNZd3NtSjcr?=
 =?utf-8?B?NEVoWForMTgyRmhjcy9DZEFjRGVBcWdwNEtnWHN2RzNNeDBLQkduT0N3Y0Vt?=
 =?utf-8?B?UXRuckt0aFkyeFdoMlg4bUsrUktKMmdFdFp5VVk4bkdsTEYxZWNKZjFsMEda?=
 =?utf-8?B?bnNXVm5qQXhvK1RjcXZWeUJMdGp2NU1xQjE5clNJd1RMTXU5ZDdwV2dFRkxi?=
 =?utf-8?B?QXE2ZWEweTlITlBHVXEvR0lORUZFS2txVGFyenowUng3NWFYdm1POVZOMU9k?=
 =?utf-8?B?V09hdWw2ei9Ua2ZHdU1Oc1RYa1JrSFNHK2tubHVqUVdPd3JQZEd3cVJPZnF1?=
 =?utf-8?B?OXVzVjVPeVErYTZBYWlQaWpXWDNUN1JFZFBvSFJ3bHZzaGVLQklBRDgyS2RR?=
 =?utf-8?B?YjgyZWV1VisyUGp6bXU3Skk3QzIzWCtGeVJOVXkvMUpuaVRYd0xjSG1KanBL?=
 =?utf-8?B?aHJDMEkwbStJd3JaOU9iaUxUWUs2Yjk5eXFqUVgySUszSmxmZXp2SXl6VkhM?=
 =?utf-8?B?VkJ5ZndUanNYck5qOXFVNktBdGRFMWZSWTIyd25WTVVoZmh0V2JyaitadDNQ?=
 =?utf-8?B?WTlHcTAyK3JBR0kvTUdqdFlRN25pc2VmcHREdjlkUVhKNzdFd0JxM0ZvOGRs?=
 =?utf-8?B?d1FsanhOWVRUM1F2cUViRHBNMk8yTWpLL0JOMU12S3Rvc2ttRmJiRGpvTzNs?=
 =?utf-8?B?TE15QUVjR3A4YWVwYkorM21kRDRkKzNiWm9wNFplazA5ZzRBNGVGb2RiNGRS?=
 =?utf-8?B?NEk4aURUSXRhS3NocW9lOFBucFU3d0JXRWk2WVpramlhTm5idmNmWG1CUnVo?=
 =?utf-8?B?QVhWYTRCQmVFZEprWWpvMkZXL1krSnQweVRZTHNaRkY5YnFkTzFKNUZpdkdi?=
 =?utf-8?B?bjBlVTdoaHRIVU53Vys5ejJWNmRTR1duQ01rQUU0MExUY3owNythZWgwL3Bh?=
 =?utf-8?B?VFJNWVJsdmFVejNVS0Q0QWg4UVI4VU5oSUx0WitGdENhTEtJWkwwMTQrV2d2?=
 =?utf-8?B?cGdzLzdJWTQyTGhTMTVBS3pkMnJiQlk1OFVzcTgyRzVia3RISkRvdlJ0dEp2?=
 =?utf-8?B?cUtrZGQwenQzUUVyc3ZjMit5OWtQNFd5ZktBQmhWbVpKTjYzNkF2UFl1V0xQ?=
 =?utf-8?B?OTRzMWpPRVBqc0FNcW5qcy9DZkk5NmY0WndqYkl3MU95aFNhSzFydk1pR1NS?=
 =?utf-8?B?QUZ5RDAyeFpIYStOUE8zOVZqTURzdHlteWR4K1A1YkZ0RlVkQ3BjVW53VmtZ?=
 =?utf-8?B?cU12T2tBN0pDWnl5OW1tcW9xNWpGRHNrSWEveHVqT3JGSGVFS2dxaTNxSFdn?=
 =?utf-8?B?REkzOFFpVzZnWUtOQTBOSlVxSFF0WU9yM1Y5eUU3MUhnR01OQVkwd0x6WkxL?=
 =?utf-8?Q?vtXfY2t7/LRu+cjVAtDkGRU=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17895464-82b9-47e8-4e65-08d9bf5d0ca2
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 23:54:21.6222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BQAU02oxsMpSK8dZC1hzJkGxV/6AiFMhc8JNqaCJmPsvcan3vcMTp6Mhp98JCTpVr091shpDF11+aLvWt+QaYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/21 6:27 PM, Russell King (Oracle) wrote:
> On Tue, Dec 14, 2021 at 02:49:13PM -0500, Sean Anderson wrote:
>> Hi Russell,
>>
>> On 12/14/21 9:48 AM, Russell King (Oracle) wrote:
>> > Add a hook for PCS to validate the link parameters. This avoids MAC
>> > drivers having to have knowledge of their PCS in their validate()
>> > method, thereby allowing several MAC drivers to be simplfied.
>> >
>> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> > ---
>> >   drivers/net/phy/phylink.c | 31 +++++++++++++++++++++++++++++++
>> >   include/linux/phylink.h   | 20 ++++++++++++++++++++
>> >   2 files changed, 51 insertions(+)
>> >
>> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> > index c7035d65e159..420201858564 100644
>> > --- a/drivers/net/phy/phylink.c
>> > +++ b/drivers/net/phy/phylink.c
>> > @@ -424,13 +424,44 @@ static int phylink_validate_mac_and_pcs(struct phylink *pl,
>> >   					struct phylink_link_state *state)
>> >   {
>> >   	struct phylink_pcs *pcs;
>> > +	int ret;
>> >
>> > +	/* Get the PCS for this interface mode */
>> >   	if (pl->mac_ops->mac_select_pcs) {
>> >   		pcs = pl->mac_ops->mac_select_pcs(pl->config, state->interface);
>> >   		if (IS_ERR(pcs))
>> >   			return PTR_ERR(pcs);
>> > +	} else {
>> > +		pcs = pl->pcs;
>> > +	}
>> > +
>> > +	if (pcs) {
>> > +		/* The PCS, if present, must be setup before phylink_create()
>> > +		 * has been called. If the ops is not initialised, print an
>> > +		 * error and backtrace rather than oopsing the kernel.
>> > +		 */
>> > +		if (!pcs->ops) {
>> > +			phylink_err(pl, "interface %s: uninitialised PCS\n",
>> > +				    phy_modes(state->interface));
>> > +			dump_stack();
>> > +			return -EINVAL;
>> > +		}
>> > +
>> > +		/* Validate the link parameters with the PCS */
>> > +		if (pcs->ops->pcs_validate) {
>> > +			ret = pcs->ops->pcs_validate(pcs, supported, state);
>>
>> I wonder if we can add a pcs->supported_interfaces. That would let me
>> write something like
>
> I have two arguments against that:
>
> 1) Given that .mac_select_pcs should not return a PCS that is not
>     appropriate for the provided state->interface, I don't see what
>     use having a supported_interfaces member in the PCS would give.
>     All that phylink would end up doing is validating that the MAC
>     was giving us a sane PCS.

The MAC may not know what the PCS can support. For example, the xilinx
PCS/PMA can be configured to support 1000BASE-X, SGMII, both, or
neither. How else should the mac find out what is supported?

> 2) In the case of a static PCS (in other words, one attached just
>     after phylink_create_pcs()) the PCS is known at creation time,
>     so limiting phylink_config.supported_interfaces according to the
>     single attached interface seems sane, rather than phylink having
>     to repeatedly recalculate the bitwise-and between both
>     supported_interface masks.
>
>> static int xilinx_pcs_validate(struct phylink_pcs *pcs,
>> 			       unsigned long *supported,
>> 			       struct phylink_link_state *state)
>> {
>> 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>>
>> 	phylink_set_port_modes(mask);
>> 	phylink_set(mask, Autoneg);
>> 	phylink_get_linkmodes(mask, state->interface,
>> 			      MAC_10FD | MAC_100FD | MAC_1000FD);
>>
>> 	linkmode_and(supported, supported, mask);
>> }
>
> This would be buggy - doesn't the PCS allow pause frames through?

Yes. I noticed this after writing my above email :)

> I already have a conversion for axienet in my tree, and it doesn't
> need a pcs_validate() implementation. I'll provide it below.
>
>> And of course, the above could become phylink_pcs_validate_generic with
>> the addition of a pcs->pcs_capabilities member.
>>
>> The only wrinkle is that we need to handle PHY_INTERFACE_MODE_NA,
>> because of the pcs = pl->pcs assignment above. This would require doing
>> the phylink_validate_any dance again.
>
> Why do you think PHY_INTERFACE_MODE_NA needs handling? If this is not
> set in phylink_config.supported_interfaces (which it should never be)
> then none of the validation will be called with this.

If the MAC has no supported_interfaces and calls phylink_set_pcs, but
does not implement mac_select_pcs, then you can have something like

     phylink_validate(NA)
         phylink_validate_mac_and_pcs(NA)
             pcs = pl->pcs;
             pcs->ops->pcs_validate(NA)
                 phylink_get_linkmodes(NA)
                 /* returns just Pause and Asym_Pause linkmodes */
             /* nonzero, so pcs_validate thinks it's fine */
     /* phylink_validate returns 0, but there are no valid interfaces */

> The special PHY_INTERFACE_MODE_NA meaning "give us everything you have"
> is something I want to get rid of, and is something that I am already
> explicitly not supporting for pcs_validate(). It doesn't work with the
> mac_select_pcs() model, since that can't return all PCS that may be
> used.
>
>> 	if (state->interface == PHY_INTERFACE_MODE_NA)
>> 		return -EINVAL;
>>
>> at the top of phylink_pcs_validate_generic (perhaps with a warning).
>> That would catch any MACs who use a PCS which wants the MAC to have
>> supported_interfaces.
>
> ... which could be too late.

You can't detect this in advance, since a MAC can choose to attach
whatever PCS it wants at any time. So all you can do is warn about it so
people report it as a bug instead of wondering why their ethernet won't
configure.

>> > +			if (ret < 0 || phylink_is_empty_linkmode(supported))
>> > +				return -EINVAL;
>> > +
>> > +			/* Ensure the advertising mask is a subset of the
>> > +			 * supported mask.
>> > +			 */
>> > +			linkmode_and(state->advertising, state->advertising,
>> > +				     supported);
>> > +		}
>> >   	}
>> >
>> > +	/* Then validate the link parameters with the MAC */
>> >   	pl->mac_ops->validate(pl->config, supported, state);
>>
>> Shouldn't the PCS stuff happen here? Later in the series, you do things
>> like
>>
>> 	if (phy_interface_mode_is_8023z(state->interface) &&
>> 	    !phylink_test(state->advertising, Autoneg))
>> 		return -EINVAL;
>>
>> but there's nothing to stop a mac validate from coming along and saying
>> "we don't support autonegotiation".
>
> How is autonegotiation a property of the MAC when there is a PCS?
> In what situation is autonegotiation terminated at the MAC when
> there is a PCS present?

*shrug* it doesn't make a difference really as long as the MAC and PCS
play nice. But validate works by masking out bits, so you can only
really test for a bit after everyone has gotten their chance to veto
things. Which is why I think it is strange that the PCS check comes
first.

--Sean

> The only case I can think of is where the PCS is tightly tied to the
> MAC, and in that case you end up with a choice whether or not to model
> a PCS in software. This is the case with mvneta and mvpp2 - there is
> no separation of the MAC and PCS in the hardware register design. There
> is one register that controls pause/duplex advertisement and speeds
> irrespective of the PHY interface, whether the interface mode to the
> external world is 1000BASE-X, SGMII, QSGMII, RGMII etc. mvpp2 is
> slightly different in that it re-uses the GMAC design from mvneta for
> speeds <= 2.5G, and an entirely separate XLG implementation for 5G
> and 10G. Here, we model these as two separate PCS that we choose
> between depending on the interface.
>

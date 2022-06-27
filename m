Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B80955CFCA
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237345AbiF0PR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 11:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiF0PR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 11:17:26 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30081.outbound.protection.outlook.com [40.107.3.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1428B186CE;
        Mon, 27 Jun 2022 08:17:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCHudkzHNy2q3a58MsSJH3Ux7GBb2Pu5qKQtGzTiFDc7Ifs2bonTY8GVBmQIo1LsPKp8Ly86dQFNjbo9tJq+b8Hv0hkywk6AIMI9O5AvOFkElXcNzmnwPAsk7QSrCl0OTNB3y3uwV47eQvjUUIpOEwcmhzMkxDvRyg79LJUZd+sRmHy4iAFgwh+2djX3Ky+OqXvADPxexASrn6ZwCkYe/CGtwiOsJicRwzqmhU8rlxPrISHLVdEkFwVSqiTgL1PVKhDrBMUxhwX/5GwCawetQzbcLJb/QRhAnw4NGYse4XbpwG9Ty3Cg8nZsEgC0c9fZlpF5AzTLHf5WRbedmN/krA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4Eq/Tats95Kt5KPySbA8AdhBjyPnaYNlx86pkLAkSM=;
 b=jAMjdrIqiM/NhufnOjT20F6lrOwQC89VMLvTaunDxEhdECdB0oCtE/6P5alFYA59R2Z358HQxTQ0F57CINk84Tna/R5HLnisUlO/MtHQwl4Gztz5QYc2rZNjdqCnoTGDOEFlayfUV92CFu5gQXlQ35vpPpulNcRVvLsyn7h1hcIp1v82/vp8SUAszt/n8L0lv81VHaa8WfLxQQW93ThGZW/me2TZQvT1fruTRBlw55T+ein2DuKv6l1eqONTbW3Fq1Of2V5Tjs6a9j0U2h8MuoRbq5sAlx7Q4748TM34S+o5KxzK4T9OI9nKYiA8uCulbwN+OsMWJcwsY0ibKLgL8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4Eq/Tats95Kt5KPySbA8AdhBjyPnaYNlx86pkLAkSM=;
 b=BMs2YBPRFhSwrfORcSOkeVKjIx1CxiOvV112YE3Ioe5h0paacFUax1CH5Rv4RHVfONiBiSSaDk/8mguOwqvL+5gtvCOcPdt9iqhg0qT3PwyFRUbWo6XYzFer55RwE4rcnlhM4iIySraTCJGVipXuvBW3vLTGKqojkcsiW5TY5oMv0C0Szp5gVqpbtxOjyIK+XVnXXqncV6V8LQcGQ6kyvxGlwHkJ9FL6GPMGp4fC5ZZQObatuGrC4Gaa+XE05gUQ53f2iJJByWIXauqkCQvlfKC+7n8nid4wt3t0EoacdffAU+GbmjOSPF2iWjArFH6GrFIfrFlUwa6tjipf5iwBYw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB3570.eurprd03.prod.outlook.com (2603:10a6:208:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 15:17:18 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 15:17:18 +0000
Subject: Re: [PATCH net-next 25/28] [RFC] net: dpaa: Convert to phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-26-sean.anderson@seco.com>
 <Yqz5wHy9zAQL1ddg@shell.armlinux.org.uk>
 <dde1fcc4-4ee8-6426-4f1f-43277e88d406@seco.com>
 <Yq2LLW5twHaHtRBY@shell.armlinux.org.uk>
 <84c2aaaf-6efb-f170-e6d3-76774f3fa98a@seco.com>
 <8becaec4-6dc3-8a45-081a-1a1e8e5f9a45@seco.com>
 <YrUEKmQzXC1OXrHV@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <19ee2170-649c-3bbb-7fba-8834d5ba9372@seco.com>
Date:   Mon, 27 Jun 2022 11:17:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YrUEKmQzXC1OXrHV@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0018.prod.exchangelabs.com
 (2603:10b6:207:18::31) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43cdc0ba-30a5-45cc-8da8-08da58501f96
X-MS-TrafficTypeDiagnostic: AM0PR03MB3570:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G8S9fV3jMzjNid1YqbFkoUeuc7rukuYYIMfQ7oFyDsVTvPoafP4gfS9vIMVoJdtnEz+jDxbdhTTARvXDYLPmP7ZB6Qg+BohrRF5EA5mXPoweYluR9XeN7cVR0HVPBQE9sIv1zJm8y2DH7pFU0x/XFYWVlk3MIo3XMHfgWDpGjVw8jeQgMolmSGlZrFzTwZrXzI86w0DIWOjtr5bxCFNSSUmTgl++NJuG2PaXzbAdodTAubGv7MFrlgq3lamjGqdj5CedbbBljTcnLtD1GLqLaFLxjdhFWHM5vdvW+5xEUpcb/+E/HHYdwn779tjDP6N5xDSy1AxcnJZ0SxM+AwPi4mCmNhVAkS4y1aukuIreFTdzTRSxx0IjKA+7NtkTVAmYbjwhpHJFN/cHULhgY9ir3cg7lZ8jAA+1ZxBiydm0TvK+XhP6Toqdn/B0HKrg8wUg3dFK6WbX29VDWWKi40/4/7SXEW9dz5B+QLDN2nIWEFQTmxiLyIEQS8KzY3xrsiSf5bxJXYx3GsCr6bOHzB9ghSP5/MvoZXsgl9pDnjue99NeS57vZZjtcHu5oKXhN9ladqFPKyUAEzj3x9IrVh0/Pmdh1cNC9w5iV7rufXzEsVrzHafCWWIH+JXqKrsBmJ5ub/5nVmle8VdJFXN/3CLHNzOL1gGJJZKMxJEs3H2Un6pO0ZfsQ/5oANJ3pAOe/UzWuQMtC0U4KAbaXdmAoxj3QEOPNXAXKtRBRJVdEYwfuxZlp7/0H97FZE0co17hyrLcPflHEI7voGpGFDdmFP2m6qI9/rME8za/OGjiJWnIX4letZ0QcBTBQ6UxB2UTyG4gpOcgBGfaiY8iYr9UyxLIrBEkBTchV1iu/EJ3dl9V6E0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(39850400004)(366004)(136003)(5660300002)(36756003)(2906002)(41300700001)(66556008)(54906003)(44832011)(31686004)(30864003)(8936002)(186003)(66476007)(2616005)(83380400001)(26005)(31696002)(8676002)(316002)(86362001)(6486002)(38100700002)(6916009)(52116002)(53546011)(478600001)(66946007)(6506007)(6512007)(4326008)(6666004)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXQyOXVJTVEyUUFoVWRjaG11M21GOXh4bnJ6MksxREo3bTc2TFB1VlgycThn?=
 =?utf-8?B?N0tZY0plbzhSbFFLT2wwTDdIbm9JclU1WHhObW56QmsySi80Q0ZLQm1URW42?=
 =?utf-8?B?VmRLUHlwdWs0UGVCU3NBN0JrcXlubXM5MDh2dFNjV2NHb04ybDAzVGs1eXJX?=
 =?utf-8?B?dE1MekU4R2Q1QXVKOFhtOVg0SFFQdWxta0grQ1FpdE0vRjFNakNKb2pVbUZW?=
 =?utf-8?B?a09QR2twS29vdS9RcjJ4YXFOMTRFZkZNSno1YkxLbndrVkVHcysxR0ZJVFRz?=
 =?utf-8?B?R2dpNzVocE14RDcvdjZ3MUJqODhpRjNHaGlvemxkcnVWV290WFlXNEVnenk5?=
 =?utf-8?B?V0NFRExmNzNQUTg0ZmErazVWbkFITFVMRzRDUEdraTdERTM1OEV6QU5oMytP?=
 =?utf-8?B?QUp4UWdzS1dIdnZTL0ZNRlEvMTdvbFhnM05mMlJrd1lRWDVoV1JjVDlQeGdZ?=
 =?utf-8?B?YzljblZaOWpjQ3ZNOGQyOHBORDRybkl4RGsyRlRWTENvMGhWVmt0cTRhMk9J?=
 =?utf-8?B?dGJNek84Qmg5ek9TSXE0NmNtMUJZeWxxbnNmOFF1NHY3dHZ0ZFQ1K25CM1cx?=
 =?utf-8?B?NzBpV0dUV0R2b3RYZW92NXlneVlNUVdBWHlCQnRsZXhvUk43aGYzanpGUHBW?=
 =?utf-8?B?UlMyV1NDdWRFc1ZNc0VOZXBBeko3MENnbEFQVkRqUzRKWXVMTmlMajZsUUV2?=
 =?utf-8?B?S2RnNGJhd2ZScGJLYjFaSk96VERaalpLVVN1QlZXQmpFbkUrNWRSOFdxYjls?=
 =?utf-8?B?WlpPQ3hDK2F4OUF4RllZcFNGUFN6M2VrMXJ2VjZ6ZHBEb0JFSjhReVk3TGNl?=
 =?utf-8?B?TnliMXJqMXJ3YVl1TlFRdnN2cVR4akpvcU05M3ptNkNqc2g4OG1mOTRmWVNl?=
 =?utf-8?B?MnZzUXNKMzZOTTE5K0FoSDZXOXJtcnl6YzhmRndOVG9LUDBCSE9NQ0dIRDlh?=
 =?utf-8?B?bGNxWWJSK0JIZ0hrZ083MG96UWJaZCsxdjlTdjV5VHlvL01OT2d6enhiWjIx?=
 =?utf-8?B?TlhmRm5mcGUyTi85TlQwaUxsQTlvUmJHcnlWUlVtNnJRSDExVUVXU29GeENn?=
 =?utf-8?B?bU5sQ2k3bjRJWnJxazRxY1l2QlcvL1QwM0xWZ2R2ZVlaYW5wV3JMU2VZQUZS?=
 =?utf-8?B?NjM2Ny9DVFN3MmRUQkZnRzdqdWxMSStKNWI3RmhyRC8xUWNid3dSYUF2aFRL?=
 =?utf-8?B?MU1vcmJsM0RaUUVMNlV5MnN6YUU3a0l4UTRxWTByeDNQZEl5UVVKcVpnZFUx?=
 =?utf-8?B?Mm1Ia1ZtR3pEN1U1M1B2akM0WXEwRzVNc1p5Y1FRQnZnS1JWQXVkQjNUYTZt?=
 =?utf-8?B?L2kzNG5yUkx4UEhiU1V3SFNFamU2UnQ0YlVpMmdUdjZTd0Fld2k3RGF6WUhH?=
 =?utf-8?B?akhiQUJJeG5SYWZQdlpzeEpZUjhkY1VjQ2pYaTAvcUF2RXBYeXNpMU1rMXRL?=
 =?utf-8?B?eHd4Rk9zODUxUG1ITXFya0NkSUZyKzhTYWtGUmNCV0NwcmtnNVNzaEVjOS9v?=
 =?utf-8?B?Um5idkJWVlJRNVZoUHc1YUNLMExKR3hsMnBIR0tIdmNDYmY4RXBmYmRLVmZI?=
 =?utf-8?B?anhrQkZMbnV6SmxTSHhTQURZUnZ1Q0EvalAzVWRZS2lSYnJZcFFKZnlFQ1dy?=
 =?utf-8?B?bXhoNEFaWFZiR0V5bFk1YlY4RzBacVlLT0tlQ0F1WmZ6dFNvWTFWVEFnTlUz?=
 =?utf-8?B?OUxKeWxKOS8yMlB0OTFYWE8wN3ZKVk1JUnVBd2w4SDJlVU9sTnRNOHVFSVlp?=
 =?utf-8?B?ZnFBREJlcXNUTklIMmUvY2FsWW90dk8yZ2pmWXYraU95MVcweDdOcXZKUG5m?=
 =?utf-8?B?bUhmRFQvUjN1MFRuWDNsWFB0VlIzejNmYkdEOWhyYUwvMiswSjVpdnlCTGda?=
 =?utf-8?B?djQwVnBVNVB4b1kyVHlxNldjT1VFWExWdHpQNXgwRDNyQWROdnFXb1Roamhz?=
 =?utf-8?B?TCtwUC9vL3lWRHk2TVZiQUFBaENjdFVlWkZ4aHd3MlcxM3U5N3NGOURzVVI1?=
 =?utf-8?B?SHNwMUxiUXJ5NlFZZ1VFS3hwMmpWY01WNkNLVFUxYVRhL0VBamJGclFkOWRy?=
 =?utf-8?B?OUxlM3BnTlpiTVZ4YkU0Vk43VDR0VTR5NDZjN1o3Kzl4endDRmh1V3hOTmR4?=
 =?utf-8?B?ZmY1WEYrUG56aGhwZlRhK1RSeWRzWHNoUVB3cTlzVENmUDZqVXJEd1lSOGNT?=
 =?utf-8?B?VkE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cdc0ba-30a5-45cc-8da8-08da58501f96
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 15:17:17.9434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+6n1C45LeyAp25Z7HpCp90q/6sVl96vFVoxl/XzVVjHdnaLxv8jd/xLdogYSCkeIiNJY/MleBg6i5ka98cwig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3570
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/22 8:24 PM, Russell King (Oracle) wrote:
> On Thu, Jun 23, 2022 at 06:39:08PM -0400, Sean Anderson wrote:
>> Hi Russell,
>> 
>> On 6/18/22 11:58 AM, Sean Anderson wrote:
>> > Hi Russell,
>> > 
>> > On 6/18/22 4:22 AM, Russell King (Oracle) wrote:
>> >> On Fri, Jun 17, 2022 at 08:45:38PM -0400, Sean Anderson wrote:
>> >>> Hi Russell,
>> >>>
>> >>> Thanks for the quick response.
>> >>> ...
>> >>> Yes, I've been using the debug prints in phylink extensively as part of
>> >>> debugging :)
>> >>>
>> >>> In this case, I added a debug statement to phylink_resolve printing out
>> >>> cur_link_state, link_state.link, and pl->phy_state.link. I could see that
>> >>> the phy link state was up and the mac (pcs) state was down. By inspecting
>> >>> the PCS's registers, I determined that this was because AN had not completed
>> >>> (in particular, the link was up in BMSR). I believe that forcing in-band-status
>> >>> (by setting ovr_an_inband) shouldn't be necessary, but I was unable to get a link
>> >>> up on any interface without it. In particular, the pre-phylink implementation
>> >>> disabled PCS AN only for fixed links (which you can see in patch 23).
>> >>
>> >> I notice that prior to patch 23, the advertisment register was set to
>> >> 0x4001, but in phylink_mii_c22_pcs_encode_advertisement() we set it to
>> >> 0x0001 (bit 14 being the acknowledge bit from the PCS to the PHY, which
>> >> is normally managed by hardware.
>> >>
>> >> It may be worth testing whether setting bit 14 changes the behaviour.
>> > 
>> > Thanks for the tip. I'll try that out on Monday.
>> 
>> Well, I was playing around with this some more, and I found that I could enable
>> it if I set one of the 10G lanes to SGMII. Not sure what's going on there. It's
>> possible one of the lanes is mismatched, but I'm still looking into it.
>> 
>> ---
>> 
>> How is rate adaptation in the phy supposed to work? One of the 10G interfaces on
>> the RDB is hooked up to an AQR113 which can adapt rates below 10G to XFI using
>> pause frames.
> 
> Rate adaption support isn't something that phylink officially supports.
> It can be bodged around (and some drivers do) but that's the official
> line - there is no code in phylink to make it work.

Ah, that's unfortunate. I removed some Aquantia-specific code, but I may
have to add it back...

> For example, if you have a PHY that's doing rate adaption, and the PHY
> reports what has been negotiated on the media side. That gets reported
> back to the PCS and MAC. The only way these blocks can tell that there's
> something going on is if they say "hey, but the link to the PHY is
> operating at 10G and the media speed is 100M, so something fishy is
> going on, the PHY must be doing rate adaption."
> 
> That's the bottom line to this - phylink doesn't yet support rate
> adaption by any of the blocks - mainly because there is no way for
> any of those blocks to indicate that they're doing rate adaption.
> 
> The implementation of phylink_generic_validate() assumes there is no
> rate adaption (as per the current design of phylink).
> 
> The reason phylink_generic_validate() has come into existence recently
> is to (1) get rid of the numerous almost identical but buggy
> implementations of the validate() method, and (2) to eventually allow
> me to get rid of the validate() method. The validate() method is not
> very well suited to systems with rate adaption - as validate() stands,
> every MAC today that _could_ be connected with something that does rate
> adaption needs to have special handling in that method when that is
> true - that clearly isn't a good idea when it's dependent on the
> properties of the devices towards the media from the MAC.
> 
> Ocelot does make rate adaption work by doing exactly this - it has its
> own validate() method that returns all the link modes that it wishes
> the system to support, and it ignores some of what phylink communicates
> via the link_up() callbacks such as rx_pause. This means this MAC driver
> wouldn't behave correctly as a system if rate adaption wasn't present.
> 
> 
> Now, the thing about rate adaption is there are several different ways
> to do it - and Marvell 88x3310 illustrates them both, because this PHY
> supports rate adaption but depending on whether the PHY has MACSEC
> hardware support or not depende on its behaviour:
> 
> - If no MACSEC, then the PHY requires that the MAC paces the rate at
>   which packets are sent, otherwise the PHYs FIFOs will overflow.
>   Therefore, the MAC must know: (1) the speed of the media side, and
>   (2) that the PHY requires this behaviour. Marvell even go as far as
>   stating that the way to achieve this is to extend the IPG in the MACs
>   settings.
> 
> - If MACSEC, then the PHY sends pause frames back to the MAC to rate
>   limit the packet rate from the MAC. Therefore, the MAC must accept
>   pause frames to throttle the transmit rate whether or not pause
>   frames were negotiated on the media side.
> 
> So, doing this right, you need knowledge of the rate adaption
> implementation - there isn't a "generic" solution to this. It isn't
> just a case of "allow all speeds at the media side at or below PHY
> interface speed" although that is part of it. (More on this below.)



>> This is nice and all, but the problem is that phylink_get_linkmodes
>> sees that we're using PHY_INTERFACE_MODE_10GKR and doesn't add any
>> of the lower link speeds (just MAC_10000).
> 
> Do you really have a 10GBASE-KR link - a backplane link? This has
> negotiation embedded in it. Or do you have a link that is using the
> 10GBASE-R protocol? (Please don't use PHY_INTERFACE_MODE_10GKR unless
> you really have a 10GBASE-KR link as defined by 802.3).

 Sorry, that was a typo.

>> This results in ethtool output of
>> 
>> Settings for eth6:
>> 	Supported ports: [  ]
>> 	Supported link modes:   10000baseT/Full
>> 	                        10000baseKX4/Full
>> 	                        10000baseKR/Full
>> 	Supported pause frame use: Symmetric Receive-only
>> 	Supports auto-negotiation: Yes
>> 	Supported FEC modes: Not reported
>> 	Advertised link modes:  10000baseT/Full
>> 	                        10000baseKX4/Full
>> 	                        10000baseKR/Full
>> 	Advertised pause frame use: Symmetric Receive-only
>> 	Advertised auto-negotiation: Yes
>> 	Advertised FEC modes: Not reported
>> 	Link partner advertised link modes:  10baseT/Half 10baseT/Full
>> 	                                     100baseT/Half 100baseT/Full
>> 	Link partner advertised pause frame use: Symmetric
>> 	Link partner advertised auto-negotiation: Yes
>> 	Link partner advertised FEC modes: Not reported
>> 	Speed: Unknown!
>> 	Duplex: Unknown! (255)
>> 	Auto-negotiation: on
>> 	Port: MII
>> 	PHYAD: 0
>> 	Transceiver: external
>>         Current message level: 0x00002037 (8247)
>>                                drv probe link ifdown ifup hw
>> 	Link detected: yes
>> 
>> The speed and duplex are "Unknown!" because the negotiated link mode (100Base-TX)
>> doesn't intersect with the advertised link modes (10000Base-T etc). This is
>> currently using genphy; does there need to be driver support for this sort of thing?
> 
> Without knowing whether this is a clause 22 or clause 45 PHY, I'd just
> be guessing, but...

It's a c45 phy.

> genphy's C45 support is rudimentary and should not be used.

Fun. TIL

> genphy's C22 support is better for basic control of PHYs but should not
> be used if there's a more specific driver.
> 
> If this is a C22 PHY, I'm surprised that it managed to link with its
> partner - we should have cleared anything but the 10000M modes in the
> PHY which should have caused the media side autonegotiation to fail.

I looked into this further, and it seems like the phy has an "Autonegotiation
Vendor Provisioning" register. In this register there is a "User Provided
Autonegotiation Data" field which defaults to 0. This causes "the PHY [to]
construct the correct autonegotiation words based on the provisioned values."
AKA the programmed advertisement is ignored. This is very convenient for me
because otherwise the link would not have come up :)

> However, with the Ocelot-style workaround I mentioned above, that would
> allow the 100M speeds to be advertised, and phylib would then be able
> to resolve them to the appropriate speed/duplex. I don't condone doing
> that though, I'd prefer a proper solution to this problem.
> 
>> Should the correct speed even be reported here? The MAC and PCS still need to be
>> configured for XFI.
>> 
>> Another problem is that the rate adaptation is supposed to happen with pause frames.
>> Unfortunately, pause frames are disabled:
>> 
>> Pause parameters for eth6:
>> Autonegotiate:	on
>> RX:		off
>> TX:		off
>> RX negotiated: on
>> TX negotiated: on
> 
> I think you're misreading that - don't worry, I don't think you're the
> only one.
> 
> "Autonegotiate" is the value of ethtool's pauseparam "autoneg" setting
> which determines whether the resutl of autonegotiation is used or
> whether manual settings are used.
> 
> "RX" and "TX" are the manual settings, which will force pause frame
> reception and transmission gating when "Autonegotiate" is off. These
> can be read-modify-written (and are by ethtool) so it's important
> that they return what was previously configured, not what the hardware
> is doing. See do_spause() in the ethtool source code.

Ah, I missed that these were from link_config and not link_status.

> "RX negotiated" and "TX negotiated" are ethtool's own derivation from
> our and link-partner advertisements and in no way reflect what the
> hardware is actually doing. These reflect what was negotiated on the
> media between the PHYs.
> 
> See dump_pause() in the ethtool source code for the function that
> produces the output you quoted above.
> 
> Phylink's "Link is Up" message gives the details for the link - the
> speed and duplex will be the media side of the link (which is what gets
> passed in all the link_up() methods). The pause settings come from the
> media side negotiation if pause autoneg is enabled, otherwise they come
> from the pauseparam forced modes. I think this should only ever report
> the media-negotiated settings.

[    8.029403] fsl_dpaa_mac 1af0000.ethernet eth6: Link is Up - 10Gbps/Full - flow control off

So the pause parameters are still off.

> If we need support for rate adaption with pause frames, then you are
> right that we need the MAC to be open to receive those frames, and
> right now, as I said above, there is no support in phylink at present
> to make that happen. I'm not saying there shouldn't be, I'm just saying
> that's how it is today.
> 
> In order to do this, we would need to have some way of knowing that:
> (a) the PHY is a rate adapting PHY (which means it must not use genphy.)
> (b) the PHY is will send pause frames towards the MAC to pace it.
> 
> This would need to be added to phylib, and then phylink can query
> phylib for that information and, when telling the MAC that the link
> is up, also enable rx_pause.
> 
> The same is true at the PCS level - we don't have any way to know if
> a PCS is doing rate adaption, so until we have a way to know that,
> phylink can't enable rx_pause.
> 
> There is one final issue that needs to be considered - what if the
> PHY is a rate adapting PHY which sends pause frames, but it has been
> coupled with a MAC that doesn't have support to act on those pause
> frames? Do we print a warning? Do we refuse to bring the link up?
> Do we fall back to requiring the MAC to increase the IPG? What if the
> MAC isn't capable of increasing the IPG? How do we tell the MAC to
> increase the IPG, another flag in its link_up() method?

I'd say that failing to bring the link up would probably be the most
reasonable thing to do in most cases. The IPG would need to be increased
to seriously unusual levels for correct adaptation. DPAA can't have an IPG
over 252 bytes, and I imagine that that's a fairly common restriction (though
since you bring it up as an option, there probably exists a MAC supporting the
10 KiB IPGs necessary for 1G over 10G).

>> Maybe this is because phylink_mii_c45_pcs_get_state doesn't check for pause modes?
> 
> With a 10GBASE-R PCS, there is no in-band status on the link, and so
> there is no communication of pause frame negotiation status to the
> PCS - meaning, there is no way to read it from the PCS.

Yup. I tried enabling autonegotiation in the PCS but got nothing.

> Let me be clear about this: this is a shortcoming of phylink, but
> phylink had to start somewhere, and all the hardware I have does not
> support rate adaption.
> 
> I'd like this problem to get solved - I have some experimental patches
> that allow a PCS to say "hey, I'm doing rate adaption, don't bother
> with the MAC validation" but I get the feeling that's not really
> sufficient.
> 
> Anyway, I'm afraid it's very late here, so I can't put any more
> thought into this tonight, but I hope the above is at least helpful
> and gives some ideas what needs to be done to solve this.

I really appreciate it. This has cleared things up for me.

--Sean

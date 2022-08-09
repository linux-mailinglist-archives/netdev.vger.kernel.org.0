Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE10458E1F1
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiHIVlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiHIVlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:41:09 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20081.outbound.protection.outlook.com [40.107.2.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A07550B0;
        Tue,  9 Aug 2022 14:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XklyTNdiCf+JRWIdVnOX+0Ggy+Pg48TOx81vzhMEo+msOBaGFL0Pg3YKv4q+z09KYJAnDao5KOmNHQsmFz08GS3es3wl/Uc8rhWsXJuZD2nh59Vi/hUs9FJUn2tL+/+abM8HOWua1EekE5fr+ZsDgrpSPV20MD5fybi9OmZ6TQDFb9xLJethPSioNTFrvEBnEAoMSxzSF0T0h9HUgkX7HC68QJdve+Xly93+FARVQwXQaC85HypXfZKvCfRDngv7FHgMRn0I9/GBYPO+AplsaV1llG28P9U0B0ckkzpA0v8g6c+OhHWc8L2liVh1+HCeKDjpVZ3an1b4LyLpk+hHIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzjwIP2X/pct6Qjd+1QU8VP5CuWRRLlQs1AzvA+TXqI=;
 b=fz1lWpKV57ZOC540uOhJ/6Jk9eWp9ERWBYxTR7cjQEAzo8XzHnNQpsqo8hxsLth8u6ExoKS2FhP9o/l/aHSpq/YVWX229YD9NktEMy0oqfQiauBRfCoePvbtHdikX+f1VO6VvmiP9vfH40uMcgYHOuSLuR5RJJUdLBdUj7++5ShCw2NtFVqEKcnJLfjzAjulOLH+ahDRGFktY6V5K81Z2jGYr8IC23IlZOQWRa1+S2FCfhx8S+k87vOWuQalWxp5Db4QQMnSt+M37jufQwo+DeSngZnWKxbnShCyXt1a1lD4Nd5/nFR4fJqNTLs4nms2KiD1LjT0kLm2sxeoGRuU6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzjwIP2X/pct6Qjd+1QU8VP5CuWRRLlQs1AzvA+TXqI=;
 b=fJGxKJrQcJw7dbLaqlDgZb9zrqMUn+FC+0bjyF4Vk4VJRK9r5M4lGhxZ04Fni4X9pEfVyYoxXTo6ZpjY54HBlbd41bZj3mDmSFmDoVwnG3XkiA+bSp5VdiF50hZnONY7x9mpIE6xy7TT3DejESVldI/ehjYcfLscn0U8vLny3qIc2b9kBh5TzII9m629CcnTixBGsDWnFD1ty77sNV+M7t3ezkLDqq/epCoScEbR+PkzUym3e0K4kHSY3DJZHSuhfj3rgul70JM4jt+oO+JOWUllwM/eSFXp6RFg92kPXzPz8iHTNzyZlqLWE5aXbNzZaqNFPmd9Md9GdjuvpOO4ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB3877.eurprd03.prod.outlook.com (2603:10a6:20b:21::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Tue, 9 Aug
 2022 21:41:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Tue, 9 Aug 2022
 21:41:04 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <CAJ+vNU2KwKYiTbPvsSufrjVsHw0JVfQRog__HZZ8qb+gG0HehA@mail.gmail.com>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <a20af511-7091-b5e1-7dd0-30a177cd6ba7@seco.com>
Date:   Tue, 9 Aug 2022 17:41:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CAJ+vNU2KwKYiTbPvsSufrjVsHw0JVfQRog__HZZ8qb+gG0HehA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0299.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::34) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67d63f9f-6c3c-4ce0-94fa-08da7a4fdc16
X-MS-TrafficTypeDiagnostic: AM6PR03MB3877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mms+iJdm2tDqTt1lQAsKC3DNPQm2h2zX8lSbVyTw6Fznbt5ygUjlRnIZqfqtS5b9iaB1SjwyqbR1gedoXVbJJgf7iNLbrtVwSXxhFOeiedaigjB8gYqXF0STaEgb+8EbnBjANDoaQcEA3Hgy/yfxhMqJAe9jCH0z7WzDkaMtUjKEUmXlbxa+Zi885Kct30LWSkPnGOn0jfyZsBiJUR0W5IVbnr+mLeN8BrTzXnhGwgMCFvr+V6wOR3aAB6juDm+a/1GLOtdLMov67JaKCSDMnMiXxHqddloQK+diu+j2RKxid6oy2Xq29eb8GVCtL9hGt7ZVCf7WVBNeXz/RS1QIJJer47i7GEAZYnAFuGm7hyOGu7ycxKuFZHtrSI84GqsbpUbMDFiCYb96TWlMHYahqnRWXNBiIpnjo1A3N5gA4Kri65EG/Ych/5gBc/X0NFZOkq/hoah1M07bFWqsWEOhEifFdRpMEbmqkXdOBiG8VadpH6Xx8Up8d00RjMoW/E9/Mr6KCND7NU5iKouR9jTC//2uR8jxfGGPCqE5P+uej/cUxalX1OzO7WLeqL52sKKTT2ynP2I+WmwgJP4YqhayyX3ww1YVYiEBryVSCW1HD6J5BUmIu6WIApdeZnS2uAkqUKOYMCp2UHk+1YJu2p6beGF1JwATdYMprO3M2vnnj0dVV7K46SZlQ5MYB3n6uLc4eLpGKqTSC2WNO82qYjL0t5ICdKtEpmW3e1fbAXA0FEpteGLWF28doPktZ4xsMOXZODD6kRCM3B+XDptM5yeYWSgC8fBBtwt9XoPFuL7POU75jIpMnqDfzvxA1mnYyZCk71cAaF6vS075J3Rp4H7vAwOdJ3p9P1n20QM+i3fzgHC2sQlaz5L0kBT0dtv4rxtgoqt56o3w6WRJrMaUrEZNsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39850400004)(366004)(396003)(2616005)(8676002)(26005)(6512007)(186003)(36756003)(31686004)(66556008)(66946007)(66476007)(316002)(54906003)(4326008)(31696002)(83380400001)(52116002)(6506007)(53546011)(66574015)(86362001)(8936002)(41300700001)(6666004)(478600001)(6486002)(966005)(6916009)(2906002)(38100700002)(38350700002)(44832011)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2xxOHV4dzA4dUY0dXZMM3dYU1lNWG1OTUE4N3REVnBpQmFCa0gwWldsOSs5?=
 =?utf-8?B?SGRBZTRoRGptVWhRcGV0Rjl0K2plSnd3QzRqdENkeSt4dmNieGw3TmY0QzR4?=
 =?utf-8?B?blA0bG1PSFA5eGc5NkNTM3VmMUlsSmRpNll3a0JyZ3dzemF0MDc3N0x1eS9o?=
 =?utf-8?B?UTRzelBWME9aWWRqMWlGV3MxbUJBejJDd3RWN1B4MDVWSEFnWVlhUTFlSjF4?=
 =?utf-8?B?RjB2N3h5aUZ3WjFZK25oMjhFY0s2Z2FYK2pnMFlMU3hVVlJEOGptL1E4Y3Q4?=
 =?utf-8?B?eTl4U0FTRS9OQ2IvMkpIYVh4QTc3Nncxc3dGTWRLM2V5K0tkNk5kS09yUlZL?=
 =?utf-8?B?SXpVR28rUW5QSW02R2YxOVpIMXNVTlB1RVRITFpmZ1Z0V2ExOFljYklvRE9q?=
 =?utf-8?B?SHp0SWYzWFd2YnBsL3hSelovaWxmdTc5ZEUzQzErOHo4Y0VwRys4UEdiNFc2?=
 =?utf-8?B?SHh2NTZKb0UwL1RlZStNbmtRbnl5dkhHYmtNajdCdlQ5dGpSOVdKaGxyM3cv?=
 =?utf-8?B?eHFzdThiYXNqYWFNNjlUaGx0R0ZPQ2dhZUozNkJyckR0ZGl2ZE1FbURDbURq?=
 =?utf-8?B?ZjhOS2ozRXZLUS8vUU5FL1NPQ1J0L3pFNUwweG9jSXU5M2dyRjNoT2NTU2ly?=
 =?utf-8?B?T1dDWHRVbUU3TzZOODVreHJKVVZMVmtSbWRTVXZxeGgvTlRPVi9WM3VqOHZR?=
 =?utf-8?B?ZS9ONklVUzZVWm96a3hmZDJkTGdZZHh2bGszTVl4dHJ2Q2diSStCcEpKLzdi?=
 =?utf-8?B?c1VxRU4rTEoxa0dBdmxrN3NHV0pYeHdaOHpBTGcwVUdwcXdnaHlaMjZlUFpj?=
 =?utf-8?B?NVN5R01mNmJFMVBMS2Jtak9TSkFEclRTM0ZZQkxQMXYxMkZNTnZJa2hMekJs?=
 =?utf-8?B?OXQ1R3RUemZSd3lnM1hyTWd2eXNxZVJBTnhXV0dlcndOZFJyYnVrMHNPVTNT?=
 =?utf-8?B?WjF0Q3VYc2V4VkpoclNESUNzeC9sK1ZXeEtEYkZvQThOdWc4U3U2QUpnYUFJ?=
 =?utf-8?B?aUs5MDlhTytTa2NOaE03VTBCL2IxZlRUZkJFUlh4WHFTWXEwYUFteUhYcVlB?=
 =?utf-8?B?SGtKc090TzRhOWlheFlVN1kwWVRaYkw4cjFaclR1Rk5uc1RlVmMzcU10U2pP?=
 =?utf-8?B?ditmWm8zSEJYVklXakNQc0U5NHl2TFQ2MlFkYmwwTTBZRlBOUXBFa3poM3Fz?=
 =?utf-8?B?RFY2ZEdEOXZ1NWs0UWZZdFJuRFp1bS91N3EraXRvOFJRMzVoUkxrdC9KWFZG?=
 =?utf-8?B?Z2tMMVV2UmUzMmFBcFIwMFJmbWRFR3RLZTZPUG9Ecm1UWTBmcDZSWDdqZUdm?=
 =?utf-8?B?Sm5qY01KRGJoVDJhamNnQ1AzZDZrMlp2dm1WMitCeXNvZWp6Mk1lV2JmR0hN?=
 =?utf-8?B?QmxUVWJxNmdZaUhZbU4wa2pJdzZWWnhvU0xmUlZTUFhqOEk1YVBoL0dQaDFG?=
 =?utf-8?B?eEJsUjJXNDFld3JueDh6TFQ5WnVYV1dMSjBabVpLaEFaZUx3SWV6bUorQUpW?=
 =?utf-8?B?V1RYZW80dGZzeDkrdzJMR1FLOWJ0dFVIUlJHalNPd3JMT3htM3NydHMxQVFh?=
 =?utf-8?B?RXptTExCbEhtd1N6UzU2LytrZzE5TTBhMzMvZ0UzRnp2WnI4Y0oyU3Zod2pt?=
 =?utf-8?B?MUkrSEtjR3dJVW5mZy9OaTNONTRKQU1mRnFlK3dNZzJLaE9UNTNvVVpnSHlj?=
 =?utf-8?B?NDJWTitWMUlIMm5qOUlmNHB1aVBaS2wyNFhvVXpOOHZVRlJUcjBtaEJwOTh0?=
 =?utf-8?B?L01JVktDTy9XQlpnVlZWNFFSelJRcnBTTVY1UHAvdGhJdDNnb3JxaEJnaG5N?=
 =?utf-8?B?UXpzSi9VMVlvd3FUV0dGclcxM0NUc2drdGE2bGxOOFFwQXZxVUlPc3htMksy?=
 =?utf-8?B?b3A3S00wSzI2dU51bkgwcnl6bmt6UEc1UFViVlAvRlMxR08vcFFrSEk5Rk8r?=
 =?utf-8?B?NzltZnRLQXJHUUtCTlYwQ2RQK0JET2VrWXdiR1NtL0dndkRudFFLcWFsY3Yr?=
 =?utf-8?B?TzE5Mm4wTmZDMTk5SHFJYmhZYmNFek1XYy9xdjllSmUybVhEZnFsenlTRnFu?=
 =?utf-8?B?NWN0Z3FqOFgySE1hL040ek1jWC82R3lUVTJFNmh6SHhFTlRmbHJUUCtkbGdj?=
 =?utf-8?B?a25HaXZYYVpnTGJySGkyYzlJdXZjM1hZTUp6U1FxUlVjdGxrVSsyeVZqRy9O?=
 =?utf-8?B?Unc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d63f9f-6c3c-4ce0-94fa-08da7a4fdc16
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 21:41:04.1225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8MLZJyg4BPpr9S0+1bbCzYXlnNskhjNqWZwR+LrIN20V7WiXlOv//NsiHAvaI9sAdtLVrX+p9QiVO6hsJtEsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3877
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/22 5:35 PM, Tim Harvey wrote:
> On Tue, Aug 9, 2022 at 1:48 PM Sean Anderson <sean.anderson@seco.com> wrote:
>>
>>
>>
>> On 8/8/22 5:45 PM, Michal Suchánek wrote:
>> > On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
>> >> On Mon, 8 Aug 2022 23:09:45 +0200
>> >> Michal Suchánek <msuchanek@suse.de> wrote:
>> >>
>> >> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
>> >> > > Hi Tim,
>> >> > >
>> >> > > On 8/8/22 3:18 PM, Tim Harvey wrote:
>> >> > > > Greetings,
>> >> > > >
>> >> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
>> >> > > > aliases in Linux such as:
>> >> > > >         aliases {
>> >> > > >                 ethernet0 = &eqos;
>> >> > > >                 ethernet1 = &fec;
>> >> > > >                 ethernet2 = &lan1;
>> >> > > >                 ethernet3 = &lan2;
>> >> > > >                 ethernet4 = &lan3;
>> >> > > >                 ethernet5 = &lan4;
>> >> > > >                 ethernet6 = &lan5;
>> >> > > >         };
>> >> > > >
>> >> > > > I know U-Boot boards that use device-tree will use these aliases to
>> >> > > > name the devices in U-Boot such that the device with alias 'ethernet0'
>> >> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
>> >> > > > appears that the naming of network devices that are embedded (ie SoC)
>> >> > > > vs enumerated (ie pci/usb) are always based on device registration
>> >> > > > order which for static drivers depends on Makefile linking order and
>> >> > > > has nothing to do with device-tree.
>> >> > > >
>> >> > > > Is there currently any way to control network device naming in Linux
>> >> > > > other than udev?
>> >> > >
>> >> > > You can also use systemd-networkd et al. (but that is the same kind of mechanism)
>> >> > >
>> >> > > > Does Linux use the ethernet<n> aliases for anything at all?
>> >> > >
>> >> > > No :l
>> >> >
>> >> > Maybe it's a great opportunity for porting biosdevname to DT based
>> >> > platforms ;-)
>> >>
>> >> Sorry, biosdevname was wrong way to do things.
>> >> Did you look at the internals, it was dumpster diving as root into BIOS.
>> >
>> > When it's BIOS what defines the names then you have to read them from
>> > the BIOS. Recently it was updated to use some sysfs file or whatver.
>> > It's not like you would use any of that code with DT, anyway.
>> >
>> >> Systemd-networkd does things in much more supportable manner using existing
>> >> sysfs API's.
>> >
>> > Which is a dumpster of systemd code, no thanks.
>> >
>> > I want my device naming independent of the init system, especially if
>> > it's systemd.
>>
>> Well, there's always nameif...
>>
>> That said, I have made [1] for people using systemd-networkd.
>>
>> --Sean
>>
>> [1] https://github.com/systemd/systemd/pull/24265
> 
> Sean,
> 
> That looks very promising. Linux is definitely flipping eth0/eth1
> between fec/eqos for me when booting an Ubuntu rootfs telling me that
> the netdev registration between those two drivers is racy.

Yeah, I always end up creating either udev rules or .link files so I
can keep my sanity :)

> Can you give me an example udev rule that shows how to invoke the new
> naming scheme your adding here?

I believe you use 75-net-description.rules, and then ID_NET_* will be
available for you to use in your rules. You can try it out manually by
running

	udevadm test-builtin net_id /sys/class/net/eth0

--Sean

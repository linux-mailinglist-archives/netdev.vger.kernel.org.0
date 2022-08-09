Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00CC58E1D5
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiHIVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiHIVhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:37:02 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10043.outbound.protection.outlook.com [40.107.1.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E19E65665;
        Tue,  9 Aug 2022 14:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJM6Fl/mj/SofXGvlJOlGTvWdIibOZexQyfUyU36gzeSWDNjkYeCMXgKVGflja5sJ+M7tDWMJZsC/xNTli/pqInF2C8ttjHIuo/aH6SWO2TIj5Kw6d+Qgf9ICy9MqMUD6P0s2453YQU8MHG/6KuShkyP5w1cizLgWSSBR4hmX615JyffQQ6f7sRGSbhA+d1JV4QmUWiqJl1EHq8HOZkCYCKi5TmvD8ZRisjMBx6D1HRzKfuJjqWLTCA7UjnfjxWvLwhhU0vwECOBG47Uhr4YxGem3hBeDppltRplBMIwvwjkIou9VFRvXa/6E5hFQhbgEEKHIbc/aikbkh9fjv4tDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/b8XYUZHYz8HOYBsJPDHrsxcs4tkOG5iD5GGsJ+vn7A=;
 b=U0jm2EYKjQ5QM4AqZFwZdsNpL17b0esirVUnlBg/Ep5DPU1VEpAsYIEGbRbwwCRl//2M6HCq5dAACwk/BjLDOF8R+ypkIG8c8J85zUby7vJFHuHkpeHGRFLwzrGOr+gfxjcTEudUSK3JStWnUmgxEApZpdLpuIMZ7xPfSJ889kiT2fZqXDMWLrky8g1D1sureyZR58ke0GDHfWiD3RqFRJ5vevdJ+DK89EqSNuvF9eHlfrB8E0MN24dXwEHE7vcgIu5P9buIVc0JijfKS9we7e8eo9WUzPYRj82X+j5M8Tpk5OrOFIQx6Dg0HBAnzDgUf6n1HfxW2eS0A5z27S/w1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/b8XYUZHYz8HOYBsJPDHrsxcs4tkOG5iD5GGsJ+vn7A=;
 b=TzNb81p9PRCVResojvdebIl8EC+yc6KyHw9HtpNXgzKYncjMSZYch2ZCCE+ruUwMOJsumjXhAEry79+HfQOYOwZQtGF5IOPEOH+DHJTw330A5asfgcPRW1H/i5wOVqhmi6g1hB7m21Z0RdNXyYS+cdR1gaS1Rh0RPf1X0jG9cdqBIO1/yO+kYsJUmVdEpRlf8ZvG3e55vZdTSkXpVoSmh6znouhgaJRGs9NqnIJtzLXeIKmB4Pn0pFBc0ymZARwshsPVvaypSBTNsYkdn40tk2qdJA4ghr4B+k8KiqtS2FmLnzUkSqQyue27Y2hC0FbDH5BR/UKpdHAEEoP4H/gysw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by GV1PR03MB8686.eurprd03.prod.outlook.com (2603:10a6:150:92::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 9 Aug
 2022 21:36:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Tue, 9 Aug 2022
 21:36:57 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
Cc:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
Date:   Tue, 9 Aug 2022 17:36:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220809213146.m6a3kfex673pjtgq@pali>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0003.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::9) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccc079a0-950e-420c-6240-08da7a4f48ca
X-MS-TrafficTypeDiagnostic: GV1PR03MB8686:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lhq5DuD93oGcvD9hWHESvN4icqRel0/rkq9nZ6KfTzt05m6Cvjvzd1U6+0Ovgf50v+/nzk1o07sniTlYrChRzBwdseG7XMyyNYZlJid5ZqcuzJgB7B9J83TuhDEz7HUTjjtTw8R1NWDEWbYeYXxJppEUWEAaj+jxwaMjWDtlZuXMAZTFO/y3jrfrrg67buMSSWNcuGlyKYElu3LsAZRxZJCeznRXhHxq0QRW1ncO3X7qWi0P3GB3rRHGfprsTAkPMzCbLNoIKeIJJ4XciuzI3T3KoC3MLLV9MLfukVo0U6Vt9e38UdHh/jd9vArgkQR3GJfWQvYtrcDM7cNNX4QdK84eDJgKzM/talNJgs2Xfd+rKWsHM6G8AzG2xFX8/ItSbGFl5543/JlHl3G3PQey5OVfa4Vz2aWUQSE7GWP2cUZQ80/vWwc2zenZLOnfWC/Gyt/U3LNlPhC+3B3CXVUP77jR7evm4d40a3BCaIC8hr2utkQCx+UXwdL59QyfveIcpugu+Gyy3eBGMcWYSIrWhVJhhrdW5XVZQEANQqVwwOtZavRciyEkWDq4a2/IdLc0asMVzrTiX+dSTCbVrA5DbzB3xSlP9yhviKVRZcru5MTtLEhm5HqZ9pfbpgmlfT2haxDGWF7TC73SqgckqvANIbxk0cfvR6z70Y+MurI78QKzq8ZszGNhoNtExLFyxnfVmBfe/fsrgWWB3xHKOrT6bi9kwlPYlWLVXHJ/Bk8RsCjO8cga9oDpE5JqHK4bfHTKzKbAoGTKY0+dNBwPcflr7Qkz7vMPArTgrN/EBZYk5p43WuCSOirrLqV5dNS1eWiR2KNXKglg3BlaWpwqrUHL424SoBrikF9qHwRrDoSb7nR7No42K75BT+9mZRwYI+onTvqHZBqK47BYm/fztEe9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(376002)(396003)(136003)(39850400004)(2906002)(44832011)(8936002)(66476007)(6916009)(54906003)(478600001)(316002)(66556008)(6486002)(5660300002)(31686004)(966005)(66946007)(41300700001)(6506007)(52116002)(26005)(6666004)(53546011)(6512007)(86362001)(31696002)(2616005)(8676002)(4326008)(36756003)(66574015)(38350700002)(38100700002)(83380400001)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUVkYlZ1eEZRZk1SaEx2ejJUU0FvNVZWanl0aXlXWTJ4b2FmT01VdlFDUUMy?=
 =?utf-8?B?UFBBM0w0eW5kK2pSMXFMU29KTzUrWCtVZXI4T2NlRVVBRGxJUmJScHJmTTM2?=
 =?utf-8?B?UTVHL3dmVEowTkhVL3dTU2RucE5id3lsSnhNR3J4WTYrZGxBZkJaaDlyM25S?=
 =?utf-8?B?OTR0VytnY2VVbzB1b1dRcjN3YUlvY0tMVWl2ZzVTUTVoU3hRNk1PTGl5dllj?=
 =?utf-8?B?RllIc1FZN01rNWkrd25XM09PRlFlcTNHbWN0cS9jdDhxSjNYNGtVcW4yK3E0?=
 =?utf-8?B?Ly94T0JhU1laL1BDN0ZNNWE5RFlDaTVEOG83eUFYRlJMNkpyQ0cyMjVWRG5Z?=
 =?utf-8?B?WmVKZkdqS2ZlRnNGWDUyTWdTVis3Um9tekZvQ2hkNzY0WTRFU245NnpkNWZH?=
 =?utf-8?B?NTA2SzViR0dvV0RLanBZY25wTTVqNXMxSHlycmE2czR5T0k4Mk1EKzlRRzBx?=
 =?utf-8?B?UDNYTWtKVXJjY1BzYWxsZkJYUVhrcis4ZlJqTSs0L1U0T0tvRThhYzJCa2Ni?=
 =?utf-8?B?SFBESmRoTHJoSGtlOElONk1sUUp0Sk5zOGYzSFVBdnI0eTVIUnpRVVlzYkNo?=
 =?utf-8?B?OXo3NHQ5RzljY0ZRSFM0ejNYM1hvVGVyUzFYQjFpV0FVQVhWZDRsVTh0dTE0?=
 =?utf-8?B?ZGNoSlRSd01TdGhZVlZyMlNZMWRVWVUxMEROU3pEcjZ0YlJNLzZnU1ZHNTFp?=
 =?utf-8?B?RUx1bElaZ2pPQ0lzVEY2b2pURDByNldwNU9PVmkwYnA1ZzRoNW13bGxXMXMw?=
 =?utf-8?B?TEpsRWtjbE5JRkpaNXh1eml0RGRaOVNNaTVCMjR0L0ppaXJUdzFmUmh4VFBN?=
 =?utf-8?B?RlFKZlFNbUI3VTc5TUdJcG9tOE9nREdTdXpna3YydVZIRWZoWjAxT0V1bk82?=
 =?utf-8?B?dHZ0Y29kMVdoWWtmenlyWW0vekNjM1BjSEdLOXZxaVBwY2RHMmZFU05DVHRB?=
 =?utf-8?B?RFJmZE5VOXNlSU9SM0pPMzIwOTdlU3p4S2lzOXpYTFFSRzR0MDBuUnBidUxP?=
 =?utf-8?B?WmFORmUwaFFsMFVOTHpFZUl6amV6MkpvUGFrZkJONENQYkF5dWxNWnVFYVFi?=
 =?utf-8?B?dE1Yc1ZtSlpLUTVIdGg5aXdhcy9pOFpwY3NaRXNLZmVGQkFpb2hKS1VtYTFx?=
 =?utf-8?B?ZjlBUGQzN1QvSTgzNlhnVFJhTmlvSmlTQ081QjNEMFhWeDhDQWJzZml1VHpw?=
 =?utf-8?B?Ykt0UDNkTzF5TSt5YVpFZ1pwTStGc09pRHFESDN1UnpiM3RBWXJVZjljZTRV?=
 =?utf-8?B?d2kyZW44Y2RlSDYyS0dPRWM3QUIxSVRSeUw2cFNrWWFkcXNqKzJ3eEM1YnJm?=
 =?utf-8?B?eU5JTDlnQjYzUE1SYS9NNjVLYmNNVWVZallhbzBCWVFuVzNmSStZRTRpNUhZ?=
 =?utf-8?B?a21zaUJ6QXc3TXRyL1hSdDhKclkzMmpvallDaFEvVG8rTGlMRlRhZFYvcEph?=
 =?utf-8?B?aVozRDRpY01SQndLZGxGNFdvTlhzdjFzc2UyTkJ3RUIyaTk4OXFVQVRsQVhO?=
 =?utf-8?B?SEZSRVhJWk43QzJDYVNCWkJHdTk4MGlSMGFDcXl6dVZrWWdpYjFyYW5Ha1By?=
 =?utf-8?B?STN4a0NvV2xKS0tvSU5aRWpwNk5XQmc0ckhTeUM3Z09ENGlkUGZQa1VtZWYx?=
 =?utf-8?B?ZUFLcXNUc2E4a0lyTDJMaDNVb2Q4dFoyQlZBb0ZOU3p3M0VKcEZMQXZ5ak1I?=
 =?utf-8?B?T0xyTkxpM3ovSHRmSFN2Q1ZWUnpwajJtQXJnUzhNMVphNXpLOXZKYWNKc3FO?=
 =?utf-8?B?QWhsVVd5OHcrNkprV0xwcE13ekx0UWtNVUl2dkVDWmdCREhOalpCYWorQVo1?=
 =?utf-8?B?STJZMkRyZzVvOE55enFpY2UzR3MxNkZNdk1MREsxUEJrT09xWnBCVk9TZjZp?=
 =?utf-8?B?Vm1MQVQ0VjZ5YVQ2N1RQTlFNUlhHLzhFajNuSjF0QlJvdWJlRUVaKzlMRmkz?=
 =?utf-8?B?dnZJbURrTWY2eFg4OTY4UjFlc3V6WlptK0U4UjNwcHpUOHV2ZjdCbkIrcEhI?=
 =?utf-8?B?dy9LSlkvVklnS0JwcnNKazk0ZHd2dlFZQk5tRTgvVFROWWZJRGNHazVQbE1l?=
 =?utf-8?B?VDlGWEFiUmFxSlUwZ2x4bmY1bktRUDE1OHM2aW5LbHBMQUxpWmtWWnA4L21W?=
 =?utf-8?B?T2t4Z1dadmNzMU9rbTFGb1NucjRhMytEaVNLMll3QmtKVlEra1dPa3I2RjFX?=
 =?utf-8?B?Y0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc079a0-950e-420c-6240-08da7a4f48ca
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 21:36:56.9824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z1sR/Bp9v9Pq+YEjMz5wrK1JU1MN1UMffgUwqQRcpLXCY3FENvy0Go5FwFdASXI1wIztkDA5A/rsMwlVmAoUjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8686
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/22 5:31 PM, Pali Rohár wrote:
> On Tuesday 09 August 2022 16:48:23 Sean Anderson wrote:
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
> Hello!
> 
> In some cases "label" DT property can be used also as interface name.
> For example this property is already used by DSA kernel driver.
> 
> I created very simple script which renames all interfaces in system to
> their "label" DT property (if there is any defined).
> 
> #!/bin/sh
> for iface in `ls /sys/class/net/`; do
> 	for of_node in of_node device/of_node; do
> 		if test -e /sys/class/net/$iface/$of_node/; then
> 			label=`cat /sys/class/net/$iface/$of_node/label 2>/dev/null`
> 			if test -n "$label" && test "$label" != "$iface"; then
> 				echo "Renaming net interface $iface to $label..."
> 				up=$((`cat /sys/class/net/$iface/flags 2>/dev/null || echo 1` & 0x1))
> 				if test "$up" != "0"; then
> 					ip link set dev $iface down
> 				fi
> 				ip link set dev $iface name "$label" && iface=$label
> 				if test "$up" != "0"; then
> 					ip link set dev $iface up
> 				fi
> 			fi
> 			break
> 		fi
> 	done
> done
> 
> Maybe it would be better first to use "label" and then use ethernet alias?
> 

It looks like there is already precedent for using ID_NET_LABEL_ONBOARD for
this purpose (on SMBios boards). It should be a fairly simple extension to
add that as well. However, I didn't find any uses of this in Linux or U-Boot
(although I did find plenty of ethernet LEDs). Do you have an example you
could point me to?

--Sean

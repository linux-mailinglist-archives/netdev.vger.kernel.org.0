Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A03158E156
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343846AbiHIUse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242698AbiHIUsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:48:31 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00068.outbound.protection.outlook.com [40.107.0.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698CCB0F;
        Tue,  9 Aug 2022 13:48:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIAoZDVSnPJEEXI4xttVMwiBzaqRv2y3Dd4z89ZbwXo38ysjsNmCMmVCsjuNQlxpaddiFb0W4WfLujGtZVWdDabI1bK9MY2jq+7XO/YVG07SKtpuDNHCH2BnCa6R17c8brNCobnO6L7QyHI2uqB898K4mXVbL9rw3Bl8LTW2VITaIso27bEeQhTSYltErjBT5nym2keZ7yzWLVVp43PwUzrs/BFCQhyVLX8V7PQr3X+ZZvRKGfGKyEb8GLhvsnO7TFB7bsMMebVQgIcaOaUbAo31oc8MgFJwG2GpC7lXnbP86478cNoP6aaZ3UQ+J2hVQGRKlu3E0c8RX6BQM86hrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JuLduqI5UWpcSCmdwukzgjWErUgNxX1tP5RsOOqaVFM=;
 b=EErqnzQ1eFKqbldf0rw5CnCGToTqtJ75TinjtjdAJ7sRfY2w8GFZBSAHe7YvdYi1nogfx7ERmIw/qdskKvUO90gr5/iSylsr5Ovwe7wDwrg+RK8AImJNi7stSAM75a2YVNn6QeUeWJZ8sJAu8NRBgjxyPuvc/FSIgWblWM9q+4u5dwRETttGzLvdRXUhuZeV5IGODE9zEDsTd79gQJvU0cvIk0Oftj+dYy0LvfVw5Vq6KKt9I0s8aqoBcJwvtqkcvorX+hx2Q5EnHXLFmMa7LWIYApyq17i0GDfOtDvFcRGnpckUKJyECXfb/hE+NS2wG7Ip4Dg5dNZRhx8slhbNGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JuLduqI5UWpcSCmdwukzgjWErUgNxX1tP5RsOOqaVFM=;
 b=HoG7KOdr/23oYlN7H78HV2mD5hZw2/zcSVOgQ03kfU9hxiPexMrXHHTnT0QqgVxaZhf4xiMfq3QfyEB1ggGwMUelbDPGv63z3V0x9p4c8fOFILQM/E9qQuo3okagoXEla9m49yFu846AZd7R3NfqlMnnM6kW7qo7tl2m39axft+0zYdH8nQ3cIEHFRu5Sba+heecMUqVLO9EIa9FrlMhE/vM9X/2vpl5jRcH7rrxTp93GKi06BDu7ek+jeJfNEQKPqx27POwsUM0JYfow/wNdtY6aHnvpWSeUFuhL/0UYXjJoyzo/lP5diFQRoBX5K7mMy3SaWFEq1P6NgicWTZlkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7611.eurprd03.prod.outlook.com (2603:10a6:102:205::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 9 Aug
 2022 20:48:27 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Tue, 9 Aug 2022
 20:48:27 +0000
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     =?UTF-8?Q?Michal_Such=c3=a1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
 <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
Date:   Tue, 9 Aug 2022 16:48:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220808214522.GQ17705@kitsune.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:208:32a::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 79968b25-3175-4bd5-06b7-08da7a488251
X-MS-TrafficTypeDiagnostic: PAXPR03MB7611:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pFZRvSv8kfowU083LFHDyZvagu7BxRnjX3CQ1ZYlebp6Xk4HkUqLpeswCe6jS6NDe+OBW90pgwlu3cSaq+LN7XCHAmJNeDLwcKzGXpP56EcXTBHRlr+FsQfA0LAkdz3+lHfcMM2GVA0NFTpKwW4ulpmJc8QA554P1cxP5onAT6NS7bRT+hiXM050OOISIec81WFJXdckMLJ0+jGeqwLiGc6kl5vRG++EdNTTlQnjbTOIKX3W0lOKRPqeneZXN3X0UfChIQwVwc5ww0dmf/0AXFtqGAuCBTbWkZ/CByK7QTxPcBlzjQW+5CY836YRgHjaJC3ybkB3cOhiTJrZ8lozkaGQKGAcjUbEgvPp/c0IE0vyUVJ24Z/HDJY24kVHsjut9LOtLZgNhIn7ALVlU9emKcCRKed4ZViiL3uZ2cjNBiAag4u2wE7rLZoxtjBlvBPu0UONRVmqOSd3A2gGugxiCnppkNLyjI+X/0JhJnvbE/9TFKRX0rMUIqUJFPTnWL9n9q+awQ2E4jNE/0hggjYHO7nGaPMIVUt1ODv1OuxKsdfBZzBEIVfIH0UZEuMkd7KtBJMi5Qk0HwFrok+3/b9BEk74MECytCK1eIwh3/nt6nberl5ixjSqE0+XteDDUK+GUMWzWYjGMATnv6qe96LmJErD/fNaecRtaFnpnT7iuwvjsq744/qcq9TMufu1FxSNYFNTH0KuTM2zcfjFC13whthFVaalSaHSmIkdc0cG3NW0IDgNPWUWk1kf7MkYyHgm2iEsvh315+PJtZqX33NlJBL5Lu7NG//y3+8QxWcHh+2rQQJShuqZfD38Y0cvUtbc3ELf38iQqcNg+Zn62oCyyWXQB1Ahjf5NvD+jCt+sA5wkjGmFhNqdBYB/EQkPj6eASmOxnOXxvq7RqNYEBS5OkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(366004)(396003)(136003)(346002)(5660300002)(6486002)(4326008)(44832011)(478600001)(66946007)(26005)(52116002)(8676002)(41300700001)(66476007)(6512007)(6666004)(2616005)(66556008)(31696002)(6506007)(2906002)(53546011)(86362001)(8936002)(966005)(38350700002)(38100700002)(110136005)(66574015)(186003)(36756003)(316002)(54906003)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWpyTU5HWjNPU1BQVkFub0xGcGpyazZPQXZWR1BhRERrYXYrTSt6dlBlM1Np?=
 =?utf-8?B?M2xWOFUxeTd2Nk9SczlzN0gyVmhjb3FOK21QNFovTkJQR09DVDhTYUpWKzRQ?=
 =?utf-8?B?ZW5pTWJpS0wvalB0eHdjSERHOGppN2Nyei9GdElDWmJTN3htV3BDcGNCMVpn?=
 =?utf-8?B?dWZqUHYxdUtOemk2QW50OENCWVFtUWcxV2o0Z2YzRlNFZ2hYMEk2a1haUSti?=
 =?utf-8?B?RTIxUDcyTzQwZm8yTnFZMmhyY21QajhabTNSZTZLMzdPNWkybkRqb3RZUFRa?=
 =?utf-8?B?UURzRVBPUU9MNzAvMGFmTzhCcWJmZHNWdld4UEY1SmNiK3ZuYlMvdS8rYUd3?=
 =?utf-8?B?c1ltd2RJTkN2ald1QXRDRWl6RHJKTHRCWmg1eUpRdkpObGpndXdlUktHL3Vw?=
 =?utf-8?B?V045L0ZkV1JuVENnSlhVNTRBOEVzazdEbzNrM05uTHBxV09mNnh3WWlnQnNY?=
 =?utf-8?B?ZDRJdCtwK1VVUncwV0dSczJBRUZlUjVRQUh3NjJxamtxdlZ2bmVwamdYNnh6?=
 =?utf-8?B?N2l0bEEvUmJWaTRYWml2KzRDS3czSGlpeTBoaGkxZEN4emgyRXYwbmtTNU5T?=
 =?utf-8?B?SG00TzNFcUxhcXN4Y29palNyR3VNdlhHYjAxU0oveEpyY29Hb3JuWHZUVTNp?=
 =?utf-8?B?Ui9iQzkrdFh3bjRDc2FuT2VKclZlbk4xTUdHNXNPMEhNY1NDTktqRldHNFhG?=
 =?utf-8?B?eEVhSWlFb2lNemN4a2JCWG92YkdoaWFXd0RramN3L2w4cFN5K3RBR2w1bHU5?=
 =?utf-8?B?TEVzd2YrSkJxRCs5RENzSGFZdVNwemljdm44czZDb2pEYXEva0wxVUlTY0cr?=
 =?utf-8?B?dEI1M25BeVI0azh1OWNHVEY1ZmtLUWNPOHZwWnFIYWM4ekFpYkU1Tm1yTVcz?=
 =?utf-8?B?M1FMZy9rUUNsNmRDRFY3M0lxQmxrd2JzbGVUa25mQ0NPU0dKTkxsMXhsbE1k?=
 =?utf-8?B?Q3FVcGZiVDBjeDBTNnAzaVJ4eGd6a0EvUUhnSzhWZW1VQ3hmcXp5ZGxtT0E2?=
 =?utf-8?B?bmUxTFFBWEM3bnRjQTJzMTVVQkZKcStKLzBZK085VDVncTdGeElLZUViUE1F?=
 =?utf-8?B?dUlJZVlpb3AzNzNoLzV6RGsxMDRjMi90aFg4MmNNaGVtSmFYcXN2WEpmNmo1?=
 =?utf-8?B?RlZjNzltOWRaNVlQRmFVdjhucTNZR2hEeE41VnRCd0tWM1IwcGQweHhaSXM4?=
 =?utf-8?B?M25GZjhGWkVFdGtSMjExMktIZnZWQkhCbE85dXdKMkVIUjRlMXN3b0ZMN2FM?=
 =?utf-8?B?UkdsSEFubnZYKzJMd3VEb0ZrTitmUVozN05oQ0xWSjg3aW1GMStvc3JycE5I?=
 =?utf-8?B?VXFORnZFa1FUM1J0RmRjRi9OTGpRSVVmd1Z0UXU1SjdwYXNoNmZ3d2dUYmFZ?=
 =?utf-8?B?QnloT094L3FoMmNRbTF1MmlBcDgvNm5uQVJCWXhEQ3VJVjBlb1hCNGZkSlhS?=
 =?utf-8?B?SWd5YkpmQ21kNkkzc0JsTjBVVjlITU9GeTF5WWxkYUNWN0pPMEJhRkc2b04r?=
 =?utf-8?B?M0w5WVlPQmtERnV0bG9aRzdQRk5HRmJIQTRYelEyL002ck5VZ3QxczZ1U0lU?=
 =?utf-8?B?VGxPUERFY3VYckhEZksyV2RzdFBkN05JSzc4UUNHaW9YeEtDWm5qOVVpNHlH?=
 =?utf-8?B?a0RtTUh6b2pqN3J5bHg4RHdaS3l2cXRpRVh2ZlVhSjVCc3JWRnU3RHpsRE16?=
 =?utf-8?B?WC9zSGY3eHlvY1FOSVpUb0ErN2xRQXpIMVByRnhVaW50NUZBSTBXeW9sZFBz?=
 =?utf-8?B?Sm91REVWL3ZqRVdkeURaSXMxTHRwME5kb0RjaE84ZHh0YmtpTEorS08vWVNY?=
 =?utf-8?B?NWNraVZqU1dCTG56RndkUTdXQnM1aC9McHZEcVNNcGdlZmdPL3BkeDlmcElR?=
 =?utf-8?B?ME1YR2Q4TmdRVDlEYnJsVDR6N0pyYmUvRS9lcXk0amhlQlhUNHJNN1FFT2RP?=
 =?utf-8?B?Yy9oK3lKK2N0TjhmUGhJRVhMWndWbkJXSlpQNmYzQzZwTmhrbytJYzY5S3pW?=
 =?utf-8?B?dWZ4d2tDaHR4K1c0blNPU1hBbnU4Vjlvd1RzWGs5am5JWHI3MFZCNUJPMTB4?=
 =?utf-8?B?Z2ZsTEtNd1BLTzRQOUloUmRINlFNbFBtSEw5VXFaUkNJaUlKN3pEMVgyOTFZ?=
 =?utf-8?B?SkFKdFAzM1lwekpXc1BLM01CY3NwTDFORnF0VVNXUCtOMm9Idi81R2dXVm9l?=
 =?utf-8?B?TVE9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79968b25-3175-4bd5-06b7-08da7a488251
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 20:48:26.9866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pyZiV5w7vTXjFeM5rOD5TvEP8/yIDMrrH9iPAhqjd7YcQXedvwx15R8BKdCgISaSS7wnGQ4MDMDUAaYu2TVdtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7611
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/8/22 5:45 PM, Michal Suchánek wrote:
> On Mon, Aug 08, 2022 at 02:38:35PM -0700, Stephen Hemminger wrote:
>> On Mon, 8 Aug 2022 23:09:45 +0200
>> Michal Suchánek <msuchanek@suse.de> wrote:
>> 
>> > On Mon, Aug 08, 2022 at 03:57:55PM -0400, Sean Anderson wrote:
>> > > Hi Tim,
>> > > 
>> > > On 8/8/22 3:18 PM, Tim Harvey wrote:  
>> > > > Greetings,
>> > > > 
>> > > > I'm trying to understand if there is any implication of 'ethernet<n>'
>> > > > aliases in Linux such as:
>> > > >         aliases {
>> > > >                 ethernet0 = &eqos;
>> > > >                 ethernet1 = &fec;
>> > > >                 ethernet2 = &lan1;
>> > > >                 ethernet3 = &lan2;
>> > > >                 ethernet4 = &lan3;
>> > > >                 ethernet5 = &lan4;
>> > > >                 ethernet6 = &lan5;
>> > > >         };
>> > > > 
>> > > > I know U-Boot boards that use device-tree will use these aliases to
>> > > > name the devices in U-Boot such that the device with alias 'ethernet0'
>> > > > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
>> > > > appears that the naming of network devices that are embedded (ie SoC)
>> > > > vs enumerated (ie pci/usb) are always based on device registration
>> > > > order which for static drivers depends on Makefile linking order and
>> > > > has nothing to do with device-tree.
>> > > > 
>> > > > Is there currently any way to control network device naming in Linux
>> > > > other than udev?  
>> > > 
>> > > You can also use systemd-networkd et al. (but that is the same kind of mechanism)
>> > >   
>> > > > Does Linux use the ethernet<n> aliases for anything at all?  
>> > > 
>> > > No :l  
>> > 
>> > Maybe it's a great opportunity for porting biosdevname to DT based
>> > platforms ;-)
>> 
>> Sorry, biosdevname was wrong way to do things.
>> Did you look at the internals, it was dumpster diving as root into BIOS.
> 
> When it's BIOS what defines the names then you have to read them from
> the BIOS. Recently it was updated to use some sysfs file or whatver.
> It's not like you would use any of that code with DT, anyway.
> 
>> Systemd-networkd does things in much more supportable manner using existing
>> sysfs API's.
> 
> Which is a dumpster of systemd code, no thanks.
> 
> I want my device naming independent of the init system, especially if
> it's systemd.

Well, there's always nameif...

That said, I have made [1] for people using systemd-networkd.

--Sean

[1] https://github.com/systemd/systemd/pull/24265

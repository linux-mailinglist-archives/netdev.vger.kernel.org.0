Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE154944DC
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiATAkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:40:45 -0500
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:16512
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232101AbiATAko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 19:40:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUSkGw910rOs823MMCj7GA1KdTX2dazrWEYylZ4y4Qf2nvmqEOObaTxDfRH51wSSXdRMowXzLTkMTXe9cx886dfmqIGAZ4oQPJLzvaCQqgaMu5GxWbj4cemQYqpq+9cu7CyZiRFzrySNWVXp0nE+icoWnQWfSKijp2zj3GsHvB0mR4YsxrU/TiCpwaz+uKaouhy3ugmSwbZc4dh3xdamQXVHr0jbbwVqWB9tQZsgObSYyH1YUYd2ViSHil8mxLvvbdfca/S+uhsc+054rtzi2XYcdWlCBNR8ThfmVUGeDz+M919xOUi0n+feIQqSvHYfApJTTMAJN/ZdwH82ezl5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCJB7NO4hQzS68dWNfRPPVU78cvopldIeaitidxe4+8=;
 b=Yzxd4wTKtOgnIItV8uCBi3P3WU/qBL6tiHhNdCuzG6VuMJAGF8wMPjXOdAgFBqDOcKsOQTlBC1WycrwpItZqHhCPUbgr5fYQc+ucn+vKfCMUCwcNuIEbKu0/yGSpqa/y1nbaUG724yclxRIIizlADNoRTQOUqsNUEceGPklxBi/d3VN/vxITSyJF/S7oDxr+gg4W/9469DKbJiXwEna0ugMRe0TrBoHjwes+xFVstmdU60WWwB7ZnypFNCh/ol++T8wWoveTgoMRSm8ZKKnG6zPo8yd5rBiGFVhXHuyAkpSPyCBqKZf9UBqceRsBQXQrRhZF52bmSs05rGinYNa4Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCJB7NO4hQzS68dWNfRPPVU78cvopldIeaitidxe4+8=;
 b=WEmOKjVSf85be/gNMnjkG/a4GRCliE9yHD6nRSmM49lYl48dgymjkeVi3N4FlB2R/Ha0rTpX7HuRmmQ6hDZTXcOWI1MIJSkwFQzymXYd3BjKqnQH25zIg67fc0WdBwm+uiCheB7vrC2QD/B/A/WiX2ObEkPE/kgZC9z3uT7W5/9rtrv++3r5Cin1D0Hb0sOl2Q5jp/6LzisWWL8mjkmOWVMpH5I4MrmbJdekhESMLf9osK3okLRFG4K9ymuaUJQdeH5dJ3S2uCvZifIBt85TsMrBWV4/zEM3T0tcn2z5gXuRh1lCS5I6gA2EbbnwImdQ3OqzOyZPTGxg8wN5DR1DSA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY4PR12MB1608.namprd12.prod.outlook.com (2603:10b6:910:d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 00:40:42 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%6]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 00:40:42 +0000
Date:   Wed, 19 Jan 2022 16:40:39 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20220120004039.qriwo4vrvizz7qry@sx1>
References: <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220115061548.4o2uldqzqd4rjcz5@sx1>
 <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
X-ClientProxiedBy: SJ0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::29) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cdda048-921d-4b97-eff3-08d9dbad7c61
X-MS-TrafficTypeDiagnostic: CY4PR12MB1608:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB160897FB47E52EB16821A6C7B35A9@CY4PR12MB1608.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oL0H1uebDn1hmoAP51wo2cipwI1+6ow+Q8uTs5gxgZVy39QJSDnYaqbPBMW4tA3GrCNvmy3k3Td1S1/8jzclpLdsIKTQZIVwWWN+oyZbP4cupT3uqjrMKM04xGFA5g/QzWM22yjEfZoO2WMUH/xXtobFibWiv8IafXXSg+1j3MXM5E66VPDNmlb8hHVWr8+KKg+wWsqlUyUvCOjpPlBOp6vqEu2fEhuJfha8EshCI9UeX7VToQBVcNy4F9Ds8JN/ttGebIFajP74kc3PGZrNVrdt3xD8iOqQ72uPm8Sn3894FcmLT7uWsykWrPfWDi1riGaf0uV0nNUE5BK+8y8+kr28LHXStUZzJM7vQe0rQJHFBkEeKnijid3o99hBbyCzEKqIRBmEHsW93XoHDLLeVSWebXrA/iEIPnKJduk21m82GJ3wKg0fsxHx6YBDFKVbp2I9sjGnpMLmSP86vkE2DxZqejWGwBLSWwZtEBRHWXTamNAgWkmULiOhxmKONvXpPH6g8PhJ8k7gFsSO9qfY3OY5zbTjzgUbvMZS0VcYqwrRDkjcJQeCaPgPowH+2Y3IupD0SNW/n2qTXb5lWarWpgMyBajxLs3/XWh/kACO/UuFCAJDFXm8TUdEA1vwOU1AlyNeTZAtnGaYjDPf2MpsavhcfVJP3U2BtwMEeKEuAz/aisQzKwk55NbMdzo5v0zN8OWoYEDgTYFWPTh5Ac3lIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6506007)(4326008)(508600001)(6636002)(9686003)(26005)(2906002)(1076003)(186003)(6512007)(5660300002)(107886003)(6486002)(38100700002)(8936002)(6666004)(6862004)(66556008)(316002)(8676002)(52116002)(66476007)(54906003)(33716001)(38350700002)(66946007)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fSBursWOYy8I5wRVQTfA7Po1JYEKIcbC0VLO2FvN68gMkRNxW6DOJ+XkSq4h?=
 =?us-ascii?Q?g2V4Wcn8uM4KvuEWmALj+b6FQKAOEEANch9/g42RJx13VDhpEc5k2xLVrIou?=
 =?us-ascii?Q?saWchMg34BNEiPJ5ihkLM4M7R9esQ2abkUzYnHpTh8YhW0xaksMna/nam9CP?=
 =?us-ascii?Q?RYPBuUOyZeJJsWgIwd+g+K2xMPocK5tU1O9ULnNDIcPNczC4kscm7IH1NOwM?=
 =?us-ascii?Q?Yp6j2gyLzNN4ucYeoDW0lExQsrbyOnJMOx62yerTb7+wFskNBYwdyOk1vO4k?=
 =?us-ascii?Q?2WZ907Fif4CORUUw+CAbide6pAtW1PNyEIPe0JGKjShlZVi0+QbC/n+Xkat9?=
 =?us-ascii?Q?Ipw+eGup2KyJtc4fSu5xmyLTo/wOyoYOyoMAuvi/8khcCwNR9Ob5sKqt65CV?=
 =?us-ascii?Q?7i3/3ZMb/zItfzWWunxgWhR/x9APAvC+hQvNGKzBXgS/khwpl67SO/VzQLPf?=
 =?us-ascii?Q?kq4CqqFFoxUrY+6PPVkoQ9c/jMAfggJW5o+54SuLRmM/hhACfTuDVXjeapmw?=
 =?us-ascii?Q?5il0Cms26tnL+PchzLPmLkyQPbkgVL2u4S1LkWpvIgF3JAQQqziMfUGcv8YZ?=
 =?us-ascii?Q?iBi/o9tazMPouvLMdNA4dHNhvHe/WB6ICscfss9EdYtHpEr74bdHF0swRfEi?=
 =?us-ascii?Q?bhukZp8RHCOYlDr1Raft9qCwOxs4Fh+DWibmgBRN56vB1VNoKjx3Vs8oUJQB?=
 =?us-ascii?Q?wAEgBfLXvFegPfOp84Z3/OoS7rZanM2UzuiZAGe8hv2UO2Hr4jJj3ZGxutJl?=
 =?us-ascii?Q?YsV3ESIyZEAOn2+yuBOFb3EveGcWnXTGoCmx52q0hKy/7hUeVbcDmJqSGW+i?=
 =?us-ascii?Q?fiCEQasN2ZiVwKOC0DtDxRJTU+YcaU4JACRz7/ffTH7T3J1k3zQ+wJmcg3Eq?=
 =?us-ascii?Q?BGW4sl6p7mnhOf5lnHROMwNuWLNYgl79BP8mx9IJU1W9HQTST1Hg+srvgkdu?=
 =?us-ascii?Q?kG4VvN/MeoMtlY86H4DAlhIgP1lryWP758bqml3ZDH3dIentQqDumrTVtqaw?=
 =?us-ascii?Q?n3Q3pnv+15sayIX22XnGYnxJhFr/SdUHJhLA6FpbUAW15krEpZGG/b/55kkg?=
 =?us-ascii?Q?976DTsy89pGpVMG5EbTzf6pBSm1BiwhpeQg4SKIpd47rpy+wyQglW/HHpVhT?=
 =?us-ascii?Q?gFxxjGupcyJQaR5y7oKIOogn5nh0ptZgp94I7PbMsWu7McvIn7zZ6AoZbiyM?=
 =?us-ascii?Q?yR4epJ0RAkfYWvQzMzSKrsbkQNi+LrUaWr3PyJY3UP9CCP/QeiBys1H8Djh0?=
 =?us-ascii?Q?w/fOYJtfYp1uhIkqxxxWKHI707WkwE1VAiW3h/uO/18EnCZfT0UhxyUFm2iD?=
 =?us-ascii?Q?JBSrL1J3ouCjPhOODw2HQrBSsCDG1Y2qIPl9GASd2LxspveZHoMtLq3DCp9u?=
 =?us-ascii?Q?uZLAnGZ8emkEEqm2uZzawKKUYov4We2n+9j9WGGfwLOse02aA0+Qnb0JJhd0?=
 =?us-ascii?Q?rISTtIVmbxhq9/M8wC1NfaBCHrZZKJqQIWxkx2dX2zRIhpbL01J7lnLyTU4S?=
 =?us-ascii?Q?Ifi/Cd/1kkrOvoZkbxVwi23Z09kdx+vwdeUeWTqguiWFSFt3UF2dEuZF0Hof?=
 =?us-ascii?Q?mOywwB4ZPMrKMkTgZA7m+kQaI7kX+ve6tG02W1YrKfLlCu8LRUKVIejoEr5a?=
 =?us-ascii?Q?9A2Fl+AmWQaySHU0XzkP/Qs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cdda048-921d-4b97-eff3-08d9dbad7c61
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 00:40:41.9765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dpYaomw3mIrO6ccH/jPir0daj4GRCDwt1UR6zE/OR+gFV7FNxAXcrbRWOIfzCBlDbKOMpDH443eKx2NWfbrHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1608
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19 Jan 05:49, Parav Pandit wrote:
>
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Wednesday, January 19, 2022 5:46 AM
>>
>> On Tue, 18 Jan 2022 14:33:28 -0800 Saeed Mahameed wrote:
>> > On 18 Jan 10:02, Jakub Kicinski wrote:
>> > >On Fri, 14 Jan 2022 22:15:48 -0800 Saeed Mahameed wrote:
>> > >> I think the term privilege is misused here, due to the global knob
>> > >> proposed initially. Anyway the issue is exactly as I explained
>> > >> above, SW steering requires FW pre-allocated resources and
>> > >> initializations, for VFs it is disabled since there was no demand for it and
>> FW wanted to save on resources.
>> > >>
>> > >> Now as SW steering is catching up with FW steering in terms of
>> > >> functionality, people want it also on VFs to help with rule
>> > >> insertion rate for use cases other than switchdev and TC, e.g TLS,
>> > >> connection tracking, etc ..
>> > >
>> > >Sorry long weekend here, thanks for the explanation!
>> > >
>> > >Where do we stand? Are you okay with an explicit API for enabling /
>> > >disabling VF features? If SMFS really is about conntrack and TLS
>> > >maybe
>> >
>> > I am as skeptical as you are. But what other options do we have ? It's
>> > a fact that "Smart" VFs have different use-cases and customization is
>> > necessary to allow full scalability and better system resource
>> > utilization.
>> >
>> > As you already said, PTP for instance makes total sense as a VF
>> > feature knob
>>
>> To be clear when I was talking about PTP initially I was thinking about real PTP
>> clocks. "Modern" NICs sometimes do shenanigans in the FW to pretend they
>> have more clocks that they really have.
>> There is a difference between delegating the PHC to the VF and allowing the
>> VF to use some SW pretend clock. I'm not sure which camp your PTP falls into.
>>

delegating.

>> > for the same reason I would say any standard stateful feature/offloads
>> > (e.g Crypto) also deserve own knobs.
>> >
>> > If we agree on the need for a VF customization API, I would use one
>> > API for all features. Having explicit enable/disable API for some then
>> > implicit resources re-size API for other features is a bit confusing.
>> >
>> > e.g.
>> >
>> > # Enable ptp on specific vf
>> > devlink port function <port idx> set feature PTP ON/OFF
>> >
>> > # disable TLS on specific vf
>> > devlink resource set <DEV> TLS size 0
>> >
>> > And I am pretty sure resource API is not yet available for port
>> > functions (e.g before VF instantiation, which is one of the main
>> > points of this RFC, so some plumbing is necessary to expose resource API for
>> port functions.
>> >
>> > TBH, I actually like your resources idea, i would like to explore that
>> > more with Parav, see what we can do about it ..
>>
>> Right, that'd be great, although I'd imagine if the resource is very flexible (e.g.
>> memory) delegating N bytes to a function does not tell the device how to
>> perform the "diet". Obviously that's pure speculation I don't know how things
>> work on your SmartNIC :)
>>
>Right, we at least need to tell fw that only X bytes are allowed for sw_steering diet.
>And _right_ amount of X bytes specific for sw_steering was not very clear.
>Hence the on/off resource knob looked more doable and abtract.
>
>I do agree you and Saeed that instead of port function param, port function resource is more suitable here even though its bool.
>

I believe flexibility can be achieved with some FW message? Parav can you
investigate ? To be clear here the knob must be specific to sw_steering
exposed as memory resource.

>> > >it can be implied by the delegation of appropriate bits meaningful to
>> > >netdev world?
>> >
>> > I don't get this point, netdev bits are known only after the VF has
>> > been fully initialized.
>>
>> I meant this as a simple starting point to enumerate the features.
>> It was an off-cuff suggestion, really. Reusing some approximation of existing
>> bits with clear code-driven semantics is simpler than defining and
>> documenting new ones.
>>

doable, although can be confusing. 

>> We can start a new enum.
>>
>> I hope you didn't mean "PTP" to be a string carried all the way to the driver in
>> your example command?
>>

No :), well defined enums, similar to devlink params. but yes we need a
clear cut of what is vendor specific and what's not.

>Yet to sync with Saeed, but I think it will be a enum + string during resource registration time.
>For generic features, enum and string are defined by devlink core.
>For smfs kind of rare knob, enum and string is supplied by driver.



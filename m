Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC81457CBE2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiGUN2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 09:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiGUN2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 09:28:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4EF753AE;
        Thu, 21 Jul 2022 06:28:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/VAfCi0aH2M7wUoNHb9X4BQkT1oMCSHf4qMVe1rcVJZmcJ81JXxfzJ+qQ+IdCEUgR/vkIiSR4OMsRWi2KOBrNnMhNtDakg4wx2puuJVMI9XmKHLJ2ocd5rVfKVrFXif16xP6dH4NNCIWUnKWmBRoXJm0F1PGt2pYziA0/e8gRVYABFk4EqbjRMys9ZW8xNjEqPqs0hLSlnUFz4S8juHQlfzqIq4r8B0u+yedMdwj8JjPWvEeJsrIN5heklTcNTS9w3e1N9Uyn4BDGGTrgUci3PJB1oYE0QyevjVW1Eo6YTBdof4AI/dZLbOJxaLifFwWellal20CSa6dVOsfCDT5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCs13PMPX8ktYmxkw39mM9YPDRfPhpM9eptQi2YcYp8=;
 b=UOQsm0fBTFiASTQ91RI2oV1XZqmEbdGT1PfW1X3yiuSaCKKCcyyh1QQV25/10puT9aUTDRmrZLSE8AVmXhp5vwvNd2r7lXwhEalSfC/hP3Rva7YESJ8q8tgMoQaK+6OfzIpwvSdmOYm/lcHl5inZNMr0rq4fPu2qx7fKQedSQhSTNidW7VyHbCeiokdGwf//oVL8SiJXvdGJj1Uwh857/551uzglc7FXtiPhzam0IgwIIH1nmSZs9mqu9BYgy+XzD14SxLpiVk7r+dpGvsNvZHMfe9qStcOj9X7j+zKrip6yzs5Q1HoL4b6nPI7vp6wb0zXc/HhF8mgValKxFznoWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCs13PMPX8ktYmxkw39mM9YPDRfPhpM9eptQi2YcYp8=;
 b=L5t9OgKwtKjq3mSvHjj5Dp+RqWBQW3yTAMYFkXfR5O1nRxOeWIkzdwrNdLVDaEzb/efaC25tunHgm7ttS6FXYzOhklJCSw9Ze9ZdklPs0LIlj91SbRd8yNKe5Mp1MudAWHQ0PTU1OUprYkZhRTXrAQUkny8RDpwZcx5mAtub+ZjxP5rGVTQawAsUsfcNrnKEvzD2izQ2XJkwYraedxmfMCx1/Jssb4wYKz5A0zrKioiwBacR+OQFxvbG2yJqsTnSdKGQKx3B+S8COIihDOUp7iDdCYOKTU8tC9qRyytes3KkJCVntv9VAByaylQjTp371CqfgPRRkvcFNz0jsQvQxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6244.namprd12.prod.outlook.com (2603:10b6:a03:455::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Thu, 21 Jul
 2022 13:28:00 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 13:27:59 +0000
Date:   Thu, 21 Jul 2022 16:27:52 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <YtlUWGdgViyjF6MK@shredder>
References: <e3ea3c0d72c2417430e601a150c7f0dd@kapio-technology.com>
 <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <YtQosZV0exwyH6qo@shredder>
 <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
 <20220721115935.5ctsbtoojtoxxubi@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721115935.5ctsbtoojtoxxubi@skbuf>
X-ClientProxiedBy: VI1PR08CA0242.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a030a97e-e3da-49ca-cf9b-08da6b1cd411
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6244:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqvPHy2a21K6Tdlg61y9SWpdyJRRiPrj67YZkHMdZqPoXOzpHp4OuIamyeRLamIwghsQL6nYurjRY7/LU8QZTzcBa59sfPHKlvywUGfQ6aanv38nbcUJhiGgM9prG4J6emHEx3PeMJh5/UOWx4oruI1hdjgLi+XODjtebEEKJQ3zH7c5rwVmfi96GrqzkTAo1tXAL9B/dQOElqQFH1FNtf+5hgWS7+i1HiB9WdojyTNaMp4N2m5EtOjNf0Br+bSkoYjXcg2iDtj3QuhAjZ3hD0opU2de5jVTOXDdQ43G4UT6rmYKEPrQwY5Ri6FOyV3Mm/un2CkHhk0KgXF9z2+bFFnVlU9CrlP3L2/Iuia9HUFDAJOMPcCo+PirpMlM1MirMz2AmvVHlWJBMyuGv2m50kH/jOynFyJFHzuays4wgC0JkMNegad91ozIIKQvoeWNNULEQUOd9eTh0T9oMhe/blb4Nl9Q/VCRu9EXwrDcrDCapY3OV+iGPTb+LbMMOo83DhzDuvEr39HGGZQozsgJ7JzOK85qgNq+dts2rafgo2v1G1UmWE9iLzeatkP9QBsBPGspWnQCHxHxXNVUl2AiXuzI/GmqtH7U8qxCKiGfFR2gpawsrLGggad1b9OmrplyBxe0TFgTIjzr+4CFuJ51hrM5LaNU9KZ4r9R9w3huwnhSQX4tgKvnhVkD90/JoFwHp2EzyryF4VPY/tawm3dY5cVyvvP17RRQEl18R3TQgOSt3+0apNqn54i5l+kK6Fr/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(7416002)(66476007)(66946007)(6486002)(8936002)(2906002)(66556008)(4326008)(38100700002)(5660300002)(33716001)(8676002)(86362001)(41300700001)(478600001)(6506007)(6666004)(6512007)(316002)(9686003)(6916009)(186003)(54906003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7pWSu2pcUJYIfRZTHHVEjyYuminVX7roqW1EliPH7hd/AahnKBmJERYoo6/t?=
 =?us-ascii?Q?RsbmtCdfLmgGTA6pe8gpDDVp17foIa9Eh4+SRtcobuhrTJxleN3qunXF+bom?=
 =?us-ascii?Q?k6v7M14+8CGz68QRDpzdwThDL0xJTYLRsNheVbnAu6HQzpliANn1bcyd1R45?=
 =?us-ascii?Q?wnjajYvY159/U1pbRmK4An5PiPDoGyCIaheT4uV/liY2AKwl4iDH27Sl3y2g?=
 =?us-ascii?Q?dIyCNiDC4ngEbg7F7F8+2JeVwLxS6DRk++k8jjEK7bfPAiFtQwbkRZDiOl8B?=
 =?us-ascii?Q?H525VRSi4Wzb0/4XQfgSfK9k74mPsxrcKlQcw/Tsw/U+/JxXjls/DTIlqC3e?=
 =?us-ascii?Q?N14HUvnsNwB2axm+wmKXRQDFbE9MHQHzILQoYhLWSwuWQ/iOuDGua5xb9Y6k?=
 =?us-ascii?Q?oUP6J8Q3lZScKdP/dGcNsr6tgeCyMyfmgh3c9FzOa20DFUGnHyLfw3Ls/+9Z?=
 =?us-ascii?Q?tOkUJFpV8W3jLRb3oEETQIvkGCy5QAWVHkRnBTDyJFLVqwbPgFG1TvreGSxB?=
 =?us-ascii?Q?ibe4YhbTgWO/lFN/iQm49JvQrXprCpVDG07jO/ADj6IIeYNhz2T5/G6tVuK1?=
 =?us-ascii?Q?5moebTLkFbsW/xzwTL7N/yFJ1qGfRVWyTgZeswjcITiOqYoquNyw7//PPNDa?=
 =?us-ascii?Q?qTFZuGAD7rcWQjBcr0SHbrIK2fGi3MoBK652W00P80841NetB2Yugsh2fcnS?=
 =?us-ascii?Q?bontVypryKPow26k9ptgtZjJE5PJKU13ApaoKJ+hqe7F6PRmbKgMygBPqwC/?=
 =?us-ascii?Q?nnuyHI0TMhjXxS+UYiLWQ75EgGtReetWCbmSjt00V1z/F2NvAgbU4OMAIWY9?=
 =?us-ascii?Q?FYIVIvtzNfLSOVD/ToH1Aq7Gp7AEW9q+FB0rVTNs6Eo1N2tg+owyEQtTfxFZ?=
 =?us-ascii?Q?8Gh8hLzwUovtmI/Mubu9zK96JMe83x8wS0NcpusiOqLn+ZEd0oTkTezpM7Pk?=
 =?us-ascii?Q?qpeGSQI4ruwx8YgwFuE0mS3/Di/Ez4XIu15ynumcoiRMyLjEVvqdVukyNqTq?=
 =?us-ascii?Q?cmyGRlBRMvbMjPJiIqT/GrGz4Mzh/0uRiblNr3t1CLoWd3QmtHFFQs028qsK?=
 =?us-ascii?Q?dN4qDRQbv2QrsPzea2A/F8QTpiP0Vq3jf60TrPQ4aq9b3DiD6DE9JIfWmRGn?=
 =?us-ascii?Q?WvKm7OGibw3i9icxWDj6xgTY4SKoJPCMtQ4wW+Q1JaI8y/HOEqTPV5X8DM78?=
 =?us-ascii?Q?tj+HM3QolSA40h0+fR+qWd6nVrSHmF0XEmruFE33rZsegvm8g89fOVI0e4fX?=
 =?us-ascii?Q?Hhee/AIsdfNoFZLlxPU4OPLnWrPNLaEGgNwlkzKVXMzRNP5W7cX9Jak6ioFf?=
 =?us-ascii?Q?Bzv6jGGrwF8oCYEnpgEMLB/DFZxsrlonLQ2HzeprKycXWhd5HWDgFV26JktS?=
 =?us-ascii?Q?kTchMpFfBnCol0kpuKfDzwgQvZ66NIeyehRaRYirQ88k+zA9n9XOOxpYmq6X?=
 =?us-ascii?Q?F+k63eRYJZQIU4OMq+8n9z9qWeUvuXjudxEDM5GSsb1Y1QSr3PYW1NwZ65uU?=
 =?us-ascii?Q?hiQSDvOd0iC02nvbksg77BrLM8oCn/gVV72XLwDLzTJNhChZV8ggiLZwuM7w?=
 =?us-ascii?Q?EH3RHHfs7ybkEHUwemnYf/aNub2OTuCcQJ9NjulO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a030a97e-e3da-49ca-cf9b-08da6b1cd411
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 13:27:58.8803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWUlRHTu8e0SZZLUAVbhEC1T5I4/klCpmmN29PTutxp76FfrqHwWe7sNCJx5nTlRhv8Kkxus2W5UufQypkUjsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6244
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 02:59:35PM +0300, Vladimir Oltean wrote:
> On Sun, Jul 17, 2022 at 05:53:22PM +0200, netdev@kapio-technology.com wrote:
> > > 3. What happens to packets with a DA matching the zero-DPV entry, are
> > > they also discarded in hardware? If so, here we differ from the bridge
> > > driver implementation where such packets will be forwarded according to
> > > the locked entry and egress the locked port
> > 
> > I understand that egress will follow what is setup with regard to UC, MC and
> > BC, though I haven't tested that. But no replies will get through of course
> > as long as the port hasn't been opened for the iface behind the locked port.
> 
> Here, should we be rather fixing the software bridge, if the current
> behavior is to forward packets towards locked FDB entries?

I think the bridge needs to be fixed, but not to discard packets. If I
decided to lock a port, it means I do not blindly trust whoever who
is behind the port, but instead want to authorize them first. Since an
unauthorized user is able to create locked FDB entries we need to
carefully define what they mean. I tried looking information about MAB
online, but couldn't find detailed material that answers my questions,
so my answers are based on what I believe is logical, which might be
wrong.

Currently, the bridge will forward packets to a locked entry which
effectively means that an unauthorized host can cause the bridge to
direct packets to it and sniff them. Yes, the host can't send any
packets through the port (while locked) and can't overtake an existing
(unlocked) FDB entry, but it still seems like an odd decision. IMO, the
situation in mv88e6xxx is even worse because there an unauthorized host
can cause packets to a certain DMAC to be blackholed via its zero-DPV
entry.

Another (minor?) issue is that locked entries cannot roam between locked
ports. Lets say that my user space MAB policy is to authorize MAC X if
it appears behind one of the locked ports swp1-swp4. An unauthorized
host behind locked port swp5 can generate packets with SMAC X,
preventing the true owner of this MAC behind swp1 from ever being
authorized.

It seems like the main purpose of these locked entries is to signal to
user space the presence of a certain MAC behind a locked port, but they
should not be able to affect packet forwarding in the bridge, unlike
regular entries.

Regarding a separate knob for MAB, I tend to agree we need it. Otherwise
we cannot control which locked ports are able to populate the FDB with
locked entries. I don't particularly like the fact that we overload an
existing flag ("learning") for that. Any reason not to add an explicit
flag ("mab")? At least with the current implementation, locked entries
cannot roam between locked ports and cannot be refreshed, which differs
from regular learning.

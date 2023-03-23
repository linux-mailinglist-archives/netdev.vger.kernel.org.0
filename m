Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9456C7285
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 22:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjCWVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCWVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 17:41:23 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2041.outbound.protection.outlook.com [40.107.6.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47620B453
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 14:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISY9C+PT/r3h1ifaUmaG7kGzWZYvhrkn+u+8U7M+lPw=;
 b=Pc985NbDF+QnEH+v3HXjFGwNyZXqeyBkHGvrliRifHI8mIxW8Rami5YjeLVXpMatRPntQoLXlzLkcvhY/inZ0Sn4vEJ5uW5sdjCwjuEaOIjGzYcebfl+EBJP3ByWBFjSFKf4KaUHrpBLqjxAIvZRktGvGgbzhRBhQqc0i3cw9x59wzW6i5J99gMDZAcyJ8cG0OsWsHmeVdXv8LL7BnSRbntkj3pecQMtysRbShbsf1SPyT4W9pTPQM3+wbFN4YNBjC0jDa2Gouna4VjOBuClyhjlHp4xZBGltouNXRP+hBijloN4P7Wq06LSlUscikOmRgzSG/25vUKRvEy0qczfEA==
Received: from DB6PR0202CA0039.eurprd02.prod.outlook.com (2603:10a6:4:a5::25)
 by AM0PR03MB6257.eurprd03.prod.outlook.com (2603:10a6:20b:144::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 21:41:17 +0000
Received: from DB8EUR05FT061.eop-eur05.prod.protection.outlook.com
 (2603:10a6:4:a5:cafe::99) by DB6PR0202CA0039.outlook.office365.com
 (2603:10a6:4:a5::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 21:41:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.81)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.81 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.81; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.81) by
 DB8EUR05FT061.mail.protection.outlook.com (10.233.238.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Thu, 23 Mar 2023 21:41:16 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 4AFC12008088C;
        Thu, 23 Mar 2023 21:41:16 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (unknown [104.47.51.233])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 78C632008006F;
        Thu, 23 Mar 2023 21:40:08 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhyNr6J5pBw+U9Fqm18T2KMOsOPB88kN4KdvYXP+gi0I5CZiOHQKTrUejOnTZl0k7lNe8Dv0f5FIg2G3aWqV6BfkKRhmY2dfpAMOVRpymJ/KHdp2CDm8vhxO5lpKchLNFiOpwh5iheYgTk+GZgGbAJYwT+v0Stmkg6mud6Y3HLkpzF/thVI9NlNxAwpzV2A5jFQBJjuZQpvueTk0ukPcQX7/+Twi1Lj8d7U1whyCQM90a4L22peptcaov69aPhObuht8HEnDDbHFmtEX2Swq0pSwiSooBw89DOb7BG+Fw87xQ3pgVfQuTUJHtoVNNaWOcbgrX235+zojfbbhoA8APw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISY9C+PT/r3h1ifaUmaG7kGzWZYvhrkn+u+8U7M+lPw=;
 b=J8FqNA9KlKQR5m+MyOgei7UCk9MDT8J6Mcx3fsVv3Mo2IMZO/Js+c4ATzL7U989l4cIZmJsYz9WC2VwhjMw7Dup7KLXdPO0io93OeL9T/nWQGpqythH/lnz5X324mHa1+Xj4KzsoexItpI7Ft0IsEkH52iwDzt6vtDYNJrhthFMAtxg0eNJaEe2Mq6HlS15BdWFSa9YKfgyxpwzhiw45IWtPpcQtiav5DS8L56SRZRO8VHGpTXJI2+bIoo1Fp1o/rFqaNMfRBmP4Yyn1wyGftOi8bblLHggn9xXXBSiSzhkrKZMlBl8hQlnjd1KkFYj6pjTLqvFQ3NTdueLhxTOBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISY9C+PT/r3h1ifaUmaG7kGzWZYvhrkn+u+8U7M+lPw=;
 b=Pc985NbDF+QnEH+v3HXjFGwNyZXqeyBkHGvrliRifHI8mIxW8Rami5YjeLVXpMatRPntQoLXlzLkcvhY/inZ0Sn4vEJ5uW5sdjCwjuEaOIjGzYcebfl+EBJP3ByWBFjSFKf4KaUHrpBLqjxAIvZRktGvGgbzhRBhQqc0i3cw9x59wzW6i5J99gMDZAcyJ8cG0OsWsHmeVdXv8LL7BnSRbntkj3pecQMtysRbShbsf1SPyT4W9pTPQM3+wbFN4YNBjC0jDa2Gouna4VjOBuClyhjlHp4xZBGltouNXRP+hBijloN4P7Wq06LSlUscikOmRgzSG/25vUKRvEy0qczfEA==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB9828.eurprd03.prod.outlook.com (2603:10a6:10:448::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 21:41:08 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%4]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 21:41:08 +0000
Message-ID: <e0c086cd-544c-e1e9-8a76-4f56c9cb85a1@seco.com>
Date:   Thu, 23 Mar 2023 17:41:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: Invalid wait context in qman_update_cgr()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
References: <20230323153935.nofnjucqjqnz34ej@skbuf>
 <1c7aeddb-da26-f7c0-0e7b-620d2eb089b9@seco.com>
 <20230323184701.4awirfstyx2xllnz@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230323184701.4awirfstyx2xllnz@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::14) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB9828:EE_|DB8EUR05FT061:EE_|AM0PR03MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d0b99bd-dd17-4b64-519c-08db2be754fa
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: sQ7b8tKKjEezD3Ax/JUcKCiYDOaaWCy96tZTCrGEqLRi/9IZoQWbFjZqyv14j6FrMGGbu8lGJmjcHGgnTzBPZLXOkV2pEftFS6GRrXPIUjshaWzvbQkT0jEHfbzawfid1WorN3pEWlTvmWGdyIvuHedkBm2Zpxo0dQD7RWHneqUbrBz5Aqdj/PEmxYbifGLlwsxWbiUOam1KUxOLWBcue9iC+qKSHAET6AykUpRWsVuntOCzAAr7IEbdkwowoa1QVlMDojejmxmjZblzVofYHb3rYJsWdb6ih/QGggD35Uixt0qTC1OOkFGyH0GerT8dk9QmUqmb2sq5iRUEmSjIdJl8iPx0IZuO7vJ14AXzzAwOD/p8LB434rgDTfWvLOLouDh5SQ20BfRCmm5TfsUKCBN+8tUonlFiw0uEfJ07t1HCeCwXz0zLaVRzPxBH2771vkvo8F/XS2g3gcqj5H1kpj5sJ1Y49qA03RdteP43WT501bC7AjT9l1wm2y316ef9FYg2jYS0TaiMv04l+RHzXxAG30Lm9LRfX5FbKUo4L9NIy1MeW8T076PRSzz2hZH4JDjc+CZvdAFJWZPRZ3ry56kQe2e+Kc07+HgeQ4qZ6ll0WPN2TB/q/9XzQU8KM5RNz3L+p/LxNd5GKSANqY9z7R02DwPO2reHJdbY3FnsEJqZvKc5tWMWpoamz0Cbbw73EryVBBvt//r90gFfCwzZVfc789FRMmcByBgWhRX88kaOJMz3pawqVU88kjuONJUGO1RzIEI/MgySkIbQUFmmZQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(366004)(346002)(39850400004)(451199018)(36756003)(2616005)(41300700001)(6512007)(6506007)(26005)(186003)(53546011)(83380400001)(316002)(54906003)(66946007)(66556008)(66476007)(4326008)(6666004)(6916009)(478600001)(8676002)(6486002)(52116002)(31696002)(86362001)(2906002)(44832011)(8936002)(38350700002)(38100700002)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9828
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT061.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5dd2e23f-f311-4004-0c8a-08db2be74ff2
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTw5i/e5/4BI0tpVns31exdWzVBJaDeLryYRC+txdubVyYKunJdqktC4PbU8GMHDcNI/KX2eYf7ZaAoH83fMlx0TXN2470Pz9GEoParCbXZa2x2Khk5dnRYkNHgiJNreGl9bmi9wgXYwS4/dbWZ0L+c6DFqgEn+SquQoHcAPwgaPfygZexG1OnIXRhSzKskbi4F5lhwAsTbnDh7GEdW2VbopNhm+ummuLhlIoIwub/sxK6KBEs5yNpUq8fu1VQFQubc00eDuIzX//9dxAKfUKValNtD8uPFcjQX6hjtN+kYjg3vJptnGz7AwMFCBTptAPm1rqn7uHtmM034MWb2rXpJ4OTNFQjQMkwsCDG8daGskHtSwgvGtgoWYgLPGS81HSih8uf162TyjfnVE+UuCZRAfEDwJp6CZAZ984lQeAiuZkE6YCobDjILvsYVyTZJ0vA4wMvPW7y+8e93zLW/PO6ET22u6erSNS7EqfLakQ+uzdysCJBqwH1R0izA8wdP4Xnu/Qz/6T5DTyxOZVXRuXYQ0xfNNMrwwA0RXPIMFiHW4F78WWg69eIPxANls8+IP5I0scxWeNafnaQb2ciqItiz9LPaUAomNV1It4XlxNR8ZfkPxxsF7aGjJft4EB+gDKdjxM6oKHhnulSROP3dlsNq7zcvIeaImLJD9N7Xqd/lXVbhqAZ0fv2WWEc/UA7bJeE9Lu0EnZuFip6kwCAV4cbQw4+DVGCA+ZZiCzDNLToyi4ixClKW1cl2V7Iyy58P7zh6wCV48wBObf4LIl9yuJA==
X-Forefront-Antispam-Report: CIP:20.160.56.81;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(376002)(346002)(39850400004)(396003)(136003)(451199018)(46966006)(36840700001)(40470700004)(40460700003)(478600001)(8676002)(4326008)(5660300002)(70206006)(6916009)(70586007)(53546011)(34070700002)(36860700001)(316002)(41300700001)(7636003)(82740400003)(47076005)(6506007)(8936002)(6666004)(44832011)(26005)(6512007)(7596003)(186003)(336012)(2616005)(83380400001)(6486002)(54906003)(36756003)(31696002)(82310400005)(86362001)(40480700001)(356005)(2906002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 21:41:16.5250
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d0b99bd-dd17-4b64-519c-08db2be754fa
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.81];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT061.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB6257
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 14:47, Vladimir Oltean wrote:
> On Thu, Mar 23, 2023 at 11:58:00AM -0400, Sean Anderson wrote:
>> > Do you have any clues what is wrong?
>>
>> Do you have PREEMPT_RT+PROVE_RAW_LOCK_NESTING enabled?
> 
> No, just CONFIG_PROVE_RAW_LOCK_NESTING.
>
>> If so, the problem seems to be that we're in unthreaded hardirq context
>> (LD_WAIT_SPIN), but the lock is LD_WAIT_CONFIG. Maybe we should be
>> using some other smp_call function? Maybe we should be using
>> spin_lock (like qman_create_cgr) and not spin_lock_irqsave (like
>> qman_delete_cgr)?
> 
> Plain spin_lock() has the same wait context as spin_lock_irqsave(),
> and so, by itself, would not help. Maybe you mean raw_spin_lock() which
> always has a wait context compatible with LD_WAIT_SPIN here.
> 
> Note - I'm not suggesting that replacing with a raw spinlock is the
> correct solution here.

Well, it's either this or switch to another function like
smp_call_function which calls its callback in softirq/threaded hardirq
context.

> FWIW, a straight conversion from spinlocks to raw spinlocks produces
> this other stack trace. It would be good if you could take a look too.
> The lockdep usage tracker is clean prior to commit 914f8b228ede ("soc:
> fsl: qbman: Add CGR update function").

Presumably you mean ef2a8d5478b9 ("net: dpaa: Adjust queue depth on rate
change"), which is the first commit to introduce a user for
qman_update_cgr_safe?

> [   56.650501] ================================
> [   56.654782] WARNING: inconsistent lock state
> [   56.659063] 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028 Not tainted
> [   56.665170] --------------------------------
> [   56.669449] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
> [   56.675467] swapper/2/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
> [   56.680625] ffff1dc165e124e0 (&portal->cgr_lock){?.+.}-{2:2}, at: qman_update_cgr+0x60/0xfc
> [   56.689054] {HARDIRQ-ON-W} state was registered at:
> [   56.693943]   lock_acquire+0x1e4/0x2fc
> [   56.697720]   _raw_spin_lock+0x5c/0xc0

I think we just need to use raw_spin_lock_irqsave in qman_create_cgr.

> [   56.701494]   qman_create_cgr+0xbc/0x2b4
> [   56.705440]   dpaa_eth_cgr_init+0xc0/0x160
> [   56.709560]   dpaa_eth_probe+0x6a8/0xf44
> [   56.713506]   platform_probe+0x68/0xdc
> [   56.717282]   really_probe+0x148/0x2ac
> [   56.721053]   __driver_probe_device+0x78/0xe0
> [   56.725432]   driver_probe_device+0xd8/0x160
> [   56.729724]   __driver_attach+0x9c/0x1ac
> [   56.733668]   bus_for_each_dev+0x74/0xd4
> [   56.737612]   driver_attach+0x24/0x30
> [   56.741294]   bus_add_driver+0xe4/0x1e8
> [   56.745151]   driver_register+0x60/0x128
> [   56.749096]   __platform_driver_register+0x28/0x34
> [   56.753911]   dpaa_load+0x34/0x74
> [   56.757250]   do_one_initcall+0x74/0x2f0
> [   56.761192]   kernel_init_freeable+0x2ac/0x510
> [   56.765660]   kernel_init+0x24/0x1dc
> [   56.769261]   ret_from_fork+0x10/0x20
> [   56.772943] irq event stamp: 274366
> [   56.776441] hardirqs last  enabled at (274365): [<ffffdc95dfdae554>] cpuidle_enter_state+0x158/0x540
> [   56.785601] hardirqs last disabled at (274366): [<ffffdc95dfdac1b0>] el1_interrupt+0x24/0x64
> [   56.794063] softirqs last  enabled at (274330): [<ffffdc95de6104d8>] __do_softirq+0x438/0x4ec
> [   56.802609] softirqs last disabled at (274323): [<ffffdc95de616610>] ____do_softirq+0x10/0x1c
> [   56.811156]
> [   56.811156] other info that might help us debug this:
> [   56.817692]  Possible unsafe locking scenario:
> [   56.817692]
> [   56.823620]        CPU0
> [   56.826075]        ----
> [   56.828530]   lock(&portal->cgr_lock);
> [   56.832306]   <Interrupt>
> [   56.834934]     lock(&portal->cgr_lock);
> [   56.838883]
> [   56.838883]  *** DEADLOCK ***
> [   56.838883]
> [   56.844811] no locks held by swapper/2/0.
> [   56.848832]
> [   56.848832] stack backtrace:
> [   56.853199] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028
> [   56.861917] Hardware name: LS1043A RDB Board (DT)
> [   56.866634] Call trace:
> [   56.869090]  dump_backtrace+0x9c/0xf8
> [   56.872772]  show_stack+0x18/0x24
> [   56.876104]  dump_stack_lvl+0x60/0xac
> [   56.879788]  dump_stack+0x18/0x24
> [   56.883123]  print_usage_bug.part.0+0x290/0x348
> [   56.887678]  mark_lock+0x77c/0x960
> [   56.891102]  __lock_acquire+0xa54/0x1f90
> [   56.895046]  lock_acquire+0x1e4/0x2fc
> [   56.898731]  _raw_spin_lock_irqsave+0x6c/0xdc
> [   56.903112]  qman_update_cgr+0x60/0xfc
> [   56.906885]  qman_update_cgr_smp_call+0x1c/0x30
> [   56.911440]  __flush_smp_call_function_queue+0x15c/0x2f4
> [   56.916775]  generic_smp_call_function_single_interrupt+0x14/0x20
> [   56.922891]  ipi_handler+0xb4/0x304
> [   56.926404]  handle_percpu_devid_irq+0x8c/0x144
> [   56.930959]  generic_handle_domain_irq+0x2c/0x44
> [   56.935596]  gic_handle_irq+0x44/0xc4
> [   56.939281]  call_on_irq_stack+0x24/0x4c
> [   56.943225]  do_interrupt_handler+0x80/0x84
> [   56.947431]  el1_interrupt+0x34/0x64
> [   56.951030]  el1h_64_irq_handler+0x18/0x24
> [   56.955151]  el1h_64_irq+0x64/0x68
> [   56.958570]  cpuidle_enter_state+0x15c/0x540
> [   56.962865]  cpuidle_enter+0x38/0x50
> [   56.966467]  do_idle+0x218/0x2a0
> [   56.969714]  cpu_startup_entry+0x28/0x2c
> [   56.973654]  secondary_start_kernel+0x138/0x15c
> [   56.978209]  __secondary_switched+0xb8/0xbc

--Sean

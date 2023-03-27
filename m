Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37E76CAEB4
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjC0Tdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 15:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjC0Tdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 15:33:42 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2048.outbound.protection.outlook.com [40.107.22.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8393510CC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 12:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhXiryJTuapC3tqYu9XSTQTo48l2JDMmgVPIM5SJYkI=;
 b=rIhAe3km1V81UzicYCoyy/q4Dg3YDNd6/vXi2RuuJp8x1XcDJqs0eQbwLg7Eoc/C5oeDwFFhti+HKoAAChdpRdRVnOaO/Sv73TMucNcOndhdEoMPUGKzWeWpbQPaDeT3RbUsFbKt8Xb37fbM5FTVOshjWRQuOMUYDDhAstXN1Lq5N3xfohIl72mgkNbBODm+d03q2rRjhyPIE1Ma1ub8e3nyBl3urplOBDj9+LHnKEjsWEuhUIlAZ6PE8tGJeCjzETgRu5PMGaF9hz3PuX2nZtfgwTSE9EZde/EK3tBqIcLqaIF3n9MLIUzcqSoSO8mw+29Pb4MBGQb1Ey+4hpogfQ==
Received: from FR0P281CA0007.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::12)
 by AS1PR03MB8214.eurprd03.prod.outlook.com (2603:10a6:20b:482::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 19:33:39 +0000
Received: from VI1EUR05FT040.eop-eur05.prod.protection.outlook.com
 (2603:10a6:d10:15:cafe::6e) by FR0P281CA0007.outlook.office365.com
 (2603:10a6:d10:15::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16 via Frontend
 Transport; Mon, 27 Mar 2023 19:33:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.81)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.81 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.81; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.81) by
 VI1EUR05FT040.mail.protection.outlook.com (10.233.243.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 19:33:38 +0000
Received: from outmta (unknown [192.168.82.133])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 8AD142008026E;
        Mon, 27 Mar 2023 19:33:38 +0000 (UTC)
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (unknown [104.47.11.106])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 489612008006C;
        Mon, 27 Mar 2023 19:33:42 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8rapTWLlU51jx0iXqTgb7DDEbM6bqLS0CMfB/v4jrKUI7vSDLpKfQ5vTs2ODFXPOCeehSbOSunAudL3NuqNcYIp6g+wTW0lrPJea5v2FeovZqdYJ53bSzOpAXHBeeCy+bKRswj3Yupg4WP17kdAflblkvy8Ti2JhqiA6dUJOv8oI6cgN+YQiXlhthTRISqJdB0DY9f2VJn61usjdnNspteVsH+BuBj5iNB6oesVfnvi8l6a2ZYLlvGOWky62AZ2oCuZOEWp7xDrxYY9iovQuhfE6EjnYFNEsmFYFLD+mcDNrszoJIcEuJp5+1bK7vjjLuT3qeTAOD6rw2dyenEOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhXiryJTuapC3tqYu9XSTQTo48l2JDMmgVPIM5SJYkI=;
 b=J7xmj05KvJeT1ZApI6jAXJcOsQp+WFrP2s6V/XJvlsop7cQzENsaJdlatqijfHr7bBGsr/e8fR+lCJ3Q2w3hfOE2oDyJug78mXE3XMpBboCc6J10n1JZm0q7eBScQL5yvSlKpudu9VOV6ruSv5ps2TVbntPttYvFx2x9hqcdflfhpR0VusotAWrUg2flQCeNPrbHRIh4OlMb8HXer87CH4rzrgaTcSpeFY/8T06TugGhzL2cL7BBaKIfc9YCbc3k7c5jKhODO09f+rxd0wVH5u9mNd1lhHYj2A8X1Ot/dD1z8iIPHcQwLKnwELrTnsFIGOyl5ap6IG7m/KKEVNpzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhXiryJTuapC3tqYu9XSTQTo48l2JDMmgVPIM5SJYkI=;
 b=rIhAe3km1V81UzicYCoyy/q4Dg3YDNd6/vXi2RuuJp8x1XcDJqs0eQbwLg7Eoc/C5oeDwFFhti+HKoAAChdpRdRVnOaO/Sv73TMucNcOndhdEoMPUGKzWeWpbQPaDeT3RbUsFbKt8Xb37fbM5FTVOshjWRQuOMUYDDhAstXN1Lq5N3xfohIl72mgkNbBODm+d03q2rRjhyPIE1Ma1ub8e3nyBl3urplOBDj9+LHnKEjsWEuhUIlAZ6PE8tGJeCjzETgRu5PMGaF9hz3PuX2nZtfgwTSE9EZde/EK3tBqIcLqaIF3n9MLIUzcqSoSO8mw+29Pb4MBGQb1Ey+4hpogfQ==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com (2603:10a6:20b:56e::11)
 by GV1PR03MB8862.eurprd03.prod.outlook.com (2603:10a6:150:85::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 19:33:36 +0000
Received: from AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::6c3f:aabb:5e8f:6126]) by AS8PR03MB8832.eurprd03.prod.outlook.com
 ([fe80::6c3f:aabb:5e8f:6126%4]) with mapi id 15.20.6222.028; Mon, 27 Mar 2023
 19:33:36 +0000
Message-ID: <d5e3eb49-c968-eb40-1ef9-c10b423c2adf@seco.com>
Date:   Mon, 27 Mar 2023 15:33:31 -0400
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
 <e0c086cd-544c-e1e9-8a76-4f56c9cb85a1@seco.com>
 <20230324125706.ettgc22v5lnu2uh5@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230324125706.ettgc22v5lnu2uh5@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:208:238::24) To AS8PR03MB8832.eurprd03.prod.outlook.com
 (2603:10a6:20b:56e::11)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: AS8PR03MB8832:EE_|GV1PR03MB8862:EE_|VI1EUR05FT040:EE_|AS1PR03MB8214:EE_
X-MS-Office365-Filtering-Correlation-Id: 558c6918-aad4-4b09-3311-08db2efa2a48
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 5FKLheGoRdnyW9Db1VZAL0EXX7Gx2JZMJo1VQhxvAQh7Z4PrfJ6b/nuh7eel+liuL+4QriG2wPM2+aWKaiaREP2x25advYL6IvxWqaEzY94gQ84FqaBQytSHErRXLjiLvtuvECx5ZDXbTagJ1Iv3pUR/NW7Ry//hQba1ttU60xPiQngnway/6IZ6T+5g4K6mF/bP2RXcS3sWc5kkC9KCZ5zIQNS2wg7+w6rChnoyQM0lzq6L1D32x8y008iKltTvG81lnE7TdTjf1HgMaoV8psJK4G38lLRv7DpsnRNAN71rQC1cGHTUbSWHCo6R3i30Fg3T8C3XSNXsE9oAq1Jm46q2xzqdOfZBqT0nY1Y95zo5o1/T4gWXav96uEIVY15IUDd9/PMrhgQPwY0sM61+xt9b1Xn/YRYNuL/5acIschlRc1CsF7pNDoPb1AXc16h6uIyRmuLUW9TKqdMOw7i/vA+3etBhhEOklWudu67FDePSgVkOAVEPCn7QuSsQ3hsQoxhsYIKzlJRtaQhm78dAYAuJqvKlvjo4Ho4d11KLgz+QwLtYFTkLkG2kaiNHn3eOq2hVeTiLv+0DIbxHjM5j/O/RyIIAA65wkf/JVuF7JN/CgOxmKlgu3Wvpet1heWh7QrYoHAwsqfa5Lobnhp5NyPkYh9EqjvSxIaztQwt/cZs=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR03MB8832.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39850400004)(346002)(396003)(366004)(376002)(136003)(451199021)(2906002)(83380400001)(5660300002)(44832011)(8936002)(38350700002)(36756003)(31696002)(86362001)(38100700002)(26005)(316002)(6512007)(6506007)(53546011)(54906003)(6916009)(66476007)(8676002)(4326008)(66556008)(66946007)(186003)(52116002)(6486002)(966005)(6666004)(31686004)(478600001)(41300700001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8862
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VI1EUR05FT040.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 450dc31b-9ea0-4274-6c85-08db2efa28c5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NgFUDmersv81PkX8mBLWV276yytIr72yEFA9HF9O97YNIu7xztVNb25Ih000jVv+nRRLWNN/wytxnSGz6YoSTy7njEbff7LI8BjM0pFVIWRDqIiBwqL16ANioDpoR94oeie1qMWco1Rxig/EMTbudESjB2fvyCrgj+65D8kGFbXDiCUOg3gHlT7J+1OKuTdTlg7R6pk4Rdy9oJjaneonhGP7uijfQxcbP6/1pavqhXYE3Pf8b41KKl1bdyfdFFo7oKQqkeoyFAsTyk7TwMpjrdrKUmNYtW1Fh2FvpPN8wngTG2r/JA3agYDwo4hyVvbsN+Yqk9eBf9JnGg8LwYsqnRUU7AD7JJv8xEm48FXygIrR8bIEAokYTx6NBqFlU3ss7IePNMas7nsQ0AfZcyKWiqTI+jWCDjM4H2j1VYpFjq9YhHJX6OINReeCo7aBzrRkMrhJKP0xJ2flj90E+n3ZFWYQrscOzwIlKCXltQGtfWGlzxrvLm043gSPTB4Uonvy5iy4FujyxOONiwSyWa9ywb7mGZF8/vbfQ7FTTt5Zwz/HzL/JWSciw9b4f5WkoygqB3E09WWTDI1EgW2rBI3w+uXSvamyIBNZLHhQmgUbYkzhEENY6v4Iry74ROm5xqM0wYYaf4+nHNtoF65UxzAO6S0haSRhKcs4wvTTPQ+P7t61L0ZhNSWcgE6e2ZYqxqF4b4XFs8Y+8UxEFdYQDCR9sGONNBj86RxkuyOfwzWLDB0u7qf2JUlsh29I2hHiNE5/
X-Forefront-Antispam-Report: CIP:20.160.56.81;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230028)(376002)(136003)(39850400004)(396003)(346002)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(36860700001)(34020700004)(478600001)(316002)(54906003)(7636003)(7596003)(82310400005)(8936002)(5660300002)(86362001)(36756003)(31696002)(2906002)(44832011)(356005)(70206006)(70586007)(8676002)(40480700001)(6916009)(41300700001)(4326008)(336012)(31686004)(186003)(2616005)(6512007)(26005)(83380400001)(6506007)(82740400003)(53546011)(6666004)(47076005)(966005)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 19:33:38.8352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 558c6918-aad4-4b09-3311-08db2efa2a48
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.81];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT040.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR03MB8214
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 08:57, Vladimir Oltean wrote:
> On Thu, Mar 23, 2023 at 05:41:04PM -0400, Sean Anderson wrote:
>> Well, it's either this or switch to another function like
>> smp_call_function which calls its callback in softirq/threaded hardirq
>> context.
> 
> Okay.
> 
>> > FWIW, a straight conversion from spinlocks to raw spinlocks produces
>> > this other stack trace. It would be good if you could take a look too.
>> > The lockdep usage tracker is clean prior to commit 914f8b228ede ("soc:
>> > fsl: qbman: Add CGR update function").
>> 
>> Presumably you mean ef2a8d5478b9 ("net: dpaa: Adjust queue depth on rate
>> change"), which is the first commit to introduce a user for
>> qman_update_cgr_safe?
> 
> Not sure what is the objection to what I said here.

The first commit introduces the function with no users. The commit I referenced
adds a user.

>> > [   56.650501] ================================
>> > [   56.654782] WARNING: inconsistent lock state
>> > [   56.659063] 6.3.0-rc2-00993-gdadb180cb16f-dirty #2028 Not tainted
>> > [   56.665170] --------------------------------
>> > [   56.669449] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>> > [   56.675467] swapper/2/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>> > [   56.680625] ffff1dc165e124e0 (&portal->cgr_lock){?.+.}-{2:2}, at: qman_update_cgr+0x60/0xfc
>> > [   56.689054] {HARDIRQ-ON-W} state was registered at:
>> > [   56.693943]   lock_acquire+0x1e4/0x2fc
>> > [   56.697720]   _raw_spin_lock+0x5c/0xc0
>> 
>> I think we just need to use raw_spin_lock_irqsave in qman_create_cgr.
> 
> Ok, could you please look at submitting some patches that fix the lockdep issues?

https://lore.kernel.org/linux-arm-kernel/20230327192841.952688-1-sean.anderson@seco.com/

--Sean

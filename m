Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8946C6CC2
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbjCWP6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjCWP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:58:19 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2086.outbound.protection.outlook.com [40.107.104.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D4AC641
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBObLUO9mfwvvYAgkj+041++Yvr36xltLL5EV/KS1AE=;
 b=AKbSvJ2YxkNYVBVYQmEuIdTsuUNuM1UHUK7qd/AK5iZYBvNyQMF4bN1jHIS4PtZeD3OhqBG70AJCZEC8TV1cEbh8wDjqvrtCP5ZNTwGTjL9oMd4pxh/ZZLSMUlWAmnp2T52XJKPPWqt8QR0gmAC6Oert7QCTnTqObyhdUk+wcW95JTXo+izmeDktgNXNnR5gAvd89AYlMnmJIFnXThg1iH/GlGcDtAW8fU6LoZO0ATo/nR6nf7mbiiOkH/+QpshnJ+rNbv/Ied5vdj+fR3ucVmdGld1FkXWDPp2I4+PVvCQTunpr+BFh52hDSiRiWIi5tfh3o2FKNCAKUAeH/uWGyw==
Received: from ZR2P278CA0042.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:47::13)
 by PA4PR03MB6831.eurprd03.prod.outlook.com (2603:10a6:102:e6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 15:58:14 +0000
Received: from VI1EUR05FT008.eop-eur05.prod.protection.outlook.com
 (2603:10a6:910:47:cafe::90) by ZR2P278CA0042.outlook.office365.com
 (2603:10a6:910:47::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 15:58:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.80)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.80 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.80; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.80) by
 VI1EUR05FT008.mail.protection.outlook.com (10.233.243.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 15:58:14 +0000
Received: from outmta (unknown [192.168.82.140])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id C9B3C2008088C;
        Thu, 23 Mar 2023 15:58:13 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (unknown [104.47.13.51])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 0DB742008006F;
        Thu, 23 Mar 2023 15:57:03 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q50ntLQM3+ZEo+XXzjXBuQVPv6b1cpJtd08yB9UWrI7Viiu7J+NLCfRaoWjLcp6J+kXM19Zl76+JLqhoJHxW96iedgQq4XtYOZ49zmEb5+Zw6teOzUUGD/t+zpWRW00Otq9g1EXEz1161oTp5XsYsNz7zC6cxBp0QoViWkvbrFPIRMwayjVhc07GOC78W0g7TbxeqeEis/J//NOOYrJp5gnryTgOj3roJz6+pcjG0ED2IH0JdRNgAQ1ogAVVIQDwjn/rS9uYAhHHTfSQ5X10syyOKhP1zPqg5rkQr6aVGdMLi6UHIMRQQs+a8te0BmniliZsUjmYEuRwhx6YIVDUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBObLUO9mfwvvYAgkj+041++Yvr36xltLL5EV/KS1AE=;
 b=L6pqz8rQoEulSkcPMLlDuASBfVbRiIJmTdXc+Tbhp964r5bwu5HjezeMLjlvcKIN8cBAoRqBteC2MCzeiLxH7BvilkT0zMfV/UszhNr+0OS0Gy0gATq69dohKVqUC52CpgyNtyACThTd2OCs/gtN2O8Z3pxpkVWtMHNrupA4mSE2c/ucCGGvwc/0GbVLa3HcFsgwO2akZHj0svxJ5SczSsIlFq5+Y1xX8NxOSZmzr1gE7kIwg0HRBWoQ+HhoiMgLy0bRnw4bpiKRBVL1aVdyJsPoQmyGn7gRuEyIFKOuX6vx4xsmnZwKJ0HmHpIsMGGmX0TKRyM1+Exlo6BlIDrtOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBObLUO9mfwvvYAgkj+041++Yvr36xltLL5EV/KS1AE=;
 b=AKbSvJ2YxkNYVBVYQmEuIdTsuUNuM1UHUK7qd/AK5iZYBvNyQMF4bN1jHIS4PtZeD3OhqBG70AJCZEC8TV1cEbh8wDjqvrtCP5ZNTwGTjL9oMd4pxh/ZZLSMUlWAmnp2T52XJKPPWqt8QR0gmAC6Oert7QCTnTqObyhdUk+wcW95JTXo+izmeDktgNXNnR5gAvd89AYlMnmJIFnXThg1iH/GlGcDtAW8fU6LoZO0ATo/nR6nf7mbiiOkH/+QpshnJ+rNbv/Ied5vdj+fR3ucVmdGld1FkXWDPp2I4+PVvCQTunpr+BFh52hDSiRiWIi5tfh3o2FKNCAKUAeH/uWGyw==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AM9PR03MB7836.eurprd03.prod.outlook.com (2603:10a6:20b:41c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 15:58:04 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 15:58:04 +0000
Message-ID: <1c7aeddb-da26-f7c0-0e7b-620d2eb089b9@seco.com>
Date:   Thu, 23 Mar 2023 11:58:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: Invalid wait context in qman_update_cgr()
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>
References: <20230323153935.nofnjucqjqnz34ej@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230323153935.nofnjucqjqnz34ej@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0329.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::34) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AM9PR03MB7836:EE_|VI1EUR05FT008:EE_|PA4PR03MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a42565e-921d-4d9b-3d7e-08db2bb768e0
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Zdo5vsfrHNNUpeCmYEdN+UsBd40vOMhMJiRRTZEP1qgUUrPCelrPaNLaZZtTNYllLr2XIK5bVjDj8JC71k7N2X2JLEhck6asbkwK68Amc9yz66PyizqSvOnWoGEiz2vPNNvcgvSioXx+ZD68jj/UBcUsDTnhICS5/sNV0lsilpj5sfajYZaBo5QjPktMALEmIwVs4KOMBL6EUiF0Neb4x6Jj+gqPDf+KtdN0rggMex4QJWsAwPPVtIMzFtO+aLYdLdIstPXRV7NIQ8QXRh6Uop+ZJRkFdRUmWAUbZ57/BMKp9hnNhRs45dKEqKDXt/dP/U3kqG+g6HwBekssVckonDE1GqeyvDwZcBkrRdtHk2rpnOPmu4UZcTuQM5lVvI8MQqG+BcnV8HC33Lbz3fF23i0bJyyfu9BSpJlgifFs/ZjKRWL8D2bGGzJGx0gXscXrr+cHL8X9ipTZp96rAwxQQcGOAGV+InFDhv/wR0rbi83/ER/7YPr5hsI5lqvRV7HpRMcXk6/rQMXnBPRSpK4+1CXet7dSyxbV1q4CTilyQflbja/H7fw9UwrI+TutMg9deTaIJ2f7wHtYkeClrLVKkiJWnrJnM+LG7DePcX/gtgFc9/f2/Grd72qz/Dwdahi6sF91sg/AmAUP2zg74n9BvgD20+f7UQygVzXhl1EceAqmFGOdBug9c46f0UBARIZ4VPqA8iOrxSG+76xoPTZuXrUVJhriZWCxkhgGWIcIRubq8FMbmBsaJ6LL2NglRmwWYjvUyOFy/f8I2fdWpFxQHA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39850400004)(366004)(396003)(346002)(451199018)(36756003)(4326008)(86362001)(8676002)(66946007)(66476007)(66556008)(8936002)(41300700001)(478600001)(6486002)(316002)(54906003)(52116002)(44832011)(2906002)(5660300002)(31696002)(26005)(38100700002)(6512007)(6506007)(53546011)(6666004)(83380400001)(2616005)(186003)(38350700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7836
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VI1EUR05FT008.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 939146aa-2b2a-4cb1-9073-08db2bb762f1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrrlKF5bcXGwiZU/EFctHPZCpruLsoRSQ3sep9PN8+b6bFM5HgWVhl8eIoT1A9Q8Yq61hpjvrlCrrZ6UwHb7shCK1TFVqEXkiJ4Wwkm53KZ0EAieH9P/6fsRyEj51ePUvaeHPE8g+ypukYWpel4kEhYi1qh7l3s9d+Ul5zvFIuOcVyWfs+MC/MjWW6o/C5aixYMPpw4DYJquqLaC16jHU1QUnKWNHFtwUue3e0O4TfsmQsAJZ2Ej2E1bzzDJJU9jymNpp4brySBdEFq9WFTHxSbvunxvRe1guXsXkK77uMMMS6EezHyo6X3ePsotFrTt+XxCS+yT1EtQJrv1EzN5NC7h9FRxwJl8LKbppy0OVxm/4mQDbBdK6ZsWLSAf/CQbPG74s4tYu9nqHstzsMshwVz8m1hDii/zcn8Yj0ZEjSO7rC00IBzNSY2xT6sxmL6/om/ugnYvYUsEFytFEaxlztxOsLSjCHuXA4JSe9NwPW/epQtOyWOMLw0r2XpZYKaq82YgDHyMCT6/YN4XI8u2Gdcnis0fqoLXP8HGkfBcWL5/zNsgW6YaEqzYdlqbp5LaRO70l5qUfFOZnJKzHbGKS8UvmEOUXLnwlyjApzDaI5vR8PSu66GaHVBA5BVsLECjpMxjteMhk2ywJtZsx9fap0ZNMNeA9CUv0jjIAHS6fffNoBAqzr10MXQy9BOjT8B5EQnjpX/s3cm8JFeJIS6ha4mWjjs4uruMzN9ScDRzcnKzXZMzZj68TsRxxZ0CdArzCcxeM86IWF2rmKBker6Q4w==
X-Forefront-Antispam-Report: CIP:20.160.56.80;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(346002)(39850400004)(396003)(376002)(451199018)(46966006)(36840700001)(40470700004)(31696002)(86362001)(36756003)(36860700001)(82740400003)(34020700004)(7596003)(356005)(7636003)(2906002)(40460700003)(44832011)(41300700001)(4326008)(8676002)(5660300002)(40480700001)(8936002)(82310400005)(2616005)(336012)(186003)(53546011)(83380400001)(47076005)(6506007)(6512007)(54906003)(478600001)(70586007)(70206006)(316002)(6666004)(26005)(6486002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:58:14.0655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a42565e-921d-4d9b-3d7e-08db2bb768e0
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.80];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR05FT008.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB6831
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/23 11:39, Vladimir Oltean wrote:
> Hi,
> 
> Since commit 914f8b228ede ("soc: fsl: qbman: Add CGR update function"),
> I have started seeing the following stack trace on the NXP T1040RDB
> board:
> 
> [   10.215392] =============================
> [   10.219403] [ BUG: Invalid wait context ]
> [   10.223413] 6.2.0-rc8-07010-ga9b9500ffaac-dirty #18 Not tainted
> [   10.229338] -----------------------------
> [   10.233347] swapper/0/0 is trying to lock:
> [   10.237442] c0000000ff1cda20 (&portal->cgr_lock){+.+.}-{3:3}, at: .qman_update_cgr+0x40/0xb0
> [   10.254270] other info that might help us debug this:
> [   10.259320] context-{2:2}
> [   10.259323] no locks held by swapper/0/0.
> [   10.259327] stack backtrace:
> [   10.259329] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.2.0-rc8-07010-ga9b9500ffaac-dirty #18
> [   10.259336] Hardware name: fsl,T1040RDB e5500 0x80241021 CoreNet Generic
> [   10.259341] Call Trace:
> [   10.259344] [c000000002163280] [c0000000015263d0] .dump_stack_lvl+0x8c/0xd0
> [   10.273180]  (unreliable)
> [   10.288587] [c000000002163300] [c0000000000e1714] .__lock_acquire+0x24c4/0x2500
> [   10.288598] [c000000002163450] [c0000000000e24cc] .lock_acquire+0x13c/0x410
> [   10.288608] [c000000002163560] [c00000000156983c] ._raw_spin_lock_irqsave+0x6c/0x120
> [   10.297764] [c0000000021635f0] [c000000000938990] .qman_update_cgr+0x40/0xb0
> [   10.312820] [c000000002163680] [c000000000938a20] .qman_update_cgr_smp_call+0x20/0x40
> [   10.312830] [c000000002163700] [c0000000001609c8] .__flush_smp_call_function_queue+0x118/0x3f0
> [   10.324241] [c0000000021637a0] [c000000000023f04] .smp_ipi_demux_relaxed+0xb4/0xc0
> [   10.324258] [c000000002163830] [c000000000020bf4] .doorbell_exception+0x114/0x410
> [   10.338529] [c0000000021638d0] [c00000000001dde4] exc_0x280_common+0x110/0x114
> [   10.338540] --- interrupt: 280 at .e500_idle+0x30/0x6c
> [   10.338547] NIP:  c00000000001f104 LR: c00000000001f104 CTR: c00000000001f0d4
> [   10.338552] REGS: c000000002163940 TRAP: 0280   Not tainted  (6.2.0-rc8-07010-ga9b9500ffaac-dirty)
> [   10.338557] MSR:  0000000080029002
> [   10.355087] <CE,EE,ME>  CR: 24042284  XER: 00000000
> [   10.355102] IRQMASK: 0
> [   10.355102] GPR00: 0000000000000000 c000000002163be0 c000000001c0a000 c00000000001f0f4
> [   10.355102] GPR04: ffffffffffffffff
> [   10.363650] c000000002187f50 0000000000000000 00000000fd236000
> [   10.363650] GPR08: 0000000000000001 0000000000000001 0000000000000001 c000000002138f80
> [   10.363650] GPR12:
> [   10.373940] 0000000024042282 c000000002cf4000 000000007ff9382c 000000007fb2d3d0
> [   10.373940] GPR16: 000000007ff9381c 0000000000000000 0000000008d77cf3 000000007ff190dc
> [   10.373940] GPR20: 0000000000000001 000000007fb2d460 0000000000000000 000000007ffb5338
> [   10.373940] GPR24: 000000007fb2d3d4 0000000000000003 0000000000080000 c000000002187ff8
> [   10.373940] GPR28: 0000000000000001 c000000002187f50 0000000000000001 c000000002138f80
> [   10.558780] NIP [c00000000001f104] .e500_idle+0x30/0x6c
> [   10.564012] LR [c00000000001f104] .e500_idle+0x30/0x6c
> [   10.569156] --- interrupt: 280
> [   10.572210] [c000000002163be0] [c000000000008a54] .arch_cpu_idle+0x34/0xb0 (unreliable)
> [   10.580234] [c000000002163c50] [c0000000015691d8] .default_idle_call+0x98/0xf8
> [   10.587471] [c000000002163cc0] [c0000000000bda0c] .do_idle+0x13c/0x1e0
> [   10.594014] [c000000002163d60] [c0000000000bde08] .cpu_startup_entry+0x28/0x30
> [   10.601250] [c000000002163dd0] [c0000000000024f0] .rest_init+0x190/0x22c
> [   10.607963] [c000000002163e60] [c000000001d57958] .arch_post_acpi_subsys_init+0x0/0x4
> [   10.615809] [c000000002163ed0] [c000000001d58254] .start_kernel+0x8e4/0x934
> [   10.622783] [c000000002163f90] [c000000000000a5c] start_here_common+0x1c/0x20
> 
> Do you have any clues what is wrong?

Do you have PREEMPT_RT+PROVE_RAW_LOCK_NESTING enabled?

If so, the problem seems to be that we're in unthreaded hardirq context
(LD_WAIT_SPIN), but the lock is LD_WAIT_CONFIG. Maybe we should be
using some other smp_call function? Maybe we should be using
spin_lock (like qman_create_cgr) and not spin_lock_irqsave (like
qman_delete_cgr)?

--Sean

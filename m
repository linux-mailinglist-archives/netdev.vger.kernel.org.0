Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717DC6C6B5C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 15:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjCWOoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 10:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCWOox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 10:44:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2062.outbound.protection.outlook.com [40.107.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF3423D93;
        Thu, 23 Mar 2023 07:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDYuhYg6MbkCXddo+/TM5elJ8XyTMrUFF2n2kgjI0gc=;
 b=Ku0FcyTSUAJHti6C5Qlkq62NFGyBv9mxkruCJzRUe9TzRYbChPij7Jl6WaNChDnb6ODQMmI+vxBNGCr6/89xMnoU1gAUNHki3SmEZUhVSsFoCGRyLLixN1Pj8NdBSTRaWDeJBpltTWvlnMRgRW2Aky4EIE4SIRUcnQJAZj4b3xpcQPbm5iHmLmVqJXBBTX+DAi3t6Ukw2aRcKk7/+U+FiawOt7niQcg+A4WEeqCJ1pC+pYIfR0te6z1n6IckY5agwxY9Zxg91Pf/ocLR4PBIiBLHZJGdQZz+KNnSbrPwyC0wAbIY+jhDANCJS8GCNtBLj20N5nNU+FAAfjRGo7G92w==
Received: from AM5PR0202CA0012.eurprd02.prod.outlook.com
 (2603:10a6:203:69::22) by AM9PR03MB7542.eurprd03.prod.outlook.com
 (2603:10a6:20b:411::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Thu, 23 Mar
 2023 14:44:48 +0000
Received: from AM6EUR05FT049.eop-eur05.prod.protection.outlook.com
 (2603:10a6:203:69:cafe::bc) by AM5PR0202CA0012.outlook.office365.com
 (2603:10a6:203:69::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Thu, 23 Mar 2023 14:44:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.160.56.81)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Pass (protection.outlook.com: domain of seco.com designates
 20.160.56.81 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.81; helo=inpost-eu.tmcas.trendmicro.com; pr=C
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.81) by
 AM6EUR05FT049.mail.protection.outlook.com (10.233.241.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 14:44:48 +0000
Received: from outmta (unknown [192.168.82.132])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 1EC422008088C;
        Thu, 23 Mar 2023 14:44:48 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (unknown [104.47.17.172])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 8FD9120080075;
        Thu, 23 Mar 2023 14:34:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmkKzwhDtGe/1IYUHBWDG2n5zX/jnW+x46xpt/JdDtVCOup/NhQCzhacZ80o2hXQ3G2DF/4/9FngnsrGDZTMco/MORgcgB1WabQjg1IYs/v78XUP4JxfkkQtGGLl9H0rsjUveZG3sk3wmHRX2cIZ0azf3qSmlrKbuX4ehZtDuBFWeYBB7VceRUczJetjZ49PmOgJQFWlFo0bhYuDIDYHJL3AStJ4/uXMprV07GiWzLeiFzl6ENryEbfj4Ffg1JvWjCpinSNL52+CIQcrHucb3ftLjj/B7IpQAkrz6Nnubldq032wd4yl2g/0B4va5OIBSNAP1Tj4o1W1LfZzwSzFsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IDYuhYg6MbkCXddo+/TM5elJ8XyTMrUFF2n2kgjI0gc=;
 b=E3d9NMohQ42yhnCvhlnBdy8Qze5jT20rbiZwGnllBDx+XkAAIpumYCEODFG+J2LKgNSNRzaxVYxuYlvIz/L+KfKcr+Ctqwo+o5slyUdBANKz/upHBAvjq/MZY6v0Rk+qVxblX47zLcaA6rjalhIvTIkzftdYKcP1KbLLAyt5KptHPaTeHfg9xPlv2IIyKldz0+9fbjsAhyUV2gaw/pLPDtA9I3DOvUC8RjtEiuyGP3DiBItd0d2qlRDVtLKmMkK7TUIYz0Wsadc7UQ/sS1sqePMwZp8KlI7et6rtlroYbTAlQQT8DNoAQaWDyAVGQmrw7H3WfCAKXDdiN7/ccyB43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDYuhYg6MbkCXddo+/TM5elJ8XyTMrUFF2n2kgjI0gc=;
 b=Ku0FcyTSUAJHti6C5Qlkq62NFGyBv9mxkruCJzRUe9TzRYbChPij7Jl6WaNChDnb6ODQMmI+vxBNGCr6/89xMnoU1gAUNHki3SmEZUhVSsFoCGRyLLixN1Pj8NdBSTRaWDeJBpltTWvlnMRgRW2Aky4EIE4SIRUcnQJAZj4b3xpcQPbm5iHmLmVqJXBBTX+DAi3t6Ukw2aRcKk7/+U+FiawOt7niQcg+A4WEeqCJ1pC+pYIfR0te6z1n6IckY5agwxY9Zxg91Pf/ocLR4PBIiBLHZJGdQZz+KNnSbrPwyC0wAbIY+jhDANCJS8GCNtBLj20N5nNU+FAAfjRGo7G92w==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PAWPR03MB9129.eurprd03.prod.outlook.com (2603:10a6:102:33d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 14:44:39 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%6]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 14:44:39 +0000
Message-ID: <c93f3b1d-3fc8-ee1c-7a7b-5d3d4562f5f9@seco.com>
Date:   Thu, 23 Mar 2023 10:44:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net v2] net: dpaa2-mac: Get serdes only for backplane
 links
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
References: <20230304003159.1389573-1-sean.anderson@seco.com>
 <20230306080953.3wbprojol4gs5bel@LXL00007.wbi.nxp.com>
 <4cf5fd5b-cf89-4968-d2ff-f828ca51dd31@seco.com>
 <e17fd247-181f-ab33-d1d7-aafd18e87684@seco.com>
 <20230322161026.5633f8d4@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230322161026.5633f8d4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0351.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::26) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PAWPR03MB9129:EE_|AM6EUR05FT049:EE_|AM9PR03MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: 837b2976-2a3f-4a30-646a-08db2bad26bf
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cSLKGic3bWvBtL5vYQtpboASJrChzN4yrl5i4Hqok2Wc9D1gih1JsCLzi1HHE8rVI1tl4cpu14V6acIj61nFRFEbgwZk9+Tlt3bUemLNOLXjweCoBFwPZL/fhqGn60hqgeS1UCnM463AnBLTLgX5Jl4F6VT2eY6Kfd95EbcOqtEt+CO5rONPugTIJz3yFBrkVs5+1Yls/bX8bRGRpDZyoKDHx7kuWeLASd1yyLn2dfhnQL2/2nmHR7nOE03O5Tx2ewYVclHHY2JNSttfIzMcBSkPIn5Xf9+zKJWW/J0fN9TvIdhUY7VLAbTMWdUs+tpP0OGPS2PgTWSSf/UUKeeNL4FI5vVHF2leZwcBUJm2SyQieYj4tbnXSD9YuzgNRTkEias67ZbD4NQQv4NZfquJH7+w/2ydCAx9x6qQE/SVMU+PXs8AeunG5nqLyTwSuyA+lFeP09IwSBOQu5by2c4rn/gQaOb7szEV2Z5NnlL80s65XpVFVntsRI1ynbv6y9FCgmWB6rfAt3VhRjJh9fPSd6RkWnxsAWEGQOQTuNkGfwxwzzLLVx6lZxBIe3GV2Xrt+vwgHigR4zLeuRe/5vuKJ4RogIhR3EhGCo6rF7KehQryxt27FCOO42F/U8uW6mo/uyWRCwMSt29CNfAAginlrD4kCLT3bAnEz1YrkQ/qh98JCQnb6NnK7FX89HmV72JkxaJO4oRm4bkFcLLynt3xCq+lCK+Uq11X5FG9JIJrT8X6HlRZRiMdkm+FCIVMKWArh8gmyChj+9uwOJxhyELAoQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(366004)(136003)(346002)(376002)(396003)(451199018)(36756003)(6916009)(8676002)(86362001)(4326008)(66946007)(66556008)(8936002)(66476007)(41300700001)(6486002)(478600001)(52116002)(316002)(54906003)(44832011)(5660300002)(2906002)(4744005)(31696002)(26005)(38100700002)(38350700002)(53546011)(6512007)(6506007)(6666004)(186003)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9129
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT049.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 39f92672-9367-4c45-0ce1-08db2bad2148
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5y79+FkzjcOioKTCewkl+6ZnMRI55AbBaU9TyzrUzINDlO+WF43taxOfloZvMaZpq6Wuidpgsd8Bxo5MLg7oU9Id4bfIm3vvJ5JoGISAxrrSfWHlTGAr/t2tj0mm7F8gGs/7sYQWF0x4lf7HHvX8Ccn+CdhYmR8rE1i1r2iqR6Qoq8SjBv13b+6/DR7JSF/mM5PYUw7orggnBmqC3ykqtH9fgbuAotU8w/GWIM4Aa/3uf7p2oYrhiS/9e+DBLzb8ulXqoxF/9o7BaVsxGCXKVUOD4BnpyC2zf3nNOkozyVuzvuL3JyNUoCxYwoI10j0/Os0aC8sRWebHPxmroDsFIMe/MzTj722l3bqY43N6QeF7StVQv2K6RsJSapjlm9tGRSuuRKUuN3wGo2dz4P9z70nXEy0fDW92QAcV7vATi9px0SCt28AVLPFkXLbNUOFMtmAEuPlGv4YP6ZMP5Pc+rlU7UPTQqUUVF72Px4XiZarvvO2wOKA3rko8nihHh7pOkEm+l3E8b/jUUVMq1XlhHoV6koAlA0xZjAr5/eSv0FdHM8Gwe4M0uxMtfCQ/T1JVFaJoCjQm5QEpB1OS+X5mNc/W/LZE6en1DsM1HYkOheXjw78PwtN7syMl7fm2UrYVUkM5CAWGlWRShRbPqFuuDKWyQRZHa38j9qhEHJKDYFZPfUOTevnEcjwswP835aQcOQyEDKfQQFUaaBlDfy61OJD/oYmFy0AwvQMqWi4bdsNE3Y3AjT0mDHPgaZNCMm2Lf6pXhj3R5QHpFVI+dpscg==
X-Forefront-Antispam-Report: CIP:20.160.56.81;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(39850400004)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(6506007)(6512007)(6666004)(7636003)(7596003)(53546011)(36860700001)(336012)(34020700004)(36756003)(47076005)(83380400001)(40480700001)(2616005)(26005)(186003)(40460700003)(5660300002)(8936002)(44832011)(4744005)(31696002)(54906003)(86362001)(478600001)(41300700001)(31686004)(316002)(6486002)(2906002)(4326008)(8676002)(6916009)(70206006)(82310400005)(356005)(70586007)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 14:44:48.2002
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 837b2976-2a3f-4a30-646a-08db2bad26bf
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.81];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT049.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7542
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/23 19:10, Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 15:52:23 -0400 Sean Anderson wrote:
>> I see this is marked as "changes requested" on patchwork. However,
>> as explained above, I do not think that the requested changes are
>> necessary. Please review the patch status.
> 
> Let me document this, it keeps coming up. Patch incoming..

This is documented in the commit message. In fact, I got almost the same
response from Ioana the last time, made the same explanation, and
updated the commit message, but he did not respond to any further
emails. If I resend again, what will prevent that happening again? I am
doing my best to try and clarify this patch, but I am getting no
feedback. Nothing like "OK, Sean that makes sense to me, please put it
in the commit message" or "No, I don't think that's right because of
XYZ."

--Sean

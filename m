Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA3AA6BAA11
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjCOHyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCOHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:54:10 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2104.outbound.protection.outlook.com [40.107.22.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9106C241C7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:54:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gz/mOjjLRYd4h4Lsb9Jp8oeNToDAjkAn7rjxmKuMCWx+OnDvIjokNosmYauNTS4YunrWjKIxtL1PFerQMczLeemctFxSZjNRwPcd9pbg3InuL2rHcLGdMxdlYoKhPsjs0fzyPi/sBXzNoyCd3g0XuxgaLPR++oIXpR/jAVbL1hMHjgKVv8T5AJFB5qycgto6SbghSEZldF8vWnfbtNIIG1UrI3ppbLA/faAvQo5jlPQzL3Ep9uceSS6KnnpGC+G7ZtpBuawHarQhtpzusoYn7Oa0VaXBjxvPDJmmylUrJNBi0qFhSoPqtFZA6Hc80z1Y5JIEPiXKv/RoKWjJ2kU+aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yIv+wg3ApW4CiIdSlm2+8OVCxsGaNn7PKUv2UyuUQAg=;
 b=oGq5Xnwln64UH49Su8xyxw0DJxX9kFj9qTriEostp8UVXGDvdDwR2q8zn92RjwTIhk2Eh5QUOWVRnK7I20rL7wR2HlqrG8M+hfVHK7Ec+p6WfaIXn2QUS99TikhGU7DrApq09sJCoNOoTNrMr7n9MwUL9fLAMZTKoYWf0Upqfl+NqQ1xtq1JNXZLzADCmLhgNvaNxhqVj+0l0b4C649uH5+FJ+VnSU2tZttIDW13CLqWVpOJH6nUxEMWLTWxsGl2yyxdHniLPpy3ehiel6WOcNotstoOD+viybBayLuWbAviclu8dOCSPBHvY6bXStmE5QSlp6V7F6u0rI/CmvRpPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yIv+wg3ApW4CiIdSlm2+8OVCxsGaNn7PKUv2UyuUQAg=;
 b=ZalE5Tl5PnhiKfXfz3iAFZfF+p1kw1MdYthCiVcxrEn1HqIPXrelFCMu78UQ2irrOjjKXirWS8NVnsIGauj064FMd+px//cCSUZd/Bgf/YdnVHmuI30N8wPJ5SRaTtHtK0J9IY7dtg/3yaPlyqWMYcozYMWdoQy1XXjuO1PAxak=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by AM8PR05MB8259.eurprd05.prod.outlook.com (2603:10a6:20b:368::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 07:54:04 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 07:54:04 +0000
Date:   Wed, 15 Mar 2023 08:54:00 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 2/3] net: mvpp2: parser fix QinQ
Message-ID: <20230315075400.xfxr5m4c2ap53766@SvensMacbookPro.hq.voleatech.com>
References: <20230311071005.enqji2btj35ewx53@Svens-MacBookPro.local>
 <20230315000002.31da6864@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315000002.31da6864@kernel.org>
X-ClientProxiedBy: FR2P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::10) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|AM8PR05MB8259:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a0ac70e-531f-4251-375d-08db252a7275
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zILKr61TO92wqckMCcGDjlpc5Lnnqj60uz1kfVpnOjbjyQO0OGSTZSvTbAfiXc+eSP4pjZmk7hlraFdgwQD/VuIxhb3YHVVZkHTQ9RwiuyOYejXEpb9E6WOzXSktS1QGjiY+lAgxPF1H9aiUCLlMLaRA0aTF98MeaUpfcwAM0XrQxQLy2fUUMbywjWYJpPHaf+Objlk/vtl9BbmfBlNx5TLnSi/limgYN8KuLh61RpS0Sw+EKd+QB7JldZJ3Q+EuWXyBZA6NpBbccc944itq7U7kCvXYm0GxTn7ca8PzTlT8Dg31dXeTEWgbanjD5F/mmhNrLPKwo1jY6UByOT3QwI5aM7bMt5+PHO//v7wSDVcmcR/HUnhdoROfia5HlFWp96aZpCJyV6zYZawU41y0s9c338CaQVZP957rd9RhBt8R5Nae1KyT0DrDUNC7jdwzFxmlQ0WgWC3nY/QGLSh/0giRnBPWBBFeSjZycspQMJT7cPAvrQ4BmdRymO8e0ilQl9scNxizVWb6PA1vC7D7MDn3P+4vM+YNONLMlie2gCWAaHGzVEZ1wH8oxVsFx+d+CQMBjv4b5bEQqmp3Bja7AHSAN9O8SQE4+vNt2/jeeaWrQ07uEEvDXOH5vjIPE2YXWKyj5sJABk9oTPHvc/AicQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(366004)(39840400004)(396003)(451199018)(44832011)(8936002)(5660300002)(4744005)(41300700001)(6916009)(4326008)(8676002)(86362001)(38100700002)(2906002)(6506007)(1076003)(6512007)(9686003)(186003)(478600001)(83380400001)(6486002)(6666004)(26005)(66476007)(66556008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wBQ4zybYr575O3QzsiL4N4kzsDforl5/Yh8xGvH+nAdmbuFYAdxqjdtZrIxY?=
 =?us-ascii?Q?gBZr60itkZYdrNt6gqeMPBbLQZ8EcN5hh/BJFSka8k7/+N5yGrrypuUJYzkf?=
 =?us-ascii?Q?dkiw20rkoUNhl1rTE6bH53X/241+L+xMCG3+BWvTpyqrjGXCwY4+m79nUMKu?=
 =?us-ascii?Q?MVzB1mRuAHcXy03oQV27OQe4uxg8jTruNXUQSgftabaPu8Gt1RbPRYTMHRz3?=
 =?us-ascii?Q?kZSo9YMHqpGB5E9X+DHe971nsRD09qBB+GJltaDFOnH0eO1l6VLVVIX8zU2Q?=
 =?us-ascii?Q?v3eTXcjDxYjHrqr7geHyjo1ovxdj3OkrhLMyUhSRKs3ksLxJj1KboQq5fMwF?=
 =?us-ascii?Q?wXl0csL7coaEPA8WVMwCK9pNFjHXq9yo3mTdutTzmY9Vgnijwz12MXdtzo2u?=
 =?us-ascii?Q?X58E/bDGGpQbJiQI6omY7leeie0dgxPVVHfVrgBHUWr1LC4nLj3AVg+19VhQ?=
 =?us-ascii?Q?RDKcyT9AuMgTRvj6dqqw9cJksxp1kAJE8RmSyrVlue0xzOUT7gBShHxFV//m?=
 =?us-ascii?Q?R/LlbRem5tyUylGKT48Q3YHDnNa8aaS5INFCbrAoZbV1VS5nox5a5Xzdx7Ht?=
 =?us-ascii?Q?a+hvzZs/Jb32AnF1BCLCya/2K2aaebqptt0zMjNbd6KagGnczyNlk/GxHmx9?=
 =?us-ascii?Q?dqVW4pBvDPLQP6IfVFSWsim28PcPAs2Nz7XJfeB98ZFCOfF5xS2ey4bgrKEf?=
 =?us-ascii?Q?7HEE3hDg/BHh49CjCJSU4NdE+YmQ1QVZFMkl3+7gDxmXMmkXAid1QJQDYOZp?=
 =?us-ascii?Q?ejoCVIRNTLY9i7DFqWtTQGxq8E91N0shK8uQzzeFLbPZT466wZIgrYPSLoyd?=
 =?us-ascii?Q?zFUTfCaECt2HadzzOk4yDMVaBRuGyCyoTlWEhHCM+XfVgEI0Df6hJZUKsSys?=
 =?us-ascii?Q?hgaFIdJar+8rcOu2xkwFjKTwMOvMilTJuf/BOE1EjgR3xPCjhr2nRGoeAfE7?=
 =?us-ascii?Q?Ha4gc0uDwzDLbprZOudVxcJcynazVqUIY5a95bTYLBprBth2dspNPgXxeqEL?=
 =?us-ascii?Q?14uKN+NO4Yyq+kbR2zQ5jENvWbEILEvkP3ku/7LuFfn4993l1bh4Nc7/c3Gu?=
 =?us-ascii?Q?KGZDx8brliNQwKZg8bGi5s5QC8qflQYW6q59GT4NqC50AB16VtOdh2UvNGqu?=
 =?us-ascii?Q?2Gon+X/aoz1TQz7EUN2Nf5hHb6oghp00GAHJ6OJ3jAK4tnylnJY+LV+kihJl?=
 =?us-ascii?Q?BIlKM8I8BpDVwaIY6EkGe4mnbNyzUou2zS49W4iVsqP1KRQeRNJoyou5ynJo?=
 =?us-ascii?Q?hP6YX5JKTQD34tGpxHdkxmBS9N7AaWDhupsWJC69AiODJnlFqYc/btEtb1+j?=
 =?us-ascii?Q?geOXY21wawqa9oroZv9Oml5k4SI/sbOutRe5r0OAcQ8jLCtUczL2EilOE5pp?=
 =?us-ascii?Q?eXdGX9wtsLB2vL4oKfg4s69xOcwr1//dzN7RrnC13N4imvJ4Xn2lC0hBFxQJ?=
 =?us-ascii?Q?QG0ajwO6NmBx0valbmoPgED2S4pz0dwQLD9ja1Ym3JAFf0tVIfr5m61SuVej?=
 =?us-ascii?Q?auBVQMCimFSwwgtLnTLZBjoTVcXJMkK1+DgX+T5R0MIAHBfOLaTBc0SrGTt3?=
 =?us-ascii?Q?TrrQjQQkExlBN8+zp4KS3cyhLXSi5IW0TyF82LQFJw/3w4yJ91IRBuoS+HV8?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a0ac70e-531f-4251-375d-08db252a7275
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 07:54:04.4226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcJaYLn+MbVyZ2ephcE5YtpyylvhTZZe8FBQGABM6nSnsS1z7o4B7P7kG/WZ0MGbNZTdWqQ5WEPTq4Y9uAg67X+J66Bugh3hmRGhULWQBoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB8259
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 12:00:02AM -0700, Jakub Kicinski wrote:
> On Sat, 11 Mar 2023 08:10:05 +0100 Sven Auhagen wrote:
> > The mvpp2 parser entry for QinQ has the inner and outer VLAN
> > in the wrong order.
> > Fix the problem by swapping them.
> > 
> > Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> Can we get a Fixes tag for this change?

Yes, I will add it in v2.


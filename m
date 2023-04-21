Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30806EA695
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbjDUJKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDUJKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:10:51 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2111.outbound.protection.outlook.com [40.107.237.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9961B5
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HmKDJ3tLNggtDJ8UAs2CqJeMCzQkW1wcJ+jahcB/SIoFgNr8EBqwWjL+vvVGPPwKPUdd49dZnblHaSQloTAcP90IfadyOGUo6PeCWz4Fz8BVFBh5NFEGZUpv9+F+muLoksxFFfqN9Z1XGFWuFQWRkXrBcZ61nEKGVqv9EDSp1c4lOSjWKTRjQS3iZNpWdzj5GNa5jhKDkiKV7UdIkFjBP2YFu0b7t/UcQqWUIkKQqfeC4haPkoTayheH8HxLKJljdwXSMTmnWKXP0q0rhXyUf8Z9sIO3a58mznB0CYpGRLmTxK+lyBmcje6lLGPzRqXAFecI2STc6QhfL3VIMPK2RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiBJwsrngXFZ9VRbpJpznR+2cFocm916qt+6r2yZxpc=;
 b=kFTJ8g6d5nEAr65NHt37lbyPtlYlknMBaYIGuICWqy45CMXasWttdSDEnGeikA2YPFcXWh/Uw5MwvJ+rdHfzdvRf/U1NjxGu5Jzd3iJZ2lkZKDI9rI315mEV9JLEEjdxoiSB5tP6QMY2afw+1B6kWi8TkNmvgmp0FMMewOPABq3zi00kNxgkbKWtwiBZzCrpVGjE8ox6uQk6urlkDs6+0bPzur8tOM2Y/CjZAESd1cEeMAIgukO+kw1xg9R480k7ygcvX/ohcXIXsUDhFix6HIzJJevmW+h7k0V8DhsApFKyVMVkI3R5M7I9SACY+8oVO93kpa2pbTtBSM6m5CYM8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FiBJwsrngXFZ9VRbpJpznR+2cFocm916qt+6r2yZxpc=;
 b=N94t5+GFISbx8TsP9AenrOmtN/SnbC5fpeN7osPt4PPlEvtuvPSsN9OalSCpEAuhSg687RcllSgI0HkhbeKLCCuEb8Sp4FMhhMPZkUZfqp3DIQpzsmkezcZYDMkcEe9HlS2H3mko33EHbpEYEhYDdbHKLn7obsGmB3QVGFhsP0E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5160.namprd13.prod.outlook.com (2603:10b6:5:315::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 09:10:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 09:10:46 +0000
Date:   Fri, 21 Apr 2023 11:10:40 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v3 5/5] net/sched: sch_qfq: BITify two bound
 definitions
Message-ID: <ZEJTEIMTK1d0+wWb@corigine.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
 <20230420164928.237235-6-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420164928.237235-6-pctammela@mojatatu.com>
X-ClientProxiedBy: AS4P250CA0028.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5160:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a4ee2dd-d70a-41b9-627d-08db42484abd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FkTWlDe5xTgtfxOtrVYn8TPkcxFI1EGmXVZQh0kc8OI9kHvFKUKRlWpdkljCiaHFKG3vlOgYeuB9dBbgni5n9vjvhN6UfaKhgLNbyO6kGwYtj/oykH94//w96dyKBmIFmcAhF8dsWiWXdW9dvAiVCjsQg+xlKc5fEOxM+QLVL98ZVO4k59i7+RZmkKWVLioQ7fToPdN1MHYBo4OO7Wsmg08udWuru2jRDFqFFrkW7XWV36lqhtydDziPqeYY6Vh+yELoxN1DKc6YpyoPbPVX7K6XNApDMU0yk17+SkI17XR+XEF5CRywO7fFw2putCy+8wUeB1Vih/VaByUYkRONj7aCJvK36aFz4MJAg2oPSNzJi8GcsZQXHumtC1EU9ODfeoiObYGPlAVMX7wL4Yy+IXmzuzngIs3yQGo1V9UzRO+Aibkg40No0BREeeu9FAoMPKZwloTvq/HXPl6QCprRrXdtwWfloxQGdKDS6AdAqEhfFqKCExjXvghSEO3c7XjrG54XKzqnS2chsYQs4Et5jSdkvC2GKazfeuEuGwNpGr8ngj0aFNMTYfS1jAbSgUMI0gK5Vff5FooEFG9QIVvVbpEye9J7Lj6Ax/2MgEd/wqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(346002)(396003)(376002)(136003)(451199021)(41300700001)(66476007)(66946007)(66556008)(316002)(6916009)(4326008)(478600001)(8936002)(8676002)(2616005)(5660300002)(6512007)(6506007)(186003)(6666004)(36756003)(6486002)(558084003)(2906002)(44832011)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HJ+LTzoOGo3zdnMGEg8lMOsrYC/V4XmJMPVThz+9w7ulsDTJtLGheB2SlaZg?=
 =?us-ascii?Q?eGUyakVfHdDwTsj0x1dB53bQbvrVxGpt4eeBsgdjBC6Vphy2C7fQj79hC6PH?=
 =?us-ascii?Q?aNYh8j/Da1kVdkrRGU+DLpnx5RUtxyoNf7V1cgk6ZBiYgvz1Z5dK8fVCDHmJ?=
 =?us-ascii?Q?L0D6JpeAz1AMEI0coRwulHAH+PH6AsNLJyZrutd6QgcnsbWtlfv58BIbM7HV?=
 =?us-ascii?Q?RX0A2MmLErf4bl+AAQ4pIQ08kRmwlWKBfIcyvihP21tqG9fzzoMMi0pLWWhf?=
 =?us-ascii?Q?WhxhGKHZTuJL+x7ctjkh83lpt+1yE/MNU3LS434bYUkHye0J5H9IvhZTVX/M?=
 =?us-ascii?Q?Rb1mpH0BFv+jO/TwDMtMWxZMFvtvmj3c3S2px6dnrWc3bONQxk0SQDvw66mJ?=
 =?us-ascii?Q?srRyGI6oHrjAiyZuXKI0gGOKw0IBoy4dW/Zbk05I0k3fJQX2mgln0YqsobAD?=
 =?us-ascii?Q?6cMSL/RqNDuJG4q43mnQ+ZM4YANNaTuEgLZXz/4Bv/L6WCeQT83OjxhE/pql?=
 =?us-ascii?Q?8E93eONpTlfUpRfgdP1z3FritklOCA4YOFHLFUl95Paz9DOcyv8bnyRYmI0m?=
 =?us-ascii?Q?zbCUQYV/XP3+aVrCQENdGe3pfFHkoSm/q+iLO11gaagj54EI43iON/k8Tq0a?=
 =?us-ascii?Q?EAkoXonKzMiXItnuB6M1xFi93Wdw3/0hJPsySW7RgpXJ8NnKZfDUsHWEGpuq?=
 =?us-ascii?Q?GINSz/e1e9bRxLK1TM53jUui/lV86bmj6rBRf9jSPTHws67dl7Y8kydQiXdi?=
 =?us-ascii?Q?mRZBdDmqXqubqM7+XXD9OXIDxRqKadCHYg4Hv8RBtNLjpChhzU9+fkR1PiJH?=
 =?us-ascii?Q?tMiLLoa0OQxwbLmy7a4126alTjrSzXGCxj+d7rQloJMLVSG9YHOW7ixMDKVO?=
 =?us-ascii?Q?C0TNRtQDHVtEgzPmhoaoTS5biJGiHtGCD8vdTkvilBmtELvWcrqWAGJ5Il22?=
 =?us-ascii?Q?LOLAGvyatMINTiHcCRVjEoUlxUZAN4xVMEuMAupYq62AJB6PqfWPVhgPQRjV?=
 =?us-ascii?Q?6wGQrnKkAmUmzD/INWZyG9cvvaZJihP/ikTNfHRl4y75sUK7Ud31uucGMr0q?=
 =?us-ascii?Q?Kh2J/8xSblRmoUUrfPGWSWVxTuqCJQyGntuqiChAizERKmpPSzTaEBPTOYYr?=
 =?us-ascii?Q?aro8hgcaFSHidg5jSxem3Yh7CD0h1KdsDG8bG3IjuXD0peM6ketBxaziNv3C?=
 =?us-ascii?Q?ZkXJ3wyPyHqp+w/5L3nH35/Gr923lh7eKgfL2lWJsmkzYIr9760xIe9LUel2?=
 =?us-ascii?Q?z9YKbsAoC4RLthnvEhEHMWuEPqzaWHM8Gt+yrnRrXkjXFROjYd3id3XTSQIF?=
 =?us-ascii?Q?KT7HnbtHfMxLZLEIPSuWueOjzhwxGmY4jT43+uu6phayZUGgc1v9gOJjJnNQ?=
 =?us-ascii?Q?6BEaPshNJPmTz4i3RD9BR45Ta4aXsXUCquowpKPYH909PH9ER3hgnwO+ch8Z?=
 =?us-ascii?Q?lzVDkaXwRJHN2nSGAkq4X8hreeqYqthFQliir1xcGqw4d8e+p33K1KTK3sXn?=
 =?us-ascii?Q?AWGESLMGz0kYDgepN5NhCJ9obJ6091cS8eaSLemW0Jw9dHxAIBPCFwpEk7qy?=
 =?us-ascii?Q?SOH3XDaPZp5BZlHvc3hIGi9u+a+H/1NplRcbb0YpaFcJU+Y+kNdqc5G+key3?=
 =?us-ascii?Q?2w08m9iAEXx4ZefgT36Va45dGXrW3f9Qf3WnWElfuOBzF2q9AmCHjyso+N3J?=
 =?us-ascii?Q?Ge9/ng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4ee2dd-d70a-41b9-627d-08db42484abd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 09:10:46.3744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPzowTlSA1Lr++I440sFl386/tlRscxriBkSOWIhsOBpS1Rt8SoaA/oF6mVYoXTQMcwVqZLLhqMqaOtVxdOHpx1N6TRRZ0r8cjCDMrfqsgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5160
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 01:49:28PM -0300, Pedro Tammela wrote:
> For the sake of readability, change these two definitions to BIT()
> macros.
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


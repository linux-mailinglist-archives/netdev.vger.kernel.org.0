Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A365E6E7A02
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbjDSMwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbjDSMv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:51:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2139.outbound.protection.outlook.com [40.107.93.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A65B75C
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:51:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGXjiCj2y5xRd3VBbdd0rUf+qq8nM3U7YQYruNZY9rN+gtPRMTGiDfXzOvn5Lv4H7McufnKnQ/hkCuQlX9rBwlW2K7NX7KCzYuCd8fPAjEeuYYWtQ9Ihr+Xe3sXeVfjwIZr2kwMjMjt1GXhiMWvYphsA1wez/WAL53kxb+SsBKO610w3EXr4CH7Svui7fXpJSNtsBAujjoLGTxpmqGztNf74ivKMlJK1VrDtBi1oN1WLTEseAD479ZT7vne1UOKa2aaVJEg5DKi9fKZjINnbpDthFxcneTl4tVRp1O91R1WGtBkXPtHgKaN7OWvy9UMCHFgOljB8sHxbsTv0bG8IeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKkKpBzvZGCrebqxrDqaNcaRgpKUTG+lVzzwc/Welts=;
 b=Cy/myeE2gHkEioja/62FV0HCt4X/1xBqBBXc/T4oRzRloxRKfenZyvVVvOCu622E5Pdg2qvcVl9xjKUD7BtKmcRhjIAKi8E/TTWgGnNsc9LSDbfr4GcvnmAPq8pJdEJfC9nIpNJVFvgr/Y30/yVzxw+h4ZfTRZ3C5RYuh52xJiA7MuUdpbWJzBkRuzFMPQgD3Haa8zlgsPpiNnd2uQKXFZYBX5PPNBhEaK9CVlSw7P1ZXzyAof7XCld4sUTS4imuSMYAMWRYo6KxXVWLZawyEpc0uEy3HTnNuX33VtDWNc6CVNTubHdjXzgSmbvXXEsFdL+6DGO0sFj2avDC/KA7mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKkKpBzvZGCrebqxrDqaNcaRgpKUTG+lVzzwc/Welts=;
 b=fLJdAtWl+F7LJeOD4jyS7MfaZYeLt0xQGG3fG0OJmXyxfxHgiyRr7hDaRM3Lra5WqiUY+CIXI9sC9tdpjkM/rjXUVojARhXOW7g8CXAzjgXXouTF7hDNKZY6fsyF7Uwy2nYTarZNW6D4wZDbxTX9AxKMQrE5TQFhoyVcfy+Z49c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5879.namprd13.prod.outlook.com (2603:10b6:303:1ca::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 12:51:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 12:51:27 +0000
Date:   Wed, 19 Apr 2023 14:51:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next v2 1/4] net/sched: sch_htb: use extack on errors
 messages
Message-ID: <ZD/jydrL4GhBfSYL@corigine.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
 <20230417171218.333567-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417171218.333567-2-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5879:EE_
X-MS-Office365-Filtering-Correlation-Id: a633ad48-1c98-4005-2cd1-08db40d4ca19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KxtF/5O9eZEnil3GUBdxwXGpCumIhwAOneVjthzqEsSH5MGHKyJ5TLmd7mvihmXjQDanhpjxJEEC0rdmjSAFnekUnDP2J/VWsQsEnkoJHjdTekrr8HyztQVG6T8i6GhGnR1eJn9U3mkSs9Qp4qha5DMfLmVJ00O5Rwo612iJIFuWjWcnkcYCFwwflxGSebFtOMBUr0SQEoBwqSbVLUy3Gc5oKWFWLILkvotQmO511/0TWDcwK6uijcrmrT5g/LzsLBIgPXBNCxHsEv0egJao6w/WUJM7sjR/eB3IhUpncz6AcurKofRiMyFQkAoSPQ4a0JwkfevCIA6So8qP1rXeil9wDPGuWWIiKgGX41thQE605OerMBRUbtByOKHdXWHKeDPM0rychgUNSYHovOWkeJj9x5Y9I74n2lMwPg2YFmiClWzquz1/Gd03TiuxfKOoQafaAYWP7d0m5quHb7bMT5T2r8c4wvo+45XC5RpooNGZZbBH1DKuY+wvGK7PNyt48122xEPYo8m7/2BgnZqkv42rEk/m47MPXbtqI3ji/BAo3q6bozgTxH+SxIYkH6dNp+t46rQex40lqstNcS+mhd1FMRcZ9KRvqXODQlMpQDM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(39840400004)(346002)(366004)(451199021)(66476007)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(41300700001)(6916009)(4326008)(66946007)(66556008)(186003)(15650500001)(4744005)(2906002)(6512007)(36756003)(83380400001)(6506007)(86362001)(2616005)(5660300002)(6486002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a61CPeulOifuRfDLHQTZMHnEnazMG/wmi5jTOgFLq2oo9dBFdMVtkYJeen4k?=
 =?us-ascii?Q?OwtCRlD8wEJr4lC4HMhgCWXpR3MYYHc+L0duqTLTmkY6EYhlSkNnGP5/RSVj?=
 =?us-ascii?Q?PD9uZx5bIYQEWOvriicbnsITSs8kagcc9EnlceOV+ZsAJHfx2Kr72PI7ErJL?=
 =?us-ascii?Q?EifpDpheCUun72crS5lQjP2ZrcMCR2SOKNgyXtOO+bOotG4dWQjLbQuLyj8N?=
 =?us-ascii?Q?LXuNHzZ6rdwHr5RDDFKRq0GxsZvPbnw4VrWkmO1BWcDVytbG7IQuHv+isCuF?=
 =?us-ascii?Q?dlQujqflZHoXTSffgkYq9T7SLzi6QYsVQ+pONpDNhGGm1SLpmMb+xOSDXaqG?=
 =?us-ascii?Q?0usnoscJqLpob2KKgvT/s2lawimkAHzVsWZEevz3JYo6YJBalszuECjeKiS7?=
 =?us-ascii?Q?DfLDRAwP5wOxS0w43d21+2aKeP0FRC1svIcMT5sdTcnNisZXEAQ9ovjLHB+J?=
 =?us-ascii?Q?4SQIh4+wxZLAgiGt8xlxhcTQpyTGbBQydQSUDUJFAWpoeA6xglBL7RsQ+Opi?=
 =?us-ascii?Q?1HKBw+jzGB+9o7Al5hQ7nIhlHEhWUj0Vd6Xhxb6p3zu7EEU3lefLGalo6mvL?=
 =?us-ascii?Q?TgSQ9/GpyFrHaSwj51jjL3VgtLDg3Cv47vAFKExWO5tgE8QBWaHJT/ep58EU?=
 =?us-ascii?Q?mC/LJSMZOzq9IIMtYN27V51/Bgx/z8Eht3aaH7JG62sHhVkalKLd788Z4dXR?=
 =?us-ascii?Q?oWXM71YrSZPqezarJrI8ZGKnCcUCNWz37hxwTnMLMXcenxP+KpFgmJUoHdh1?=
 =?us-ascii?Q?RR0SKFQh8WrbB9LT6ettbNCeDcQ9BXf84woS00Tsy+tjQl0FBOwbZSr6+72J?=
 =?us-ascii?Q?NvagEchc5MLN1YnmUFxJ6z4Bkes28zGuCt4cbgrAUg5JpbHWucbBy+nAeU92?=
 =?us-ascii?Q?Xmy4bgQBZG4vv1wkutBANRuf6pp9cZ94CqIs4LV5vDd4TkbED9JyE8IzMMBS?=
 =?us-ascii?Q?MBAt+/HjQJMsJKrzqQPwpXxPvDUCE3HXfvR7WYIM1HZINiWewB0jDQ/HshPl?=
 =?us-ascii?Q?ABET4tMzV+1VqB59NPbh8TZ5wDCXYaPnvXHCq4U6K8++uwyOz1hUX1od4MlM?=
 =?us-ascii?Q?O+v4s3YzjDqrrKiuUyXhRJDuLdr85mSkGqw748vgeQfUG4n3Mp5S75G3kU1H?=
 =?us-ascii?Q?VuXJFlGFnnYjhI8HKFYZGO9r+f//brr0Qr+1ucmtczR+4piTAa+cEEFZ42gK?=
 =?us-ascii?Q?e99NI0q9cBBy5L0JkwcFNgado67T2VNb0XScHWa8ohRd89icJrZv6i+EORJn?=
 =?us-ascii?Q?Ql1faooatrVWq4j5ehl62r5yJ+0NVfIbLM3KYRSz/o8tN8tMXuwXv/YJgIwR?=
 =?us-ascii?Q?++YYJqFHB1ZKctrR1YZDf8DCZbkozktrrYGXRMlaMviMm2FnR4npHy29rOoR?=
 =?us-ascii?Q?zAYpCFIsCCF82AHjeQYFRbg+xY+WTc+BGEWmDhvrxM7U7YctO8OYaqnLylM1?=
 =?us-ascii?Q?4iJbuvVR6NyUrLuvNsvtM3eROt3mxKSmgSepCpqWkgFBzVEVUW30YW/1bccN?=
 =?us-ascii?Q?lgoToSLEUZFoz3yujjwUC/0JLtq28QP31LUtIqOyQcP7avOF8a2pyEZgLwKT?=
 =?us-ascii?Q?qZstpxah7RgbWMBvIU6VChj0KB25Fe/zmR+XKy6WjU6OR+HC/4vq8rNAr0nW?=
 =?us-ascii?Q?JwFzo93Lc/761O8NE/MHrGxEMK6Sv50XOmsCk5pOaKPcUVpE2rKt4Dfu3spW?=
 =?us-ascii?Q?/NzsVw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a633ad48-1c98-4005-2cd1-08db40d4ca19
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:51:27.5957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zd7QRhLN1Us8fAGlhHURSofdO+DLaXt0c9zapWAQ/iDJsi8MmyrHpMLSOsd4t/yRI99odQM+zBA6k3dAGtmWJ09/1TnC5Dq5yiZ5K1fxALM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5879
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 02:12:15PM -0300, Pedro Tammela wrote:
> Some error messages are still being printed to dmesg.
> Since extack is available, provide error messages there.
> 
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


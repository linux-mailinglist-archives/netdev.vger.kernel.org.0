Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DFD5296C0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 03:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiEQBcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 21:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiEQBcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 21:32:43 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849482E0B1;
        Mon, 16 May 2022 18:32:41 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GIXNJW022383;
        Mon, 16 May 2022 18:32:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=61BGc85S9HZMdTm+fU5q7eQr8q8SpfXUXcj8JBa0MCk=;
 b=QN9T+uwqW4AZHck9Aa2G/rMB3Ub7+dTw2zMjc12ANeSbNRjPZCT4TNYpNN/NyAFQiWrP
 zQikR+J2tgU7h1TZ2H7pLFtfHbUrZUxleB2yM1pAhOK36Cdk28+J7tDuOA/0KZKF+7og
 jLJ731xymHQP1UHAkS3ZJjvCJAVor+4c/O8= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g2a8u5x9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 18:32:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAH92tQX2VDO6LMuOwrj5h61ICFLfm6mcByOKFaBFcwbLgFvCB8LUGz7Ok7894U1HA9tL3Qu8MoUQ4R8HXFFFt579VUQOhbhSidwwYN5aVT26GP+yFct1xOp50AfAk5etwCB8hEDFY4pWoPDptVpIo/qtfzvMEWjwNvt6aRmoaueE2y7V6TfKcO/9sAH9I7cru6ngUpODwXs0VMI/Dm7M1nLW4zVXH1zMIkP0F/3JRqaB/qhpWuby6OMDnzPtWmjmH4aLtmvx4AkB1u9phQiYvea136iRG0J6xbXwIpTkzNYDQ6G9RTmwkN0uTbhQ+vW/ZvFYyjpK1hA0bvSXbBVGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61BGc85S9HZMdTm+fU5q7eQr8q8SpfXUXcj8JBa0MCk=;
 b=OuFPYiboNGxp5mGMio8bJ9sWE3BRfpneO36zaZkGXFBZcx9uX3G51nJd2puXBxjVaPrsmHTXxcb743MTpsrZGSM8dov06g/VbIc65SoVpSeL58zYqZrZwoDmtNI294F+UXk+O0IR+WNbNfVyRJqJmTaCq1QwsEEkiDfAW2TdJLri5AdIW8qF31/VF+EZBbpY+rjBprcoGkqzV1RfWy5YOcl6OuXohwjnRP2DCuAeNYJrDwr7UHgySmB2aITpR8GUPyciAiij6X/wS08cLbP0k8xiSbKDniFGLON0Q/IfQiFD6oZlPwDng+YjuSlChj3f8ux+zTixeTWTh5Qq3H3EUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB2667.namprd15.prod.outlook.com (2603:10b6:5:1a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 01:32:19 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:32:19 +0000
Date:   Mon, 16 May 2022 18:32:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Geliang Tang <geliang.tang@suse.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v4 5/7] selftests/bpf: verify token of struct
 mptcp_sock
Message-ID: <20220517013217.oxbpwjilwr4fzvuv@kafai-mbp.dhcp.thefacebook.com>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-6-mathew.j.martineau@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513224827.662254-6-mathew.j.martineau@linux.intel.com>
X-ClientProxiedBy: SJ0PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::8) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60e1853f-078e-439f-eaf1-08da37a51578
X-MS-TrafficTypeDiagnostic: DM6PR15MB2667:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB26674CB3ADEE168B74F1D30AD5CE9@DM6PR15MB2667.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZkuC/Ra23blRmNObT9V1U2sw2RTJBjoGwH7pOF4E20mLkHGBSbE6hlME0wddK22mA8KLktEmMDceNclucYovrqMPYBGih3Dzd1qWSpAfWqflgwfbhG9pFLiAFmFpEY8xY47Dcy3UTr5jAY0XAz/RD1xbDYbuAC5oIKGGUnpVLRHgynIBt4xbW7FzVxF0jQBR2M8fZ3GoQuSqGN6kQA9AosDdxN5Rr/rV6ygOZC9KGGVrH0az7gawAvZboacJxZ+MMj3rCh8yHyO9ZQyENHCwzOxnu79syqcalQe908fYxbrjIW4YvNTADjnskPG2PgF8K5Jkgp5elY5Ui5Gyq2c+0247G0LcbYcn1/0LHdngllE4FnkX3CeXRftXRQ7qGc9zO+g/af0wyAl+wwyWrntNn5KVH8JWQq4Mm3nbc8m6pJL0Kw4ssaBKI7LhEkwHC+SM9dCWC233ZJJ7sI8z5mtUh1MZjnc9cT9593fbv/1G7tjvdp05BawW/QjuJUrE9sHGsIRYW4QHO9uWJXC9coJB8ipRZRDaDW0ir3KkV8+kzuN6rsDHXjE1aC1DA7lMCziQ6x72XEKA1tPJF3R2CxsLNegcP7gATbLHNP1L036j6S2SzyzEQvbMWzYrcsUlYWUii2kWa5I7UOQTeq9Z7xKEoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6486002)(83380400001)(86362001)(8936002)(6506007)(66556008)(508600001)(5660300002)(8676002)(66476007)(2906002)(4326008)(9686003)(6512007)(186003)(52116002)(38100700002)(66946007)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mfdn+iWV5dtzPiVvMmlf9yhnbcWCDYvCvST9NBwWqNmdeiWkSOAHibGAZxiL?=
 =?us-ascii?Q?x3KWkhDU5Rku3cI8PYt5TCdSNbLweW1lqXxFRu+lsxJryBZEhHnj76yd3zFM?=
 =?us-ascii?Q?lkZOH/OoCIL7mcN/TuW0sZgVotJDNmWfrFLRBZQXyQd92eJ5BM5ZfoadHphg?=
 =?us-ascii?Q?qKUommpjGXkcszE5A/kLXDnor+GmudjFPmtD0Zce64F1wDxL/IzMOSkqNxN2?=
 =?us-ascii?Q?x0iELwz1uCaVSGtyKSrgBWuroXyNOqa1xwOXNRFmSjG3mZvuISYfyY+eoqjb?=
 =?us-ascii?Q?RB9DHpSj75BNac5Hnr3QoP4GUXnurh7PxtbtPBPeaK2Onjc3OdHQBx5TrgF3?=
 =?us-ascii?Q?l5U7vWjvcIrSwriiueXbIHTjxXpKZxwE+3N/BbFs8Bisp36WWTq1RnsYIpMo?=
 =?us-ascii?Q?K23tiOtea2N05t7HjcyzWeEmM/aj7pjKkK7AjjUdBoLfdjfD4bJo8+xCn/WW?=
 =?us-ascii?Q?aXLPIE9au1Pe2k/ol+mcLQsYIAzq+0rz6NhAH9mPk78NpjRgC9qPMmgNCm4H?=
 =?us-ascii?Q?+hSGHiSaOARcNq6DR+bbMXAJthu6jPO316keF2443gt0/fk1GBp6+YmpI4Ts?=
 =?us-ascii?Q?q2UqN2SumPiHR97R63HjnaKUWfZQdXbPKzFEKGMWQ0SYdimganYI6rYXiECH?=
 =?us-ascii?Q?VB/kUjYWeA9FtC/YREUtIGgg4JyGpcdCUi+f/Ksp0swdjxeCWUT/pwL5jsZ5?=
 =?us-ascii?Q?TLOV8uhPvpB4aEH55IXL9Bsr/yqJ1lESmo6SK5n1g5Cpgbds4wndF9wajBFu?=
 =?us-ascii?Q?c3sgNk0foYLh/T7XSk7mcMW/uLHPB5cYJsdGS1uhr8uM/v8v5bnE124ZNLdG?=
 =?us-ascii?Q?iXRLtpcIn3I7doIzxxCPUlb2qTyxgP2/JASVrU3JrxdGtf2T7k85GEnCqmJM?=
 =?us-ascii?Q?wx8tFrkmrIYA6ML9OWDVpcT3WAUEiV5MQqZdBv/1Ws7/sJnRdZDDV2OAkdHX?=
 =?us-ascii?Q?CCiQAc6KgSqUtRsQ7rbTtXeCwgUcYz0BBbN3tRXqzvUQuO/mvCOlSoFnT3Xy?=
 =?us-ascii?Q?3cgEU5u5fc48G+TbClVD1enSpGDiwCAlZeRz5p3uQCIuypqmx5SQErqot5gP?=
 =?us-ascii?Q?6Xsx1D9q4zrGk1hesah8UIKlqa1QWNM/9u2oZS8te+7SYvx6G3bREfE11hh2?=
 =?us-ascii?Q?nZ/zMRnO3mceZD5IQCBqJ/rZhVziWywXMgeINuvlyFdUaKyDbxYLFgNWVy2H?=
 =?us-ascii?Q?2O2jH+nTvtUsb30Cxsidw/yKWe1gImfnfnenyk7IxDa4YZ9+QyhsIU9kYUdb?=
 =?us-ascii?Q?bMTdzZsY8WnLTPR8YPvU54walfQLfSef00wD9d/TSKRVpliUzwq6FNIHjomT?=
 =?us-ascii?Q?1Y4s0fzhqMA1cEMaN9TPavW4oUK15ACF7nL68XH+oNFkR94bRC3sLDgt3KV8?=
 =?us-ascii?Q?xavj1jTh+QUD71nCZnvul0a9Ikf7A0CBVO7AnYZp617NZhBlm2uAOtLlwbo6?=
 =?us-ascii?Q?KEiUZc74AdHRWpUacFNLe+VKoUL2kPEYn4c9lb4Eo7ZYA5ijRoDw1o7j6gOV?=
 =?us-ascii?Q?hTFSzyoTWtH/RnDcec3T8ONpYJx022PfqmfZga3oruHqY+I0oNFZVq3FigT6?=
 =?us-ascii?Q?SaKDLuHh0tOWATtJKT+84bZ82xWCuTiEQAzxPbfDmdYenwqaq2cIMrgjNrOM?=
 =?us-ascii?Q?PThH3T7tsfW9W4887H2OSIVornriT4kpJ/jSCKXxY4WeCeFC/5hGBX+2JGvT?=
 =?us-ascii?Q?IBIf8J69kp6UGng1OeglV60ms+TYVeHyy3Ly0GsOLe0IQWsCzvgLFe7D3KqK?=
 =?us-ascii?Q?+4FOXj1lwJBuy/gqZtjyyumOMOqMiaA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e1853f-078e-439f-eaf1-08da37a51578
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:32:19.7432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uXQGsbWFnDZt0bo53QnmJ8Np2b4jfrCvkBLAz5at4iu4WYUqResB+tfqUFFMaueP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2667
X-Proofpoint-ORIG-GUID: X26tyJg2NKAVe1Xx-iwmbSabliwGvZKb
X-Proofpoint-GUID: X26tyJg2NKAVe1Xx-iwmbSabliwGvZKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_16,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:48:25PM -0700, Mat Martineau wrote:
[ ... ]

> +/*
> + * Parse the token from the output of 'ip mptcp monitor':
> + *
> + * [       CREATED] token=3ca933d3 remid=0 locid=0 saddr4=127.0.0.1 ...
> + * [       CREATED] token=2ab57040 remid=0 locid=0 saddr4=127.0.0.1 ...
How stable is the string format ?

If it happens to have some unrelated mptcp connection going on, will the test
break ?

> + */
> +static __u32 get_msk_token(void)
> +{
> +	char *prefix = "[       CREATED] token=";
> +	char buf[BUFSIZ] = {};
> +	__u32 token = 0;
> +	ssize_t len;
> +	int fd;
> +
> +	sync();
> +
> +	fd = open(monitor_log_path, O_RDONLY);
> +	if (!ASSERT_GE(fd, 0, "Failed to open monitor_log_path"))
> +		return token;
> +
> +	len = read(fd, buf, sizeof(buf));
> +	if (!ASSERT_GT(len, 0, "Failed to read monitor_log_path"))
> +		goto err;
> +
> +	if (strncmp(buf, prefix, strlen(prefix))) {
> +		log_err("Invalid prefix %s", buf);
> +		goto err;
> +	}
> +
> +	token = strtol(buf + strlen(prefix), NULL, 16);
> +
> +err:
> +	close(fd);
> +	return token;
> +}
> +

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698354E68BD
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352706AbiCXSgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352702AbiCXSgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:36:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79332427E8;
        Thu, 24 Mar 2022 11:34:42 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22OCIKHe019412;
        Thu, 24 Mar 2022 11:34:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+uVJrWu9tjPLvkry3QqHHG6wZcsJJFWtBIm5LUplwvU=;
 b=QDQ1Pmgu2BYMrc9fWJ5H3g/d9vp+sxyX13Eb6ocKjH8cvy8uGECo8HeX3UbE/mBC95w2
 MJK9PWj4LVh+uDDr2CmcOZOpUveFZaYr5JElkooejgqmfx3Jn9OrPP9xUQPCe0mPmg1h
 z7tg+VTs2IjNY2aHfN14J7h9o9llhYS/+sA= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by m0089730.ppops.net (PPS) with ESMTPS id 3f0rh9apvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 11:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oj+kaaBApEUbwVWQTWbwslseNbYJfwf6t25vWaLo3Y2woJfWTp/wt2nIGmDytFCTwMrkfQ8u/bQYgSXt8Rg/8a2cQ3LQaEknYPr307Kht4NrtLpJDfPk7Vfh6/WU2BMhELMhmqnoInbZlVTBojC4+8acSH8kg1SxdzoU0JlXvL01WATPSADU955sTmGlF4rgIWRkCEbuGVVe/MxEJTwLxq0RRfOD3yaexYPFoasbchJHYumquZRcd168k9ZMDP9u2Yl0gtI/QeXHkXfQSt89ajkudd9AMRStBhowBHlOzcj3RmgG4gASKDibKBDCvViQ1khRgEfqRhfc1oTg0p5CIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uVJrWu9tjPLvkry3QqHHG6wZcsJJFWtBIm5LUplwvU=;
 b=eHH5PHuhdMywem9/3EJkhOHHs8dSMtx/xlwWx3+SvZINjmjno7K9yOx/3gUL7k244oJEeC34U9xjVik/irW7U6wRrTbz5TRZC04aJ5IyHoo/j/N92GRTewswTCyMQAFjejy5KMFcFhCbG5DS9dd7nvmrcH/537YORl2oJquqoOa8ZVewYAIdr89ZcQnek0rR4OdJiRjht2NbtlVUznTOWvavZX25YBAZ5RlcTWmZnM+SgdGqujs7bq7tN9qk/lHclNzSV4ZNSd+1CblaH38+qOvgOIfNhGpXZYLHPTwUILKYOmYQVGQtK0QpvcuQGV237wGDEo7WTibFfC8f+g57ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by PH0PR15MB4717.namprd15.prod.outlook.com (2603:10b6:510:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Thu, 24 Mar
 2022 18:34:26 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::708c:84b0:641f:e7ca%3]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 18:34:26 +0000
Date:   Thu, 24 Mar 2022 11:34:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf: Fix maximum permitted number of arguments
 check
Message-ID: <20220324183423.6ht7hlat52ucsvfh@kafai-mbp>
References: <20220324164238.1274915-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324164238.1274915-1-ytcoode@gmail.com>
X-ClientProxiedBy: MWHPR15CA0025.namprd15.prod.outlook.com
 (2603:10b6:300:ad::11) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaec569c-6911-404c-dfdd-08da0dc4ecc2
X-MS-TrafficTypeDiagnostic: PH0PR15MB4717:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4717B1B4AEE19D4F29049E90D5199@PH0PR15MB4717.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9MNKenbzVGbtw06pWdpLsMtTt/kefaEZbuajyIFNGGsltzCkWezVKyMcCSKPfDU3ypNDsU63NSJgHviVlTsKfVIFQVxRgJLYR1/lnl/Ay3yBB/1uGrm3SQfcSQrzDmR025grhmw/I6gmEJexOw2UyICq17BooHEA4n8Psq1r2tyIBvzpiIbOneLeMp6PII3KpIKarIOFGtDAF2pulrhlKduQbVIRjJAJ/DVgaxf8G4MoCkji8Cuq9S8HY/BaQnf849iRVybWC9IISs8goJLMhfH3kvui+EHigtKfCh408q3bkx3VPWgazgRm2N3/A1kV6clq6I8dHt3AmfTzMxbc56UZNGp8hZIYnI/CthuOL1eTAjFPWtVN6QzTe7r2oz22DUTKx2kWQVUBOHh+eYWOz9YGdmj/fN7FW0RVQHqTIjisG4YPrt9PoxApx1IpThsXdc/oILTaasW7aFk2KZOVc+xaYW5py3wF847YR4M0L2ClCG8qTNbdE4tK9oNDyktqanIoj3exoVxpt8O/U5DAltyDXLXxeEHwdPd7mO0W8m0Lom1y13BThi2UWcKz1s/4Li+D+cQ3LYxelnHmGtni7J1QWNcYqADgnywGCqa4sXzSJWWFHqDDNxdiI/iGNXJV8vNgrHqKghZT1kaF80u0Xw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(508600001)(6486002)(2906002)(66946007)(86362001)(8936002)(5660300002)(66476007)(4326008)(8676002)(66556008)(54906003)(6916009)(38100700002)(558084003)(33716001)(186003)(1076003)(316002)(6506007)(6666004)(6512007)(9686003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/KTzig+e7Znf3yaZijpvx92R9itXkz0nPiMlFqVQ17hsi2CYoZSkbS9RX2hj?=
 =?us-ascii?Q?BR3VsKza2A54gI4dK2fSA3momU+diAjAl1gUxdGAL2yVWsE69PG/lkUov0Ie?=
 =?us-ascii?Q?G4wpp2DAMrqQ10GeH28POxKX0szUM2Z/VM85OGndDvxhRW+iSOdbJ8dtFpXi?=
 =?us-ascii?Q?fFKjbWfe0z7gLbOcVx8stfVdGTxxOToJMKv6peWHaU+NnFtSzwnveHcTBW4a?=
 =?us-ascii?Q?LGTKYirT0IWsO/60zw6B7OtXpFsIfntoPzwtk0Hm9RDK3wlKZ7/VRy4PKLis?=
 =?us-ascii?Q?xtENeuTrJAmne0LNojroF5sIf6CkqbNI8eM1BEMKeigJdL8GHJlbn/YTvwX7?=
 =?us-ascii?Q?x8sSLQLTo/4JNNbDuf5x/zwGACAML/jAsq9QzfulupRc1faF5uRoTZuXzN1+?=
 =?us-ascii?Q?dedV8hPjb0/uCxnyrnPtlx3k+9eSe5eaFQ6nKvyuEknPGIauyHAsVIiFFom0?=
 =?us-ascii?Q?o3b9/qvfVPgSS2m4yI5eFhkoh2sn8JgVZSjt3A+0ElGntzrA48jbTQ7ovNJG?=
 =?us-ascii?Q?C/eFA3v22y4hxpLdcU+8mHMmhlQKuDkBbV1vtbbsKu4ht6j8I5H9WviTL8vY?=
 =?us-ascii?Q?AL6dNNRExMUsVl0pKGMFHt+JyS1jd5Czadznse1WyY6Lk7piSHRKeU6KBA3Q?=
 =?us-ascii?Q?KuhZESw+4jBNMENEXhq8lPF46PvluW243JJ5k+xU4TEdk2D1eVwpUIVCAPhQ?=
 =?us-ascii?Q?rt04npociRxwY/pMjU9et2QkNZRJcvqZ+Nziy/wqMZVW2dmKpTQUHmlJyhhW?=
 =?us-ascii?Q?gqd9Q7oMy5v3W++8gFo1XoAF+6QDvVuXeCLXiT+UMfxl/95hENNK1AX3zaaQ?=
 =?us-ascii?Q?rE35F4f6hFil/7u+dx4DGFLxV29daUqR7UK1BdhwFQcj3kLwRGFnc9aCyXZD?=
 =?us-ascii?Q?kVz9IWRPX7AA5MVOzVOj2oXAfPuHNAyhpuCh/3SUJpYFh499WTvaNJkJqLAZ?=
 =?us-ascii?Q?opPfrv+c6pVQQuczZ3uM7UdxiFkIzO/KNLZPwUevvexDClUPnmwVpAPlzBvs?=
 =?us-ascii?Q?SznX1O6FmiD0csQKSvlLdY1d5EtE8dndpXQSZEic2liiAJX3OFPPO4FxVT1I?=
 =?us-ascii?Q?e34EIziSAHO2a0cwDgAIbtbmO6l7sqCkmPCUl2HSH16ert9WRBvKznmJ+ZpG?=
 =?us-ascii?Q?kAWPeYHMxQrRYWxygNKDUajAAQoiMSJOVprllOIrsuG1SRw0PIg3cHybv9Ur?=
 =?us-ascii?Q?CIobiUivW5j2WmqbqaJIPnYqqwGNiwvhaJzK56rfD+cHKl0+G3E3F4BDjIvR?=
 =?us-ascii?Q?eOt7v+iAxHgxPZUzms8TiUqMYo+2Ui0U/dHSrdt4lOXL8w7tPxRQ/ndDIgCe?=
 =?us-ascii?Q?ftdcOA5jD26W1itCuJOIQRIu6A4J7A9JP06Bwmmzm5IDf2bKT0VpzBvJnra0?=
 =?us-ascii?Q?v7+yeunY8PfS1Gx3JGPjECAxpWRoso6nrYFoK6BUP8iPYgz8qLuK7h/E9g/E?=
 =?us-ascii?Q?PuRFzA00YhQGtU6E6SA60UtMxgeRogmgjrGe0lKY+X60X72WEXbkia+EP7eJ?=
 =?us-ascii?Q?LrOm5sjRTTNkXg79RTG07mq6zyJcNE0qr7oCxtuvIwGjr+NJ5jgtBX5011ZB?=
 =?us-ascii?Q?bg/iU2snXEXhdMRzLAKUuArNwKEojOVABA/ItSl/WA7Kj+anFRwkM4GPzzwc?=
 =?us-ascii?Q?2U6zNKUK0UYEVnDc0zLIvt0dATd2K5UYXtIIbD57nhASNrzjXo2zSp6uW27P?=
 =?us-ascii?Q?qSUWfwC86qLQIKootYBRtThFWPqW57Fe/ta9lNvqXIFW0YJioacKffnMQ2EG?=
 =?us-ascii?Q?xoXF4EwxmI3mH7NX4vaPRCKfV1J5Ya4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaec569c-6911-404c-dfdd-08da0dc4ecc2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 18:34:26.5478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0E+eSuBF6tKZw/bN8uGRwZlDK/uuq+t4FmhVmn6Wy4Ss0T2S/k3ioiO4WhzGNnO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4717
X-Proofpoint-ORIG-GUID: utnNgsB_BKAQ--ZGF2mFCLAeeIGI5PfC
X-Proofpoint-GUID: utnNgsB_BKAQ--ZGF2mFCLAeeIGI5PfC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_06,2022-03-24_01,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 12:42:38AM +0800, Yuntao Wang wrote:
> Since the m->arg_size array can hold up to MAX_BPF_FUNC_ARGS argument
> sizes, it's ok that nargs is equal to MAX_BPF_FUNC_ARGS.
Acked-by: Martin KaFai Lau <kafai@fb.com>

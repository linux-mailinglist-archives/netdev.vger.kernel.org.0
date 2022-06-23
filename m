Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1E558B6B
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiFWWy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiFWWy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:54:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1EF56C05;
        Thu, 23 Jun 2022 15:54:58 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25NK2som012266;
        Thu, 23 Jun 2022 15:54:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8+gjz/kVWvgYLzfECvNWeY6QmrSd2T9wxnMtZjiEzWg=;
 b=JO4ZYLMB17Ukfi0bVJPRbzehWK9Z/tZ7CN5GX4RdwErlAtoLazl6vu0jXYV0suZiRnOj
 1xwb/KqGx0H5gMo6a3pqYfwgsMObhYxJPajXLotmezvy0LL75gyFcLUfxWVV6cfdmQT5
 tH1minUCWx9eDhk+bR4J/MwOhpsarEd3A8A= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by m0089730.ppops.net (PPS) with ESMTPS id 3gvce7y8d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:54:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E9dm3iRJRRRc/cJAxey01xDyepyBug6lBxu5dDdEcHNVzq+0B5CcNWEVKcjA99gkpHpEZIb2izFe2P+rbSszp3spdRV4I5t2D9C9Np/VY61H76Kx2eZyUEs/SvsnwcyRwjMwz12yiCya4pK6yDRFsPLQ9dxmoVIXrQZRRYX/h0REWWLCEiCwwWN6KSWX/hOFSEXuFJ/XmhKG/vBINhLbYQQeYaS1bA2VezuPTsm7/XTRlaaWmuvYMTd/ljocUorrkwvKVNVuKXLvGJPRDQbDgm5vpEjE9tfhcM/eoaNgGNLdLjPuPxto1zuf1QibPgnkivyUf4ZFogIMOnxwd6iitA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8+gjz/kVWvgYLzfECvNWeY6QmrSd2T9wxnMtZjiEzWg=;
 b=JNSR6WpFI/02QfUAkyG2+0EpowTSGxHdlvGDpjqXMaYbcO2PAoz2K0ZPPEI0OmTuGNQ3LjtaWks0iiRyJg4t8mwGfQu0wxzQ5oOFLA7heXrRKz0aTmAnuNdweGv35YrE7FWL22XC7zR9v6AUxfnIyIMBwEyrhmNKRXo4z2JtVgq43wijmQwz4F+zEEWvj8Ovsaki85kWN47c0qyNsKgd3C8DGgqqd8/MlmhW0Knw2pwRZBZChWfh5DfuhrBhmR5YxsmzPLAwnjvK3JDaTY940QsaV6mamB3XuZuSLltAHGjbz3MXD6rU5OcOrylPzySKrLqtkCXCUVGNu4hsRtrfvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN8PR15MB3441.namprd15.prod.outlook.com (2603:10b6:408:a7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Thu, 23 Jun
 2022 22:54:42 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:54:42 +0000
Date:   Thu, 23 Jun 2022 15:54:40 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 08/11] libbpf: add lsm_cgoup_sock type
Message-ID: <20220623225440.unpnyba66evj2cd4@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-9-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-9-sdf@google.com>
X-ClientProxiedBy: BY3PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::6) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c6617ab-f3fa-446a-e63f-08da556b5c34
X-MS-TrafficTypeDiagnostic: BN8PR15MB3441:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QRr7rObI4B2sroE3kodg5Ukzp57T9nxzraXpUG7L0LRcUTumJTIpnOiMuxperIgtJdk0/PMNj6o0TyWl6CK27k/yaEk5tSE8aBRv6g8cz08a3vCwSBFEHSRhoy5JHeMTcDcTj0U7gXHozFj3BY3MzjJIKgHG/+w/iGYlZIZ5Eia6mlNblop5sSJmU6kl5Rw7fCzVIjNyb1qFoyrOlaI6yoRj7O/++Ig/AjOMwO6mb+GuEFp0VhJ8yw6MK0nQqXdu94vvMemNq8dnhNBuTPLNn8s50eYSSkuq4A/2UdKQH4m/ZBDHLWuUWplvqO1VxVsN7goSLtS8rz8zmTZRzVEX82TuWRYNF73lE0I2b1YGBQxAK39uSHMCjutfu7cd0pBQa2ykIJO9FNvRnHl6dqSkZPfOfJV62s/E/ZGoQfqJDYbwPjtegCzN3vZ+u7kdyQGZfmcVxm0SKpwBZnfSNQw3+IxP6x7reOdl2hbgQlohFC7qXj84UzGhGoDJukhMysBkC+kzB6dbRn7JNfyNVfxG8/G9KtQp064/N7W8nXlkzOre+v3cBVg03OkT/y0Fj9WsfGTR5DMM1ZNLeevVg8gw3Wy+nOiPfAGZOwFY202rnmWJwy7Lyr4HZOh1eD3u5fV04cnUTQ6RLJHnDjsDzifKmqNhgKARoGyk0C30KyC/a17+cARGdhXUfcP899f2CJfdOhm4BJu2B+J7hCQgcb3oPtUkkZT2Z0UurDXLNSsdXSD/VmwOa11SXSZ6rCzW7Bm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(396003)(136003)(376002)(366004)(346002)(39860400002)(6506007)(66946007)(1076003)(38100700002)(33716001)(6486002)(478600001)(41300700001)(86362001)(66556008)(2906002)(316002)(52116002)(186003)(66476007)(558084003)(8676002)(8936002)(9686003)(6512007)(4326008)(6916009)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jXzMKdaPtoiPABqyXNnCNMHdH6ryz9XqlDfpmkO8CgSmkxGem6YXogtUyz2c?=
 =?us-ascii?Q?vBkLF5jcT7jmJ+Fh385Yi1+HWLwUenycNuj4PbIbCUSdC9Qdke60JwTq+eJ0?=
 =?us-ascii?Q?CdkXg/Ph0hQAG7B9UJoNdiKmDnLfjBVFC4RdDfzaw647Cm/mz1BhydT4R8de?=
 =?us-ascii?Q?hztwFi+GZgk2Mna1t4gX8i4NAY3jNiqVHDCLbBEBoUJH2QkNfR4kRzAYIfZo?=
 =?us-ascii?Q?sRls7HS4fHX/uBHJLDZWOkPC4xct5LGN6l4799R/58remOqMfJpDmwICxbyL?=
 =?us-ascii?Q?9L+CfBTNu+Dvk/qWYNuC6G3b+sBEh4ljy5qvRZ8LIE+BMDqogLBWxcBBaw6/?=
 =?us-ascii?Q?rqTKQDBjmtf6QLi0/XysaP5bpSYPkqLCiL77uYDCVidZ+edpFFSiyNCZ+J78?=
 =?us-ascii?Q?vgZG8xYLvs0koyqa9M600DAvdrfUVa/uuOKcA1CX/H/j7cReASRlm6YPkof+?=
 =?us-ascii?Q?PJHOrJLF4rFJL1pTwE1CM1FEEkw7XOFAOZ5XnZglFsbDWgSD1cyu6n7bEsTm?=
 =?us-ascii?Q?Zeytxq0WCaHSXlKQm9WrLMsVfqN4jL7osGxzWLGHmrNQ08rm/phjdavkNsC4?=
 =?us-ascii?Q?EjL3bANdJNTyPAy4oy4WfEH1Cf1WUiJr2oIfuthFmSlnMCT2vSwyfqrNsiE7?=
 =?us-ascii?Q?+9iLs9zR1S8goYLU/4RUSPlGgDtwaq/lm/XmmvAyauGsIiLYKBwto507R/DW?=
 =?us-ascii?Q?VecL0bEKv8tlN4iLPUSqdjxdQJXTbJSfEEASYiQ9333++1Ok0K26ZUip8LUF?=
 =?us-ascii?Q?b1PFWbCar3Yd+f4mMm1Rmq4ppWShVzXVR1CPwz3jJiGExD69n21pclOnKugL?=
 =?us-ascii?Q?G+Wj1rwFoIU8priTMkbT4p1ob0YEqyItVqd07A2OktAHsynworoekze3oRDY?=
 =?us-ascii?Q?yPqLOfSIr1hrbMVg6h3zdwpwxCUOwJjcgsJZj+OssNzTXOsEHdndPnAhpaAt?=
 =?us-ascii?Q?6vzPdwRY4coIwzgCXANmgl84rr3Ymoz/1u3GyoJy2M+KN+RalZBWWYBVXtu6?=
 =?us-ascii?Q?VHXAtzu4n9yVVhkMjAlFREfcNOz6zH8DirMUTiakx9Uw7jXzAsA338o9IAnp?=
 =?us-ascii?Q?UYcvvUE8V8rWGEzo+g4QygU6fqfHxICjNNmWlw4i/WyilpAlVzZHH4LxIXYK?=
 =?us-ascii?Q?1LTfmAwsI0oLAq1U+0K+MYRaOaYwM2sC9/ObDifsXSKYYhSXgtHYclI9KrhM?=
 =?us-ascii?Q?kL8Z1KUdsYiZ4hj7/aTSaA8OLRjhrNwHo8VUJvKXXCiiG8QPjBaYFEg/Tstp?=
 =?us-ascii?Q?RQiBVVx1x4cENr1aphgDJA2wkXpr4A+OZisiO9zDoutv/+Y0rf7CjUgrskoP?=
 =?us-ascii?Q?xLJlFIk7O8mkbJ3xhiGpqIUeW8NizE+fG5CUAwJ5izArSq2oDi2OrAlGmGrC?=
 =?us-ascii?Q?lGNvEgpK5tlspG+bFA26Uq7578+QiKXgGXxfNxAktgaEB2j93kDctPMrHCzD?=
 =?us-ascii?Q?wj7jLMYhZkSwjXwD+ixVNK5NUOCnytcG6qSh+QrDOKR6b1y8DR9NRXNYyZ0Z?=
 =?us-ascii?Q?hHquTA2b3jyCPfrrZlgfGw+kGkuyecsbWUMJWGNeYWsnll0mjOVn3YRtjt1A?=
 =?us-ascii?Q?PlQNvUTxq76gPeiuuHJPz/ZQ80AIpk9JZ0ZOGPHgNAOU9UOVca5joGQGPyMf?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6617ab-f3fa-446a-e63f-08da556b5c34
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:54:42.4271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfzykkSj0tT/X5V223qlMNfIrpgGqxzZ4E5AbEvCogGquu51vK9wufVywdv4s6Ri
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3441
X-Proofpoint-GUID: PL3KauB1czO-EW0iSgL4TXpRPsenRWNh
X-Proofpoint-ORIG-GUID: PL3KauB1czO-EW0iSgL4TXpRPsenRWNh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_11,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 09:03:43AM -0700, Stanislav Fomichev wrote:
> lsm_cgroup/ is the prefix for BPF_LSM_CGROUP.
Acked-by: Martin KaFai Lau <kafai@fb.com>

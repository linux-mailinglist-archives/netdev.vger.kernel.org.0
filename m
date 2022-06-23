Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427F2558B69
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiFWWy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiFWWy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:54:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079AB56C04;
        Thu, 23 Jun 2022 15:54:25 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25NK2sCt000521;
        Thu, 23 Jun 2022 15:54:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=x8VdgF+Ak/tUZmq/DSFMgTkt3MyLFPRipLkXdNQRPh8=;
 b=jy0z95SDEHrAoMHaJrEKL24xvjQ9kxOAXjQJEZW46bAH3D9vmHg5nRMJh5/q7xnFOZ5V
 Bf5d4XhRF5uHDz4rGPQzUGE0Dw92O+ON/kqDTwQd+Q6U3PiD44wxAnMShwOeFJ7NQrEN
 uR3JEppe7c9jxqZiSDtvZOxxDMN9ydZsHQU= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gvqwxm04y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:54:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hk0Fw7OkIHLXL6gffWDGN3KV71NBa/WP2F5wHrpMMgBJtgWU7srbsjnPJBy+qbsZ+E2bIPSJdxHpwMAJU658GB6N0AJQ78Hy3fuEnXDnIc1YRp+IB3/dmAL5hECh//7Brpu4D+sKiuPOY0RxyquiDiK0H6Bs+2FUvEng9QnzQEOQDpOY47Uw1KxFQSGCkCgyG6m9/EjwFfK8j7jnQ+2FF3/mAj1oh/NiUKhGhfYZiaobmt2RGHIIyigrdC1uoEq3Pn3hu9jeFIdPiwg7fuBK588dAxg86QvQzJ3keO9OHlDgQ+5OaR5lqI2ufoVkSVI9rHOSmdLykZFlOwE0mi882g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8VdgF+Ak/tUZmq/DSFMgTkt3MyLFPRipLkXdNQRPh8=;
 b=cgK6GCB41cChWlI2zcb7AFhXsnY2ynyJE57Eqkvqdh2vX/CwqxwTIdX+V6OwUoRik/N5S2mRCCYm8daniBD5Ucf1m3ZDHpqk8VtGb1LCynRHfHNKC1S9JMsjPp5WQY1w4nOoyaGalo+Agr/rcDDMyoFVY2UB3wx6cSUSM7KTS4WJIQzfUqyLu8q3hz7PdcuLfjRdMtH8kKeWEiOWxyE1KXEGKSv1KLF8Cy8iisTevwT1yBrj+4azFwJi6s27/JOlaDThD9Vx80/g5aMBBGrAu8jXDs8rCvt0niRQWP/1ZmvyeAWOtZ3f18nus6Ibb/mikY1H1Chs0X1CHW+oHSYzBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by CY4PR15MB1719.namprd15.prod.outlook.com (2603:10b6:910:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 22:54:09 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:54:08 +0000
Date:   Thu, 23 Jun 2022 15:54:06 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 07/11] tools/bpf: Sync btf_ids.h to tools
Message-ID: <20220623225406.n5kds63j37j63dxr@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-8-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-8-sdf@google.com>
X-ClientProxiedBy: SJ0PR05CA0140.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::25) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b0f05bf-c0a0-4109-6741-08da556b4833
X-MS-TrafficTypeDiagnostic: CY4PR15MB1719:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /haPYSuTGH1Ja/scM6excQraJaNE0aSulVcD1fz5rW0ae5eyi6gxLOkABpcAc+YsBlGX1im1qr2SW44wbYdV4O6nNqjYttdhSXRguGjtcmUTuQlbnjAxeuAk+F24ZtZI1vNghr61dQFeyAYAfclLcO64YCujdWRsFffCv3H0e72tY2hG7kiv86aZYZPaT7XREDwsltqxON5BUYLk++m3erlb1W/b/RdjrH4uPio0L3HNv9rn9DSWlEMZC0WkumVUNF72J2Cp8P/B/oKfQWAUnlvtY5kZkT8HU5yZB0VaxtmsyVziPk/UbRGiUSasCe6Z3r9TBwf1WnsSC50ICwWJhkvW8q2WGp6+pjd9b/k0o3LRinvcJdBoxADsuBC8dgfa4sdsenG1uJhKUL1IlrI95Nh7wjdwVYLQNUjJriHUyiZfUBaH8b/hzQM3/54xffeTREMjQUPdEF/otJkq9g4bJWPl1OSXOfAqDsj4vhOxYqGSagGLIC1wXdsg6lTWcmNaHQHcPKCNzDyfaRSkemohiQmnCN8/pS5VsalALy7a7Ie0fvLPObln1Q2JLSxOkReDwebC67VIhGwqEAhJ15buWCW2K+Y3eTnNaROt4jRaquI6Qq6ibv8rFYsKBa1o59NLvwedAjPi/YI+F3E2IpW/E1/1eLpXCDuBhv/4RAEfb7Od0ZSEy0SqNFH1xke9Lvmuz2O8tcto3QNxL7gb9bv2R+lDc+yBckeNAMQQOxf7pMGFUcDUxsiFgIVhPUL4g55P
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(66946007)(6506007)(66476007)(9686003)(6512007)(66556008)(8676002)(4326008)(86362001)(558084003)(83380400001)(52116002)(33716001)(41300700001)(186003)(2906002)(6916009)(478600001)(38100700002)(8936002)(6486002)(1076003)(5660300002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p0WBtGlKuJ4JYYFc4LZ0mvI6L+6xiL24WwPTNfpNI5PUWEzEzQMYov1XH6ON?=
 =?us-ascii?Q?GAIjcqNh1pblzpKMaMv2ptzAv70HbCqFBYhz/i7uTjNvevFSYjzx9UPgOsCI?=
 =?us-ascii?Q?OfySRkxitgS10yrdxc133z9fx5N6ceqfKcW1bxfCcf6w3UBhpikAWWihCek7?=
 =?us-ascii?Q?86lCIM/knkCztbkzzFhmrGcfli7GI94oN/XmdEvHYEKy3v762UOo9c6tpLv7?=
 =?us-ascii?Q?ub0hWWT5X/3XhDSchbsTxGpXrCMwB+CwTXh7chylHjdrLjIgVWD/sYB4ICce?=
 =?us-ascii?Q?l6jMUtjTToiIfSWf7+AfzHiek1I4IbEZFxNR/0uzKbeevu/t3O8F3VgIJ/dQ?=
 =?us-ascii?Q?uWSVQIeH32BNgOl+yRx25gpFj2BXgT0yYeIkwnO93t0i+Tc9hz5C0eGScxG1?=
 =?us-ascii?Q?IfILblTkQR6aLWyT4X3No2RkY10vHIbPnJQJmGin1S1rUw7Oa37xXsr7E0ft?=
 =?us-ascii?Q?75g0IHHr/v35q9wWsQqmVUTPv0GourTJ7JPwQIiTY/miE14k2c7CF0I/7pRD?=
 =?us-ascii?Q?l8qa2s4429+bJg2H/Qi2H8wynGTHuxkvMeS9846iL6zoTb1+DlXBGny35V9i?=
 =?us-ascii?Q?PLOpcaZSv63GUcHMU4MPy+6tHVpGnZk7FG7jMYsk4zbQikNTzMjJO1lFjtfh?=
 =?us-ascii?Q?b5kcjFJJfuIHkiWOaKz9lZSEGtSBdx+ccQAhDsAugfXjEFF3r+5JwaE4+EAt?=
 =?us-ascii?Q?L35hOCbo+G08nqXIPr0BZHTM6D6saw7UeJOwBxEPFIit9gMksuF6oAaC/fPp?=
 =?us-ascii?Q?SKrbqj4OM5CYSbWlyiPm2a5gtnQ1qnbZbRnJIhs9vuZrvmIJykgCjwrP38Y0?=
 =?us-ascii?Q?tkmK1ri93leoa0zZqsCsxMfqnLThm9TKk4ShhLpH3QYqnCudEOwCIztRQMRt?=
 =?us-ascii?Q?TiN/+t50ZiF4rCOCRVuK+VqFSGac2Ry97027YAglm1uwp93Ew3Rc5t5X5+7J?=
 =?us-ascii?Q?w3/Iq9gidrFshytOt5WEHkaRkyaC3ZoSMIgfl4+CjYZJ8IIkN1jxsf/ZYz7e?=
 =?us-ascii?Q?0snRVWqNp16lGF+AMf9aJ1yHt++4iCjNu2Xlkld+6AsXglm7zF0/BVw/aBMB?=
 =?us-ascii?Q?HfTN3ZD9YO0AGicNtGmxnmoW47N02EHwt9OCHHpI2O/2FfPYi16C+Udlr3EK?=
 =?us-ascii?Q?r6qS2q9o6DmPBlz05Vk1NR/wbISD5nwsgjvsptinb0UF5lrwzn+KiShmoLfy?=
 =?us-ascii?Q?KgojWJSRjoGrfwu3cHX45brh80bdnJ/Gc0p4YhBQVsCGfOFJvQsE5Gcc01Pe?=
 =?us-ascii?Q?bNX1f5UH8IORl1X7MT0gWP1jbYfpYu8Ivud1VDhbTRiOqDJX/svlqT0mALOT?=
 =?us-ascii?Q?+uZV8UdpO3a5uZhMv6emXwQ2F8FmBs6rqCJ6znjWx7LTE0Lc+jyxEkFH0z/Y?=
 =?us-ascii?Q?iGIJylcPD954puWLnVDfcUjmgzSAJtnQ7tlwOvFD15tY2ECNJoeW6iwLlICE?=
 =?us-ascii?Q?GZxIpAl2hbtwDRXqyEZ1SpswiJoallojWwnfmN6N0Ds5pgEYxONWbcJKdAzz?=
 =?us-ascii?Q?m/qEb0vSpy6HZhEOSRzct2tb//EA8jZVe8hrSwyY+b8m1PSvpjA33XSSsZOs?=
 =?us-ascii?Q?IBVY89LsI8tNqP9seCxSyokFsw8LzwygCIhGNnrIvRV5USyjyR83tiQXFZqE?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b0f05bf-c0a0-4109-6741-08da556b4833
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:54:08.8630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OyWqT/77zSHrwANjZkyM2Wd0SC0OhH6WCax42L8rWnSRr0gsTgg7SC7XWyrSdMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1719
X-Proofpoint-ORIG-GUID: BmyXTIB5oxTPdpFvDZ6x3VUTsni1txmE
X-Proofpoint-GUID: BmyXTIB5oxTPdpFvDZ6x3VUTsni1txmE
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

On Wed, Jun 22, 2022 at 09:03:42AM -0700, Stanislav Fomichev wrote:
> Has been slowly getting out of sync, let's update it.
> 
> resolve_btfids usage has been updated to match the header changes.
Acked-by: Martin KaFai Lau <kafai@fb.com>

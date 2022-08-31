Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9C715A8950
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 01:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbiHaXCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 19:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiHaXCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 19:02:15 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5AB8FD41;
        Wed, 31 Aug 2022 16:02:14 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27VJrYGq001342;
        Wed, 31 Aug 2022 16:02:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=0u4fGsRwFEz6YfUIswhqCx5WFhEvNmp/Z3cO9EN9LHs=;
 b=Wq4rafAlmcrAfGwhLVFnhtnLlY2n18BmN3rkHHt77K2ISS/jcDX0i27te6Lz8ydAQlkm
 px58NklZFIkUA7qcS/6xd/6py4aYMtsJhdxLcI9WH17Yx9I2z4HemlNSR3f2b1RhnsPa
 CL0fA1tYCuN4fQmp7vh/uLxDxudRNmkyQcw= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3jaab2u2mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 Aug 2022 16:02:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgyII2n6Izn5fAz4MMU6+GQSzp0J5bRU5ImGJBrQfeXVl7xXLy2PLwTpCBZeF80NUCNZiDo8iyCs4fl7W23zlAOA4lghyVZY05I6OcxLBcaFawVl+JBwzjRdk69DTB+fFCFca6GZ3cTqpUgMy2Kdiuom6xs74RfwpJNsPEt3LBVwEtTrb624jcUG38CCzU95gD1Y2xRVQ8Fq0kXnBfj+fBD09u03QhSdnuDwonjAsrPH+roSSAE7iJG8Do9Sx2GSBNjAUsN9ce/Vv9EXYtgpMH1JZA4Fa6i3E9AqC+Bz8Wd8DfH68i2SUp420Gfsvlwd860WZvwpkSLMeFPBic0LYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0u4fGsRwFEz6YfUIswhqCx5WFhEvNmp/Z3cO9EN9LHs=;
 b=fKDgs81FMVI4KixrbFZRJmWHVJwvQYRJjZNUSDRnQJK6b2pawR8G9GzhvpWt9wQHvILWLamE8ofYGj0Q7sdziBlykvrTlJZ0j3PU+YOC9yZj3NOun0w6/nU5BGLagx6fhiVZatqmWDPUSFwdQqae3cmVRN++ldgJHKRnzI8moROmdOJ2Yyy7JZlKBnSgKA6fJ5Dsfti9eoucDPI1GpLb2dq/3vj7Y5+gSO6ohz5q260lizRrMWhnbQBUghEOOhIFA1Ji/fLPG8bh2Px8FYysdPNP5kbDXla/VJ7TiaSoxvNlGWyLD3h6iU1Cpek+zulmg0IR72ysPpsAHKzWyxN2UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by SA0PR15MB3823.namprd15.prod.outlook.com (2603:10b6:806:82::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 23:02:00 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5588.012; Wed, 31 Aug 2022
 23:02:00 +0000
Date:   Wed, 31 Aug 2022 16:01:57 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Aditi Ghag <aditivghag@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: Re: [RFC] Socket termination for policy enforcement and
 load-balancing
Message-ID: <20220831230157.7lchomcdxmvq3qqw@kafai-mbp.dhcp.thefacebook.com>
References: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABG=zsBEh-P4NXk23eBJw7eajB5YJeRS7oPXnTAzs=yob4EMoQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::37) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52ec6194-30f8-4949-4445-08da8ba4cf99
X-MS-TrafficTypeDiagnostic: SA0PR15MB3823:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAJHbb4gV+b7cCbrM2nbd9xKfXL5o1my5VURQrOxvJ1j6OZGCDBzqJhkqb5cklv0jR4rnNHnT2M3hpHul+ea4fjKOKS+cuyrwIaLFL9sIzxZ6Y2m+uKaEcpoPT654yQuOi+pi+kCOXDW+lFmCaNJlNVKUaXu7SoVwXa8v5GjvFBE09gYsYOoQP9/dF6uczHpzp+6ZPQqx5XdViK9iiw1XclqB8IOy/Usr50Qo4j9WkJW1lxAc4i/LzzI+N6o7Abd8w0ktoTiva4BcB6F0NLI5Egw3nXdd66B9XzsbfOLOZ2HgH5YIlITZrDvdzXEcnc0lneCgspmKg8OMFwxbDa1JDO2k+RGmgMkh4g2C2cYcpwkHbkNNtwA0EO3P3zC6eEh9a7jskKKFtQWJCg0QQw2/2aqgJGPeTeurbr6psNiWOpt9QcKPEuqf5YW7xLjdFmvBZJefqYBhODSXXKNlbSkz0sfwqh2aDAkNz5a5r6dChYGuJ74rhVM+/WuMqY9bGK+Rkir++b2f9snuKtiN6Etnr+TA7EpApLq6UE9NVqKBJmAoIX6Sgo1b8QaQvvaqKupWfO5nSD5kRAz+AoSsl0xGpKx5dhMNbuvhj+GamP32Rz03U8kfcitwKbRnVKIGeBMaWg6HCmttXeqWTitwUlxBO1MnOHUaMCw2YNy9Jsn5Kb2YTl/oOB5Gp0MMHwrSwjAfnwVOAQCI8TBAWk945rh0RvbEh202IQNkatLFf+24to=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(66946007)(66556008)(8936002)(5660300002)(8676002)(66476007)(4326008)(478600001)(6666004)(316002)(54906003)(41300700001)(6916009)(6486002)(966005)(2906002)(1076003)(186003)(6512007)(52116002)(6506007)(9686003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cJtxsAbY6GHPTrXJAySDK6LKiF3QpYDdEmiVpiq7mNAH30444kaA4z9jLhcv?=
 =?us-ascii?Q?35ZQQ+AIWZdGaS8sajApJASxBzKa2hxZB2mk0JuOlOd3bVJb7URVlbc17nQ3?=
 =?us-ascii?Q?3I1k9hKQJHEd7yALoWlzCCxFGyh9kTSJJPNpZ4zBTvSbBIY7l/ApAcwnjXVx?=
 =?us-ascii?Q?9Mx3mL/Zo+6RzYtoRn/zxEdX/DwHeIkMMult3i5gtpBo9FSLgg4+Zw1tsp6r?=
 =?us-ascii?Q?saVP3flw2NuWAbe7uJeQvAhaTlXCrJRCvxiFXDgfR46xjF3Aks3MpK7c9IRz?=
 =?us-ascii?Q?aJB02fBC341eeDr6L+8mcBAXUoZj8uiL3lw86H8rY5lO6O2o6XFIXB8tvZVH?=
 =?us-ascii?Q?leXbbcjMIODHY4yzQ0frBBOjNv/luQ8Uj+BdexnK1hmSmmDJZOoD3ExfTJ4D?=
 =?us-ascii?Q?NTBHQcpo0NIuOoWxv1bprr83cAZtbomAg9VRAMBOuSr4Ocml9KeuYWnxp4Oy?=
 =?us-ascii?Q?lHx1YOXVy4XVXJu9IRA2+FNyo8ElXNSfB7Z+K3p6j+Erw85Ul0Tj9ZgqkNaP?=
 =?us-ascii?Q?MVLjknc9yS4YebA/SXzXSAAnlY1HFU1w0VEi1GBWNDFLE8s22eVdOKfux1dK?=
 =?us-ascii?Q?OQNfja9E80x0IX91mlKqoE9r2SPIfxSPO/Na9+yo0E8imp9ShfByarvz3cvH?=
 =?us-ascii?Q?raZGJ6n5hlWKx/2jGLkFBtrv8m9dMIzbS5/XfHdmJQW1h7jyHDhJ02twhmRK?=
 =?us-ascii?Q?59NA5ZURcMLL6pWTHIYkGuJSQkG6W78S7gAQ0qw9J3tZ3N+sIUySJgOQa/0Y?=
 =?us-ascii?Q?4ODniGVq1RJyc5eMvfSMj2cl0TkygX/EnSHPXK/3/MrC+tfvSzu9vIKwGFsr?=
 =?us-ascii?Q?xC2Tfp+tP5vnty2zzAT4J291RZOW0kR2aSINxG/xmv1f8guIFA5iPzs4p8s3?=
 =?us-ascii?Q?rDa4jCMLFDOHn9IKy6Yl3NuP3EpNLA1NHhLxe1i3fSVy/cZByOTobBLS7xyB?=
 =?us-ascii?Q?hNeV448bnRBKvNm5jjdwlh0MU7HQI4d/c9JxP020WbWOW1rGqDuOJUAANnSS?=
 =?us-ascii?Q?ESDyn/fGq8qvWD8FiGK3fk+f9X/NpERD1znbBrc/+VyRynjQpb5MG0PLhWO4?=
 =?us-ascii?Q?k9UQf6dhwYKFHlTk2kLAhI71zGIJLeZ3+98dfdW1SAvoShzitkjgb6BkqbD5?=
 =?us-ascii?Q?NfJFJ3KmKGVYUPwvYRs7l4z5hHcazBCZ+XijRgTx2fp5FX4LTXeyFt5Szi5t?=
 =?us-ascii?Q?mdCIdviLkLwd59S4DySVZpF5KayPIPbRNB0pmYgkVSm9AUPPpxL0KUIYuA6e?=
 =?us-ascii?Q?XZs0KjtdR3pdrD6Eok0Rpqfaww8WqmYqqKawLaVtStXssWYJ681WjblYL7uJ?=
 =?us-ascii?Q?wznZejyRXJLfN8wRKeK2A09LXZYn3TCdXlou5Yzv1PEOrjBqhL6vFaz0yDy3?=
 =?us-ascii?Q?L0zXi/6FclZIrTZu+xQUxXkN8QFuzIx+VMn9r263wZyOqhdDAEXKQtdTkIhq?=
 =?us-ascii?Q?OVZpeUKQ4ABA9Xpm1C60zO4srCU6iCJdnrozps+/3sO7peqCNKMaF5HC2HDs?=
 =?us-ascii?Q?Qhp+VYdgTHhJWWs3y5jnVjWZyoX2m+Kax4l17xAiV80CHf/1EYF60Wh77bL2?=
 =?us-ascii?Q?0bn3/vevchMcVDSjJcqI+qBuA65EiBmfKE9OAWSyA7o+lNklA4MWxwhDsByS?=
 =?us-ascii?Q?7A=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ec6194-30f8-4949-4445-08da8ba4cf99
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 23:02:00.5340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+tlEvft18MbWZzxja9vBjmMtOZaEDDeqSPdTnjuXiHa97nD/cXZ85s+zTiYTg/n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3823
X-Proofpoint-GUID: y4rgRywWfgoeEFJKP8S6xOza7r1r4TMR
X-Proofpoint-ORIG-GUID: y4rgRywWfgoeEFJKP8S6xOza7r1r4TMR
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_14,2022-08-31_03,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 09:37:41AM -0700, Aditi Ghag wrote:
> - Use BPF (sockets) iterator to identify sockets connected to a
> deleted backend. The BPF (sockets) iterator is network namespace aware
> so we'll either need to enter every possible container network
> namespace to identify the affected connections, or adapt the iterator
> to be without netns checks [3]. This was discussed with my colleague
> Daniel Borkmann based on the feedback he shared from the LSFMMBPF
> conference discussions.
Being able to iterate all sockets across different netns will
be useful.

It should be doable to ignore the netns check.  For udp, a quick
thought is to have another iter target. eg. "udp_all_netns".
From the sk, the bpf prog should be able to learn the netns and
the bpf prog can filter the netns by itself.

The TCP side is going to have an 'optional' per netns ehash table [0] soon,
not lhash2 (listening hash) though.  Ideally, the same bpf
all-netns iter interface should work similarly for both udp and
tcp case.  Thus, both should be considered and work at the same time.

For udp, something more useful than plain udp_abort() could potentially
be done.  eg. directly connect to another backend (by bpf kfunc?).
There may be some details in socket locking...etc but should
be doable and the bpf-iter program could be sleepable also.
fwiw, we are iterating the tcp socket to retire some older
bpf-tcp-cc (congestion control) on the long-lived connections
by bpf_setsockopt(TCP_CONGESTION).

Also, potentially, instead of iterating all,
a more selective case can be done by
bpf_prog_test_run()+bpf_sk_lookup_*()+udp_abort().

[0]: https://lore.kernel.org/netdev/20220830191518.77083-1-kuniyu@amazon.com/

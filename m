Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AD9543B92
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbiFHSec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiFHSeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:34:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FF0A006E;
        Wed,  8 Jun 2022 11:34:28 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FPRoe014474;
        Wed, 8 Jun 2022 11:34:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=RCDII/xLmat5gK/OX9wjpRYZTmhUJ0vongr7nhftIcQ=;
 b=dQT67MELI4QR1HYOTlcJw/Ih4PIFQX4EjpRj6IJXhiFbyvXSX7YKBvynITEB5R7USRJv
 GK4j/Fwx30DjzoEdJM8crAIv21JRb2fygQcfRkEqxNu8Ujyid8rmE6r5vANAiTj8PM8I
 ER7yJozXWVMPZDXyioa33qb4kW7HTJEDXqo= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gj9djrrmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 11:34:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBtxK92AGA3hOjpnrJZOpD5eIBrMfL4vGepJ6GZAM9bhkqSUxBKA6hnUzt9wbwpW+xbC3TWalewF49+8FsTMVJdEA5OyQCIHAQFmqY/yJTh7Qdcdo+8g+kzBCL/9S/cqU/cjPoVFO786NiwGoZVYroKkTMz8IKljhnPjhsIWnMiUUpjvHIp8r3oTJf4pdfVK9M9P6V30i8dgpZ2nN3i3UXH59vIJLLpLJuRmhLOtfVgk4R8wgUbZ3rGEfdbMeF2CKf1A7EZOfpCbkyhAizZIY7efdrMRWE8kXyK8dJQk9bD8fAsnXzv5+c0GOXgT8kJ6/xUuJu2ib9buji6saRWP+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZR8HlN6Ym448S548tFHbpOYFriVaMf4usVKc2E4Moo=;
 b=nJzDpOZeAFE4yBnmJ8UNU6XdfZ60rERU3Z7eOdfNiH/nswYfLjOIzgqznhJByiqpzm126qKFHID735+hXy19QswYTNaWICGA3CuaHa/qEcrAt1FY0SbczO42v59JB2i8EtyWOeB9Hu9X1k7UqSY6lZyjyTlm+jFeGsDB3khsVoHw8DPC32eQuFPUepMYzssf2HMU2CdePaIvZXu4nY/TAN13zZZZ72ov8qzE7gHXjdR6mM35XEOYvW1vf/FDSox1dplsEMtzVvGMjIgna6uxndyjfQi3kRUsVY0tX6n9keiJXc9UfUMH6O/FJRsX67IbfbLWdMii2Y4HkpVy2N9HaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by DM6PR15MB2490.namprd15.prod.outlook.com (2603:10b6:5:8e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Wed, 8 Jun
 2022 18:33:59 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::a09e:da84:3316:6eb0%9]) with mapi id 15.20.5332.012; Wed, 8 Jun 2022
 18:33:59 +0000
Date:   Wed, 8 Jun 2022 11:33:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     =?utf-8?Q?J=C3=B6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] bpf: Require only one of cong_avoid() and
 cong_control() from a TCP CC
Message-ID: <20220608183356.6lzoxkrfskmvhod2@kafai-mbp>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
 <20220608174843.1936060-3-jthinz@mailbox.tu-berlin.de>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608174843.1936060-3-jthinz@mailbox.tu-berlin.de>
X-ClientProxiedBy: SJ0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:a03:333::22) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4830ccb-8d38-4bc7-2c28-08da497d7401
X-MS-TrafficTypeDiagnostic: DM6PR15MB2490:EE_
X-Microsoft-Antispam-PRVS: <DM6PR15MB24906E2706265D65ACF20247D5A49@DM6PR15MB2490.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGrUSmEzRy40sJwj9snpc9/BHvJ0xhloP2m+Y1hmncQgxn1fQUv/BbqP1bT5GgkBdX+DRR3zoI/cAABtqjqidNzLaTX2HbUdkqiA6SrJJn2oZ9vP0y8GSZxwwJlS51tu2/34PbfBgkvo9rEer3WPhBI7M1L+4SGjKG85jQomS/zPGiQqr9/O50lNvC2EAEeSCavRA1VX1nBk/qAQ21FpiJcKCoW68TYqkYdELRsvF0b+W8luxiutJK3LJ5ao+olaOXwbEJSZxFyDKgYb9H+Jm9hNldrgQDYqjAdzUYmEe0Jmy77oihy009LxZ9nXxdj8Q54ZCv200T3Pla/yQ5AieJq0rGKUdz4jgJtqgoLNWRRYq3T24P4h/79fBH9rTmI/TS39KWi/QQXTB6CeklIxj/KebfFcm/NgnG4DbWjjkD+5q6m96ax68ZQNHQ4XiORRoLzWCx/pgf5emaUhg5ESAQhdno64bQsu1T68FbkzQhD3wMbbiSHl7/SuRBPia6uqV/mv5gnXcl8juuE360dAHapPQjx8nThc18RJjL0gkVLofFJwofjCn+SWJRaE+IxyR49a8LMo+mZor7U8rZBpRlN0+cjYxPOF2t3K67DmLtaS5S72bspb8PbuxcHj4naR54AbIdcbkvRPOnwPfpODDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(8936002)(316002)(6486002)(6512007)(83380400001)(38100700002)(86362001)(1076003)(33716001)(186003)(2906002)(6506007)(66946007)(6666004)(66556008)(8676002)(5660300002)(6916009)(508600001)(54906003)(52116002)(66476007)(4326008)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?31EITchnxv0KCU0ERUUAGmjyEbN/45u01YKk81jdTeFq6/9ZKb/wPBH1HD?=
 =?iso-8859-1?Q?uQYwPh/coo3oGBRbDvq2RfU8v9fWzH+GNDC8jYa6jtbdOWC9IjfJlS+R1X?=
 =?iso-8859-1?Q?I3uDqUyFHWLhYz/7koRLUsnSBiaSrCrRAvLSDwLdUWk5wiPrexDUql1mf7?=
 =?iso-8859-1?Q?aHiFATmqyawAczJd4W4Zc+rqR0zRvT2MMdow8IeG/kVyNJNeVIcjwlbxmg?=
 =?iso-8859-1?Q?7nCcqYEuG5+4Ve1V1O35VxA3yd80DWymmELCxJ2jSVVdlO8OIHAbSgaZWh?=
 =?iso-8859-1?Q?mSjBUC+8NG5x+bRPHqZ3v0hVoRAQ9hv/GdThnjJZZNDPjEa4AvjjDh/MR3?=
 =?iso-8859-1?Q?5hdab9Mj4uDQEwJgcTwtl7XvWGde77id524YopJwL1o//Nnk9JKLee3+zS?=
 =?iso-8859-1?Q?RPjkqkZa9kDvPRibl4sUZSmjfL121YVqoybED4XkY1qPDK3W0kwjVHULny?=
 =?iso-8859-1?Q?/SHf7zk45Or4PK4DF8M5jMlNRMAWYEng6zdCKZ0lXfsjWOaOEPYhEemqYS?=
 =?iso-8859-1?Q?Kqu8acFqbXAp2K0/HhVmlar3Bfv0DvEJ5nS+BB5waB+C+X5sLeFluvdUUz?=
 =?iso-8859-1?Q?/wXVu00RG7k+0V6dVUzd4FKENRED7nuXao9kRGGpk+R2EFzO+QnKbypaL/?=
 =?iso-8859-1?Q?OYwBhfzurY/3/kHRNTpChRRRViXwxBE1QMIWq/46v07ookBSTF3DrHix9h?=
 =?iso-8859-1?Q?mw5GyLlfoVYF/hxQGX87i9MteTFh5Uwp6L5imtHla5iAz8q2OFz2lFjWi7?=
 =?iso-8859-1?Q?Z6c9VDtxACN6u9TZwc7XKV/gXLIgXqn7Ngf/q5q2wF90ZGbqU1a2IyYaGp?=
 =?iso-8859-1?Q?A0Ewd0sU48dQu9SM2faxB4y9vYAQagn1j8bnznL7Rx9qH82kSTAxxCWgRc?=
 =?iso-8859-1?Q?8s3GlPIyC/NyECyyLlO4jvKxlMPF8hDfCuyg3cT/9qqbRHpXprueV5oe1O?=
 =?iso-8859-1?Q?iy6seVC/c/A66Utj/1nSkNUvShdwNjLPLp7l7siCJfqNgfffM0pO837rvP?=
 =?iso-8859-1?Q?wtXFFVt3m4jwLRhfDbcAlD+GWP3RGKRAhUGEDLkv2FbbBxnXw3cvUJeTG2?=
 =?iso-8859-1?Q?UAmSmiQKqZHimpKnoZsy2gEanPMKw/p/rwc1HCIPMwpW41XK3cIlswwB0O?=
 =?iso-8859-1?Q?3ddMVaB7cLn3oR1E5pV9X4pYNx6QQhX6nM/F2RZjXvoL1vIDDokg4HEL9L?=
 =?iso-8859-1?Q?+rktGpdHuemAVMko5nZawGeOjh7mhgiEsfe9ePCU+qFP7oUyVJvTK5m4NA?=
 =?iso-8859-1?Q?wDUPoXsUZ3Xd/ahgP7Cff1jc9K0FPZmOumkmzMmrhGH94VJzDkZ4fciHh4?=
 =?iso-8859-1?Q?9C49RCAHELiLmchdD1cAxq2YBumB+WnpMDKkmsf05CKeSzedYMv4ulmEbb?=
 =?iso-8859-1?Q?DEnLcO6tpfsTpihLNyYkHpvqDe+/grwnUs6u2+inwKsxZ85Ztj7XmAJInS?=
 =?iso-8859-1?Q?Fxr0RqBLP+lbSp+32lvZaH6/iqobfXp3FoqV9yHR+ICOXsPGZ+Q7gFJ2d+?=
 =?iso-8859-1?Q?YIHHcZ00dwD4LwJ6YcpAspKxEQ7CFHtznSyKDbGyh2nBR2Zi5066awBvPT?=
 =?iso-8859-1?Q?HUGrd/PtkuzCsfF+bSF3cxXviogE4hXTPZ8r5R0ENQFNjD3l4Q6yI4byyE?=
 =?iso-8859-1?Q?YhT5KPiu5KiMtMWyLKhBb6chFGx+jbF66YspHPLrsn18l3SWYkRgwyPVPS?=
 =?iso-8859-1?Q?i71v2DDYvKcHqrejmrcJLQxuUVbOMiTgRVH5kcL1ys2m5mBoGvyj6dqUfa?=
 =?iso-8859-1?Q?dmv9tCuRVGLNKyCV3BAzLbex2q2LBAoBSG+bQtSLdTcjMrLiCk5ERfkfxY?=
 =?iso-8859-1?Q?G2G6vUX8uFKlFWx+r6rmvN6xkBM9/CA=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4830ccb-8d38-4bc7-2c28-08da497d7401
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 18:33:59.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhsdU/eHJD6+YABF2uyoIJgiij/0/CMDBpRgRFNVJZ5DGd+9aBcSw9yWRzX96l0R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2490
X-Proofpoint-GUID: p18FrwoFqEu0eK6BI2oPky0ZoTN3Go2D
X-Proofpoint-ORIG-GUID: p18FrwoFqEu0eK6BI2oPky0ZoTN3Go2D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 08, 2022 at 07:48:43PM +0200, Jörn-Thorben Hinz wrote:
> When a CC implements tcp_congestion_ops.cong_control(), the alternate
> cong_avoid() is not in use in the TCP stack. Do not force a BPF CC to
> implement cong_avoid() as a no-op by always requiring it.
> 
> An incomplete BPF CC implementing neither cong_avoid() nor
> cong_control() will still get rejected by
> tcp_register_congestion_control().
> 
> Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> ---
>  net/ipv4/bpf_tcp_ca.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
> index 1f5c53ede4e5..37290d0bf134 100644
> --- a/net/ipv4/bpf_tcp_ca.c
> +++ b/net/ipv4/bpf_tcp_ca.c
> @@ -17,6 +17,7 @@ extern struct bpf_struct_ops bpf_tcp_congestion_ops;
>  static u32 optional_ops[] = {
>  	offsetof(struct tcp_congestion_ops, init),
>  	offsetof(struct tcp_congestion_ops, release),
> +	offsetof(struct tcp_congestion_ops, cong_avoid),
At least one of the cong_avoid() or cong_control() is needed.
It is better to remove is_optional(moff) check and its optional_ops[]
here.  Only depends on the tcp_register_congestion_control() which
does a similar check at the beginning.

Patch 1 looks good.  tcp_bbr.c also needs the sk_pacing fields.

A selftest is needed.  Can you share your bpf tcp-cc and
use it as a selftest to exercise the change in this patch
set ?


>  	offsetof(struct tcp_congestion_ops, set_state),
>  	offsetof(struct tcp_congestion_ops, cwnd_event),
>  	offsetof(struct tcp_congestion_ops, in_ack_event),
> -- 
> 2.30.2
> 

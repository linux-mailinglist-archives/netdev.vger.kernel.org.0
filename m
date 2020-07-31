Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387EA234A95
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733153AbgGaR76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:59:58 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39946 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729657AbgGaR75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:59:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VHnKra018098;
        Fri, 31 Jul 2020 10:59:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=MWI4pCWWtW5HO1eHOOynMElniv4GXhHkHKwvJvdBeHM=;
 b=p/WzVvTu8rZzvSBO9d5Pe2wdS601rpFbz0YxjSSZgYLi55baFdWyLMeQbE9ZjmugICJQ
 l0uJcYRgpjqUEBrJ4+qVxh9X/Veeat4QIUDSqZT0TWYzMh0tbCQNzCl9Rh95fV+pbB4w
 nFkSKpYASDWsjuWrqzvLaDDfS1v7EKk6fD0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32k7hwcsct-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jul 2020 10:59:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 10:59:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFYUbG0Tf+/Bz4DxI+teCy9cZEELNw1U6sk+VJ2B0pCD4jAeSbPe4xf+aeNVjroRhw3R5pdavF5Xwpwk5aRLjIdYa1nUGfEHvRy3P/cFwSiaZ1c8yFvPsQD6SMFTeLGu/vLDXhegFEJ3WJfSAYKTY+TZOwchy9M9hkcrs/9Rkb6HGyTXzb9xXy8R63a7vQt+4s8E51kiPNZ8dcgSyNRcgTgL7rtDPZ/txs994a3M/cfEfBLTNNKwTNO3z8EMWY3gnH5YOCN96sl/Nn8BlSFcESML2xSJu+SV7ulCcJl00nvoOLpE+U27NE1K/tAhjZeyqtvwP/evSpn+2GY7CbXUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWI4pCWWtW5HO1eHOOynMElniv4GXhHkHKwvJvdBeHM=;
 b=EzOo+u2aKHHU0jjJec/3Kg4XQg2MXgG/e87kcfqjEwy3xZ4s+NIA0HcvGOMt3WFDDpWZsW28Laru7iQ0+T9pq5i1eKPTekuNXb3wXhT9GKPzonpZT/+aP8QkO3bQWF9PLlp3WiaMR4TbmZ7WHgQrHI5RLP2MESAxbMNGw2s117xcPZFI5+P2mYWX+GRYDPZ9VzG3e9Sw+B65puKYL7Wehs5t91LaBmG4BHnbBmNUPBLJCNIrqOFS9/4AmXKEZ63tuiGvWDtvQrynhDG8j1leZ1ovB0gObR1dT4F03nmTWMT+YEo1AQeVgfYrmxwFgAGVdvrOmSDAmx0jN6OBZ5SmYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MWI4pCWWtW5HO1eHOOynMElniv4GXhHkHKwvJvdBeHM=;
 b=lNVhDFZLSO6rwfx8kW6Tjm0DphmF7UrLdvsUgWGpO71YrizYeN3RBLhPvYkydQbuUnobNerO2YaVhdlf9bbIujPc9J3Pe9F0QzIGfd2oUcuIUFV0/KS3A2p1G/rJLh/KG75aVvmuqYdDTyYx9/SbzL/Sw/D5vJtrMssOXToEjsE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3094.namprd15.prod.outlook.com (2603:10b6:a03:ff::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Fri, 31 Jul
 2020 17:59:19 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d489:8f7f:614e:1b99%7]) with mapi id 15.20.3239.020; Fri, 31 Jul 2020
 17:59:19 +0000
Date:   Fri, 31 Jul 2020 10:59:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH v3 bpf-next 6/9] bpf: tcp: Allow bpf prog to write and
 parse TCP header option
Message-ID: <20200731175913.v4r2qjcvflehtyii@kafai-mbp.dhcp.thefacebook.com>
References: <20200730205657.3351905-1-kafai@fb.com>
 <20200730205736.3354304-1-kafai@fb.com>
 <CANn89i+5RKTcBFqueEs48HUadC+dO54eR7Yp5pBJ6zgbosTDCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+5RKTcBFqueEs48HUadC+dO54eR7Yp5pBJ6zgbosTDCQ@mail.gmail.com>
X-ClientProxiedBy: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5cdc) by BYAPR03CA0036.namprd03.prod.outlook.com (2603:10b6:a02:a8::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Fri, 31 Jul 2020 17:59:18 +0000
X-Originating-IP: [2620:10d:c090:400::5:5cdc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b815a2f-4848-497c-ca1e-08d8357b7285
X-MS-TrafficTypeDiagnostic: BYAPR15MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30942859E0643C7381EF68F1D54E0@BYAPR15MB3094.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afBDW5acaqVFz75VuN0K0+fnOj0pnT4E1Mc9S4/8phCiWSdnSNkKrGnzwZHVH7zVhzIoL14x2niqNuxSZC0rey0hZDfvNfcnc0MUJYowiyfcNDqrpHWr2P5wL2f7zBAnP2PAw5zU7jZ+ail/CJTuKuwEQ8VxoRqG2ooT4y5taLHe2uKoeLaxVNq+anhpd92r0rNXgYCzux8c1DwQ8/8t1JVeb5Ks58Hre37o8IFkfWSYL1NfdJAAkU+vhYvtKMmZYxocsCxhmXx8lwozFAbQU5+6jP+W7Z4wzIygo6rMT+HgM6jf8xj8uj6mj+qleOBHtvlZBULlCeUzSSLRlhK0QSU9ofDOD0TBWLUZGzPGfGqnv4RWHCpEE5r7zR6LYU+812TVj97kvn0L9ZegbqXEag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(136003)(346002)(376002)(366004)(39860400002)(966005)(66476007)(186003)(2906002)(7696005)(52116002)(8676002)(16526019)(6666004)(66946007)(66556008)(6506007)(86362001)(316002)(5660300002)(55016002)(9686003)(6916009)(478600001)(83380400001)(53546011)(4326008)(8936002)(1076003)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HJ/mf2oF/pVlA/C8wxaWQauAkPPuqa+88xGE9XlSVjP+qXOvyPYfdJ7MNM6JWD3LfLJ3C87g3ScwTzbjjKu/FXk4VknpIVv66S/CzXcY5Oejze/PW2PDA901FMuiaIg2tuF8cEQdUn6mp+iLSEyJdDIMCuRJzX/dWe61d4hN4brZ3fYFiHmPiKppQ9jWjNHGKhY8i/O9NWzu9KmiQmS8Y5fvvlpkhFiustFr+36Zn9c1sTlQ6yfdOz4+CwYrqwGCKlgaEdW4rGMZ3k/LRKRQ7wteTB8uL7QVRB8N8jDn+WFWItGrcDcy214Q0BhtZSGZVt+t9f1Q6C9WTOPgpxM74sCsaQeNlpPOCAgBvk1C/gLf5XpL+dW+aznukq+zUqhcJOB7ROOhJi5OoXX4W0uNlTyX1rtAv9z5Cip/jFynhDDPqR6Q37SxszapWtX+cBgf3d8IPByz0RjYWncdKEWUEIDw924wX9PB0xq5DCu6xrYHG/hG009Rzt8fWrXPvKOm0qn735dvwywpfK3cXz9Mt4yT/+zpOcuWk2XWNwDWKmHr0mnUAL6F2CqzA7zsJ/Y8pOcKvRxF+ZqTxGLV0hByfR1K8S21qsRM8rgsWNPTpaVqcGkDUYptIM7g015aw9tOuH01nNq/3obo9IOUrLITBSlnWugWuxKQq7WUo4tkAVGDtvBqlB7PdRdWiHK4vrKS
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b815a2f-4848-497c-ca1e-08d8357b7285
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 17:59:19.3584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v95tizW6FofTaQOQlyP+TKq5d9hhGottkaQZvsJOllB0qjjZl2VmWpZVO11ft4JZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3094
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 priorityscore=1501 mlxlogscore=964 spamscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 09:06:57AM -0700, Eric Dumazet wrote:
> On Thu, Jul 30, 2020 at 1:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The earlier effort in BPF-TCP-CC allows the TCP Congestion Control
> > algorithm to be written in BPF.  It opens up opportunities to allow
> > a faster turnaround time in testing/releasing new congestion control
> > ideas to production environment.
> >
> > The same flexibility can be extended to writing TCP header option.
> > It is not uncommon that people want to test new TCP header option
> > to improve the TCP performance.  Another use case is for data-center
> > that has a more controlled environment and has more flexibility in
> > putting header options for internal only use.
> >
> > For example, we want to test the idea in putting maximum delay
> > ACK in TCP header option which is similar to a draft RFC proposal [1].
> >
> > This patch introduces the necessary BPF API and use them in the
> > TCP stack to allow BPF_PROG_TYPE_SOCK_OPS program to parse
> > and write TCP header options.  It currently supports most of
> > the TCP packet except RST.
> >
> > Supported TCP header option:
> > ───────────────────────────
> > This patch allows the bpf-prog to write any option kind.
> > Different bpf-progs can write its own option by calling the new helper
> > bpf_store_hdr_opt().  The helper will ensure there is no duplicated
> > option in the header.
> >
> > By allowing bpf-prog to write any option kind, this gives a lot of
> > flexibility to the bpf-prog.  Different bpf-prog can write its
> > own option kind.  It could also allow the bpf-prog to support a
> > recently standardized option on an older kernel.
> >
> > Sockops Callback Flags:
> > ──────────────────────
> > The header parsing and writing callback can be turned on
> > by enabling a few newly added callback flags:
> >
> > BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG:
> >         Call bpf when kernel has received a header option that
> >         the kernel cannot handle.  It is useful when the peer doesn't
> >         send bpf-options very often.
> >
> >         The bpf-prog can inspect the received header by sock_ops->skb_data
> >         which covers the whole header (including the fixed fields like
> >         ports, flags...etc) or
> >         use the new bpf_load_hdr_opt() to search for a particular TCP
> >         header option.
> >
> >
> >
> >
> 
> > [1]: draft-wang-tcpm-low-latency-opt-00
> >      https://urldefense.proofpoint.com/v2/url?u=https-3A__tools.ietf.org_html_draft-2Dwang-2Dtcpm-2Dlow-2Dlatency-2Dopt-2D00&d=DwIFaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=Z-syoz304fodO8xPKCcJh0QYhXbb7_XVuRgTINFba2U&s=Ad66Zb5r0utWgnrB-QuDXBft6G1HXW2C_aBV9fTMxoo&e= 
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/bpf-cgroup.h     |  25 +++
> >  include/linux/filter.h         |   4 +
> >  include/net/tcp.h              |  53 ++++-
> >  include/uapi/linux/bpf.h       | 231 ++++++++++++++++++++-
> >  net/core/filter.c              | 365 +++++++++++++++++++++++++++++++++
> >  net/ipv4/tcp_fastopen.c        |   2 +-
> >  net/ipv4/tcp_input.c           |  86 +++++++-
> >  net/ipv4/tcp_ipv4.c            |   3 +-
> >  net/ipv4/tcp_minisocks.c       |   1 +
> >  net/ipv4/tcp_output.c          | 194 ++++++++++++++++--
> >  net/ipv6/tcp_ipv6.c            |   3 +-
> >  tools/include/uapi/linux/bpf.h | 231 ++++++++++++++++++++-
> >  12 files changed, 1171 insertions(+), 27 deletions(-)
> 
> This is a truly gigantic patch.
> 
> Could you split it in maybe two parts ?
Yes.

Most of the code changes in TCP are calling out the bpf prog to parse and
write header.  Thus, they are all in this one patch.

I will put those callout changes (and a few func arg changes) in TCP
to a separate patch but leave the bpf callout function empty.

Then the next bpf specific patch will fill out those empty bpf
callout functions.

> 
> This way I could focus on the TCP changes, and let eBPF experts focus
> on BPF changes.
Thanks for the review!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BBA2524A0
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHZAKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:10:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726483AbgHZAKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 20:10:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07Q08gE9010153;
        Tue, 25 Aug 2020 17:10:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CdxujxtlbX85+vBk5mkY/7J5WkVZQBfNekX2P6lEpnw=;
 b=rdAeezO70Pjveof462g4/1LssvaQo6/u03Dg6m2Ad40xyN8TUSXvSqExCpBnCFgIMAZ1
 eYrqQsC0Y5oj7wv3T/lKe1dlP0iTFPhdWbKhGmRz3YvSy9z7xgOMUFjQJ7IHCnaHRtKh
 RUP8hpzl7PQSUNsVMmy5D9GQ/1LzFKLm51w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 333k6k6a86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Aug 2020 17:10:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 17:10:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gM6jovQ7Ic+S6AiAaC4wQQc4+KkDLliYtwn1dD9w0rN0xnjDH5ROu0OdM7cIWQ/2CxnA4C/KSF2/lLHSSJgurM7iNaY+V3URzxuQyr78cb+DQJsICybEdIUxF08QLrh6xIeGCKaAjNE1hQrXulCNir/Owy6yumWu02lEzIUrBwaJUx8h0m4vbj1/jauQyIpYKu4ZaxdXln+uvcN8UsFeWIpOLgrTAysM0roU4R2EbhSmG2cuwe60cnb2FFBMwfTjSqpv5jsLNMWRgcAAeea0JfLOL8pHljXGucYPoP7LUYfQLz/4D3G1FkoEF4BjYg5RPyPx8GnPUEdSvW3GOtPm2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdxujxtlbX85+vBk5mkY/7J5WkVZQBfNekX2P6lEpnw=;
 b=ezJZyet27G5IcRB2rftT4EuhWKeg/aaJ1UuMaT5OZkPyrL3A5zITWEBIOBr+rF+6PuaMoHI6d8GDlng15IKGXLO7pm8Isfjw/92vlXds/9RCFSJRBtH3RRtJTWHmddwbdUlSqq1IBmb3CNnI0PZGHOj5aO5JExMT98rMiZoCSsxwk505kaC2Kyj9NzqiWQOHiY/SPCvgaAkKT4vrH4lO2X6EWzfIFgG9zTbFXiZZqFeXD4AcA/0Og/H3/yAaLgh8MlSDbwl45zMUjOVO1vzRH/eiGDz+9V0u57x4IiFZWrvBCDzPUaIg2P3OM5oEIoyw1tP4RuyfQiLYad10aWb31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CdxujxtlbX85+vBk5mkY/7J5WkVZQBfNekX2P6lEpnw=;
 b=AD87QI42F2GtGwD/q3pDxgXK15+G4xZMQUaqrOpJc//dW8NE+Yz2BtKHSJIDDT2MGMNRqpiPoOX4weXqgYq3E8vuPfKne87aK8NlYcceq+dCHb+hoEd1dsLMIXEqUDXtuGXv+EBBzb6QdQeE+ZeBvFqeLJqKm1hqfHYQ6Cz/8Fc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2566.namprd15.prod.outlook.com (2603:10b6:a03:150::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 26 Aug
 2020 00:10:28 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3326.019; Wed, 26 Aug 2020
 00:10:28 +0000
Subject: Re: [PATCH bpf-next v3 0/4] bpf: verifier: use target program's type
 for access verifications
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200825232003.2877030-1-udippant@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e88056b2-8c88-b4d3-7a23-3da4f0499ad4@fb.com>
Date:   Tue, 25 Aug 2020 17:10:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:208:238::22) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR22CA0017.namprd22.prod.outlook.com (2603:10b6:208:238::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 00:10:26 +0000
X-Originating-IP: [2620:10d:c091:480::1:319c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2e98aad-11dd-44f0-8ebc-08d849547008
X-MS-TrafficTypeDiagnostic: BYAPR15MB2566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2566FADA9B8E2EC5AEEC3AD5D3540@BYAPR15MB2566.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /CIbJm4cymxli7fwxNbZGNxmFbWPpxuJrs+2onRlCoxy4klhipk2DyBrnejeEd7HMTgIdlKl7wEd2iHIl4W1o4Ud/GHMAi3k9QPcvm6A4UrQ2hwJgc8SSnOHhktbUyMuwByOG+2QBdvnFN+U5k0BjqYI2LT/NiokHAgjM70lNdzS6fqq3rBqri4QWmXitWD+/OpLjUcGpV6Mzit4ulQh45GatFFkqQs0Q8sYLIDPt9mwqvTR+TEf3/Gb5sqQ7tfnRYxvadC+V9wElkAw1NsaJtB5oscjBPCjCLzj96verfss02ZFDXiItCM3sCZBDXqN91XixRMw9ZH3o+CNHbBydGOkRVAURdqnNHHj8AWa1l7h5lJyJnEgj2m8S5201K7t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(39860400002)(366004)(8936002)(5660300002)(31686004)(83380400001)(186003)(2906002)(36756003)(6666004)(6486002)(66556008)(110136005)(66946007)(66476007)(52116002)(4326008)(2616005)(16576012)(316002)(956004)(53546011)(478600001)(31696002)(8676002)(86362001)(15650500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZatrUYKK+CQd9486TXhJq37le3PF58/AQ6dv61juq6+i3Ri8SxCxkRUHefifGJhUH06TLd8RSp4fM/n0f/vtP8PD+N4jQUBGvU81RH4pbnAA9GgfhVRMlHmK3h47CbLWvQrelRykDdiRONNjUFb7loaK8fCYG6ff+fvdHj/r51l4IrHT3kAdTpK4sKV9ORYLb0DcF1/vjTZ4Q8QZLXJFweozTEO6sAG5k9Q7gUXllPzhzueoXzmr0xxbm0FK363uUtcsovFDWFC3pq6UjpoEyEnCkjdokvTIOo8YgfInkx0bVeJZpdP3n+F6UcvV0yLT9TOIOvNl+3nFzbWkNj/r0e2OmEqhsenGZ6ilcWBLYNsjTV1HnQ/OzjRhWxxctVtl15EWINbs6OuYwbtIau6CnJmGAJoNYz3SmG1Q7Qx89tMYmFjFCHBVdVYbpEYlqg1MR16CobckxTATIbAFQA+4JtLVDPJN/cUGhMWjIiE20EQcU9yiSBcWapBrjoYC+hSmV7Y6VsUwELZ39U91Dsr1W8Nk2waMmrqSlY5IuNEe8LPbS0X6dXkYngy0N9m3kN5SVPDjbua2UGDY896Dy1BVpRIOPZRiCmuwpbDq5VgjURk/o3UguoCUKAtjezCDLCNFYPJM5xHo/NegYL8lSNf4SdzUDgNapDhd99HnEQwX6RBpXpVMiimWYUDHTLn62EAW
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e98aad-11dd-44f0-8ebc-08d849547008
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 00:10:28.5770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9BLm6+2bzbgp88+UNQPNp2ZwUudn9OjM356dXZr4Kb+QjUZ1TMIzIKVUuTIp2nxn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2566
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 mlxscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/25/20 4:19 PM, Udip Pant wrote:
> This patch series adds changes in verifier to make decisions such as granting
> of read / write access or enforcement of return code status based on
> the program type of the target program while using dynamic program
> extension (of type BPF_PROG_TYPE_EXT).
> 
> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
> placeholder for those, we need this extended check for those extended
> programs to actually work with proper access, while using this option.
> 
> Patch #1 includes changes in the verifier.
> Patch #2 adds selftests to verify write access on a packet for a valid
> extension program type
> Patch #3 adds selftests to verify proper check for the return code
> Patch #4 adds selftests to ensure access permissions and restrictions
> for some map types such sockmap.
> 
> Changelogs:
>    v2 -> v3:
>      * more comprehensive resolution of the program type in the verifier
>        based on the target program (and not just for the packet access)
>      * selftests for checking return code and map access
>      * Also moved this patch to 'bpf-next' from 'bpf' tree
>    v1 -> v2:
>      * extraction of the logic to resolve prog type into a separate method
>      * selftests to check for packet access for a valid freplace prog
> 
> Udip Pant (4):
>    bpf: verifier: use target program's type for access verifications
>    selftests/bpf: add test for freplace program with write access
>    selftests/bpf: test for checking return code for the extended prog
>    selftests/bpf: test for map update access from within EXT programs
> 
>   kernel/bpf/verifier.c                         | 32 ++++++---
>   .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 68 +++++++++++++++++++
>   .../selftests/bpf/progs/fexit_bpf2bpf.c       | 27 ++++++++
>   .../bpf/progs/freplace_attach_probe.c         | 40 +++++++++++
>   .../bpf/progs/freplace_cls_redirect.c         | 34 ++++++++++
>   .../bpf/progs/freplace_connect_v4_prog.c      | 19 ++++++
>   .../selftests/bpf/progs/test_pkt_access.c     | 20 ++++++
>   7 files changed, 229 insertions(+), 11 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/freplace_attach_probe.c
>   create mode 100644 tools/testing/selftests/bpf/progs/freplace_cls_redirect.c
>   create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect_v4_prog.c

Thanks. LGTM. Ack for the whole series.
Acked-by: Yonghong Song <yhs@fb.com>

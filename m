Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955611CE4BB
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgEKTp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 15:45:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728283AbgEKTp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 15:45:56 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04BJcSn3019951;
        Mon, 11 May 2020 12:45:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=d86ck2Dw2MnJ7YIhYyYR16Egq86Qf5w+yMGpDew8mDk=;
 b=YssLM0VwxxJNYhK4L+PtP1ICzaJ3+S+JQa9FVvxWhQwZH2oihALaIlJrRNEY96AxV1/x
 Im7lIOzY+g0uJrbS6bu0hxDsnlof38arIOZGmiqYWzE2hL5MU3/m0Yzt6UZfBGm27XtY
 lgX4to2/P5Nboxy/XMdAos0Pb4XhcMfgeAU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgs8388-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 12:45:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 12:45:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsldXOuYnnHueu5r7GwAOFLTryGtMMXdk3x2KFBJyd6VKXkZ5BxDo6sgerjzDgGdjGFP25A7Y1jIsws3+HcDP4PBcM+j4rLHZ4gYA9u3o57+lGhGgS8uovq9B9lwDxQ03uZWgbyWUjCJDueyfXQDcW9qCTNJ+j5XMTGmDwqtcqtRAVheLMgiukkfJLCbDG3DyEt8lzze83NMF0Sls0LE/xWfg7gpodW8qu8S/fIHoMzQv4cYkr7a6BXs8e2maxvbALIPdXmk7c7DPWgM8RzycTPVwd06Hy7/zSPW+Bv+mdkwUyCYRJWWzKbLAK6rAP34l+PO4QOrWo7/ff4MeiF9Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d86ck2Dw2MnJ7YIhYyYR16Egq86Qf5w+yMGpDew8mDk=;
 b=E3L9FytvBfinwfiF3Qm5jOEQH+G0YwXrh9AuvVFTchGKEzytAhWIuwN5UKfLkYiKwVQY4zsI2SfackDMPJunyFfuIgj2JfRG0dGGa7PwuGpEalAdOgSwmDxD0aq8dC1zfFFXtNZcZn1seInsGhiluNFl8Kg3bPozwplsuhs0Ac1VQoMgSBMfM/Bbb3dFts1n0l+vABY0yF89CAB64XTfrNsVsxbXbcdfDICYPGCU3a3U33C0FQpoeVOd0mCPoo0oSCsw90r5uLSDHxxjxl45EF3TJtzJ2E9QyTkDM5dsBWQ0IGX9W4DW2zMsQkuw451yLr8gis6UcZKCL583FO5Oeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d86ck2Dw2MnJ7YIhYyYR16Egq86Qf5w+yMGpDew8mDk=;
 b=dTBI8WPYecHlTIwXIl4ZWwrBuEbStWZ5VQfhr1JIum6KyLL2PtK2kjw/se974+GAgtz+QM4R+eiu+mEIzKn/j/HcnR6pi+Lx0HbxM+5anDw6HucRhaNZBKz1sBWRBbBplcRGhWs2DFW3D04jtgESSFON9D0nU/ufFKHoIZQOzv4=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3996.namprd15.prod.outlook.com (2603:10b6:303:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 19:45:23 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 19:45:23 +0000
Date:   Mon, 11 May 2020 12:45:20 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/17] Run a BPF program on socket lookup
Message-ID: <20200511194520.pr5d74ao34jigvof@kafai-mbp.dhcp.thefacebook.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR05CA0084.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::25) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a5f3) by BYAPR05CA0084.namprd05.prod.outlook.com (2603:10b6:a03:e0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Mon, 11 May 2020 19:45:22 +0000
X-Originating-IP: [2620:10d:c090:400::5:a5f3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e94da8ea-b990-4211-4108-08d7f5e3d81a
X-MS-TrafficTypeDiagnostic: MW3PR15MB3996:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3996ED41CF3EA33F9276575DD5A10@MW3PR15MB3996.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZIYOO9ow108Pi1j2SGLndgvAB48K0qUODHv2L0RmXt1+wpjKMOdd4XaP9kDF1qbYZXAJCOciCuyMmrkPoMJOPvgn7AJxfAfOOf0fK1EoVgknMK11SKc9iywmY/d8uUEQZRDwx3u+oZT/RZTvZ1Yhgg4Mfev4Nidyw2VNl/F/msLa/xzry6z6rp5MzD732tpM/4ZtOX7PkkG/CPRr7fM0ib+1iOGtB96dAbfGhSyV7/nuyZ0U+1lC/k7yYOIUXlE+spF7lCV2C9lGrjFNS+BnEu3DzhaIB+dfDxWbJAd1StrxZqaxbVpUqxyzdrSL8ePRwjxZT3KYdEkbn9XTpOH9cMwrQtQOxZWIE1TBrInUQ2rX41zIDXxKsbep6L+bucEOy2Q62DTZY/ZJs23q6cTXVrkWVAhgA8n3ox76vBDnv+/y41xImE+oEQ+6MdzmiXy+m2edySQ6RMsNi6wC5PYjh+gBXsGR4kL27NhaZs2pJw5Louu5xBTN35HYiOgfI1yvoVrzbzXvDFnnsDoMUfSEN4T7m0HkU5LpZ/3OQ3w+NSNA669KB4TlohJ0oqlRhxYwWlWNpaPNQ4ZL+qLWeeRK30kJl5EC6d1X9TWIEydDkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(376002)(346002)(136003)(39860400002)(33430700001)(8936002)(9686003)(4326008)(55016002)(66946007)(86362001)(66556008)(66476007)(2906002)(8676002)(1076003)(966005)(6506007)(52116002)(7696005)(7416002)(5660300002)(478600001)(16526019)(33440700001)(316002)(186003)(6916009)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8uPqMm8WcEZ17JOGCOegWjo71cJHKNaOYXN2OtMGCuGdLZxBgyxZi/bFkwgva0xpPjFwDOgFJkgmk1/eEDfPwADHSLuUtquHRZu0tb0TwpVwnyKgSNbOOjfLuI6aIrQlHb5CXpX9SlOosAt932zwgpUHus8OWSEpYdKHusiLdAFc5XoEy4dNLgmxksQNV8GOjuUeg5mQ0plLpmeeghfYuePIKzYtz7EPGJ72GmeW1OzaF2kBK+LujhapQLqeOlNhfszsTDjbcPYYwPkdXiaMohzJldCpdOJ75cGBIAoAEndgSMWZQwIhNj8mtdIvKR9LqZeFJopTqyUSXkVw6HuWiM8htX1SXI3N2VWdsfK0ULrUt1kHTrL1osZnl+9msJKK+XXzy5m+W1/HMY8Vh+j8M6AslV6jnl96YTHF8ah76cJvmaWReHUqINwkYWA5FSsb+PuuNoawzuGXkWlisOPZoGygnkB3B4AfKfxeSyDtPInr6TxfipidaZbHxE6T2bIOR2FEcKA1iyuSeoAiX101Cg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e94da8ea-b990-4211-4108-08d7f5e3d81a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 19:45:23.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LBQjEw49ntSTRr3GmK8rfmqMoNIRI3PIPg4ndpZP4StIO9/SmV7cWzv6LAf/F0iF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3996
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_09:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005110150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 08:52:01PM +0200, Jakub Sitnicki wrote:

[ ... ]

> Performance considerations
> ==========================
> 
> Patch set adds new code on receive hot path. This comes with a cost,
> especially in a scenario of a SYN flood or small UDP packet flood.
> 
> Measuring the performance penalty turned out to be harder than expected
> because socket lookup is fast. For CPUs to spend >= 1% of time in socket
> lookup we had to modify our setup by unloading iptables and reducing the
> number of routes.
> 
> The receiver machine is a Cloudflare Gen 9 server covered in detail at [0].
> In short:
> 
>  - 24 core Intel custom off-roadmap 1.9Ghz 150W (Skylake) CPU
>  - dual-port 25G Mellanox ConnectX-4 NIC
>  - 256G DDR4 2666Mhz RAM
> 
> Flood traffic pattern:
> 
>  - source: 1 IP, 10k ports
>  - destination: 1 IP, 1 port
>  - TCP - SYN packet
>  - UDP - Len=0 packet
> 
> Receiver setup:
> 
>  - ingress traffic spread over 4 RX queues,
>  - RX/TX pause and autoneg disabled,
>  - Intel Turbo Boost disabled,
>  - TCP SYN cookies always on.
> 
> For TCP test there is a receiver process with single listening socket
> open. Receiver is not accept()'ing connections.
> 
> For UDP the receiver process has a single UDP socket with a filter
> installed, dropping the packets.
> 
> With such setup in place, we record RX pps and cpu-cycles events under
> flood for 60 seconds in 3 configurations:
> 
>  1. 5.6.3 kernel w/o this patch series (baseline),
>  2. 5.6.3 kernel with patches applied, but no SK_LOOKUP program attached,
>  3. 5.6.3 kernel with patches applied, and SK_LOOKUP program attached;
>     BPF program [1] is doing a lookup LPM_TRIE map with 200 entries.
Is the link in [1] up-to-date?  I don't see it calling bpf_sk_assign().

> 
> RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 seconds.
> 
> | tcp4 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     | 939,616 ± 0.5%         |        - |
> | no SK_LOOKUP prog attached   | 929,275 ± 1.2%         |    -1.1% |
> | with SK_LOOKUP prog attached | 918,582 ± 0.4%         |    -2.2% |
> 
> | tcp6 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     | 875,838 ± 0.5%         |        - |
> | no SK_LOOKUP prog attached   | 872,005 ± 0.3%         |    -0.4% |
> | with SK_LOOKUP prog attached | 856,250 ± 0.5%         |    -2.2% |
> 
> | udp4 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     | 2,738,662 ± 1.5%       |        - |
> | no SK_LOOKUP prog attached   | 2,576,893 ± 1.0%       |    -5.9% |
> | with SK_LOOKUP prog attached | 2,530,698 ± 1.0%       |    -7.6% |
> 
> | udp6 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     | 2,867,885 ± 1.4%       |        - |
> | no SK_LOOKUP prog attached   | 2,646,875 ± 1.0%       |    -7.7% |
What is causing this regression?

> | with SK_LOOKUP prog attached | 2,520,474 ± 0.7%       |   -12.1% |
This also looks very different from udp4.

> 
> Also visualized on bpf-sk-lookup-v1-rx-pps.png chart [2].
> 
> cpu-cycles measured with `perf record -F 999 --cpu 1-4 -g -- sleep 60`.
> 
> |                              |      cpu-cycles events |          |
> | tcp4 SYN flood               | __inet_lookup_listener | Δ events |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     |                  1.12% |        - |
> | no SK_LOOKUP prog attached   |                  1.31% |    0.19% |
> | with SK_LOOKUP prog attached |                  3.05% |    1.93% |
> 
> |                              |      cpu-cycles events |          |
> | tcp6 SYN flood               |  inet6_lookup_listener | Δ events |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     |                  1.05% |        - |
> | no SK_LOOKUP prog attached   |                  1.68% |    0.63% |
> | with SK_LOOKUP prog attached |                  3.15% |    2.10% |
> 
> |                              |      cpu-cycles events |          |
> | udp4 0-len flood             |      __udp4_lib_lookup | Δ events |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     |                  3.81% |        - |
> | no SK_LOOKUP prog attached   |                  5.22% |    1.41% |
> | with SK_LOOKUP prog attached |                  8.20% |    4.39% |
> 
> |                              |      cpu-cycles events |          |
> | udp6 0-len flood             |      __udp6_lib_lookup | Δ events |
> |------------------------------+------------------------+----------|
> | 5.6.3 vanilla (baseline)     |                  5.51% |        - |
> | no SK_LOOKUP prog attached   |                  6.51% |    1.00% |
> | with SK_LOOKUP prog attached |                 10.14% |    4.63% |
> 
> Also visualized on bpf-sk-lookup-v1-cpu-cycles.png chart [3].
> 

[ ... ]

> 
> [0] https://urldefense.proofpoint.com/v2/url?u=https-3A__blog.cloudflare.com_a-2Dtour-2Dinside-2Dcloudflares-2Dg9-2Dservers_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=v4r30a5NaPFxNXVRakV9SeJkshbI4G4c5D83yZtGm-g&s=PhkIqKdmL12ZMD_6jY_rALjmO2ahv_KNF3F7TikyfTo&e= 
> [1] https://github.com/majek/inet-tool/blob/master/ebpf/inet-kern.c
> [2] https://urldefense.proofpoint.com/v2/url?u=https-3A__drive.google.com_file_d_1HrrjWhQoVlqiqT73-5FeLtWMPhuGPKhGFX_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=v4r30a5NaPFxNXVRakV9SeJkshbI4G4c5D83yZtGm-g&s=9tums5TZ16ttY69vEHkzyiEkblxT3iwvm0mFjZySJXo&e= 
> [3] https://urldefense.proofpoint.com/v2/url?u=https-3A__drive.google.com_file_d_1cYPPOlGg7M-2DbkzI4RW1SOm49goI4LYbb_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=VQnoQ7LvghIj0gVEaiQSUw&m=v4r30a5NaPFxNXVRakV9SeJkshbI4G4c5D83yZtGm-g&s=VWolTQx3GVmSh2J7TQixTlGvRTb6S9qDNx4N8id5lf8&e= 
> [RFCv1] https://lore.kernel.org/bpf/20190618130050.8344-1-jakub@cloudflare.com/
> [RFCv2] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/

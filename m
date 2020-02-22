Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A85168BD3
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 02:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgBVBtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 20:49:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46792 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726842AbgBVBtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 20:49:35 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01M1hs4j003729;
        Fri, 21 Feb 2020 17:48:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qaCHoO3Hx8ii8y4696cDDAIrLmta3a/xTthGEakzKgU=;
 b=gLP3WY2v/mRB/odoRVOslO1LtjjjDpSUdkTXWn5r5JczTOpQo/sKZ9toYAZ/a1YJrg52
 J7mzsRcJnalaWqoGnK0jNC2m+SNdhNrKkHeyBi25QMoS055ns/S9mr7hyHOzbFh3T66d
 Lkbk5x4rW27PNTUJXj45KHjvzic+V4TWrHU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yaj9u2m2r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Feb 2020 17:48:58 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 21 Feb 2020 17:48:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV683sRa1IBpzwrHV1iFH2Q23rLbceKqef3G1fHYQXnFNuj+uT979xTbstsXTZJnqjqTZZgQ1MCvzscq5K86Muml/86IqnxZ+lgTgNk3fEo33f5e8LFKIa/ggotpbDPaHMgSfI9xl2KQnJ0fEjXYVrBY/1RQdMW0b1r8PU3PCXbOMfAypATJsr5votM8Co8OvcBMOulmW3pbViISkSP1GABQmcd2edYRTixqIZGrtVzhVp8j3ypygQOp9GbEKH4F/GJ1qSnDCS1u6e9WGgGa2Alnf6rNWfEHn5su5vjxQ69Bqn0wLYdzOMVcIJ1LnXUy3dJv7RZx9D3mGSc+AoUalA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaCHoO3Hx8ii8y4696cDDAIrLmta3a/xTthGEakzKgU=;
 b=N/ta35LfoRmu6HmauOhPsVEvtOTLfbPVawwmI2bGm+lsg14oSV0rGjU2xuYn6L1ZIdxvNeSD0pCpxBM76LkCQrzYvOn+Ceh+L3Q83tYlVdioc2/3ekMEYqtkjKyv0Ht2yB/6PFzF09TjV0JjVNcQ5KGFT3AEyNHk6CAX9Ti4wq82PpTmwFZ6m45t3+Dcl5KwK9jSq2ZFSQWbZvAdNAHx8kYmFfoaD7ZaJ4RWlLZSZrzNQdLktUUU5Dr893WpdtuwU/KrScXMPNTQ1nQe77OXD5jki5hNkA+AyMK/6pRSC8faCQCHoZ74p6DkrANr+PkwuvH1UskF98cwFhP8xi6cEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaCHoO3Hx8ii8y4696cDDAIrLmta3a/xTthGEakzKgU=;
 b=C6LdtplguHRegvR5PC9KeOW8c82X0uVsKxpKNx8BJcTBv9ZrdYygPC4zb8+9LBHIQCLk6IsOdUvuajMWo4Twms271Q+xKJCqcHCAN/921zthSx2MmSnwlhvoydaQoWo8Ax/IFC+IwQwxSGIeab5UVBTrXougKiDDQJfOONdXHt8=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2199.namprd15.prod.outlook.com (52.135.193.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Sat, 22 Feb 2020 01:48:55 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ccb6:a331:77d8:d308]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::ccb6:a331:77d8:d308%7]) with mapi id 15.20.2729.033; Sat, 22 Feb 2020
 01:48:55 +0000
Date:   Fri, 21 Feb 2020 17:48:50 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Eric Dumazet <edumazet@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
Message-ID: <20200222014850.GC459391@carbon.DHCP.thefacebook.com>
References: <20200222010456.40635-1-shakeelb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200222010456.40635-1-shakeelb@google.com>
X-ClientProxiedBy: CO1PR15CA0063.namprd15.prod.outlook.com
 (2603:10b6:101:1f::31) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
MIME-Version: 1.0
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:c751) by CO1PR15CA0063.namprd15.prod.outlook.com (2603:10b6:101:1f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Sat, 22 Feb 2020 01:48:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:c751]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60c548c2-145a-4437-f917-08d7b7395ffa
X-MS-TrafficTypeDiagnostic: BYAPR15MB2199:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2199C076FE25847558085EE7BEEE0@BYAPR15MB2199.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-Forefront-PRVS: 03218BFD9F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(136003)(396003)(366004)(199004)(189003)(6916009)(86362001)(7416002)(1076003)(2906002)(33656002)(4326008)(6506007)(9686003)(66556008)(66946007)(5660300002)(66476007)(55016002)(7696005)(8936002)(186003)(16526019)(8676002)(81156014)(81166006)(54906003)(316002)(478600001)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2199;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4lQ2RYDFsNoM3jcvjHJXaUpmJd2UH5vyMfnJXGj2PIsqggu6fmC/4Nif54BXhiDmOsnDA4OECg7bMgDtIDrMmWlxo2HC0LqsLoi1PNH4V8t3BJSyheYI+iGrYwKo7a60VYVC/XNgMKghz4mrkOgPgJTsV6yj1NI+cU47Pufhfnq0IzkDeQRivEIwCckU3xPkvFjoaLrMmKKNHS7JTQJies2tAYp4d+Dw1WRoKEiWRRgjjnaIo06YEeXF/Nl0qrZlg8/C8jqvky+i2UgKjpgDuJ6y9XE1neg6Gq5vWHRvwBsMe7BWd8tCAw/duCPAumMYdy4aqMV0mJJ9Z/lhrS3nG3w5jxr1F2KrQlSQapCDIJn0733znKYJXDvF9luwhW1LlnlJFj8BQVsrqaoe81wXozP6P47cfoAdfAJ8JZoC9C37hTpaeh49OpclfgWlKgqp
X-MS-Exchange-AntiSpam-MessageData: Y//ARKAQgofHYwFuiPsDLG5yFCx5KNu7yo2rLOAaA1bNskDDVynhr3X4NA0SMrXgb+azM0DqYavxzQTGlF7EhevKRKa1d2OCD5holSBPSCSKTBBp1OFBEbNB/USz2K7PIeGksA9c8xivVnTtiTIXOqj6e5hX5vWXCm0zI5aMH+eqL41rtSSgTM6XSegddS4z
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c548c2-145a-4437-f917-08d7b7395ffa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2020 01:48:54.9865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDtadEIMefPC0kxFBAslBUM9E/kVgT08PhRkq6/DhT9Fobk+kuS8iqX8e2lg5OsU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2199
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-21_09:2020-02-21,2020-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 suspectscore=1 clxscore=1011
 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002220011
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 21, 2020 at 05:04:56PM -0800, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by suck sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the late association of the unassociated
> sockets at accept() time in the process context and then force charge
> the memory buffer already reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Hello, Shakeel!

> ---
>  net/ipv4/inet_connection_sock.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..df9c8ef024a2 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  		}
>  		spin_unlock_bh(&queue->fastopenq.lock);
>  	}
> +
> +	if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +		mem_cgroup_sk_alloc(newsk);
> +		if (newsk->sk_memcg)
> +			mem_cgroup_charge_skmem(newsk->sk_memcg,
> +					sk_mem_pages(newsk->sk_forward_alloc));
> +	}

Looks good for me from the memcg side. Let's see what networking people will say...

Btw, do you plan to make a separate patch for associating the socket with the default
cgroup on the unified hierarchy? I mean cgroup_sk_alloc().

Thank you for working on it!

Roman

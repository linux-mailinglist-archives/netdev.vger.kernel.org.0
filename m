Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB351CE36C
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbgEKS7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:59:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731014AbgEKS7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:59:50 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04BIxR2v014891;
        Mon, 11 May 2020 11:59:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=RnuESM1G4CGGmkCAVR4iRIQG22P+AbMTdnRC+f1WYeY=;
 b=ftlMPxPOcLMeD2RIINGuVjyUDPk3ssBdZ6IuVf34fpLUXQ3aOo/L+fRm4hx76QFtMmf1
 ln7EnNej611MrBLwMkhq/SMsyQKkbaNfeCiahqjSTaRjv5FBc+Yiy834dWKryy3g0v/Z
 3APJJVT4r30BJ11IpmFgcCKvx7Ew1Zfygq4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgbftqu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 11:59:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 11:59:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8Y2uWki2uU5Odw/HTXUTJtyZ4vbuXD4w6fWRw5C2mUybhwtwsWw0EwuITrkeqKt5860CMRB/Oh606YpVrL3sAeDqr2RL0Z+pTrgIoD7JeI09rqGL/9TH6KEqxsONBceYR1hUfLZtxUw3Wj49//gcGjj7NjAEruPFA1zTE+DC0b+lruwbCl0O3QRIUPtCaw/Nz2KCLfuF8uzjZuGr6du9/qETANwI6C9ndAmCitOc9TRdlY/I08RBphMbqYIw0d7oHeqXSNUtfn+JH1MIIZjUblmLLnEyP3Fuv/o2UBT6Szr49iFb1fKAq6HspWYq3CrPgDFMSMsJUN7YbIGtb3Lvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnuESM1G4CGGmkCAVR4iRIQG22P+AbMTdnRC+f1WYeY=;
 b=Vv3ROeZXSn0IIWrW6YHt4LC2ksoyh+Eqp7vee9pqr0VzfYz1sQqTZO7s2pr6cLXY3ckbtj31zYlloG1f3RceVnQtKp2aHSSCioE6gF5Dpjdb5ynY18y+yqB2bf0DXfp+CgOyhND1uAIarKS2kQpAB35wdzi6WbL8cOT8ff0Mz36yQqQe5JAQvraiVxJD1KK9+6IGMTJ9hKUPFxcGFO+TsVC/TuYaK7fgegPHDPnLtuEKAYpuYbgQN+AissiTh63r2VSzIMAJOYQy9B+RTz4WJp9bb0otpLRrmspISaQplqs9lkeA+m8Vpcb+dMZE14SDbPhKqASkcUjSzOpq/xhORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RnuESM1G4CGGmkCAVR4iRIQG22P+AbMTdnRC+f1WYeY=;
 b=PbJ3JLtWfyAixDdqljLg4639GOB81wwjUPJ2BD6fIA7Rm/XZgPs4QE+mUlTNfMeGGk5WV21SVFvOBwK/WFaeb2WURs2JOnuF4qNVEknZXtLlqtUKsBmcUG8yiZn8S03p0UYZgxfm45dnK/4aIVqiyYxQH96FOnuWuHMnUPQ6ypI=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3995.namprd15.prod.outlook.com (2603:10b6:303:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 18:59:18 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 18:59:18 +0000
Date:   Mon, 11 May 2020 11:59:14 -0700
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
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type
 with a dedicated attach point
Message-ID: <20200511185914.4oma2wbia4ukpfdr@kafai-mbp.dhcp.thefacebook.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-3-jakub@cloudflare.com>
 <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
 <87a72ivh6t.fsf@cloudflare.com>
 <20200508183928.ofudkphlb3vgpute@kafai-mbp.dhcp.thefacebook.com>
 <877dxivny8.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dxivny8.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a5f3) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 18:59:17 +0000
X-Originating-IP: [2620:10d:c090:400::5:a5f3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e7692de-f8ef-49a1-bd4e-08d7f5dd681e
X-MS-TrafficTypeDiagnostic: MW3PR15MB3995:
X-Microsoft-Antispam-PRVS: <MW3PR15MB39958881BF550A7B946CD8B7D5A10@MW3PR15MB3995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6BWchxgrMGNi18CmIsifSbSsA9cEpUMZDFDacj3bwasZ9iJIJJeI60Rd2p48S25SWVLBAiv7dVfXV9a0rnZGMgzUNuBpSJV2x4sUTHK3Rh/7ltoFZLGO833UTFj0j6EmVx1NiYwC/tp6PpiFnOoqk8TzzABOv69X4liZau1ubXu3PqkvCCp/s7rVtS++8qz+zhjrJPTCvq/8EORTI7IptQNwLTQzuc9y0hlqwChjzu0paENTlf5okn5QDOqdyN/XheJ+6rIwSxmu5raVBn2swS7OQU04AkhhOlgsZoETvJxeUBdTA9v2xyRYRKTGuMnMpqzQrqcM0cpUbUlptrYSvZNZSrdc4a0qA6D9q/ZcSapv0Llfyfk0Bi1JNh+SLKYl+kwgKlu/FetBXQavjexy8bsVAHzj+K/s+P15vQ0D7dLWCAPffVesq5svijZ9lvYp6pcKQrTNey6MEanXwYgnD+qbghC+ON55MtkQRx6Syd6siMj5YCyvVL72fZv+jyur3pfk7kfLcAzY8hbls+mSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(376002)(366004)(136003)(396003)(33430700001)(33440700001)(8936002)(7416002)(86362001)(55016002)(316002)(9686003)(66946007)(66476007)(66556008)(4326008)(5660300002)(52116002)(6506007)(53546011)(186003)(54906003)(16526019)(7696005)(2906002)(6666004)(6916009)(8676002)(478600001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: OvX+eiwD2Nd0Z3v1F2bXeyBuDmfAaQXPOj6ZS7fuChvI1naEaukNJRN6+u1l95+8lrwHsST1Yok+On7HieXIKMeKV7mXN3CWwiJs+AYdNMLes6IWj4c0wa05K3ZSdSQuKSDSjpJzlJmPrImuEqmJKM0d/NZ6EJrqKEcIIhZENEI8MTJQ/5+rsbZ2qeUmIKFf4w1Y1J9V+4DnmbCbtJFRjhVhHIClfVG6584Zd5lnK7Wy4kq/2RkBzt6mqdY2Kt7D+nH+4+ZKXO3qMSBsqj0nwVMyGqs9wgMSXK8OG4Nrv91KxM+qP4slCp5IjfemGfH/pCYRhelNpuOTO4bj8VJb41d+jsO49jfz6yJFPa6QsuZWq912vKs0IXHk+jZGuRBvqUxSLI10yLULcThFBgM1zNLNf72H5DDIlcjbNhorDz3VrQBCFB9hivtUOzwOX358gQn79zP+Tpy4v8iycpfKH5xJR39oTg014fTFzr/WXarWgY0hOs1bcHAZNVyQKJcYDTq6nACCc2hT8B8Y8j58Qw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e7692de-f8ef-49a1-bd4e-08d7f5dd681e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 18:59:18.2116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWyEsDA/MQOKnoltxuempHwpAhr4mG+mY41FPhpAWjDwybLpJG6H1CTPXOLcjEBC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3995
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_09:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxlogscore=664 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 11:08:15AM +0200, Jakub Sitnicki wrote:
> On Fri, May 08, 2020 at 08:39 PM CEST, Martin KaFai Lau wrote:
> > On Fri, May 08, 2020 at 12:45:14PM +0200, Jakub Sitnicki wrote:
> >> On Fri, May 08, 2020 at 09:06 AM CEST, Martin KaFai Lau wrote:
> >> > On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
> 
> [...]
> 
> >> >> +		return -ESOCKTNOSUPPORT;
> >> >> +
> >> >> +	/* Check if socket is suitable for packet L3/L4 protocol */
> >> >> +	if (sk->sk_protocol != ctx->protocol)
> >> >> +		return -EPROTOTYPE;
> >> >> +	if (sk->sk_family != ctx->family &&
> >> >> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> >> >> +		return -EAFNOSUPPORT;
> >> >> +
> >> >> +	/* Select socket as lookup result */
> >> >> +	ctx->selected_sk = sk;
> >> > Could sk be a TCP_ESTABLISHED sk?
> >>
> >> Yes, and what's worse, it could be ref-counted. This is a bug. I should
> >> be rejecting ref counted sockets here.
> > Agree. ref-counted (i.e. checking rcu protected or not) is the right check
> > here.
> >
> > An unrelated quick thought, it may still be fine for the
> > TCP_ESTABLISHED tcp_sk returned from sock_map because of the
> > "call_rcu(&psock->rcu, sk_psock_destroy);" in sk_psock_drop().
> > I was more thinking about in the future, what if this helper can take
> > other sk not coming from sock_map.
> 
> I see, psock holds a sock reference and will not release it until a full
> grace period has elapsed.
> 
> Even if holding a ref wasn't a problem, I'm not sure if returning a
> TCP_ESTABLISHED socket wouldn't trip up callers of inet_lookup_listener
> (tcp_v4_rcv and nf_tproxy_handle_time_wait4), that look for a listener
> when processing a SYN to TIME_WAIT socket.
Not suggesting the sk_assign helper has to support TCP_ESTABLISHED in TCP
if there is no use case for it.

Do you have a use case on supporting TCP_ESTABLISHED sk in UDP?
From the cover letter use cases, it is not clear to me it is
required.

or both should only support unconnected sk?

Regardless, this details will be useful in the helper's doc.

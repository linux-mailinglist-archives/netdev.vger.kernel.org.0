Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05DC1CE60B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731834AbgEKUzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:55:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731579AbgEKUzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:55:25 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04BKacPx002934;
        Mon, 11 May 2020 13:55:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=t6pqk2nM1C5wgqeqkLzfN/C3G5h8yW9mVMzEfE0o7DM=;
 b=h9Y3FvndDGirlG5orMgMJLGWHKqzK8HZ11LYRnJixqgIlPlCktwNZS2DXj7HIdikaPvq
 /figl3ZAEFfEOImy98OTkgi5HUZ5GlPOVm+rVWdprupXrV4T0KXtD6igtDxFCeLcI7AG
 bIJFG/rXNCYhemOOl9FeWN0msPRk56IN+c4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcsprb91-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 May 2020 13:55:03 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 11 May 2020 13:54:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+BD/5O7J3baNQfsHZC5vJWeiY4r/JLI2ya5Kufd68QxpcBgz7UvONVZ7jRDSVA3dUcvC77sRQFvrrGhVat3MDnvQI6tEn3fDBsu0BG5qsj8+UeeiZ8vu8dyf2gr0/T3eSYVITQkvWOBKfwANkZABDjFvx4kNXVua6ZgOLZ68aKNa2I6Mq458R31NY5M5otm1KQTXfGuSfq+hqwXOCx2p7YzUfl6McWzgUFFOlQ74i6gZi7wkVcTURv2DxaBLvDDpFuUxZLfG8wwJ48WmEVcuWiv/wCa5waI5Cjb6uOFLgA0DvhnuHRbOBugrKoIgULYpNvmKbhuXhhJqZcMZwZ7fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6pqk2nM1C5wgqeqkLzfN/C3G5h8yW9mVMzEfE0o7DM=;
 b=kQinkgfjAC7Ynk1aDw6JnbmIz22eGb9CMx+Kzp42YiHZronCeR+iXSqKFKLddZoT0UWLpRijjOYkoc19xE5my9c20PU2YZgiGM2AvmVta7iVRUDgGjjiwdFh81dqMehbEmy5MZ69MbfJkrUp2LhG1O0c1q0+lnOTGj5KL5E/GOM+OxmhjTvGQt0igT/vmdVKogkaT2xgdxRxJhKJNJneIwIiZuwwM806lv0qQMZVjBaOjC9Z+eHEZRBSynU04pb/ryS5KJ31ax6cgDFKN8lwAua7QKUnqIbyOi/SHbToDqY0AimnMlGNCSKvfEDcV21XMWL7yZ1Noah1bCcs3RGYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6pqk2nM1C5wgqeqkLzfN/C3G5h8yW9mVMzEfE0o7DM=;
 b=EDB8oIqYX2kPFIuxca7q/Q4jm1RQFkWIC2Cza2azp0Ew3w4s2MT56ZBMg3PJH+ZqK0Raudfd7yhpYSt6iFzOaVEGKpNuqFXUlFFBkXduhpQjr4W/hy+IrIqi8mxLQrcxzkQS1oW4nX2YLDnBrnaecC0WcLzpzM5VnOlRuQMdP3g=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Mon, 11 May
 2020 20:54:38 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 20:54:38 +0000
Date:   Mon, 11 May 2020 13:54:35 -0700
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
Message-ID: <20200511205435.mgjbkfndpi2sds6z@kafai-mbp.dhcp.thefacebook.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
 <20200506125514.1020829-3-jakub@cloudflare.com>
 <20200508070638.pqe73q4v3paxpkq5@kafai-mbp.dhcp.thefacebook.com>
 <87a72ivh6t.fsf@cloudflare.com>
 <20200508183928.ofudkphlb3vgpute@kafai-mbp.dhcp.thefacebook.com>
 <877dxivny8.fsf@cloudflare.com>
 <20200511185914.4oma2wbia4ukpfdr@kafai-mbp.dhcp.thefacebook.com>
 <874ksmuvcl.fsf@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ksmuvcl.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a5f3) by BY3PR10CA0023.namprd10.prod.outlook.com (2603:10b6:a03:255::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28 via Frontend Transport; Mon, 11 May 2020 20:54:36 +0000
X-Originating-IP: [2620:10d:c090:400::5:a5f3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06728853-7667-493d-ecca-08d7f5ed8497
X-MS-TrafficTypeDiagnostic: MW3PR15MB3980:
X-Microsoft-Antispam-PRVS: <MW3PR15MB39804CA924BCF3B97D252F21D5A10@MW3PR15MB3980.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uL1kHeIbvh7EygJ+dvlBx4WXW96z1T3+uNI4ktyHf4ZPdngM2l7zwJ2CG4iJ5gx2FlSXPJ7Zc5H7aI3tBIIDbNEKbVVeaCZOvrjxfNNm1Ydd16LccovRnw1RFiNst6u5SPmf8Flt/hJ1i4JvHSgG/8lFk8LMeM9SUThwYqnGYNUsVOhvpj0x65w+fPwseBOXx4dACUn/wpw6M3y+LMhNN46k8cCdOZt36wRPtRM4xevnI6cAiDVuj7CQ4upuAX7A05qEkc0CZUYmwMsWN+u9r49tayX5Pd6Mq4JDKK9j7QfFywDkeC75u3IPztvybBzZB4jQb0UZjfqpHtl1XFPqDYlJtCAMqEC9stcF33AwBEt9tODzAuH69/1KC6dj+g81+3hO6ZNpbnzu3vNjfE5E5JJAzxuu+983ZUprXPEyyXNBjGCwYp/gbkIsCCA5euDedz1khyBIN1JV5KHustfHkiuY9y5SXSAVgqrAo8vylJPsTqZZVbNEmHZcS19xguEbuVKX6n6U8TV75GqSegiIv9yZ3w36E5FXTF7Qmq+nPlAaCIqE8kaeM1fAnYhWPkM1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(33430700001)(8936002)(33440700001)(54906003)(2906002)(16526019)(53546011)(6506007)(7696005)(52116002)(186003)(6916009)(478600001)(8676002)(1076003)(86362001)(4326008)(7416002)(55016002)(66946007)(66476007)(316002)(66556008)(5660300002)(9686003)(134034003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6Hs7Bp6vq8psgDcs42ayRlVtVM2KcJOpJL6bExCHz/7G8Jx5MIhSLikFsYtG4+xMqET5/MI4WKS48Mzmy/LskAaZAlYAeLiWfIGluOlDiTJGKR4eugYjZI/AlFewmzOQ4FhYSkwy0SZLnHYyufSBqJJoL5bSKpqfJrihjEVIDjHuGkaZIkqpbm2yQmAmWNMaHEhtRopoyxpeNb3nkQv1MYClREEdnusgnJRy4i7eaoDh2ZQJAN4+TypF7FAMCCRSVq1KgZnmFudjYjT+3ufnPnj8SRK0JW2dWjIToOMc11snafVM3QW7pPH0tftIu1oa3yzMVEjhioLddJ03n7qCvEZn7rzYEEf8Bfy0Xc3mmMleHKmEdGKLHCfxZu28xSofbV5HQDNeMp9INirBIUWNf0IF4rWVwfv3d8AvGEDdeYbRWfgqDK64c5GvNC3NKFx03BNpXlaL2UzuNa3MUOHLhsvXTd8hWC3s267Ekbj1YaL9mxEpdGf+TBtDJoELtKAKf0F2mtKMGr2Sf6KW8ixxPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 06728853-7667-493d-ecca-08d7f5ed8497
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 20:54:37.9167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fj5BT2SujCd3hYBrFTAvq/JtEyCO+JD4jDxkWl0nCQ6ohFeCdf3tmlXyxxaIxGoc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3980
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_10:2020-05-11,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0 impostorscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110157
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 09:26:02PM +0200, Jakub Sitnicki wrote:
> On Mon, May 11, 2020 at 08:59 PM CEST, Martin KaFai Lau wrote:
> > On Mon, May 11, 2020 at 11:08:15AM +0200, Jakub Sitnicki wrote:
> >> On Fri, May 08, 2020 at 08:39 PM CEST, Martin KaFai Lau wrote:
> >> > On Fri, May 08, 2020 at 12:45:14PM +0200, Jakub Sitnicki wrote:
> >> >> On Fri, May 08, 2020 at 09:06 AM CEST, Martin KaFai Lau wrote:
> >> >> > On Wed, May 06, 2020 at 02:54:58PM +0200, Jakub Sitnicki wrote:
> >>
> >> [...]
> >>
> >> >> >> +		return -ESOCKTNOSUPPORT;
> >> >> >> +
> >> >> >> +	/* Check if socket is suitable for packet L3/L4 protocol */
> >> >> >> +	if (sk->sk_protocol != ctx->protocol)
> >> >> >> +		return -EPROTOTYPE;
> >> >> >> +	if (sk->sk_family != ctx->family &&
> >> >> >> +	    (sk->sk_family == AF_INET || ipv6_only_sock(sk)))
> >> >> >> +		return -EAFNOSUPPORT;
> >> >> >> +
> >> >> >> +	/* Select socket as lookup result */
> >> >> >> +	ctx->selected_sk = sk;
> >> >> > Could sk be a TCP_ESTABLISHED sk?
> >> >>
> >> >> Yes, and what's worse, it could be ref-counted. This is a bug. I should
> >> >> be rejecting ref counted sockets here.
> >> > Agree. ref-counted (i.e. checking rcu protected or not) is the right check
> >> > here.
> >> >
> >> > An unrelated quick thought, it may still be fine for the
> >> > TCP_ESTABLISHED tcp_sk returned from sock_map because of the
> >> > "call_rcu(&psock->rcu, sk_psock_destroy);" in sk_psock_drop().
> >> > I was more thinking about in the future, what if this helper can take
> >> > other sk not coming from sock_map.
> >>
> >> I see, psock holds a sock reference and will not release it until a full
> >> grace period has elapsed.
> >>
> >> Even if holding a ref wasn't a problem, I'm not sure if returning a
> >> TCP_ESTABLISHED socket wouldn't trip up callers of inet_lookup_listener
> >> (tcp_v4_rcv and nf_tproxy_handle_time_wait4), that look for a listener
> >> when processing a SYN to TIME_WAIT socket.
> > Not suggesting the sk_assign helper has to support TCP_ESTABLISHED in TCP
> > if there is no use case for it.
> 
> Ack, I didn't think you were. Just explored the consequences.
> 
> > Do you have a use case on supporting TCP_ESTABLISHED sk in UDP?
> > From the cover letter use cases, it is not clear to me it is
> > required.
> >
> > or both should only support unconnected sk?
> 
> No, we don't have a use case for selecting a connected UDP socket.
> 
> I left it as a possiblity because __udp[46]_lib_lookup, where BPF
> sk_lookup is invoked from, can return one.
> 
> Perhaps the user would like to connect the selected receiving socket
> (for instance to itself) to ensure its not used for TX?
> 
> I've pulled this scenario out of the hat. Happy to limit bpf_sk_assign
> to select only unconnected UDP sockets, if returning a connected one
> doesn't make sense.
OTOH, my concern is:
TCP's SK_LOOKUP can override the kernel choice on TCP_LISTEN sk.
UDP's SK_LOOKUP can override the kernel choice on unconnected sk but
not the connected sk.

It could be quite confusing to bpf user if a bpf_prog was written to return
both connected and unconnected UDP sk and logically expect both
will be done before the kernel's choice.

> 
> > Regardless, this details will be useful in the helper's doc.
> 
> I've reworded the helper doc in v2 to say:
> 
>         Description
>                 ...
> 
>                 Only TCP listeners and UDP sockets, that is sockets
>                 which have *SOCK_RCU_FREE* flag set, can be selected.
> 
>                 ...
>         Return
>                 ...
> 
>                 **-ESOCKTNOSUPPORT** if socket does not use RCU freeing.

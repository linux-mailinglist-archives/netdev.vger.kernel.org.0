Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740C12A905B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgKFHbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:31:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726415AbgKFHbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:31:14 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A67QOO7007363;
        Thu, 5 Nov 2020 23:30:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=3o7cxa8APvyfqe7xuWYph64k4bwZTiok17gprQSd4Ug=;
 b=RuO4qdS7R+kuHvbjup8ZygqJeR5fgQU0uNbFiDyKs7VHkIJ7JJ1EUo3W9p8vZU4WFfj4
 aeBIO0lxN9LLB8OQEK37gqQ1DNuQKmFd0SPRORWuFbqhMWJYiYk9D1FcE2a+N6kXsSkz
 up/DNrWMlD4k/7X+Rh3xeVXFkuOBAE89gcg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34m81m7ham-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Nov 2020 23:30:58 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 5 Nov 2020 23:30:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nby9taF13mWqAZVl3rc/3y1ViYWDcgYM2ggo358vABqNj9M10nh8Zvl8MZbNWEmxxNVMVTI46MyLjp6PR5tT8tIdAq042B6vDZwGHphPGg/uldxFSYgSbdELOH6DM1+x6iBTA8pHayvOxkQLmta//C3HWSoTruoYHz0M5VMHTIKEfVLyVcFRLK+ZNcOtQilW4H+Z5fuYZ7SQWRE27KXcZNOq9i+FL/xdaKe06QwaXlfNxBf8wk0InMAmZqvkxybSEYTyfKGtUendyTEZsNeROURv6Vvo3hMeMNXRfNC3UPci6I3daRLX24WWcZycYyMGvBTQg2OkXysuheNJbMW7KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o7cxa8APvyfqe7xuWYph64k4bwZTiok17gprQSd4Ug=;
 b=YpJYV+m5tRdSVN6euK4m/HnRUQNQDaUrcvbkqdXmF+z4euDCwO3zsm8YGBXRo+skLrHcR2/MFoZB7QmGGPRpiADmdiDG1gqqmCEYu+KI8kQUsuW/TZwgPBbYp2nHyN6TLnNNO2QsGi3DDkaE2iEXHjcSe8sKUjrPNQjhVpUkz6US3UA3FVNeg/uhHqeC+0zdeEz0b0JRykQd+OJ5zvVwTzVMf3976NFTM+mw6yuWoK8y03l7p+0j3Gn+39CjTwZqHP+yAy9K7gs5hak1llpLeufeOBIlG3YJueJiDD5wjQT7IfcZSU6YIjVEoLmf7NhNbQTC2yIY7Avatsd5H0toCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3o7cxa8APvyfqe7xuWYph64k4bwZTiok17gprQSd4Ug=;
 b=GlW9j8cGH7d2FTqVswTjPlPyNycLLAPCYnliEE1qTVOO0EYjQt3q5asNI3Snl5oS5lREVNVrbzyqwM5Af6nn7++2XaXhfz0TkTqQHkTcc5YQIJWckgrlXjvPqYWl/yF9NO5sQhq/7Nj6r05nxMnqNmM4r97Ja28IB5AYK99RVq8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3413.namprd15.prod.outlook.com (2603:10b6:a03:10b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Fri, 6 Nov
 2020 07:30:41 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 07:30:41 +0000
Date:   Thu, 5 Nov 2020 23:30:35 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftest/bpf: remove unused bpf tunnel
 testing code
Message-ID: <20201106073035.w2x4szk7m6nkx5yj@kafai-mbp.dhcp.thefacebook.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201103042908.2825734-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103042908.2825734-3-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: MWHPR22CA0054.namprd22.prod.outlook.com
 (2603:10b6:300:12a::16) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by MWHPR22CA0054.namprd22.prod.outlook.com (2603:10b6:300:12a::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 6 Nov 2020 07:30:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0f5acca-1af3-4588-52d4-08d88225dd76
X-MS-TrafficTypeDiagnostic: BYAPR15MB3413:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3413D4EF8020540C7AEBD308D5ED0@BYAPR15MB3413.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0hWJoLJJQ2IbrTHHsTQfdk62o4e7/1IXy2HWP33P+K6blAnh9zl4kCLiJSR33M+p0rNJPfM/ZpT5TaPAcCcxM++eHZ2RQxJzkNu2AbM6UkXL0C493gWiyL6gIRZ1J7+dU9/wJ3SJBGsxC5FyP4UBuH132QPa26E1XvrU7vkQwVDbbdaNUkjM7RGCUsjmj+JEJ2eH8ZdAk2bfKG9sSZ6/0uF07hrPyzp9kWrFGsJYyOFXA0qEBr9HMNON0nDaYHM/yMVgkSZT2uraJvH1bC6E+yMZ1Mjf0bClSbPfCTMnCUAX4Qqv5QKQfOzyvCp6GX9BJUbLEsY1qetPWnDlmQeL8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(366004)(346002)(136003)(7696005)(6506007)(4326008)(52116002)(86362001)(478600001)(8936002)(5660300002)(186003)(1076003)(55016002)(54906003)(316002)(9686003)(6916009)(8676002)(6666004)(66476007)(2906002)(66946007)(66556008)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MwUyafjZEofWYljNGWb/0yy0CLd2wcXzYPBswid4y/XOq5hzMcpnuqG/5XhEiwdNzgi5ZkJESsMXJLjT9nOZjei34r63l8iKlBJJKyLQr6gR6tzo9oS//aAXOhmZ8vzdYkT3d+zUQL4ucci6aPGGEV4d5RV9GStdmvMHmgkt2YKcVGw1SxBPpWR1q7NqiocqJ9RNc93POZ7D/K5tSvFNgL7r/F9fT4c4f+N8CySTptmtItaVc2XfCJDRR6QvnBWl5/PE+xeXuxr/Cc8tAWH663m2znqBHry0Rcg3j2Dx+jKddZk+IyARC6F3rylsx+J92IiHesxC6AfRMrvgyJiSi+yJvWnyKd55Dc0Z3Zkth1wPJd+WMLlmI+sirEzUZDjQSwJY+Lcm2RrGvoE0own+hq7zIgKVALy6r2m1G+DJHZyxl47SNHQTFVusDfmakThacNyTGy13HGd+djv5ddureuGmYVYZ9LAcXW7lpwYBUE729MjtW9mAfbbDrxmw8iX3mnAeacRVdauSVQOgMW+IXTALU+gUKT8fWtx6/xP7P8am3PbZNokGtL2qE6cyIoaoCNyX2KGXEgco44dtqRM5evkU1NOFPAVqhQHgRdJmnzWaeeDUGn0GN0cl91/3zWb8R47gzyk2bkdOwOvRjoBGJnEl4VtpjHET2Z+bCwXqAk8cH0gsUZHVurzTXkB+kxUN
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f5acca-1af3-4588-52d4-08d88225dd76
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 07:30:41.6573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zwCntH61CMYi52o6Mh3IFMZIJ8rCCoJIIwkuL7J3Tk6qXTMU2BgTnnxQ0CddL3nk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3413
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_02:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0 suspectscore=2
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060052
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 12:29:08PM +0800, Hangbin Liu wrote:
> In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
> ("selftests/bpf: bpf tunnel test.") when we moved it to the current
> folder, we forgot to remove test_ipip.sh in sample folder.
> 
> Since we simplify the original ipip tests and removed iperf tests, there
> is not need for TCP checks. ip6ip6 and ipip6 are using the same underlay
> network, we can remove ip6ip6 section too.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
[ ... ]

> @@ -585,12 +571,11 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
>  	struct bpf_tunnel_key key = {};
>  	void *data = (void *)(long)skb->data;
>  	struct iphdr *iph = data;
v4 hdr here.

> -	struct tcphdr *tcp = data + sizeof(*iph);
>  	void *data_end = (void *)(long)skb->data_end;
>  	int ret;
>  
>  	/* single length check */
> -	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
> +	if (data + sizeof(*iph) > data_end) {
>  		ERROR(1);
>  		return TC_ACT_SHOT;
>  	}
> @@ -628,72 +613,6 @@ int _ipip6_get_tunnel(struct __sk_buff *skb)
>  	return TC_ACT_OK;
>  }
>  
> -SEC("ip6ip6_set_tunnel")
> -int _ip6ip6_set_tunnel(struct __sk_buff *skb)
> -{
> -	struct bpf_tunnel_key key = {};
> -	void *data = (void *)(long)skb->data;
> -	struct ipv6hdr *iph = data;
IIUC, the patch is to replace _ip6ip6_set_tunnel with _ipip6_set_tunnel.

Are they testing the same thing?  At least, _ip6ip6_set_tunnel()
is expecting a v6 hdr here.

> -	struct tcphdr *tcp = data + sizeof(*iph);
> -	void *data_end = (void *)(long)skb->data_end;
> -	int ret;
> -
> -	/* single length check */
> -	if (data + sizeof(*iph) + sizeof(*tcp) > data_end) {
> -		ERROR(1);
> -		return TC_ACT_SHOT;
> -	}
> -
> -	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
> -	key.tunnel_ttl = 64;
> -
> -	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
> -		key.remote_ipv6[3] = bpf_htonl(1);
> -	} else {
> -		if (iph->nexthdr != 6 /* NEXTHDR_TCP */) {
> -			ERROR(iph->nexthdr);
> -			return TC_ACT_SHOT;
> -		}
> -
> -		if (tcp->dest == bpf_htons(5200)) {
> -			key.remote_ipv6[3] = bpf_htonl(1);
> -		} else if (tcp->dest == bpf_htons(5201)) {
> -			key.remote_ipv6[3] = bpf_htonl(2);
> -		} else {
> -			ERROR(tcp->dest);
> -			return TC_ACT_SHOT;
> -		}
> -	}
> -
> -	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
> -				     BPF_F_TUNINFO_IPV6);
> -	if (ret < 0) {
> -		ERROR(ret);
> -		return TC_ACT_SHOT;
> -	}
> -
> -	return TC_ACT_OK;
> -}

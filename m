Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06522AA22B
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 03:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgKGCQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 21:16:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33550 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727394AbgKGCQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 21:16:09 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A72EF8X000799;
        Fri, 6 Nov 2020 18:15:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JJwmw9fXyZv2rxK0KCYRZkOwBZPyQlR88d2IzSfVr5Y=;
 b=Hb2QSnTXjK9Tkbdqd7ekm/2SWfa5E9CgUL5WBrtuHDy5/Kq5x5GnCz6TzekOtz5cDeX3
 0vNkI/OvlST+bgimREKyO7h7beVFQa1i0aJtZhudWWsup1aEB3xOu2rnHZ1M1HanUlfV
 L02Zxzin+oktriNslEzrIOU4ixw6cGqwXBg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34mx9pdspu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 18:15:52 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 18:15:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9TZQ4ClyQADToaIY/uXbUiuGzounZVOOPaI0y3RvzCVmVejh89XYxvJaOzxyij9x6/iCet28nB87pme8o5OcmpBY/3+G+VcwehWddrIa861j8Rk5ZzzDxR21YRFp8sfv8eoZVigbICtpS9ZYPe8XcaM5+pYtlwaI6rLXUmeuJemRCCw61ipYhBMQJZiy5gh9B5CvJj+4BmwGNJq6k2nADmvYskS4b1j6dbb3rlNbl3GZBv69DqypRaDBCWipqXTpR6kSVIOt2PIB8GVATr0Nr1507+poFKy74c7S2Bl9TAvNs8DB0zk3Wn9VS53ap43E+mLNMVxalmJv9PmlQJzbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJwmw9fXyZv2rxK0KCYRZkOwBZPyQlR88d2IzSfVr5Y=;
 b=lqxriGeT1+oKZU0Vn/TnInqcDgWJDjeVFYAWahA6eI3IHQ/WR7TE+aSMolVZP+qlDNGn5lm4W1HdYD+/pYU8slrjCt/FQP4fsdJNkQEFAr678Rhhvxo45lU/8mJ2b5joCd4ifvjsDZctRrCMN7gtQ8+7j6zqvtMUhD2l1Z7bojoDyxnT0B74NnaprT9rus9MIBsK05hm9HGPME60W3AQcaZA+MtvZ3vS6k2AuQm1mByxqtOXJzKTtapv3One2g0a1Cos6h8KjwMnlW4Ebo8hb5rJllLvEGpvxulFewLfaRgfeY5FCNxAiT4Do/f8bK7JdozhtEdrz6VgD7Clj2vOeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JJwmw9fXyZv2rxK0KCYRZkOwBZPyQlR88d2IzSfVr5Y=;
 b=EeC4tnxAGLjeojtDUYLY7TkramqXfwhDjm92w8N0xuRd1xMA0/i/cCWEaBWoxXL5f5Gee1w7MOG0T49YnXpPBaG73FJWRISY7DueoF0iKRbocqrmK05ICNXraloJhQ0HNUPdmdSyWpBGjmD6eTrcJ8KQTYhmZ8Da1Su4eWkNs4M=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2200.namprd15.prod.outlook.com (2603:10b6:a02:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Sat, 7 Nov
 2020 02:15:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Sat, 7 Nov 2020
 02:15:50 +0000
Date:   Fri, 6 Nov 2020 18:15:44 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Subject: Re: [PATCHv2 net 1/2] selftest/bpf: add missed ip6ip6 test back
Message-ID: <20201107021544.tajvaxcxnc3pmppe@kafai-mbp.dhcp.thefacebook.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201106090117.3755588-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106090117.3755588-2-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: CO1PR15CA0083.namprd15.prod.outlook.com
 (2603:10b6:101:20::27) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by CO1PR15CA0083.namprd15.prod.outlook.com (2603:10b6:101:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Sat, 7 Nov 2020 02:15:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6aa8cfb3-cae4-44f3-d040-08d882c30c00
X-MS-TrafficTypeDiagnostic: BYAPR15MB2200:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2200320D003F35B94442FCD4D5EC0@BYAPR15MB2200.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ABzQQ5vvZ8Cyh3stHbBTXiP/iBTIfj1db7rYVRvKJNxD8+M0rusEeIb/+0P8Izd9/LwNxs5f9RlbaqbhVtwxX6RfWyT5WIrFzNhrIiG+WOXirXv0tr49vmXgluBo90L/DP4jyIm5ZN683LYC5P2NJqrAwnyYDOiHGG5SAtCrbZyzAqmtX1d5rHrUSbf6CU4lkrLMyM4dvManhaG7GLYCH4QMzXriPzAySrMsbDtZ0LmfzxD9jyEPILcud3F4rpx9k29vMuuOp5bDCSOY9vGs0o/qCHh7gEai4Ruv5dn531Wf0eHjq/EcasHViDi+dFIs9/hjitCFWTmcP9hVAhaPug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(8676002)(5660300002)(66476007)(66556008)(8936002)(6916009)(54906003)(478600001)(66946007)(86362001)(1076003)(55016002)(186003)(6666004)(16526019)(2906002)(6506007)(83380400001)(7696005)(52116002)(316002)(4326008)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3HsdR/YQlJBN59OS7Q12VIU/ae+fbN3TwOunavEZU7pdZXszuEi9MBRC4FyI2T9a831bH5ni5B5C8jkZ7I4cQGU2y9GJqxQhmjXgqZfXBtAm+F0MAyCRK6UA3ZJQ/FM3U07zaLwlBMOpDS1HLmDOP/0z6I4MkrKyYoodyN8bhGS8vINZFo7FqsCuaWLIXflWbYKYKs7RsrQ9RNL7001PID/F8LCWJhp9e1QaxqwrYU1FaW1V/nDc9lRexsdRgtWvevg4st7hpY+myV3nsi0JAb102aTNe3Dy37wL0rR3DJenEqYEzvsd3QZn2rF69/1KWS+DEFUEUP+QU/DipxYjEKzXPMYTYK/JIQGlcMdKW1gMavLR+8CS1SB8JJY1swuoV6RRv7uQQ+nZUJVkLhUMeWBVeF+R+WjjQwvKC5wuKHlpXBMadePwzPHzEElfKVMNriGnGj3xe3kYOIXn9+CZCS2l4Zrs2CERg/OWI3m0Y40QpcHusoGfmLCw1rTXVniZkWPDLj7dHI1lR2K3997NvdDI4jJHc3buoJ61g/Ah80rtp4MxXdN0OmhSNZDdueVPZy95KijhvboLdHMxojcQVqrowcmz2gS8nyktf9OaWcmsjN+Dq1SdmO9Zf7tgrvTFiJHP4Vw5UpIUTPBzRvoby4o+XqHOKD+A50MaA9cTKTFCfRX7pzIq7tzS/tl55pCj
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa8cfb3-cae4-44f3-d040-08d882c30c00
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 02:15:50.7586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wjWtEdDKu4D6U17jws9XZvlma+HWZQXptj51gOzFNZucHGpMvM/qCkCTReVO7RG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2200
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=2 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011070014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 05:01:16PM +0800, Hangbin Liu wrote:
> In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> ip6ip6 test") we added ip6ip6 test for bpf tunnel testing. But in commit
> 933a741e3b82 ("selftests/bpf: bpf tunnel test.") when we moved it to
> the current folder, we didn't add it.
> 
> This patch add the ip6ip6 test back to bpf tunnel test. Update the ipip6's
> topology for both IPv4 and IPv6 testing. Since iperf test is removed as
> currect framework simplified it in purpose, I also removed unused tcp
> checkings in test_tunnel_kern.c.
> 
> Fixes: 933a741e3b82 ("selftests/bpf: bpf tunnel test.")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> v2:
> update add_ipip6tnl_tunnel() to add_ip6tnl_tunnel()
> keep the _ip6ip6_set_tunnel() section.
> ---
>  .../selftests/bpf/progs/test_tunnel_kern.c    | 44 +++----------------
>  tools/testing/selftests/bpf/test_tunnel.sh    | 43 ++++++++++++++++--
>  2 files changed, 44 insertions(+), 43 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> index f48dbfe24ddc..7fd95befef56 100644
> --- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
> @@ -15,7 +15,6 @@
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
>  #include <linux/types.h>
> -#include <linux/tcp.h>
>  #include <linux/socket.h>
>  #include <linux/pkt_cls.h>
>  #include <linux/erspan.h>
> @@ -528,30 +527,17 @@ int _ipip_set_tunnel(struct __sk_buff *skb)
>  	struct bpf_tunnel_key key = {};
>  	void *data = (void *)(long)skb->data;
>  	struct iphdr *iph = data;
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
>  
> +	key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
>  	key.tunnel_ttl = 64;
> -	if (iph->protocol == IPPROTO_ICMP) {
> -		key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
I think it is still good to check IPPROTO_ICMP
even ping is the only test.

> -	} else {
> -		if (iph->protocol != IPPROTO_TCP || iph->ihl != 5)
> -			return TC_ACT_SHOT;
> -
> -		if (tcp->dest == bpf_htons(5200))
> -			key.remote_ipv4 = 0xac100164; /* 172.16.1.100 */
> -		else if (tcp->dest == bpf_htons(5201))
> -			key.remote_ipv4 = 0xac100165; /* 172.16.1.101 */
> -		else
> -			return TC_ACT_SHOT;
> -	}
>  
>  	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key), 0);
>  	if (ret < 0) {
> @@ -585,12 +571,11 @@ int _ipip6_set_tunnel(struct __sk_buff *skb)
>  	struct bpf_tunnel_key key = {};
>  	void *data = (void *)(long)skb->data;
>  	struct iphdr *iph = data;
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
> @@ -634,37 +619,18 @@ int _ip6ip6_set_tunnel(struct __sk_buff *skb)
>  	struct bpf_tunnel_key key = {};
>  	void *data = (void *)(long)skb->data;
>  	struct ipv6hdr *iph = data;
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
>  
> -	key.remote_ipv6[0] = bpf_htonl(0x2401db00);
> +	key.remote_ipv6[3] = bpf_htonl(0x11); /* ::11 */
>  	key.tunnel_ttl = 64;
>  
> -	if (iph->nexthdr == 58 /* NEXTHDR_ICMP */) {
Same here. Can this check be kept?

Others LGTM.

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
>  	ret = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
>  				     BPF_F_TUNINFO_IPV6);
>  	if (ret < 0) {

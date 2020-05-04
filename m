Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA731C4A29
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgEDXX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:23:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11194 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728223AbgEDXX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:23:29 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 044NKeW8003280;
        Mon, 4 May 2020 16:23:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YfexcXuHK6VHvnIhXZmbFdEfjoE7uYsKejWbZGez5kg=;
 b=a2buvzhVEa9x97FkEaWfPGXTJ/ETy2KjunKDrxP/QDo8mpDGNeWV9Npgdz1488YLNojq
 JWqp5jxudyfralODsUzdtGghjYAJpWU0caqQ25366Mj0ipbJQIFRnR7JRpga3uqkTk49
 RBU+ZUNlk4heLdYJ3dtx01N3qi8lCcAo/sk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30ss0wqttf-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 May 2020 16:23:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 4 May 2020 16:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ietQmPopbMA4CLKQkrklkp4Y3M3O+F5uKOHzmn3oiLDSHdfPGGedGLo055YpyiJS83nl0cSsOoGIExzmGVHJGbLtG7PEQ9pwxcheHC9KC7mHE6J2tj2qdiF5ElEWHgH5BZ0XCRziFn+IpkdTksjdxyTJS1Xd76fawT6EeV3mAMbFPTTbha3fE59VVABG7eZxAyv04BAWJj+uyFZoi2Cv7GndZgm/4MqTe/ydzRon+JoQpEUx3kgOMXesTMsMQA0j4DaCiLv3oxCpyRm7j0AVE1q4f22u3iIDDmy4pnQhYx+BWRTvTTgGT8UZSLp3r5VPsYS5GMN829a2rwMPU8USJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfexcXuHK6VHvnIhXZmbFdEfjoE7uYsKejWbZGez5kg=;
 b=C+7GvtLC3zlJcm8klWFcvEon3Nk3EQ8wy8DVUwCe76fzEl98mplq/iJ3XcsEIKX+KDgYLzRK3RwGL9eYaeqAe4bvnALZDK6MRH4K5U6HNkFtzwVAExwyclhGQRD2hWqQSJJbGxx+ZwaUpiAfEuHY0IArIQOAK6HznylHYzigZSEa6z0pS1XqibatryamlULZVwXXQEQytBRprUw3dMcZ/UaIbFcxUjdyfMz/6afqBTQqjmxM4qpIuCOiGaaqt/hQoETBn1Gm4Gijw35wo51HFDLtP0oVP1J2OCc155FarRNm+hgo5EE3y4b/uds6UuCJ0HMGmRthUL+XdlzuG4QBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfexcXuHK6VHvnIhXZmbFdEfjoE7uYsKejWbZGez5kg=;
 b=FbhUrx4W4Fka1JbQ3MkHQRMqc+UNQ/HfifNrEaO+BzdzTqLHvB1qG9ZriGrD7A+ySMk6SvPTn18T4WoBmk8tcsd9iUN3VOJo7010UZRRHJ1BBOfGdBVAsGjJ/MEFiT6f8blDJIzXhy36x56T0p/Kp25a8Oqxen4piN17Fox/3CQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3384.namprd15.prod.outlook.com (2603:10b6:a03:112::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Mon, 4 May
 2020 23:22:48 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 23:22:48 +0000
Date:   Mon, 4 May 2020 16:22:47 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 4/4] bpf: allow any port in bpf_bind helper
Message-ID: <20200504232247.GA20087@rdna-mbp>
References: <20200504173430.6629-1-sdf@google.com>
 <20200504173430.6629-5-sdf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200504173430.6629-5-sdf@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BY5PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::38) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:d4c3) by BY5PR04CA0028.namprd04.prod.outlook.com (2603:10b6:a03:1d0::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Mon, 4 May 2020 23:22:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:d4c3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 857fd7d0-c5f8-4056-bd61-08d7f0820f03
X-MS-TrafficTypeDiagnostic: BYAPR15MB3384:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3384B1522CEAE141F3AAC72FA8A60@BYAPR15MB3384.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QOebkKloMAwuXQWDOWzNGmfRN2dOO4RwrKt7e6oPUKH2szoR72dPzDfDQXTiUg+XnpY8PuW/a9J2k5V1R902FrHWUUqq2mA5hd7v+56gYl3o5lIBBKj226X+G/T9f+D5wT8SztvbKQHRXZbn3oA7erbB+1UQI3J+QmT2SZmMBPxly6kl1PFBv1ONyMMP9vk6N83T4gZoujS0c3tvDeKD6GH9NpIB0Q9TZc14sysfjxKVdI7qKtmF2ihMx5st+b/dZsuWz0l9K4OJ1h019YnvPMxxrRSkIAlqJQvlbDANwr1wSc+9bzJHWWf3Wx7iKMUsbpe4IaVdl83BZsv4MtdmtapP+BMehdr431RDFzxPFjkmlGR3QEcpB1Bz1l9tsSJrYVOqAc6BPGyQY9NyZ2zMzkGjrdm8ST+Z9ooBmrBdn6Jdj98BSv+PxdK5sqEz1q1JIlNuuSRGv7G6cdJmTdlTNDvt5oSFgbeUHPCUGTFOvBh3+fmnZNuLtDUuPzK4R9mmmbbNtzIuLZxMzd/msI3znQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(346002)(39860400002)(396003)(136003)(376002)(366004)(33430700001)(9686003)(33716001)(8676002)(33656002)(2906002)(1076003)(66946007)(33440700001)(4326008)(186003)(16526019)(66556008)(6496006)(6916009)(6486002)(52116002)(66476007)(86362001)(316002)(5660300002)(478600001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LZXc4lG8tpusDC0KbNYJi3RmFhUmSZ/wgNiVC8jYQ6jwBM0H+jsKObzMO0SGZJnjdUCIgbKTSO3dbjEladcOHQWfGgv73nl421MTKGBfZ6znZ85uFyhY+sED6JKtogIXQmP1U2pN5HI7KItF+pIHYL7+lvHT4l1BM89+TjQBqZnJmikHPglM2LttD/j5oV0nEkXl5gavxV2i7QB+xJJfMKoXdcKeuJwNyfpcXxcyFZVI8GzfBoJwcuty0WBg1AekADizmHY1gTmWkhxGDbvJK5WpdBu57TvI5fxemZ+HxxACaySR4TfhmhIuYz8fszVPW8rK9V2xT/KuLZXncO4G14quvGAZq+q+PxRqN0uBHu+OhFkRDQKyYLoL7q000kVwaWihk5Y49Nyfi9DA9eZ0UG2b0QhMXD+OBDl3IWm8myJsz37XY34g2XqceOgDiX5HGlJXob7uMyJ3sy9z5kX1AqwNIDwsLb4l3FnpuphHiGp/NVC6Ea3Etxqhv+wDyl8PVNI1R3FAQbrXAFMW9MAEX0zIOyXSR8+noyLW7SHsv4RgIZIue99LV8bnQ948aeBr/0ucYpAKenROCer2UuHiibUpGwZrJq9AmtyJzJk2eSotnNw6UG5yY7tPhVp4Hthujy3/MoHmd8eb+YM+kvjCXXFQA/tqMY9/6zrqC0vF01m+8eEisFRXb9/Ju1skLBeLD1eUt7iz1xcnaQyrUb9TOjrAN7RAl0ygWpUQvepXYe3gs7TG2KdR71zqMB4u2Fy+wdDfgCL6JrS3zoxAoRDLqIkoHZ7dys19QuBzT/A5K3Lb9BVBLpY2p6T78mrWYqX0O0vShvl7QQN8cYOT4mbiFA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 857fd7d0-c5f8-4056-bd61-08d7f0820f03
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 23:22:48.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2n8R48uDdFvHbLE73d8t9TjooepPvk0DKFt4frs8N9lYx8TAxENTKLmSneGqWK6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3384
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-04_13:2020-05-04,2020-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 suspectscore=2
 clxscore=1015 spamscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005040182
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> [Mon, 2020-05-04 10:34 -0700]:
> We want to have a tighter control on what ports we bind to in
> the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
> connect() becomes slightly more expensive. The expensive part
> comes from the fact that we now need to call inet_csk_get_port()
> that verifies that the port is not used and allocates an entry
> in the hash table for it.

FWIW: Initially that IP_BIND_ADDRESS_NO_PORT limitation came from the
fact that on my specific use-case (mysql client making 200-500 connects
per sec to mysql server) disabling the option was making application
pretty much unusable (inet_csk_get_port was taking more time than mysql
client connect timeout == 3sec).

But I guess for some use-cases that call sys_connect not too often it
makes sense.


> Since we can't rely on "snum || !bind_address_no_port" to prevent
> us from calling POST_BIND hook anymore, let's add another bind flag
> to indicate that the call site is BPF program.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/net/inet_common.h                     |   2 +
>  net/core/filter.c                             |   9 +-
>  net/ipv4/af_inet.c                            |  10 +-
>  net/ipv6/af_inet6.c                           |  12 +-
>  .../bpf/prog_tests/connect_force_port.c       | 104 ++++++++++++++++++
>  .../selftests/bpf/progs/connect_force_port4.c |  28 +++++
>  .../selftests/bpf/progs/connect_force_port6.c |  28 +++++
>  7 files changed, 177 insertions(+), 16 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
>  create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c

Documentation in include/uapi/linux/bpf.h should be updated as well
since now it states this:


 *              **AF_INET6**). Looking for a free port to bind to can be
 *              expensive, therefore binding to port is not permitted by the
 *              helper: *addr*\ **->sin_port** (or **sin6_port**, respectively)
 *              must be set to zero.

IMO it's also worth to keep a note on performance implications of
setting port to non zero.


> diff --git a/net/core/filter.c b/net/core/filter.c
> index fa9ddab5dd1f..fc5161b9ff6a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4527,29 +4527,24 @@ BPF_CALL_3(bpf_bind, struct bpf_sock_addr_kern *, ctx, struct sockaddr *, addr,
>  	struct sock *sk = ctx->sk;
>  	int err;
>  
> -	/* Binding to port can be expensive so it's prohibited in the helper.
> -	 * Only binding to IP is supported.
> -	 */
>  	err = -EINVAL;
>  	if (addr_len < offsetofend(struct sockaddr, sa_family))
>  		return err;
>  	if (addr->sa_family == AF_INET) {
>  		if (addr_len < sizeof(struct sockaddr_in))
>  			return err;
> -		if (((struct sockaddr_in *)addr)->sin_port != htons(0))
> -			return err;
>  		return __inet_bind(sk, addr, addr_len,
> +				   BIND_FROM_BPF |
>  				   BIND_FORCE_ADDRESS_NO_PORT);

Should BIND_FORCE_ADDRESS_NO_PORT be passed only if port is zero?
Passing non zero port and BIND_FORCE_ADDRESS_NO_PORT at the same time
looks confusing (even though it works).

-- 
Andrey Ignatov

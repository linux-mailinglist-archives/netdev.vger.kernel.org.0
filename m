Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7422A6CFF
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 19:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731139AbgKDSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 13:40:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728841AbgKDSk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 13:40:58 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A4IXcN4025443;
        Wed, 4 Nov 2020 10:40:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=PyHKaXImSx54IR5j6eF+wPgFXoOwk6SiVca1MTU8EiA=;
 b=J364YZMncKn8h4hNqGZ93JFZWEJ36fReGYRDgBNkjDatpbleh1fqbTADO7Hjo9lV7i9z
 wVM/hu3LMah3pUeZL0UeHlqBLEwV0bct5kKKg4xYbm7VOGzjDgkrCqmenm5G97cj7tIL
 5a+zLxsg+RbKYUXdqfkAwQnB6aj3t3hqCt8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34kg7kw5aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Nov 2020 10:40:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 10:40:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EV5qtdBUL/kL/M+YAFjx+2tq+K2YKToFKAppDIcmgMwMnMHDMyTTElwZPE4aCSOdZKrP0gAAJf9k79io69vhlmQ7IQzkzhbxLUJI7Mx837sBzkGNP8JdKt7nzz8Vb6sDwdC7NYQF3RenqoxSCdU0CGpGIY+nZJgTo5LZWNt7KKqa5YPpNPG22h1S3/E1mIdjN3VzThSUf8MFZdoacfB7JtXcc+B7vu/o19CvD3I8O8jDKGfuitOme7MPV1D47ANdrM+yAFFV24ygqZIBTEXy7Zswff6D9xX8CyaenWaq7nG2ElulcE5P+7jzH7mkaz0Thqseuixet2B0Yi4sKIk6QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyHKaXImSx54IR5j6eF+wPgFXoOwk6SiVca1MTU8EiA=;
 b=Pp7tX587wqqC8+2wfan+HdtFHLtAslvOHNpzXIKqKbQW0CqsQ/HFQ06fpt+C/5sewPEFuuBE15AzFJgNVtg3h6HXEjMihE3eaZ3X4QLmpcVzvFsbdYE7Qut6lkfWYLGAbAxl1k0OR5+EKP85y0OOZ8AvkPkwpU+D+Z3ipdPO1cTmYhX/ldkrtSxR4FYJl0sUzEhl9tdAFB9Cp3kbwJH9ht5cnD9SQxhTcehAx1Io7iSEqDNZHt9KOE5j2Xe/6qJdEUCAypu5dqlHpfbZ+7/Ki6xOZ+0HAPg86saP/r7qzuAWgW2LDPvMxxWv9Z3JzUK0QNJplOlOFtdaMiwZ3xvzTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PyHKaXImSx54IR5j6eF+wPgFXoOwk6SiVca1MTU8EiA=;
 b=H1aN37WwV+efVUA3H7UoPSmKmNEV6AfzuM0ECoMumNs9iJDx1/UjErGA63EnKvBS9jYCcZNp11I0Zk1SYthBXG04GQcGdqo89v3Ke12RrR8D86muYhV2a//7FRAwkNQxkiXWPbOEcE+ZVewaMGVQpYDRsdakFZZuY80mqj5kyXg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2581.namprd15.prod.outlook.com (2603:10b6:a03:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Wed, 4 Nov
 2020 18:40:41 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 18:40:41 +0000
Date:   Wed, 4 Nov 2020 10:40:34 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/2] selftest/bpf: add missed ip6ip6 test back
Message-ID: <20201104184034.c2fse6kj2nwer3kv@kafai-mbp.dhcp.thefacebook.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201103042908.2825734-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103042908.2825734-2-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: MWHPR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:300:115::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by MWHPR11CA0040.namprd11.prod.outlook.com (2603:10b6:300:115::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 4 Nov 2020 18:40:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ade6a1bb-9191-4ebe-fc13-08d880f12159
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2581E2D8A5AEF337CF087515D5EF0@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IRddJDzrAWx4DPc+Rf3V8E4HlmS1T177bV7WjrF+IZIEkOVINesYUVWHyEYUnpfyH9wX4Ig7biQ17nhOwh4c/j8qt7wXvo+8jhYRdmRE1sP1g1CDDtkjjNV1e/qbjPmHODzkEBYvctTUPulqv9x4/iwdCASBGJwCnqMjBPcdCu/RO5tNCbTFwqY/FYS46ECZgvOL4dxz/qAlrEhqFjnKnQilvFHraWtCVoZntC6ZHPjJPdl9ZAlM7rwyS+6fWifSpiMZc6a8LW8sPSZtciHeIYHr6BV3PcjXY9ELkuG2XaVhBM0cDXRnZLNmNdoRDMSzYTtWmjKDAM+o2K13H2gBgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(6506007)(66476007)(66556008)(4326008)(52116002)(7696005)(5660300002)(16526019)(6916009)(478600001)(186003)(55016002)(66946007)(9686003)(83380400001)(6666004)(1076003)(316002)(8936002)(2906002)(86362001)(54906003)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 08iWNiirOTA/ahGpgWVHYd5jjDF68+2IJ1iAooQJpaUyRPTFrkBs1hDUqYYitijT2C3JAw3MAT2aL3KkC2DSR1f8xBLiuNNF/84r51gh7QcZvlf7XQd8JFzQt0IjS0NN/Byay2utmB1A9C9OLl+mGDldyvaVcWZxWIXbTnbX+sTsAaS3FDR1WX8xItsJmdPQ1GxZKFh17hQF8j0fj6IWXG/3NfD4aAA+lfHcwuHe7EHN2i8xaRSXoAzj/ty2cmBcDjJkH1jdRWszeHioKjN5zDiVPhlfcniNUv8/9d1Jq/pSNc32tq8+NOCfZvw/a4BkVGHa2DCKHs6hqBS0gvPbkYXUNi7ChsQ0aSDBtdbuoNhkOAFm0FQ3nUDbhmCwVLifpCnmYm4gzozNPoQL/dBx+qC2TjWHC3U00CfusOc2W4SMbblJvsC9JZ0Ppt+R3gY8P4oPYrRUbY0nOTzpWjl07FTHCHCmbGmCTvkzZQnj+atB9XC9VnkqWHEl8brWRUnoLp/c8IxioJFxx+P57tpRTswuctAEy9b56Rl8apGLJs5QoCBzFF5eczBisg0rjIpbL9KMmGNQ0Ji9qim84ow/7I5hU03mMAviRO8L4tKxoJGX/KNj3y9tA1Vy7bidduGkUg9WeKZYGGvPpQAenUf+UurfpaDJTLjlcHeNefLN1LU=
X-MS-Exchange-CrossTenant-Network-Message-Id: ade6a1bb-9191-4ebe-fc13-08d880f12159
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 18:40:41.0742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lN5YZ9SO9XGjJXLkUXrxBh5YAdrx06TcSZMPoL0S0vR3aXxmNSTbt54PLoVf5oV4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-04_12:2020-11-04,2020-11-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 phishscore=0 suspectscore=2 impostorscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011040135
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 12:29:07PM +0800, Hangbin Liu wrote:
> In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> ip6ip6 test") we added ip6ip6 test for bpf tunnel testing. But in commit
> 933a741e3b82 ("selftests/bpf: bpf tunnel test.") when we moved it to
> the current folder, we didn't add it.
> 
> This patch add the ip6ip6 test back to bpf tunnel test. Since the
> underlay network is the same, we can reuse the ipip6 framework directly.
> Iperf test is removed as currect framework simplified it in purpose.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  tools/testing/selftests/bpf/test_tunnel.sh | 39 ++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/test_tunnel.sh b/tools/testing/selftests/bpf/test_tunnel.sh
> index bd12ec97a44d..76a00d2ef988 100755
> --- a/tools/testing/selftests/bpf/test_tunnel.sh
> +++ b/tools/testing/selftests/bpf/test_tunnel.sh
> @@ -24,12 +24,12 @@
>  # Root namespace with metadata-mode tunnel + BPF
>  # Device names and addresses:
>  # 	veth1 IP: 172.16.1.200, IPv6: 00::22 (underlay)
> -# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200 (overlay)
> +# 	tunnel dev <type>11, ex: gre11, IPv4: 10.1.1.200, IPv6: 1::22 (overlay)
>  #
>  # Namespace at_ns0 with native tunnel
>  # Device names and addresses:
>  # 	veth0 IPv4: 172.16.1.100, IPv6: 00::11 (underlay)
> -# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100 (overlay)
> +# 	tunnel dev <type>00, ex: gre00, IPv4: 10.1.1.100, IPv6: 1::11 (overlay)
>  #
>  #
>  # End-to-end ping packet flow
> @@ -262,11 +262,13 @@ add_ipip6tnl_tunnel()
>  		ip link add dev $DEV_NS type $TYPE \
>  		local ::11 remote ::22
>  	ip netns exec at_ns0 ip addr add dev $DEV_NS 10.1.1.100/24
> +	ip netns exec at_ns0 ip addr add dev $DEV_NS 1::11/96
>  	ip netns exec at_ns0 ip link set dev $DEV_NS up
>  
>  	# root namespace
>  	ip link add dev $DEV type $TYPE external
>  	ip addr add dev $DEV 10.1.1.200/24
> +	ip addr add dev $DEV 1::22/96
>  	ip link set dev $DEV up
>  }
>  
> @@ -553,6 +555,34 @@ test_ipip6()
>          echo -e ${GREEN}"PASS: $TYPE"${NC}
>  }
>  
> +test_ip6ip6()
> +{
> +	TYPE=ip6tnl
> +	DEV_NS=ip6ip6tnl00
> +	DEV=ip6ip6tnl11
> +	ret=0
> +
> +	check $TYPE
> +	config_device
> +	add_ipip6tnl_tunnel
> +	ip link set dev veth1 mtu 1500
> +	attach_bpf $DEV ipip6_set_tunnel ipip6_get_tunnel
From looking at the ipip6_set_tunnel in test_tunnel_kern.c.
I don't think they are testing an ip6ip6 packet.
If the intention is to test ip6ip6, why the existing
ip6ip6_set_tunnel does not need to be exercised?

> +	# underlay
> +	ping6 $PING_ARG ::11
> +	# ip6 over ip6
> +	ping6 $PING_ARG 1::11
> +	check_err $?
> +	ip netns exec at_ns0 ping6 $PING_ARG 1::22
> +	check_err $?
> +	cleanup
> +
> +	if [ $ret -ne 0 ]; then
> +                echo -e ${RED}"FAIL: ip6$TYPE"${NC}
> +                return 1
> +        fi
> +        echo -e ${GREEN}"PASS: ip6$TYPE"${NC}
> +}

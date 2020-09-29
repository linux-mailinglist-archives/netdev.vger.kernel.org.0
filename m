Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5802A27BCAA
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 07:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgI2F7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 01:59:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725300AbgI2F7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 01:59:30 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08T5sBkM019987;
        Mon, 28 Sep 2020 22:59:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xn5yoK+w5zvVtBmK4MukckVBCA+NBSsMteEZDOtoJRI=;
 b=fUWIzb23UPMFrt5iCo8ah9/YwN7p+5JXlbp3a0ArHhtvPpAlqmvHQ43TsTQILT2fEBJ8
 Jq7HPfk9h6aTITjhpRIMo+1lnr4tYNPaXu79S0uLHEg0GsGicJn3kWJuyUsVgkpX5KdV
 5fcnI9H5tmh52hs+LblTAghgyaNrAMF7G5M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33tnfm0u63-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 28 Sep 2020 22:59:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 28 Sep 2020 22:59:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6UcwCNsyx51w/bjBsPzTF4vEu96fYRZQXSx+SMikdBvkhrWGSgcshHNJfZvVtue7I8dnboKCgbjn1UBK99TKxuqBufLkPCYDHTDDd9GSV1cqsZapDmL1kurOP8nZsSwjvgaHfc3nLSyZyzwvlZKaMSevqSxnODGFfFxVyywvxigBqN75f6qk5uTPnDD5nS0X+0Ib0y1vZrOVXLsQPZHju/rTUa0xUWC0QDmCZ8DO38pmHzanTt0XDH3c1S5M150RA0cDGZicVHSkZ2Q62ENjfVN0et2H5WTCVkFGtH2k1cAk2jZMYToDgoY/7sT/cX58N9N+Xv2cDx+hxebX7BqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn5yoK+w5zvVtBmK4MukckVBCA+NBSsMteEZDOtoJRI=;
 b=Gb37ybdHIphG7MbtkLntkjQEsyH7shSPNAfi4IXb2UY1c2j0U9kKgLMMdnwsIoE9RyI94DCXjQrb6Uq/9cNIOZCWH3y15BkV0Vh6LpJTRqAAIUJA3sK3TPSux3FnCFUiGE2lQzXU8gI3WAQuj5EzoCBVfsPEDjqDGxK91Fm8brW+BliraU0nVScYZXxV2g/r9MM6f4+BXl6gBsu++py7hKkvieIJLb4nYSjaODH8tfHQ2WKsVjcJmVTJc/28fAfHXBrCF+P7ns4H3jN8RUJTxWx7C1X6DsVMCpRGLH01eXoP6dl4RSOrnBX3U2CXbU6//iksTHCGZhBoluorMA/j9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn5yoK+w5zvVtBmK4MukckVBCA+NBSsMteEZDOtoJRI=;
 b=F2xlqspkd3YUEf9KgZfgpneDRrAc0zIQsOKMF9k3+X8N/p2lavoIwsMThFcIIlqt146O1LYGJBQT9pky6cvTu2CdRmQYoeoFRqm54Hv0+M6WZHIx3Gc8xr/jFYp6w/lRT/xtjDNOUUCLEepzVaTSCH7S7qkbMbQUqnxBCrwsBvI=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3207.namprd15.prod.outlook.com (2603:10b6:a03:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Tue, 29 Sep
 2020 05:59:11 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 05:59:11 +0000
Date:   Mon, 28 Sep 2020 22:59:05 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@cloudflare.com>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 2/4] selftests: bpf: Add helper to compare
 socket cookies
Message-ID: <20200929055851.n7fa3os7iu7grni3@kafai-mbp>
References: <20200928090805.23343-1-lmb@cloudflare.com>
 <20200928090805.23343-3-lmb@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928090805.23343-3-lmb@cloudflare.com>
X-Originating-IP: [2620:10d:c090:400::5:d609]
X-ClientProxiedBy: CO1PR15CA0085.namprd15.prod.outlook.com
 (2603:10b6:101:20::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:d609) by CO1PR15CA0085.namprd15.prod.outlook.com (2603:10b6:101:20::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Tue, 29 Sep 2020 05:59:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 864bc275-3401-4845-d346-08d8643cc94f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3207:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3207356CA0CCE1A9114056C2D5320@BYAPR15MB3207.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZdoL0sAaQRJ3l9nMlCATfanpKVn3a3MAMJuC2jir9K32eRxwsQ+I1H+MNTUj0QNzookxdBi5F0lo4SmG8XS7RpnbwGZLcf0C0QKsWKdth2XNd2CqpjQnyeqWEzxLduvl2lssBozC+rmYQaTzhIbJBksJXLHf3EtgacRk5m0abcofQWNhrsRJGl8HgWHrKiv/COqRV4lZ0mrZLnNgIRgGggcpTNBcccTd37pld25Ti9kbjgyeOuD2RqSkWgNUOBqbxSZjlGyvnceMERAhJepSkWTu3mOaqpCbzo5Dgz8sAzd9EyPzhXUQZ+T/Y7JSQ4q9S8nuFs4PmcyP8o4Ai0oqgog7klp3peYAPx3anAoK/s8Rx66oh22FRdocHcsPl3+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(366004)(396003)(66946007)(66556008)(66476007)(4744005)(1076003)(4326008)(2906002)(86362001)(33716001)(8676002)(316002)(8936002)(478600001)(6666004)(6916009)(54906003)(52116002)(5660300002)(186003)(83380400001)(55016002)(9686003)(16526019)(6496006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: TRIrg1HdjDoSHUFNE1+fprx0J0tLM4BeDS0leMD28a3nFYT/08fgskuU49T9R1Yazdn6Q39KHyutw87+QyVCH+cPfNvmUT5le2LrFlcLry9Qhpz5J9BVZrH99VEet2aUvE00ZyN0ESzrFfkekHNvFNi03yReXfsqdKcdwSTzqaopnawWuGsczJbvbEGBAF03VGiKORSajlmvWB/NSgFO/iMSAo3GyqNKdG7IX7D+L1QKscrRykXiYSDrtJKEvDl4ImlxhxmfxtPRv9/XeykIxV+RniwAJERXxPc0UUMEO2j6ScZMmsAT4rpQfjHSHZ27M2rnpl8SYVrxe0jwLP2ns8k0/zwD4w8+aFvjpT+FEwtNE1PomOU+bTsampepcSmoOEHHVc5k5J6NLqkS/aHFGIyYnlgJEL/Ub157Wedy6jC7+hKZ/pHRJhYSrIAnyQb9OMnO2E9HGkY6dQVCPvzOGCLyAoZl58H+rRe67nL77U0iqFZfmaOo8Nwf41tskHirtFPrRI4+lxoicr31ObDZoiSKxr6VRnH3ySw6qqBP3pCmw0LugiNY2XewpciPbwVq81TZE7kgYVuMJ5UsscPDEArW1fQj+tFobdSPIVVSJFpJgKMCX7sFAhfpG7xH2Bqz/lFUcUquLrXpzC8vxQSbrXPzWEjDRwBv/ezrZYprIp1AbjxOwoAggOUhd2r6OCXL
X-MS-Exchange-CrossTenant-Network-Message-Id: 864bc275-3401-4845-d346-08d8643cc94f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 05:59:11.6389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srlgCrocJeCKVxXHcYUKxLM7yIcb6thjMR9zmSILWNqcICNx72Dz+USbwLFpqbnl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 suspectscore=1 impostorscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009290058
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 10:08:03AM +0100, Lorenz Bauer wrote:
> We compare socket cookies to ensure that insertion into a sockmap worked.
> Pull this out into a helper function for use in other tests.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_basic.c  | 50 +++++++++++++------
>  1 file changed, 36 insertions(+), 14 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> index 4b7a527e7e82..67d3301bdf81 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> @@ -50,6 +50,37 @@ static int connected_socket_v4(void)
>  	return -1;
>  }
>  
> +static void compare_cookies(struct bpf_map *src, struct bpf_map *dst)
> +{
> +	__u32 i, max_entries = bpf_map__max_entries(src);
> +	int err, duration, src_fd, dst_fd;
This should have a compiler warning.  "duration" is not initialized.

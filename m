Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5592BB7C3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgKTUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:45:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7772 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728041AbgKTUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:45:53 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AKKbQPa009778;
        Fri, 20 Nov 2020 12:45:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y7dmCPMXc9B6qdfKeX1c+t0mV06Izu1ejgTGAUD4iFU=;
 b=O8wNMsqxWYBTX1F91KHFF3c18JW/5zU4OtiFmhCKZvH2vHchpRZpiITqgzMCYVzlMVw/
 sNS1QPKPUuq/+6QIKBM+SlaVUNWzorkEfQrg7FJLgs9hGzBB9QMHGq3NYIMouJbG+TX4
 VixtG2aOJjwBdQgAdpqnexIuVv/6Yq3B6JA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34whfkwf34-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 12:45:34 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 12:45:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rkg9PwrkF4p5D4ZeWo9Yp9ypdCsgt6FmUlAzf3Teuz329DS1iFmwzPjnO+rjEqpKe7p18LHT878GGTk5hMaU10J2IrrvS79ic2nAb7KOllg95/z8uUuXRZsX0vNhF8JS67TehJg6c3zOr8w1wNG2RFSAq+jRI8wzkSNkgNETYo7N5UEmXrFtAlr10+iHSEEDSemz4MQ3FcQgWAY8RXi7M2dAEFJPyd1SE7SGOt9KhfYexusV8WPTUA7C4rQTXNqr25bjJL95bl+h7MjENY1YXIR4ZuIGa4lxXaM4pA55iBAmoWC3/HsA6PSAV1/cG+4L2cRXN2M12OLJRttlKBeRFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7dmCPMXc9B6qdfKeX1c+t0mV06Izu1ejgTGAUD4iFU=;
 b=efEfiV1gfjrUzYkAZYX9ZOS0Ftoyob76huUfkLhZSfwfIWssVyG9Tjxmpas/70vrtHJdE566k4MlTP5JFFXnoe7/H6uLVPJCIMt7h83Of4xFk3Y4ClARGBHbepK2mk9dv7G1dMgFfzOhX2bdh9qyePz+A99XDa8vouIxYekrOcD6q1pOauD+EgWruoQkMoJoAsb+kix5HLa3fpp0G5qXgPZGbE26CfONG1CLzoqJfpqvf7C8seQFejwj86peqhZsC178MuQbVvg6QpTo/zuOkhNs4SRLbu0QoImlskVo9XPbN9wIFHIU9y5yrK7fVOicQYoDfF12JqAuTRUsfzZDrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7dmCPMXc9B6qdfKeX1c+t0mV06Izu1ejgTGAUD4iFU=;
 b=hIreA8PpaFNJYIJNX+b3dt9PYvEpniaVy/TcrsEA2NoI0E4mGAt6/pSMAcQ0s0SI57l8ls5VhZGYAIxQOsxO/cDTbWob4VIUh2MKUq7JMypGubHCy2is0qTVSxgZ03DC0JUsFld6S6cgW2dWYtM8hcaRC8O3Ryq2v6DJ0Djsyaw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 20:45:32 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%6]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 20:45:31 +0000
Subject: Re: [PATCH bpf-next v2 5/5] selftests/bpf: xsk selftests -
 Bi-directional Sockets - SKB, DRV
To:     Weqaar Janjua <weqaar.janjua@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <magnus.karlsson@gmail.com>, <bjorn.topel@intel.com>
CC:     Weqaar Janjua <weqaar.a.janjua@intel.com>, <shuah@kernel.org>,
        <skhan@linuxfoundation.org>, <linux-kselftest@vger.kernel.org>,
        <anders.roxell@linaro.org>, <jonathan.lemon@gmail.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
 <20201120130026.19029-6-weqaar.a.janjua@intel.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <86e3a9e4-a375-1281-07bf-6b04781bb02f@fb.com>
Date:   Fri, 20 Nov 2020 12:45:28 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201120130026.19029-6-weqaar.a.janjua@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f0a]
X-ClientProxiedBy: MWHPR01CA0025.prod.exchangelabs.com (2603:10b6:300:101::11)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1688] (2620:10d:c090:400::5:f0a) by MWHPR01CA0025.prod.exchangelabs.com (2603:10b6:300:101::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 20:45:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a6b010e-7f5d-4681-b957-08d88d9538e4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2775550A47CAE21A1BC060D3D3FF0@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AaOryu6FcdBXdpJ1SagdgdkaD7+4vd0SShJcDQ1fXYwdPN/DAVRuizV0XFmHHtTNkfkLlCF7ITQpeV6uymC9ggT5+bVkF3Wyi37/CPxq2o2w62RyMKLufrbN/HGOY1fzxqXRZnuPbwMMYsxgDJqIdAXYOCd7D3iIqemJCwPYQPG5ekXL1occzTi39n/Epot0Np9b+nKzCG/llKRDMaE8Cl0WbQBrKvJPOdtwugWFPdQpK97GvjTv6a38dsFeXN7nmAWBxM//QyBelRkAKT4zLTEkypqiKkIg115EP4TkO3RmYLHh306KCWBV96EEdiQHFJA8gtf0r4kHWUJ4r0qljwAU245ZYt7tXTc+BFfnlTx1U9kilS9f/8pGslzWhcqz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(376002)(346002)(316002)(2616005)(2906002)(16526019)(83380400001)(31696002)(52116002)(53546011)(186003)(31686004)(5660300002)(36756003)(7416002)(66946007)(478600001)(86362001)(66556008)(8936002)(66476007)(8676002)(4326008)(6486002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: N+iykqJt9F67BOjzyXj4+/atGhgMk7/rSd47gTGPMzMWjGM+f5KjiCmiDx880tXkL9J+bR++3rkUMzwfXTXCTy6lWYHKiy6TfiANQYJwPMKakLGuXI9e42C4nwZ8AjclDd9310x0k617I4Jd8n+LQwNHS0Mgzz1AacHpx+wacr6HQhnNQvA+OdG0xuemkbMFEbe+KC16zejDMI5UE7w8iaQCsWEMrO3ITAo0l92qkOsjMIibJbggLlCrVYYWbRkynIIm6cZQpMMEeQEPK/u+tQxb2dDeXKyXPRP8h/lptXdvdHXvb81eu0Xqz0bO+CddJl7OMAKY31THeriVB+5PA0uvOs+v4WIkIoV/93PmqpEGNg64syGxD3dcNfIxrz3ip93qkPo4kzGNcMAZ1UtwpqJh0ge5BYJ9Vu+8xFwBsA1HJPOjnXBH8EAq8q/vgoz5Aeye71ojK/AHAhxq2BABZ+2r9WYe2T07HNgDmqZdPvUzWb7RDrKwfkVuiPwS6PLEiamUlh3gG9YZ7lZ+F+vnOlT3tkMReyTXdw5Oe6iS50ZuGfLPt1yGUMM+wGEaCwPbjOHKkut1LDQ3Gvl7jKkBsspI4goLaqZtfsXcCIfQeX+FCk3QZcANLI9N6/o/li99LmFnjDwNBURDZTLMEphtGPHGE67zxxcyLDLuDW+/0VBMYwTBu+9KTHZ6MpPQraFxiZRlM3NLtsf4V+bh5GWSXxNHol+0c1X07xlQBiH+pScCvgKftHLSOKTjEXxqg/en61t6jZf09EaJjUwpixEr2BWcC86oXu3KckQcUUZ+NTMgcJp0MK6x7TyUn2pXxC4Bu/5FtsvohKgCACvYFUb6ZD6WBZBVcgjzkT2rVr1ce60vqWDeShMtMmf2I6S05NenjIf3+Y7VC0PNOrkEsSYrNENd5UIZs9GJrfu5aJtQjqE=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6b010e-7f5d-4681-b957-08d88d9538e4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 20:45:31.9241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7P29IzeCBZg1DrT6pc3VYkhn8Xf0K4Usw2Aoho6Ha3cuUMsowtXhSiRvuJDBvJc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_13:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 phishscore=0 suspectscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200139
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/20/20 5:00 AM, Weqaar Janjua wrote:
> Adds following tests:
> 
> 1. AF_XDP SKB mode
>     d. Bi-directional Sockets
>        Configure sockets as bi-directional tx/rx sockets, sets up fill
>        and completion rings on each socket, tx/rx in both directions.
>        Only nopoll mode is used
> 
> 2. AF_XDP DRV/Native mode
>     d. Bi-directional Sockets
>     * Only copy mode is supported because veth does not currently support
>       zero-copy mode
> 
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
> ---
>   tools/testing/selftests/bpf/Makefile          |   4 +-
>   .../bpf/test_xsk_drv_bidirectional.sh         |  23 ++++
>   .../selftests/bpf/test_xsk_drv_teardown.sh    |   3 -
>   .../bpf/test_xsk_skb_bidirectional.sh         |  20 ++++
>   tools/testing/selftests/bpf/xdpxceiver.c      | 100 +++++++++++++-----
>   tools/testing/selftests/bpf/xdpxceiver.h      |   4 +
>   6 files changed, 126 insertions(+), 28 deletions(-)
>   create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
>   create mode 100755 tools/testing/selftests/bpf/test_xsk_skb_bidirectional.sh
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 515b29d321d7..258bd72812e0 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -78,7 +78,9 @@ TEST_PROGS := test_kmod.sh \
>   	test_xsk_drv_nopoll.sh \
>   	test_xsk_drv_poll.sh \
>   	test_xsk_skb_teardown.sh \
> -	test_xsk_drv_teardown.sh
> +	test_xsk_drv_teardown.sh \
> +	test_xsk_skb_bidirectional.sh \
> +	test_xsk_drv_bidirectional.sh
>   
>   TEST_PROGS_EXTENDED := with_addr.sh \
>   	with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> new file mode 100755
> index 000000000000..d3a7e2934d83
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/test_xsk_drv_bidirectional.sh
> @@ -0,0 +1,23 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright(c) 2020 Intel Corporation.
> +
> +# See test_xsk_prerequisites.sh for detailed information on tests
> +
> +. xsk_prereqs.sh
> +. xsk_env.sh
> +
> +TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
> +
> +vethXDPnative ${VETH0} ${VETH1} ${NS1}
> +
> +params=("-N" "-B")
> +execxdpxceiver params
> +
> +retval=$?
> +test_status $retval "${TEST_NAME}"
> +
> +# Must be called in the last test to execute
> +cleanup_exit ${VETH0} ${VETH1} ${NS1}

This also makes hard to run tests as users will not know this unless 
they are familiar with the details of the tests.

How about you have another scripts test_xsk.sh which includes all these 
individual tests and pull the above cleanup_exit into test_xsk.sh?
User just need to run test_xsk.sh will be able to run all tests you
implemented here.

> +
> +test_exit $retval 0
> diff --git a/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh b/tools/testing/selftests/bpf/test_xsk_drv_teardown.sh
[...]

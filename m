Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7204048E19B
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 01:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238448AbiANAhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 19:37:47 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10258 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235673AbiANAhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 19:37:46 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20DN6LhY031180;
        Thu, 13 Jan 2022 16:37:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=H53jmpEZI0OxlGguPGXYY+ual2aPQkZQPKnpTiWdqQ4=;
 b=KgnwBPaeFWdWC7rJ6QrjwWWniCF3qHue8mBVko/C0BfUNYM9sQRaTsiADDieWz0a57XA
 r7oVEab7/j7xjaazsRNNxNbz/SgmAx/mj7GMXPBV3FMu+WutC89xK6YQXuUI+pFX54aA
 etGQ1ZVVAwYGBv6mTsBZnIq7d9J8Mbfpz4s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3djaprxer5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 13 Jan 2022 16:37:45 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 16:37:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVXCR1e/Gb0JqlHS64zeXPVkdmcNN7qQ9TAxtiJRyJGELrEqd7rVkCUMk7yGxjvztDeevabjfovAFe4jfeCcfaI+z22xKU9BPw982N3SInVb/d9XlBlkjNotqKkaApOH4I4sQ/txEvPj/NWUN7JWfaoZpHqEVQCc240CaVX2EdY4OSaoSg+37i2nPUdg0HeDc052QeUflFHktSXqAHOgokV2IBsxyheSPyxAHFLsCFtmze+67ZUUi4CuknUh8kF0sI6jSEZR0VfH9xGe0hRAspWZ/5DTd7Wue2O47Wpxu5XvaRdCi0priOJNpTdh1rzdWrrVrsGm6VMHAi9dQ57JqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H53jmpEZI0OxlGguPGXYY+ual2aPQkZQPKnpTiWdqQ4=;
 b=M/xozu7DfNKPVZQV8+uZXvSZMkPMp5zvl+pzEt6nE5cqUvvZnx4KYeKB34a3m7cgOdUGUkC9EamYM1uMnw1sotimJz4cgTuU6f2Wt5IFMDbI1H5SqgTPDLP3khxijrS6kFKYPdyAREIJBMUqjq0nZgUFM+jQ+h8Doocz/HG79EU0/CGOo0lgyPf8t+ESP0/4d2DiaRXqH7W9cI9+1a+5nuKTd2Hcj2f4szP4tLXxAsX0b+RRYbfOnwokBB+vtiN4SFYMqa6vnXj4Uoc19RXGfjDF83Kh3Po+7Rb7zbHz3mVye6T4odNpT/xxHi5ke4DeYl3R2q+kSQS3c5cqdQ+C0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH2PR15MB4294.namprd15.prod.outlook.com (2603:10b6:610:2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Fri, 14 Jan
 2022 00:37:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4867.012; Fri, 14 Jan 2022
 00:37:37 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "davidcomponentone@gmail.com" <davidcomponentone@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yang Guang <yang.guang5@zte.com.cn>,
        "Zeal Robot" <zealci@zte.com.cn>
Subject: Re: [PATCH] libbpf: remove unneeded conversion to bool
Thread-Topic: [PATCH] libbpf: remove unneeded conversion to bool
Thread-Index: AQHYCNruv6K1qocsPE+7URuTztx2EaxhrCWA
Date:   Fri, 14 Jan 2022 00:37:37 +0000
Message-ID: <229F1668-2FE9-4B09-8314-DFB13B3D0A12@fb.com>
References: <2010e0898586ad83321e8d84181789123e2fe4e4.1642062557.git.davidcomponentone@gmail.com>
In-Reply-To: <2010e0898586ad83321e8d84181789123e2fe4e4.1642062557.git.davidcomponentone@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c350c7b3-a2fc-4b5a-560a-08d9d6f6108a
x-ms-traffictypediagnostic: CH2PR15MB4294:EE_
x-microsoft-antispam-prvs: <CH2PR15MB42945163767054092403A3AEB3549@CH2PR15MB4294.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g9CKIH84CgAyMXoep7RZlTuQvefYRe0qp4czFCRacKF0HeHP6qeVGrMRrZ0EFNgc5qi1Ox1KmYPz7mAg7P+XmBjmzOxmA3Kn8yQf5jDxlQDTTdYkdoNnrq2lDNxW+76kCVEnhCxQ0ikP+1ARNv8d7qh/2/CMp6wHFn7bVRJGJq3QedfGeUzHrjO5bQ8nITWJxlO7JRqbaPpZPkG5Pxv+lsKhb+/vdoewxkObSHfryzvTUfnCaPXYARwx0Hk2prxJAbaaIG1PB2kHRNc7rrobDMoB6/jGZrN+fo8lFNB0ZNsMzmJS5MBORpEDaHZwRKVdNxxwdm+t1bwIwVW6+Haqzq9TIieclu4zgNpIKc9pJXY0PvTbPOJABWkG0VrAjwUKwmFGQfpjDZF8ZA+Hlm8XidPY0bo7w8iqV4H2JoXmO5j8CTuT+11/ifOiZl/+fgDd0IGPNujE2wCAnOSQOBQMPgxJCF77PScWtazW04lo/z+sU8TAg8zLjZiMSNFE+FvZJogmho2ZGX79Yk87CQM7BDIyfZAPToefLnWrfvOq3HDnK8efkzn5Vf9tvfSWPvbrVhKN9qOTvskEvl5LI2Zun+xM/qh+3Hh+Uq5fh01uk72sdSFsfSTYu2t7sMHA8MSoo2wUneK0ByJ5zab/dgxMURl+xTcXx7q2TbjofxElJa0qf+Jitoo6dHeTqCpGLK787qjaL3F4+pQFjX3aYlFLV6h24Y1+ve1TrOUl6NUAp6CrCdD/5fOvOVkKlo1Rt/tn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6916009)(71200400001)(54906003)(316002)(6512007)(38100700002)(122000001)(33656002)(186003)(38070700005)(5660300002)(66946007)(7416002)(6486002)(66446008)(36756003)(86362001)(83380400001)(76116006)(8936002)(6506007)(66476007)(64756008)(4326008)(66556008)(53546011)(508600001)(91956017)(8676002)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Cd5+J3GY30/NGaJcpbnzBXk4iR+Iz+J7/DkwAX4FAJXUAb1KPq/8QqGW9jQN?=
 =?us-ascii?Q?CRyiAS+vs+GPWcLEklEap6x6Sljr0xIFkW6XRn29846ESuHlGbqpEey0HyVI?=
 =?us-ascii?Q?9mDv+92MwXFEXdD2+zwg7Y+pub3kNzeuM/8ZHGaZ8RLio1vX6zxbnZA60nEo?=
 =?us-ascii?Q?qQYSLLf3JrkxBDUhnbMRqUOxk7oRkneQIUWDciMdQmaH0/+YDhLTOiUhapXG?=
 =?us-ascii?Q?Fwj/AsZ2QAbCDph2n1qfr9OmabIpXHC3Ht5wPWyTQk5xEjVGlJXEmG89W8N3?=
 =?us-ascii?Q?PCAeVMqhhg3hfQ270rJrDX04c3DjHQfYLKd8urHRmTkMo4yPeM8jpkg6jaNF?=
 =?us-ascii?Q?Bf7QE7tHZW0KGL/U71DI6SaP7CwY0/s7X3qtZ1sJsmdCfqRM6wmBalAWMdQC?=
 =?us-ascii?Q?pIPapZyotYxIHzvYIz0IpaDMHsMeCdDfXJDSDzI4Q5MqgObJIhr9Wgxeot+l?=
 =?us-ascii?Q?ziuRcl2TST5ARVknuNmn11Y02jEEoWrFbLS/RUoKh4j1qLhIlonNjclH6P4k?=
 =?us-ascii?Q?UUdDHqDIUMqaYk8VABceTqSQIV9+cROQrN9JHEIou2wnimBeNHcC5XJdV7xs?=
 =?us-ascii?Q?aFKEYMs4BK/B79ivCatPFRwZMfl9hNWSM5P8umJs4HDK1Wa+GwuCxDj8OUYq?=
 =?us-ascii?Q?YOqpPIWw1m6xTlQgPDa6YoqYg5YjFiKNCuizkuBmfxk8a2PZNcem8liNjKZl?=
 =?us-ascii?Q?+6EvoJtn3OQ+79xZKUumNUvGSxx79l1cnsB0Ms2y4QhH7GAm1cdJpqaqwzao?=
 =?us-ascii?Q?WSsiV560q+TiZgbj9mkviBiwhtrsMezYmeRPbeOUIFLxzcoxCimFKurRcjYm?=
 =?us-ascii?Q?BDYzumzvCDUvmSAn0gBH+zPoxZk83zy7xnuDmKSBSgJ6YwGBFHOo7hL7mqJG?=
 =?us-ascii?Q?nUN7xd2tQlFrHnWMOKn6Rfi/Hj6JYloKAs6tkV/4iT/NPjhe/46Xjy5pbkSE?=
 =?us-ascii?Q?j6uGl4nIpiy/Mq1WrfjtivH2aNKRfbF7+kAFKc0/NbvZ9zXUhWBQMT26AM38?=
 =?us-ascii?Q?UpUzvPnwKBeXHQEorcqIfCreAI0pz6+bBdNYDNbAij6cdqvdN+I1ll2aU3Hp?=
 =?us-ascii?Q?WM3pAjQkEqWu5w7pMz2nKe9/ioSGmiJRh38+d3Gg/j0tLBrfbgs7S9qZ09Qw?=
 =?us-ascii?Q?DoWcsqjFtwBzfN4+rOufLIuijgLijiZehY2ZgsUjh1W9ZrvcrueYwmgkp/23?=
 =?us-ascii?Q?kWGJSrVMDy3twW+lkNZB+lRmfHvNCyB4SvjpV2YiOgEs7z2KK0H2Sz4A49bf?=
 =?us-ascii?Q?Ucs5PVyXljA4EU7VX8PDbmiRwRJzubiqXLbtR/zUSXRqIB0g0MNjqYN73a8M?=
 =?us-ascii?Q?CyHZTZo8K6qCKv31DfZvWE36zuQH/Od6dlasnFqEVwwru7oVEWJDO0OhYKIA?=
 =?us-ascii?Q?mgvwFU/DXsRZVecXQ17/6cE4fhwO79ofz+wyxhW603mdZpTTABONecCbaHeP?=
 =?us-ascii?Q?Ik+lbFh2QujeDKv0ONSfbToSBRB1JBWVm6vICGhhcKyEffF70b5FHSIjxSop?=
 =?us-ascii?Q?IRgcpC+NMGgw+KZWTK7CTSLAKrc+Q40YaSeCaHMb9kF1OkaFG6eH2KVyv6nA?=
 =?us-ascii?Q?sFqRPPotLmASi2FCGCAA4YmJZne9Ey9h05+FVtJBIkaEhQu2MeedL4MsHaz/?=
 =?us-ascii?Q?fx3Kk5CWRMdtQZYVmNmKJ9VjZoWRYgqm1tnnnaxkEidi1X6mtXPZVV2ZblJQ?=
 =?us-ascii?Q?SyLxng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B735A5D4EC951499BE530A717C08C91@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c350c7b3-a2fc-4b5a-560a-08d9d6f6108a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2022 00:37:37.6654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RIxRy1V0m4IsEF6kbCyRbHR9jyh0cu/mcGC6cot3tglnB8Kl9T3RkDcBBELq1rmSQtmPBLwy45FzrwUdvb92jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4294
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xkSxqNaYilgBq8bpkOJySqiNCWil62rw
X-Proofpoint-GUID: xkSxqNaYilgBq8bpkOJySqiNCWil62rw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-13_10,2022-01-13_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 suspectscore=0 mlxlogscore=868 spamscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0 clxscore=1015
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 13, 2022, at 4:07 PM, davidcomponentone@gmail.com wrote:
> 
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> The coccinelle report
> ./tools/lib/bpf/libbpf.c:1653:43-48:
> WARNING: conversion to bool not needed here
> 
> Relational and logical operators evaluate to bool,
> explicit conversion is overly verbose and unneeded.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>

I think this change has been NACK'ed multiple times. 

I guess it is a good idea NOT to send it again. 

Thanks,
Song

> ---
> tools/lib/bpf/libbpf.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 7f10dd501a52..f87787608795 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1650,7 +1650,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> 				ext->name, value);
> 			return -EINVAL;
> 		}
> -		*(bool *)ext_val = value == 'y' ? true : false;
> +		*(bool *)ext_val = value == 'y';
> 		break;
> 	case KCFG_TRISTATE:
> 		if (value == 'y')
> -- 
> 2.30.2
> 


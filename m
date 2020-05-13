Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24D1D0574
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 05:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgEMDUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 23:20:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59518 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725898AbgEMDUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 23:20:16 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04D3IxJY010290;
        Tue, 12 May 2020 20:20:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Y0zs+hxwbr/C/PL1qdz1qBNXApRyma5/e29AE4zsHkY=;
 b=m0C2CRnuvYqL7tklLGSA0E/y4k05w2ZnIvu2/ila2K/dVeGC+rSx+CasWoFIVxrGH2LA
 KdFhLTWVu8gJtj0EdIizwplCkS+SvSFNMjrAvvBp4YuxPOJSWzhcbdLZZADDM828eJG8
 uF12oxlWWkbctk61Q6gacDTSbISKlfs+o0Q= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x22e46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 20:20:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 20:20:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gae5EylJrtBWcMx//krSmo/ueFUp79jjEsoUgdB5Sh2aJ/qSejT1426EMj/MsarVhkcGuFzFOH4SfPCoQnP5HA9Et0htogMJSLWa3ye4AsB/Bkgkbc0twmwsSrfnVZf/XBOHuPqstDSiruGiLMtd1olLMPIxEaVUNhqfQVrdmfGK/+nIHzg5F2OghP/1EqNXrd4LIlQkOak8m/jNeO3Iu9SPoSPSc14kzbRUvBhV70nZ737JDOmSWeGIFthMNRBknGZIh1DjCU/hhlRknHinzqTeVF7E9zKnbCnj+FQhNXU5rzrd58ePlkOThf0rMwdjls9jHo2+zAe7gfIUI1b5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0zs+hxwbr/C/PL1qdz1qBNXApRyma5/e29AE4zsHkY=;
 b=Qw0AM3Ywsvirq1kDv6bhW2Kk3Op3pe5kbvHxD/+V0qb5Ww1hJensUJL+jPQUJ8Kh/aWTA6awm2s996ZwrPkJyrGIkCR14R+Bo5X54MmpLSRCZJn7Rls0vceQuc/slJi2jhvcBtuY1xRBJCSFvSAq6kSQ+UJPFWM4Oi6q5OG17bc5ulxVV8pYWbOdzoU2ZpDf8aGEZOWwKnN7JKk8KmcQLopFguTAM5CBkt6tIX6w68e13es6ILb5epiYwCzh9dLDDIQCcHj2kkageaHIOwJaoPCfnt9lujfqLRA4AOiIDenOqHn2lVtAGAH7WQpUbFQdAf1FDINwDRB4SDH1U/zgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0zs+hxwbr/C/PL1qdz1qBNXApRyma5/e29AE4zsHkY=;
 b=YYCtxMZ0rwU602x9Z9VRvK/o+zqyQt1WTmsEX6yY3iMRuaN8Xgmz5k8kpMbKUL+5Y8yR038mTmXlih4tUbHlQS2GXGGiXeS5uElxm6OFXIwMc7YRL5aUiV544P6TGkWfv78jmw0rF2JIb833SRPgQNHfXIjeR8Bu+DjisNPAavE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2742.namprd15.prod.outlook.com (2603:10b6:a03:158::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Wed, 13 May
 2020 03:19:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 03:19:59 +0000
Subject: Re: [PATCH bpf] bpf: fix bug in mmap() implementation for BPF array
 map
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200512235925.3817805-1-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <832dc9d7-2a38-9728-a845-2f7f7e34bb74@fb.com>
Date:   Tue, 12 May 2020 20:19:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512235925.3817805-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:a03:54::17) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:5464) by BYAPR02CA0040.namprd02.prod.outlook.com (2603:10b6:a03:54::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 03:19:59 +0000
X-Originating-IP: [2620:10d:c090:400::5:5464]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3460ea22-8d90-4c4c-b8ed-08d7f6ec84af
X-MS-TrafficTypeDiagnostic: BYAPR15MB2742:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB274290558140F93B7BC8FB35D3BF0@BYAPR15MB2742.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k0XsJ0bJ1I4i0KFFyjqBlGnx812IyirNdI+IeGf47EjyzsrPzv4a5R/q0FK3MquaEcFAW3YFMII+EV7SzTM1Rk9hzKbYe0yJLIUPczJSziVRauvllUpR7xJjVJPAwa8o2GvYgYPw6dp8ChuaJurFLx5ZhYCwhIylFs3MY/p351mXcDAl/L7sCUCh5l51E4nogCepVzwCTWFG41aLAEhPhTNvK04/J4BUZgLONlive/3xuTwmCy4A+Hs5n+zbN9u2yqkzwPev3WFTQYsW/h6dSTw6E0ps2tHCL7CxX2uN7A0/IQ6TE170KVVt5ehsxS0Hv+d7IRWI264gziipRYiItxgW+SvLlFVanTX/YGlwGWZngywTk7q/HyxqqpQaNJozH5UeLbS8D10iyjTlHTbdLU1PEyTZZMQkXxkmJmPokeTQrKp4jahvD5R6ouQ2OA6Gs1PXc8pdSmV1Vau0sMRq5z6TBZ3lcDssf2X+bKW/tOp9AA6ha7v+g097I8VYxsp5RJbgxQcUIK0w38Cf87MirLKZOhDFCAFpUCEIN+kNieRcBIOJc/qS1xzNC33TNxVA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(33430700001)(66476007)(31696002)(8936002)(4326008)(4744005)(478600001)(66946007)(66556008)(5660300002)(31686004)(36756003)(33440700001)(6486002)(52116002)(316002)(2616005)(6512007)(86362001)(186003)(53546011)(6506007)(8676002)(2906002)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vyyoUVtjUmuLgzzepY8IMON27bRchTjJW6lpChf48wf1njj8GelQNF9cy4pgIcYeoqY2vTkF+62pU0HUmVpU24jsSEyg/yWnuHxB7b3+GkgUfK705ZmJSOPsOK716STAHSlACPOhDpdOQ6pT0dq5aIhKm5ULBYXtoLD11G1nvNzd5W4RxhYgXPOVhTzlFMpMvV3db50QEFOeVjbY/2uyDCRo5KJPYI3HzU/RB8oljMtBGPO1/rHIdeHECJVeuN+Cgd9XdmkxTyvbay26gHoC+ZUxz/D0An1RLPJZrnxv1EKOV5CPVA8W6pmUL/5M002LyQxWmFD8b6hn1910WKvpsdlgSRTGB6mQjMCX3pkbdN8kxSjRQNLDdAArO+UMySD2uXwkSurByQlT1p9T2H4iY77VU3fC8ZCB0atpvxfSbtfZOTJIHpauX6+82liOF+fOj04GZclHh8Q1lJLxJsM+To4wMIcmTxB0VXfe3Wk7UdylxGL8uGnW3OGAYIdDGEgFU74cPhDQbYgVfCyanbov1w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3460ea22-8d90-4c4c-b8ed-08d7f6ec84af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 03:19:59.6117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WdsWGX+jyMM7HYDdtTOsqOS6WQcb9V68eiqzrKo1OSgZmTNhC3mvhYgBveVrDyjj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2742
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_08:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=991 cotscore=-2147483648
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130029
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 4:59 PM, Andrii Nakryiko wrote:
> mmap() subsystem allows user-space application to memory-map region with
> initial page offset. This wasn't taken into account in initial implementation
> of BPF array memory-mapping. This would result in wrong pages, not taking into
> account requested page shift, being memory-mmaped into user-space. This patch
> fixes this gap and adds a test for such scenario.
> 
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>

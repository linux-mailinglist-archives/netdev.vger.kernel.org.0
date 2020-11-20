Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1D82BBA29
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgKTX17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:27:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23750 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726426AbgKTX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:27:58 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKNE9J5009675;
        Fri, 20 Nov 2020 15:27:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=WRswQUy4cnChSCx6cRweMPAEQuEeitkOw5QGGE9f+A4=;
 b=Vhw1Tl7Pu+E/KOkEOs3+W4vQiZscZqyc95aabEnsH2O7i+8ZfunvZIYNElOz5+qb685U
 VbspE5RII4y9T+AcF+nxWxJsSMdhUIlARqh0eO2MDkFr+3z/qqtm3aA6qlEbrgDlFSRe
 9Lu5/6KKab1ZE2hKQ5OKI0VjrQ6ueg7kRu8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34xemp389v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 15:27:45 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 15:27:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iHUz3nwtDAbEv4Qej9sjD1esSJEeT5n2ECOahlpoZnrdU3jmtCiSr0gIRLYTBDNwHJTCO61U7Yxw7lgz3e3tzzsXg5VdmdJg/Jn2KXs1hkgQQ4pM2Y4+1LFV9J1N3aYe3+RSzHZ8CVvIaXj189dpmfJAlRL0PY7g1rzRYH4XpCf+ullBlHMiMrSvatm5XgeGIe2TdE/s51Q38XhuS2KZuc1Uu0Dqtj6nCy1D/vh0NheUAuqpHw6pY+WSTh/P8AgFeOE4xmDTJ00ctKPiRbeeNFFSWNK1a9Fb8maZZ7hfAerg3fm2muSmVWDiMQGFG/xRgHPTWw5D4LUcmvvo4jQE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRswQUy4cnChSCx6cRweMPAEQuEeitkOw5QGGE9f+A4=;
 b=PkIxDO8fvE02hbi9BtBVa5jnuGU8rSQNKQSuLHUdEJLmW7mn0Z0rNrSabLAoa/DPYkRcH+Ny5Ol8tCQXYwyL4i5pGAcjnzpHbHc8xhWcWJbEDinjuDcOyesJUn0stTg5a5V5jqT+lIxXnEPUt+oFHj5RS7Dmo1GNMb4zmz1FHj9Zf1FlPgWLjbfKspG+jDlpRazLGw+uYXHihaImpLdNHG7LbHzTbHkzgSCdAxiV7LCpiFcWhIIAuyMvrmiyKfjdF06k+6P3qZvEN8y7zTg3ssuqYJsH15CYyCqObT9zn2UIBeeNDGbEbpH5o+C91CDWCb/lX/5H6pGpDAf2+QHB7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRswQUy4cnChSCx6cRweMPAEQuEeitkOw5QGGE9f+A4=;
 b=YkiI771PORaRROFrixgSN0cZDt8VQwxn2LV3gT0mpS2EOGw4QfX8xQXLSeYKXoVbQRkKeeaisKOdXLvPutUIuYWJdtfj7DCiiF7S4ulq14CKgZCePGWcPw62MWgEdJ0n6bgvZ4IG/pUIwMjOBjHKcGBOQuuRYz9ODPiiPOOISd0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3617.namprd15.prod.outlook.com (2603:10b6:a03:1fc::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 23:27:41 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.034; Fri, 20 Nov 2020
 23:27:41 +0000
Date:   Fri, 20 Nov 2020 15:27:34 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 6/6] selftests/bpf: add CO-RE relocs selftest
 relying on kernel module BTF
Message-ID: <20201120232734.pvb7du6jdol6jd4i@kafai-mbp.dhcp.thefacebook.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-7-andrii@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232244.2776720-7-andrii@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:300:12b::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR14CA0027.namprd14.prod.outlook.com (2603:10b6:300:12b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 23:27:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba4adee9-9900-4b2f-2f38-08d88dabdfe7
X-MS-TrafficTypeDiagnostic: BY5PR15MB3617:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36174744B71B3D11A531ABCBD5FF0@BY5PR15MB3617.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 463PmgW8X5w40z8/Rf74SY/CGKOy9xjz2ZtFhKF1nStWQj/RmJG2rQ4ToP7smDlwGUmo5zYNNck40DCNVJf7840Zsdr9ZGTnUU0bO9GBEhHwjf5KYKXPFANSoGr2ZO6knLoyFMBpOw7pjlWPFLMF6dUnTGm8HSNRBKR2rBoDCzDBXPR5OHCqBx64gqKzUDu9242veW/KCOUmaXrFDMqFiGh1MTac8kbhx8g7RqbRkuPTT/kx+d1AUVIqLeT3nPmvxBsoijCzB71SFtFL6QeZXBqj7MpbdVQFRXcKGViALmqb1Jc+qGpFWw4EjiFWkqyS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(366004)(396003)(86362001)(9686003)(6666004)(5660300002)(55016002)(6916009)(4326008)(1076003)(8676002)(8936002)(66476007)(478600001)(66556008)(66946007)(2906002)(16526019)(6506007)(316002)(558084003)(186003)(52116002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: FQrnNnklEVSVmcI54WKLMl+1cBlsM1O/rl2BK8sMvTLKPzzmeCiEUHCbWUi7FYxO+9kzMLPfK648g0BkKxB+PHz6Wv8/qL+P/OfByPpdtIhN12tQijMQvT8aDOLz4zHdnMRQx361WTr46UjrmCWzuGzRKFih64D9iYTn+NQUypsZvK2D5BVxqZlpB3kO514q5xRhUv9PM/uhyjRUpgi42m8LvifAQKBcmYho8EBjplCRSccYuuYxpmWyD2+v7n27xy4EtmXMdZdMi/hfgwhdTUchV8LlKX949TxJHweOWScSOCTNw4+wCnTLuJWXRxg6KiuM5nr7tBYgPx27Kd31OiGIO8GeJ+955b2xb2bL33siUQtcNkkJ2bYz8lw8IJ9qJhQdYNDTpftVmk0rNe/OiTDPVAIq/ec+ekedcxOPEHdDNe7LWRZXJXKtVp78/1iU9TR02hlu+uK3T+iUmwjEnarVL2ZnSNDZyxBTsIg3khXlalc8wlMWRDCFTsMl+w7S8YfoQstOJlDeGv/uVDX2XJz/dT21Hr2VbqA7/WBnSuknhypyXaYWQbL5tMZYAlmfgIMjbR1p9bH9RJILEwkzeXpEHr4HGJzg3SIBb1fr4Nn1VZ8pjOc14JNL9/AhGCCTVwYP7IP4nHh+BnPNWaKne4Rjb2zTUmwn5LysF+vu/Eux1z50wHkK92giFKI1XUSqgq3snq1GEv/PlFHfiJov0bUrYRBORnR9P3b/O19c2mRfDPJN8O4+PymIHIDtV5RjTUL0kYDhc3N+ohfJGYDSMLXBjIqNThaAB1H3cwpnwMCah6EvmnC7pdQP3smllhWWUPFZa0VUN3ErLEZGI4DiggnVsyjGqxlPy1OBC0n7iUdzJLFSJyyYBbDgxfQeLAorohd5MbRHTRXf1PWrR71M8+qIFZHTaVzuNYlOV3xPguVLSMEe/XSiRbzNoNC03frd
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4adee9-9900-4b2f-2f38-08d88dabdfe7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 23:27:40.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ui9Gnvfi4jm/ba7aagDhXZ/BXtR4BZi4wLGIGf0tlYH+mAH932ISE2Lo5z4V1716
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3617
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=1
 adultscore=0 impostorscore=0 clxscore=1015 mlxlogscore=730 spamscore=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 03:22:44PM -0800, Andrii Nakryiko wrote:
> Add a self-tests validating libbpf is able to perform CO-RE relocations
> against the type defined in kernel module BTF.
Acked-by: Martin KaFai Lau <kafai@fb.com>

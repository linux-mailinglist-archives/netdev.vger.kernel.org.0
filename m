Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED34714F57C
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 01:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgBAAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 19:46:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726264AbgBAAqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 19:46:39 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0110a1uJ001460;
        Fri, 31 Jan 2020 16:46:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PDQ2jugJZOD58GFFqnzvj9nK2wgPANQFRIN1gRTMru0=;
 b=hzET+QYPo0k0PbKjBR/oRfIer9v2W2ZqViq/gpGFImXKdW/4c7cDXxhfdwPHhXLvU0MG
 cP+DOhS8OKPCiV1a8pWcIGbVSyEzLJY1ltuFSUTgEkrAJxlqdif7EcNwwLncaNaL/PKW
 5ihX8J+fyWaCq8ie6UdRnCS6owN9QR8O9UA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xvn09k080-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jan 2020 16:46:25 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 31 Jan 2020 16:46:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iv9Izxe2YlZlM3r8LVhto8eKtkkMWHOUJGTpGVW0nA4MECSfxy2pmB2BtLLpTtMZSPzV2nQG50Dbbhsgsvaq5ox5fsm5ZypmdyYd3WT2pXUHY759y6A7s0rh2G1vtZ1fAYSDr/qxSw5DqJ/j/MCi/5lZpFKxh3+ks5xb8QnsYvheQTbUXrwxka1Gub/T+jLVI91QjKkyC3zGPUeoV0OnmynoXfWSIOQ4cj/lMCONUgf+3KyMXblmb7OsBiER/uJ7KBXpBsmJf/uPSMkbS0XQsLlECVGfOSdQ/azh4XY3o2eDpNolyHPl4/CzTiC3ZJ+lg2g9FpxtqYFowGPDzyRqxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDQ2jugJZOD58GFFqnzvj9nK2wgPANQFRIN1gRTMru0=;
 b=W1AWBFxi+IyKOrP/ZoAHHj+pZqHglApXCMSHX8STu6tAs/OX5bedVFcORJXhlqKop9kyJ7FEaAHfe91DdU7YrlLJpZ8HDLeorqxXdxIMaBbv4CYkI3OvhSRMQAqrczw8TGUapr/fNpXXcig3No/k4Jxo2AQQHhcl8qt3joqJd0oYQnCyuCPFrqPx1iiNQlGaEZEvKTmYAAKae+MbS10ptOaLSJ3UJva7cYeETm658Zndi6rBlKD58ynHYT2/ZoxNgy9ftSzBQaSNQaSoDUCt3GtBIhFvRDmxFwbOtPpFovxqTB+/BnrTKxAqxLpMMz8qKfBkCbF4KKz1M2bUdMLHnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDQ2jugJZOD58GFFqnzvj9nK2wgPANQFRIN1gRTMru0=;
 b=Vlk9Msezf+abra1gNWP6SexHn/548gKt0jdasdZNaGaasiEQ8CpcKDIfH77Z2w2hCM0XjsC6wMOKjpXFOhHyunfZNHVQNRT8uai9OK1nAHkKQf+TG4dHxfiUaddCrcsW60vx73ZFkYLiaWq6sLF6d/vYTgycmvAC7H5yM4ONXeo=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2251.namprd15.prod.outlook.com (20.176.69.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Sat, 1 Feb 2020 00:46:23 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2686.030; Sat, 1 Feb 2020
 00:46:23 +0000
Subject: Re: [PATCH bpf] bpf: Fix modifier skipping logic
To:     Alexei Starovoitov <ast@kernel.org>, <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
References: <20200201000314.261392-1-ast@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <59c9c081-776c-6f11-cbb2-484edc440b3d@fb.com>
Date:   Fri, 31 Jan 2020 16:46:19 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
In-Reply-To: <20200201000314.261392-1-ast@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:102:2::34) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::3:41c5) by CO2PR05CA0066.namprd05.prod.outlook.com (2603:10b6:102:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.15 via Frontend Transport; Sat, 1 Feb 2020 00:46:22 +0000
X-Originating-IP: [2620:10d:c090:200::3:41c5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fefbd12-b8df-44a9-d9cd-08d7a6b028fd
X-MS-TrafficTypeDiagnostic: DM6PR15MB2251:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB225163BAB3F77714980C507ED3060@DM6PR15MB2251.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-Forefront-PRVS: 03008837BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(39860400002)(376002)(396003)(199004)(189003)(478600001)(4326008)(52116002)(6512007)(2616005)(4744005)(6666004)(36756003)(53546011)(6506007)(8676002)(8936002)(31686004)(81166006)(66476007)(66556008)(81156014)(66946007)(2906002)(5660300002)(86362001)(316002)(31696002)(16526019)(6486002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2251;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mL5EvEX2GEsG55FlG3UDe54u/xfyQVaEFgY/6D4d1agG6pzPhPCXBcKsmBCJrXx5i+5svD0kp7iAQDi3wA7UhSARpRNrWPsCbh7ml5I/Kt75OI0dw766ZyHQRcgw+8MucxFL2m2LMF5WDraMlkxN2ZPfUfnTFU03Jj9blDowNOCFmd3Ij7GKr9gv95jfPDr2C3cU+RUlPHjl4r0voFCW05FUOwGaDOKbio1QbWkmSLUmeFdY5FHMY6l6N1b5fABow/qgkW1ssYwiQw1BL1ac6rav533GGrdMd4z7m5pqO3UENbC+uumUuVNApqAdLUHxiXR+B/F8LAYdUmtsCcIsFiBkiWMuqxv85eAr3xxRKLPGCvkW6PhDBMMURUdozL1BjZ27nUH54D8b8LPT2VR1dbMtU06WErNZ3m6a1LtaaHwONoAfeddRPgV+5MOjd6Zs
X-MS-Exchange-AntiSpam-MessageData: mSQ+83gLayZrl1TM5l1FCZPRS1/SVLNNy6hk7TI5rEjyBhqASqxo/2u+KAzMYmfG3eOuiYkOIMXkBsCMgFkSSixBAxyTZXyG8qnDwKj5WCR7nmdkYp1oWdciNsvLTYWCCBWPqtZeEMBxqTFdOfdQnAJrwbA1nrLlpD8LEYt72SYJt3Dltj0SmXg5jZrJYVES
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fefbd12-b8df-44a9-d9cd-08d7a6b028fd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2020 00:46:23.0393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xchUpoWtKcW4bEtMZnPWg7SMXod5KUGcu0RHwzV5YCm6EVE+lThIC5FEqMUif51
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2251
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_07:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002010001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/31/20 4:03 PM, Alexei Starovoitov wrote:
> Fix the way modifiers are skipped while walking pointers. Otherwise second
> level dereferences of 'const struct foo *' will be rejected by the verifier.
> 
> Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>

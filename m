Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA924CDED
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHUGXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:23:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50860 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725268AbgHUGXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:23:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07L6Kg23029207;
        Thu, 20 Aug 2020 23:23:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=oJqD6h1uGsMt/DPXUc+VepazS7W0mXU0VAxhK054uM0=;
 b=qK4U174uEdbz38ckDFm6grBpK1UPNKlTRDpWkdnkJYAg8uLg7pxyeWbYdjvC9qlCtz7P
 vQrg3dgJq6b+jrjJg2w1F9zJBRKyxMlHKGuZPcIw+a03nBQ6V5bIQIDwhqGYHk3gznqy
 RkutFeoRdt6M6qaRJD+VOMGQ59Fa1HYOSn4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 331hcbxsgh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:23:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:23:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjiPe5IWqVbsVHJOa0gaUtqbcx4hhg/LvE5WUcciTWx6MxEPnG1q2L2Jg+jVh2UTpjH1eBG6sOlUIv1sxRE7iIUpo4ThXzNhd957P6XqxXXVPVUzXht+FZToU6OA5dsQMwU4SPhvXG57jEN+7Au69QfTm3ZoHIHN7ETqXw5GwbEVySshgIVCqmzhzQ3gsBJyRF0GxmwKgxgemWBLvdQP+aAcDVOtryV0HCcEtkEAD5DctEPVM997PHmMXn3auq181W3HpsohesIA3BW9Auy2hmOFAd7dQWVapsAxqu6HxNsBsh2DPvdlf+uQKZVjNJGilkVr9zT1WOCnQo6mIeX/Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJqD6h1uGsMt/DPXUc+VepazS7W0mXU0VAxhK054uM0=;
 b=SZmARdhgzawhAxThjUypfWPHhS7fvAc4hJDcXbdpm6L/wYDR3G+m78UsHhKvggEmXTgleeKvd1o9Q309tmrxaXJ4AVXFgdSGUFmkgcV1pl5B+UWkkUAcR9sdmTX14CEAILBhZZL+yJaHjlEM0vl8dPSdOKkSZpI1segYhWQKdKMgWcoRqtAFyqVxhbvTpzFdA0jrSNKB76/e/5VG6CpoePGRfT82tzn11JABgHQ+HAWxuYErRAGEovP7XCus0Mi8MEb28jIckG0Ccm7E+R3bl3YHJK53NFfpzE0Xwh+5twTd7viI0q6hKrF7Q1iheNEu7SRjMSOXITkNnVXaR0WgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJqD6h1uGsMt/DPXUc+VepazS7W0mXU0VAxhK054uM0=;
 b=hFIHmE3usPMrDoA5+T9V+CquEoA3YUHMsD8DdATdfQvtQE86lWTwCGho4bhU42aZJDo9a2QRSenCSM+YiWJT+fCqWhJrwQ+o1EJoBATiTR2QyjJuKPuYtrC3d24dzWTakvQ6hEiOpv4Au0fJ24ZnFQK/dm/8lYGbAh0AOvQb46E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Fri, 21 Aug
 2020 06:23:23 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:23:23 +0000
Subject: Re: [PATCH bpf-next] docs: correct subject prefix and update LLVM
 info
To:     Jianlin Lv <Jianlin.Lv@arm.com>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <Song.Zhu@arm.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20200821052817.46887-1-Jianlin.Lv@arm.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2b3ed0fe-5be3-05a4-4db0-d0039709e488@fb.com>
Date:   Thu, 20 Aug 2020 23:23:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821052817.46887-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR19CA0046.namprd19.prod.outlook.com
 (2603:10b6:208:19b::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR19CA0046.namprd19.prod.outlook.com (2603:10b6:208:19b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Fri, 21 Aug 2020 06:23:21 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26c64768-eb3f-4545-b6f8-08d8459ab492
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2582F091EAB2282A00237BF5D35B0@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39860400002)(31696002)(110011004)(83380400001)(5660300002)(4744005)(6486002)(66946007)(316002)(86362001)(52116002)(36756003)(4326008)(66476007)(53546011)(186003)(2906002)(2616005)(478600001)(956004)(16576012)(15650500001)(31686004)(8676002)(8936002)(6666004)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c64768-eb3f-4545-b6f8-08d8459ab492
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:23:23.1778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B21HfuMXt8PdZ2Y38GE1HNSu6OletOaXU3rBJiH/OuhPZG/RdlYMOAQgzm1CQdwa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 bulkscore=0
 mlxlogscore=627 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 10:28 PM, Jianlin Lv wrote:
> bpf_devel_QA.rst:152 The subject prefix information is not accurate, it
> should be 'PATCH bpf-next v2'
> 
> Also update LLVM version info and add information about
> ‘-DLLVM_TARGETS_TO_BUILD’ to prompt the developer to build the desired
> target.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>

Acked-by: Yonghong Song <yhs@fb.com>

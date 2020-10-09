Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244092880EB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 05:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgJID6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 23:58:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23060 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729223AbgJID6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 23:58:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0993rP5C029318;
        Thu, 8 Oct 2020 20:58:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=1a74CrRJrvSw6ml0PxED4rk+FsHKuRKZZayzj1GYcZE=;
 b=pTWXetMFB0NaM0qOT47vEHoNFh4KMaX+yIIFTCdXQJl7K/y0ov0aqmZYACb3XRWFsKpd
 qzPRxZf+WaUJjZvjo+7GSyY0OL10gHD59aVKfU10j857EGRo8ILIcaICwgY65EE83Wxa
 BSW8o3kKQnJ9yt6NIk55oMz12eCEbiPFnuw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3429jq9nhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 08 Oct 2020 20:58:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 8 Oct 2020 20:58:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZs/iA3y5D63mPO/9yVvQntTPvSi752HzVprGKQSpf72kW9pzjuUJkub7k0D+2ed1OHGWqH+G4OtOzMgBmhFwfedgISUXUiv0xgKYIQ3hfxMjxUrQxZU0agoJDglFjRvtyqPfx478LQYquFGDDZN+mqBXz8h3hhQZdofZttrk6O58gwzwIZgdG9nf92//m7KqRx/nx/5iHZHrN5H5blKdldNSjnriBbxDjA/SXaSxZ+PVKgcouzEaym1asdkxFXF1I9xMxmsNPI5XCtsU2iyMnZCNoGk5+ec80YVEIsk+kjMvYIuqq9a3lTZTHDLF5puhKd1YfMQFv7BJnXkbH2Ylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a74CrRJrvSw6ml0PxED4rk+FsHKuRKZZayzj1GYcZE=;
 b=Vxw8pavLP1aaV2/E/BeuDtPUdNNhmmSn2qbZ3r7eZCj7CHi1yf6GC4sfY7sUpCoPiceksYpGjC2aC5HO7I41pnKw45P5u3C6EuN+HD1nFsgK0omIVO312Y9sZoVQqX0ylrZnRtKX+vMbRD0rNZ4wW42xVpTwt9ptFJIQmkq8oeY0U+sHzbfokVvSpm4Yb/PXv2RaRXkXevC4JiPFFu7cWKcC3wwVEDVDyp6SYIB7WugTKXQahlulNI6Q7b6nGtSQe+FKgci7kFKhipqiG5QhhUM+EGHoU96N/BCt0UMJmI//95/a03UIM5xY1k4f4LYOHPqprDb7F5cRDmYmHn0Ehw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1a74CrRJrvSw6ml0PxED4rk+FsHKuRKZZayzj1GYcZE=;
 b=BiznoqXFK/WsLJp8Zi8PV2TwAluiuFz/skkS9x6v18bMDZtS12WBasoQfbjsYMCZC/62gCZSJTpS63dNO3ACsVdVv+p5VqE0tX9R8qTx6meoRoKN7lGA9Yd0sngSq5eTRL0ahDdwGxPARgTilY0bNmiCVozSpoEIRmhfixTIPVo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.24; Fri, 9 Oct
 2020 03:58:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 03:58:07 +0000
Subject: Re: [PATCH bpf-next 5/6] bpf, selftests: make redirect_neigh test
 more extensible
To:     Daniel Borkmann <daniel@iogearbox.net>, <ast@kernel.org>
CC:     <john.fastabend@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20201008213148.26848-1-daniel@iogearbox.net>
 <20201008213148.26848-6-daniel@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b0444b97-138e-3ba7-d889-8ca2aba4979b@fb.com>
Date:   Thu, 8 Oct 2020 20:58:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201008213148.26848-6-daniel@iogearbox.net>
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:68ff]
X-ClientProxiedBy: CO2PR04CA0201.namprd04.prod.outlook.com
 (2603:10b6:104:5::31) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1844] (2620:10d:c090:400::5:68ff) by CO2PR04CA0201.namprd04.prod.outlook.com (2603:10b6:104:5::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.42 via Frontend Transport; Fri, 9 Oct 2020 03:58:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07623caf-7858-43c8-6f02-08d86c078812
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2245095201F27B5B444F235BD3080@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2TPQwzwLhzp8tz58+kK3tAnoAIfWy/52Gx8exU1Z0nz5kzj7mp7TUFt5j+Li1Caz4BSF/QGov//tSJc9zFsCO+0pM0No45QYcFqrBHWKUwb9HsvCG3ae1aBBcMiagVwEOiewuA7iT/vSbYBAnZnxeuRmxzFCVc3VNQBzLKPT6HHQxdz5fg7pjs6VXnKaCY2cWMup321+zK0ba9p1YTHg3BzO1h+AKEd9/v7849MymE8LTW8OHeZ5EEIX/SNtoOq6h4PvIW6a0+TOm703fgJ5z2OOEtlwACQB8vRD/ugaBNHrOINIFvkkRl6HkrTQV4qTF5QbO+QJsJI4smGj4Wk3mNpANE2yf3TZ52ESsR83RWBri4zABL3Pww98jvgaIS/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(396003)(366004)(66476007)(2616005)(31696002)(478600001)(4744005)(8676002)(31686004)(6486002)(5660300002)(53546011)(2906002)(186003)(16526019)(36756003)(8936002)(66946007)(66556008)(316002)(86362001)(4326008)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a2dE61JKkOZeUEWaukAI6aoXHp9SEOQCCPKD2HVpPz+qoXMbayj0eK5Kq6A3W8dhmodp04G03hrNjVsSi0jBZaMR+uUJ3XZF+gVaUHWykM8Qp2bs1K3W3Z6wopggeEQ/RKuwj/3JlD29VxnpRop5sBrhNEusBKkVI45RzLxbbaNZgk3QFs2lbvh+hxDwRueKthpnGy4suK0dFfuQik9rECC++wIy3VnjK2iENCxpi6ZcNRrECjIaJb2pExIhjowYjDCAVmWaS1DhLIUhSwGKKG+7pgKI9XZ7UcojX78N9/zzZWZkzBxPJw/KvEv+aqjOmmVVaXrSe2ddeFFPvrDh5l1Vic8zclpt+9ym74mgRMvzWMEA0hKKTYiPIIKa5wQbTQe3hcVu/3cWoyq8uZ7OWQfPJ2DVxaC7lcp1SAadAz2DvTo5mH2ijh4ao3jj6XpStWGJHaI3qwsMo9FIjiZQPWZJn+b0WuDrRxUg/oQ+qqX3NC49Tfe7UL2OK39sTKOHmPow0E5H/81UHGC4BoqWAhbvsq/YXybP57Gl7iTibDuJtU/KOwfn4tlDqdMdpYIsvY1jNnGs2WjAESSsQYBkMJlgFwXTphgE7IFslkJ9Xj/9L2MIhQgvjInFtlrmjzOtEiF3bOYSXvxiAmTArTwC3gTLfGgQwE79ZzW60VhR3C/Y9pK+nbkeRavogkwu/LLt
X-MS-Exchange-CrossTenant-Network-Message-Id: 07623caf-7858-43c8-6f02-08d86c078812
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2020 03:58:07.8744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXYjc/v9UEb82fgjFw6jsrr9I38OEsbsvJIRG9ts/GDNohpFtaNAbKgCkOL22B3y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_01:2020-10-09,2020-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010090026
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/20 2:31 PM, Daniel Borkmann wrote:
> Rename into test_tc_redirect.sh and move setup and test code into separate
> functions so they can be reused for newly added tests in here. Also remove
> the crude hack to override ifindex inside the object file via xxd and sed
> and just use a simple map instead. Map given iproute2 does not support BTF
> fully and therefore neither global data at this point.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>

Acked-by: Yonghong Song <yhs@fb.com>

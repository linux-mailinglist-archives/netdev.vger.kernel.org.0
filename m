Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC72311F2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732498AbgG1Sr4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:47:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33926 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729190AbgG1Srz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:47:55 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SIe2v6007217;
        Tue, 28 Jul 2020 11:47:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=l/pTYxEKwE+I/QQ+kMCnGTPuTXQPbQEkj+InPfdyCzY=;
 b=XOQ0I22VTwGju0yyDPecXzdGzULM42/8FtAg0vY7XDET1s6QGiFSIMGIdphtrJ1PIP11
 a78hVK9oc+98dT4yHQQUQISnFEfrzoaaa6VyXr6qx7AuLZgIldRP3IWmPAzMTEG2Oegy
 KSgPUQqzFEUoP7uVNQgAhMsdP22I74ElZ0k= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4edb351-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 11:47:42 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 11:47:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRO87lcJjWPDzDYHysGnGb8CBTVVarArfMhUapbN+AvQC9r7qQVQzZ7KegwSLjKLBxAKHtA2hXx1UQHb3YITknfhmQD/RlDUQZhmH9vw+rrFw7j3MqGpKU6weFHhAm6llpX/cTs4EKBOOKgo7LkRza/CxTJfn29vzdwcwgwyMlta4T0AiNgQdMcV0Ue4RA2S1Zef1zzXfnAZtmhtkLUclRghN5KP99P+ABPJme6jv17SCInWTGP5TGhChnAYJJQHZr0GQbXC6jSSipDkPexsVc5ez7NZftwPWsHTKTAOpzqlAN9mfEJpYiYd7h6TqXzd+hF5y39b1RUS+oCrFqLEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/pTYxEKwE+I/QQ+kMCnGTPuTXQPbQEkj+InPfdyCzY=;
 b=kMJGgirvs/G3bRe4hTeUkAQNCXySTsUZ37u9f3bW5NAvOvHXZU2h3Q7ZLo/YwtMxbhW9bsauQk5IfCtqW2jJeC/HxsKbPnH4RHWj5asWQjLIUcYJhcFid+wQ81uwOTmR3zpax3L1d/fH4xwlU8Bpczu6nLv/LFoonIV/+LXiLyCnVmQ16YgQpHQe32N2nz1LXoRiP//4c2gaed7ywa5YwGtlGRZnhZao76KYXrOYBIeoYVT3NV7cqGPmjTwVItmSra6FucCqOvjSP1tkRkwy4V/G7r47guEVVG12t53u5dvMg6NtPpFWndhmLmGIU4wuUz/prNU385ZvYQdH5ZKJCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/pTYxEKwE+I/QQ+kMCnGTPuTXQPbQEkj+InPfdyCzY=;
 b=C8BueOWJyysb8R9TZWAYO1rsOGAthdFKUD/HsGKVdhF+dPpwTGYVSHvZHhOtYvaLMgYMGd91AOnLUXdmagPsS0p82FqikXrqYwbJz/kLzPsm42np+NEFPIg3bjP8ruoppF9iFHazevBxW3HVMqjNp80wctLck8K7meHiwiUo7ZU=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=fb.com;
Received: from MN2PR15MB3582.namprd15.prod.outlook.com (2603:10b6:208:1b5::23)
 by BLAPR15MB3906.namprd15.prod.outlook.com (2603:10b6:208:27f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Tue, 28 Jul
 2020 18:47:40 +0000
Received: from MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372]) by MN2PR15MB3582.namprd15.prod.outlook.com
 ([fe80::e9ef:ba4c:dd70:b372%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 18:47:40 +0000
From:   "Chris Mason" <clm@fb.com>
To:     Christoph Hellwig <hch@infradead.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH v2 21/21] netgpu/nvidia: add Nvidia plugin for netgpu
Date:   Tue, 28 Jul 2020 14:47:38 -0400
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <6376CA34-BC6F-45DE-9FFD-7E32664C7569@fb.com>
In-Reply-To: <20200728172703.GA5667@infradead.org>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-22-jonathan.lemon@gmail.com>
 <20200728163100.GD4181352@kroah.com>
 <A2C3C5F0-D86F-4D0C-8402-822063D2C6D1@fb.com>
 <20200728172703.GA5667@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0052.namprd02.prod.outlook.com
 (2603:10b6:207:3d::29) To MN2PR15MB3582.namprd15.prod.outlook.com
 (2603:10b6:208:1b5::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [100.109.110.153] (2620:10d:c091:480::1:49e3) by BL0PR02CA0052.namprd02.prod.outlook.com (2603:10b6:207:3d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 18:47:39 +0000
X-Mailer: MailMate (1.13.1r5671)
X-Originating-IP: [2620:10d:c091:480::1:49e3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11bc133d-6e3c-4df0-025e-08d83326b43d
X-MS-TrafficTypeDiagnostic: BLAPR15MB3906:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR15MB3906A368F3E02EA3C4F8AC30D3730@BLAPR15MB3906.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMFO5jyYKPfphmbGw83kPiE3jHTLJM93Z90p5CcO5/IPExig7zeVWj9dAslfno3ltCH0RMMVUmmdGxZeYTt1znyljNdqkdTaJAeco/PTO10yn9x7MgtsZv/hnMxaHGjhevD/LxaBuRmDgrsE0g3OPLK7TAE+0YZj8iyk352seve2Vm//qWbQDZQOoYFKLqQgQZJcdLJ43SVgiIWekEG0IlX+sR4BIxREw9w5N+i4f+pvskroCd3YDsKh0tpO4sheiZ6+eFO3xxnWOMLQQKrcCwvkkqacPD5+PB0pNQIjruUCn5U/RllGC+v71V/XLwYNpN44FoGfrp6Tdltfmlx3bTexO1s+/aqwTSrnNiSlQRx7txVgKvFOdSbkNuOx0nRz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR15MB3582.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(4744005)(52116002)(66946007)(956004)(36756003)(86362001)(53546011)(2906002)(4326008)(316002)(6916009)(6486002)(8936002)(33656002)(66556008)(66476007)(2616005)(5660300002)(16526019)(8676002)(478600001)(54906003)(186003)(78286006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: XDNKYQSa14iCOPyG8p/za4zOVU4op2m4BLRpv9A8WKFnWCXLxKAcUWQDTaXps1bWM7eIR+8P5MtB/D0rPOuSUSvt3fPt/oS9wsxJWnTuGpBgv/TTEB6btSSQ/a+GJxGOoqDxZX0VUAf2MuaiohuqEhaIuWf4apWceK4KwOeMmx0d1lcyfWRigWOr+v/yy3MU5bxhckRPNFCul4Hv+EhURzbZyxgfDyhQMiWcYjB152l+QXw/rrhDdsAZiVV8TbQT5cR4BvTKM6lKUDp26g7b10IgI/GpSHWc969l83tSd6PHk3ZEcJ2xt58H0oJ3Er9cNEAPACkAFo6/v3uboRLt344x90Wl2cW6KmMfMtguxtVfeH2rDhj+CMcPcKZ4M2aCGFoXjuzSWH4jTXNP6yBW/Fzc1h3nbX49wMCDkjaxa8M5uzu9Vk1UY+XV5UEo2HcB/3i7kehRhZ+clkwMFZyLCtZjMqvRdmW73v/ns9Uw9u7zQi9CNRBtO4WN+T7pUSVu2EqsD8FB6jkoCg+aqkCCnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 11bc133d-6e3c-4df0-025e-08d83326b43d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR15MB3582.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 18:47:40.3343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHjkiD9mUK5itWNa45tq4m9/ALSZqzL5BByoTe4M3Gr/eEDWZ+gf1LNjN89AhxcR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR15MB3906
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_15:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=752 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Jul 2020, at 13:27, Christoph Hellwig wrote:

> On Tue, Jul 28, 2020 at 01:18:48PM -0400, Chris Mason wrote:
>>> come after in the future.
>>
>> Jonathan, I think we need to do a better job talking about patches 
>> that are
>> just meant to enable possible users vs patches that we actually hope 
>> the
>> upstream kernel to take.  Obviously code that only supports out of 
>> tree
>> drivers isn???t a good fit for the upstream kernel.  From the point 
>> of view
>> of experimenting with these patches, GPUs benefit a lot from this
>> functionality so I think it does make sense to have the enabling 
>> patches
>> somewhere, just not in this series.
>
> Sorry, but his crap is built only for this use case, and that is what
> really pissed people off as it very much looks intentional.

No, we’ve had workloads asking for better zero copy solutions for 
ages.  The goal is to address both this specialized workload and the 
general case zero copy tx/rx.

-chris

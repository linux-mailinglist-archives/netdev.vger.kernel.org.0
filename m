Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBEC27D45B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 19:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbgI2RYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 13:24:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727650AbgI2RYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 13:24:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08THK1PK018911;
        Tue, 29 Sep 2020 10:23:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=nDCWED7cTWXio+7n4CbBlSFCTLArN57bTmDje6cvFBQ=;
 b=g+vKrLTPIJ3E9//KCN2jLbFnmvA4KqGiaML8OKY2txkYJ47VfOPgy/mqtDUjkKPd/+NQ
 oTaZLL9iKgeGqpcFv3q4vnHd6yphj7jv9R+JN1HCS5pPj/LV0uM8aFj8KUEkFykO5Eg0
 IOaUL38FuKAknR4EAsa0nvgopVWtp8KZGIw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33t14yephn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 10:23:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 10:23:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsrS7EKF2INrkUka2s6ewF8y3PbYUlLF2CvEZ3prG4gjr3rNst2QTzrfP9T5YAA7jgE41h9CltIqDxp2bys9otrbB2KP0iwrDGDSeTQkHUj7Cmk7sM5++bV3a1JLa4k9Tw2rfR/uvmC4C0JSY8aLRZBS1Fuz9QEnGA/y8z/qe5yylyvgIFBCekqY2z6GI8jWAHkpjNR+SceQwz8ZiAZtOcbTT05b5yYFa0kFOKDdtIV2/D1t0RFGyHLNW2nJRKzzVHLh9gJQHzjXVGhMO3KLRp2VevmrXdNY/bxDMfdJA0zLNKqGCwt37I369nybVjTCOJNeOLQSd9FL1zCF69wv/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDCWED7cTWXio+7n4CbBlSFCTLArN57bTmDje6cvFBQ=;
 b=flUGeHMsJChkYLvBM3urMqvScDp/Vt02+FN3TPBreut8V1Wcvac6Tyr8v7MIrW0+z2wUNfcqXRh76hvX0/xzA8OJ2tFWoo+2ranjKE6sbpJedmzxW+5MVBbvVRWPc0ue8m+cUWOOWo2CK2/x1U+eMPmKYOXbG6MOqCKYIBlQHPd1OKN+toiUm4gSOvRcpyaOU/DBy+85Dkee9ziR4qmMBR+DldOA+prms/p3qdPPzY4IEzp7FQtV+h/Aih17IZ38FIRfz8kXWDu2PlwiVBVICJ9kI17vIN6YUGw4eHfXhF99DS+XD1RpJj6LIZviRi4HlblOp47NEbeQzbY6LBIn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDCWED7cTWXio+7n4CbBlSFCTLArN57bTmDje6cvFBQ=;
 b=ixglXIT13mYg3QNWOs5b30YLSPvIraf6e1kiyeqhDySHm/Y5N18Za/e6rBXy05ji+Tp+9KEMvB5pLHZ0fzaynIImk47r/39anFU4WlFXj9nEI9e9oFFNEjwOW7e3VpeN+vieHbdFOk9No7+MjBP7LEqfncurX2P6OV6FCq05GKg=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2725.namprd15.prod.outlook.com (2603:10b6:a03:158::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Tue, 29 Sep
 2020 17:23:48 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 17:23:47 +0000
Date:   Tue, 29 Sep 2020 10:23:40 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/4] selftest: bpf: Test copying a sockmap
 and sockhash
Message-ID: <20200929172340.hogj6zficvhkpibx@kafai-mbp.dhcp.thefacebook.com>
References: <20200928090805.23343-1-lmb@cloudflare.com>
 <20200928090805.23343-5-lmb@cloudflare.com>
 <20200929060619.psnobg3cz3zbfx6u@kafai-mbp>
 <CACAyw9-hSfaxfHHMaVMVqBU7MHLoqgPyo55UwQ3w7NKREHcCxw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw9-hSfaxfHHMaVMVqBU7MHLoqgPyo55UwQ3w7NKREHcCxw@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR10CA0020.namprd10.prod.outlook.com (2603:10b6:301::30)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR10CA0020.namprd10.prod.outlook.com (2603:10b6:301::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 29 Sep 2020 17:23:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16af6e4b-bf25-4724-7cdd-08d8649c6cb2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2725:
X-Microsoft-Antispam-PRVS: <BYAPR15MB27255B1B9F5DFA9B01F08A22D5320@BYAPR15MB2725.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hq+gyuyMlphFJFAj/35IsFtF+IU0fL6ivst+Fc0054Fzwu6YyDrUJdPB72FpH1+1jV1tTxO1b41UvhJNqLhAxiumK9dszHl3GkogPa4Xh+b0bRKTnsNRKu8AgYUTOTkZhauhQWg7nirNNXeB+X9opYg1onArbtbAybJ67LVBliUHnb5NUdNNlUTgs2+3lJ5HceWAhaGUXsVVNcn/oD/FpsVcIt5iH+Ysr8wZfD1v6enl6zsi97Pf3zv1M4TlvG+I1L5jzNh/0ceuBO6ja8mARBOJ7p+7/HSpernQVAXOWqcUnKKA67M+6Ng11P1mbXbnqx7G4A+zM9Glk586q14UzddTQX+/ERh76ATE4SYFshTfv7AfMLRosruf9rgeUYF9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(83380400001)(478600001)(4326008)(8676002)(186003)(52116002)(7696005)(2906002)(54906003)(316002)(16526019)(66476007)(6506007)(66556008)(8936002)(55016002)(6916009)(5660300002)(9686003)(1076003)(86362001)(66946007)(4744005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: J9rmFVVnbQ/37zqLcCK0sVgBAfWUGEImh03NqZScluAq5m8S6xWSb0KQyftlCmemwWJJ7cjqu9v7ugJNBvsACh8/aQCy47xB5KN8YJpY92/rJYxYjFdyda7N1AU+gVVUCQQFCsb1hZCjbIBMmmZiLE1LVQHJ/zibxsSQ5W4ReT1q/1mZPj85UL07H4mxD1Mh4rX8b07sXp7sTz0s1z/yQ1uTDa271auY0OC42v/FLnb/AGu92vVqoNUgzJs7TVkQJes8pvBh3wcJDANmZ5LVhJTpYkFq+H2fj/u866NC9g5VIQNK7/6udIAUiR3tpP0bwmZtIib9ic8LgtyTPfEzaqbWclH5kcPMtYFev9A2WZY0VaHbF9fxIEN0N7Oi5ajcqyMuu6kVVcMz7E9mBdSWawCvjs7svx7lvgfwyUsybuRee/MsnGi+g6wPpJT+v/tFM8w7t/5U3XE0ptZtrOyAwT0X7jQt8Q+rZl+HIvxus1QnqGngE6HSBVHJRHEL3fDq+rysVMtCq7u9VvGOT0sKKxKYG0TXF6U/AV/1nt+jn+vmKrelbyGvCUI69HGPoNliDWlFZkshvTwQYyhMaW3AyG58nqacZMpmIaxTYbL7YpzGd4xsqU0Mc8nq9vY78cgJXgvxwMyCWU68ti7UFNr35RvdRu4LgQptVUgleCZhOaM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16af6e4b-bf25-4724-7cdd-08d8649c6cb2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 17:23:47.8245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0OA87K0JFaIt6ZZg9bCCCiLe9hlX8Ura6HNHTh37F+FcE3D9ZEtoL1HgXb61/gsk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2725
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_11:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=969 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290147
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 10:21:05AM +0100, Lorenz Bauer wrote:
> On Tue, 29 Sep 2020 at 07:06, Martin KaFai Lau <kafai@fb.com> wrote:
> 
> ...
> 
> > > +     /* We need a temporary buffer on the stack, since the verifier doesn't
> > > +      * let us use the pointer from the context as an argument to the helper.
> > Is it something that can be improved later?
> >
> > others LGTM.
> 
> Yeah, I think so. We'd need to do something similar to your
> sock_common work for PTR_TO_RDONLY_BUF_OR_NULL. The fact that the
> pointer is read only makes it a bit more difficult I think. After
I thought the key arg should be used as read-only in the map's helper.
or there is map type's helper that modifies the key?

> that, a user could just plug the key into map_update_elem directly.
> Alternatively, allow specialising map_ops per context.

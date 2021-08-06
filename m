Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB23E201B
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 02:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbhHFAlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 20:41:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34128 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242998AbhHFAlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 20:41:50 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1760Yslu031193;
        Thu, 5 Aug 2021 17:41:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bY+t7pKGu879F3MMwAWX9lWezOgsXjqudF74/bWQ3Gw=;
 b=lHG9h/C6nysuz25ZkNSeM1N2izRUgWBcaERDLQMWmlJ8ucbqB6Ork6TQRq0k9trto8xg
 d5Tdsny1HOUQvekVdErAIvyyCHBZ0fOthsjRIR06fBmaSDz8UJpVKzqi7rlPeMX0ZdZD
 yME0fRTzmJQCgYpV7AF0QJKzNNz8fDIIIeI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3a8jh5k0tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 05 Aug 2021 17:41:19 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 5 Aug 2021 17:41:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT7mIzS9d2OCrGGy4Sf9bhVgw8WtqF/hCAU3xs4ZLuM/V4Fxc+HG5Mfcw7uVlwRv4JogwKD3QMU20/9zJsLGUt8UF57YZKpMG2f+fBCR1wRFnO9BLqUM1KKYyNum1as5lZ/sbgOQri6NjJ7VncWD+02ScpdhEbBtZkDwgnJr8J18Mtw2fvs1f2V76Wrmnd3Y7gUksF1lzKe835EWbCWNY6YT9x53E1P0J+XQ2rD4E7u9tHbK/IM3t1th0K5ey7an6p6s0BfCOj8V+bkBqZSjNE4pt9F8ds3vvu/tTVVX3Lo+MKxcjmoVg5B3USAAyswKDlntXE1JESVj67LZ46kpgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bY+t7pKGu879F3MMwAWX9lWezOgsXjqudF74/bWQ3Gw=;
 b=MHbu7Mh0FzUWoeQ9t9dMfqQ+hrxEcEqJT1d4IcPFevN+vuxWmz7CtlCu0TgEuA1Zj/BzI5giV43Cslc+dnP5L/0sWZn43AztAPyaqRdYOWakNz04de2dP5hLPjVoM+yGAIDDyZ1z5pMfDv8ZWd0CsMd3vTk3lf240vTE8en0bjA0llCdkRpaNXeFTXNOWW6JEP9D6lWRcldmXU1T3cTVVCP5zeiiyS0naYXdqQPTnV/Q5t5HASAYsm4ZfAz08XRiYS4Ry9gHrTI+45dPWXLEL68C12ICDjsS5GwAz283o6S/C7EHVM9R6vR4ZUWtLGeFwYbNa2rnWUtJZFg/e8XTFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2398.namprd15.prod.outlook.com (2603:10b6:805:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 00:41:17 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 00:41:17 +0000
Date:   Thu, 5 Aug 2021 17:41:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: af_unix: Implement BPF iterator for
 UNIX domain socket.
Message-ID: <20210806004114.pf77j5a6eb4223wn@kafai-mbp>
References: <20210804070851.97834-1-kuniyu@amazon.co.jp>
 <20210804070851.97834-2-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210804070851.97834-2-kuniyu@amazon.co.jp>
X-ClientProxiedBy: BY3PR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::8) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:b6ac) by BY3PR05CA0033.namprd05.prod.outlook.com (2603:10b6:a03:39b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend Transport; Fri, 6 Aug 2021 00:41:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77370351-713f-432f-1487-08d95872e6e4
X-MS-TrafficTypeDiagnostic: SN6PR15MB2398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB23989E7785E95D9A060E93FBD5F39@SN6PR15MB2398.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Db0PO4mUpUzL4tla7LO/x7W5YW4q6nwsXc4mNlL5cX83QfPj3xISsD5KEIIAzaRlkYl8JlOktItNJIg/lblG7d/KbAyPczpZpKgWxaCaxvffhPMX0JXmWp5QAZ5+bdZcj7vJ3IEJ6nDQtIctjvUpaonTJjH12VZR9s/eiJpreutTjxXxcdn3ZDU3VMezmedMobZCp5sGjyVSXm0NgaspXuKBIq+aVTB+DzFhtbffxykC2/EltTR6jqQf7bEDNZnAvxQtuyBjEPDgchyUX+fj/emoL2uBoXXG/C5Sy4rx4iWdfhPNCqOJVXU0ROsbcGE3/Prix3dYdKZBrdwjbGXHfO8z0aaIUWM5m8vSvhRE9xG1bC1ICuQB44dDv0uiBz4QKtaUEoBEDF5Aht81ZU+IRFHaLe55+Z/4Lrtn/qaXsKPgKe/8QNgbgUOgtMW3a4RhjnNC8wzg7mutt4AuRCv8pZCveHh2iCaeeknpsy0MEUHs4vrrPz3Yt9QYa262qDLtu9P1s3MXnyXAfIwxME3ex+V7jMobINULQ99xJfU7eoLDWiRheNX2i7yA4x4E0Zz2LbxyOcvdmnHgEThzKboFJHCQwbN5/Dnc8+qZ9A7w/y0zo1s3w7t5j4+/sFdjlaZWaFB4WgvIkzmHBRCVJU1Ckg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(2906002)(6916009)(186003)(6496006)(52116002)(316002)(9686003)(55016002)(54906003)(8676002)(33716001)(7416002)(8936002)(1076003)(86362001)(4326008)(5660300002)(4744005)(478600001)(83380400001)(66946007)(66476007)(66556008)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yYuNhB43thZ8oxV3lKM5rpLB/EcC7yNfAS5hZLfMHbmajqxZ6o5SspQTlHRC?=
 =?us-ascii?Q?BBbc+k2StZBD+9PSfPyhTztguOTHG9Lhrv+yOdnQ3mDvl7Xfl56eLNOLrhEc?=
 =?us-ascii?Q?Lpqgs5Z/S8o4w/KCsLMWC3jO3qZv0mx33LM4UCNhBVoQ6mgdwjuJOjtnkECy?=
 =?us-ascii?Q?Nz6223Yi9zbX3BAhwYbenO3ISKoEMuPAGu66Acw1Igp7pTZu9vDEmrW3MjU2?=
 =?us-ascii?Q?XXX0PoBXAmtcFKbLetq+zxJr3/2NaqO1ntAD6NWD01TBtMekvFQNqeydKaPo?=
 =?us-ascii?Q?b1WteTKAxdHy8dh9Sm5os2tmlTfezWnHSN1IowTqZ+DHhdzB46tsdQlBb/JE?=
 =?us-ascii?Q?qPyzE7Pm2FoH0ICOFUgmJ7W1BspACaBGGBqAR5o0a/aEL1BQBOrCIamuQUQW?=
 =?us-ascii?Q?CtMlRVxK4qR0KlOc+YbU2asr45RNBwvg3XPhI/OKpaxBSyb+1gI3iTcyChYk?=
 =?us-ascii?Q?FdqRBE0NVRCH2Hm9LUHoRKhyJ/GWNDNCYww8AOdnIM2/ZBZrYx+27ek1R3Nd?=
 =?us-ascii?Q?cfyeC1usn3hJGeIHpjd4X/v9DPvqEpsS53z7HiEsrrLxZRXIK8bSHtn7K0x1?=
 =?us-ascii?Q?8ZTCOSZ8QTWZmCsxKa5DyHb7jJC3FTRPS4nVHnvq766/QieRIzZMEJb9E3td?=
 =?us-ascii?Q?KvSVl6yPUT1MJ2CVQDjAl8SixZal/DHUtj7fYcAAm4aUyXVNwB3tqL8Sbm9r?=
 =?us-ascii?Q?b3Tf/PrOeA8HAG6L9lApi/vcW5yGj1MlxmKmS/Irpi75FReUM7WJwvyTrCdR?=
 =?us-ascii?Q?l7XxLaufdbLtc4x1POTrng8VubE5d/ylH0ncjBOTP5V202sHvHfqeieHvcvg?=
 =?us-ascii?Q?0huXG33Ykf0X/nY9x+e4O57bVwADW9bKDXxdX4OKf8qGgJWWhqsOfGfq16om?=
 =?us-ascii?Q?ndvAvqGMUMEJ7THlvAQzW9kwaiLLzerdclIIloYaDqHUARQiqZI7KtBpvKmU?=
 =?us-ascii?Q?/RqsmWAU4YjId8Xpl2NavBK/0ILh76ADba2eDllokEbbi7rc5GoTHPYqIJ/u?=
 =?us-ascii?Q?GJJhJJkajWLPcrs4Uy23WLJ6Oi7yjHgW+OInGh1Wdi/md+El9bLuyKzdHaS9?=
 =?us-ascii?Q?URKkbrsbGpSnQc89hOi4z36cfWKUr4NUtqLz8+2kkkwvX6RYZXj5quTVb2Hu?=
 =?us-ascii?Q?ztXnzvBXekWDUroGDPAGvsxkCnGZwraY5Gsibxc71Jf7AK8ih/nJZ5lSs37g?=
 =?us-ascii?Q?Yu76AdwOBJIiq38btt/PRwWeZ9VStw5m9sRb527Vh0JxBycrprK1dgO4C/tQ?=
 =?us-ascii?Q?gmHZTIDtXX5nq0XxH3WjAesgp4WfAifWxdhULoVtgx0iNILfVZ2VOQluGq3q?=
 =?us-ascii?Q?D+5Z4aOPbsOtWV1u0do0SKzjLSFIMqul+AGAnj+AgVSRAA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 77370351-713f-432f-1487-08d95872e6e4
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 00:41:17.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZAnsObzANyIPZxOn0ketKwgS3+o3kl5VLsqTadj8o2KDCScrzDQNkImjWBo+wtba
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2398
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ykzuq7vqM0obru6Joz79UlGzsaIJV9mj
X-Proofpoint-ORIG-GUID: ykzuq7vqM0obru6Joz79UlGzsaIJV9mj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_11:2021-08-05,2021-08-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1011 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108060001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 04, 2021 at 04:08:50PM +0900, Kuniyuki Iwashima wrote:
> Currently, the batch optimization introduced for the TCP iterator in the
> commit 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock") is not
> applied.  It will require replacing the big lock for the hash table with
may be s/applied/used/.  I thought it meant the commit is not landed.

> small locks for each hash list not to block other processes.
Right, I don't think it can be directly reused.  Not necessary
related to the big lock though.  Actually, a big lock will still
work for batching but just less ideal.

Batching is needed for supporting bpf_setsockopt.  It can be added later
together with the bpf_setsockopt support.

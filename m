Return-Path: <netdev+bounces-6490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD89B716985
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:31:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82C9B28128E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:31:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8348125CC;
	Tue, 30 May 2023 16:31:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EE22A9D2
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:31:21 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1101123;
	Tue, 30 May 2023 09:30:49 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UE44cw017589;
	Tue, 30 May 2023 16:30:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Kg3vsSzoUED5FVn2vhnyId1IZnRpoA4sFOf6dUn6c1Y=;
 b=iaFCwaID5pjIT/TlNHDgYgrDkwIN8RRtZnTupxbXFg/asnbEUX1xAOGoPcbUecW90rF8
 eR5Pi3x6o9I2jNHRET+E23hh09wvaV3L0ggOxwaDWC9tQOVf7x2VggweUj+tHOTCq8mL
 2wgjXJeVTy8JExE+3pcv3Af5sVBDF+/RLnC9h2Fqausf3iUHV7Hlk7xM1xEHh4Fl1iCn
 eud3HrC+iiAsU3DnOJzMPkuuK+1yhotpeGgyqJo4JWU5fA2PsScOUrXVEUpW1iFyh+j3
 8ksVxjXl4HLqFG57oCS81FiacgBnnF00krviPLv9DSCCbLffIJ0LuFBEXs/xO72Jm9yA Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhj4u7ks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:30:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UFp7Z8019823;
	Tue, 30 May 2023 16:30:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a4cdud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efeVhFYHHv17Y4MbsD1eOh+ybL7isFxEdNAgai8CDLDAABFsi4fbvA9r4Z156kFPr/qVHw59JeN42IlXSmD+9M1yjOCgfngExiqhVVAhWv3KHA3dJZeGIpVAPwgvDtByFB+JxOvF01Ar2zPW9SLAZjxb/O809GWpeP2yztUR1TBkstQc3cRnAGZ7UykpPymN4Bud4gy6YJrqp9Oyw1dduknvNkw2tJ0od/0nZ/pdAZ8Cn5FCQAYZjWEzdxsAVVso33Gs75xWGub9r+D5VojAwhLdZ3bdmuyHtUMY1sVVXoWIji/47s/OexG/tgufW7jN5UWZvO3BchN9btxAfBTHbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kg3vsSzoUED5FVn2vhnyId1IZnRpoA4sFOf6dUn6c1Y=;
 b=Z1BTX6onmXuUiNm++mKqxwXWAjBFuVAd428ra2Y4JyYQcmhR9FYc++jcQMpoXTA6yflHWTqiCnGNzlulGLhtwDmdfsY9QyBh42qvYTkVXsm8FM+yhALPggufSUEho5kF3r+9J1PFORqtIbatYP63qAxQxLqAzZ9mnqYvAv0iSIDCy2WmxbqRS4ISKSsTrX3G815P3DGzUk+nLichcQ0Ulw4mN7L3H1Xkdz1mv0Kwarkj5IV9zGv4MM0VCI73I4dMnBtq03kNLYNBhn3vmnISQgy5Ra6+cc4eAGSv+OdC2lDgnShBD35gC4pD4LG2BxnbIBcyRfGxR5aY+V7irleAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kg3vsSzoUED5FVn2vhnyId1IZnRpoA4sFOf6dUn6c1Y=;
 b=nxghadf/1WWfuJtn/3mSSNSXU2G9rP/x36MXfj5C2MdTnhvF2rZuSW67iRm5Ujh11IAXLfGt+EyV2vSJ8r/YWYv7Mec795sBvKYHtaHdC3IjqinUPVoYLJ+WPDuDANhHknAgcSi7BS1XMehit58whtQpEyG7+9qWgP6vZ22D+ek=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4277.namprd10.prod.outlook.com (2603:10b6:610:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 16:30:04 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 16:30:04 +0000
Message-ID: <035e3423-c003-3de9-0805-2091b9efb45d@oracle.com>
Date: Tue, 30 May 2023 11:30:01 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
 <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
 <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
From: michael.christie@oracle.com
In-Reply-To: <6p7pi6mf3db3gp3xqarap4uzrgwlzqiz7wgg5kn2ep7hvrw5pg@wxowhbw4e7w7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::16) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0e44d1-7848-493c-5c76-08db612b1f50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Kd74Jkth/klmMNe+XF3O3htoX62gEhSnQyO00C+T+RNwWMzBZBAxNbwdPQjegg4Z+l6CqK6ZwSfKk51juHDbHZg4ofXi/r2uVdixBdoSFbBC5GzAzFivCATfHHhA79GIZJuNtu2DbPVd6Tid3KrPX1Yh1LJFLGTk2vpWulGV09u8tRniWw+vc8oAC3wttVGKf7LjtF4C0XfIaO88E5FnvD2SLRA8T3e1TO6pu3T31AZEa4YkydXqaG4wKNgiUwd3ZDj2JHUbw4hzx3Bt/gPxbjaLixOPe0gDWY7UFzCa/evPHXJ7+0zhUYfCfYjDXND+8vXn74qm/i3mCzsrLaHIfyD4ui88S5GDYDi/JiapQzh0ZD+Bij01Vq3u7sG9JXIvNS2Ee5oW6QBqGstAMLO8FW2eBluPdW3Vw9uv3udwEVPzZSEb5eSAu6qbP8LBlzw5HKyq4/Z/tNvs2qLF5CMtITZwiCjNiOY7gvEWbT0SCUD71f66E07Lv0UYj5wexsHmrOIcHoxuVSAmAY1PTxsb0tLYJJaENN9o31VUJZ0LJ1iDVcydZc+ESwSMYH+dd24sMnXdzDXdbhE6j0p1opNU7hPt+XlreBxRIJPT1yxpmduNc7lWtPpgpK4ihqFO9Rtu
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(66946007)(4326008)(7416002)(36756003)(66556008)(66476007)(6916009)(83380400001)(5660300002)(31696002)(86362001)(38100700002)(41300700001)(186003)(2616005)(8936002)(8676002)(6486002)(2906002)(31686004)(6512007)(6666004)(316002)(6506007)(26005)(53546011)(478600001)(54906003)(9686003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?M1F1WUpxUHBmQnllbnVWa2VnR2VLL2FFZXFMekx4aWhISGpYTytrdEVmNVFh?=
 =?utf-8?B?eENFR3N1YW9YeFJhRklvdUxvWG5jYUMyVC9TS2hGbWRYMGh4bHhsaG9pdG1Z?=
 =?utf-8?B?NytBRjdCV1cra29KVHpkVllFbFJxM2VuZVRRV1J3MVBZQnJOMkNNZWFTd285?=
 =?utf-8?B?OUtlYTFaOEZHRFNyV2liN01ycWhOUWZhVFlyeUkzUDNqd1BlajhYVk9xSmJM?=
 =?utf-8?B?dVc0Kzgrc29rNlZvSGRKZFNUODF6c3FEbnM1WW5POUxUUGRPL2dWdE5ZdlhM?=
 =?utf-8?B?UHhveGpHNjZUWUx3UFFaemhPRG1Fbi9VREwwakZOS1hNaU9KeFc2WTJDVW4w?=
 =?utf-8?B?TEkrSWVJVmJmQWhMcEFhb1ZVNkVvV3VuajlNcGdKMW5WMHNibE95Z01YcXgv?=
 =?utf-8?B?RFBvTFlwNUdyaWhtMmZWQmVodTFoNWZGQy9NejhmdTYyM1NhOGdXK0EzYmJz?=
 =?utf-8?B?K0F0SVpZdjZ5cERYQUIxNEpUTjRFQ3hENUJORUpDRVd3VUZBOUdhMW5aSE1s?=
 =?utf-8?B?MGJwd3RiSlVpdkl1bllRbUtCSWNCOElyclBrc0Ewek8wVVpkOEY5cFg5Ri94?=
 =?utf-8?B?OXNRMGxCdDQxUFJPN3hVQUFPTXhhd05wTTM1Tm9GYlFmamRXQzFpRjFJQWcr?=
 =?utf-8?B?djNmMThQamdsQitRdWxleVF3ZnluZE1teU95V3FlbUx0Y3lJWkJZUTh1QzUy?=
 =?utf-8?B?dmZLemkweER2MFVjQmxYN1gwMlhmR0dac2xQSEJ4MU1kMjJiSHBQMTlBN08w?=
 =?utf-8?B?R2JMT2pwZ0dPNnRPamt5MGdkd3QyUU4remU2eVI4MjVVY1ZLNklxaEtmdXh4?=
 =?utf-8?B?TC8zK2t5UC8vOVhEZ0tIQlRCSm5RWXNxTmtkRVRTS2Zjc2VCZzlXb0FPOWtW?=
 =?utf-8?B?Nm03K041UHQyTmxIQlpCKy9mb1QwY0JzblVmK2UyU3dlTFBDSUNxTGdUNGkv?=
 =?utf-8?B?a2FNaFBsYk5iekYvUUwxc21LSVlmRkFyMEJ3L2IxZ3lER2xnUDJTR0t3TGw3?=
 =?utf-8?B?c0toT1pWbm5KS1cvaUg3ZjdTQStIUXhSL0w0UzlEMlcrL3A2Mk8xUWVSbWx3?=
 =?utf-8?B?S051T1ZVV21iVzEyR2dRbGJnM21wd2hNNHRETjdwWXQ1M24xTWJ2Sjg3V3g1?=
 =?utf-8?B?T1RGZFNJWlJRczBlblNVaUVsT1VIcU8zYVZ1NytBZHFTTFpZQWJqNWVvMGYr?=
 =?utf-8?B?Um9KOWdubktjRS9IOUtpeU1OUUt2Qm9aTlA5cUNrYUpkanZKSjlodWphUXdh?=
 =?utf-8?B?amJtUkprejhSOFNvK2dqQzNZQ3lSSFFqOUwyT0t1UEpmdnExMWdxYkFOYytX?=
 =?utf-8?B?ZnN1YUxWMTRMT2F6YkhOSkJKUnVVV1B6VG9obnVsM2JORVhuUjc4YlM0YXhM?=
 =?utf-8?B?UEw1d0dGdkNSMk5VQ1cwMmRIcURRcGtmRGtuNXQ2cEtFRGU4dDVpZHhXL0VV?=
 =?utf-8?B?aEFDTDlBMi90NkhGcGxIVEV6d2xreUY3cGM2R1ZXV0x1YmlIZkUzdVJ4U0x4?=
 =?utf-8?B?N0pNZjNxMitZVjQ0K01udndoaUJNTGlYZXNWVzQvZEYweHh5TkswbjJENisr?=
 =?utf-8?B?TnUwRTZKdlRpNE52TGZRNHpyMFoydVBqb0hyQ2x5UUtPMWZvL0JMMnRnbUxU?=
 =?utf-8?B?V3NTYVV1ckt3SURiQnRacWFZZjhlWVZVdjdSRm05M2w1R3VCTEw1cXY3OWw2?=
 =?utf-8?B?d2NnejI4Q0p0TGRlTkJDKzZRakFjQTZjZ1BPdFRKdzFUL0c0YmRvakozVXNi?=
 =?utf-8?B?RlErU1lsZE1QUVpqeThzMThDUDc0QWgzWnBpeGRXV3FlN2ZVR094bjhCZm9p?=
 =?utf-8?B?SFNONFAxczdxL1F3REdKdGR3S21paStzY1doNGEyaU5hY3MyRi8yVU5Ud2Z1?=
 =?utf-8?B?TkZEbmU0V1JmZnk2Z0FQbnp2eWd0VDRFZ1F5dElPR3krZkZlRU51VFk0dFcv?=
 =?utf-8?B?N3NrTmhXb29uRDZkdHpkS1BRSDN4RHhxYVVOQkxRTVNBWVpCWmVoU3N3QW9o?=
 =?utf-8?B?YkJhalVQekMyMm42dEFHY3Y0ZE9CMFpXUUsxci9qRTA4Y2dWT0p2MVVNTnRl?=
 =?utf-8?B?V2dGUHlaZVVKeGRWMlN2S09nb2kzZTdzVzN2QjU3TDJoUmxwL0dBaTBwNmQy?=
 =?utf-8?B?V3FJTTBJa3dKNElYOVhoU01EK0Z4ZEE1WS9zeHYrb1Q5RHBQM1l6TnFYUVVV?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?L0daMldsRElHd3ZQOTlWRE5ad0N1ays3MGtqL1JKNmxGaHp0bDdBb1ZNMkFo?=
 =?utf-8?B?VEFlTE9CazU5UkpyaG9SWmNkN0QzQVdNcENnS3NTWU55RVlKVlVVYTlTK2V1?=
 =?utf-8?B?ajNCU2l0V3RPSkt6WUM2WnpRMjRWZFUvTHJYM0ttYnlKa0p4V2ZCQ2xiNXhN?=
 =?utf-8?B?YjMvQnhpRnhkTE40TXVRSklSL3RLRzZtQVBsc3NJaWpHd2NyRDB1em9YOW9y?=
 =?utf-8?B?ZmNwVHdrNitaSmR4R3hYckNJa3J0cDZhS2lTZHJ2NTEzVUdFd2UwNjcvcDN6?=
 =?utf-8?B?ZC8zTWxXUThpdWVtRHRsQmg3Slp0LzVlNytVMUJibUdoUmZnM1B4N3ZERXhG?=
 =?utf-8?B?cCtGb3hXSHVQUUZnZDNQMnlxdElzVEZhVEZLTGVnbEVGRVRLdFZkTDA5MFI3?=
 =?utf-8?B?azBENVcwY053bk9MV0Vkb1ZCRFNrK09MT2tTRWxuYnFDclppY1FpMmFYZEg2?=
 =?utf-8?B?cGtZdjREazYwTnhmd1hia0xUOU5raFVWZWJhQk1KR3lnM0Fzdjc0R0pLNkt0?=
 =?utf-8?B?S3J5MFdGbE1uR2VpVlFtVWkzMnRHalA4OFJiVG5PSnhrSXh5b252OTBjRTlC?=
 =?utf-8?B?QnRhSmRjU0V0eHlhUTZmK3g2aHhRTzlpUnRuRlNKamhCRCtXU05OUlVTL3lx?=
 =?utf-8?B?cUo4VHBqbHFPRS9kcUZaeThhKzRFOFBJOEs1Vy83WGpzMGVSWUlXODdlamJX?=
 =?utf-8?B?eTA0amhudXpaWTFsanA5bWZNZjhKcVJVT0FwY1ZTVXpyWmZmeXdxT3pJNkNI?=
 =?utf-8?B?eE45TWFjOEk4OFc1S3c0TnNiRzc1L1pjWGlKS3E3cmNqVElJOFVpa0QyZW9u?=
 =?utf-8?B?NUxMMG9FeFR5Qmx4aUwxeW9IejI4NHFJKzY0UmxLa3pxcWtCRWlxRnVhUk1i?=
 =?utf-8?B?R21ZKzFHL3JyaEVweHNhaXIxY3dJTU0yb05BS1ZQVER5ZVhTRXBhbnYyYnpy?=
 =?utf-8?B?d3EvMThFV2dGdHltbWNOT1ZIcWphYmJjdVVDMi9rMFhhTEp5cmhUVGlaU2Rt?=
 =?utf-8?B?dHdmcFdCckVrS29uay9hTnBXN1F5RCt1SmVvendibW9MTWZUb1BwTmRjN3cx?=
 =?utf-8?B?eERmZFExMWIvcVJPd1N0SmZSMjI1SHhzV3IwK3RLOUtNTUsrd0RmTUs4T1ZG?=
 =?utf-8?B?eXVJODVMVHpuWGwzZmFjckJmYnFOcHQvNFpnam03U3lzV0FISU1VdjJoWnR1?=
 =?utf-8?B?dkpHQitWN213THBuRUZ3RGNnWS9qcndZa3RtOW5OQjNxeGFFTTAwMkdIMUpP?=
 =?utf-8?B?L01MeVV0VXMzVDNlbmx0ZnExVEpBc01xR2NESWhaU2lvdHIyZWpYK29yMEVw?=
 =?utf-8?Q?VGcsqJF+W3DII=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0e44d1-7848-493c-5c76-08db612b1f50
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 16:30:04.1166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8ZlF+sy0JtdK45mMKcrsqocvSoplw/X7Eox1qJaMhL1OIseaIi7m9sNGlf8USXi/MtkUc4YLaMRaUUhSgHsoT0fmi5laa0y6vXVTTFwsbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4277
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300131
X-Proofpoint-GUID: O5TjUFaPZGo62jMlqNT2ryDGy3GyJbme
X-Proofpoint-ORIG-GUID: O5TjUFaPZGo62jMlqNT2ryDGy3GyJbme
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 11:17 AM, Stefano Garzarella wrote:
> On Tue, May 30, 2023 at 11:09:09AM -0500, Mike Christie wrote:
>> On 5/30/23 11:00 AM, Stefano Garzarella wrote:
>>> I think it is partially related to commit 6e890c5d5021 ("vhost: use
>>> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: move
>>> worker thread fields to new struct"). Maybe that commits just
>>> highlighted the issue and it was already existing.
>>
>> See my mail about the crash. Agree with your analysis about worker->vtsk
>> not being set yet. It's a bug from my commit where I should have not set
>> it so early or I should be checking for
>>
>> if (dev->worker && worker->vtsk)
>>
>> instead of
>>
>> if (dev->worker)
> 
> Yes, though, in my opinion the problem may persist depending on how the
> instructions are reordered.

Ah ok.

> 
> Should we protect dev->worker() with an RCU to be safe?

For those multiple worker patchsets Jason had asked me about supporting
where we don't have a worker while we are swapping workers around. To do
that I had added rcu around the dev->worker. I removed it in later patchsets
because I didn't think anyone would use it.

rcu would work for your case and for what Jason had requested.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603EA3AC664
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 10:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhFRIpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 04:45:09 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:44690 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233855AbhFRIpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 04:45:01 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15I8ZDmM021252;
        Fri, 18 Jun 2021 01:41:52 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by mx0a-0064b401.pphosted.com with ESMTP id 398e300aym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Jun 2021 01:41:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BI5XEID5bv5wrCFFEL/VEUAsjek1Xkzx0cIMsP7FXtcobj5mXHqJmg98+7+GeKRWJTuZVuFnhPqDiDrHh8PORPjxsqSpBezKqlgwsWxwva0On2jnl70K+Lw01AM4aol9xH852+dQuQnbz27We06LhrybVxv+6VOYjVvMEo3dTjalES4ckYdxwJet//7VQki4LhPj9XlBCR3dcxYYYjtJeb+9oCvdfvEl/yYSMvVjZ/m6D6MyRgT76E5jBKpKPRGIX+ct7cI4in0VS/VS7jIASF+1quziR3TXizTu3+k47gLdYieeAnII7OBgqU+7O1faLrMAcT3Ja/WJzRbpXZXalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brOESHofmL3/lB9KRztoWeau+H2o2QOmVtk5nTHkimM=;
 b=Y3851/M6VJH7Y077X1FAHSug5t8o/HEYYtE7Tli/6o53hhf8NfzgD0nhqj83dK4mOQpJpLnbi38bVI23TFKrzX7cekRJJe8CvZAKG8A6IOO6tr1+ujZYXUv2G7uB96vhEv5Z93jTq6D/TptcvHYvGIiv1AueJ1etajXaqceQeoT3RlmNaZklyhI7ONw8VvGjRgbfAxzGcW+qLs4tfSw2AJppTMGG20oqKw/lbAP2ZbwSjw0Xa6EbP1v6dnnaYwb5raNajuSAa3OkVxMmOBx7B70+D6iiSCkZKCtr3jAXOUutR4VCZcozuYZrKEK23Uatx1Pt3EoyCBvh/rqtk9oTzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brOESHofmL3/lB9KRztoWeau+H2o2QOmVtk5nTHkimM=;
 b=ZNYlKJAYkafstpymecSR/qa7Njt0cf8TXhmS88djIr3v+7AdZTGj/bDXNft86lpp7KKs4qhnNC1iqS3FRG9NYUC5//gEhUgkU9sFl8uPQzSbOnJRAPtrbu3kryZHdHDvWw50DVWcdbR9tv0CVS1RP87u0jtqf/gmuVBhxPoDYHw=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none
 header.from=windriver.com;
Received: from MWHPR1101MB2351.namprd11.prod.outlook.com
 (2603:10b6:300:74::18) by MW3PR11MB4762.namprd11.prod.outlook.com
 (2603:10b6:303:5d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Fri, 18 Jun
 2021 08:41:50 +0000
Received: from MWHPR1101MB2351.namprd11.prod.outlook.com
 ([fe80::c5c:9f78:ea96:40e2]) by MWHPR1101MB2351.namprd11.prod.outlook.com
 ([fe80::c5c:9f78:ea96:40e2%10]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 08:41:50 +0000
Subject: Re: [PATCH v8 03/10] eventfd: Increase the recursion depth of
 eventfd_signal()
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qiang.zhang@windriver.com
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210615141331.407-4-xieyongji@bytedance.com>
 <8aeac914-7602-7323-31bd-71015a26f74c@windriver.com>
 <CACycT3t1Dgrzsr7LbBrDhRLDa3qZ85ZOgj9H7r1fqPi-kf7r6Q@mail.gmail.com>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <4ff258e8-d319-c2d4-cb70-0edc9a54fd03@windriver.com>
Date:   Fri, 18 Jun 2021 16:41:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CACycT3t1Dgrzsr7LbBrDhRLDa3qZ85ZOgj9H7r1fqPi-kf7r6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: BYAPR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::19) To MWHPR1101MB2351.namprd11.prod.outlook.com
 (2603:10b6:300:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.175] (60.247.85.82) by BYAPR11CA0078.namprd11.prod.outlook.com (2603:10b6:a03:f4::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19 via Frontend Transport; Fri, 18 Jun 2021 08:41:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a5a9290-24a7-4946-a96c-08d93234ea6b
X-MS-TrafficTypeDiagnostic: MW3PR11MB4762:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR11MB4762CA0263044357C4D668248F0D9@MW3PR11MB4762.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VU3pOzHmzZym4AC5zKP3p56MwtHdaXK21keUcxMGMYk86pREuPPhee3ZrHxbTd2P29qfhJkOYN88F7u536Q8ayhMjDKh3StME3/F7SKWQ96p6/PhyYO8wi/CjXBvTCGSSfsSPkpzAyEGs89Jx2Qutvasa2lswwhOxnpexvD+KLRtDxO9mogFxHX9QVnlpY/nxSjrnYy228HL6UlWZIZCeR2uconMP3b5Gm8mRiVMzzmzXu7HNCulqe6H+K0bpdRQ8uyoc4du235n5tjXoh6FIAXLJim23iXGwolrusKpt5JqsspXc9nZ6KQ/R1ZrWtb6T+P8KxsL9ctM4M5X8bEZslPPczqWpbQP+Hat0SqWzGd6jCQbAQ5CvkOggYoLxl/aNJ/oWzqwFSo1xQDY+Q6Vb81qcpAmrY9M2qZJrRaI32SCk+OW1FE/q5jfYidlNSWKSp7kqI4Ebu3Lecl5knynR1Ikp0U2benOv9LomRxmjRVPixsMJcMl32v73uMDz4OL8FPtshtMDZZWOqv8gClHBzDEsrKe7ksLcdAwgNMkezVz6M4xcMnYoE55I0ChH4weIu3cpc0nY157U+d+ANo7f6mDJ/NhVcyS3rVG8w5HBMtVAPuwGHwtfbgQ57FWxrrwn8cN0e2PiA5zYGvqYcfyMSTKj+QvWytR+OgKgC/UrYSKMGMfK7mTlwnZFybWyyFw5f5OJUyVEUFYBoX6xzFb43z5ArE0OgN69bHGWzGl832YxFqBlq9BJ0+rwyyqR6DHb31FL+Ao1W4+4iOk1Q9smTyj7Ux7FODPCRbtesbyIZRZaGh7PIbGftxyvDR2/Y9BnjXrz10U9QY0IlKM13wW6d6OffuhyG6o37Ao68CHBHdHZzqktg6q9WxVY262RVz9Hmsk8mfx9EHKvjpGVibShA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2351.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(5660300002)(86362001)(6666004)(38350700002)(52116002)(31696002)(6706004)(31686004)(16576012)(6486002)(54906003)(53546011)(316002)(6916009)(38100700002)(2906002)(478600001)(8676002)(45080400002)(26005)(107886003)(36756003)(8936002)(966005)(4326008)(66946007)(66476007)(66556008)(186003)(16526019)(956004)(2616005)(83380400001)(7416002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1RRdXBuS1lHd3FLQ256ZjVHV21wdXRYc0s1MCttckV5Y0F0OWVtSzhnaGxj?=
 =?utf-8?B?RVg3STE2dVd3aUdrdUxibDJiZHBPa2paVHRoVEFmRkhocE43Z0dVVVUwVXJi?=
 =?utf-8?B?ejUwVXRCQUR4WjdKR3BpblliNDcxR0RYNWpaT0ZHVVNCN2M5QVJXakxZSklh?=
 =?utf-8?B?VWE3RGhmd2RpdnpkRmJDd2tvVXdWMytiRGt6TkdXWjY1WURnVk1kZWgyamRp?=
 =?utf-8?B?MlNVeEhlM1lSWnpNZDNxWmk0c0lOUjJiRDNUdmEreFRWN2JDRjRwRVZHYjBk?=
 =?utf-8?B?aE44SC9WcDFaa1kxaGlJL3pzZHpDa1AxTTVRaDVtM0RRMjRSUjUydHk2M0ZW?=
 =?utf-8?B?NVh6eTFqTXJQc1EzTW9oVzg0ZU1XZWxwclpXUklPWEI4dzNGVm5hQ0I1R0Zs?=
 =?utf-8?B?UEwwQ3FxQ1dWRDRuNjZoelpjRlk1aVkxeWwvNkovbUtRZklaYmZqUXJ0Tjly?=
 =?utf-8?B?c1g2YXdlMW9SUjdLSHg1SjdpRll0ZlByaXRLbVFTQXVGdnVLbnZleUNpR1l5?=
 =?utf-8?B?L0JnbjA3S0xhQXNzcjY4N2VBWjRDSjFEbEx0cDFDUmhUdDhUaWNZSW9uVzZk?=
 =?utf-8?B?TnE0VDRIbEphRUUvY0kySUFXd1U0SlZrS2YzTGpEMUtkcm02ZE5BdGp5TGRh?=
 =?utf-8?B?Mmx6US9ENFBjU2dYWFRqL09BSFVwTmZmU0l3Uk5neld6T2VBRGhycUpGWUlB?=
 =?utf-8?B?UkIycFlPeXAwZjk1a0JsNG5YcTdFTWNISkpES0NzS3ZDd2I2TXd6dEE1Y2Yy?=
 =?utf-8?B?dHZFOUIwOXZJWGtvMlg2dzF5cnpZLzBGQ1lGR2RPVFRKWDVLOEkySkpQUnZF?=
 =?utf-8?B?UEp6K213MXQreW41d21nQklpNERzVmRhblBqTVBIZ2FwMiswZ3RHbFhIS0x0?=
 =?utf-8?B?NWFKQ2Y2OHpmWTVjL0J6TmdYanFzNThpV3RsUHRSeUJFeG5KalRSM1RHNnVp?=
 =?utf-8?B?OVJKTTVEMm5vQ2pVblU0alp5WEJWZlZCUklQcTd0WXhzcUlUQmxsK1U4STcx?=
 =?utf-8?B?WUFLaE9jdmVxTjQxUUJqcUVNSkh0dmduRyttVTVac3l1NE5FWUNsWjdaUVFE?=
 =?utf-8?B?TEpyNTV4cnhrSUxMOThhalNQRmxkM1N4Z29NMXY1a1NIcHkzZlBiZXVNTFY3?=
 =?utf-8?B?WGx6WlR1RVl4T1NpQlkwWmxZaVBWWnlTWW1NOHY1RVpiNlBSNlBtV3RVcEJa?=
 =?utf-8?B?bmtWQTNONEJaeS85bmpncHA1VVVSWWdGTy9rYUs5NnZ4eGpqYTFrL3lxYzZs?=
 =?utf-8?B?bHpmK3NSZHc2a1pBb0JCZ1g3eXVnNktscnY1cTU0QW9OeXNPejBIbUJyY2FP?=
 =?utf-8?B?aGhMOVJ4dEVzYUFKK3Z6c2VGdkswejBzZkVPbG0rdU9XbStIemZCL29JU0ZJ?=
 =?utf-8?B?czBOT0xzTmFlQ1dRWlJTWjlRTVRsdzNHcHhUTndMenRQWlorN0JKTDZxQzF5?=
 =?utf-8?B?WTJDZmNySUhEdTB1bmNXNDg1c0loNlRpQWduOFd3OGF5cHVJTXora29uSk4w?=
 =?utf-8?B?MjVyZVJ5WTlZc2xyL1dhemFJWGpyK2Rrb1N6SUNJbDV0U2VDRHhiaGhjVFZa?=
 =?utf-8?B?eFhXbThxZXNMVDFFcXhiZHNDU3hWTTVFZVQyQXhrMjM0aVJRYXB5Z0s0L2dO?=
 =?utf-8?B?UGJmOTh2M1EwQVFnT2dYNmlZUnV1eGNPQkUzbWtTWk96Mlhjbk5BUDA2Nm9H?=
 =?utf-8?B?VnpJSDdjYzVjTzRnZkRINFdjNmFPTURNcHp5OUkveTJVQ3JzTUVoNjVyNDFW?=
 =?utf-8?Q?QZjUOJKipGfdcGSfvDnNuSNNm7RXWgh3B6xu2LT?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a5a9290-24a7-4946-a96c-08d93234ea6b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2351.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 08:41:50.4237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zjHZYXif1gkxDQeFAQD+vbsUa3GFsqujrfjUz0AAIQy7s/t+YAEDEGRGJ9kt3j/CV/k+ZynTO96Dxv8XKR0fQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-Proofpoint-GUID: 7sV4fNZJvaptb77gsNElCDByhnusJDUE
X-Proofpoint-ORIG-GUID: 7sV4fNZJvaptb77gsNElCDByhnusJDUE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-18_04:2021-06-15,2021-06-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106180048
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/18/21 11:29 AM, Yongji Xie wrote:
> On Thu, Jun 17, 2021 at 4:34 PM He Zhe <zhe.he@windriver.com> wrote:
>>
>>
>> On 6/15/21 10:13 PM, Xie Yongji wrote:
>>> Increase the recursion depth of eventfd_signal() to 1. This
>>> is the maximum recursion depth we have found so far, which
>>> can be triggered with the following call chain:
>>>
>>>     kvm_io_bus_write                        [kvm]
>>>       --> ioeventfd_write                   [kvm]
>>>         --> eventfd_signal                  [eventfd]
>>>           --> vhost_poll_wakeup             [vhost]
>>>             --> vduse_vdpa_kick_vq          [vduse]
>>>               --> eventfd_signal            [eventfd]
>>>
>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
>>> Acked-by: Jason Wang <jasowang@redhat.com>
>> The fix had been posted one year ago.
>>
>> https://lore.kernel.org/lkml/20200410114720.24838-1-zhe.he@windriver.com/
>>
> OK, so it seems to be a fix for the RT system if my understanding is
> correct? Any reason why it's not merged? I'm happy to rebase my series
> on your patch if you'd like to repost it.

It works for both mainline and RT kernel. The folks just reproduced in their RT
environments.

This patch somehow hasn't got maintainer's reply, so not merged yet.

And OK, I'll resend the patch.

>
> BTW, I also notice another thread for this issue:
>
> https://lore.kernel.org/linux-fsdevel/DM6PR11MB420291B550A10853403C7592FF349@DM6PR11MB4202.namprd11.prod.outlook.com/T/

This is the same way as my v1

https://lore.kernel.org/lkml/3b4aa4cb-0e76-89c2-c48a-cf24e1a36bc2@kernel.dk/

which was not what the maintainer wanted.


>
>>> ---
>>>  fs/eventfd.c            | 2 +-
>>>  include/linux/eventfd.h | 5 ++++-
>>>  2 files changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/eventfd.c b/fs/eventfd.c
>>> index e265b6dd4f34..cc7cd1dbedd3 100644
>>> --- a/fs/eventfd.c
>>> +++ b/fs/eventfd.c
>>> @@ -71,7 +71,7 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
>>>        * it returns true, the eventfd_signal() call should be deferred to a
>>>        * safe context.
>>>        */
>>> -     if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count)))
>>> +     if (WARN_ON_ONCE(this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH))
>>>               return 0;
>>>
>>>       spin_lock_irqsave(&ctx->wqh.lock, flags);
>>> diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
>>> index fa0a524baed0..886d99cd38ef 100644
>>> --- a/include/linux/eventfd.h
>>> +++ b/include/linux/eventfd.h
>>> @@ -29,6 +29,9 @@
>>>  #define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>>>  #define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>>>
>>> +/* Maximum recursion depth */
>>> +#define EFD_WAKE_DEPTH 1
>>> +
>>>  struct eventfd_ctx;
>>>  struct file;
>>>
>>> @@ -47,7 +50,7 @@ DECLARE_PER_CPU(int, eventfd_wake_count);
>>>
>>>  static inline bool eventfd_signal_count(void)
>>>  {
>>> -     return this_cpu_read(eventfd_wake_count);
>>> +     return this_cpu_read(eventfd_wake_count) > EFD_WAKE_DEPTH;
>> count is just count. How deep is acceptable should be put
>> where eventfd_signal_count is called.
>>
> The return value of this function is boolean rather than integer.
> Please see the comments in eventfd_signal():
>
> "then it should check eventfd_signal_count() before calling this
> function. If it returns true, the eventfd_signal() call should be
> deferred to a safe context."

OK. Now that the maintainer comments as such we can use it accordingly,
though I still got the feeling that the function name and the type of the return
value don't match.


Thanks,
Zhe

>
> Thanks,
> Yongji


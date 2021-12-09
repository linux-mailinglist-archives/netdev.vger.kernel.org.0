Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5C946F28D
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242385AbhLIR7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:59:01 -0500
Received: from mail-eopbgr70135.outbound.protection.outlook.com ([40.107.7.135]:51515
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230223AbhLIR7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 12:59:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EdEbDef5uazH54ewwOa4L4CISAcjNRta3WZE6i23T/FqEoq8fYoDy9CyfIq5lTdtuFkLgxIRs6zyEVWHgig8Ngk06dntU9EjvyUOe13d2ZtJZoW0tdWL9Gn2emJLFUExlPOknO27YQttq34YQWOwTjqiH1m9vUDQw4YCRARPBY6VBbZnqL1CArSrZhNmVSw4Ot+plIog66BDw++6XOoIV1++hxCrSZPOI9kQ5+9+VKhHccmltV6WydCIOMieLSw8ubZv+LQqZgKKwDP1MKHxxhFH4j36/Gu56FKmjFJX8bghmuYGfNM1G3tALHZJdtm/CtKEyXGDk2ULEt5DETet3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zq03SRB85apPRgGo6HNDphynvfcveae1jXvw/eK4EnQ=;
 b=am6uSEk3MJRJ7DKEMYzk51JB+V1PHd/roiAqAwgv3wyPHPCW3eC5wLjY7oab1rUIG1z5LIAwpY1y5bGrWZouH1JlRL85KTSj7ZXP3bGi1o/O4ctYi6qvnoPC1E6ir/Dgabjs/QCTm1vJIq9CjnLIjO8ahL03jGtIvU2VN7ZV6WXjY0Jez0Vyij8A+Nf0VU/YOMZ4xCapmkp1gUqbA9CvVlTz3SLSc+E99iSI31Iw6Ls89fMUd4r+qWOy45Yf2kpIWBa58JFSIoIxa1aQsSVBsHLRHROt8Bt+jSfi8I58C4sG7n/dYeMevlh6Rqrz62JU800lbUzofdZM2Vk3PweV4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zq03SRB85apPRgGo6HNDphynvfcveae1jXvw/eK4EnQ=;
 b=YWrQkAFBu3WpPk4Kuk/af1BNHwQQSFul9axD9epI8mbAXHiIr7a50CJiG9aC/aRhYoFI1bnL8USR9AMEToCFiHGhmmMGBODAo8gsNkyj90Zc1236m+8Xkkp85HVqwylEc9CK0ZX0sCQJLfVaePg0AYC/ZdRc5F5bjUciDn30cpGLq4surSS2t2WnWzJ02T5gT02/KD2GU+s+lmoLD9ZyVHfTG3j7KcGm+y8vEDCdfG67oKSKYaBju92GsK8npjIl1Yz/NNqTein0CZr4xZ/sPYmroffKj2nnkC9QE1qJ96F4aQ+Ljre5nN7QhLEY3LjWSZ26zNaN1t75mgmbntgncA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB8PR06MB6249.eurprd06.prod.outlook.com (2603:10a6:10:109::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Thu, 9 Dec
 2021 17:55:22 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 17:55:22 +0000
Message-ID: <15676ff5-5c5c-fd06-308f-10611c01f6a9@eho.link>
Date:   Thu, 9 Dec 2021 18:55:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v1 bpf 1/1] libbpf: don't force user-supplied ifname
 string to be of fixed size
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211209120327.551952-1-emmanuel.deloget@eho.link>
 <CAEf4BzYJ+GPpjcMMYQM_BfQ1-aq6dz_JbF-m5meiCZ=oPbrM=w@mail.gmail.com>
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
In-Reply-To: <CAEf4BzYJ+GPpjcMMYQM_BfQ1-aq6dz_JbF-m5meiCZ=oPbrM=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0190.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::34) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from [IPV6:2a10:d780:2:104:f0f7:4b65:dc50:47a3] (2a10:d780:2:104:f0f7:4b65:dc50:47a3) by PR0P264CA0190.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 17:55:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c82fd07c-d1f1-44f0-9f71-08d9bb3d1225
X-MS-TrafficTypeDiagnostic: DB8PR06MB6249:EE_
X-Microsoft-Antispam-PRVS: <DB8PR06MB6249CEB790BD2458A123E381FA709@DB8PR06MB6249.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cPPNoEGdqqAdL0nqnZq3Mu5/j0lS/hoWNWMM8+vvcRTu2Ltip9I+fZELh+qIMhspGMCk5dVo9luoENmWnd7ioU0nKgmDoO+ZxlDFDNEQsqXAYR5tJBokqyIFWfk7W7E3Pm9Xrvox3MovqttiQRkvoWN8CQqadN6nYxfYzUK9VV70sI+pOKEfEkJuQketqOqVwfdRLACyyw/joVORhV0zaomqj3jdP8tsHPrubvJ+Up0gfNJ9JMhaOUQ7OkxE2L8jR4CA+c3LhcH6MdDREzpJOVR/yRN7efYerrRu68XRUXtjyMoxTNHQQOJZViClFf8yBka+Hmc+Xt6VWLR3Qt8JaSxaCpPDKL2MFN4TWOVpLzJZCQeGAOSA81uYHXTqdd0Kp3sxcUkuqC0sjc22cBVo76HyP5N56scKktp/mdiGPSBBmdmfqY+9GuoCZEQa91/sxEatBZRSAWajbosVdDH/Fz7Gh5+1odOL8LAyQP/N9eH3wmK+OneoNA68IKU55d2MyYXtalrK/RKUvh6kfP0EWDiA6ycumxz8A17pUqgvOqT6S1KSwJZ9BzfCrKy31RkdoObX/Sb/aXCQ9fKlY0xqypAIVk1f94YDWysur8z0zltlw1qZTbyFUF9vackk1LiZEo1hQAQlkfV+jMee1f2rKSXTL+L9rAE5mGm1hlxP2dMpf23arzBjp4nvOx0ntIjsJTXCGydb3OkzyYWLJjSxprnkNZrL7xJZKmfLw21BBU4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(346002)(39830400003)(86362001)(7416002)(6916009)(31696002)(186003)(36756003)(83380400001)(66476007)(66556008)(66946007)(53546011)(2616005)(2906002)(6486002)(5660300002)(52116002)(44832011)(38100700002)(8936002)(31686004)(4326008)(54906003)(8676002)(508600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmYxQTUybnR0YnJYaDhFMEFIVlNOeEtsbzVGUS9udGFhNEZtREUzMXRxeEM3?=
 =?utf-8?B?ZnF1ZGlqRzU2bVRlRGtodTNCaUU4K3drQTZKSFA2c2FYa1NtcVg1Mk1kdzln?=
 =?utf-8?B?M25EMkNQSHpMWTdhTUR4TFNoZ01pRWR4V0t2MFRoclVzd3pSZ2NzS1g2cmgr?=
 =?utf-8?B?QlE5MDd6Z0RTUFNRdnRtUThPc2lReVpZczBpdURBV0xQcEMzVHJjR1JaV3FP?=
 =?utf-8?B?M2x6eU42eTNueGF4aUxMWlBKMFZjVmZaS2JoUWhYMXFJZXE1ZE5VYnJmSzJh?=
 =?utf-8?B?V3hKREtONGJ4US8wOURMN1d2QnJ0MEJmdXhpVkZ4L1RSTjc5N2UwLy9YRW9x?=
 =?utf-8?B?ME9pd0RKdTFpaTlUSFRMREwwcDZQdVdaWVdRczIzekxVVnFibU9rZlA0ZklB?=
 =?utf-8?B?WVVwNUJoT2tPK0xhTWM2KzhObGJhaWUzR2xPRVJHeElsNDVPYXlxZ1ZEZHF5?=
 =?utf-8?B?akQ0MWEzZFQ3a21QbXhpWlFFWUNmVWkvOGU5UEY4ZWllQ00rMGxkWDl1cUpH?=
 =?utf-8?B?NDU3QWdzMTloYXJsZ0dVbXgwRG0zYVNUdmt0bXpwcUVWS3d5NkpaUlJjcVZU?=
 =?utf-8?B?QldHbU9nOG52SUxqTlkxZy8yS00wYVAvNHNGYW5JbFdIa0wvcUc1QWorcTRW?=
 =?utf-8?B?MWZXNnRhYjZJalhqRHNDci9uOFJZelBzRnIxK2lIWkUyZ2FIUDZldEE1SCsy?=
 =?utf-8?B?QzNxaytzMTZXOEJ6M1RPcjNreXMzQVg3UzV6WGhnQlQ0Q0NQZzM1YlBMSkZo?=
 =?utf-8?B?US9kY2JsbHhEdFZKaERGVGliWkJKcVRWWkxaczJJdXUzQVhkbnhIZFdxbHR5?=
 =?utf-8?B?U1R1V0RrY002OEtIT2NjTEdIQndPaXR2Z2dJcjNMRkxZaFVhRmxXMVU1WW9L?=
 =?utf-8?B?REY2N0VzWmJkSzR1NzdOSzN5Ni9LYy8zSGtYamdMdDYwbDNCWnBKS1puc05z?=
 =?utf-8?B?d2tnd1YvQzdwZUtlbXlZM1pKQitvb1JRcGg2LzlqaE5FMHdMNWVCMXYzVWl0?=
 =?utf-8?B?a3k0aFpXUmNaN2JUL01KRXZtaWpNRS9GM0NTd0NQRTJzcjJuNk1Xc0k2SDd1?=
 =?utf-8?B?Sm9oRDA0bXlFUjdQWG9JdnNEUUlseWpFbkNWc2xuaFZKNFJRTWpWNFg0SUVI?=
 =?utf-8?B?Z01NTXZYUHBPOHgzMC9ZaE04bnpGOHphaUg3RUVGUGVTSlhiNksvL2ZUWjNH?=
 =?utf-8?B?NTlncWppWlVtZWpnUXdYeHJjUHRsQzhlL2pFdkFUSHRJYnppc09vcXNrOER3?=
 =?utf-8?B?bXZFUjF4Qi9tUVRyL1dVcXNsNHM0VlRjRjJvdnJ4d3ZreHhHczM0OGlHMElp?=
 =?utf-8?B?TmltZC91bVQ0RXUyeXNRY00xbHNITTkvZytFbnNrVnZOZHdRS2VUdXpvMlBi?=
 =?utf-8?B?bkVRY0d5clBYSTVnVkFBWHloUytKTzMrRDBGbENMTU9WVXZRNWRCZ0dhd2pV?=
 =?utf-8?B?d0xBQ0FXMHBNWjAzQWM5WUFabllDVXNFVlNRYWtTUFlSbE95RkE4QlkzZlBE?=
 =?utf-8?B?M0ZaUkJ2bG9iWGFqWTY3bHFIaThLNE4vQkpPcVVPQ3RoNkZKNG5wY3V2WEUy?=
 =?utf-8?B?eDdMNmMyYzBEdnVPN0xtc0UxeENSbUZieitzam53K0E5YnhMSGNCZzVoUjZC?=
 =?utf-8?B?eklyTmNGUzREakxwYnZXcHpnRENhYysray9KS0dZaE5jY1FFRUEvMVVTaWdy?=
 =?utf-8?B?VndaZUc2NWxZKzJVdkhUcERMaVNXU1Y4QTFzSjRuRDNZWVI0bkJwZ04yN3Vo?=
 =?utf-8?B?eUVlL0E2OHNVN01QSE5tcGlDRFNZdjFQWlVYTnZnVWIyMmJqS2REbFM5RTdt?=
 =?utf-8?B?cGVscVZOV2Zya2IycDVlOGhRVHJtdmwrRHBtUHA4TFdZNm9CUy84YUwyQSsy?=
 =?utf-8?B?Q1hDYk9abDUxdjd6MUNCdUI5LzUyNUpmMVJEdW9jbjRhVlo5L0tneURaOXBx?=
 =?utf-8?B?UUlLaDVrV09TUWNNclNiSmQrK0NQdEhHK3BSMXNaYXduYzRWb2s5aEE2blo1?=
 =?utf-8?B?VUpPa0NXVnRaSFAzaVdPUTZOTGZZNWRSTzZ0Q296anpwb0JmNm1xK2UzWFpP?=
 =?utf-8?B?U1JxZ09sU2xvanovRkYxUnFyWWNQVFhyTXdSK2NnN1ZLRXZWdXd1RDY2QWNm?=
 =?utf-8?B?akh1VHdKTFlJZTgvaG5GNVdEaHQ0VGd6anRpUUhGbjlhYnVyMFE3Q2Z5MDQx?=
 =?utf-8?B?N2FWMDVjMnlQdzJrcUVQc2JlSVFaUDJVNVQ3WWEyL0Q3RU45Uk0yQ0RvVjlH?=
 =?utf-8?B?eWdTNGNCWmtIdFc2N3lIdGdYelJMdWtxT1VaUjU4S2ZVdzFNK1BTRXJ0N0Vo?=
 =?utf-8?B?NGVWSm1HUGJOMW1kUDBhaHZxMWJSQS9HaW12QjFzbm0vT0UvTHBsZz09?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: c82fd07c-d1f1-44f0-9f71-08d9bb3d1225
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 17:55:22.4696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPRkUR3SnDakpoA/I1o79uXr0FS9aYQ/1zdYpGq9f4Jr6SCmlRe6KMndkMtEWTbXODG0kqUZ9HoajKzzWXD2UB6L9aG2AdG0O5S67eRFg2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR06MB6249
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 09/12/2021 18:17, Andrii Nakryiko wrote:
> On Thu, Dec 9, 2021 at 4:03 AM Emmanuel Deloget
> <emmanuel.deloget@eho.link> wrote:
>>
>> When calling either xsk_socket__create_shared() or xsk_socket__create()
>> the user supplies a const char *ifname which is implicitely supposed to
>> be a pointer to the start of a char[IFNAMSIZ] array. The internal
>> function xsk_create_ctx() then blindly copy IFNAMSIZ bytes from this
>> string into the xsk context.
>>
>> This is counter-intuitive and error-prone.
>>
>> For example,
>>
>>          int r = xsk_socket__create(..., "eth0", ...)
>>
>> may result in an invalid object because of the blind copy. The "eth0"
>> string might be followed by random data from the ro data section,
>> resulting in ctx->ifname being filled with the correct interface name
>> then a bunch and invalid bytes.
>>
>> The same kind of issue arises when the ifname string is located on the
>> stack:
>>
>>          char ifname[] = "eth0";
>>          int r = xsk_socket__create(..., ifname, ...);
>>
>> Or comes from the command line
>>
>>          const char *ifname = argv[n];
>>          int r = xsk_socket__create(..., ifname, ...);
>>
>> In both case we'll fill ctx->ifname with random data from the stack.
>>
>> In practice, we saw that this issue caused various small errors which,
>> in then end, prevented us to setup a valid xsk context that would have
>> allowed us to capture packets on our interfaces. We fixed this issue in
>> our code by forcing our char ifname[] to be of size IFNAMSIZ but that felt
>> weird and unnecessary.
> 
> I might be missing something, but the eth0 example above would include
> terminating zero at the right place, so ifname will still have
> "eth0\0" which is a valid string. Yes there will be some garbage after
> that, but it shouldn't matter. It could cause ASAN to complain about
> reading beyond allocated memory, of course, but I'm curious what
> problems you actually ran into in practice.

I cannot be extremely precise on what was happening as I did not 
investigate past this (and this fixes our issue) but I suspect that 
having weird bytes in ctx->ifname polutes ifr.ifr_name as initialized in 
xsk_get_max_queues(). ioctl(SIOCETHTOOL) was then giving us an error. 
Now, I haven't looked how the kernel implements this ioctl() so I'm not 
going to say that there is a problem here as well.

And since the issue is now about 2 weeks old it's now a bit murky - and 
I don't have much time to put myself in the same setup in order to 
produce a better investigation (sorry for that).

>>
>> Fixes: 2f6324a3937f8 (libbpf: Support shared umems between queues and devices)
>> Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
>> ---
>>   tools/lib/bpf/xsk.c | 7 +++++--
>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index 81f8fbc85e70..8dda80bcefcc 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -944,6 +944,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>>   {
>>          struct xsk_ctx *ctx;
>>          int err;
>> +       size_t ifnamlen;
>>
>>          ctx = calloc(1, sizeof(*ctx));
>>          if (!ctx)
>> @@ -965,8 +966,10 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>>          ctx->refcount = 1;
>>          ctx->umem = umem;
>>          ctx->queue_id = queue_id;
>> -       memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
>> -       ctx->ifname[IFNAMSIZ - 1] = '\0';
>> +
>> +       ifnamlen = strnlen(ifname, IFNAMSIZ);
>> +       memcpy(ctx->ifname, ifname, ifnamlen);
> 
> maybe use strncpy instead of strnlen + memcpy? keep the guaranteed
> zero termination (and keep '\0', why did you change it?)

Well, strncpy() calls were replaced by memcpy() a while ago (see 
3015b500ae42 (libbpf: Use memcpy instead of strncpy to please GCC) for 
example but there are a few other examples ; most of the changes were 
made to please gcc8) so I thought that it would be a bad idea :). What 
would be the consensus on this?

Regarding '\0', I'll change that.

> Also, note that xsk.c is deprecated in libbpf and has been moved into
> libxdp, so please contribute a similar fix there.

Will do.

>> +       ctx->ifname[IFNAMSIZ - 1] = 0;
>>
>>          ctx->fill = fill;
>>          ctx->comp = comp;
>> --
>> 2.32.0
>>

BTW, is there a reason why this patch failed to pass the bpf/vmtest-bpf 
test on patchwork?

Best regards,

-- Emmanuel Deloget

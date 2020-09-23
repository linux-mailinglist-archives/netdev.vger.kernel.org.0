Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392D4274F91
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIWDbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:31:03 -0400
Received: from mail-eopbgr750073.outbound.protection.outlook.com ([40.107.75.73]:11182
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbgIWDbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 23:31:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvczGEK0drIVVZyT2anyxqCbY+zH6zk306wIXnR1ZrP37MAFhdY39DLw5vnhzBHpQA3BDwuvOYpFVvEcULd1oSDcyINz5DQIbT24KyH7w5XOMdo82Yv9W93u9SsrkYn5YL+S5DLg6rPjS0nVedIEqrNbK0FmdKV7LGXkLCZwZc2VrjPfVxCQtFcwL2GwA3lcnvRY8wML7xc/r0aR0aLVw6pT8zmVV6sL1i44KsZoywgP4ldQuNPgl/0+INRsNgH3Dcyp5ouQwx/SrKn73KxRniP5epUsJFtvcgQqGyHuUp2SHnbPIzwmmiRaCBECd/LefzBnwgmaQ7/WRpGbI346kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58CJHIL6h7C5/Q5VMumZ9/xrDNBYT75w3UxS+wJotOk=;
 b=UlDkAfsb6BhWWk6bzft0jxq2Tkzo4NkjghiqWxkYahx1UcvEiS7AwG0xv0FkPRHHA0H6x+xYJYP21Efp4MLYHpuvX+dokXbDh9OMbqLq89jXsHzueFOzzAO95ybz3tSiAJGeTTc5LmPpYZREHL51TKLYUNSVtdHWG+ALKQZtLEuqbCp6G9dRHnWWpqsJ2M/yqw4AOwoGAH87MSU+NnLreRFbCYwVZlm9IFhZe9hNNBIi3ch/PL4GqMrLMn397lKPM/XIoSG18530gsTXc+gJkrp3VsLy7xUEwydMHT4pm3OtZUCQz+xOHoYyvvCbvNBNzsbwzKQhBqi6l5CRKgYXEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58CJHIL6h7C5/Q5VMumZ9/xrDNBYT75w3UxS+wJotOk=;
 b=kaRfdNI9ylfVHI/i2UDsMvJ2/REvO0Ds9qBhrHoH31Q3WcpZRRzDLrXcblMIs4VwPsKE48SVVuDFG4epljBJlSb7/ibJvZEhVpdv1dQ0JyRPSAP1Tg8+vcVMYeB+x/fC7sK9NwTRrkyb7UYeue96iH9gsYi/mNRJHEu9URQgMuw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from SN6PR11MB3360.namprd11.prod.outlook.com (2603:10b6:805:c8::30)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Wed, 23 Sep
 2020 03:30:58 +0000
Received: from SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966]) by SN6PR11MB3360.namprd11.prod.outlook.com
 ([fe80::4dbe:2ab5:9b68:a966%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 03:30:58 +0000
Subject: Re: [PATCH] SUNRPC: Fix svc_flush_dcache()
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <160063136387.1537.11599713172507546412.stgit@klimt.1015granger.net>
 <07c27f89-187b-69a3-fd40-f9beef29da40@windriver.com>
 <EFDE7D43-5E0D-4484-9B8C-CBED30EA4E04@oracle.com>
From:   He Zhe <zhe.he@windriver.com>
Message-ID: <15694751-066e-18de-85d6-c47635a28225@windriver.com>
Date:   Wed, 23 Sep 2020 11:30:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <EFDE7D43-5E0D-4484-9B8C-CBED30EA4E04@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0026.apcprd03.prod.outlook.com
 (2603:1096:203:c9::13) To SN6PR11MB3360.namprd11.prod.outlook.com
 (2603:10b6:805:c8::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.175] (60.247.85.82) by HKAPR03CA0026.apcprd03.prod.outlook.com (2603:1096:203:c9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.7 via Frontend Transport; Wed, 23 Sep 2020 03:30:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f24a2fad-4cd9-4e37-4b59-08d85f71164d
X-MS-TrafficTypeDiagnostic: SA0PR11MB4672:
X-Microsoft-Antispam-PRVS: <SA0PR11MB46726479BD35FCF1DA728FD38F380@SA0PR11MB4672.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmV8YT1hqDcRMjor86Zw7fkZgMrUXdv/SSwQnCEqUcbzwpHs+TBGR04j2tmgNqcsMVjZdJwXferU/8nCCDDNcCzeBL5AuzWCwByrGuht9XH/HkD557zNYi27vjKN3BUACp0SlDSrTdc29Ncp0H7NmWnP47xuNqTdZ0dpQsODhbYFBXn3RlRR4y/qojmqOkaafk2+g1BgcZxDwLJcfX9shoDQlahK7fM+NDRuiT7USyw0KZJYKe9uPB7n47SjUvm0CQldsuCL27/voaAsHWdH92AEd86UL33Z1uZi0ZA1Fa4zVvvd29RO/jPQ7H/aihJzLL6cwivqNKVo+PYtapwSsEZUGrSsZTOvr4KZeH/x2P7xu/A2pLbdkoD9XYqeUjxVtpzFgzHfprVibwywoYXK9b6Q4YM+GNE0Aq9ktUg8W8Cq8I6gCIfcxu2crrOkEgKxAhjODeW5SOUxBwVBVKE6Og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3360.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(39850400004)(396003)(376002)(366004)(6916009)(31686004)(6706004)(66946007)(31696002)(66556008)(66476007)(54906003)(2906002)(86362001)(5660300002)(4326008)(83380400001)(52116002)(8936002)(6666004)(16526019)(8676002)(26005)(186003)(16576012)(316002)(36756003)(6486002)(53546011)(478600001)(956004)(2616005)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rVt06r+fwO0BEFzyJykljng8nOimfgU4uo3/oU/dJ4zcM133/rBGbiRA7GV4P6588Kf/6+NYCXCxJRJZTOgE5BF+ngEo8pmNeNf1Cuj8BbWtPjRkFQxoojcZYGf1/mvSqil/4OEc2eN0KQWH8KJwfym4yrMYnHM/JS1HIRLYb5AWfLCA8xpS6jyMOkRFQ+umUT2oKXhe4mQvN6ptaE6zJXbJ1TE+DIYw86R+3TmxgTQs5QWsTwpxv8bSFNPawO1ZQ9B6NI8ITIgN77hC1+pDA3JRRP8+mcJKsba7ehVlrdBAqII2ur3F708QLxhLUnWaR+PCett1PJ5Jr8dWd8DEF4fjIYgsxSYZmN0dNcogc9AXCCSGuQLBtW8yfHRJIE3ijGZ5t6Xr2kGw1YXTaL1E+chdCnMBk5bzGDVuHStfOudoUQcscHJYon8kAgFvxabcbjghW/LJqPcJkMFvxovhAoAU00Ldf1D30ww/IQygfXL/kFhU6MPD0I4FuzRYoHACxoyJmXXtjPYO0Q9gBW7roHP97W99vc4KrO2UWVK3UB/P1YW0xqwPLT/cJD1wDwUnTKK+IR8cDVofzRZ3a8iwfQrLgcWgoXflaMVc539E7cIapElRO1GBNRX2F8i1Xest1GaMJZNH5iL4qsQCWgj5Bg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f24a2fad-4cd9-4e37-4b59-08d85f71164d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3360.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2020 03:30:58.5681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYFqldtcNXRX1qpG/oCjG8NyZ7NpqpX+zSWodfqMITxle0tmKUeIG8kr0wMPdH6EWAnZtFa8JRfYNSbtxKr4Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/20 10:14 PM, Chuck Lever wrote:
>
>> On Sep 22, 2020, at 3:13 AM, He Zhe <zhe.he@windriver.com> wrote:
>>
>>
>>
>> On 9/21/20 3:51 AM, Chuck Lever wrote:
>>> On platforms that implement flush_dcache_page(), a large NFS WRITE
>>> triggers the WARN_ONCE in bvec_iter_advance():
>>>
>>> Sep 20 14:01:05 klimt.1015granger.net kernel: Attempted to advance past end of bvec iter
>>> Sep 20 14:01:05 klimt.1015granger.net kernel: WARNING: CPU: 0 PID: 1032 at include/linux/bvec.h:101 bvec_iter_advance.isra.0+0xa7/0x158 [sunrpc]
>>>
>>> Sep 20 14:01:05 klimt.1015granger.net kernel: Call Trace:
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_tcp_recvfrom+0x60c/0x12c7 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? bvec_iter_advance.isra.0+0x158/0x158 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? del_timer_sync+0x4b/0x55
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  svc_recv+0x1193/0x15e4 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? try_to_freeze.isra.0+0x6f/0x6f [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? refcount_sub_and_test.constprop.0+0x13/0x40 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_xprt_put+0x1e/0x29f [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? svc_send+0x39f/0x3c1 [sunrpc]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  nfsd+0x282/0x345 [nfsd]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? __kthread_parkme+0x74/0xba
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  kthread+0x2ad/0x2bc
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? nfsd_destroy+0x124/0x124 [nfsd]
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? test_bit+0x1d/0x27
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ? kthread_mod_delayed_work+0x115/0x115
>>> Sep 20 14:01:05 klimt.1015granger.net kernel:  ret_from_fork+0x22/0x30
>>>
>>> Reported-by: He Zhe <zhe.he@windriver.com>
>>> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>> ---
>>> net/sunrpc/svcsock.c |    2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> Hi Zhe-
>>>
>>> If you confirm this fixes your issue and there are no other
>>> objections or regressions, I can submit this for v5.9-rc.
>> I don't quite get why we add "seek" to "size". It seems this action does not
>> reflect the actual scenario and forcedly neutralizes the WARN_ONCE check in
>> bvec_iter_advance, so that it may "advance past end of bvec iter" and thus
>> introduces overflow.
>> Why don't we avoid this problem at the very begginning like my v1? That is, call
>> svc_flush_bvec only when we have received more than we want to seek.
>>
>>         len = sock_recvmsg(svsk->sk_sock, &msg, MSG_DONTWAIT);
>> -       if (len > 0)
>> +       if (len > 0 && (size_t)len > (seek & PAGE_MASK))
>>                 svc_flush_bvec(bvec, len, seek);
> Because this doesn't fix the underlying bug that triggered the
> WARN_ONCE.
>
> svc_tcp_recvfrom() attempts to assemble a possibly large RPC Call
> from a sequence of sock_recvmsg's.
>
> @seek is the running number of bytes that has been received so
> far for the RPC Call we are assembling. @size is the number of
> bytes that was just received in the most recent sock_recvmsg.
>
> We want svc_flush_bvec to flush just the area of @bvec that
> hasn't been flushed yet.
>
> Thus: the current size of the partial Call message in @bvec is
> @seek + @size. The starting location of the flush is
> @seek & PAGE_MASK. This aligns the flush so it starts on a page
> boundary.
>
> This:
>
>  230         struct bvec_iter bi = {
>  231                 .bi_size        = size + seek,
>  232         };
>
>  235         bvec_iter_advance(bvec, &bi, seek & PAGE_MASK);
>
> advances the bvec_iter to the part of @bvec that hasn't been
> flushed yet.
>
> This loop:
>
>  236         for_each_bvec(bv, bvec, bi, bi)
>  237                 flush_dcache_page(bv.bv_page);
>
> flushes each page starting at that point to the end of the bytes
> that have been received so far
>
> In other words, ca07eda33e01 was wrong because it always flushed
> the first section of @bvec, never the later parts of it.

Thanks for clarification. I just tested the patch. It works well.

Zhe

>
>
>> Regards,
>> Zhe
>>
>>>
>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>> index d5805fa1d066..c2752e2b9ce3 100644
>>> --- a/net/sunrpc/svcsock.c
>>> +++ b/net/sunrpc/svcsock.c
>>> @@ -228,7 +228,7 @@ static int svc_one_sock_name(struct svc_sock *svsk, char *buf, int remaining)
>>> static void svc_flush_bvec(const struct bio_vec *bvec, size_t size, size_t seek)
>>> {
>>> 	struct bvec_iter bi = {
>>> -		.bi_size	= size,
>>> +		.bi_size	= size + seek,
>>> 	};
>>> 	struct bio_vec bv;
> --
> Chuck Lever
>
>
>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73FC2AC5BD
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgKIUKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbgKIUKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:10:09 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C08C0613CF;
        Mon,  9 Nov 2020 12:10:08 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id b8so10168485wrn.0;
        Mon, 09 Nov 2020 12:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZVbyXnbU5n/aHOYJO0y2okfOYm98zAlj3EYrx97isEM=;
        b=gF64r5wBfXsYTjGy1Wttf+h+D1lw5kwkfqri5uVIKZqRRoUGrckQzPfzJDjXw08n3T
         frS7Ds1edT0QINbGqqLInCXuDcBHqAyeKyrkEskSOUJTzfpMa3tQ9r++WONR0lyYzELb
         OT21LbXcCMCUdTNp0De84BDuCJ15CAAo2mBiAYpZTGtS87KIEORhdnFSnozppsd2BWYj
         qZMxQr19xY9FITQ4IA8eW2H1q4jB81Re26933OtYTN1e4thNE49i+qUHwSezeZNfV9qT
         PmSgjBCzk/0UeJTe4Lh7MEGi3SA8dCVVnEt4YrB9+c7mi7pIXILNKmAIJmxelUhdxjMy
         sP7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZVbyXnbU5n/aHOYJO0y2okfOYm98zAlj3EYrx97isEM=;
        b=kAkeoAYMvwsB5qxOMd5eNbPowbtTbDWu2KlYx9zYlohovl/TfpWQXDt45hpFBUiY0R
         6Sum+EFZ8bTgPRPmYKYHWmmrJMf21gUQpE40huKmCAFmaclwIR0M9GvOO1UBUgTJxsWZ
         9tl3NbNVgkWZF6hg4Wv6ylyhOdmCYSNt3LtxHYZ1mdTGiFhqQMiJvJu3Zu1S+xhAW5vf
         IGTe4OuPKXl+k59qFmRrGLk+L8Kv0viPGMzd3zIwuwh4jbvIqRoetwfsGqNkjSadau2Y
         3pHtO2VCObtBSsviCsQD2FsjKqPtEeWh6MlULo+6IOquPxS7yr5aSQWOz40/srG06U81
         PgeA==
X-Gm-Message-State: AOAM532PUzERDz0QQVGDd87cz+WnwYkV+cVabXKfyTQltRzU4Mncj7n6
        oa+GkjvVJWgEDZPpJlW5P3z64/hAMyc=
X-Google-Smtp-Source: ABdhPJzvOG4imT75p06zDGaIRbbYxKZ5lxA48bWNE3pHxkjN2n5wIRysvhKSzYpYrNubTA3X6spLTQ==
X-Received: by 2002:adf:fb12:: with SMTP id c18mr18960179wrr.99.1604952607432;
        Mon, 09 Nov 2020 12:10:07 -0800 (PST)
Received: from [192.168.8.114] ([37.170.31.34])
        by smtp.gmail.com with ESMTPSA id s8sm10396730wrn.33.2020.11.09.12.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 12:10:06 -0800 (PST)
Subject: Re: [PATCH RFC] SUNRPC: Use zero-copy to perform socket send
 operations
To:     Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trondmy@hammerspace.com>
Cc:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <160493771006.15633.8524084764848931537.stgit@klimt.1015granger.net>
 <9ce015245c916b2c90de72440a22f801142f2c6e.camel@hammerspace.com>
 <0313136F-6801-434F-8304-72B9EADD389E@oracle.com>
 <f03dae6d36c0f008796ae01bbb6de3673e783571.camel@hammerspace.com>
 <5056C7C7-7B26-4667-9691-D2F634C02FB1@oracle.com>
 <3194609c525610dc502d69f11c09cff1c9b21f2d.camel@hammerspace.com>
 <A3D0FF41-D88F-4116-AD47-AF9C94B1D984@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <47630f20-c596-6cdc-2eed-7e0ad1137292@gmail.com>
Date:   Mon, 9 Nov 2020 21:10:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <A3D0FF41-D88F-4116-AD47-AF9C94B1D984@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 8:31 PM, Chuck Lever wrote:
> 
> 
>> On Nov 9, 2020, at 1:16 PM, Trond Myklebust <trondmy@hammerspace.com> wrote:
>>
>> On Mon, 2020-11-09 at 12:36 -0500, Chuck Lever wrote:
>>>
>>>
>>>> On Nov 9, 2020, at 12:32 PM, Trond Myklebust <
>>>> trondmy@hammerspace.com> wrote:
>>>>
>>>> On Mon, 2020-11-09 at 12:12 -0500, Chuck Lever wrote:
>>>>>
>>>>>
>>>>>> On Nov 9, 2020, at 12:08 PM, Trond Myklebust
>>>>>> <trondmy@hammerspace.com> wrote:
>>>>>>
>>>>>> On Mon, 2020-11-09 at 11:03 -0500, Chuck Lever wrote:
>>>>>>> Daire Byrne reports a ~50% aggregrate throughput regression
>>>>>>> on
>>>>>>> his
>>>>>>> Linux NFS server after commit da1661b93bf4 ("SUNRPC: Teach
>>>>>>> server
>>>>>>> to
>>>>>>> use xprt_sock_sendmsg for socket sends"), which replaced
>>>>>>> kernel_send_page() calls in NFSD's socket send path with
>>>>>>> calls to
>>>>>>> sock_sendmsg() using iov_iter.
>>>>>>>
>>>>>>> Investigation showed that tcp_sendmsg() was not using zero-
>>>>>>> copy
>>>>>>> to
>>>>>>> send the xdr_buf's bvec pages, but instead was relying on
>>>>>>> memcpy.
>>>>>>>
>>>>>>> Set up the socket and each msghdr that bears bvec pages to
>>>>>>> use
>>>>>>> the
>>>>>>> zero-copy mechanism in tcp_sendmsg.
>>>>>>>
>>>>>>> Reported-by: Daire Byrne <daire@dneg.com>
>>>>>>> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209439
>>>>>>> Fixes: da1661b93bf4 ("SUNRPC: Teach server to use
>>>>>>> xprt_sock_sendmsg
>>>>>>> for socket sends")
>>>>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>>>>> ---
>>>>>>>  net/sunrpc/socklib.c  |    5 ++++-
>>>>>>>  net/sunrpc/svcsock.c  |    1 +
>>>>>>>  net/sunrpc/xprtsock.c |    1 +
>>>>>>>  3 files changed, 6 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> This patch does not fully resolve the issue. Daire reports
>>>>>>> high
>>>>>>> softIRQ activity after the patch is applied, and this
>>>>>>> activity
>>>>>>> seems to prevent full restoration of previous performance.
>>>>>>>
>>>>>>>
>>>>>>> diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
>>>>>>> index d52313af82bc..af47596a7bdd 100644
>>>>>>> --- a/net/sunrpc/socklib.c
>>>>>>> +++ b/net/sunrpc/socklib.c
>>>>>>> @@ -226,9 +226,12 @@ static int xprt_send_pagedata(struct
>>>>>>> socket
>>>>>>> *sock, struct msghdr *msg,
>>>>>>>         if (err < 0)
>>>>>>>                 return err;
>>>>>>>  
>>>>>>> +       msg->msg_flags |= MSG_ZEROCOPY;
>>>>>>>         iov_iter_bvec(&msg->msg_iter, WRITE, xdr->bvec,
>>>>>>> xdr_buf_pagecount(xdr),
>>>>>>>                       xdr->page_len + xdr->page_base);
>>>>>>> -       return xprt_sendmsg(sock, msg, base + xdr-
>>>>>>>> page_base);
>>>>>>> +       err = xprt_sendmsg(sock, msg, base + xdr->page_base);
>>>>>>> +       msg->msg_flags &= ~MSG_ZEROCOPY;
>>>>>>> +       return err;
>>>>>>>  }
>>>>>>>  
>>>>>>>  /* Common case:
>>>>>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>>>>>> index c2752e2b9ce3..c814b4953b15 100644
>>>>>>> --- a/net/sunrpc/svcsock.c
>>>>>>> +++ b/net/sunrpc/svcsock.c
>>>>>>> @@ -1176,6 +1176,7 @@ static void svc_tcp_init(struct
>>>>>>> svc_sock
>>>>>>> *svsk,
>>>>>>> struct svc_serv *serv)
>>>>>>>                 svsk->sk_datalen = 0;
>>>>>>>                 memset(&svsk->sk_pages[0], 0, sizeof(svsk-
>>>>>>>> sk_pages));
>>>>>>>  
>>>>>>> +               sock_set_flag(sk, SOCK_ZEROCOPY);
>>>>>>>                 tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
>>>>>>>  
>>>>>>>                 set_bit(XPT_DATA, &svsk->sk_xprt.xpt_flags);
>>>>>>> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
>>>>>>> index 7090bbee0ec5..343c6396b297 100644
>>>>>>> --- a/net/sunrpc/xprtsock.c
>>>>>>> +++ b/net/sunrpc/xprtsock.c
>>>>>>> @@ -2175,6 +2175,7 @@ static int
>>>>>>> xs_tcp_finish_connecting(struct
>>>>>>> rpc_xprt *xprt, struct socket *sock)
>>>>>>>  
>>>>>>>                 /* socket options */
>>>>>>>                 sock_reset_flag(sk, SOCK_LINGER);
>>>>>>> +               sock_set_flag(sk, SOCK_ZEROCOPY);
>>>>>>>                 tcp_sk(sk)->nonagle |= TCP_NAGLE_OFF;
>>>>>>>  
>>>>>>>                 xprt_clear_connected(xprt);
>>>>>>>
>>>>>>>
>>>>>> I'm thinking we are not really allowed to do that here. The
>>>>>> pages
>>>>>> we
>>>>>> pass in to the RPC layer are not guaranteed to contain stable
>>>>>> data
>>>>>> since they include unlocked page cache pages as well as
>>>>>> O_DIRECT
>>>>>> pages.
>>>>>
>>>>> I assume you mean the client side only. Those issues aren't a
>>>>> factor
>>>>> on the server. Not setting SOCK_ZEROCOPY here should be enough to
>>>>> prevent the use of zero-copy on the client.
>>>>>
>>>>> However, the client loses the benefits of sending a page at a
>>>>> time.
>>>>> Is there a desire to remedy that somehow?
>>>>
>>>> What about splice reads on the server side?
>>>
>>> On the server, this path formerly used kernel_sendpages(), which I
>>> assumed is similar to the sendmsg zero-copy mechanism. How does
>>> kernel_sendpages() mitigate against page instability?
>>
>> It copies the data. 🙂
> 
> tcp_sendmsg_locked() invokes skb_copy_to_page_nocache(), which is
> where Daire's performance-robbing memcpy occurs.
> 
> do_tcp_sendpages() has no such call site. Therefore the legacy
> sendpage-based path has at least one fewer data copy operations.
> 
> What is the appropriate way to make tcp_sendmsg() treat a bvec-bearing
> msghdr like an array of struct page pointers passed to kernel_sendpage() ?
> 


MSG_ZEROCOPY is only accepted if sock_flag(sk, SOCK_ZEROCOPY) is true,
ie if SO_ZEROCOPY socket option has been set earlier.



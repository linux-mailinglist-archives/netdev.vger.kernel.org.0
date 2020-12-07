Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B092D14C3
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgLGPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgLGPa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:30:56 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057DDC0617B0
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 07:30:16 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id y17so3739143wrr.10
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 07:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=30JlR8LoPyZrlzeEVzTals0j/Hp1YhgKcUquSFNFM9o=;
        b=io+c5w0Xg2SyICnmX3kUsLyOL9a5kCVV8+3Mnr+/zRsTv62oBhFzyXRoIiBctrPUAb
         ELIQIu1yuMjTxLKz042n0IaOCT3I8Y4eIOWQgNrMh/zXf222/crNrw8n7FGVSNw340fs
         E2oVwH4TSXHpOcuOrEzrUDQQTIreZMQFGx7dMsqcb/8mi2h1zcPtqDycEqnL+Bh67fOg
         8Ay+d/sOd6zAO/Yy9ezbfetUCzE377RqOQimPNnu3NRun2HUpfddpuugJObwQZPpO2TL
         LmA6pLthgq41dEqwkID4q6u5/UFAyAGX5E6vvaU2+F8w6f3i9WJ3F4r/9nGkVmyKqjJB
         L0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=30JlR8LoPyZrlzeEVzTals0j/Hp1YhgKcUquSFNFM9o=;
        b=nnddpl4zXqDwD+cQOvrg2KK2xNJZLqQ3U8CluSvu8f8pUQJCiX1/eNOclIEYrin7Fz
         IMuE5CHjQDh0apoH22XeEZDWJRpLAz1flazg68pg7DKYWm/4I4lzrN3JAIIwQAxcpeyh
         BYs8HVH/LU9qAO140v/x5Hw0mRJaTzHYu5zygHdtVLayfsXaARbWeGH0U6D2zTk5PqZG
         Fn7T1pyUlF0TCFYq6zKo3+NPheA/DL+qev9plAKHn+d7GSUFpJoLe8SZgZy6W3PrOq/2
         CyYFIJ+UCAanWgHHhIyOy4OUbwqfIlpRgr8VU65NAJkwhK3LVTe7v8nScBNc/hQtodZJ
         EfRw==
X-Gm-Message-State: AOAM533Mv0mitscIMXdyXpNeH82ojPfbAD5AavaFGVbK/UdT0EdBmh1H
        FauqtkoqgmfolPAoiqbSwzO7uA==
X-Google-Smtp-Source: ABdhPJzO/y5cxlsjxHbpukQCVBFyn1bk6Ih2FHjM9ejDgj363Fp1gY/sbxfz//+S2jOqqoTq5H44sQ==
X-Received: by 2002:a5d:6250:: with SMTP id m16mr20552083wrv.400.1607355014462;
        Mon, 07 Dec 2020 07:30:14 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id q73sm9175382wme.44.2020.12.07.07.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 07:30:13 -0800 (PST)
Date:   Mon, 7 Dec 2020 16:30:07 +0100
From:   Marco Elver <elver@google.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
Message-ID: <X85Kf6j0d5pyQS6E@elver.google.com>
References: <000000000000b4862805b54ef573@google.com>
 <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com>
 <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 07:01PM +0100, Eric Dumazet wrote:
> On 12/3/20 6:41 PM, Marco Elver wrote:
> 
> > One more experiment -- simply adding
> > 
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -207,7 +207,21 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> >  	 */
> >  	size = SKB_DATA_ALIGN(size);
> >  	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +	size = 1 << kmalloc_index(size); /* HACK */
> >  	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> > 
> > 
> > also got rid of the warnings. Something must be off with some value that
> > is computed in terms of ksize(). If not, I don't have any explanation
> > for why the above hides the problem.
> 
> Maybe the implementations of various macros (SKB_DATA_ALIGN and friends)
> hae some kind of assumptions, I will double check this.

I looked at some of these macros and am wondering why SKB_TRUESIZE()
uses SKB_DATA_ALIGN(sizeof(struct sk_buff)). Because I don't understand
how the memcaches that allocate sk_buff are aligned or somehow always
return SKB_DATA_ALIGN(sizeof(struct sk_buff)) sized objects -- a simple
BUG_ON(ksize(skb) != SKB_DATA_ALIGN(sizeof(struct sk_buff))) triggers.

Alas, doing something like:

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -235,7 +235,7 @@
 
 /* return minimum truesize of one skb containing X bytes of data */
 #define SKB_TRUESIZE(X) ((X) +						\
-			 SKB_DATA_ALIGN(sizeof(struct sk_buff)) +	\
+			 sizeof(struct sk_buff) +			\
 			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

does not fix the problem.

Still trying to debug, because I don't want this to block the SLUB
enablement of KFENCE, even if it turns out it's not KFENCE. :-/

Thanks,
-- Marco

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978F1EC53C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfKAPBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:01:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39043 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbfKAPBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:01:10 -0400
Received: by mail-io1-f68.google.com with SMTP id 18so11198997ion.6;
        Fri, 01 Nov 2019 08:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=TBAFKynpg7YBPsA6wf6JWHl/9/CPJW3b1igBgFWJV2E=;
        b=CBAVAwRe+WlT8H2FMtR7fWk5vsApB4R4Fwt0pkWz3jVBgDoAf7xIc4hFgWE9co51D1
         agHmBjbRRhQPERx3eNNhu8u7zrAfz93g8DrsNjDpY1GHf3Q9wX9b3iMRdA21d+/rjp46
         ShqjSRP0m8Nzp+YWNSoIaUQY7lDLge+zEDTJGu7AEJlo6HDf9IvBowg3yTniJoAy9ue6
         pAZUNfsVJzeCKVgKq73jsLXDDmWdN/3uM7IpSDC/Ip9lNuaAkhiilSzheW/js4+d7CGo
         DviEnYL7gSsf8xHlCt1okZSOpRuoHaSkwGHH/w8i7n961lQL+jdO2z7MDru+NagL+zex
         NxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=TBAFKynpg7YBPsA6wf6JWHl/9/CPJW3b1igBgFWJV2E=;
        b=MmSvCcCimzVT3OgD8P8vE0HPVGWuXBelas9lhW4oDLdLEGAiMG20RcOFvCXeW2tHDI
         vNtF/ZqONSvDzWId2AGM5yGn8xEiVyCSHKr2tK7wy7whEBTuRSUDfK+oZo6h2j2e1suO
         7S8+hqfcfsy9nQpczzIfehZc4ZZH8qZgDaXNc09c7i4KS+xLC+7+Uyhhoa2HJPP/6BRH
         0D3x3vt74Z8BjLfo473mh6upvF2vlfGBNj3m9Yq3qa07ntVCnDb+t80NT4va4wE648/H
         eIwd0XTO6Rcow9xn6h8ze86donhLQokU3reGSrdrjqUrMiAbDV30/wAZX8AtrbjTO/SB
         pT8g==
X-Gm-Message-State: APjAAAVCjrOVxqQha5aNEpQGZq4FWhlEvhmQlH6ZTCxOcWQh+vpuyTMk
        Sg+n6iMlyF/6LRcLGqQGc1k=
X-Google-Smtp-Source: APXvYqw5b6n7kBK48avlOUPepxYum5V6LVTDvUo0W+/APYB9WcQFPgKaXXVEJB2yVmTNKJqUeTAhRQ==
X-Received: by 2002:a5d:8598:: with SMTP id f24mr9994753ioj.60.1572620468986;
        Fri, 01 Nov 2019 08:01:08 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m18sm735605iol.49.2019.11.01.08.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 08:01:08 -0700 (PDT)
Date:   Fri, 01 Nov 2019 08:01:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Message-ID: <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
In-Reply-To: <20191031215444.68a12dfe@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
 <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
 <20191031152444.773c183b@cakuba.netronome.com>
 <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
 <20191031215444.68a12dfe@cakuba.netronome.com>
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Thu, 31 Oct 2019 21:44:45 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:  
> > > > Jakub Kicinski wrote:  
> > > > > sk_msg_trim() tries to only update curr pointer if it falls into
> > > > > the trimmed region. The logic, however, does not take into the
> > > > > account pointer wrapping that sk_msg_iter_var_prev() does.
> > > > > This means that when the message was trimmed completely, the new
> > > > > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > > > > neither smaller than any other value, nor would it actually be
> > > > > correct.
> > > > > 
> > > > > Special case the trimming to 0 length a little bit.
> > > > > 
> > > > > This bug caused the TLS code to not copy all of the message, if
> > > > > zero copy filled in fewer sg entries than memcopy would need.
> > > > > 
> > > > > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > > > > 
> > > > > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > > > > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > > > > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > > > > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > > > ---
> > > > > Daniel, John, does this look okay?    
> > > > 
> > > > Thanks for the second ping!  
> > > 
> > > No problem, I was worried the patch got categorized as TLS and therefore
> > > lower prio ;)  
> > 
> > Nope close to the top of the list here.
> > 
> > >   
> >  [...]  
> >  [...]  
> > > 
> > > I see, that makes sense and explains some of the complexity!
> > > 
> > > Perhaps the simplest way to go would be to adjust the curr as we go
> > > then? The comparison logic could get a little hairy. So like this:  
> > 
> > I don't think the comparison is too bad. Working it out live here. First
> > do a bit of case analysis, We have 3 pointers so there are 3!=6 possible
> > arrangements (permutations),
> > 
> >  1. S,C,E  6. S,E,C
> >  5. C,S,E  2. C,E,S
> >  3. E,S,C  4. E,C,S
> > 
> > 
> > Case 1: Normal case start < curr < end
> >  
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >         ^       ^         ^
> >         start   curr      end
> > 
> >   if (start < end && i < curr)
> >      curr = i;
> >         
> >  
> > Case 2: curr < end < start (in absolute index terms)
> > 
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >         ^       ^         ^
> >         curr    end       start
> > 
> >    if (end < start && (i < curr || i > start))
> >         curr = i
> > 
> > 
> > Case 3: end < start < curr
> > 
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >                 ^         ^          ^
> >                 end       start      curr
> > 
> > 
> >    if (end < start && (i < curr)
> >        curr = i;
> > 
> > 
> > Case 4: end < curr < start
> > 
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >                 ^         ^          ^
> >                 end       curr       start 
> > 
> > (nonsense curr would be invalid here it must be between the start and end)
> > 
> > Case 5: curr < start < end
> > 
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >                 ^         ^          ^
> >                 curr      start      end 
> > 
> > (nonsense curr would be invalid here it must be between the start and end)
> > 
> > Case 6: start < end < curr 
> > 
> >     0 1 2                              N = MAX_MSG_FRAGS
> >     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >                 ^         ^          ^
> >                 start     end        curr 
> > 
> > (nonsense curr would be invalid here it must be between the start and end)
> > 
> > So I think the following would suffice,
> > 
> > 
> >   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
> >      msg->sg.curr = i;
> >      msg->sg.copybreak = msg->sg.data[i].length;
> >   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
> >      msg->sg.curr = i;
> >      msg->sg.copybreak = msg->sg.data[i].length;
> >   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr) {
> >      curr = i;
> >      msg->sg.copybreak = msg->sg.data[i].length;
> >   }
> > 
> > Finally fold the last two cases into one so we get
> > 
> >   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
> >      msg->sg.curr = i;
> >      msg->sg.copybreak = msg->sg.data[i].length;
> >   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
> >      msg->sg.curr = i;
> >      msg->sg.copybreak = msg->sg.data[i].length;
> > 
> > So not so bad. Put that in a helper in sk_msg.h and use it in trim. I can check
> > logic in the AM and draft a patch but I think that should be correct. Also will
> > need to audit to see if there are other cases this happens. In general I tried
> > to always use i == msg->sg.{start|end|curr} to avoid this.
> 
> I will look in depth tomorrow as well, the full/empty cases are a
> little tricky to fold into general logic.
> 
> I came up with this before I got distracted Halloweening :)

Same here. Looking at the two cases from above.

   if (msg->sg.start < msg->sg.end &&
       i < msg->sg.curr) {  // i <= msg->sg.curr
      msg->sg.curr = i;
      msg->sg.copybreak = msg->sg.data[i].length;
   }

If we happen to trim the entire msg so size=0 then i==start
which should mean i < msg->sg.curr unless msg->sg.curr = msg->sg.start
so we should just use <=. In the second case.

   else if (msg->sg.end < msg->sg.start &&
           (i < msg->sg.curr || i > msg->sg.start)) { // i <= msg->sg.curr
      msg->sg.curr = i;
      msg->sg.copybreak = msg->sg.data[i].length;
   }
 
If we trim the entire message here i == sg.start again. And same
thing use <= and we should catch case sg.tart = sg.curr.

In the full case we didn't trim anything so we shouldn't do any
manipulating of curr or copybreak.

> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index e4b3fb4bb77c..ce7055259877 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
>  	}
>  }
>  
> +static inline u32 sk_msg_iter_dist(u32 start, u32 end)
> +{
> +	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
> +}
> +
>  #define sk_msg_iter_var_prev(var)			\
>  	do {						\
>  		if (var == 0)				\
> @@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
>  	if (sk_msg_full(msg))
>  		return MAX_MSG_FRAGS;
>  
> -	return msg->sg.end >= msg->sg.start ?
> -		msg->sg.end - msg->sg.start :
> -		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
> +	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
>  }
>  
>  static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index cf390e0aa73d..f6b4a70bafa9 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -270,18 +270,26 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
>  
>  	msg->sg.data[i].length -= trim;
>  	sk_mem_uncharge(sk, trim);
> +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> +		msg->sg.copybreak = msg->sg.data[i].length;
>  out:
> +	sk_msg_iter_var_next(i);
> +	msg->sg.end = i;
> +
>  	/* If we trim data before curr pointer update copybreak and current
>  	 * so that any future copy operations start at new copy location.
>  	 * However trimed data that has not yet been used in a copy op
>  	 * does not require an update.
>  	 */
> -	if (msg->sg.curr >= i) {
> +	if (!msg->sg.size) {

I do think its a bit nicer if we don't special case the size = 0 case. If
we get here and i != start then we would have extra bytes in the sg
items between the items (i, end) and nonzero size. If i == start then the
we sg.size = 0. I don't think there are any other cases.

> +		msg->sg.curr = 0;
> +		msg->sg.copybreak = 0;
> +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
> +		sk_msg_iter_var_prev(i);

I suspect with small update to dist logic the special case could also
be dropped here. But I have a preference for my example above at the
moment. Just getting coffee now so will think on it though.

FWIW I've not compiled my example.

>  		msg->sg.curr = i;
>  		msg->sg.copybreak = msg->sg.data[i].length;
>  	}
> -	sk_msg_iter_var_next(i);
> -	msg->sg.end = i;
>  }
>  EXPORT_SYMBOL_GPL(sk_msg_trim);
>  
> -- 
> 2.23.0



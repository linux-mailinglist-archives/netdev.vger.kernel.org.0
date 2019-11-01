Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9AEC76F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbfKARWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:22:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37812 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfKARWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:22:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id b20so7760109lfp.4
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 10:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vdJS5wHCvpSQMFm2jdDQ61c5eY7rBNbjJW+8uyG0GRg=;
        b=OYhrNrhuXsL/quLsVKXrps3cBpJHq+KilIJjfscIIvLeZFpDBdSoX5Q5sPW6eptPNi
         i+9NTi0uzAsUEkZpX166hI0jqCIMfUC1/Dethrk7AQ4MffqSak83kdWTTcyrvjA23iLf
         VHfL8XeJ2hsrhaKJfEQDlO5doohJw1DsFhJwSgSSs1/H3Mp7e0ORiq8fT8zQBT6jBvOL
         ZLP2Rk3odmj1W6ChZQ8tPGvlT7D7ouKOMjBygRdn+r/7EJVGBofXm4i/np/bNknJA+Ph
         nj4G7+4aUuYtW6CtSVVT/O2NcowP9Ar4uo8F24ar5BTxuWkeviBzEzcmiqXyUqZScnTl
         tK2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vdJS5wHCvpSQMFm2jdDQ61c5eY7rBNbjJW+8uyG0GRg=;
        b=gb/xKMgRvSXYFW8uFT8cL4IrrV62g2/qR7eAH3OsciblY1kU/FC6H6/F9/kqlMYrxT
         3tt01JIEZfDrOTqKFdLy6k7tm/E5I7GFZuP4SC6w+8s3VwbVvE7fpR8/0K+ta1/OO3/W
         IilPcTbmnp6slS4nSm8HcPyfegp8ODx8f7tGqXI9KqRGE/J/T89P7Qqhr7sEk8i2zldR
         uSyo0HqkW4F79iBLwgSTqiNftD3DKEznwjT5VmAigP22NGTQFE56KaedrXB3ar2XMOzZ
         W3i7LyBmmvz3qAqHnr7AeQEpBYrjQHyvkQBh3RWEcqJH+pssi0ntyyfhFg5yzWCgXqil
         +JzA==
X-Gm-Message-State: APjAAAUlmUCSeyeIapJjVWtE4K312VKkB7BrusmVZg/e97Tz1LMa/TY8
        nHyXZLz1lutyR8fcrmDjsSVzLQ==
X-Google-Smtp-Source: APXvYqyPGR3nzGdy0gDqD745mihco1NVGyz6RWNzVa7kM90t6EZUC/folZiIrXBnSvpxYJBU95/uHQ==
X-Received: by 2002:a19:5e53:: with SMTP id z19mr7553066lfi.111.1572628969408;
        Fri, 01 Nov 2019 10:22:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q15sm2780830lfb.84.2019.11.01.10.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 10:22:49 -0700 (PDT)
Date:   Fri, 1 Nov 2019 10:22:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [oss-drivers] Re: [PATCH net] net/tls: fix sk_msg trim on
 fallback to copy mode
Message-ID: <20191101102238.7f56cb84@cakuba.netronome.com>
In-Reply-To: <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
        <20191031215444.68a12dfe@cakuba.netronome.com>
        <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 01 Nov 2019 08:01:00 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > I will look in depth tomorrow as well, the full/empty cases are a
> > little tricky to fold into general logic.
> > 
> > I came up with this before I got distracted Halloweening :)  
> 
> Same here. Looking at the two cases from above.
> 
>    if (msg->sg.start < msg->sg.end &&
>        i < msg->sg.curr) {  // i <= msg->sg.curr
>       msg->sg.curr = i;
>       msg->sg.copybreak = msg->sg.data[i].length;
>    }
> 
> If we happen to trim the entire msg so size=0 then i==start
> which should mean i < msg->sg.curr unless msg->sg.curr = msg->sg.start
> so we should just use <=. In the second case.
> 
>    else if (msg->sg.end < msg->sg.start &&
>            (i < msg->sg.curr || i > msg->sg.start)) { // i <= msg->sg.curr
>       msg->sg.curr = i;
>       msg->sg.copybreak = msg->sg.data[i].length;
>    }
>  
> If we trim the entire message here i == sg.start again. And same
> thing use <= and we should catch case sg.tart = sg.curr.
> 
> In the full case we didn't trim anything so we shouldn't do any
> manipulating of curr or copybreak.

Hm, don't we need to potentially move the copybreak back a little?
That's why I added this:

if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
	msg->sg.copybreak = msg->sg.data[i].length;

To make sure that if we trimmed "a little bit" of the last SG but
didn't actually consume it the copybreak doesn't point after the length.
But perhaps that's not needed since sk_msg_memcopy_from_iter() special
cases the copybreak > length, anyway?

> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> > index e4b3fb4bb77c..ce7055259877 100644
> > --- a/include/linux/skmsg.h
> > +++ b/include/linux/skmsg.h
> > @@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
> >  	}
> >  }
> >  
> > +static inline u32 sk_msg_iter_dist(u32 start, u32 end)
> > +{
> > +	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
> > +}
> > +
> >  #define sk_msg_iter_var_prev(var)			\
> >  	do {						\
> >  		if (var == 0)				\
> > @@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
> >  	if (sk_msg_full(msg))
> >  		return MAX_MSG_FRAGS;
> >  
> > -	return msg->sg.end >= msg->sg.start ?
> > -		msg->sg.end - msg->sg.start :
> > -		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
> > +	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
> >  }
> >  
> >  static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..f6b4a70bafa9 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -270,18 +270,26 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  
> >  	msg->sg.data[i].length -= trim;
> >  	sk_mem_uncharge(sk, trim);
> > +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> > +		msg->sg.copybreak = msg->sg.data[i].length;
> >  out:
> > +	sk_msg_iter_var_next(i);
> > +	msg->sg.end = i;
> > +
> >  	/* If we trim data before curr pointer update copybreak and current
> >  	 * so that any future copy operations start at new copy location.
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {  
> 
> I do think its a bit nicer if we don't special case the size = 0 case. If
> we get here and i != start then we would have extra bytes in the sg
> items between the items (i, end) and nonzero size. If i == start then the
> we sg.size = 0. I don't think there are any other cases.

On an empty message i ended up before start, so we'd have to take the
wrapping into account, no? I couldn't come up with a way to handle
that, and the full case cleanly :S Perhaps there are some constraints
on the geometry that simplify it.

> > +		msg->sg.curr = 0;

Ugh, this should say msg->sg.start, not 0.

> > +		msg->sg.copybreak = 0;
> > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
> > +		sk_msg_iter_var_prev(i);  
> 
> I suspect with small update to dist logic the special case could also
> be dropped here. But I have a preference for my example above at the
> moment. Just getting coffee now so will think on it though.

Oka, I like the dist thing, I thought that's where you were going in
your first email :)

I need to do some more admin, and then I'll probably write a unit test
for this code (use space version).. So we can test either patch with it.

> FWIW I've not compiled my example.
> 
> >  		msg->sg.curr = i;
> >  		msg->sg.copybreak = msg->sg.data[i].length;
> >  	}
> > -	sk_msg_iter_var_next(i);
> > -	msg->sg.end = i;
> >  }
> >  EXPORT_SYMBOL_GPL(sk_msg_trim);

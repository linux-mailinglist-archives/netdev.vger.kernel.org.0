Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5514EE7C4
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 19:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKDS5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 13:57:03 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45454 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728332AbfKDS5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 13:57:03 -0500
Received: by mail-io1-f68.google.com with SMTP id s17so19665179iol.12;
        Mon, 04 Nov 2019 10:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/RXxzsDCwFc2TTsbPua2KtLfYTWrGGbLVo64vuwyBlU=;
        b=K8gH5v/kMEfQ/OObUPAW4PfwFg2NW0em5bBrMBG9ivbIiZokgmsXyEoq/8dU+gAyqB
         PB6p7lP3qYpgYZcEGcb35wzAILjDKwrOmzyMLw+1kzt6ydcfKFySYJ13Xpt90wb5JE5z
         JojoyxWzMVTdhmSgChNpg4soP8bgT/axMePKetOKOr6qGnaiS1bvQnQUR5/191WW8T0Z
         Hj4eRw5/WJNZ2FiE31IskGkbTt/EoqITRDJ5+RAFpnPHsh5zlgqnSs9m6HR6bfvqGVSZ
         ue4VQiLtZEi+EqVqroCpJEbdN+gK4x7y7rtzaIe81Y6nllTA9B/d4FObYptwTjaRZWyW
         vq6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/RXxzsDCwFc2TTsbPua2KtLfYTWrGGbLVo64vuwyBlU=;
        b=cAnsEoPxI2rakKM6XY6H3YBeqYiOs49pK3dYHrvXqQp/swLbo3AS52EQU04c03seXh
         H1dXoFDYAncJfmUcQnp4Xd3K+TQ4V4wLXWNl30JJ2tb1W8Wog1EO20IZxsdcNBjZnHp+
         2sjev7MJKzSThEc6hwCcUVJftdUI4xEGj2vj9+SCiqzAL8vck+0AP2iWrEUQb8kImvIM
         jkXoKjQW9f9gROQZRK2o7kpmeN0jkXfLL3BGNQysFs6DlA4DDxv9MLVJqWTHN2qyVpF6
         VsxSgjn6J6b6vsSmqHESrPcTMkrXijxt7SJuVuoDIm82GkdmFFkCn/AHDFw5rSqtsEcx
         SZEQ==
X-Gm-Message-State: APjAAAUiTtM4fBq4hB2uxFmDqdgoJlvRVKuKiwadguo+ouLYXvaKsqnC
        Zid0E8LGRvNRVCEFRmGfRi8=
X-Google-Smtp-Source: APXvYqwoy5U8cO28Lj1t3HLIhNU0rrk+uwQ8pASQAsYSybFxecKs/ZkfCI3YszftuseFRp+RoWQNZQ==
X-Received: by 2002:a6b:b486:: with SMTP id d128mr3266268iof.47.1572893822088;
        Mon, 04 Nov 2019 10:57:02 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id u21sm2580890ila.41.2019.11.04.10.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 10:57:01 -0800 (PST)
Date:   Mon, 04 Nov 2019 10:56:52 -0800
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
Message-ID: <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
In-Reply-To: <20191101125139.77eb57aa@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
 <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
 <20191031152444.773c183b@cakuba.netronome.com>
 <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
 <20191031215444.68a12dfe@cakuba.netronome.com>
 <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
 <20191101102238.7f56cb84@cakuba.netronome.com>
 <20191101125139.77eb57aa@cakuba.netronome.com>
Subject: Re: [oss-drivers] Re: [PATCH net] net/tls: fix sk_msg trim on
 fallback to copy mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> On Fri, 1 Nov 2019 10:22:38 -0700, Jakub Kicinski wrote:
> > > > +		msg->sg.copybreak = 0;
> > > > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > > > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
> > > > +		sk_msg_iter_var_prev(i);    
> > > 
> > > I suspect with small update to dist logic the special case could also
> > > be dropped here. But I have a preference for my example above at the
> > > moment. Just getting coffee now so will think on it though.  
> > 
> > Oka, I like the dist thing, I thought that's where you were going in
> > your first email :)
> > 
> > I need to do some more admin, and then I'll probably write a unit test
> > for this code (use space version).. So we can test either patch with it.
> 
> Attaching my "unit test", you should be able to just replace
> sk_msg_trim() with yours and re-run. That said my understanding of the
> expected geometry of the buffer may not be correct :)
> 
> The patch I posted yesterday, with the small adjustment to set curr to
> start on empty message passes that test, here it is again:
> 
> ----->8-----
> 
> From 953df5bc0992e31a2c7863ea8b8e490ba7a07356 Mon Sep 17 00:00:00 2001
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Tue, 29 Oct 2019 20:20:49 -0700
> Subject: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
> 
> sk_msg_trim() tries to only update curr pointer if it falls into
> the trimmed region. The logic, however, does not take into the
> account pointer wrapping that sk_msg_iter_var_prev() does nor
> (as John points out) the fact that msg->sg is a ring buffer.
> 
> This means that when the message was trimmed completely, the new
> curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> neither smaller than any other value, nor would it actually be
> correct.
> 
> Special case the trimming to 0 length a little bit and rework
> the comparison between curr and end to take into account wrapping.
> 
> This bug caused the TLS code to not copy all of the message, if
> zero copy filled in fewer sg entries than memcopy would need.
> 
> Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> 
> v2:
>  - take into account that msg->sg is a ring buffer (John).
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>  include/linux/skmsg.h |  9 ++++++---
>  net/core/skmsg.c      | 20 +++++++++++++++-----
>  2 files changed, 21 insertions(+), 8 deletions(-)
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

I think its nice to pull this into a helper so I'm ok with also using the
dist below, except for one comment below.

>  
>  static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index cf390e0aa73d..f87fde3a846c 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
>  
>  	msg->sg.data[i].length -= trim;
>  	sk_mem_uncharge(sk, trim);
> +	/* Adjust copybreak if it falls into the trimmed part of last buf */
> +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> +		msg->sg.copybreak = msg->sg.data[i].length;
>  out:
> -	/* If we trim data before curr pointer update copybreak and current
> -	 * so that any future copy operations start at new copy location.
> +	sk_msg_iter_var_next(i);
> +	msg->sg.end = i;
> +
> +	/* If we trim data a full sg elem before curr pointer update
> +	 * copybreak and current so that any future copy operations
> +	 * start at new copy location.
>  	 * However trimed data that has not yet been used in a copy op
>  	 * does not require an update.
>  	 */
> -	if (msg->sg.curr >= i) {
> +	if (!msg->sg.size) {
> +		msg->sg.curr = msg->sg.start;
> +		msg->sg.copybreak = 0;
> +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {

I'm not seeing how this can work. Taking simple case with start < end
so normal geometry without wrapping. Let,

 start = 1
 curr  = 3
 end   = 4

We could trim an index to get,

 start = 1
  curr = 3
     i = 3
   end = 4

Then after out: label this would push end up one,

 start = 1
  curr = 3
     i = 3
   end = 4

But dist(start,curr) = 2 and dist(end, curr) = 1 and we would set curr
to '3' but clear the copybreak? I think a better comparison would be,

  if (sk_msg_iter_dist(msg->sg.start, i) <
      sk_msg_iter_dist(msg->sg.start, msg->sg.curr)

To check if 'i' walked past curr so we can reset curr/copybreak?

> +		sk_msg_iter_var_prev(i);
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
> 



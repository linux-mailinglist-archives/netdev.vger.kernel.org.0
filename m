Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A9CEBCEC
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 05:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbfKAEyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 00:54:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33657 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfKAEyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 00:54:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id c184so6208662pfb.0
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 21:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8tPWK5BYgsuL9zha6OCfDPYnrci37qEo2bbOP/w1G5Q=;
        b=seTDmiNrqiUFMt4vzI8kNkW8iW6IXp4/atKoYhwPQSoD4SpW4iDH7n/phuuwaqmUg/
         eF6bQAxxZQ7PVJF8qsKSUY8lYIn4Wv7bOP1PmKXF9CtgJ5KRYGc7f8it4cEqvGjJwImo
         wqRXiwbPz23eV76ZXCPTH0LsW+hwi3juz7To7zhtN5BNbx1gHbm3SpEVNfxFl2cZ+wC5
         r2qws2hDTXG2HUIYcEMWXRL5YvLqQE7NEogbyFaqlMOiHA+ANJKHcoWhkauS0oFlA6OD
         ZjP2IiyhcpWymlvM+8uuks6gAefKltNDUs76/uo+lsOu91+TQFBn3C5+0o2itr2dwXwq
         CqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8tPWK5BYgsuL9zha6OCfDPYnrci37qEo2bbOP/w1G5Q=;
        b=FmGk9Uyov6o+Me95B9xwkh1lq2RtnxYqjk+KGMdP8bfrV68kYy8aUVbGMwA03sKs7a
         sr3g1yDzlgDmMoMAoNx3lgk1PcOXtOv3Za0fuJeCPw2S/HK1ffkJaU6WfVSkpwSkvT/J
         XpZWg+EGm8N2dEv57xSeSqF2RkGk6muWmzMcbeKoZ6KVpUhuuiz2ebLMTwpolZxCcIJ0
         dbFHkKaF3Xq4z6HxTIBe5O1fMlSuj364S4TzB1Q0xjk+p+CkzLTKW9td9SAXXuixwDqK
         fB+LSVEqKK+FU95xW5UYzLwm+Lynqpjkuc1RFDPfr6lb46aS2kjAgt7oBRHNKgZTR5qK
         SVBA==
X-Gm-Message-State: APjAAAXC/0xHeD5JZhIHioE+5wlVPFkJCEb1GP5lxC3R/T8FwFUTviYq
        u11l+RxU9+nf0miCc0xurOusKw==
X-Google-Smtp-Source: APXvYqzxZYnEkqVpNUYPkOkE6SqlqUJp+ABefXAxX16P0ANDk/fLjwFTDUi/wu3EtDkNzXswS9II0A==
X-Received: by 2002:a62:76c6:: with SMTP id r189mr11322014pfc.48.1572584089179;
        Thu, 31 Oct 2019 21:54:49 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id e198sm5178943pfh.83.2019.10.31.21.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 21:54:48 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:54:44 -0700
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
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031215444.68a12dfe@cakuba.netronome.com>
In-Reply-To: <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 21:44:45 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:  
> > > Jakub Kicinski wrote:  
> > > > sk_msg_trim() tries to only update curr pointer if it falls into
> > > > the trimmed region. The logic, however, does not take into the
> > > > account pointer wrapping that sk_msg_iter_var_prev() does.
> > > > This means that when the message was trimmed completely, the new
> > > > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > > > neither smaller than any other value, nor would it actually be
> > > > correct.
> > > > 
> > > > Special case the trimming to 0 length a little bit.
> > > > 
> > > > This bug caused the TLS code to not copy all of the message, if
> > > > zero copy filled in fewer sg entries than memcopy would need.
> > > > 
> > > > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > > > 
> > > > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > > > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > > > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > > > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > > ---
> > > > Daniel, John, does this look okay?    
> > > 
> > > Thanks for the second ping!  
> > 
> > No problem, I was worried the patch got categorized as TLS and therefore
> > lower prio ;)  
> 
> Nope close to the top of the list here.
> 
> >   
>  [...]  
>  [...]  
> > 
> > I see, that makes sense and explains some of the complexity!
> > 
> > Perhaps the simplest way to go would be to adjust the curr as we go
> > then? The comparison logic could get a little hairy. So like this:  
> 
> I don't think the comparison is too bad. Working it out live here. First
> do a bit of case analysis, We have 3 pointers so there are 3!=6 possible
> arrangements (permutations),
> 
>  1. S,C,E  6. S,E,C
>  5. C,S,E  2. C,E,S
>  3. E,S,C  4. E,C,S
> 
> 
> Case 1: Normal case start < curr < end
>  
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>         ^       ^         ^
>         start   curr      end
> 
>   if (start < end && i < curr)
>      curr = i;
>         
>  
> Case 2: curr < end < start (in absolute index terms)
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>         ^       ^         ^
>         curr    end       start
> 
>    if (end < start && (i < curr || i > start))
>         curr = i
> 
> 
> Case 3: end < start < curr
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 end       start      curr
> 
> 
>    if (end < start && (i < curr)
>        curr = i;
> 
> 
> Case 4: end < curr < start
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 end       curr       start 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> Case 5: curr < start < end
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 curr      start      end 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> Case 6: start < end < curr 
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 start     end        curr 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> So I think the following would suffice,
> 
> 
>   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr) {
>      curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   }
> 
> Finally fold the last two cases into one so we get
> 
>   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
> 
> So not so bad. Put that in a helper in sk_msg.h and use it in trim. I can check
> logic in the AM and draft a patch but I think that should be correct. Also will
> need to audit to see if there are other cases this happens. In general I tried
> to always use i == msg->sg.{start|end|curr} to avoid this.

I will look in depth tomorrow as well, the full/empty cases are a
little tricky to fold into general logic.

I came up with this before I got distracted Halloweening :)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e4b3fb4bb77c..ce7055259877 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
 	}
 }
 
+static inline u32 sk_msg_iter_dist(u32 start, u32 end)
+{
+	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+}
+
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
@@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
 	if (sk_msg_full(msg))
 		return MAX_MSG_FRAGS;
 
-	return msg->sg.end >= msg->sg.start ?
-		msg->sg.end - msg->sg.start :
-		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
 static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..f6b4a70bafa9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -270,18 +270,26 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
 
 	msg->sg.data[i].length -= trim;
 	sk_mem_uncharge(sk, trim);
+	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
+		msg->sg.copybreak = msg->sg.data[i].length;
 out:
+	sk_msg_iter_var_next(i);
+	msg->sg.end = i;
+
 	/* If we trim data before curr pointer update copybreak and current
 	 * so that any future copy operations start at new copy location.
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = 0;
+		msg->sg.copybreak = 0;
+	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
+		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
+		sk_msg_iter_var_prev(i);
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-	sk_msg_iter_var_next(i);
-	msg->sg.end = i;
 }
 EXPORT_SYMBOL_GPL(sk_msg_trim);
 
-- 
2.23.0

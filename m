Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 742DCEBCE3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 05:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfKAEoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 00:44:54 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40586 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKAEoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 00:44:54 -0400
Received: by mail-io1-f65.google.com with SMTP id p6so9608579iod.7;
        Thu, 31 Oct 2019 21:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ubGzTc2JG05dFdpzm6lVpJCYav7w/qkdP80BNzZY03k=;
        b=gk3ZHjoJf1z+K4VsnOZFokkuXhW/2QaZaq9Zvnn8HsuiCMqAsW/mCrKmrjW9w3b3hH
         HnLhlvle++/7o7L+KKX1ewCB0KGSpE2TLtQCw23XymM0NkW1CsKkUsMW1w8Qv4ucWMfM
         gZlw3DXAhrUX1bhUK0MU3uMBSwN0ZciHwCcVKS4+lde0lyqyhV8ukBzA9R/HfVRi5uGY
         sID+E64yuHj3Yp0QQs78dqY4BPUwQk/RbAbQjPL+vTHHPm3h6ZaZWugsadNhcygvfZpA
         v1zaw0+IOGQzj/m/H/8HqGjPVoNwAey0ARVmXXxlrV3B0JPMS8mmlp6V/YCx1DAEAM+M
         BjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ubGzTc2JG05dFdpzm6lVpJCYav7w/qkdP80BNzZY03k=;
        b=c+vt8j9zfAD1xI9czqW41ox2kNjXDZG1BBnEw0LKoHMEulLn3lZw8j0WVE5IBNCAbR
         gnfyfgfxrnz6PS10bZTGqj+5oz80YJ4ws8yTMCYd6WP3VT1/uOrNICuhYJ7NE8DoA10L
         3g9Gx7Mj3kZzUNJtNMAgkIAjF6e88Ircn/Er+QVcWsSDt7cgtKiCAgUOjcFWl2hymuHt
         YpUya88XNYMkFYF2HCwm3p72zoWpPPTifF0e7BhOjmqJkyz/qaxnZkcULoO6Z/jYZlX6
         iZUq2D+abSa438mN0szyMWX9k9sUBI0R+4tFsr6gqxvXvW2TthDYJZEZsYvL/XhPmbgM
         xtLQ==
X-Gm-Message-State: APjAAAVMDBBP5aTv/hDQMdeLhdDrKmeBvLgLJ3nLW2NWnYD6sQ3Dnf6/
        TOWeDGPNf+ZCIIczrpEQz0U=
X-Google-Smtp-Source: APXvYqwwuvTQsLYY/pcCaKne9GscqUv6sNojhMmD3jUNRjVRQ7mQmGKejn+M2iwVgtMtqi5u9VGZZw==
X-Received: by 2002:a6b:5503:: with SMTP id j3mr8519170iob.151.1572583493189;
        Thu, 31 Oct 2019 21:44:53 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c5sm574819ioc.26.2019.10.31.21.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 21:44:52 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:44:45 -0700
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
Message-ID: <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
In-Reply-To: <20191031152444.773c183b@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
 <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
 <20191031152444.773c183b@cakuba.netronome.com>
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
> On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > sk_msg_trim() tries to only update curr pointer if it falls into
> > > the trimmed region. The logic, however, does not take into the
> > > account pointer wrapping that sk_msg_iter_var_prev() does.
> > > This means that when the message was trimmed completely, the new
> > > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > > neither smaller than any other value, nor would it actually be
> > > correct.
> > > 
> > > Special case the trimming to 0 length a little bit.
> > > 
> > > This bug caused the TLS code to not copy all of the message, if
> > > zero copy filled in fewer sg entries than memcopy would need.
> > > 
> > > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > > 
> > > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > ---
> > > Daniel, John, does this look okay?  
> > 
> > Thanks for the second ping!
> 
> No problem, I was worried the patch got categorized as TLS and therefore
> lower prio ;)

Nope close to the top of the list here.

> 
> > > CC: Eric Biggers <ebiggers@kernel.org>
> > > CC: herbert@gondor.apana.org.au
> > > CC: glider@google.com
> > > CC: linux-crypto@vger.kernel.org
> > > 
> > >  net/core/skmsg.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > > index cf390e0aa73d..c42c145216b1 100644
> > > --- a/net/core/skmsg.c
> > > +++ b/net/core/skmsg.c
> > > @@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> > >  	 * However trimed data that has not yet been used in a copy op
> > >  	 * does not require an update.
> > >  	 */
> > > -	if (msg->sg.curr >= i) {
> > > +	if (!msg->sg.size) {
> > > +		msg->sg.curr = 0;
> > > +		msg->sg.copybreak = 0;
> > > +	} else if (msg->sg.curr >= i) {
> > >  		msg->sg.curr = i;
> > >  		msg->sg.copybreak = msg->sg.data[i].length;
> > >  	}
> > > --   
> > 
> > 
> > Its actually not sufficient. We can't directly do comparisons against curr
> > like this. msg->sg is a ring buffer so we have to be careful for these
> > types of comparisons.
> > 
> > Examples hopefully help explian. Consider the case with a ring layout on
> > entering sk_msg_trim,
> > 
> >    0 1 2                              N = MAX_MSG_FRAGS
> >   |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
> >        ^       ^         ^
> >        curr    end       start
> > 
> > Start trimming from end
> > 
> >    0 1 2                              N = MAX_MSG_FRAGS
> >   |X|X|X|...|X|X|_|...|_|_|i|X|....|X|X|
> >        ^       ^         ^
> >        curr    end       start
> > 
> > We trim backwards through ring with sk_msg_iter_var_prev(). And its
> > possible to end with the result of above where 'i' is greater than curr
> > and greater than start leaving scatterlist elements so size != 0.
> > 
> >     i > curr && i > start && sg.size != 0
> > 
> > but we wont catch it with this condition
> > 
> >     if (msg->sg.curr >= i)
> > 
> > So we won't reset curr and copybreak so we have a potential issue now
> > where curr is pointing at data that has been trimmed.
> 
> I see, that makes sense and explains some of the complexity!
> 
> Perhaps the simplest way to go would be to adjust the curr as we go
> then? The comparison logic could get a little hairy. So like this:

I don't think the comparison is too bad. Working it out live here. First
do a bit of case analysis, We have 3 pointers so there are 3!=6 possible
arrangements (permutations),

 1. S,C,E  6. S,E,C
 5. C,S,E  2. C,E,S
 3. E,S,C  4. E,C,S


Case 1: Normal case start < curr < end
 
    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
        ^       ^         ^
        start   curr      end

  if (start < end && i < curr)
     curr = i;
        
 
Case 2: curr < end < start (in absolute index terms)

    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
        ^       ^         ^
        curr    end       start

   if (end < start && (i < curr || i > start))
        curr = i


Case 3: end < start < curr

    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
                ^         ^          ^
                end       start      curr


   if (end < start && (i < curr)
       curr = i;


Case 4: end < curr < start

    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
                ^         ^          ^
                end       curr       start 

(nonsense curr would be invalid here it must be between the start and end)

Case 5: curr < start < end

    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
                ^         ^          ^
                curr      start      end 

(nonsense curr would be invalid here it must be between the start and end)

Case 6: start < end < curr 

    0 1 2                              N = MAX_MSG_FRAGS
    |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
                ^         ^          ^
                start     end        curr 

(nonsense curr would be invalid here it must be between the start and end)

So I think the following would suffice,


  if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
     msg->sg.curr = i;
     msg->sg.copybreak = msg->sg.data[i].length;
  } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
     msg->sg.curr = i;
     msg->sg.copybreak = msg->sg.data[i].length;
  } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr) {
     curr = i;
     msg->sg.copybreak = msg->sg.data[i].length;
  }

Finally fold the last two cases into one so we get

  if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
     msg->sg.curr = i;
     msg->sg.copybreak = msg->sg.data[i].length;
  } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
     msg->sg.curr = i;
     msg->sg.copybreak = msg->sg.data[i].length;

So not so bad. Put that in a helper in sk_msg.h and use it in trim. I can check
logic in the AM and draft a patch but I think that should be correct. Also will
need to audit to see if there are other cases this happens. In general I tried
to always use i == msg->sg.{start|end|curr} to avoid this.

Hopefully it wasn't too verbose above but figured it couldn't hurt.
.John

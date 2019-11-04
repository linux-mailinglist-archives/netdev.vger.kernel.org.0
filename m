Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800FDEF0D9
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfKDW6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:58:41 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:38360 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbfKDW6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:58:41 -0500
Received: by mail-il1-f193.google.com with SMTP id y5so16417173ilb.5;
        Mon, 04 Nov 2019 14:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q98+jnyGQdn+jYOmWWSD2OgHwr4nXh0G0uBe+f21Bfs=;
        b=HYe22o02z3beGzaDNWuohwV4GKHY1BYkKdEG7IG1X0tSQF1NuADwGYbpTTjicPr/GM
         u6VnpkBv8Dksz5OnLWQbsrw1PtNLAjCbR1BEt21xjstmZMSPRFsDJuqcdmTZvT0KUDIM
         eGj1/BOXYu7j/2glwP5WUNJ2bCChEg6oNjpTNUlR4sv1XHuvaF5JcWd4RwwN5XxpZDB7
         g5gAN8+/jEBC62L200FrGmJvbvd85wxsx0tsoE340Ry7fV44sgS5fXbj3HqsCu37gOFY
         oW1NXpkhTuyWO5UsPRXNHwb9UUs4+RHdZA0YuoaOn3AwSHvxovuCcpaj4KWR+ar9Az0J
         o4dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q98+jnyGQdn+jYOmWWSD2OgHwr4nXh0G0uBe+f21Bfs=;
        b=jNpVZE1lS+75EfOF7X97z7grwIe/f5I9X9/o+DkOCNEQw6bJ5yfNCSfcWfBM80k20A
         N4RDxHZvCd37Rup7mMtzGuWOOIcs8CS2y+okmrTap6nYwez1uRhb75jj9LiZcegMsBc5
         w1IUQZDdJd0ojBUvY/ATWfrlFjiYUhvg97TQFB8jgvwssCz05zj2CjozgkO/2kUHjDku
         hYGrZNEyZAV/Q10kUQZbXZL+/nzu9xetCVAaGSZvWpf3W2Ts3nYpRiBeHnoYx2v2LzSW
         M049MZw4Rs2Eq3nCx5bFIViE48u6VMQdcqMSEnpmNydPRhrEKs2t+RjAFzume+F3P8dl
         21YA==
X-Gm-Message-State: APjAAAWAQRkvAgp6raPo60KcWrjoaWpXzMFsimpUhKXTMbHHWpJJRxAU
        3vE4qO8ecBqMoFd/mZmo+iTG7La7kW8=
X-Google-Smtp-Source: APXvYqyH7MsebcRMqMcSh5lBQnBVbvKY0vq+K5T+Nt4fE8DwGhYa65o54saCxgq9AXdsgM+3ljrtdw==
X-Received: by 2002:a92:8408:: with SMTP id l8mr31904599ild.107.1572908318551;
        Mon, 04 Nov 2019 14:58:38 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v13sm2677683ili.65.2019.11.04.14.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 14:58:37 -0800 (PST)
Date:   Mon, 04 Nov 2019 14:58:30 -0800
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
Message-ID: <5dc0ad165502b_42ae2af05d4685c0e9@john-XPS-13-9370.notmuch>
In-Reply-To: <20191104113407.7da3ed44@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
 <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
 <20191031152444.773c183b@cakuba.netronome.com>
 <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
 <20191031215444.68a12dfe@cakuba.netronome.com>
 <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
 <20191101102238.7f56cb84@cakuba.netronome.com>
 <20191101125139.77eb57aa@cakuba.netronome.com>
 <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
 <20191104113407.7da3ed44@cakuba.netronome.com>
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
> On Mon, 04 Nov 2019 10:56:52 -0800, John Fastabend wrote:
> > Jakub Kicinski wrote:
> > > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > > index cf390e0aa73d..f87fde3a846c 100644
> > > --- a/net/core/skmsg.c
> > > +++ b/net/core/skmsg.c
> > > @@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> > >  
> > >  	msg->sg.data[i].length -= trim;
> > >  	sk_mem_uncharge(sk, trim);
> > > +	/* Adjust copybreak if it falls into the trimmed part of last buf */
> > > +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> > > +		msg->sg.copybreak = msg->sg.data[i].length;
> > >  out:
> > > -	/* If we trim data before curr pointer update copybreak and current
> > > -	 * so that any future copy operations start at new copy location.
> > > +	sk_msg_iter_var_next(i);
> > > +	msg->sg.end = i;
> > > +
> > > +	/* If we trim data a full sg elem before curr pointer update
> > > +	 * copybreak and current so that any future copy operations
> > > +	 * start at new copy location.
> > >  	 * However trimed data that has not yet been used in a copy op
> > >  	 * does not require an update.
> > >  	 */
> > > -	if (msg->sg.curr >= i) {
> > > +	if (!msg->sg.size) {
> > > +		msg->sg.curr = msg->sg.start;
> > > +		msg->sg.copybreak = 0;
> > > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {  
> > 
> > I'm not seeing how this can work. Taking simple case with start < end
> > so normal geometry without wrapping. Let,
> > 
> >  start = 1
> >  curr  = 3
> >  end   = 4
> > 
> > We could trim an index to get,
> > 
> >  start = 1
> >   curr = 3
> >      i = 3
> >    end = 4
> 
> IOW like this?
> 
> 	test_one(/* start */ 1, /* curr */ 3, /* copybreak */ 150,
> 		 /* trim */ 500,
> 		 /* curr */ 3, /* copybreak */ 100, /* end */ 4,
> 		 /* data */ 200, 200, 200);
> 
> test #13  start:1 curr:3 end:4 cb:150 size: 600      0 200 200 200   0	OKAY
> 
> > Then after out: label this would push end up one,
> > 
> >  start = 1
> >   curr = 3
> >      i = 3
> >    end = 4
> 
> I moved the assignment to end before the curr adjustment, so 'i' is
> equivalent to 'end' at this point.

right.

> 
> > But dist(start,curr) = 2 and dist(end, curr) = 1 and we would set curr
> > to '3' but clear the copybreak?
> 
> I don't think we'd fall into this condition ever, unless we moved end.
> And in your example AFAIU we don't move end.
> 
> > I think a better comparison would be,
> > 
> >   if (sk_msg_iter_dist(msg->sg.start, i) <
> >       sk_msg_iter_dist(msg->sg.start, msg->sg.curr)
> > 
> > To check if 'i' walked past curr so we can reset curr/copybreak?
> 
> Ack, this does read better!

Great.

> 
> Should we use <= here? If we dropped a full segment, should curr point
> at the end of the last remaining segment or should it point at 0 in end?

Right it should be <=.

Full segment? If a segment is trimmed exactly then curr can point to the
previous segment with 'copybreak = sge->length' so next copy will see a
full buffer and advance curr. Or can leave curr on the trim'ed segment
with copybreak set to 0.

Both should be OK as long as copybreak is correct.  Reviewing code now
to be sure we didn't take any shortcuts but that should be true else we
may have other bugs when working with BPF.

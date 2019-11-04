Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC742EE8B1
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 20:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729546AbfKDTeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 14:34:20 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34044 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbfKDTeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 14:34:20 -0500
Received: by mail-lj1-f194.google.com with SMTP id 139so19026404ljf.1
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 11:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fgSeIYEYDrhZGVZ1wThncNpInXi9KuTgwauEOaT/fz8=;
        b=XNDo374JjUNHFXw5xBuVByALaK8ejs5Wkhil7aQ1XBWn5hgeYqLzayJla0aWI937cv
         lCHOve2W62HATQ69l5pqd3Fx56DjU/5i2AnOZ1y9GC8hXkp8X7j3/JLw3Z6YlmADqL8/
         mX6rHMuXZz1rjIv68PqzMWb6/RcI3K/s1dvEnWvSn7TxI022dpcCLAENvldNs3L1gOT9
         pAuwWLEzZDmHeUqdoezmdXvG18/Ap6Do7TEoLXT8MOS9pRDLu2yJgCZhNFRFSUWLxvKS
         biQHw2v3X/Apj/q6Hg2e2llmQZP9eC5mHSzmmTrIOpA+6LGkjYSDP6+GaHsZQ6UvcO08
         r5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fgSeIYEYDrhZGVZ1wThncNpInXi9KuTgwauEOaT/fz8=;
        b=X7CXZT3k+w7yCR9F+v0NZg37+eQkPKn6p0d5wur94fKI3peO8Okrj/lztdwPrFMnRm
         tyYkbD+4v6YQmUtcj8Yd+lceS2t2kgbRk4XsB3ZpWpPXRha5xnGwTZash0tMa3X5Dg+w
         wur5UuI3XHsnSdogUfoLS27SmNifHsfORIDW5jqn6rbSIBb/vhGtG2mBkhBexc2X3JHn
         Z0JsoFnT3wM5NaYD3ESQobkmd5BGRfpfnC59W+n1lreh6l4Ir6UDZklZubOmMUkQFRG4
         11PdUvmMdn/xUO4QNUZLpYiXh6tobZG25ELBOb3NtV51/8lnPbOOvUVscDcnUcx/2RSx
         9DRg==
X-Gm-Message-State: APjAAAV0adluS98eh8enwbnYVtZayN5NkPzYAPuYkcVMhjtL4deper+n
        OlsE3JrTVMRKN1fS3S93Ec4hjw==
X-Google-Smtp-Source: APXvYqyMAFBGZOHSvW+4tcTBdNMQAfmjcnIVtFWHqHu+kYjRrJ3kcJfacfRH5Nqmwvl4fTuMkhnfXw==
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr1344371ljj.243.1572896057562;
        Mon, 04 Nov 2019 11:34:17 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q15sm6946976lfb.84.2019.11.04.11.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 11:34:17 -0800 (PST)
Date:   Mon, 4 Nov 2019 11:34:07 -0800
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
Message-ID: <20191104113407.7da3ed44@cakuba.netronome.com>
In-Reply-To: <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
        <20191031215444.68a12dfe@cakuba.netronome.com>
        <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
        <20191101102238.7f56cb84@cakuba.netronome.com>
        <20191101125139.77eb57aa@cakuba.netronome.com>
        <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 04 Nov 2019 10:56:52 -0800, John Fastabend wrote:
> Jakub Kicinski wrote:
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..f87fde3a846c 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  
> >  	msg->sg.data[i].length -= trim;
> >  	sk_mem_uncharge(sk, trim);
> > +	/* Adjust copybreak if it falls into the trimmed part of last buf */
> > +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> > +		msg->sg.copybreak = msg->sg.data[i].length;
> >  out:
> > -	/* If we trim data before curr pointer update copybreak and current
> > -	 * so that any future copy operations start at new copy location.
> > +	sk_msg_iter_var_next(i);
> > +	msg->sg.end = i;
> > +
> > +	/* If we trim data a full sg elem before curr pointer update
> > +	 * copybreak and current so that any future copy operations
> > +	 * start at new copy location.
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {
> > +		msg->sg.curr = msg->sg.start;
> > +		msg->sg.copybreak = 0;
> > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {  
> 
> I'm not seeing how this can work. Taking simple case with start < end
> so normal geometry without wrapping. Let,
> 
>  start = 1
>  curr  = 3
>  end   = 4
> 
> We could trim an index to get,
> 
>  start = 1
>   curr = 3
>      i = 3
>    end = 4

IOW like this?

	test_one(/* start */ 1, /* curr */ 3, /* copybreak */ 150,
		 /* trim */ 500,
		 /* curr */ 3, /* copybreak */ 100, /* end */ 4,
		 /* data */ 200, 200, 200);

test #13  start:1 curr:3 end:4 cb:150 size: 600      0 200 200 200   0	OKAY

> Then after out: label this would push end up one,
> 
>  start = 1
>   curr = 3
>      i = 3
>    end = 4

I moved the assignment to end before the curr adjustment, so 'i' is
equivalent to 'end' at this point.

> But dist(start,curr) = 2 and dist(end, curr) = 1 and we would set curr
> to '3' but clear the copybreak?

I don't think we'd fall into this condition ever, unless we moved end.
And in your example AFAIU we don't move end.

> I think a better comparison would be,
> 
>   if (sk_msg_iter_dist(msg->sg.start, i) <
>       sk_msg_iter_dist(msg->sg.start, msg->sg.curr)
> 
> To check if 'i' walked past curr so we can reset curr/copybreak?

Ack, this does read better!

Should we use <= here? If we dropped a full segment, should curr point
at the end of the last remaining segment or should it point at 0 in end?

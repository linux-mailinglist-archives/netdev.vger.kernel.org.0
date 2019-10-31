Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FBEB989
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfJaWJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:09:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35229 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaWJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:09:03 -0400
Received: by mail-io1-f65.google.com with SMTP id h9so8625345ioh.2;
        Thu, 31 Oct 2019 15:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mbRrgdCkRs3i0AkiyxJvSQPMkJTt31Zs7sXQoEh7498=;
        b=anxfJk8ZQhhTgxKNDPuLmYwvFonXRXB7hCPc9VIezYrkDjTuAVlSqBovGaT5qVCrHN
         z4nQF9OoDziyty0hwUnszWgswvPcfDcBgfP8MfHiRxer5eC3tuQTf1QR3A4v/ipikix9
         4XZ6/SAt6Hi3Z+l2keDEuKzyjMZez+2Wt3PegkOx/kqtq6TYho1zeJx1xd41wIrc6wty
         XHBnKJuY/hoL5uKLvxJPSkSBb4b5vb1DPaxbsNB8MBkvWj244XqahKXsoBGAsxC5xsSR
         iNfk0b9qKNYzF5B5A7arVTchl7SzhenG0re8GbiiWVcVTfs4rLYjGlB2gR6muq8xLPd4
         4f2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mbRrgdCkRs3i0AkiyxJvSQPMkJTt31Zs7sXQoEh7498=;
        b=RZ0SXTR4ZH+WKUzCh/sJqV8YhJY6OE04C9KfXKLRt9ebd266707LyB40Fst5bUvlRp
         6yUcv5dgfRLV3T8wwkAAyezYsVp1wMMHDkQGRfhaAEltstPLoT3YFcUzDStPVHnN2Kfr
         XerRDzHuBxbPpZMsZitYi5xFqqc/NdJk/fuTflQ3ZoDRSTrFxIEn+uMxtGRmWnYAPe0P
         iW6zpbBBe0/+KoreeAocy7IrugH/XJlokoH6lgl6xKTuZ3QzUfhZx4L1xmMxR7+hKbbp
         kL54NfMuaTI2u+p5bSCO/I5hNEB1MQdSuCSLN+WBqpg4VKYk/BFGk6SCtk10PajYyc/2
         3Qcw==
X-Gm-Message-State: APjAAAVGLuOEoh6CPxurzZi08bhE3e8cSDPgY8L5X6hLMWaegzRhQo1a
        UjffEo0dVGidQAzmiOgJXf8=
X-Google-Smtp-Source: APXvYqyfrXhuikhrhTO92P5/Ox0y2vtLbViA67QmKsrXbdBMpkhCOhDg/P1YLS93hYIwmZyDo06/sQ==
X-Received: by 2002:a5d:8910:: with SMTP id b16mr7099079ion.157.1572559742508;
        Thu, 31 Oct 2019 15:09:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g8sm739674ilc.60.2019.10.31.15.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:09:01 -0700 (PDT)
Date:   Thu, 31 Oct 2019 15:08:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Message-ID: <5dbb5b7665d9c_58842b00644685b8fe@john-XPS-13-9370.notmuch>
In-Reply-To: <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
 <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> Jakub Kicinski wrote:
> > sk_msg_trim() tries to only update curr pointer if it falls into
> > the trimmed region. The logic, however, does not take into the
> > account pointer wrapping that sk_msg_iter_var_prev() does.
> > This means that when the message was trimmed completely, the new
> > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > neither smaller than any other value, nor would it actually be
> > correct.
> > 
> > Special case the trimming to 0 length a little bit.
> > 
> > This bug caused the TLS code to not copy all of the message, if
> > zero copy filled in fewer sg entries than memcopy would need.
> > 
> > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > 
> > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> > Daniel, John, does this look okay?
> 
> Thanks for the second ping!
> 
> > 
> > CC: Eric Biggers <ebiggers@kernel.org>
> > CC: herbert@gondor.apana.org.au
> > CC: glider@google.com
> > CC: linux-crypto@vger.kernel.org
> > 
> >  net/core/skmsg.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..c42c145216b1 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {
> > +		msg->sg.curr = 0;
> > +		msg->sg.copybreak = 0;
> > +	} else if (msg->sg.curr >= i) {
> >  		msg->sg.curr = i;
> >  		msg->sg.copybreak = msg->sg.data[i].length;
> >  	}
> > -- 
> 
> 
> Its actually not sufficient. We can't directly do comparisons against curr
> like this. msg->sg is a ring buffer so we have to be careful for these
> types of comparisons.
> 
> Examples hopefully help explian. Consider the case with a ring layout on
> entering sk_msg_trim,

Perhaps worth adding this case is only possible AFAIK with BPF manipulating
the ring to buffer/release data.

> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>        ^       ^         ^
>        curr    end       start
> 
> Start trimming from end
> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |X|X|X|...|X|X|_|...|_|_|i|X|....|X|X|
>        ^       ^         ^
>        curr    end       start
> 
> We trim backwards through ring with sk_msg_iter_var_prev(). And its
> possible to end with the result of above where 'i' is greater than curr
> and greater than start leaving scatterlist elements so size != 0.
> 
>     i > curr && i > start && sg.size != 0
> 
> but we wont catch it with this condition
> 
>     if (msg->sg.curr >= i)
> 
> So we won't reset curr and copybreak so we have a potential issue now
> where curr is pointing at data that has been trimmed.
> 
> I'll put together a fix but the correct thing to do here is a proper
> ring greater than op which is not what we have there. Although, your patch
> is also really a good one to have because reseting curr = 0 and
> copybreak = 0 when possible keeps the ring from being fragmented which
> avoids chaining when we push scatterlists down to crypto layer. So for
> your patch,
> 
> Acked-By: John Fastabend <john.fastabend@gmail.com>
> 
> If it should go to net or net-next I think is probably up for debate
> 
> Nice catch!!! Can you send me the reproducer?
> 
> Thanks,
> John
> 
> 
> 
> 



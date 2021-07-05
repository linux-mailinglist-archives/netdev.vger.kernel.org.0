Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65103BC1A6
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGEQag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 12:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhGEQag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 12:30:36 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46949C06175F;
        Mon,  5 Jul 2021 09:27:58 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id j12so6901929ils.5;
        Mon, 05 Jul 2021 09:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6mm4TwDU0EQC4agqLfuyOy/11Do/Eo/Z1FMIy3HRwDs=;
        b=tOBTqp0R/XjqjIl9ln0thxQKVYHhzL4FMlK8KWgTDzpu35zB6sFro5jHBTZLBdI63/
         BhcCKDTaaTFgnrvxn3WrFf0hG+wqd8V5WSk/lUGEAk2EZYN633ZFodbXXh3s+2Dt/VNK
         zQy6/WAKuv/trUi5xiVO1W94jK+h4idpn9JHU0qKMtprPTZYeYnUqEhiJ4prW6rRPQWa
         yfe1wQ2shP26u/j6SvWI8j7Ycy5ZPYCjNyXJlKtNU4oUQWdmjl0UlpEe5FYgJQrOTqeV
         f/Spx25fdneBKqeZDzPECPzKSNPCX6CpYTi7wkGafmQP1uXlbnFrWzqrip8rB4cRlKPt
         FpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6mm4TwDU0EQC4agqLfuyOy/11Do/Eo/Z1FMIy3HRwDs=;
        b=iq+jIBaP9g+nzPvMv5RV7q5oTrNDij3aRgDIpjpSnr7x/8Yne+YjKzlJzG9x2WsSLH
         L9tmebHjWTcb6lk8DE7fBWOCb7sfASP7NNjIWNoKfax8HiG1jzlcdEQ3ShDe5IhM7nb/
         OEMWrCnNtOED+9O5Pmg3lfo3w4AgshKLFOr2ittEkqHaFLxNLzDnFLUgrmXxa1G2/1Po
         9uBZuSdpyFajsCAxz1eZlWaqvzLBCoRsGAWxTrnj2KGjEO/KWJmUPPNC5GPmhPhMUhU9
         UfuOZEc2VYXXFh51irk+RLiy5npaqNC0PXhXj6TLjcqukbkVDp6lNCAw/fembdaNZRAR
         AeXw==
X-Gm-Message-State: AOAM532PRGfAiYhqfO8DMWbgq+1gvv6mvkNVXkdVug0Arndb9/9AOug5
        mc06//NfNp9YmiABkf+tk4g=
X-Google-Smtp-Source: ABdhPJzpK4aY4Efpw/Vbf7XI2wObiBt8q6IWrhM/TfVFTkS5KFKe8YRzjEmet+YgWCo9gT2S3n7Jhw==
X-Received: by 2002:a05:6e02:b4c:: with SMTP id f12mr11145321ilu.214.1625502477198;
        Mon, 05 Jul 2021 09:27:57 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id c23sm7202327ioz.42.2021.07.05.09.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 09:27:56 -0700 (PDT)
Date:   Mon, 05 Jul 2021 09:27:49 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <60e333051eb3d_20ea20862@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXwTJ4kKNtcH27VVvX+bYFKTvVnM_RtP5G7zg_Nt9QBYw@mail.gmail.com>
References: <20210702001123.728035-1-john.fastabend@gmail.com>
 <20210702001123.728035-2-john.fastabend@gmail.com>
 <CAM_iQpXwTJ4kKNtcH27VVvX+bYFKTvVnM_RtP5G7zg_Nt9QBYw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 1/2] bpf, sockmap: fix potential msg memory leak
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Thu, Jul 1, 2021 at 5:12 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > If skb_linearize is needed and fails we could leak a msg on the error
> > handling. To fix ensure we kfree the msg block before returning error.
> > Found during code review.
> >
> > Fixes: 4363023d2668e ("bpf, sockmap: Avoid failures from skb_to_sgvec when skb has frag_list")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/skmsg.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index 9b6160a191f8..22603289c2b2 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -505,8 +505,10 @@ static int sk_psock_skb_ingress_enqueue(struct sk_buff *skb,
> >          * drop the skb. We need to linearize the skb so that the mapping
> >          * in skb_to_sgvec can not error.
> >          */
> > -       if (skb_linearize(skb))
> > +       if (skb_linearize(skb)) {
> > +               kfree(msg);
> >                 return -EAGAIN;
> > +       }
> >         num_sge = skb_to_sgvec(skb, msg->sg.data, 0, skb->len);
> >         if (unlikely(num_sge < 0)) {
> >                 kfree(msg);
> 
> I think it is better to let whoever allocates msg free it, IOW,
> let sk_psock_skb_ingress_enqueue()'s callers handle its failure.

Sure, although we already have the one kfree(msg) below. Anyways
I'll just move these back a bit. Agree it is slightly nicer.

Thanks.

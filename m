Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2456E99DD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDTQsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTQsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:48:32 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C69269E;
        Thu, 20 Apr 2023 09:48:31 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-74ab718c344so259452185a.1;
        Thu, 20 Apr 2023 09:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682009310; x=1684601310;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkIWak2A4gt4tfUK76u+vQRENb/aYt6+KfdjwfD4yF0=;
        b=naCNoMt5etsGRGVmZg6X7R9HX4F5UL+J95xplxtF/6rg+GlVFsb3c+mB9NQtQZmG2c
         G/872gl2i7X2lH580mnM+163SH3hfqVpvFK5gVtgnnEKwIrAVLbmJ+0WURNXqbG6UpX9
         tfnGuYf6FKhcAUb4ZBWPs/X3FRQwt5xAiQBbrpMFr4No+zTOsLZCGp6M32lzzoO0H60q
         /yY/79q/1MkajM8addf07UmD9dldIosRpMC3OFH7Ay7r2CcB4MBZSMBx8DYs2sO1Ivo8
         haIc0SiObCgrIpKH9+WoS7FXIodBRTo8W24N9PA+eUJ9c85K/zt4S/+Hsu5H5kZwgZOp
         jo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009310; x=1684601310;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qkIWak2A4gt4tfUK76u+vQRENb/aYt6+KfdjwfD4yF0=;
        b=jUOh/C8QLfggfdS9ZL9cDyMPj9koeTUGnMf+B/7JtlNsjyIO8BqIIxMmAPPd3XPFBO
         DafWO1Pp7t/CRTsfUihbIJrnP0/sGgqR9H949lsiFina8yZrcoGrVz5q36BYjdH/sDFu
         3J3eunc39HnSzy7NqUux8dMIxLTsp5ZYNggFSbWrCagFLRNrFTnDr5z9JurJgNWCuPA3
         tdDLjXGnXwAj/ZleGeQOfSwu2sM7xT46zEkiHbDCASct6VDcLvvZBqoKuEhSKOWPLGDL
         pTUxfs3zz5U53qfHk5xxRtybsrX2fjJ2473Ojw152osoIaTKJvc7CxoUqG6hq6RxlbT2
         eG5A==
X-Gm-Message-State: AAQBX9eod4lDxtUPpX2tYFvvd77pmWZZbth0kMIlMSrP0jiAEtl7K7S+
        MHuYO7v7zoYn2wopfUR6bIYoF4m4xjs=
X-Google-Smtp-Source: AKy350YlkQUPXkw0+w8pqF75MAwJsNXWC6VdzJ3PA1NW9zP8sAi4CspV522CwGupOsD71pDWK21OXA==
X-Received: by 2002:ac8:7f94:0:b0:3e3:9185:cb15 with SMTP id z20-20020ac87f94000000b003e39185cb15mr3563327qtj.7.1682009310119;
        Thu, 20 Apr 2023 09:48:30 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id q1-20020ac87341000000b003e4f1b3ce43sm609145qtp.50.2023.04.20.09.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:48:29 -0700 (PDT)
Date:   Thu, 20 Apr 2023 12:48:29 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Breno Leitao <leitao@debian.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     kuba@kernel.org, Jens Axboe <axboe@kernel.dk>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org,
        asml.silence@gmail.com, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Message-ID: <64416cdd84a8d_390ce2943b@willemb.c.googlers.com.notmuch>
In-Reply-To: <ZEFPrGSuDopUwi9V@gmail.com>
References: <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
 <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
 <ZDa32u9RNI4NQ7Ko@gmail.com>
 <6436c01979c9b_163b6294b4@willemb.c.googlers.com.notmuch>
 <ZDdGl/JGDoRDL8ja@gmail.com>
 <6438109fe8733_13361929472@willemb.c.googlers.com.notmuch>
 <ZD6Zw1GAZR28++3v@gmail.com>
 <643ef2643f3ce_352b2f2945d@willemb.c.googlers.com.notmuch>
 <ZEFPrGSuDopUwi9V@gmail.com>
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Breno Leitao wrote:
> On Tue, Apr 18, 2023 at 03:41:24PM -0400, Willem de Bruijn wrote:
> > Breno Leitao wrote:
> > > On Thu, Apr 13, 2023 at 10:24:31AM -0400, Willem de Bruijn wrote:
> > > > > How to handle these contradictory behaviour ahead of time (at callee
> > > > > time, where the buffers will be prepared)?
> > > > 
> > > > Ah you found a counter-example to the simple pattern of put_user.
> > > > 
> > > > The answer perhaps depends on how many such counter-examples you
> > > > encounter in the list you gave. If this is the only one, exceptions
> > > > in the wrapper are reasonable. Not if there are many.
> > > 
> > > 
> > > Hello Williem,
> > > 
> > > I spend sometime dealing with it, and the best way for me to figure out
> > > how much work this is, was implementing a PoC. You can find a basic PoC
> > > in the link below. It is not 100% complete (still need to convert 4
> > > simple ioctls), but, it deals with the most complicated cases. The
> > > missing parts are straighforward if we are OK with this approach.
> > > 
> > > 	https://github.com/leitao/linux/commits/ioctl_refactor
> > > 
> > > Details
> > > =======
> > > 
> > > 1)  Change the ioctl callback to use kernel memory arguments. This
> > > changes a lot of files but most of them are trivial. This is the new
> > > ioctl callback:
> > > 
> > > struct proto {
> > > 
> > >         int                     (*ioctl)(struct sock *sk, int cmd,
> > > -                                        unsigned long arg);
> > > +                                        int *karg);
> > > 
> > > 	You can see the full changeset in the following commit (which is
> > > 	the last in the tree above)
> > > 	https://github.com/leitao/linux/commit/ad78da14601b078c4b6a9f63a86032467ab59bf7
> > > 
> > > 2) Create a wrapper (sock_skprot_ioctl()) that should be called instead
> > > of sk->sk_prot->ioctl(). For every exception, calls a specific function
> > > for the exception (basically ipmr_ioctl and ipmr_ioctl) (see more on 3)
> > > 
> > > 	This is the commit https://github.com/leitao/linux/commit/511592e549c39ef0de19efa2eb4382cac5786227
> > > 
> > > 3) There are two exceptions, they are ip{6}mr_ioctl() and pn_ioctl().
> > > ip{6}mr is the hardest one, and I implemented the exception flow for it.
> > > 
> > > 	You could find ipmr changes here:
> > > 	https://github.com/leitao/linux/commit/659a76dc0547ab2170023f31e20115520ebe33d9
> > > 
> > > Is this what you had in mind?
> > > 
> > > Thank you!
> > 
> > Thanks for the series, Breno. Yes, this looks very much what I hoped for.
> 
> Awesome. Thanks.
> 
> > The series shows two cases of ioctls: getters that return an int, and
> > combined getter/setters that take a struct of a certain size and
> > return the exact same.
> >
> > I would deduplicate the four ipmr/ip6mr cases that constitute the second
> > type, by having a single helper for this type. sock_skprot_ioctl_struct,
> > which takes an argument for the struct size to copy in/out.
> 
> Ok, that is a good advice. Thanks!
> 
> > Did this series cover all proto ioctls, or is this still a subset just
> > for demonstration purposes -- and might there still be other types
> > lurking elsewhere?
> 
> It does not cover all the cases. I would say it cover 80% of the cases,
> and the hardest cases.  These are the missing cases, and what they do:
> 
> * pn_ioctl     (getters/setter that reads/return an int)
> * l2tp_ioctl   (getters that return an int)
> * dgram_ioctl  (getters that return an int)
> * sctp_ioctl   (getters that return an int)
> * mptcp_ioctl  (getters that return an int)
> * dccp_ioctl   (getters that return an int)
> * dgram_ioctl  (getters that return an int)
> * pep_ioctl    (getters that return an int)

Thanks for the thorough review.

So we have io_struct, io_int and o_int variants only. And the io_int
can use the proposed io_struct helper that takes an explicit length
to copy in and out.

 
> Here is what I am using to get the full list:
>  # ag  --no-filename -A 20 "struct proto \w* = {"  | grep .ioctl | cut -d "=" -f 2 | tr -d '\n'
> 
>  dccp_ioctl, dccp_ioctl, dgram_ioctl, tcp_ioctl, raw_ioctl, udp_ioctl,
>  udp_ioctl, udp_ioctl, tcp_ioctl, l2tp_ioctl, rawv6_ioctl, l2tp_ioctl,
>  mptcp_ioctl, pep_ioctl, pn_ioctl, rds_ioctl, sctp_ioctl, sctp_ioctl,
>  sock_no_ioctl
> 
> > If this is all, this looks like a reasonable amount of code churn to me.
> 
> Should I proceed and create a final patch? I don't see a way to break up
> the last patch, which changes the API , in smaller patches. I.e., the
> last patch will be huge, right?

Good point. So be it, then.
 
> > Three small points
> > 
> > * please keep the __user annotation. Use make C=2 when unsure to warn
> >   about mismatched annotation
> 
> ack!
> 
> > * minor: special case the ipmr (type 2) ioctls in sock_skprot_ioctl
> >   and treat the "return int" (type 1) ioctls as the default case.
> 
> ack!
> 
> > * introduce code in a patch together with its use-case, so no separate
> >   patches for sock_skprot_ioctl and sock_skprot_ioctl_ipmr. Either one
> >   patch, or two, for each type of conversion.
> 
> I am not sure how to change the ABI (struct proto) without doing all the
> protocol changes in the same patch. Otherwise compilation will be broken between
> the patch that changes the "struct proto" and the patch that changes the
> _ioctl for protocol X.  I mean, is it possible to break up changing
> "struct proto" and the affected protocols?
> 
> Thank you for the review and suggestions!
> 
> PS: I will take some days off next week, and I am planning to send the
> final patch when I come back.



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0B6E6D07
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 21:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbjDRTl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 15:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjDRTl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 15:41:27 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C34659B;
        Tue, 18 Apr 2023 12:41:26 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id oo30so15825522qvb.12;
        Tue, 18 Apr 2023 12:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681846885; x=1684438885;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dqdkta1Zk1UqyIAXbk1/CAopdFNFnp9tf0jtsKEKX/U=;
        b=k+BsMLjVgeY/JRtYXrnJI7vJ28yuIV8fhFcqK/kmJDiMB5YFSQbzH9svJL79M/gtvu
         VkXtGsnxtx/EqNRIl8oeR6K/kcokITpfVeYv6D7/FX6vBT1SPZJFAjj6YSU5U1EHyLM/
         brSazLGWCynYtMhGzcI9jBakr2lDu7uVETrKXbQat9FsDly4XNz+9FFrGEZ5B868rTpN
         Jyb9BpH/eHjDgs7P9638iPyZAgf9P7phn0RWP4cTLoJg3WbB9XYltFDYNufzNi6l8jhJ
         kM7LEU7ZG+svskLUAyWp8q0RtlTvZkPwFsMWHwil8kjM/j/WegL9cCFlceZl/xOq76bs
         NLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681846885; x=1684438885;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dqdkta1Zk1UqyIAXbk1/CAopdFNFnp9tf0jtsKEKX/U=;
        b=GPLt6N4rMdAMQerU/3omvHZgVSzr8A4JzRPh9KGDckM5G5b+3FjtwtfYVCbHN4uhma
         qa1sUDRGOFU6tPMmtfEJol3Kk00kHCXF5E054tFJFlNsX6wqA3LMVeQHK1sEiZ6+XbWO
         ak1+tZ8iewyeqiMnX/oTkBq1vwbjHLE1QWQKd9PNvuS2mFEp1HLhf4/dDI4/8pufdZ4d
         mTXEmudk9m/97g42nCUN9Qq1XNcpni05ev0bBUXaQO/bGlXxw36qACEno3tCKYRK3z1j
         Bim7DTjlSZ05sAdfNqHjFq8SYNZe7pLlppDFAYS6VCPxhY2sD1uOJd/zUfeDbPlDblhp
         xgIw==
X-Gm-Message-State: AAQBX9cuG1nyhUXDUO3Jd5r5+xevoff4YcD33dqAFyBdtC9F3TIGYE5r
        n0GP+SjpJY81KPUmGq3xkfo=
X-Google-Smtp-Source: AKy350Y3WRyEQO9TtYe/YYFXZqAOBuHoJeYs1uPJYBRJu7+rvTUnFvSGRVH65/YcG6Zgt2Qr5fL+Ag==
X-Received: by 2002:a05:6214:1c4e:b0:5e3:d150:3168 with SMTP id if14-20020a0562141c4e00b005e3d1503168mr25374707qvb.18.1681846885409;
        Tue, 18 Apr 2023 12:41:25 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id w14-20020a0cfc4e000000b005ef6ba1f4afsm2179222qvp.134.2023.04.18.12.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 12:41:24 -0700 (PDT)
Date:   Tue, 18 Apr 2023 15:41:24 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Breno Leitao <leitao@debian.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        kuba@kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        asml.silence@gmail.com, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Message-ID: <643ef2643f3ce_352b2f2945d@willemb.c.googlers.com.notmuch>
In-Reply-To: <ZD6Zw1GAZR28++3v@gmail.com>
References: <643573df81e20_11117c2942@willemb.c.googlers.com.notmuch>
 <036c80e5-4844-5c84-304c-7e553fe17a9b@kernel.dk>
 <64357608c396d_113ebd294ba@willemb.c.googlers.com.notmuch>
 <19c69021-dce3-1a4a-00eb-920d1f404cfc@kernel.dk>
 <64357bb97fb19_114b22294c4@willemb.c.googlers.com.notmuch>
 <20cb4641-c765-e5ef-41cb-252be7721ce5@kernel.dk>
 <ZDa32u9RNI4NQ7Ko@gmail.com>
 <6436c01979c9b_163b6294b4@willemb.c.googlers.com.notmuch>
 <ZDdGl/JGDoRDL8ja@gmail.com>
 <6438109fe8733_13361929472@willemb.c.googlers.com.notmuch>
 <ZD6Zw1GAZR28++3v@gmail.com>
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
> On Thu, Apr 13, 2023 at 10:24:31AM -0400, Willem de Bruijn wrote:
> > > How to handle these contradictory behaviour ahead of time (at callee
> > > time, where the buffers will be prepared)?
> > 
> > Ah you found a counter-example to the simple pattern of put_user.
> > 
> > The answer perhaps depends on how many such counter-examples you
> > encounter in the list you gave. If this is the only one, exceptions
> > in the wrapper are reasonable. Not if there are many.
> 
> 
> Hello Williem,
> 
> I spend sometime dealing with it, and the best way for me to figure out
> how much work this is, was implementing a PoC. You can find a basic PoC
> in the link below. It is not 100% complete (still need to convert 4
> simple ioctls), but, it deals with the most complicated cases. The
> missing parts are straighforward if we are OK with this approach.
> 
> 	https://github.com/leitao/linux/commits/ioctl_refactor
> 
> Details
> =======
> 
> 1)  Change the ioctl callback to use kernel memory arguments. This
> changes a lot of files but most of them are trivial. This is the new
> ioctl callback:
> 
> struct proto {
> 
>         int                     (*ioctl)(struct sock *sk, int cmd,
> -                                        unsigned long arg);
> +                                        int *karg);
> 
> 	You can see the full changeset in the following commit (which is
> 	the last in the tree above)
> 	https://github.com/leitao/linux/commit/ad78da14601b078c4b6a9f63a86032467ab59bf7
> 
> 2) Create a wrapper (sock_skprot_ioctl()) that should be called instead
> of sk->sk_prot->ioctl(). For every exception, calls a specific function
> for the exception (basically ipmr_ioctl and ipmr_ioctl) (see more on 3)
> 
> 	This is the commit https://github.com/leitao/linux/commit/511592e549c39ef0de19efa2eb4382cac5786227
> 
> 3) There are two exceptions, they are ip{6}mr_ioctl() and pn_ioctl().
> ip{6}mr is the hardest one, and I implemented the exception flow for it.
> 
> 	You could find ipmr changes here:
> 	https://github.com/leitao/linux/commit/659a76dc0547ab2170023f31e20115520ebe33d9
> 
> Is this what you had in mind?
> 
> Thank you!

Thanks for the series, Breno. Yes, this looks very much what I hoped for.

The series shows two cases of ioctls: getters that return an int, and
combined getter/setters that take a struct of a certain size and
return the exact same.

I would deduplicate the four ipmr/ip6mr cases that constitute the second
type, by having a single helper for this type. sock_skprot_ioctl_struct,
which takes an argument for the struct size to copy in/out.

Did this series cover all proto ioctls, or is this still a subset just
for demonstration purposes -- and might there still be other types
lurking elsewhere?

If this is all, this looks like a reasonable amount of code churn to me.

Three small points

* please keep the __user annotation. Use make C=2 when unsure to warn
  about mismatched annotation
* minor: special case the ipmr (type 2) ioctls in sock_skprot_ioctl
  and treat the "return int" (type 1) ioctls as the default case.
* introduce code in a patch together with its use-case, so no separate
  patches for sock_skprot_ioctl and sock_skprot_ioctl_ipmr. Either one
  patch, or two, for each type of conversion.


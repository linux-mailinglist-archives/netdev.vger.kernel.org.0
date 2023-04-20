Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D1C6E9772
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 16:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjDTOoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 10:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbjDTOoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 10:44:04 -0400
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386856583;
        Thu, 20 Apr 2023 07:44:00 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-2f87c5b4635so628976f8f.1;
        Thu, 20 Apr 2023 07:44:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682001838; x=1684593838;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QbffplO3VOZcBuvT0UOJ7mzyhsrhOlVkaEplR1sfDJk=;
        b=U/L2i5LnbmyYOvyskATWrU2jfCVkLCIWgyah/e/W8JTnVmasYx0KHWiLjMERERLU9M
         Pa7mml2g4v6B4HZQRqPeU6Aqi2nKJ7tbsb4wAA2yVV+35u0xepuk/Moo14bbKMefPB68
         KBTd2/VB84IBldRJJi4STuluOcBdNdlbu7Y/CKzP5Oaf02b0WhFWvzSqI0u4ZRlMAqXz
         TwWv6UK2DL0sLbPL+wnM5q+gCuDyfyUTamEV25Deyn/m4ALR4Z4ISJ0YydexyNuEln5P
         ooOGXCkx+I4edw3FSTJ+NqAR9C+YxGdDul5RkWin+f3TaHrCyPnykRU2rqs9RUFVoDJB
         yKbA==
X-Gm-Message-State: AAQBX9f8YFjbytMDRwdFK5F3ShShSJLsqY8shZDNS1uGAJ3RW+87UoSC
        +pBP8V1yCO/VzyA6bLc9BWo=
X-Google-Smtp-Source: AKy350bFMAekMWmVpbReB2mEMQlH58SOps8pRO56YWnsO6OvZe+Bv8fTq/PabS3BkG4Y1rRHi/yj9Q==
X-Received: by 2002:a05:6000:12c9:b0:2fa:ce3:9a0 with SMTP id l9-20020a05600012c900b002fa0ce309a0mr1400681wrx.36.1682001838483;
        Thu, 20 Apr 2023 07:43:58 -0700 (PDT)
Received: from gmail.com (fwdproxy-cln-004.fbsv.net. [2a03:2880:31ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id u15-20020a5d468f000000b002f5fbc6ffb2sm2154621wrq.23.2023.04.20.07.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 07:43:58 -0700 (PDT)
Date:   Thu, 20 Apr 2023 07:43:56 -0700
From:   Breno Leitao <leitao@debian.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     kuba@kernel.org, Jens Axboe <axboe@kernel.dk>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        io-uring@vger.kernel.org, netdev@vger.kernel.org,
        asml.silence@gmail.com, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, marcelo.leitner@gmail.com
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Message-ID: <ZEFPrGSuDopUwi9V@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <643ef2643f3ce_352b2f2945d@willemb.c.googlers.com.notmuch>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 03:41:24PM -0400, Willem de Bruijn wrote:
> Breno Leitao wrote:
> > On Thu, Apr 13, 2023 at 10:24:31AM -0400, Willem de Bruijn wrote:
> > > > How to handle these contradictory behaviour ahead of time (at callee
> > > > time, where the buffers will be prepared)?
> > > 
> > > Ah you found a counter-example to the simple pattern of put_user.
> > > 
> > > The answer perhaps depends on how many such counter-examples you
> > > encounter in the list you gave. If this is the only one, exceptions
> > > in the wrapper are reasonable. Not if there are many.
> > 
> > 
> > Hello Williem,
> > 
> > I spend sometime dealing with it, and the best way for me to figure out
> > how much work this is, was implementing a PoC. You can find a basic PoC
> > in the link below. It is not 100% complete (still need to convert 4
> > simple ioctls), but, it deals with the most complicated cases. The
> > missing parts are straighforward if we are OK with this approach.
> > 
> > 	https://github.com/leitao/linux/commits/ioctl_refactor
> > 
> > Details
> > =======
> > 
> > 1)  Change the ioctl callback to use kernel memory arguments. This
> > changes a lot of files but most of them are trivial. This is the new
> > ioctl callback:
> > 
> > struct proto {
> > 
> >         int                     (*ioctl)(struct sock *sk, int cmd,
> > -                                        unsigned long arg);
> > +                                        int *karg);
> > 
> > 	You can see the full changeset in the following commit (which is
> > 	the last in the tree above)
> > 	https://github.com/leitao/linux/commit/ad78da14601b078c4b6a9f63a86032467ab59bf7
> > 
> > 2) Create a wrapper (sock_skprot_ioctl()) that should be called instead
> > of sk->sk_prot->ioctl(). For every exception, calls a specific function
> > for the exception (basically ipmr_ioctl and ipmr_ioctl) (see more on 3)
> > 
> > 	This is the commit https://github.com/leitao/linux/commit/511592e549c39ef0de19efa2eb4382cac5786227
> > 
> > 3) There are two exceptions, they are ip{6}mr_ioctl() and pn_ioctl().
> > ip{6}mr is the hardest one, and I implemented the exception flow for it.
> > 
> > 	You could find ipmr changes here:
> > 	https://github.com/leitao/linux/commit/659a76dc0547ab2170023f31e20115520ebe33d9
> > 
> > Is this what you had in mind?
> > 
> > Thank you!
> 
> Thanks for the series, Breno. Yes, this looks very much what I hoped for.

Awesome. Thanks.

> The series shows two cases of ioctls: getters that return an int, and
> combined getter/setters that take a struct of a certain size and
> return the exact same.
>
> I would deduplicate the four ipmr/ip6mr cases that constitute the second
> type, by having a single helper for this type. sock_skprot_ioctl_struct,
> which takes an argument for the struct size to copy in/out.

Ok, that is a good advice. Thanks!

> Did this series cover all proto ioctls, or is this still a subset just
> for demonstration purposes -- and might there still be other types
> lurking elsewhere?

It does not cover all the cases. I would say it cover 80% of the cases,
and the hardest cases.  These are the missing cases, and what they do:

* pn_ioctl     (getters/setter that reads/return an int)
* l2tp_ioctl   (getters that return an int)
* dgram_ioctl  (getters that return an int)
* sctp_ioctl   (getters that return an int)
* mptcp_ioctl  (getters that return an int)
* dccp_ioctl   (getters that return an int)
* dgram_ioctl  (getters that return an int)
* pep_ioctl    (getters that return an int)


Here is what I am using to get the full list:
 # ag  --no-filename -A 20 "struct proto \w* = {"  | grep .ioctl | cut -d "=" -f 2 | tr -d '\n'

 dccp_ioctl, dccp_ioctl, dgram_ioctl, tcp_ioctl, raw_ioctl, udp_ioctl,
 udp_ioctl, udp_ioctl, tcp_ioctl, l2tp_ioctl, rawv6_ioctl, l2tp_ioctl,
 mptcp_ioctl, pep_ioctl, pn_ioctl, rds_ioctl, sctp_ioctl, sctp_ioctl,
 sock_no_ioctl

> If this is all, this looks like a reasonable amount of code churn to me.

Should I proceed and create a final patch? I don't see a way to break up
the last patch, which changes the API , in smaller patches. I.e., the
last patch will be huge, right?

> Three small points
> 
> * please keep the __user annotation. Use make C=2 when unsure to warn
>   about mismatched annotation

ack!

> * minor: special case the ipmr (type 2) ioctls in sock_skprot_ioctl
>   and treat the "return int" (type 1) ioctls as the default case.

ack!

> * introduce code in a patch together with its use-case, so no separate
>   patches for sock_skprot_ioctl and sock_skprot_ioctl_ipmr. Either one
>   patch, or two, for each type of conversion.

I am not sure how to change the ABI (struct proto) without doing all the
protocol changes in the same patch. Otherwise compilation will be broken between
the patch that changes the "struct proto" and the patch that changes the
_ioctl for protocol X.  I mean, is it possible to break up changing
"struct proto" and the affected protocols?

Thank you for the review and suggestions!

PS: I will take some days off next week, and I am planning to send the
final patch when I come back.

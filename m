Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4094516D2
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 22:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345541AbhKOVqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 16:46:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351035AbhKOVno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 16:43:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637012444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zs+2+ZTATogosdjkaXzNr5IQQ1VQzDW6+yjOk4xp5yY=;
        b=JqcO0gHPGL5SJB4DBeFOMXTl/clauRD93KwRIDfL0v2GZY32JMsLRanAcYzrqgFOqOv+aq
        gBClGipYcx5SHMea+eqa3+/sDIQy21oIf33xojiNGt3sTRLSLFy1z313vLa0iG2jeidGCn
        tZjyzU4Nyce0wtSvzbDjGkBxamiWmgg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-ypbvF-8DMfKLbAOF4Nh2MA-1; Mon, 15 Nov 2021 16:40:43 -0500
X-MC-Unique: ypbvF-8DMfKLbAOF4Nh2MA-1
Received: by mail-ed1-f70.google.com with SMTP id q17-20020aa7da91000000b003e7c0641b9cso3606800eds.12
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 13:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zs+2+ZTATogosdjkaXzNr5IQQ1VQzDW6+yjOk4xp5yY=;
        b=dQP6iKrZ+TQq6Bs3kaQmE4+Kj5DRvzVJU+I6hkm25W172qG5dGyicBuY6zVu1PUCOW
         rNKn6wdRqFTmpueUP7oyOJGEayGD2CRwtKcs2STfSXKQ1KoYZEXXwDcL1Y5uK38DQJdN
         IwI0Csyvi2I5lwinFYM9/ksrJQc4RDp32WQTpnCQnO2Pgp29Sm2qpcPmkOXgHSoI6won
         C5gmOsaRzSfZyr0sdxmm2BGvGBI5UxKZndR31Fi0e0JmQhAr6YP+x4iSCDX1maT1Z5CJ
         7U5+LB/OJaeyBLQoVy832NGAr0tZaBioMYSigi5k2LclmB3zU/QP9zCrWSuyY+mwmqCE
         wayA==
X-Gm-Message-State: AOAM533KH61lszq253qPEsB3lzK4zvR63Nf5HmI5yjOG6kdiyQ16wPpQ
        ZpbETCO5xkGQyI8qybSnyrcB4ic3zIuoTIlrF1iuZTFRO6/3NqzXOtyzijSAi75uhPCQhQtMnY7
        6jrLTVY+56/wNGVZv
X-Received: by 2002:a05:6402:22a5:: with SMTP id cx5mr2810139edb.334.1637012442515;
        Mon, 15 Nov 2021 13:40:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6JGHZ1j9puFyPzQlALmhRP6cyIrgxmU0wBVb2LuvpeEiSC3bFn2n7vSiL9S23J9RL5DqfRw==
X-Received: by 2002:a05:6402:22a5:: with SMTP id cx5mr2810111edb.334.1637012442373;
        Mon, 15 Nov 2021 13:40:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-229-135.dyn.eolo.it. [146.241.229.135])
        by smtp.gmail.com with ESMTPSA id z9sm8517435edb.50.2021.11.15.13.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 13:40:41 -0800 (PST)
Message-ID: <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
From:   Paolo Abeni <pabeni@redhat.com>
To:     Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Date:   Mon, 15 Nov 2021 22:40:40 +0100
In-Reply-To: <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
         <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-11-15 at 15:37 -0500, Soheil Hassas Yeganeh wrote:
> On Mon, Nov 15, 2021 at 2:02 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > Mostly small improvements in this series.
> > 
> > The notable change is in "defer skb freeing after
> > socket lock is released" in recvmsg() (and RX zerocopy)
> > 
> > The idea is to try to let skb freeing to BH handler,
> > whenever possible, or at least perform the freeing
> > outside of the socket lock section, for much improved
> > performance. This idea can probably be extended
> > to other protocols.
> > 
> >  Tests on a 100Gbit NIC
> >  Max throughput for one TCP_STREAM flow, over 10 runs.
> > 
> >  MTU : 1500  (1428 bytes of TCP payload per MSS)
> >  Before: 55 Gbit
> >  After:  66 Gbit
> > 
> >  MTU : 4096+ (4096 bytes of TCP payload, plus TCP/IPv6 headers)
> >  Before: 82 Gbit
> >  After:  95 Gbit
> 
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> 
> Wow, this is really impressive. I reviewed all the patches and I can't
> point out any issues other than the typo that Arjun has pointed out.
> Thank you Eric!

Possibly there has been some issues with the ML while processing these
patches?!? only an handful of them reached patchwork (and my mailbox :)

(/me was just curious about the code ;)

Cheers,

Paolo


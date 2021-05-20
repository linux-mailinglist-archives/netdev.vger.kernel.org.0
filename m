Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E66C38B560
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 19:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbhETRo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 13:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhETRo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 13:44:26 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B2C061574;
        Thu, 20 May 2021 10:43:03 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id g11so11963238ilq.3;
        Thu, 20 May 2021 10:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=eZmdq61uG3HkzcvMJ/HSaEOQnew3jJp5aSiKbov8Cck=;
        b=Da8PJWX3ztusnxQ5j/RDn/ZHdAIKuPGoDVft3PCViLKg+yPNZDDL9rNu9agTHpap1q
         58Yv8FzSzYM90FCtI+hCRKJo0RyWUV1ImOBujpZ3DIlOWwkQbIFb04XkqYgbdKDLJN8z
         TD+nGwLva3rYs9iAko7BHHEYTmYbim2FhrtOn40N3KlbFMvFmfUmNb+1ghoepE4Z7PBo
         uwwKVzqOxnatou6vzbX8ReVeW+SiazeXv/tzPB36YPsylZPdW3+HHC5CIUYnsU4JRzwr
         xNNvsCrG6QmBhi0kxGgSi2o3bJfQC0EtVyQ0Me5Nh1sffHXsaxmnmIKy7KeocSTBmv9V
         yIPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=eZmdq61uG3HkzcvMJ/HSaEOQnew3jJp5aSiKbov8Cck=;
        b=LAOnhPEoE3hjr8dxwuo62sbjK/zPZ6v575wF8iDRM4aCVCggRm3QKj1AVsZ8TCTtjq
         eDOW5KEN+Uu8idEpUggWYdLZW5cso6D5UJctNrkaHkd37nIpGDrvP0pnB3oM3gF7zqMR
         +DytgqNdmUzMt5ptb8c1M0kzXN4m30sx1MTWmnnH6UVaReeewhyK4MnPvBZKjjLqQzRA
         tc62cc0Sz4lbJFzKfQqjqPtvLqziGmuljWoi8xMLyHkMD4KZG+yuA9nGmVZ48azgg7EM
         FkG7tDVnV9fp7yyoHQ5hiSEHaC1k1e+ORLnZd2BKW+d6Sgck0FzYMo19/iDWh/G7i+KL
         xcug==
X-Gm-Message-State: AOAM532HzZr/qQkvm94qatQk+0en3T3jN7XFVy4Eq1ss6PX9GVLFQEoS
        Ji9e4FnX1VxTwV4qBm2NJbM=
X-Google-Smtp-Source: ABdhPJx0/tAmMEIE359/zuKKiIeOwchSJ1KCTXb0sFixqvKubov6L0hTAEpI2WtXAMxuwkKyTpjcAQ==
X-Received: by 2002:a92:d24a:: with SMTP id v10mr6290973ilg.247.1621532582462;
        Thu, 20 May 2021 10:43:02 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id p5sm3620466ilg.33.2021.05.20.10.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 10:43:01 -0700 (PDT)
Date:   Thu, 20 May 2021 10:42:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <60a69f9f1610_4ea08208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch>
 <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch>
 <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch>
 <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
 <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch>
 <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Wed, May 19, 2021 at 2:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Wed, May 19, 2021 at 12:06 PM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > > > > <john.fastabend@gmail.com> wrote:
> > > > > >
> > > > > > Cong Wang wrote:
> > > > > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > >
> > > > > > > > Cong Wang wrote:
> > > > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > > > >
> > > > > > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > > > > > done using it.
> > > > > > > >
> > > > > > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > > > > > >
> > > > > > > Sure, in case of error, no one uses the original skb either,
> > > > > > > so still need to free it.
> > > > > >
> > > > > > But the data is going to be dropped then. I'm questioning if this
> > > > > > is the best we can do or not. Its simplest sure, but could we
> > > > > > do a bit more work and peek those skbs or requeue them? Otherwise
> > > > > > if you cross memory limits for a bit your likely to drop these
> > > > > > unnecessarily.
> > > > >
> > > > > What are the benefits of not dropping it? When sockmap takes
> > > > > over sk->sk_data_ready() it should have total control over the skb's
> > > > > in the receive queue. Otherwise user-space recvmsg() would race
> > > > > with sockmap when they try to read the first skb at the same time,
> > > > > therefore potentially user-space could get duplicated data (one via
> > > > > recvmsg(), one via sockmap). I don't see any benefits but races here.
> > > >
> > > > The benefit of _not_ dropping it is the packet gets to the receiver
> > > > side. We've spent a bit of effort to get a packet across the network,
> > > > received on the stack, and then we drop it at the last point is not
> > > > so friendly.
> > >
> > > Well, at least udp_recvmsg() could drop packets too in various
> > > scenarios, for example, a copy error. So, I do not think sockmap
> > > is special.
> >
> > OK I am at least convinced now that dropping packets is OK and likely
> > a useful performance/complexity compromise.
> >
> > But, at this point we wont have any visibility into these drops correct?
> > Looks like the pattern in UDP stack to handle this is to increment
> > sk_drops and UDP_MIB_INERRORS. How about we do that here as well?
> 
> We are not dropping the packet, the packet is cloned and deliver to
> user-space via sk_psock_verdict_recv(), thus, we are simply leaking
> the original skb, regardless of any error. Maybe udp_read_sock()
> should check desc->error, but it has nothing to do with this path which
> only aims to address a memory leak. A separate patch is need to check
> desc->error, if really needed.
> 
> Thanks.

"We are not dropping the packet" you'll need to be more explicit on
how this path is not dropping the skb,

  udp_read_sock()
    skb = skb_recv_udp()
     __skb_recv_udp() 
       __skb_try_recv_from_queue()
        __skb_unlink()              // skb is off the queue
    used = recv_actor()
      sk_psock_verdict_recv()
        return 0; 
    if (used <= 0) {
      kfree(skb)         // skb is unlink'd and kfree'd
      break;
    return 0 

So if in the error case the skb is unlink'd from the queue and
kfree'd where is it still existing, how do we get it back? It
sure looks dropped to me. Yes, the kfree() is needed to not
leak it, but I'm saying we don't want to drop packets silently.
The convention in UDP space looks to be inc sk->sk_drop and inc
the MIB. When we have to debug this on deployed systems and
packets silently get dropped its going to cause lots of pain so
lets be sure we get the counters correct.

.John

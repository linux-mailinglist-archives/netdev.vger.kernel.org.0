Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40228279141
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 21:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbgIYTAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbgIYTAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 15:00:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05C0C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 12:00:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 197so3354202pge.8
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 12:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6yEZ87hbqUHFRRkw2yL30bTDWYndLrXdIaxUDaFXRg=;
        b=jyXBuC2gJtov3ebkeT04oAcOH5j1Zmjf0r6cZgbWIl65F5CHVkrMoP+SBlEdHL2Ptz
         w4Sewvkc8ZaAnNB1TDLFS7Kc29iy5pPaYgsCgJbIdKaC4w0P8vznKd55gZhzCOcw4Dvk
         S+JMGdGl7BoZms4AZsWeiyJG2hS/Pqak+qCaaVvUjadqSZ6BCTo6dlQyg8vJJEASPNrX
         pNVEUTEpr5ODGylzBSlk6XTqzA4DmOGAiaLLVmpsl492mtYw9kcFCBPqvPy4FC3/cLtO
         fMJC33NbtlfeLprLQglG08FvSyF41k6vRI2UPqzJK8RH9GBIRidia4nKzEmi18L+IIlV
         mCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6yEZ87hbqUHFRRkw2yL30bTDWYndLrXdIaxUDaFXRg=;
        b=TRaqxO0sn2wNgrazmF50uEhUTPhcpmnAcHuHPCxIr5VK/4/KVbmurU7/Qhuho6lu2U
         dgywuFTkEH1CIs5QHzViKI4BhoP90tN6c8geS6wRBj+7gOu0ma7bzQYCIsGaQ5UP6spM
         oQZ8Kkg+CGX8EI/TZFbuQxu0T4Kxf299xTwoGu6w8qK1EXRubOBPI5PtkK9UVC+h57Rd
         rR7iR6TcuOXfbCdbnVfpgvGnIFXU80KxvHhunuyTEjccrLZCYVpSSqgY44Mc1OyNJxeI
         G2pDqACcFIwXApHwYJYSpAqR7l9olOi5joslKlb1fpHLvvAEGnqMx5LqRWhUgblju8pz
         p9qg==
X-Gm-Message-State: AOAM532YbNoOPk2M1bTq9pDQRTaw7ryGwUG/bH/F5AI2KLogcAT8LW+K
        s4Cke+dzD2LQZHbDvN3aPqdfIrSSZCiWGA==
X-Google-Smtp-Source: ABdhPJzG/RWEX3HZdOccQnD6YEI05uOYIuAN1XiLC3pTVRxxOAVUjtXIgH6r34X87pqRWAiQ3K9otQ==
X-Received: by 2002:a63:f90d:: with SMTP id h13mr294653pgi.227.1601060437129;
        Fri, 25 Sep 2020 12:00:37 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q10sm2684911pja.48.2020.09.25.12.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 12:00:36 -0700 (PDT)
Date:   Fri, 25 Sep 2020 12:00:28 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
Message-ID: <20200925120028.65b5cd6d@hermes.lan>
In-Reply-To: <CANn89iKAaKnZb3+RdMkK+Lx+5BBs=0Lnzwhe_jkzP4A8qHFZTg@mail.gmail.com>
References: <20200914172453.1833883-1-weiwan@google.com>
        <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
        <CAEA6p_BBaSQJjTPicgjoDh17BxS9aFMb-o6ddqW3wDvPAMyrGQ@mail.gmail.com>
        <20200925111627.047f5ed2@hermes.lan>
        <CANn89iKAaKnZb3+RdMkK+Lx+5BBs=0Lnzwhe_jkzP4A8qHFZTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Sep 2020 20:23:37 +0200
Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Sep 25, 2020 at 8:16 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Fri, 25 Sep 2020 10:15:25 -0700
> > Wei Wang <weiwan@google.com> wrote:
> >  
> > > > > In terms of performance, I ran tcp_rr tests with 1000 flows with
> > > > > various request/response sizes, with RFS/RPS disabled, and compared
> > > > > performance between softirq vs kthread. Host has 56 hyper threads and
> > > > > 100Gbps nic.  
> >
> > It would be good to similar tests on othere hardware. Not everyone has
> > server class hardware. There are people running web servers on untuned
> > servers over 10 years old; this may cause a regression there.
> >
> > Not to mention the slower CPU's in embedded systems. How would this
> > impact OpenWrt or Android?  
> 
> Most probably you won't notice a significant difference.
> 
> Switching to a kthread is quite cheap, since you have no MMU games to play with.

That makes sense, and in the past when doing stress tests the napi
work was mostly on the kthread already.

> >
> > Another potential problem is that if you run real time (SCH_FIFO)
> > threads they have higher priority than kthread. So for that use
> > case, moving networking to kthread would break them.  
> 
> Sure, playing with FIFO threads is dangerous.
> 
> Note that our plan is still to have softirqs by default.
> 
> If an admin chose to use kthreads, it is its choice, not ours.
> 
> This is also why I very much prefer the kthread approach to the work
> queue, since the work queue could not be fine tuned.

Agree with you, best to keep this as opt-in.

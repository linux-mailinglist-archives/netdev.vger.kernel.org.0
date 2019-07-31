Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD37B728
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 02:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfGaAXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 20:23:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46555 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGaAXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 20:23:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id c3so7595066pfa.13
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 17:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vx0Uf+iivZfhQ5eaxpeA+I7ZUhlEpyzb2ZwTHUiqkMM=;
        b=Zjn8zMSiL40/pSef6bwBxavl0IfUJuDGb4pd7HQYqGCEYl77OdcAcO6lkeaMnexajw
         ADyNMLyxqWhL1CIAj+vTRWNNS1MkazU2dvYTD1ZCQ3+cKIcQgr5uG/AhmSC8z6eJ7QFN
         0T+/bWJzA1fKiDrRjM0gHdu9ees0YbgdqLMTGuYeP6oLrh6JDFhJhmESykzlH1b07OBV
         e54SoIUizrEmwB9AK9loTpPJoMLmrF+UdSVSwgByStlXd52wyePEi1KFP5Kv9kX0tgFT
         VrDvZW7HqWIyz0tiwu6FGmOJWaEHoLyGRNlOSSVAR6uK9utjR+RrPvY0LiZXogABf+AL
         D+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vx0Uf+iivZfhQ5eaxpeA+I7ZUhlEpyzb2ZwTHUiqkMM=;
        b=VykO2OfUKKbh1oPOr+4wD+Pk0Ry2sPVVdWLR1Noi/oA+2X8WcvzbzrDLZnCPM1iFOi
         Y3O9awXd/LpkXwFNGK3n2aA2/0ZkWwP5PfTSSNwWP4smlaWkwg8mIn8lsws9wTLauLkK
         NDayH6yAglzRdqgVhcWqOikIOY5RsJ39KZHBMH+N3U6lSV4oeDj1ylWB77bOMCPh1K6i
         8cPFjtVmJNPFbYQWTdZcB9RsFlJJ8xwUEjqt7FbwQyVNJT+sMxnY2fs7Q/933fqraOd5
         8Ev+U+2xIa8LhBVl5/w7wrwQLdxru84zg7eAD6J3thekqP5Ogk4BIsHt1dFmX3IM+M36
         jLwA==
X-Gm-Message-State: APjAAAWGg/TBi/j0X5BcZDjqPQHLUiHRDoMq471YN/Xl4W86GMfMhhWQ
        SgWxiOGLy0NEvQQohNbFd2Q=
X-Google-Smtp-Source: APXvYqz17CMXvZNVD3gBEo09GskKaUkUvECR+04yvKtQICkImtf4BbyblLBpludwycS0UhnLq5mnPA==
X-Received: by 2002:a62:3283:: with SMTP id y125mr45248126pfy.83.1564532622301;
        Tue, 30 Jul 2019 17:23:42 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::3:af4b])
        by smtp.gmail.com with ESMTPSA id o13sm7315pje.28.2019.07.30.17.23.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 17:23:41 -0700 (PDT)
Date:   Tue, 30 Jul 2019 17:23:39 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] tools: bpftool: add net (un)load command to load XDP
Message-ID: <20190731002338.d4lp2grsmm3aaav3@ast-mbp>
References: <20190730184821.10833-1-danieltimlee@gmail.com>
 <20190730155915.5bbe3a03@cakuba.netronome.com>
 <20190730231754.efh3fj4mnsbv445l@ast-mbp>
 <20190730170725.279761e7@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730170725.279761e7@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 05:07:25PM -0700, Jakub Kicinski wrote:
> On Tue, 30 Jul 2019 16:17:56 -0700, Alexei Starovoitov wrote:
> > On Tue, Jul 30, 2019 at 03:59:15PM -0700, Jakub Kicinski wrote:
> > > On Wed, 31 Jul 2019 03:48:19 +0900, Daniel T. Lee wrote:  
> > > > Currently, bpftool net only supports dumping progs loaded on the
> > > > interface. To load XDP prog on interface, user must use other tool
> > > > (eg. iproute2). By this patch, with `bpftool net (un)load`, user can
> > > > (un)load XDP prog on interface.  
> > > 
> > > I don't understand why using another tool is a bad thing :(
> > > What happened to the Unix philosophy?
> > > 
> > > I remain opposed to duplicating iproute2's functionality under 
> > > bpftool net :( The way to attach bpf programs in the networking
> > > subsystem is through the iproute2 commends - ip and tc.. 
> > > 
> > > It seems easy enough to add a feature to bpftool but from 
> > > a perspective of someone adding a new feature to the kernel, 
> > > and wanting to update user space components it's quite painful :(
> > > 
> > > So could you describe to me in more detail why this is a good idea?
> > > Perhaps others can chime in?  
> > 
> > I don't think it has anything to do with 'unix philosophy'.
> > Here the proposal to teach bpftool to attach xdp progs.
> > I see nothing wrong with that.
> 
> Nothing meaning you disagree it's duplicated effort and unnecessary 
> LoC the community has to maintain, review, test..?

I don't see duplicated effort.

> > Another reason is iproute2 is still far away from adopting libbpf.
> > So all the latest goodness like BTF, introspection, etc will not
> > be available to iproute2 users for some time.
> 
> Duplicating the same features in bpftool will only diminish the
> incentive for moving iproute2 to libbpf. 

not at all. why do you think so?

> And for folks who deal
> with a wide variety of customers, often novices maintaining two
> ways of doing the same thing is a hassle :(

It's not the same thing.
I'm talking about my experience dealing with 'wide variety of bpf customers'.
They only have a fraction of their time to learn one tool.
Making every bpf customer learn ten tools is not an option.

> > Even when iproute2 is ready it would be convenient for folks like me
> > (who need to debug stuff in production) to remember cmd line of
> > bpftool only to introspect the server. Debugging often includes
> > detaching/attaching progs. Not only doing 'bpftool p s'.
> 
> Let's just put the two commands next to each other:
> 
>        ip link set xdp $PROG dev $DEV
> 
> bpftool net attach xdp $PROG dev $DEV
> 
> Are they that different?

yes.
they're different tools with they own upgrade/rollout cycle

> 
> > If bpftool was taught to do equivalent of 'ip link' that would be
> > very different story and I would be opposed to that.
> 
> Yes, that'd be pretty clear cut, only the XDP stuff is a bit more 
> of a judgement call.

bpftool must be able to introspect every aspect of bpf programming.
That includes detaching and attaching anywhere.
Anyone doing 'bpftool p s' should be able to switch off particular
prog id without learning ten different other tools.
iproute2 is a small bit of it. There is cgroup and tracing too.
bpftool should be one tool to do everything directly related to bpf.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D56B46430
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 18:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNQcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 12:32:24 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36850 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbfFNQcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 12:32:23 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so1780442pfl.3
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 09:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qDjm7fOa1jHEEMb2u36MM+18haayLLmJH4+ov3pfKD0=;
        b=0SvRVM9g1semiEw3ORxpODaxQx7GPauhH8fsH30qbiT7razUk+3jn42zOuEpOe1tdH
         ny4RfrV106981MCguJR2Dig97VFSwpIAWBNwhVc/Fjqw6d4JRldDqMvu88X6Ol2Fbq24
         TgWQcPhA2TlkI83hVotld5pQlDMriYLzkiDQnRSfCr+PyLXGK7Vsa6mI39p0Odt0aHIU
         OXzsx5tleY3mhRUJAae/j6ByBhXReElFGKnXtIf0PDGSqb0hT9SF/0uDsHver0bTvP63
         1AN94lRhcrA1lBYjcIAp7Wv8RPWCBWxLNZcW2F6eIWCye1IOqUcjG3ze/65Ay7L4Vy/O
         ZXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qDjm7fOa1jHEEMb2u36MM+18haayLLmJH4+ov3pfKD0=;
        b=UNRXXGXb55lobQDAP2X+PwE13rG2HtFNjinlvzeKDrrRSDz+Arte8qdWYoPsZnuJUE
         nC3BHfhnAuilKkJEmFKF2NYbtHUlBgbQE+FvljFvA8qm1VYKPNOnx2DQVD6ejoFf6mac
         IU4yBCiOpUfFaQt4Qfsx/OzepxtW0Ja3NS7gKo8hNpWN3ZA73IMbu895t2YgmrsFX1Q1
         lt3AlLKqZzacSJXJYgBfYLeuwuu/noPMsDnu+ZFAL7Ze6Lx64yomrckWGIcrKjnV9pSt
         pvXH+oTE0mL6LdkWtU/RU6rY6kpdPcm81nu0eOYRAe4I8cyof9Pa+gwtBo3SQ0obraeT
         avzg==
X-Gm-Message-State: APjAAAWpHfm70qtHeq/jdLtc1ZjOfHmhfPYp/AbHTNtLQrYUlmE0fUtO
        racM++62t1wM16dXyWA4qjI7CA==
X-Google-Smtp-Source: APXvYqwjDOVDUqKF3aDWmIqr1f5hUOfQqQITFkqTmAvQATa5skM7XBh5gdrcv1KC4fiznqZhlSDpuQ==
X-Received: by 2002:a63:b90d:: with SMTP id z13mr33103683pge.16.1560529942979;
        Fri, 14 Jun 2019 09:32:22 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id d12sm3633286pfd.96.2019.06.14.09.32.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 09:32:20 -0700 (PDT)
Date:   Fri, 14 Jun 2019 09:32:19 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190614163219.GE9636@mini-arch>
References: <20190610210830.105694-1-sdf@google.com>
 <20190610210830.105694-2-sdf@google.com>
 <20190613201632.t7npizqhtnohzwmc@ast-mbp.dhcp.thefacebook.com>
 <20190613212020.GB9636@mini-arch>
 <CAEf4Bza0D6=4a6D1ErpT+nh8_byufOz4qhvBmCsBV9zLFHP0eA@mail.gmail.com>
 <20190613215400.GC9636@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613215400.GC9636@mini-arch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13, Stanislav Fomichev wrote:
> > > My canonical example when reasoning about multiple progs was that each one
> > > of them would implement handling for a particular level+optname. So only
> > > a single one form the chain would return 2 or 0, the rest would return 1
> > > without touching the buffer. I can't come up with a good use-case where
> > > two programs in the chain can both return 2 and fill out the buffer.
> > > The majority of the sockopts would still be handled by the kernel,
> > > we'd have only a handful of bpf progs that handle a tiny subset
> > > and delegate the rest to the kernel.
> > >
> > > How about we stop further processing as soon as some program in the chain
> > > returned 2? I think that would address most of the concerns?
> > 
> > What about a case of passive "auditing" BPF programs, that are not
> > modifying anything, but want to capture every single
> > getsockopt/setsockopt call? This premature stop would render that
> > whole approach broken.
> In that case you'd attach that program to the root of a cgroup
> (sub)tree what you want to audit (and it would be always executed and
> would return 1)? And you'd have to attach it first.
On a second thought, that's not true. BPF progs are executed from the
bottom up, so attaching to the root cgroup wouldn't work for that auditing
case :-/

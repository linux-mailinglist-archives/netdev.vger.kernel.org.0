Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47790113948
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfLEBZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:25:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34201 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728100AbfLEBZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 20:25:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id r11so771201pgf.1;
        Wed, 04 Dec 2019 17:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wXoUdUAHKBaISydzla24j9JfZxsUNvCsquV32FT8FOQ=;
        b=phmsT3F4dF0M14EPNcg1am1sOwSFkUyx2bfTW7oyKgyBs6tMSSUqmQybaTa+SxoT8l
         4R7XUIrwJohdQmYQsh0vmaFM1ddr0vjA2GinZKjqo8H2LshXlCu7S6RFyds0WDMO0d1g
         z/+OlyBHFg5S7gyP932sjS2IOw/LCWfFvWNuV8p+BIJDXXUjiPOhSTOGbeneW4bhk/es
         dvMFkLXqByYlBcuhwT7w8dIRrfyd/mpgGc6f6gfgzhtW0Ukscvu/KvTq82qV1VBQ+5VI
         uO15mPsEf9USZPfc+63kqOnecNcfz9WZoeIEgHz+N9keViErJuJwSU5IE7Ej4lYHF1z7
         PAJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wXoUdUAHKBaISydzla24j9JfZxsUNvCsquV32FT8FOQ=;
        b=dZVZgrGDEzjxfYYQo2xML8zb+ixwy9jzjr+fKFTO0JZMCKR0+RprKNpLLIXuVbguru
         eAz/Km0VQqS8NGkqkrLN62NevfFXI3VkUfst1AQFDyIdbxKfK8yPOgL70Poxvll2As6r
         eCbKNaJw0fF/NNdb9N4t38E8wrn3ArP0PZJmab6IX0kThHhhe6u2XZ0XxGtRSTjM1s0l
         dscO598TYACn8sLi96gEEk3NLKMWrqLHlvQZ7NisO8v4Zch6ge5gVofRqm3fQOA2VIln
         CI6N0QzdnYKrOuozOLo4TWxJvCpXItYJT3et0MSHAAKsQ9Pz4HU2kVUxUaFREL9DDLKd
         y07A==
X-Gm-Message-State: APjAAAW5t1GztWdmepr/qQdfw2rLMzqdAZg86Cv+tflelY3Nsa7JXnXH
        IiOcFnnZWPcjSd7zi7Id7Ik=
X-Google-Smtp-Source: APXvYqzmIQuYJ2DE6q81jtTR+ElGMC0qA/OyVhOQZZGU/rOaWupztTcnh3V+XBhGZqkkjdMUYLQDwQ==
X-Received: by 2002:a63:5657:: with SMTP id g23mr6554594pgm.452.1575509129665;
        Wed, 04 Dec 2019 17:25:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f9fe])
        by smtp.gmail.com with ESMTPSA id c68sm9907694pfc.156.2019.12.04.17.25.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 17:25:28 -0800 (PST)
Date:   Wed, 4 Dec 2019 17:25:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     andrii.nakryiko@gmail.com, toke@redhat.com, jolsa@kernel.org,
        acme@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, mingo@kernel.org,
        namhyung@kernel.org, alexander.shishkin@linux.intel.com,
        a.p.zijlstra@chello.nl, mpetlan@redhat.com, brouer@redhat.com,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, quentin.monnet@netronome.com
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
Message-ID: <20191205012525.lpp5ilieupftpqrd@ast-mbp.dhcp.thefacebook.com>
References: <20191204135405.3ffb9ad6@cakuba.netronome.com>
 <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
 <20191204162348.49be5f1b@cakuba.netronome.com>
 <20191204.162929.2216543178968689201.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204.162929.2216543178968689201.davem@davemloft.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 04:29:29PM -0800, David Miller wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Wed, 4 Dec 2019 16:23:48 -0800
> 
> > Jokes aside, you may need to provide some reasoning on this one..
> > The recommendation for packaging libbpf from GitHub never had any 
> > clear justification either AFAICR.
> > 
> > I honestly don't see why location matters. bpftool started out on GitHub
> > but we moved it into the tree for... ease of packaging/distribution(?!)
> > Now it's handy to have it in the tree to reuse the uapi headers.
> > 
> > As much as I don't care if we move it (back) out of the tree - having
> > two copies makes no sense to me. As does having it in the libbpf repo.
> > The sync effort is not warranted. User confusion is not warranted.
> 
> Part of this story has to do with how bug fixes propagate via bpf-next
> instead of the bpf tree, as I understand it.
> 
> But yeah it would be nice to have a clear documentation on all of the
> reasoning.
> 
> On the distro side, people seem to not want to use the separate repo.
> If you're supporting enterprise customers you don't just sync with
> upstream, you cherry pick.  When cherry picking gets too painful, you
> sync with upstream possibly eliding upstream new features you don't
> want to appear in your supported product yet.
> 
> I agree with tying bpftool and libbpf into the _resulting_ binary
> distro package, but I'm not totally convinced about separating them
> out of the kernel source tree.

Looks like there is a confusion here.
I'm not proposing to move bpftool out of kernel tree.
The kernel+libbpf+bpftool+selftests already come as single patch set.
bpftool has to stay in the kernel tree otherwise things like skeleton
patchset won't be possible to accomplish without a lot of coordination
between different trees and propagation delays.

I'm proposing to tweak github/libbpf sync script to sync bpftool
sources from kernel into github, so both libbpf and bpftool can be
tested and packaged together.
People are working on adding proper CI to github/libbpf.
bpftool testing will automatically get more mileage out of that effort.

github/libbpf is self contained. It should be built and tested
on many different kernels and build environments (like any user
space package should be). That's an important goal of CI.
When bpftool is part of github/libbpf it will get the same treatment.
I see only advantages and not a single disadvantage of building,
testing, packaging bpftool out of github/libbpf.

To support stable libbpf+bpftool releases we can branch in github and push
fixes into branches. Same CI can test master and stable branches.


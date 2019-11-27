Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD9510A80B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 02:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfK0BjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 20:39:05 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46806 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfK0BjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 20:39:05 -0500
Received: by mail-qk1-f195.google.com with SMTP id h15so18013478qka.13;
        Tue, 26 Nov 2019 17:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=15pddQ+tJiIXUfy3ihFVIOBDW7KImamgJuRtImRC8/8=;
        b=JpsOGGnmffjuhrKG3Xn/W8jh9MetQvivpVP1UDN3ItLqXlzeuYVFJlHSBAciEqQ8cR
         hggzbzT6n1imn8zpPvLUI+Tu2NAGgx4Z9iRT3bKCUgFdxvbGMpeUf9LH2cLN3ccxbaIu
         LqNCQ+PmPgWy5jZnbxLQNXHVFqjxvwVdfXZWr/h0mvVUOLaud4aUa1zGoJRt2Bi2aC4j
         jDXYbkZDkY0EiM3L8vJivLUvBHElfGmzLFpguphf9hnGGJyiXLg4942Pq4bVPjaJ8HO5
         l7LMqP3sRdZOVw/kQXAqJ+TZ1JqVgYu8xBo2M5+6hDa5XH5gXyO74Wq5UGkminHJvzzZ
         tAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=15pddQ+tJiIXUfy3ihFVIOBDW7KImamgJuRtImRC8/8=;
        b=nxc54wds44IM4UiuerJ5rfAVoSePuRYDu55V00AHMLh5t96zEqj0IlaS0SCJMH5gKR
         GuXW7tJ8UKN81M1P9MiNiqKyIW6USzLZ0VQ7xbgLJekK/j+56Mx4gnUHi1DwI03PCh8c
         q7VCzGVeM7qN73o0vEfw+wlfXkUctmefH8sppkllDNJ8JBJgI4w3qFecCfVD/18DJqDG
         uz65Wwg0UNfpkAYWBwcaUpZjtC2t/tkffRsBQJJOad1eGjGpPf/ETY1RJDgKCTyJFj1W
         RKNNLVveXrQZaz0TRMsBKdvAD+KOhUnX3yGNTQbnIkRd2jGajAxwc7C/Xi+iqWeWvML4
         NLFw==
X-Gm-Message-State: APjAAAV2d2aUBSAyvKArVoVFxo61UHCOhlMgHldqda1hHA3A9lQP8z8z
        b5+1PJJkPXYKaFzNclV5aSw=
X-Google-Smtp-Source: APXvYqxyqfW1iC0L6IJaIs2yrtW6M2tsaXpXRL10YGWr5f+FMbMJnZYV8EUGHOf2mk1pGCVhXiaduA==
X-Received: by 2002:a05:620a:14bc:: with SMTP id x28mr1746213qkj.494.1574818744384;
        Tue, 26 Nov 2019 17:39:04 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id n185sm5990392qkd.32.2019.11.26.17.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 17:39:03 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3660740D3E; Tue, 26 Nov 2019 22:39:01 -0300 (-03)
Date:   Tue, 26 Nov 2019 22:39:01 -0300
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
Message-ID: <20191127013901.GE29071@kernel.org>
References: <87imn6y4n9.fsf@toke.dk>
 <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk>
 <20191126190450.GD29071@kernel.org>
 <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
 <20191126221018.GA22719@kernel.org>
 <20191126221733.GB22719@kernel.org>
 <CAEf4BzbZLiJnUb+BdUMEwcgcKCjJBWx1895p8qS8rK2r5TYu3w@mail.gmail.com>
 <20191126231030.GE3145429@mini-arch.hsd1.ca.comcast.net>
 <20191126155228.0e6ed54c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126155228.0e6ed54c@cakuba.netronome.com>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Nov 26, 2019 at 03:52:28PM -0800, Jakub Kicinski escreveu:
> On Tue, 26 Nov 2019 15:10:30 -0800, Stanislav Fomichev wrote:
> > We are using this script with python2.7, works just fine :-)
> > So maybe doing s/python3/python/ is the way to go, whatever
> > default python is installed, it should work with that.

> That increases the risk someone will make a python2-only change 
> and break Python 3.
 
> Python 2 is dead, I'm honestly surprised this needs to be said :)

It shouldn't have to be said, and probably it is old school to try and
keep things portable when there is no need to use new stuff for simple
tasks like this.

Anyway, it seems its just a matter of adding the python3 package to the
old container images and then most of them will work with what is in
that script, what doesn't work is really old and then NO_LIBBPF=1 is the
way to go.

In the end, kinda nothing to see here, go back to adding cool new stuff,
lets not hold eBPF from progressing ;-P

- Arnaldo

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B077E4BF
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732547AbfHAV3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:29:18 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45194 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728045AbfHAV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:29:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id m23so70741384lje.12;
        Thu, 01 Aug 2019 14:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFZ968ioLvhDlnML/1Tb2VL+GpgCBC3R+Dvj/MA/znw=;
        b=hlA1TxZ5WHq4cZ6YOWE7/7NMjOyRmkVslk9aZZP+RqyhrM9bsLxANzx5/TPPmxbe++
         sk16nbqk1A4yeBnDaMbhU4mCIL2wVbebx9V+yzNjuM1XZE5ifFMMNgh+2xweH0gN5zWx
         PNZ48SDEzKC366pFJ5jSfkcPo01sckIg7gTrAqIHeMQNH11/D5KnmTLprPLiKfgCdKwp
         3ZGreTRgTC7PaaICiFhZ6SrGOjF+BnBtxx+pRNSbIeFvMERU7YZAbZtTunWbTOURhcj3
         l9gxP8Iol7py6RzwePVLfRcifT359jfch84dFxi8Kaf1Zcd1xjtJnh+F3Qn5zNkI3eiJ
         6JrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFZ968ioLvhDlnML/1Tb2VL+GpgCBC3R+Dvj/MA/znw=;
        b=cOzFbs5IytVx3nWmj+XUYAjUdMt8gQdVlMXnQc0hrrA+iZ6nEL621jV0wJJb7GH9s6
         MyRBtzzOHJPlH4helyQILiHhlmAEtNqaSYROtu1kH+WuERbeNRpRCOXYb/nFtIXhCyM6
         AKiI3mPXD5tRLA0hQa/bWvSRaE7JcAXAYPd2mB3H/CQj4GLEI5ZsYejT+9ZBPeGrud/e
         k5ra8Fs32Igu4tD0G0ORURTrT8DOAvnQVVUufdXfu6o84BWkH67/9oHT4sE6ehJhhTnh
         ut4TW2pK2vfmSR9frQSKhSWI1C/azqvTMeG4v6ZsRiWV9ZTQnJL4BDBaeFaVNyevIZDD
         qIvw==
X-Gm-Message-State: APjAAAVpu22daJsJZyNSbEAecTe0WzqLfkHTK2exNk/UpYWCEa/MWBDK
        jFgCHV/d/aED7OfKbI60qWTHlA1zy+Cg/wgNE51BSw==
X-Google-Smtp-Source: APXvYqyYjOa3zPiFTeI7h8zeIhsh1LUFNDASe002/4lQ3kFyriTfD9BkgA9NtI6VVylsfxqok8gpaC1eURwKvnWIRI8=
X-Received: by 2002:a2e:9758:: with SMTP id f24mr69822624ljj.58.1564694955976;
 Thu, 01 Aug 2019 14:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190729215111.209219-1-sdf@google.com> <20190801205807.ruqvljfzcxpdrrfu@ast-mbp.dhcp.thefacebook.com>
 <20190801211135.GA4544@mini-arch>
In-Reply-To: <20190801211135.GA4544@mini-arch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Aug 2019 14:29:04 -0700
Message-ID: <CAADnVQJN7RLmaMfdhDoJ6x5wgR8Kt3PfyH4nj_6L85jORJF_pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] bpf: allocate extra memory for setsockopt
 hook buffer
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 2:11 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 08/01, Alexei Starovoitov wrote:
> > On Mon, Jul 29, 2019 at 02:51:09PM -0700, Stanislav Fomichev wrote:
> > > Current setsockopt hook is limited to the size of the buffer that
> > > user had supplied. Since we always allocate memory and copy the value
> > > into kernel space, allocate just a little bit more in case BPF
> > > program needs to override input data with a larger value.
> > >
> > > The canonical example is TCP_CONGESTION socket option where
> > > input buffer is a string and if user calls it with a short string,
> > > BPF program has no way of extending it.
> > >
> > > The tests are extended with TCP_CONGESTION use case.
> >
> > Applied, Thanks
> >
> > Please consider integrating test_sockopt* into test_progs.
> Sure, will take a look. I think I didn't do it initially
> because these tests create/move to cgroups and test_progs
> do simple tests with BPF_PROG_TEST_RUN.

I think it would be great to consolidate all tests under test_progs.
Since testing currently is all manual, myself and Daniel cannot realistically
run all of them for every patch.
When it's all part of test_progs it makes testing easier.
Especially test_progs can now run individual test or subtest.

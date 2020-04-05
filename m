Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D60119ED58
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgDESb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 14:31:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34137 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgDESb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 14:31:28 -0400
Received: by mail-qk1-f194.google.com with SMTP id i186so4989266qke.1;
        Sun, 05 Apr 2020 11:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdCOiULPYGtStxmnCkuLZmgFo9x/FqnSR/aOAQ2GpqY=;
        b=a/oiTCaP0JqkVYTPom12lG6TzWozpI0vJlIWag+UO6v0t6sQUvmrDxpxORevKwDUue
         lXmR8iaLNSHPmO6foLB+ZjB4hyevI81dyVbN7PYQ8uqEf9rhZrFfY0jDy5NFLjTkSZGz
         S9ISOBAAV6XJ+G80TqgsgXbYLHPX2t/UDU5+cPqMdILsGERgFQC37Rc7zXd9lHOEu8BW
         vSso/2iwS6uJ/ZgJBtty7cVCtBziAD4EkVWQW4OLK1DK3PQaBwxrONvaXh4U3z+2MTM6
         Cy12QYmIjonp+eEoMeg05391xGGkWVsLsg5MPhDE3XFks/k0n6B1ZeZHT58H6m0WJyLx
         cJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdCOiULPYGtStxmnCkuLZmgFo9x/FqnSR/aOAQ2GpqY=;
        b=os8XJtitpsqftVd9/UGukvLeD+fNuyssIzandq6QXlGvfxgvWT5YmPtUDwWYjgJCze
         hnsBfCNZJDfJNbw8v3u4SjQ2e4fcgFhJ/PeSmO/pj8kyykkN9cRd5QBVYnyWdwyvukAh
         3VsWtcfwxJJyG7XwfqIRnAReflCmCygRJNknt/XMvnlekzRxG2KTeIQcc8XXR1FkC/rq
         vj5g9oneakR/ye6NcQVDmTK5p7SJJU81agISu9aSL28o8GqUq5iIkIWZH3tmc/zcpmqj
         xiXX6LdPP2toIa2lEoBk1gGAdL/gynDldYAWq2cDDcsq2lFcQTN14CMlmschFF8An+OY
         /rag==
X-Gm-Message-State: AGi0Pua6kXfJnbF4s5AqIivugns5e42s5f3F/RPR1WnF26NSNr4P8SUB
        lugDQ8rqLw3x6qN18I+1cihIvRxZroKxp4oINQI=
X-Google-Smtp-Source: APiQypJlyFvwWzBHcBNhjoIuhWhZakt/U0cjOygj60OtUhHLEU48/lMr/qPnmWesPtPMCPIHmjE4WU2Sk8XtVbPvGQo=
X-Received: by 2002:a37:9c4d:: with SMTP id f74mr2633934qke.437.1586111486634;
 Sun, 05 Apr 2020 11:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <0849eba7-18c3-e5d5-f4d6-b76dcb882906@gmail.com>
In-Reply-To: <0849eba7-18c3-e5d5-f4d6-b76dcb882906@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 5 Apr 2020 11:31:15 -0700
Message-ID: <CAEf4Bzb4HJNzpyF=yRsS1CjiZK1qZ57QmiFUH2-hh46u+OFs7A@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/8] bpf_link observability APIs
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 5, 2020 at 9:26 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 4/3/20 6:09 PM, Andrii Nakryiko wrote:
> > This patch series adds various observability APIs to bpf_link:
> >   - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by which
> >     user-space can iterate over all existing bpf_links and create limited FD
> >     from ID;
> >   - allows to get extra object information with bpf_link general and
> >     type-specific information;
> >   - makes LINK_UPDATE operation allowed only for writable bpf_links and allows
> >     to pin bpf_link as read-only file;
> >   - implements `bpf link show` command which lists all active bpf_links in the
> >     system;
> >   - implements `bpf link pin` allowing to pin bpf_link by ID or from other
> >     pinned path.
> >
> > This RFC series is missing selftests and only limited amount of manual testing
> > was performed. But kernel implementation is hopefully in a good shape and
> > won't change much (unless some big issues are identified with the current
> > approach). It would be great to get feedback on approach and implementation,
> > before I invest more time in writing tests.
> >
>
> The word 'ownership' was used over and over in describing the benefits
> of bpf_link meaning a process owns a program at a specific attach point.
> How does this set allow me to discover the pid of the process
> controlling a specific bpf_link?

In general, it's many processes, not a single process. Here's how:

1. Each bpf_link has a unique ID.
2. You can find desired bpf_link info (including ID) either by already
having FD and querying it with GET_OBJ_INFO_BY_FD, or by doing
GET_NEXT_ID iteration and then GET_FD_BY_ID + GET_OBJ_INFO_BY_FD.
3. Iterate all open files (either by using tools like drgn or by
iterating over procfs), check their fdinfo to see if it's bpf_link's
with given ID. This gives you which application has FD open against
given bpf_link.

Similarly one can iterate over all pinned files in bpffs and see if it
pins bpf_link (I believe bpftool can do that already and show which
objects are pinned, so it should be a minimal change to actually print
out all the pinned file paths).

Does that answer your question?

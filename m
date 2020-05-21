Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6BC1DD6CD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgEUTMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbgEUTMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:12:19 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E84C061A0E;
        Thu, 21 May 2020 12:12:19 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id x12so6380313qts.9;
        Thu, 21 May 2020 12:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cR6/WgdxEb48OPUj9rt10xxN8lgY/TRAtYbhZXD6v3M=;
        b=uTTOWA1/DohmCDhX+BR04WgbUaubItV7uNx/ETKMk/U92y8QbyICM+g9sKinYfmDuN
         nbCwoQs/mcGEWCZrV5FCfn+rr85L3WHN01O9p/JZqQRgBcwe5y0sAOA/OR7Vj9Y2X4SE
         87TEA3lOWl/xF3h7VfiH+HE3tnbhW4GKgFXKisW27lphpwF7Pkr88k/vz+rw8+8/HVuL
         G/ipU9i6bbTsFBUFDkCmxHgFY/iWukJvylp9uHFWjqZkqzrc+ajpDmwLn0R5spuJzfE8
         zk5tPr7sUi8N8JpS59c0l7fnvfAu0pdrZCBNf996C0YP8ho77mbpWd3ixBSq4VwsgdhN
         HKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cR6/WgdxEb48OPUj9rt10xxN8lgY/TRAtYbhZXD6v3M=;
        b=tKaFYIgHxBzul4QpjuTQo7o484ndLgE8NH0O6q/twwxItqK80Sz9hl9l3t5DWTsaLM
         uJ3y+Yf6CEvoPVUx6S4ik6YAE1rHd/qV1fOjLCsex34Yr0UTAXgnChEcGKAoIsNx+WHi
         p1ZRaSEr4eiTvE1YbBN2QcxD6vYQPxj8XOsBfce6y67wVwIJu57+JgxK9PmEtZtn1TmE
         abuLcj/pE8/jX7tMndHFaKbFXAahQyxBkQj5fMVqjXEN5gkVNVfCOk2jEKacgjXXjkbv
         3HKZKzfHkBptnNBy4W/qCw9UlNaKdy8sHh5Y+PIAXsqzq5WYE0wgg7TOWxpsEwFbfM54
         lasg==
X-Gm-Message-State: AOAM530BczkkfMkay8ttnLwqSM0kJ7UyQBA8Og8qAeFCe7yRSznAnnvN
        ECs7BZAT7eQ+PZPjfQGWD8Sy1eerQ7LUKRSstHo=
X-Google-Smtp-Source: ABdhPJxCA9ASFNs1WgVNDKwgd5TKRdkqJrLsrFtQm0wXeykzRQ2EWOB7HDfDd0qpE95Tc96Hb97MFejWrwqhhEyAWbc=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr12002183qtd.117.1590088338755;
 Thu, 21 May 2020 12:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
 <159007175735.10695.9639519610473734809.stgit@john-Precision-5820-Tower>
 <CAEf4BzZpZ5_Mn66h9a+VE0UtrXUcYdNe-Fj0zEvfDbhUG7Z=sw@mail.gmail.com>
 <5ec6d090627d0_75322ab85d4a45bcf6@john-XPS-13-9370.notmuch> <5ec6d1cdbc900_7d832ae77617e5c0ce@john-XPS-13-9370.notmuch>
In-Reply-To: <5ec6d1cdbc900_7d832ae77617e5c0ce@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 12:12:07 -0700
Message-ID: <CAEf4BzY0Ft8djizeAn3sSZOLfy-ZiH5+AC=ikjk6Uno1U1JgSQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 4/5] bpf: selftests, add sk_msg helpers load
 and attach test
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 12:09 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> John Fastabend wrote:
> > Andrii Nakryiko wrote:
> > > On Thu, May 21, 2020 at 7:36 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > The test itself is not particularly useful but it encodes a common
> > > > pattern we have.
> > > >
> > > > Namely do a sk storage lookup then depending on data here decide if
> > > > we need to do more work or alternatively allow packet to PASS. Then
> > > > if we need to do more work consult task_struct for more information
> > > > about the running task. Finally based on this additional information
> > > > drop or pass the data. In this case the suspicious check is not so
> > > > realisitic but it encodes the general pattern and uses the helpers
> > > > so we test the workflow.
> > > >
> > > > This is a load test to ensure verifier correctly handles this case.
> > > >
> > > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > > ---
>
> [...]
>
> > > > +static void test_skmsg_helpers(enum bpf_map_type map_type)
> > > > +{
> > > > +       struct test_skmsg_load_helpers *skel;
> > > > +       int err, map, verdict;
> > > > +
> > > > +       skel = test_skmsg_load_helpers__open_and_load();
> > > > +       if (!skel) {
> > > > +               FAIL("skeleton open/load failed");
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
> > > > +       map = bpf_map__fd(skel->maps.sock_map);
> > > > +
> > > > +       err = xbpf_prog_attach(verdict, map, BPF_SK_MSG_VERDICT, 0);
> > > > +       if (err)
> > > > +               return;
> > > > +       xbpf_prog_detach2(verdict, map, BPF_SK_MSG_VERDICT);
> > >
> > > no cleanup in this test, at all
> >
> > Guess we need __destroy(skel) here.
> >
> > As an aside how come if the program closes and refcnt drops the entire
> > thing isn't destroyed. I didn't think there was any pinning happening
> > in the __open_and_load piece.
>
> I guess these are in progs_test so we can't leave these around for
> any following tests to trip over. OK. Same thing for patch 3 fwiw.

Yep, exactly. It's a cooperative environment at the moment. We've
talked about running tests in forked processes and in parallel, but
until then, cleaning up is very important.

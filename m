Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE68F26233C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbgIHWtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgIHWtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 18:49:51 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C1C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 15:49:51 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 16so769141qkf.4
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 15:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2HU8g9qnV1VDaV0c9lrq6EKArLaVEN3j7/XSwFN0QqM=;
        b=Z90ztMUO1TxEDOS9VSXxPep7MEvzQ/PUL1Gm19hoct4oUV5LuIm+DMe1gEeeWMknn4
         vG8AxfZ8PSDvxl3CDJywWkGtfBDYb3RxDgOhi+OhQfRKObpTO9Z7V/Lw6pjYQdgjEbKJ
         ByFOHgE6rAsm1E5Sx5iqan6ySYKvh39UM/cnfJmnmKQ/W8M9g0uB4BdREry8hmgaRfs2
         w9YtCtPe/YCyD8ZGQePI6zXSmaKMvaIcOXzAm94JQzuz/hPcwJWcYOxY9Rt127vuwhvK
         gVgXFiO97+fFsW5/d5uvvbR3ZQGH4lpE4VUrarKeAXqvUYbTDqUWCxxiq78jFMWAMHxk
         jl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2HU8g9qnV1VDaV0c9lrq6EKArLaVEN3j7/XSwFN0QqM=;
        b=cOMIWLr/ST22/tmZLkc0xDLaUseKsJ5BrxAMrno81KFogbNB4Yn8CPdV+pTKP0UGU9
         yiU074/ygv/h3CU5q+WjNnxBJ2gH9aJD19PLmHuTQqHqZQPRuDVovUHhtQaAXlRxjcrV
         dcoNpf3IGRwLa04lDcjVxVUpvc9ionivwxfe0MSe0JQv6R6QpwIRMA20+PyzAhpey3FB
         LIk0YJ+fdPDjTJPhiIvKCVgSjZp7A83TnaudWj0nMm4i/ByMA2uB0CgXAGnx0pbMkTBi
         Ut2St8G/vtKecWkj4hEQGCs9mMeRBavl8UnJL6SMirQFQJoIftEaAVS3xNQKPLqWpFnh
         YdeA==
X-Gm-Message-State: AOAM533wVq+t7el3/WuQH904UndjdgfqqbAMpAickv7u4MeJbxXsCLSF
        SLdUH8RPvIkzIaV2EqCj8tWOqPuP0/MwBUZbdZiqDA==
X-Google-Smtp-Source: ABdhPJwMZr5tfILQWxCkB86iuiDFlgJCHkE0UTPXQEawQTrBnbi+P36FkaZN87wIx5usm4wSKq3JjZkYSY4YExbhvhg=
X-Received: by 2002:a37:4a57:: with SMTP id x84mr776229qka.17.1599605389903;
 Tue, 08 Sep 2020 15:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-6-sdf@google.com>
 <CAEf4BzZcb+CKwL72mgC5B+2wAi8hfT_OoVUNZCcZjKgu4zRxiA@mail.gmail.com>
 <CAKH8qBvkRrRWGX8HjKuCCoE1x2BB7tXmyJv1HotEyp7D_D+mLg@mail.gmail.com> <CAEf4BzYi+DjDHZTWWOPyJaU13civjeFRO-bGOzvEPjsimk906A@mail.gmail.com>
In-Reply-To: <CAEf4BzYi+DjDHZTWWOPyJaU13civjeFRO-bGOzvEPjsimk906A@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 8 Sep 2020 15:49:38 -0700
Message-ID: <CAKH8qBvCQ0q+R0RPX-nhSwXqybKHFYZ0ovu08W6Z6tiFSkzsGA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 5/8] bpftool: support dumping metadata
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 3:35 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 1:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > On Wed, Sep 2, 2020 at 10:00 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > >
> > > > From: YiFei Zhu <zhuyifei@google.com>
> > > >
> > > > Added a flag "--metadata" to `bpftool prog list` to dump the metadata
> > > > contents. For some formatting some BTF code is put directly in the
> > > > metadata dumping. Sanity checks on the map and the kind of the btf_type
> > > > to make sure we are actually dumping what we are expecting.
> > > >
> > > > A helper jsonw_reset is added to json writer so we can reuse the same
> > > > json writer without having extraneous commas.
> > > >
> > > > Sample output:
> > > >
> > > >   $ bpftool prog --metadata
> > > >   6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
> > > >   [...]
> > > >         btf_id 4
> > > >         metadata:
> > > >                 metadata_a = "foo"
> > > >                 metadata_b = 1
> > > >
> > > >   $ bpftool prog --metadata --json --pretty
> > > >   [{
> > > >           "id": 6,
> > > >   [...]
> > > >           "btf_id": 4,
> > > >           "metadata": {
> > > >               "metadata_a": "foo",
> > > >               "metadata_b": 1
> > > >           }
> > > >       }
> > > >   ]
> > > >
> > > > Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> > > > Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> > > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > > ---
> > > >  tools/bpf/bpftool/json_writer.c |   6 ++
> > > >  tools/bpf/bpftool/json_writer.h |   3 +
> > > >  tools/bpf/bpftool/main.c        |  10 +++
> > > >  tools/bpf/bpftool/main.h        |   1 +
> > > >  tools/bpf/bpftool/prog.c        | 130 ++++++++++++++++++++++++++++++++
> > > >  5 files changed, 150 insertions(+)
> > > >
> > >
> > > [...]
> > >
> > > > +
> > > > +       if (bpf_map_lookup_elem(map_fd, &key, value)) {
> > > > +               p_err("metadata map lookup failed: %s", strerror(errno));
> > > > +               goto out_free;
> > > > +       }
> > > > +
> > > > +       err = btf__get_from_id(map_info.btf_id, &btf);
> > >
> > > what if the map has no btf_id associated (e.g., because of an old
> > > kernel?); why fail in this case?
> > Thank you for the review, coming back at it a bit late :-(
> >
> > This functionality is guarded by --metadata bpftool flag (off by default).
> > In case of no btf_id, it might be helpful to show why we don't have
> > the metadata rather than just quietly failing.
> > WDYT?
>
> we might do it similarly to PID info I added with bpf_iter: if it's
> supported -- emit it, if not -- skip and still succeed. So maybe we
> don't really need extra --metadata flag and should do all this always?
Sounds reasonable, especially if there is an existing precedent.
Let me explore that option.

> > > > +       if (err || !btf) {
> > > > +               p_err("metadata BTF get failed: %s", strerror(-err));
> > > > +               goto out_free;
> > > > +       }
> > > > +
> > > > +       t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
> > > > +       if (BTF_INFO_KIND(t_datasec->info) != BTF_KIND_DATASEC) {
> > >
> > > btf_is_datasec(t_datasec)
> > >
> > > > +               p_err("bad metadata BTF");
> > > > +               goto out_free;
> > > > +       }
> > > > +
> > > > +       vlen = BTF_INFO_VLEN(t_datasec->info);
> > >
> > > btf_vlen(t_datasec)
> > >
> > > > +       vsi = (struct btf_var_secinfo *)(t_datasec + 1);
> > >
> > > btf_var_secinfos(t_datasec)
> > >
> > > > +
> > > > +       /* We don't proceed to check the kinds of the elements of the DATASEC.
> > > > +        * The verifier enforce then to be BTF_KIND_VAR.
> > >
> > > typo: then -> them
> > >
> > > > +        */
> > > > +
> > > > +       if (json_output) {
> > > > +               struct btf_dumper d = {
> > > > +                       .btf = btf,
> > > > +                       .jw = json_wtr,
> > > > +                       .is_plain_text = false,
> > > > +               };
> > > > +
> > > > +               jsonw_name(json_wtr, "metadata");
> > > > +
> > > > +               jsonw_start_object(json_wtr);
> > > > +               for (i = 0; i < vlen; i++) {
> > >
> > > nit: doing ++vsi here
> > Agreed with all the above, except this one.
> > It feels like it's safer to do [i] in case somebody adds a 'continue'
> > clause later and we miss that '++vsi'.
> > Let me know if you feel strongly about it.
>
> I meant to add vsi++ inside the for clause, no way to miss it:
>
> for (i = 0; i < vlen, i++, vsi++) {
>   continue/break/whatever you want, except extra i++ or vsi++
> }
>
> it's the safest way, imo
Ack, I can do that, thanks!

> > > > +                       t_var = btf__type_by_id(btf, vsi[i].type);
> > >
> > > and vsi->type here and below would look a bit cleaner
> > >
> > > > +
> > > > +                       jsonw_name(json_wtr, btf__name_by_offset(btf, t_var->name_off));
> > > > +                       err = btf_dumper_type(&d, t_var->type, value + vsi[i].offset);
> > > > +                       if (err) {
> > > > +                               p_err("btf dump failed");
> > > > +                               break;
> > > > +                       }
> > > > +               }
> > > > +               jsonw_end_object(json_wtr);
> > >
> > > [...]

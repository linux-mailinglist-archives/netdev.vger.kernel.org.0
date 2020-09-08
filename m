Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451E6262179
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730423AbgIHUxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbgIHUxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:53:21 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FC4C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 13:53:20 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id y11so302760qtn.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 13:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g4YR8SuShX7QcPEBP8FeYlpCgaekc4/WOgYCkOBy+ik=;
        b=JgeSMlKt7NyZxFjwVlmXALXVwT/bOq1IHoGDZjzw6q7KfEx4GCypfDoFyxQnSwTTME
         dpcyyc9fXIKSWQSH6K7QLhI7+9WLpEPqBl9KlnvtqImshID4fGAbV+9hzpekPnin1jp8
         J1OF780F8DKoY0KGAxULPwGLBlDyj8y1ExIGbg427Ofxp67xLWaepicqtBQhtbT+4qtC
         V1sYulxWxe35ZSw7mCha3kC3Cdp9xaGAfthwhj799oWWP+EIJRQ2ypYsWyItEUKU+wy+
         SJ7SGuYYtf59htvBediUwxWyQeAmJJOevHXAZDCEnuzwdXl6KJdoXoG2KXlh+VkfhZfR
         Fwrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4YR8SuShX7QcPEBP8FeYlpCgaekc4/WOgYCkOBy+ik=;
        b=dghMe+SKOLbbQrHAQiB9Rb/f/un8kAJqXLcjMVPSuh++6Ci4HhSSCtf7B/CUdai9I6
         UElYMLHgq41tNXbP4SufxzSUiQeqUGSARcz+kQyPLAmTgQy6Td+i5Ft4MpM79jWbNgGc
         7xf2JoWxw77LuC184f2edUtdI+uWGDF80sCStwiBtFpOqne2qCDslHYT+BteJCcZ48Sp
         fO5Y+BYKd8KpGx00jwuH6NYUpW4iAHdnFZXr6DDXo73JEa8p2P2mirVfR0jlyMUIzxLC
         B3Em1jdbl2BPegST/4AHWPw+ipD3RbHiMkl9jR/9NxpWkQfFmB79wYMsVxS6r5wDsMEu
         ezkw==
X-Gm-Message-State: AOAM532IJ8XCCLksyJPcXcsk87eWIa+9rsFGRI+IFjIACXW0NgpoxFcU
        BaBvzbonUBd07nynRDe6oiRgaQ8sW1dhwc+5OMfN4A==
X-Google-Smtp-Source: ABdhPJztZUBgOyXfnZgLehiu4Dd8eZfPcUrHCOQ07ZJrNzRMPkbO5PKKLn6Kkt2Y1oDwvAdR2MAqsvJozlHdmdZRgwI=
X-Received: by 2002:ac8:4784:: with SMTP id k4mr308069qtq.266.1599598399248;
 Tue, 08 Sep 2020 13:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-6-sdf@google.com>
 <CAEf4BzZcb+CKwL72mgC5B+2wAi8hfT_OoVUNZCcZjKgu4zRxiA@mail.gmail.com>
In-Reply-To: <CAEf4BzZcb+CKwL72mgC5B+2wAi8hfT_OoVUNZCcZjKgu4zRxiA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 8 Sep 2020 13:53:08 -0700
Message-ID: <CAKH8qBvkRrRWGX8HjKuCCoE1x2BB7tXmyJv1HotEyp7D_D+mLg@mail.gmail.com>
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

On Wed, Sep 2, 2020 at 10:00 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > From: YiFei Zhu <zhuyifei@google.com>
> >
> > Added a flag "--metadata" to `bpftool prog list` to dump the metadata
> > contents. For some formatting some BTF code is put directly in the
> > metadata dumping. Sanity checks on the map and the kind of the btf_type
> > to make sure we are actually dumping what we are expecting.
> >
> > A helper jsonw_reset is added to json writer so we can reuse the same
> > json writer without having extraneous commas.
> >
> > Sample output:
> >
> >   $ bpftool prog --metadata
> >   6: cgroup_skb  name prog  tag bcf7977d3b93787c  gpl
> >   [...]
> >         btf_id 4
> >         metadata:
> >                 metadata_a = "foo"
> >                 metadata_b = 1
> >
> >   $ bpftool prog --metadata --json --pretty
> >   [{
> >           "id": 6,
> >   [...]
> >           "btf_id": 4,
> >           "metadata": {
> >               "metadata_a": "foo",
> >               "metadata_b": 1
> >           }
> >       }
> >   ]
> >
> > Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> > Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/bpf/bpftool/json_writer.c |   6 ++
> >  tools/bpf/bpftool/json_writer.h |   3 +
> >  tools/bpf/bpftool/main.c        |  10 +++
> >  tools/bpf/bpftool/main.h        |   1 +
> >  tools/bpf/bpftool/prog.c        | 130 ++++++++++++++++++++++++++++++++
> >  5 files changed, 150 insertions(+)
> >
>
> [...]
>
> > +
> > +       if (bpf_map_lookup_elem(map_fd, &key, value)) {
> > +               p_err("metadata map lookup failed: %s", strerror(errno));
> > +               goto out_free;
> > +       }
> > +
> > +       err = btf__get_from_id(map_info.btf_id, &btf);
>
> what if the map has no btf_id associated (e.g., because of an old
> kernel?); why fail in this case?
Thank you for the review, coming back at it a bit late :-(

This functionality is guarded by --metadata bpftool flag (off by default).
In case of no btf_id, it might be helpful to show why we don't have
the metadata rather than just quietly failing.
WDYT?

> > +       if (err || !btf) {
> > +               p_err("metadata BTF get failed: %s", strerror(-err));
> > +               goto out_free;
> > +       }
> > +
> > +       t_datasec = btf__type_by_id(btf, map_info.btf_value_type_id);
> > +       if (BTF_INFO_KIND(t_datasec->info) != BTF_KIND_DATASEC) {
>
> btf_is_datasec(t_datasec)
>
> > +               p_err("bad metadata BTF");
> > +               goto out_free;
> > +       }
> > +
> > +       vlen = BTF_INFO_VLEN(t_datasec->info);
>
> btf_vlen(t_datasec)
>
> > +       vsi = (struct btf_var_secinfo *)(t_datasec + 1);
>
> btf_var_secinfos(t_datasec)
>
> > +
> > +       /* We don't proceed to check the kinds of the elements of the DATASEC.
> > +        * The verifier enforce then to be BTF_KIND_VAR.
>
> typo: then -> them
>
> > +        */
> > +
> > +       if (json_output) {
> > +               struct btf_dumper d = {
> > +                       .btf = btf,
> > +                       .jw = json_wtr,
> > +                       .is_plain_text = false,
> > +               };
> > +
> > +               jsonw_name(json_wtr, "metadata");
> > +
> > +               jsonw_start_object(json_wtr);
> > +               for (i = 0; i < vlen; i++) {
>
> nit: doing ++vsi here
Agreed with all the above, except this one.
It feels like it's safer to do [i] in case somebody adds a 'continue'
clause later and we miss that '++vsi'.
Let me know if you feel strongly about it.

> > +                       t_var = btf__type_by_id(btf, vsi[i].type);
>
> and vsi->type here and below would look a bit cleaner
>
> > +
> > +                       jsonw_name(json_wtr, btf__name_by_offset(btf, t_var->name_off));
> > +                       err = btf_dumper_type(&d, t_var->type, value + vsi[i].offset);
> > +                       if (err) {
> > +                               p_err("btf dump failed");
> > +                               break;
> > +                       }
> > +               }
> > +               jsonw_end_object(json_wtr);
>
> [...]

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E42662BD
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgIKP74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgIKP4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 11:56:31 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA7C061756
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:56:31 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z2so8182891qtv.12
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HB1wLkJBUPBITqr249AFzq+PR4Y7nrQ2PRnzX2SICNU=;
        b=q6mTZynvnuOIdXFxtOD49r+38vJ9B5saRc3IwrULNNlQw4i2QImBldf6kJg536NWqQ
         GuKZ/xQg/z2eqdHj+zDrvIhQNnmNLfLw8ECIGw+EwdIEgxnu0xezOYq9N/7fndQWfmag
         6k+kkjfPeDFhTJC/hptFfjQQV38r2owSheIlqMRlvKQ+bcAIVgYNuNe9Bvzi1nbxTduG
         /u4KOemjjBSZk5dPMYz7NCp2aWO/jA58SA8yHuUSzGtFHCHJ0/7X5MYTKzb3Ks50byML
         85feoiOX3GWXU03Gi6PcPD2H0JbSQvT5ljbgA+baUamBozteFMGwONWP3fwYRozpHxCy
         Ojpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HB1wLkJBUPBITqr249AFzq+PR4Y7nrQ2PRnzX2SICNU=;
        b=L6uvyQYuomvoVbHPA1aV3okW8d/uYZr4Xb8UpMYV0wt26XMdnIFL4bHM8jI2dRXKTM
         l6X5Xwe1xlymoQlVnLWVh5L9444duIcbzLjc2R4pK7Y5GcEEjfpL0tfsprtveOLtKaDH
         Zajrlv0KJZKJ3c4tjDLJ5lYmGPuMy9OYITEmeQAa7txjVDDqJJYi3lHbPg++Bnp+OEf8
         XOeo0TkcFkqlBkhCsCtGDuDXjFKmZPfZp6g96SnnS+3oEurDlJ0sQiaetG4Rv56NAARn
         +FFi+p5tXnYPaxEihVooM+/HwoCWIboK5sqjj0nTNsxDxQVGiTLXGkdGJpnSWZlhCCbw
         8j9w==
X-Gm-Message-State: AOAM530oux0X8/lMrAg31q4R4F3RStsTHMTUU9Ma7wU0XLFeX6T6deAB
        BthJ+azXq3zsPm9Kk+yk0RrxE48yayF61CAjRrp31Q==
X-Google-Smtp-Source: ABdhPJwX6e9cju+FL0v94+Z0/0T0ORtkFdzm5HvbrtkrybQyiKcZ93D1C9S02/CEAgsWDiMYufPy6anpHcb8ShTao1Q=
X-Received: by 2002:ac8:4784:: with SMTP id k4mr2595978qtq.266.1599839790431;
 Fri, 11 Sep 2020 08:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-5-sdf@google.com>
 <CAEf4BzaWxnm_X=nZWn0tcq7bMnbL8ZFDuU=qzMNDh_aSAayXsA@mail.gmail.com>
In-Reply-To: <CAEf4BzaWxnm_X=nZWn0tcq7bMnbL8ZFDuU=qzMNDh_aSAayXsA@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 11 Sep 2020 08:56:19 -0700
Message-ID: <CAKH8qBtiMh1evaQ-CQ83nESSS2UQLCM7avydoXvqY6aM+GHwDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/5] bpftool: support dumping metadata
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:54 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index f7923414a052..ca264dc22434 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -29,6 +29,9 @@
> >  #include "main.h"
> >  #include "xlated_dumper.h"
> >
> > +#define BPF_METADATA_PREFIX "bpf_metadata_"
> > +#define BPF_METADATA_PREFIX_LEN strlen(BPF_METADATA_PREFIX)
>
> this is a runtime check, why not (sizeof(BPF_METADATA_PREFIX) - 1) instead?
Make sense, will fix.

> > +static int bpf_prog_find_metadata(int prog_fd, int *map_id)
> > ...
> > +free_map_ids:
> > +       saved_errno = errno;
> > +       free(map_ids);
> > +       errno = saved_errno;
>
> not clear why all this fussing with saving/restoring errno and then
> just returning 0 or -1? Just return -ENOMEM or -ENOENT as a result of
> this function?
Yeah, I just moved this function from it's original (libbpf) location as is.
I guess it makes sense to simplify the error handling now that
it's not in exported from libbpf.

> > +       if (bpf_map_lookup_elem(map_fd, &key, value))
> > +               goto out_free;
> > +
> > +       err = btf__get_from_id(map_info.btf_id, &btf);
> > +       if (err || !btf)
> > +               goto out_free;
>
> if you make bpf_prog_find_metadata() to do this value lookup and pass
> &info, it would probably make bpf_prog_find_metadata a bit more
> usable? You'll just need to ensure that callers free allocated memory.
> Then show_prog_metadata() would take care of processing BTF info.
Sounds reasonable. I can maybe keep existing
bpf_prog_find_metadata (rename to bpf_prog_find_metadata_map_id?)
and add another wrapper that does that map lookup.

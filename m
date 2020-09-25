Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18727807A
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 08:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgIYGV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 02:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbgIYGV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 02:21:56 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD54C0613CE;
        Thu, 24 Sep 2020 23:21:56 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h9so1246457ybm.4;
        Thu, 24 Sep 2020 23:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVcIy3Aein3p9xvLXON8eMXLgMPbOqWFH9Nc9Ym9foM=;
        b=fbMCAHgkiB+S80lN/y7O8hMulRKLiTStxOrUKioVkzDHSVcrWmc2cO9JYCceP+VNFg
         npQUeyhZRzhQN+hR590zN/Gu+90qSI+VMaL6BZW1w/0Rn9QLzUT0Gv/kguDIn8S6RCAa
         pEgSjEDm/mYLK66Vfl5tCPtG+lY/U5D9gXldAUh4ijVR4qqC5nhMPlG5/YIOT05GhsyN
         Zjf/JTWwJAejQI8p+V/Pn+ylIAHp5CKrorxP8KDITNC2rQhta8hiwIg8axeEWlYdFPdY
         xdNsPVDXLytlDzKIvU9Od8xNQFB+3Jc8UGBcKCqAqp1k7IvuoetVMpujpeqllch+s1g+
         vJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVcIy3Aein3p9xvLXON8eMXLgMPbOqWFH9Nc9Ym9foM=;
        b=t2yJ6HzLQmhDXcYKgiq9NZKLZBImRleMvu9bJFUl5LFCyJlNRKoO7KfN5Wa2QEh7jW
         48s/nkib+x+byskPkyDMVHu/Aq7MHXXIbTQKfI5/Nkg6L63hRRMQBezrcu5WdhxMfHWj
         qNyk8eoYq5q5Vn16axmr+IA+36LHPRbLDZim8fBIcdJU34amL1Ke/PY1bW1dBhATVErN
         MwYKuCgeqGTnh0W+9fQVgo10wU4Ekhys31WNMUfj+lj47BbfHl0w2Y1Vy4TUeEZY3Tgz
         AvKTyaiP6WsuvvFW7bOtl4RdxCsVK0pOlFCjlI4dAAR31VRumidJ/0a8NMRCCv1uItuL
         z5XQ==
X-Gm-Message-State: AOAM530ZWmkMwp/XXVhuGkLutOONhuFjVqrONjzND1PWmarblzWPbQul
        4aU4c8LgSqj4v6jVPTr+qLT+YlZQRy9jqVuEFAM=
X-Google-Smtp-Source: ABdhPJxR73UsqY1KIJmlv9lrCn1/MD7qsgQ6rniErPqO/dDnnKON4PKmj+x7Ykqo3wsNmi/iM4zQCCkfUY5TNROfbs0=
X-Received: by 2002:a25:2687:: with SMTP id m129mr3254862ybm.425.1601014915390;
 Thu, 24 Sep 2020 23:21:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200923155436.2117661-1-andriin@fb.com> <20200923155436.2117661-8-andriin@fb.com>
 <20200925035541.2hjmie5po4lypbgk@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200925035541.2hjmie5po4lypbgk@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 23:21:44 -0700
Message-ID: <CAEf4BzYFswwhJOq4bSDZU5-bqUo+LwwUQ_NRH_zkBgGcBVYOjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 8:55 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 08:54:34AM -0700, Andrii Nakryiko wrote:
> > Add APIs for appending new BTF types at the end of BTF object.
> >
> > Each BTF kind has either one API of the form btf__append_<kind>(). For types
> > that have variable amount of additional items (struct/union, enum, func_proto,
> > datasec), additional API is provided to emit each such item. E.g., for
> > emitting a struct, one would use the following sequence of API calls:
> >
> > btf__append_struct(...);
> > btf__append_field(...);
> > ...
> > btf__append_field(...);
>
> I've just started looking through the diffs. The first thing that struck me
> is the name :) Why 'append' instead of 'add' ? The latter is shorter.

Append is very precise about those types being added at the end. Add
is more ambiguous in that sense and doesn't imply any specific order.
E.g., for btf__add_str() that's suitable, because the order in which
strings are inserted might be different (e.g., if the string is
duplicated). But it's not an "insert" either, so I'm fine with
renaming to "add", if you prefer it.

>
> Also how would you add anon struct that is within another struct ?
> The anon one would have to be added first and then added as a field?
> Feels a bit odd that struct/union building doesn't have 'finish' method,
> but I guess it can work.

That embedded anon struct will be a separate type, then the field
(anonymous or not, that's orthogonal to anonymity of a struct (!))
will refer to that anon struct type by its ID. Anon struct can be
added right before, right after, or in between completely unrelated
types, it doesn't matter to BTF itself as long as all the type IDs
match in the end.

As for the finish method... There wasn't a need so far to have it, as
BTF constantly maintains correct vlen for the "current"
struct/union/func_proto/datasec/enum (anything with extra members).
I've been writing a few more tests than what I posted here (they will
come in the second wave of patches) and converted pahole to this new
API completely. And it does feel pretty nice and natural so far. In
the future we might add something like that, I suppose, that would
allow to do some more validations at the end. But that would be a
non-breaking extension, so I don't want to do it right now.

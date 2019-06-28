Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2395A2B7
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfF1RtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:49:19 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35176 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF1RtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:49:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so6842990ljh.2;
        Fri, 28 Jun 2019 10:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJsIhY4wNQryIfT9KbxiILwrE7QAS+RQBKJnSZt1T4o=;
        b=Crebc91lCSxk7TMCY8Q1U9io2/WLQpztGqZaL+13FtcWeRi8UJXcokTcvTshRXhiAy
         ooXSPgCtrMzKcPJn8uvnBZ/S5mcan1t2Yp26dct8RVz4gDtlYd2umQbOrnnISeAY73Nu
         Yxm0bUk7a1I3jh+MICpnPG5hUhr5bkrhGgENXucWLrn6NHZdrU2go6D7juVZ2Onm2AdT
         Q/0m9W1o+8sEZSPPA6RjCWsVI4lB7xKMtzDt8mD0m+k0whGSPj5nCZF+JfL/h9qLVmvG
         Voi6r8rKzQfVmq4IDwJOEzAJ0ILefENsWuhawHj8Y0xZMcPV8wOMLiYMEjHMqZwj69IW
         bh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WJsIhY4wNQryIfT9KbxiILwrE7QAS+RQBKJnSZt1T4o=;
        b=U9Z5ToDjhEpMxLczmXzyo61zWM0Q5PCidhCAzB4CZrsAOo85/dl587khjzME+bCuUj
         7qa7llJkdDPBoX2c9rcJt8SssOxVe7gILRjW7Bk3IdEACeMtOvqsI0M/oViimfxVwBYd
         PdxRygJN/+BrNSUwQmuK9V3FAizjxbU6BuJFI04Nv/CB6WRZ1TrUxhhxiFGpJ0ZqxWCr
         OH0uYiQjJGsSNyVvaDonh9kSEdp5P3aGYIGZd3BHK18tAklPvT4IOqHyb+sIu/nIQfnr
         6XwyAsoNrS25eLJNBQXswyh1apNhw6QP7bSog3aSKKwgxFmPpa2ekP60iSQdjzmQLxfJ
         7AxA==
X-Gm-Message-State: APjAAAXpgN3dGe0Ty3dosvAmJuQq8CAMC6b7Q+adb1yI0LLWaJpaH2A1
        8gOBdl29NlkIZ1Ry1MeeZPyStRb3k1s2PTm9oGI=
X-Google-Smtp-Source: APXvYqw6pdfVVcV7F1MTFAKS4tN+8AmYdV0o5Pj1yHuZwF6xpDcLMBPIT5lVWVOeoG97nEquRE9MQNhAx1M38ZD5Ca0=
X-Received: by 2002:a2e:6c07:: with SMTP id h7mr6983719ljc.177.1561744156739;
 Fri, 28 Jun 2019 10:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190627202417.33370-1-brianvv@google.com> <20190627202417.33370-3-brianvv@google.com>
 <20190627221253.fjsa2lzog2zs5nyz@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190627221253.fjsa2lzog2zs5nyz@ast-mbp.dhcp.thefacebook.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 10:49:05 -0700
Message-ID: <CABCgpaWZKac+yAoohUbR0otv4EjBdj9ogA-oZJ2=mHkmqb8AVQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next v2 2/6] bpf: add BPF_MAP_DUMP command to
 access more than one entry per call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please explain the api behavior and corner cases in the commit log
> or in code comments.

Ack, will prepare a new version adding those.

> Would it make sense to return last key back into prev_key,
> so that next map_dump command doesn't need to copy it from the
> buffer?

Actually that's a good idea.


> checkpatch.pl please.

 I did use the script and it didn't complain, are you seeing something?

> > +next:
> > +             if (signal_pending(current)) {
> > +                     err = -EINTR;
> > +                     break;
> > +             }
> > +
> > +             rcu_read_lock();
> > +             err = map->ops->map_get_next_key(map, prev_key, key);
> > +             rcu_read_unlock();
> > +
> > +             if (err)
> > +                     break;
>
> should probably be only for ENOENT case?

Yes, this makes sense.

> and other errors should be returned to user ?

and what if the error happened when we had already copied some
entries? Current behavior masks the error to 0 if we copied at least 1
element

>
> > +
> > +             if (bpf_map_copy_value(map, key, value, attr->dump.flags))
> > +                     goto next;
>
> only for ENOENT as well?
> and instead of goto use continue and move cp_len+= to the end after prev_key=key?

Right

>
> > +
> > +             if (copy_to_user(ubuf + cp_len, buf, elem_size))
> > +                     break;
>
> return error to user?
>
> > +
> > +             prev_key = key;
> > +     }
> > +
> > +     if (cp_len)
> > +             err = 0;
>
> this will mask any above errors if there was at least one element copied.

So in general if we copied elements and suddenly we find and error we
should return that error and maybe set cp_len to 0 to 'invalidate' the
data that was already copied?
Yes, I think that sounds like the correct thing to do, what do you think?

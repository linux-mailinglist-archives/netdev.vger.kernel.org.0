Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1AC97CC60
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 20:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfGaS6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 14:58:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42762 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbfGaS6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 14:58:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id s19so48213216lfb.9;
        Wed, 31 Jul 2019 11:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dfwzkRB1EXz9VJ9dIrQ8xrDksaj8jIaBGeToAqjBxZk=;
        b=pzLaZSqD+v/3JZCkSsk26AW9Eo6y04oP3JAgPhEImxaH9ddeYCWVvB8eE6kmMjRI4d
         rt4DHIZa2LTcO2qPndNHSZAro2OhrMCdzmtPEK31DeOSt5fIwBfaagONkrDkPNzNWm0X
         FAtWHZ7xW728jw5/yPivXHvK5zD0DGH8EcceObQX16TopnjWoONXiYxTYxwYLy5d6ksa
         hJ2RX8Xp/YkcGwbbesTaUJd4lP/xgmxynw9hxATOBhfhZDkYWNnjsnX1pcx1kbl+lR0J
         xI+0wdN0jW31N0gb918hny0FGKON0xDN90qzGd49fef5J2qL/OdsiyB1Wp9+Ivy3NLQ8
         eYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dfwzkRB1EXz9VJ9dIrQ8xrDksaj8jIaBGeToAqjBxZk=;
        b=rB+OfkQXxo3EQtJKPKbtvhCt/QiuoYY6q9q2/InI5+24ptVVv3oQknuOoapHGRFBmX
         mJySKLvcStxY2EKHoieL42dhLsbcjSIvUJHi5EyNWcS4heMohzGdNND+OjuXGDK+Ew4z
         X57QnLbvTBjSDel2msX+trogPFoNBQK7I7wuw5JwxKIfRWCpkfnXBccP529OGwlqK6Xw
         Xbv6RDOZgMqUnsF7IUfz8EQUgOgM3ccF5z8R8xERe8rgt8M6KXnnWBJHDP2XgOjYXqPW
         2Nqftpi7KrUKTXHXB3qSyXLLVnz8pJ1r5Q/CDqt2ieAmYmK6m0yD1xSKNFRzkBSTYfuL
         j+iA==
X-Gm-Message-State: APjAAAXX3cfxGQYmm2fhOeAFfY1PzfLvgCnxExYPA/PobJ6yr5Urnfmf
        XrBe3p2uiFPNB/KrciZ+xGk8flr6VtH4/ELucNI=
X-Google-Smtp-Source: APXvYqyFQ94uSoTGnAuzPo6MIkxbHzT0H4KE5R2Xg4xbuewViQmMLg86l+y4c8ByxzzHkTp9v1x+8LRm7BJJaEoAHVg=
X-Received: by 2002:ac2:4351:: with SMTP id o17mr38095219lfl.100.1564599510043;
 Wed, 31 Jul 2019 11:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190721213116.23476-1-mic@digikod.net> <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com> <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
In-Reply-To: <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 31 Jul 2019 11:58:18 -0700
Message-ID: <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type: inode
To:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>
Cc:     =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 11:46 AM Micka=C3=ABl Sala=C3=BCn
<mickael.salaun@ssi.gouv.fr> wrote:
> >> +    for (i =3D 0; i < htab->n_buckets; i++) {
> >> +            head =3D select_bucket(htab, i);
> >> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >> +                    landlock_inode_remove_map(*((struct inode **)l->k=
ey), map);
> >> +            }
> >> +    }
> >> +    htab_map_free(map);
> >> +}
> >
> > user space can delete the map.
> > that will trigger inode_htab_map_free() which will call
> > landlock_inode_remove_map().
> > which will simply itereate the list and delete from the list.
>
> landlock_inode_remove_map() removes the reference to the map (being
> freed) from the inode (with an RCU lock).

I'm going to ignore everything else for now and focus only on this bit,
since it's fundamental issue to address before this discussion can
go any further.
rcu_lock is not a spin_lock. I'm pretty sure you know this.
But you're arguing that it's somehow protecting from the race
I mentioned above?

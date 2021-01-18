Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8492FA69C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405504AbhARPQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393351AbhARPPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:15:47 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CEDC0613C1;
        Mon, 18 Jan 2021 07:15:06 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q2so31723274iow.13;
        Mon, 18 Jan 2021 07:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vy0h901KXJHx7zR+QSkwJyxuEtD9TesxvJvHthBNc6c=;
        b=YeFB265CZOz6TnZub+7S8nMHNsDakM64UfeFP22hmRKcLOcCZKCPiDU3kSHFdab2Vv
         ZuXC7AAvOi1w0JwFI1t/G5FpK+ckS+CKXoRNCrgpShPCYCakBg41d924KYQDY9GIIlTr
         XR51YBEJkzijzd4dSDnGjvEjj1w4jLazjhWRW3MDyi7gUPtgkJfQL3Q17AGXumK6pJGd
         TzMnv+cIn00RAM2+cpSVC+X/PJwUBgeqziSScwyUeULHBfc5n0uAf5ic9A4gFcJIFn/7
         HaRYIRDKpt6whH+RkqaK/O9efLB/uuJ/J8i2cCGUoF/I333jdqj/45C+5n8tqQssINVV
         pZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vy0h901KXJHx7zR+QSkwJyxuEtD9TesxvJvHthBNc6c=;
        b=Oe+FUVCmoEoWrI3/AdDOp54U9QMsHOHKIAwV2qelm3IstisPDlJF+wvxPjav4GQfkN
         6Bn0rTw4OUGj8AcUAhA3h4Tbyxnjeo6PqnM5oYiq3oIiqET5K/LyUiufasc3S0Gxp3SZ
         1rHS+P+5sBMCeeYZRNYQi1pQGbRokZJ0swnzNMJgUh96SNKqMuJQe/jJ6Ft44TVK6nFv
         dVcIBYtpLxD/GW9y5Q4QxpCpZ6uMSnUrMLIYU6kQS5QpjK4/J4THscjgSHj5hjOFBjG3
         h+7I/fDvQNuuf4iU7aHnF71NO7Rjem4Gz6r7zgkUB4lugneNqIaHpsPIO7F9pEWmfqSO
         QWAQ==
X-Gm-Message-State: AOAM531ih+x3ZTm1DHAT3LhDrnKo0VMO48TeOq0mIOz+iEb39gEyFAEF
        mSXylGaRPTm21Jjw//94PR4z82Nff5pvGA==
X-Google-Smtp-Source: ABdhPJzoxfcxpWgv+hquOXmJoRuWuIiW8VO2poB3RK52qpCQo1uTNJB+rmAzYEG21ORB8W7yGX26qA==
X-Received: by 2002:a05:6e02:13ac:: with SMTP id h12mr21732890ilo.159.1610982906105;
        Mon, 18 Jan 2021 07:15:06 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id h14sm270557ilh.63.2021.01.18.07.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 07:15:05 -0800 (PST)
Date:   Mon, 18 Jan 2021 07:14:56 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Message-ID: <6005a5f08de7a_23982089d@john-XPS-13-9370.notmuch>
In-Reply-To: <871reir06y.fsf@toke.dk>
References: <20201221123505.1962185-1-liuhangbin@gmail.com>
 <20210114142321.2594697-1-liuhangbin@gmail.com>
 <20210114142321.2594697-4-liuhangbin@gmail.com>
 <6004d200d0d10_266420825@john-XPS-13-9370.notmuch>
 <20210118084455.GE1421720@Leo-laptop-t470s>
 <871reir06y.fsf@toke.dk>
Subject: Re: [PATCHv14 bpf-next 3/6] xdp: add a new helper for dev map
 multicast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> =

> > Hi John,
> >
> > Thanks for the reviewing.
> >
> > On Sun, Jan 17, 2021 at 04:10:40PM -0800, John Fastabend wrote:
> >> > + * 		The forwarding *map* could be either BPF_MAP_TYPE_DEVMAP or
> >> > + * 		BPF_MAP_TYPE_DEVMAP_HASH. But the *ex_map* must be
> >> > + * 		BPF_MAP_TYPE_DEVMAP_HASH to get better performance.
> >> =

> >> Would be good to add a note ex_map _must_ be keyed by ifindex for th=
e
> >> helper to work. Its the obvious way to key a hashmap, but not requir=
ed
> >> iirc.
> >
> > OK, I will.

[...]

> >> WRITE_ONCE(ri->ex_map)?
> >> =

> >> >  	WRITE_ONCE(ri->map, NULL);
> >> =

> >> So we needed write_once, read_once pairs for ri->map do we also need=
 them in
> >> the ex_map case?
> >
> > Toke said this is no need for this read/write_once as there is alread=
y one.
> >
> > https://lore.kernel.org/bpf/87r1wd2bqu.fsf@toke.dk/
> =

> And then I corrected that after I figured out the real reason :)
> =

> https://lore.kernel.org/bpf/878si2h3sb.fsf@toke.dk/ - Quote:
> =

> > The READ_ONCE() is not needed because the ex_map field is only ever r=
ead
> > from or written to by the CPU owning the per-cpu pointer. Whereas the=

> > 'map' field is manipulated by remote CPUs in bpf_clear_redirect_map()=
.
> > So you need neither READ_ONCE() nor WRITE_ONCE() on ex_map, just like=

> > there are none on tgt_index and tgt_value.
> =

> -Toke
> =


Hi Hangbin, please add a comment above that code block to remind us
why the READ_ONCE/WRITE_ONCE is not needed or add it in the commit
message so we don't lose it. It seems we've hashed it over already,
but I forgot after the holidays/break so presumably I'll forget next
time I read this code as well and commit-msg or comment will help.

Thanks,
John=

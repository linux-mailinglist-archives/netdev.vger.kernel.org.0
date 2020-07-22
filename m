Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890CD228D17
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 02:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGVA3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 20:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgGVA3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 20:29:23 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CC1C061794;
        Tue, 21 Jul 2020 17:29:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id md7so250439pjb.1;
        Tue, 21 Jul 2020 17:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1rIz/p8xbgeatvF2KGOXuP/aBnNA3fNyon9ax4MTbhM=;
        b=bycVnyQBdG2Rl7Xy7kuqt/8JEDsaFSnmsdR7LeouowCSiDHmAVotuWFRTU6Z9aa/d6
         DZsJYsI85iq93NLeHXzs/SR7X2R9W9Ecisss0YiIysynKU3RN3zNdEYSXDW5MkerB4Wj
         l+6ZahtUp/zDu/xPZXA2y3SDPt3xFgR3pjHlPWksq9Ji4tA51ciP3QUtnT1QOJRi6Wj2
         vwUyUPBRE5z+CU+CynzcevMtO8llB+4pbFiAS4zppqEOrJ7Pd6lm4rz2ac8XQ9F1rLjI
         MxZfQqAGWXT//1te21WYP1UylzVYP8islEdTOCv0osZ5tyBhu5AMT3hhBxcQ75JvOhk2
         4Cxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1rIz/p8xbgeatvF2KGOXuP/aBnNA3fNyon9ax4MTbhM=;
        b=SvUrgAbRrjLnwx8PFd1pbx5PuqCymw7Ej/5sPJkUAmZfW3LtqOY1TliTwauXjopNIL
         KevF2s52lO+d9kiSxzYpsiGFPdhT12xRrIDeGWBzto5XkHV/Bl/2KLV0fX0zmVsw6Was
         9hTzbzAucy7PnyF45haSI2d8SA9RGlrBSumwHyMQBJJGlSnN3hZmWWbk5qfFSo+O7Als
         a0QW8fQJVGv64FkK01ceccj+XmoS1Z6xyOOMo/mayWTqfe8gpYdiy8M+3grZjU6cfDTc
         3zp5rCFfOBA4d2JNWbpjmiR19PY+HjFx6PWTWL7LqlrVxMCXDRq+RN3E/vAWHm2GGXCe
         KuYA==
X-Gm-Message-State: AOAM532jVBYhg5wioAZKzm2nsHn9o5MofgV71EaaAgDgSgRBBN3Ioq0q
        yiQci7tdoyPHwiuE9sndlar8+Y4w
X-Google-Smtp-Source: ABdhPJwTavAejdrR4zFNBRi8M5TUb6ckBtYtYtNX86cCuMNhGVryjXaumzRM9H6OJ9/rsiHTobZnRQ==
X-Received: by 2002:a17:90a:f2c3:: with SMTP id gt3mr7705892pjb.92.1595377762813;
        Tue, 21 Jul 2020 17:29:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e3b])
        by smtp.gmail.com with ESMTPSA id 19sm21901584pfy.193.2020.07.21.17.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 17:29:21 -0700 (PDT)
Date:   Tue, 21 Jul 2020 17:29:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200722002918.574pruibvlxfblyq@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
 <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
 <87mu3zentu.fsf@toke.dk>
 <20200717020507.jpxxe4dbc2watsfh@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYd4Xrn4EqzqHCTuJ8TnZiTC1vWWvd=9Np+LNrgbtxOcQ@mail.gmail.com>
 <20200720233455.6ito7n2eqojlfnvk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYtD9dGUy3hZRRAA56CaVvW7xTR9tp0dXKyVQXym046eQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 08:48:04PM -0700, Andrii Nakryiko wrote:
> 
> Right, I wanted to avoid taking a refcnt on aux->linked_prog during
> PROG_LOAD. The reason for that was (and still is) that I don't get who
> and when has to bpf_prog_put() original aux->linked_prog to allow the
> prog X to be freed. I.e., after you re-attach to prog Y, how prog X is
> released (assuming no active bpf_link is keeping it from being freed)?
> That's my biggest confusion right now.
> 
> I also didn't like the idea of half-creating bpf_tracing_link on
> PROG_LOAD and then turning it into a real link with bpf_link_settle on
> attach. That sounded like a hack to me.

The link is kinda already created during prog_load of EXT type.
Typically prog_load needs expected_attach_type that points to something
that is not going to disappear. In case of EXT progs the situation is different,
since the target can be unloaded. So the prog load cmd not only validates the
program extension but links target and ext prog together at the same time.
The target prog will be held until EXT prog is unloaded.
I think it's important to preserve this semantics to the users that the target prog
is frozen at load time and no races are going to happen later.
Otherwise it leads to double validation at attach time and races.

What raw_tp_open is doing right now is a hack. It allocates bpf_tracing_link,
registers it into link_idr and activates trampoline, but in reality that link is already there.
I think we can clean it up by creating bpf_tracing_link at prog load time.
Whether to register it at that time into link_idr is up to discussion.
(I think probably not).
Then raw_tp_open will activate that allocated bpf_tracing_link via trampoline,
_remove_ it from aux->linked_tracing_link (old linked_prog) and
return FD to the user.
So this partially created link at load_time will become complete link and
close of the link will detach EXT from the target and the target can be unloaded.
(Currently the target cannot be unloaded until EXT is loaded which is not great).
The EXT_prog->aux->linked_tracing_link (old linked_prog) will exist only during
the time between prog_load and raw_tp_open without args.
I think that would be a good clean up.
Then multi attach of EXT progs is clean too.
New raw_tp_open with tgt_prog_fd/tgt_btf_id will validate EXT against the new target,
link them via new bpf_tracing_link, activate it via trampoline and return FD.
No link list anywhere.
Note that this second validation of EXT against new target is light weight comparing
to the load. The first load goes through all EXT instructions with verifier ctx of
the target prog. The second validation needs to compare BTF proto tgr_prog_fd+tgt_btf_id
with EXT's btf_id only (and check tgt_prog_fd->type/expected_attach_type).
Since EXT was loaded earlier it has valid insns.
So if you're thinking "cannot we validate insns at load time, but then remember
tgt stuff instead of creating a partial link, and double validate BTF at raw_tp_open
when it's called without tgt_prog_fd?"
The answer is "yes, we can", but double validation of BTF I think is just a waste of cycles,
when tgt prog could have been held a bit between load and attach.
And it's race free. Whereas if we remember target prog_id at load then raw_tp_open is
shooting in the dark. Unlikely, but that prog_id could have been reused.

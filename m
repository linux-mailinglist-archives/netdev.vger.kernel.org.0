Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 204441449D0
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 03:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgAVCaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 21:30:21 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38089 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgAVCaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 21:30:21 -0500
Received: by mail-lj1-f193.google.com with SMTP id w1so5044235ljh.5;
        Tue, 21 Jan 2020 18:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wt6thzL7EeCnUzaYLEarYBen63ECERZwAiMkilhbX4Q=;
        b=czL/rt5BFosT8Ihta/QQ92SQ5uXnOwSyHvx8zyMF+ftd386SlFJXtxst5cwSNe48nA
         wVfY0IY/gZGwi5ZAzH+qksnKgxIYEwSv/uvqhsvwFRD8guEqrbdJMAgcioV6gPIRMj9M
         nVTDtgD+XmBcYW81KSJact8dYWtlSu3aVTcgtFA0CIE7UL9/3lP2+j7Ws7Tw4OsPTZKh
         kc1qcj9cSj+I28G424NnY8Dp6+vqkLl9+SrdfgvuE2fuABXNCYFcyjHHZvM5XV0rCMIg
         GQludLPtDsOkFPDd5Ir5kH6I/WrfNj85sbDRT+gZpYx8Mkm3BldKtZ3H55JMdkQqVHku
         9toQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wt6thzL7EeCnUzaYLEarYBen63ECERZwAiMkilhbX4Q=;
        b=dRwq5nn+0knO8AqeUUN4mfwAjxExb9HIYZKFo4cwWI7RbA6CFwKucXQdAuBg1gXxKZ
         Q5WAhyleVvloHH7mTR8R0m728AxijCtqP5BIzo1r0fWwpSuu5G9nMRLDfxswKqB3X7WS
         zjsUJXtLrKUGz7iAymD+dpcfd1OtqUhplkiaPGg93cixYZ9tz//pbTqSRY405BVR98I9
         miWDj98n4FM7Grclhz6NIchOS8Ezehms2VT+/Ww05vhKE7EWY9Lb6h1jqu/PzI+50wOd
         IZlpJfC7nttFhx29e1x1crewqCRUBc/d+K8kQKV3FOVJA1Yc4OZy/uz+QrCVjGkCwi22
         D0sw==
X-Gm-Message-State: APjAAAXFLeCg12a3uD2axUirNKrjEmbhhh4ffX82JP9dCEu8kaflzSNH
        2l5Hk0hQ8q4Wkv8ZHk5ZbHZw9Zi00X+49V4JeUo=
X-Google-Smtp-Source: APXvYqw7rGoWLyabmpSt6PAkWSMlW+JSrl5wJaICiED5741gYozUZrKMpk9os/lwSlbCqwwqxpwPGIzpRaTcyE8k9MA=
X-Received: by 2002:a2e:b55c:: with SMTP id a28mr17729598ljn.260.1579660218917;
 Tue, 21 Jan 2020 18:30:18 -0800 (PST)
MIME-Version: 1.0
References: <20200109063745.3154913-1-ast@kernel.org> <20200109063745.3154913-4-ast@kernel.org>
 <B7A2A8DD-B070-4F80-A9A0-6570260D4346@fb.com> <20200109221739.a7wuiqe37rqameqh@ast-mbp>
In-Reply-To: <20200109221739.a7wuiqe37rqameqh@ast-mbp>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jan 2020 18:30:07 -0800
Message-ID: <CAADnVQ+90dHXwwuES9aQ5Hmf-B8=kceJo+0Ne4myn8xhbssBYg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] bpf: Introduce function-by-function verification
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 2:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> > > +
> > > +   ret = do_check(env);
> > > +out:
> > > +   if (env->cur_state) {
> >
> > I think env->cur_state will never be NULL here. This check is necessary
> > before this patch (when we allocate cur_state in do_check()).
>
> yeah. good catch. 'if' can be dropped. I'll follow up with a clean up patch or
> will fold it if respin is necessary for other reasons.

that is the case of code review gone wrong.
This dropped 'if' during code move (because we both felt that it's unnecessary)
is the reason for syzbot panic under fault injection:
https://lore.kernel.org/lkml/00000000000048111c059cab1695@google.com/
I'm sending a fix for this shortly to restore that 'if' check.
This time adding a comment :)

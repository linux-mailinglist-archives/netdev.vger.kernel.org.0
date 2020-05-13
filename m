Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E311D1C9F
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733115AbgEMRxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732488AbgEMRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:53:06 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB54C061A0C;
        Wed, 13 May 2020 10:53:05 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id l73so1917318pjb.1;
        Wed, 13 May 2020 10:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tGUOftzrWRpzmZ/HEtDB/xqQ38CXh357XMPKH9+znTo=;
        b=s044Ybsr/od2kSF7Wi9GhyjWhKzNbH/YkWe552QWtOQbbPzlZ638BYedHPM24NHl2J
         ccDWSVKkzZQvp49AuwwreyKcebKRTvyfwZBGaWYexbfnNCczLSMkL13aCXjSXYShS9d2
         CQBER0Yv5aBXV1pvD2oPQJ9nDTfMlz+huCuk06t4KvBZtDzBqWr38Kv/bMGRC8CGZFF2
         TX9vldnw0NFOcBb8PguXhP4L6/SF8wOKW+k4DacsWcRKSCEafnh5Avj0o+wseniKSYM4
         Zvdlun9BsgPhAYhpZoavfqY5CNgtqA6OPDlsBWTko9MvlQvSnI1RinKyj7Yef2uJwJaL
         gX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tGUOftzrWRpzmZ/HEtDB/xqQ38CXh357XMPKH9+znTo=;
        b=hSzTfhQaIUXjtx+++YPoIJ9iKOYdP3e2s81TsupiJBUp900E/yCHqR88g7CS2sHYUC
         nknuPYB3nxuW3WsQA5/CTy7uOpyLSbN4p8TUbaFfwnEG/gtCozxA5jo4FmI+2WW0YgHU
         YFllKjF9DK5icxeSjgs8HbuUU4IsTERl7wsvFRUmWW3dXFhSCaffoWhRajqhhUX8WX3O
         xEdI83qcTSi3yBwq95kp6Ce50l1FCHA/9tTA49JLuwCKEDlOv+7PlNpi7eYfQ1ZAqO4c
         2zBhTMmhiL23GuHX/gr1MOwDIAOQLhuwlooZ0d0dG7/GjAqYgrT20YXIzgB3x9dzXEZp
         jq8A==
X-Gm-Message-State: AOAM531G2W0dofMzC0RXAgTtS0idqsIbovwPbTMx8MrOT6cIx2465gTL
        WSDhYtyt+qAVX9jCasjhhao=
X-Google-Smtp-Source: ABdhPJxop4g1CflpizWcnUdqdhEZDKmexIS8d23ZJsXY/CVpLBoCv/QoZuAc8INC3pjBP8WnkcwWdQ==
X-Received: by 2002:a17:90b:fd4:: with SMTP id gd20mr8619430pjb.181.1589392385226;
        Wed, 13 May 2020 10:53:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ba8f])
        by smtp.gmail.com with ESMTPSA id z1sm15957475pjn.43.2020.05.13.10.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 10:53:04 -0700 (PDT)
Date:   Wed, 13 May 2020 10:53:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Marek Majkowski <marek@cloudflare.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        network dev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com,
        Jann Horn <jannh@google.com>, kpsingh@google.com,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH v6 bpf-next 0/3] Introduce CAP_BPF
Message-ID: <20200513175301.43lxbckootoefrow@ast-mbp.dhcp.thefacebook.com>
References: <20200513031930.86895-1-alexei.starovoitov@gmail.com>
 <CAJPywT+c8uvi2zgUD_jObmi9T6j50THzjQHg-mudNrEC2HuJvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJPywT+c8uvi2zgUD_jObmi9T6j50THzjQHg-mudNrEC2HuJvg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 11:50:42AM +0100, Marek Majkowski wrote:
> On Wed, May 13, 2020 at 4:19 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > CAP_BPF solves three main goals:
> > 1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
> >    More on this below. This is the major difference vs v4 set back from Sep 2019.
> > 2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
> >    prevents pointer leaks and arbitrary kernel memory access.
> > 3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
> >    and making BPF infra more secure. Currently fuzzers run in unpriv.
> >    They will be able to run with CAP_BPF.
> >
> 
> Alexei, looking at this from a user point of view, this looks fine.
> 
> I'm slightly worried about REUSEPORT_EBPF. Currently without your
> patch, as far as I understand it:
> 
> - You can load SOCKET_FILTER and SO_ATTACH_REUSEPORT_EBPF without any
> permissions

correct.

> - For loading BPF_PROG_TYPE_SK_REUSEPORT program and for SOCKARRAY map
> creation CAP_SYS_ADMIN is needed. But again, no permissions check for
> SO_ATTACH_REUSEPORT_EBPF later.

correct. With clarification that attaching process needs to own
FD of prog and FD of socket.

> If I read the patchset correctly, the former SOCKET_FILTER case
> remains as it is and is not affected in any way by presence or absence
> of CAP_BPF.

correct. As commit log says:
"Existing unprivileged BPF operations are not affected."

> The latter case is different. Presence of CAP_BPF is sufficient for
> map creation, but not sufficient for loading SK_REUSEPORT program. It
> still requires CAP_SYS_ADMIN. 

Not quite.
The patch will allow BPF_PROG_TYPE_SK_REUSEPORT progs to be loaded
with CAP_BPF + CAP_NET_ADMIN.
Since this type of progs is clearly networking type I figured it's
better to be consistent with the rest of networking types.
Two unpriv types SOCKET_FILTER and CGROUP_SKB is the only exception.

> I think it's a good opportunity to relax
> this CAP_SYS_ADMIN requirement. I think the presence of CAP_BPF should
> be sufficient for loading BPF_PROG_TYPE_SK_REUSEPORT.
> 
> Our specific use case is simple - we want an application program -
> like nginx - to control REUSEPORT programs. We will grant it CAP_BPF,
> but we don't want to grant it CAP_SYS_ADMIN.

You'll be able to grant nginx CAP_BPF + CAP_NET_ADMIN to load SK_REUSEPORT
and unpriv child process will be able to attach just like before if
it has right FDs.
I suspect your load balancer needs CAP_NET_ADMIN already anyway due to
use of XDP and TC progs.
So granting CAP_BPF + CAP_NET_ADMIN should cover all bpf prog needs.
Does it address your concern?

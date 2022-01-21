Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9DE4957E5
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 02:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348250AbiAUBoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 20:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348356AbiAUBob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 20:44:31 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606DDC061574;
        Thu, 20 Jan 2022 17:44:30 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id s9so5140573plg.7;
        Thu, 20 Jan 2022 17:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wfl0pjMZM1Kbq/HRlo84Pj19EgrEOZiUYyD/ASOXiFM=;
        b=Ea88lDttp5I9UDxXpdNPE26XJU+GnCC19e8y1o2wLNWBHL/dTRiXpshcb53DGe73iX
         yzYIxP602yaP29iTfHhV1z6SGrqv5m0JlKxgR2ejjvgT5oit7yETQRULo9xNMP2JSa6x
         tFaWmg1q8i3MXqeOJ9X3XHloL44RLVUm9zPdcs57mKjnTzheymUTv5KBeDAUQ4SnRZPb
         03ZYQHCg+VS9XUrrAYsxLF8Vmf60o9fO4yHYrY6rb6WjBXobqhDSUbo1miZk6WVl3jV8
         bBtugMoYHWTKnC8ibLCOO+h1duN3M7XPRva2QJQ0IpkNUCE8frgwZjRKDnytpJwBODva
         iDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wfl0pjMZM1Kbq/HRlo84Pj19EgrEOZiUYyD/ASOXiFM=;
        b=P/hwLRkpwOQKlGUV5TTsndOINN+0aEgwF1ub2AQk7BslXhBJjS14uj0PrAtx9EQ/X5
         ykCwIGzAdByrdzenwQDdeTmG+HCa8pfGFyVem2/FZUE0e18ceCbIB+V+EaCFMoxD1pvg
         339M16jgVGLIKNbZ1MNrVaW3R6+Og2TyKeZMy1sOHcofWeAN13B/0VF3TOAAfP4PGReg
         8utZwqsRnYp89pbQtDfu8nMxwUpqMbvWFdPaiWWqSH7HKh0vawnbUf904+VXYNbbucn7
         AXpZpAQjP4P8Hcn1QtQVndggagcjqO6S4IJ7yGzWF24hL3jRJRP0fBYukoScfufArHT2
         eEbg==
X-Gm-Message-State: AOAM531YZ6rNYNW8ihsjkFfA3+19Kw8DwG16b4iex6hLy0ow+IjluDKk
        Jfa9lp2QQh6gPVj9iDbLhcUZmUpGrONiwQvwvJg=
X-Google-Smtp-Source: ABdhPJypOWnGm/gYyLTFh+/FRay60DL9kL5dlJIe+YOIF4HYVuvIfdI7xaVkZw7Ag2VaGXXicWn2Wld9Gd+PEGHKyCQ=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr1824276plo.116.1642729469813; Thu, 20
 Jan 2022 17:44:29 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 20 Jan 2022 17:44:18 -0800
Message-ID: <CAADnVQJMsVw_oD7BWoMhG7hNdqLcFFzTwSAhnJLCh0vEBMHZbQ@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        sunyucong@gmail.com, Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> This patch series is a refinement of the RFC patchset [1], focusing
> on support for attach by name for uprobes and uretprobes.  Still
> marked RFC as there are unresolved questions.
>
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts to specify a name string.
>
> uprobe attach is done by specifying a binary path, a pid (where
> 0 means "this process" and -1 means "all processes") and an
> offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> and that name is searched for in symbol tables.  If the binary
> is a program, relative offset calcuation must be done to the
> symbol address as described in [2].

I think the pid discussion here and in the patches only causes
confusion. I think it's best to remove pid from the api.
uprobes are attached to an inode. They're not attached to a pid
or a process. Any existing process or future process started
from that inode (executable file) will have that uprobe triggering.
The kernel can do pid filtering through predicate mechanism,
but bpf uprobe doesn't do any filtering. iirc.
Similarly "attach to all processes" doesn't sound right either.
It's attached to all current and future processes.

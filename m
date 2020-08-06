Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962BB23E019
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 20:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgHFSCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 14:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgHFSCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 14:02:11 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CB6C061574;
        Thu,  6 Aug 2020 11:02:11 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id d2so20957982lfj.1;
        Thu, 06 Aug 2020 11:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yWU+/2TNwaR73Azbye1A/oyewvoVzzzR97G8l1acWA=;
        b=TwXGtrEL6+F3dhTesINjf0jQll2IJYfy4lV8CpCPzC/SZ1KcB6+mR5t+OdsknbNsWT
         ZBSrMC+vVq+cGRsweMcKsyeMDwqxU13D8mmBz5xz6id1SW7BABQ9ggfIdwRmS4/Hj9yW
         CNs9lH+625sp2JCie/x2Kba265S2w7Mx1DcFZIdhJTVyVFzcfEgXOKVav13n7tdrXPTL
         Ghb8IYyV71G5XmlnmZTF3T56xcA5Wv5kINKQwFB4M8ZzqktfOnm+gRfI4sBkIck7gd9E
         hYswbQahPHvOsW/W3oFzkl03rKjOgtHZr9ZHj5rSxzzLVw1jyr4QuuEglHBDpBt8ouab
         5ccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1yWU+/2TNwaR73Azbye1A/oyewvoVzzzR97G8l1acWA=;
        b=tY5RC61BYNCg9dbFTHAtAV3dSk7GaLiewieA58630NL/FCFA0Ba6j6tmzf0B+MX8om
         6ZPDZCoVC4yskuJg/Z+z+4W9WFmjMs+YY2gWK/RSGk5LpyHaSeLhb2Agojn0Z9c6FcNq
         RXC8oxJ3xu79P8B31at/AnqXbnRwdr/CwPhgnImSqIK+FINTPYB2xC/Y6Pa93NKpF6bd
         iH+GH79PM1ANe947ym/oz954Ffzr6Ol8axcPGRX2uS8aErcN9hbV8a8c4hS49xI42HDZ
         Txau9GRsT2tLQbwq+8At7U8FjkJyVfUwMSbEElrv39pWxEHdZy9sbzNMIZ0FtmYSpJa0
         6pxg==
X-Gm-Message-State: AOAM532kg53o04F6gWO4hmILALRIYloRh81yP1hcLJq4nmyVPByYOfxz
        Tt6DO9oLGydsdjFtPDRIoq2rKUlRdLDuSoNijvw=
X-Google-Smtp-Source: ABdhPJxHHrS80IX4QvwuTmBuVdrgJM4zDnRZPInfSiLWxorGQ543gGTcrDt5DBr4Hb5GHpKmBx5zDuSip0VhrDggVLE=
X-Received: by 2002:a05:6512:74b:: with SMTP id c11mr4336640lfs.119.1596736929599;
 Thu, 06 Aug 2020 11:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200802013219.864880-1-andriin@fb.com> <20200806173931.GJ71359@kernel.org>
 <CAEf4BzbQTg7ct0+JpSFY2rQ4H8j6vScb0z_wJ-PeFqDzS=aE7Q@mail.gmail.com>
In-Reply-To: <CAEf4BzbQTg7ct0+JpSFY2rQ4H8j6vScb0z_wJ-PeFqDzS=aE7Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 11:01:57 -0700
Message-ID: <CAADnVQ+hVvmYh=ez_s3XJOy9MEPCAHU=opegxeQevZE4NZyh_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Add generic and raw BTF parsing APIs to libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 6, 2020 at 10:51 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > I haven't checked which of the patches, or some in other series caused
> > this on Clear Linux:
> >
> >   21 clearlinux:latest             : FAIL gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41, clang ver
> > sion 10.0.1
> >
> >   gcc (Clear Linux OS for Intel Architecture) 10.2.1 20200723 releases/gcc-10.2.0-3-g677b80db41
> >
> >   btf.c: In function 'btf__parse_raw':
> >   btf.c:625:28: error: 'btf' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> >     625 |  return err ? ERR_PTR(err) : btf;
> >         |         ~~~~~~~~~~~~~~~~~~~^~~~~
> >
>
> Yeah, fixed in https://patchwork.ozlabs.org/project/netdev/patch/20200805223359.32109-1-danieltimlee@gmail.com/
>

Thanks for headsup.
The fix will be pushed to bpf tree when net tree gets ffwd-ed to
Linus. Hopefully today.

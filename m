Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8720351F69
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 21:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhDATQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 15:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbhDATOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 15:14:20 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BD3C0613A9;
        Thu,  1 Apr 2021 11:04:44 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s17so3193378ljc.5;
        Thu, 01 Apr 2021 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9JnNqbp+jfX8Yeet9lEdVPDzns8/gphEhHuNm2ARo20=;
        b=YyCsKv7oInpoc6D4tMYefd1GPWGDDkJQMFslwOa53O8n2rmnnZ/g7VBGMTvUOl0fGJ
         D7wLA/2MMrzQZQsV5nnS6vjfRwTFespIpiD5VOxMgfRiMYGwZDMmgzE7CQuye+tzzn60
         wYUMO/dU6Y6ioGLouBz7BVR60ogvHnxVFSDp3jz9uWyECgmlEDCbWEB5KTYSsJHlCzFq
         nAyxXXnuCqdggk8KI2kowZYTH2lLDH8mcoL2P8WfDOYIVfG3TZ2KF1mxZm9XLQGiO4yj
         zjb/C16bT3oab//EeilxrbhsPAmwSQBXao/HIEzYIc04WiBxs60pk966zzvL1MtDGfcg
         FQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9JnNqbp+jfX8Yeet9lEdVPDzns8/gphEhHuNm2ARo20=;
        b=m4lfOU6M0C/Qo7uwQXWVUmWEOE66wDR7YNeGyU2itxvk8z2HhU9Q7EpEPc0ACcI/75
         XPqCVbrADWi5sMERFWefokZzyE9DP658RVqnD3mvtIQn+2pKVJ6Abnw/ri8COs7nsFuW
         bwyrCEGYYDkazEmd3SsGHxgQA8+2hJhqcghn/4amdPCIRMpblMUN3wQc/qU/wy8H1IaD
         crFaw1dDLsQtRzOIeDkPFJGulkLQObGvQydLnHPPTknuzQwdrOpN8SENMt9mnGjc6baj
         o5TJ94QxzsbzKECTkGMalYN5CXGnBlvE9SPINYSlfhdvmfosan/lVszZezTVnacJfHq5
         lAZg==
X-Gm-Message-State: AOAM53062fjspvG1J9vq7tLuYWGaPVz9BrLjSmUgCMMRyLm5HSJzi+8j
        fmAM/YR8lP1KFWi7f/+6r16FSnvJEVMkH3YdS1pjhWXO
X-Google-Smtp-Source: ABdhPJxnmVOSZRz8DqH/OxOr0exfcQnDyl/DbLWDDu5J0SJXup6oN/24+PhWtqGdP9OtPpXTRFzcfQpvbuRnNkdR75M=
X-Received: by 2002:a2e:3608:: with SMTP id d8mr6155259lja.21.1617300282954;
 Thu, 01 Apr 2021 11:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210326160501.46234-1-lmb@cloudflare.com> <CACAyw9_FHepkTzdFkiGUFV6F8u7zaZYOeH+bUjWxcBNBNeBYBg@mail.gmail.com>
In-Reply-To: <CACAyw9_FHepkTzdFkiGUFV6F8u7zaZYOeH+bUjWxcBNBNeBYBg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 1 Apr 2021 11:04:31 -0700
Message-ID: <CAADnVQLZAsELzD93eOOvHzcZKhbcOe0Uiu+VX_Q4VVVe94i1NA@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: link: refuse non-O_RDWR flags in BPF_OBJ_GET
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 7:04 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> On Fri, 26 Mar 2021 at 16:05, Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > Invoking BPF_OBJ_GET on a pinned bpf_link checks the path access
> > permissions based on file_flags, but the returned fd ignores flags.
> > This means that any user can acquire a "read-write" fd for a pinned
> > link with mode 0664 by invoking BPF_OBJ_GET with BPF_F_RDONLY in
> > file_flags. The fd can be used to invoke BPF_LINK_DETACH, etc.
> >
> > Fix this by refusing non-O_RDWR flags in BPF_OBJ_GET. This works
> > because OBJ_GET by default returns a read write mapping and libbpf
> > doesn't expose a way to override this behaviour for programs
> > and links.
>
> Hi Alexei and Daniel,
>
> I think these two patches might have fallen through the cracks, could
> you take a look? I'm not sure what the etiquette is around bumping a
> set, so please let me know if you'd prefer me to send the patches with
> acks included or something like that.

It is still in patchworks. I didn't have time to think it through.
Sorry for delay.

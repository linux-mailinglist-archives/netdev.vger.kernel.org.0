Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DE71CC5BD
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgEJA1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgEJA1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:27:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED080C061A0C;
        Sat,  9 May 2020 17:27:34 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x15so2331314pfa.1;
        Sat, 09 May 2020 17:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ntICPQQf/XPztEleueLnx8mDIcrlCQG5u+4L30w6dNI=;
        b=U1zNe4oV/5t5w/0/sDR1nCzUJhvWPBFebik68lo6xvLig5On5Nxhra7pOVFrTIHEVd
         BiQsFBbfLMhLqUSFYnY3LRJrSEyBkQIKswF6Xu/+UHP/kp9XY1pbQdAzAkSV6zmL6iyg
         gUwPCeCOPs/iAG6CrnMEdYdkBUbkDNYTu1VBfSbCLf//mEO3u+1FIiyxk3gB/ZXU0WqY
         vj63bOTIGAmd8U/lumFT5FA1vjg64k3c8rr3YRvFb7PZTjc8FFAFjqMMZ79jxfUtqVpB
         qoOg6WkIBRrm1LT7F+gxTBPf1RJDmXp/kDefrrh8G0AN+dFT+wLK+PiepFtnN5SXt0/V
         lrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ntICPQQf/XPztEleueLnx8mDIcrlCQG5u+4L30w6dNI=;
        b=k2d7F5oo5AjvpefnS+6FB4c8kYfIJRn0I20aDQv3Ik0pAL3k8Y0FgdXeYjRt60cXjT
         hIro5KoYlUxtnQz4k+ZYLzVEtxWnwqN9A4nDzhlkIaholnt0m1pKcFPy6q+md2E91DQN
         rmFA5FZMcuWTgrn4JBENzgScZ7u13/ZNjbVJZCcErTOM50FxFOL84SIDz/HmUXsJi75q
         6AsOXb0B5q1I8AA79djxPibAWgXCnOfClwBOHROQmttygiStqVQd2L1aP2Q5swyFpLIg
         2cjNg9EMEpnemRGKLimcyWhct7yeDpNozaPnlY8gka+me3HewZ9YIhGpqKAFBcoGwCMR
         2ckA==
X-Gm-Message-State: AGi0Pua8n5OeQWwBK+yyCm6BoES37bW2qXxWUfU24V38Et0GSD2rhMlv
        PRecJc92VHbLW3U4u+cKZ6A=
X-Google-Smtp-Source: APiQypKvYxAMj6jjV/Nf7rHsgeLKR4z9bneKfmK0DsM+6rppl0GoU3dXBhuxPCTZNoqrm8l1HXmmcw==
X-Received: by 2002:a62:8241:: with SMTP id w62mr3668343pfd.187.1589070454331;
        Sat, 09 May 2020 17:27:34 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id 9sm5853997pju.1.2020.05.09.17.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:27:33 -0700 (PDT)
Date:   Sat, 9 May 2020 17:27:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 00/21] bpf: implement bpf iterator for kernel
 data
Message-ID: <20200510002731.ztx2inlfs65x2izc@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175859.2474608-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:58:59AM -0700, Yonghong Song wrote:
> 
> Changelog:
>   v3 -> v4:
>     - in bpf_seq_read(), if start() failed with an error, return that
>       error to user space (Andrii)
>     - in bpf_seq_printf(), if reading kernel memory failed for
>       %s and %p{i,I}{4,6}, set buffer to empty string or address 0.
>       Documented this behavior in uapi header (Andrii)
>     - fix a few error handling issues for bpftool (Andrii)
>     - A few other minor fixes and cosmetic changes.

Looks great overall. Applied.
But few follow ups are necessary.

The main gotcha is that new tests need llvm with the fix
https://reviews.llvm.org/D78466.
I think it was applied to llvm 10 branch already,
but please add selftests/bpf/README.rst and mention
that above llvm commit is necessary to successfully pass the tests.
Also mention the verifier error that folks will see when llvm is buggy.

Few other nits I noticed in relevant patches.

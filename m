Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EE463A8B
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbhK3Pu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237639AbhK3Puy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:50:54 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD748C061574;
        Tue, 30 Nov 2021 07:47:30 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id 193so27223356qkh.10;
        Tue, 30 Nov 2021 07:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0E8rI2pldC/kJRYfFj5pOe4f4oCd/4elC+07mJ7cezg=;
        b=M3TECrBfeRNcmU2wzwJW8xakJwOsl96F7/wzhKVZtGVC4XSClhkZtPmX4O/ArG22Sh
         jjA+g1x4pyJ/4pviilYQPG+KhhSz3F4DZuFRxnjDPTFhjqCEG4DtQvvJ8KQb64m6allX
         yyKpYEUobSoiHyXxASAEYQUGG6RRUph0Z3VWpZpdz7lmDRWto1u3+zXWvSbLxkDosk3G
         7B4KO4BxCe1+OrGLaCgzq2a913mzBdZ+eBV/20lQAFekOCsIcFyVxoB2ZV2YfjeK8rzK
         SXg7rom0+dWxy0uNUSNNlxxK6f6+bXyctj/awauwEt7A4J/lXSd6tDQSaieEQdgMmo+8
         LQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0E8rI2pldC/kJRYfFj5pOe4f4oCd/4elC+07mJ7cezg=;
        b=aEDwJF6lOKVALR1v3UyQRQHeogd81xev40Ew9jIUQetifgumoPkmSjjzUdbBwJT8gh
         Aox3c91O/AsZOkas/dnjUVoMHEKtOpCjn/UUfA6phKawDM/kKaQ1B9Jr5QkDaIf6nDCH
         PfW8pzA2oVoG51jWAqeerte6/2x2L78t2d5Ru4qh5G3cUhWIae1/IOJNKhGXebFubQZ/
         r7H/QT/CWsGNkIbnt2nj1GG+HkiVc2hpTBie2sgjFp2N7MrxiHQZ2+CLyrYRvWHXwDZ0
         hkBJf7DXD5f00W1s4GzRDqMTV6Zdg1unpDcr5IvLN92/hkPlP0uQwsGrZWki6uEYxrjz
         89cQ==
X-Gm-Message-State: AOAM533lBt32BQn2kBPAMjB0bGD6Ra/DUZEVGI4su675A82UvO8XfFFU
        D13u9KzrvtZDYnMof721w+pUpy489osVr2bX3rA=
X-Google-Smtp-Source: ABdhPJztrZJR8wzz1uvKDh9tgCXsCwcvYHaAV5LAj9Tyfjkwz7VlVZjHRc1l9DQlQzaVs/JoaW2gQFPu+qw5proo6JA=
X-Received: by 2002:a05:620a:134a:: with SMTP id c10mr46334061qkl.207.1638287249916;
 Tue, 30 Nov 2021 07:47:29 -0800 (PST)
MIME-Version: 1.0
References: <20211120112738.45980-1-laoar.shao@gmail.com> <20211120112738.45980-8-laoar.shao@gmail.com>
 <yt9d35nf1d84.fsf@linux.ibm.com> <20211129123043.5cfd687a@gandalf.local.home>
 <CALOAHbCVJcPdYq2j_VvhHBE-xLBnizRRx2oBu-KNgOr5jMf6RQ@mail.gmail.com> <20211130092333.77408a81@gandalf.local.home>
In-Reply-To: <20211130092333.77408a81@gandalf.local.home>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 30 Nov 2021 23:46:54 +0800
Message-ID: <CALOAHbDvxpjW9eD2_FeKMJzXdbEkWJykbdcjtk1Et_+=ybvgVw@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded 16
 with TASK_COMM_LEN
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Tom Zanussi <zanussi@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 10:23 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 30 Nov 2021 11:03:48 +0800
> Yafang Shao <laoar.shao@gmail.com> wrote:
>
> > Many thanks for the quick fix!
> > It seems this fix should be ahead of patch #7.
> > I will send v3 which contains your fix.
>
> Don't bother. I'm actually going to send this to Linus as a bug fix.
>

Great!  Thanks for the work.

-- 
Thanks
Yafang

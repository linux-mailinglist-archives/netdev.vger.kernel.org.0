Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 640FFDD6A4
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 06:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfJSElW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 00:41:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37791 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfJSElV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 00:41:21 -0400
Received: by mail-io1-f67.google.com with SMTP id b19so9890864iob.4;
        Fri, 18 Oct 2019 21:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=p2VVU+8PljankkCSMCXqV9yM+SFP23m/H23f2IowcHc=;
        b=T+l2Vpkn9FUAiH16Xkxl9YFf/obtWD724fvhqZ05m4ZwdmFHOEhnZlZOLybtAPdmCT
         SKF6PpvONV1178FTeVeoa0C+moSh2BmwSLc5Tuw2rgnC2+cZPvsdCS/70I767A0kgr0M
         Tl4fi1FzYw/GwMmKMfNZHRHK2oQV6HFb9IqDSTc8ik7bhbu7hvkyL9IaCn3YM4Frpug+
         kVDqSe1n3/bFbB+b67XjNJdmHh4Ic+1Opa/M7oKj9RAMcLLFLGzFlcm6lrjkfLX+fqtX
         3QSXHVdsJAZ8oDfaZ08JDx7fS0bksC40ZEyYhV/CVfp3g87gVUEHT3nIywvrCqx9FV5c
         g6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=p2VVU+8PljankkCSMCXqV9yM+SFP23m/H23f2IowcHc=;
        b=WWmR2y8T23H8uOr1NwDuZ+cIAcZNVqygCOFVjXTjVRdtsIQE4/Q3dd1XSvVhMQBgI8
         BevnMRoSZWyRymxoPFhrPZk2Q0yOazLTRwVXEQ/CDo/Dw8/aG+nIy+EW5GJ8U8QBiiR6
         hQgijQPgxzdQW0frwcWW4sd3FlU/4kh1AjMPxMhMoTUiw7IbkpEQt/g80cKfFYj8HCi0
         vBcANCGK2qgLuSpiVVJHzsvUZw6bAOuXs6fMwgk04tVDpgT1L2naYCQFW4fjSdjGHBy1
         SQXdnvd2Ez3c6H/KQaRVVb+GqihkBx56Y7k38jRdPjLRlRzphfFAdvRwTQ0N/10cNnaj
         8p5Q==
X-Gm-Message-State: APjAAAWFRPHcjs6a5wicP4fZdcaO/dFJHFn8HLEV/2RB7kw3WJfG6qmp
        KdJ22YN6TE8sZ4JK3Tz8Dcs=
X-Google-Smtp-Source: APXvYqzLwhYAv+PlKOslXSIKp9Q5XxGd6tzlv/kzFqD5eR1PFumNUoSf8kaeuqGwNnzPi8/wBX8w/A==
X-Received: by 2002:a02:b817:: with SMTP id o23mr12507895jam.101.1571460080843;
        Fri, 18 Oct 2019 21:41:20 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z20sm2928890iof.38.2019.10.18.21.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 21:41:20 -0700 (PDT)
Date:   Fri, 18 Oct 2019 21:41:12 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Message-ID: <5daa93e8bfc26_3a012ad7c9bb25bca6@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQLyi9os2FK9OSiZ2CMKtEd7NOR=P_Q-Qd9_0Lu9dn63kw@mail.gmail.com>
References: <157140968634.9073.6407090804163937103.stgit@john-XPS-13-9370>
 <4da33f52-e857-9997-4226-4eae0f440df9@fb.com>
 <CAADnVQLyi9os2FK9OSiZ2CMKtEd7NOR=P_Q-Qd9_0Lu9dn63kw@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, add kernel version section parsing
 back
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Fri, Oct 18, 2019 at 9:52 AM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > On 10/18/19 7:41 AM, John Fastabend wrote:
> > > With commit "libbpf: stop enforcing kern_version,..." we removed the
> > > kernel version section parsing in favor of querying for the kernel
> > > using uname() and populating the version using the result of the
> > > query. After this any version sections were simply ignored.
> > >
> > > Unfortunately, the world of kernels is not so friendly. I've found some
> > > customized kernels where uname() does not match the in kernel version.
> > > To fix this so programs can load in this environment this patch adds
> > > back parsing the section and if it exists uses the user specified
> > > kernel version to override the uname() result. However, keep most the
> > > kernel uname() discovery bits so users are not required to insert the
> > > version except in these odd cases.
> > >
> > > Fixes: 5e61f27070292 ("libbpf: stop enforcing kern_version, populate it for users")
> > > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > > ---
> >
> > In the name of not breaking users of weird kernels :)
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> What does it mean that uname is cheated?
> Can libbpf read it from /proc/sys/kernel/osrelease ?
> or /proc/version?
> Is that read only or user space can somehow overwrite it?

In this case LINUX_VERSION_CODE as shown in version.h from linux-headers
does not much what is being reported by /proc/version or osrelease.

So its a bit surprising to me as well but I haven't got to the bottom
of it. Maybe something to do with how proc is mounted in this kubernetes
setup?

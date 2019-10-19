Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2CADD5FE
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 03:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfJSBdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 21:33:31 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35582 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfJSBdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 21:33:31 -0400
Received: by mail-lj1-f193.google.com with SMTP id m7so7972542lji.2;
        Fri, 18 Oct 2019 18:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3d6xstmVpC1Pa0CGJR/j47g/ueus+Cqpwd9n/D8x+fc=;
        b=tENNXGCEKE1K1igQfUd9fcfuyXPXQYrGOT3YQwHNo+mRKOT+ibgU/riupmMXtZD0+C
         jt9r0BrRkCsgfSw8aJuq3TbVtOYZd3vzsujXgmPBPQKSSr/gq8Yw56CX3ivVhumSsvos
         pDEB8Akh2uvF6D48PGJKSpnlLTT8sJ1FSGPaF6XhhKBQTtEL0RE8XCsXSB4KHfiFqQU4
         x6mXwo65fJBThDIF2XZ0rusf4IDog3vUJhAXjV7ugudZdEmwsq6f1mBXE+ywhLWUP6XQ
         a4VqMvxKEZMwUHpcHpdvvrh875RVdYGcqR7zFhTXNS9m+5w7w82jCku0vPx7Ci6c54x+
         iYgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3d6xstmVpC1Pa0CGJR/j47g/ueus+Cqpwd9n/D8x+fc=;
        b=kg/ZyJUQtOTS6UMU+871RvNPd8XJvFAiPHXi42W9H9Ah9y2zJU2u5ASBNqJcZSVdc/
         KigVRAYQ6OTFSSkLt2L6qZoj8r1rZZGGlex1CLoOwfeKwNzuawushT6TTNGkobvjOTQ4
         /Z2Saf7W4N+0nvqT3eH40++9rkMEn3fvcBCUWfgEgvso1WciXmIMU7tisgcxWtCdeS62
         CetONUBmiuhMidH2v9IjDt6rCrYjop7whrP8Rgjyedt81uuRSJy5wVPg+HeDw0atwKHA
         Xx2AV0ms5XeJPXRQ86nk1D2Ja7vGUmyqnoNcut3gpP3UST5pLANNqZuf6aTMKDV5/yZq
         EjfA==
X-Gm-Message-State: APjAAAUyShP4Z+7QYZZmd0KqGV4D+U5NRpHAmOgrqq5kvQMJoEQhTQCG
        6xqbSKbQx8xoWdVvcGQJ9hwtQTYHJ84pOt5K9vs=
X-Google-Smtp-Source: APXvYqzEov0CWNUyjRa+S3yBDhDIzPAtSswDfC+FuTOtWZKxASbhoYcoSIRY67L4zjd7DBANJ3+kE8zqrnsBzt9umUw=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr8117895lji.142.1571448808934;
 Fri, 18 Oct 2019 18:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <157140968634.9073.6407090804163937103.stgit@john-XPS-13-9370> <4da33f52-e857-9997-4226-4eae0f440df9@fb.com>
In-Reply-To: <4da33f52-e857-9997-4226-4eae0f440df9@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 18 Oct 2019 18:33:16 -0700
Message-ID: <CAADnVQLyi9os2FK9OSiZ2CMKtEd7NOR=P_Q-Qd9_0Lu9dn63kw@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, add kernel version section parsing back
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 9:52 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> On 10/18/19 7:41 AM, John Fastabend wrote:
> > With commit "libbpf: stop enforcing kern_version,..." we removed the
> > kernel version section parsing in favor of querying for the kernel
> > using uname() and populating the version using the result of the
> > query. After this any version sections were simply ignored.
> >
> > Unfortunately, the world of kernels is not so friendly. I've found some
> > customized kernels where uname() does not match the in kernel version.
> > To fix this so programs can load in this environment this patch adds
> > back parsing the section and if it exists uses the user specified
> > kernel version to override the uname() result. However, keep most the
> > kernel uname() discovery bits so users are not required to insert the
> > version except in these odd cases.
> >
> > Fixes: 5e61f27070292 ("libbpf: stop enforcing kern_version, populate it for users")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
>
> In the name of not breaking users of weird kernels :)
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

What does it mean that uname is cheated?
Can libbpf read it from /proc/sys/kernel/osrelease ?
or /proc/version?
Is that read only or user space can somehow overwrite it?

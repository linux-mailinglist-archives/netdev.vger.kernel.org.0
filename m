Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1136F58B88
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbfF0UUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:20:06 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39057 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF0UUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:20:06 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so3917350qta.6;
        Thu, 27 Jun 2019 13:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V6nBBib2uAQ8MeL4AqygiKPfET4jPWJDtqXE3QRJH3c=;
        b=jElBBPkn5n99AvAkmVP9pFWrhwPnMx0PgW0IPu5BLJP9jKxBo1U28mxZGN4Se8g7Xl
         6jTh9BwY1s1Z5nIDOsWjB49JnE2QYYatC98D+jNaewyiKsyhJG6BsNh1DwPge4WzrK/M
         mej5uttO1PJmsMCz9R639PBMhzJPpZOsATYFU90fjTFf1j6JV/0jph4TTNy5M6Z7Y2P/
         FWhhHsgXFszhkWrNb+a+EXTQOq4WsDhfzx9ZVN4FUbCCfe13HDmo803EzxHr938/W6jh
         V8QEjehqQ0CY3ADKi+6wfB5UzaCdUEEMV1r+rE313f0Lpf9oilxqj1VgqpfodH3Ux0pD
         pqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V6nBBib2uAQ8MeL4AqygiKPfET4jPWJDtqXE3QRJH3c=;
        b=rUXJsmWbkVH2kimRtNsIUgemrV8q6y4OVbsj6qeJ4X/E12EpDsLV0HKQMi+i01DeUp
         qAUkaf+8DTYfi8cyO27HonJ/LqPdeD4kgIDOiRaCHyKfRB2wpsc9wM/PaAao/z9GLYTK
         OG1VcUr0d4HvYnc2P4YSgU9J69sQJ9vfMQdEO+oyL1qEPM5hfIGsrxreFKVRpgcRrt62
         VXwsJAMLkpVR1UefiX9+qxlcoXjo5WcuXc21LwVRgccCyxGQYV1pJbdtA4N5g61+4t5f
         C8NmLkh4jyrsb2UDOlilcKyPlsLJtWydTuiyHIJFN/YiDRfODIy8zWBuRYw+oHYNGTqD
         wLFw==
X-Gm-Message-State: APjAAAWWVWlZMw+XxDfhukaS/ykb4xxdpBZcEiTWm/0PEbVUTvoY0lDK
        dIOBjvdEAWxY0F9Qg/zf8kyqSneEwytQoCBNkprdPP1frhE=
X-Google-Smtp-Source: APXvYqwiw0cIIGZPHp+W8N4Iv5ObPdhk3We6pKDg86ky7OdOAifo5fKFJ6Itw0BBTtp+0rrUXvdppWWSYNCTfz9J1d8=
X-Received: by 2002:a0c:818f:: with SMTP id 15mr4679279qvd.162.1561666805450;
 Thu, 27 Jun 2019 13:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190626232133.3800637-1-andriin@fb.com> <20190626232133.3800637-2-andriin@fb.com>
 <E28D922F-9D97-4836-B687-B4CBC3549AE1@fb.com> <CAEf4Bza1p4ozVV-Vn8ibV6JRtGc_voh-Mkx51eWvuVi1P8ogSA@mail.gmail.com>
 <079A7D73-697C-4CFD-97F3-7CFB741BE4C3@fb.com>
In-Reply-To: <079A7D73-697C-4CFD-97F3-7CFB741BE4C3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Jun 2019 13:19:53 -0700
Message-ID: <CAEf4BzYN0uwOd8Kqo+wLQCiiHmHj1ZYS4aVhQDhf1R9Kbhp5pw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: capture value in BTF type info for
 BTF-defined map defs
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:56 AM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jun 27, 2019, at 10:47 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Jun 27, 2019 at 10:27 AM Song Liu <songliubraving@fb.com> wrote:
> >>
> >>
> >>
> >>> On Jun 26, 2019, at 4:21 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> Change BTF-defined map definitions to capture compile-time integer
> >>> values as part of BTF type definition, to avoid split of key/value type
> >>> information and actual type/size/flags initialization for maps.
> >>
> >> If I have an old bpf program and compiled it with new llvm, will it
> >> work with new libbpf?
> >
> > You mean BPF programs that used previous incarnation of BTF-defined
> > maps? No, they won't work. But we never released them, so I think it's
> > ok to change them. Nothing should be using that except for selftests,
> > which I fixed.
>
> I see. This makes sense.
>
> >
> >>
> >>
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >
> > <snip>
> >
> >>> diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
> >>> index 1a5b1accf091..aa5ddf58c088 100644
> >>> --- a/tools/testing/selftests/bpf/bpf_helpers.h
> >>> +++ b/tools/testing/selftests/bpf/bpf_helpers.h
> >>> @@ -8,6 +8,9 @@
> >>> */
> >>> #define SEC(NAME) __attribute__((section(NAME), used))
> >>>
> >>> +#define __int(name, val) int (*name)[val]
> >>> +#define __type(name, val) val *name
> >>> +
> >>
> >> I think we need these two in libbpf.
> >
> > Yes, but it's another story for another set of patches. We'll need to
> > provide bpf_helpers as part of libbpf for inclusion into BPF programs,
> > but there are a bunch of problems right now with existing
> > bpf_heplers.h that prevents us from just copying it into libbpf. We'll
> > need to resolve those first.
> >
> > But then again, there is no use of __int and __type for user-space
> > programs, so for now it's ok.
>
> OK. How about we put these two lines in an separate patch?

Sure, no problem.

>
> Thanks,
> Song
>

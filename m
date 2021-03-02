Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D946632A2CF
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837601AbhCBIdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:33:14 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:54087 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379836AbhCBBcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 20:32:09 -0500
Received: by mail-wm1-f52.google.com with SMTP id e23so844654wmh.3;
        Mon, 01 Mar 2021 17:31:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HZ2hCyBVrm0WxssHI6NWJB7Y69JCeL0DnQlIlq8D1Hg=;
        b=oszh1FTmjcsL6LHsYV2rwrgHeAE/G/toR4wnieh+w8KdrDtjTXygsWcd0ax3OHdzlK
         Or564gZ8AUDDB7mjN90bnJJ3uaM0RlAo/wuCfUI/DSZWeE63I8zwOaNUSRznC92aKWHQ
         68FSx42wL8KIEhRZO02NS0u53xFZ6qgTZVmNEnd/rSmhupQCnI9ybYwy/jsb7FPjqJpB
         oawDi/uu6HgCWR6+MkLHwkfrfJF6zK7nICYrs96lmleMWgdCWbuS5lsR1RidmxwBJjuJ
         sKOwrhkUNFbS68FUOmtMsCUrjPRiddn1dQmvk8Sxa5O/I4RrdrsqqMALe89eaYUSZn37
         Z6zg==
X-Gm-Message-State: AOAM531hYIrtPuUQpdEomllRgzOADHMXZUuGVMCslYv/rli3t6Ehg+DA
        ZGKTwC20e+zmwY93Uo+ytrPYz3sSbfwkU/KVWP8=
X-Google-Smtp-Source: ABdhPJwiy+pSdCpqtHFSPxg84vqmpWtyS8T+zOiUa45ftB6XmtCRAvzwCI9hMYTc27zlgzzGc2kh2M4l9AFpNvWUbBE=
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr1422250wmc.74.1614648686579;
 Mon, 01 Mar 2021 17:31:26 -0800 (PST)
MIME-Version: 1.0
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
 <20210223154327.6011b5ee@carbon> <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
 <CAEf4BzaqsyhJvav-GsJkxP7zHvxZQWvEbrcjc0FH2eXXmidKDw@mail.gmail.com> <b64fa932-5902-f13f-b3b9-f476e389db1b@isovalent.com>
In-Reply-To: <b64fa932-5902-f13f-b3b9-f476e389db1b@isovalent.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 1 Mar 2021 17:31:13 -0800
Message-ID: <CAOftzPhhJmvk=XrzsvLGie7gS5yTS+MyRv8jMuyLxh520mD0Aw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 8:51 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-02-24 10:59 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Feb 24, 2021 at 7:55 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 2/23/21 3:43 PM, Jesper Dangaard Brouer wrote:
> >>> On Tue, 23 Feb 2021 20:45:54 +0800
> >>> Hangbin Liu <liuhangbin@gmail.com> wrote:
> >>>
> >>>> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
> >>>> in bpf.h. This will make bpf_helpers_doc.py stop building
> >>>> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
> >>>> future add functions.
> >>>>
> >>>> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> >>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >>>> ---
> >>>>   include/uapi/linux/bpf.h       | 2 +-
> >>>>   tools/include/uapi/linux/bpf.h | 2 +-
> >>>>   2 files changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> Thanks for fixing that!
> >>>
> >>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >>
> >> Thanks guys, applied!
> >>
> >>> I though I had already fix that, but I must have missed or reintroduced
> >>> this, when I rolling back broken ideas in V13.
> >>>
> >>> I usually run this command to check the man-page (before submitting):
> >>>
> >>>   ./scripts/bpf_helpers_doc.py | rst2man | man -l -
> >>
> >> [+ Andrii] maybe this could be included to run as part of CI to catch such
> >> things in advance?
> >
> > We do something like that as part of bpftool build, so there is no
> > reason we can't add this to selftests/bpf/Makefile as well.
>
> Hi, pretty sure this is the case already? [0]
>
> This helps catching RST formatting issues, for example if a description
> is using invalid markup, and reported by rst2man. My understanding is
> that in the current case, the missing star simply ends the block for the
> helpers documentation from the parser point of view, it's not considered
> an error.
>
> I see two possible workarounds:
>
> 1) Check that the number of helpers found ("len(self.helpers)") is equal
> to the number of helpers in the file, but that requires knowing how many
> helpers we have in the first place (e.g. parsing "__BPF_FUNC_MAPPER(FN)").

This is not so difficult as long as we stick to one symbol per line:

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index e2ffac2b7695..74cdcc2bbf18 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -183,25 +183,51 @@ class HeaderParser(object):
         self.reader.readline()
         self.line = self.reader.readline()

+    def get_elem_count(self, target):
+        self.seek_to(target, 'Could not find symbol "%s"' % target)
+        end_re = re.compile('^$')
+        count = 0
+        while True:
+            capture = end_re.match(self.line)
+            if capture:
+                break
+            self.line = self.reader.readline()
+            count += 1
+
+        # The last line (either '};' or '/* */' doesn't count.
+        return count
+

I can either roll this into my docs update v2, or hold onto it for
another dedicated patch fixup. Either way I'm trialing this out
locally to regression-test my own docs update PR and make sure I'm not
breaking one of the various output formats.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E13D13B594
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 23:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgANW7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 17:59:03 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41394 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgANW7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 17:59:03 -0500
Received: by mail-pf1-f196.google.com with SMTP id w62so7326178pfw.8;
        Tue, 14 Jan 2020 14:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=m4skGWIyrIgKIVaOl1NoSoEAFejOap4tlTn77hdy+W0=;
        b=kqjEHBFECdnAFIdfHlmFOUgzmznNCccWHlO/Qge35RK2GndBC5bAObVVWCByOk/qAB
         uaKm70JFpKvo7EW+A73PXANa3EQ+6Pyt6vbffzHEbXBU639M7/6DLXt8jTLWDR09owrA
         eEfL27HdJNhn/MB4GZUYPPVAx4BmIP/nWIcQgHyYmG6GvdrPWTSfIG3GfWY+SS8GuuV5
         Jq8J0XHMrZf6LdYBWkn2eCiwiw0UcNENEYXgNCccyeFX1sdqzYL/SFGAqhLmRfMfc6Oh
         HpZmYArgmK8TTAV88ulih5AIeW2dq1vkiyqhs6HrljLaVfSDO0mPoVbv09iHWCCIMF4H
         odAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=m4skGWIyrIgKIVaOl1NoSoEAFejOap4tlTn77hdy+W0=;
        b=uFEKgl2O6vu10un0UJgu5KUG5mOzQ4SVToI49hxyEqJBT6S5hVuRdJ6SdScUWAF8Gp
         RHB9ZhoisE/P9UUrNHlOIppWWkMph/X5la9mFJSZH4o5Ckwdj/pz2rM51lAHD48pvz9Z
         afLfW3pGZap+hs36SiCIJjhH0jUtG+ISCdgIZRg4kFKMKnprqH6jwX+V4eSpzjhamz1Q
         okrS4opnkB6ibqe5s158gZDorV3AqKi/WntKZvlkc17q3g5TTWZB2yFamdGRLV4bv0Am
         s1688rHBvgy2NG4EDcyDgCivcGa9Dc2qgXhUrSj9H51vPqn4+TtUcn8i8VIQay7aMG9i
         9/fA==
X-Gm-Message-State: APjAAAXEuvJcOb4+4UcA24TxKFE5tSi5t/kkR9b9rW13yhG7J9fF5kZa
        8f/CD2q4qJpWJGpORddvpM4=
X-Google-Smtp-Source: APXvYqwKm7i1/xYpb26HJ/+uEIjvl4mcJWH2P3WZ2vrvEJtVkvyNsvslX7D6z3Cfw+jJSO4OYWnF1Q==
X-Received: by 2002:a63:3d8e:: with SMTP id k136mr29220219pga.4.1579042742373;
        Tue, 14 Jan 2020 14:59:02 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::77bf])
        by smtp.gmail.com with ESMTPSA id iq22sm18179435pjb.9.2020.01.14.14.59.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 14:59:01 -0800 (PST)
Date:   Tue, 14 Jan 2020 14:58:58 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: Fix include of bpf_helpers.h when
 libbpf is installed on system
Message-ID: <20200114225857.kdmedok6mie55j6o@ast-mbp.dhcp.thefacebook.com>
References: <20200114164250.922192-1-toke@redhat.com>
 <CAEf4Bzb9sTF4BWA1wyWM-3jsMUnbwYi1XtkDj8ZXdyHk7C4_mQ@mail.gmail.com>
 <CAEf4Bzaqi6Wt4oPyd=ygTwBNzczAaF-7boKB025-6H=DDtsuqQ@mail.gmail.com>
 <87sgkhvie6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sgkhvie6.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 10:26:57PM +0100, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
> > On Tue, Jan 14, 2020 at 11:07 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> >>
> >> On Tue, Jan 14, 2020 at 8:43 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> >
> >> > The change to use angled includes for bpf_helper_defs.h breaks compilation
> >> > against libbpf when it is installed in the include path, since the file is
> >> > installed in the bpf/ subdirectory of $INCLUDE_PATH. Fix this by adding the
> >> > bpf/ prefix to the #include directive.
> >> >
> >> > Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken from selftests dir")
> >> > Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> >> > ---
> >> > Not actually sure this fix works for all the cases you originally tried to
> >>
> >> This does break selftests/bpf. Have you tried building selftests, does
> >> it work for you? We need to fix selftests simultaneously with this
> >> change.
> >>
> >> > fix with the referred commit; please check. Also, could we please stop breaking
> >> > libbpf builds? :)
> >>
> >> Which libbpf build is failing right now? Both github and in-kernel
> >> libbpf builds are fine. You must be referring to something else. What
> >> exactly?
> >
> > I think it's better to just ensure that when compiling BPF programs,
> > they have -I/usr/include/bpf specified, so that all BPF-side headers
> > can be simply included as #include <bpf_helpers.h>, #include
> > <bpf_tracing.h>, etc
> 
> And break all programs that don't have that already? Just to make the
> kernel build env slightly more convenient? Hardly friendly to the
> library users, is it? :)

Could you explain the breakage ?
bpf_helpers.h and bpf_helper_defs.h are installed in the same location.
If prefix==/usr during make install of libbpf they both will go into
/usr/include/bpf

Are you saying the bpf progs had:
#include <bpf/bpf_helpers.h>
to pick that header from /usr/include and commit 6910d7d3867a that did:
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,7 +2,7 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__

-#include "bpf_helper_defs.h"
+#include <bpf_helper_defs.h>
broke it?
If so this bit needs to be reverted.
And we need a selfttest for such include order.

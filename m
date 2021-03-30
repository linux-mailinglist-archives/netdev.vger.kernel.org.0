Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9ED34E3D3
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 11:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhC3JBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 05:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhC3JAw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 05:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69DB5619AD;
        Tue, 30 Mar 2021 09:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617094851;
        bh=7BKJpJRJJea7jWMl80W5EN9UAj8omc2Cs2r3GAQepzo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wsuslf1aShoCKyVO6hEvzEdZFMLQDIu2sbrH3x69Zj3fzv+Ssz4//dpuMEbWngOUq
         Zjq5v+sm416E8eDL5lOizTzEa7Erwc/f8fCuW75qsYfDXgJ3oE6b4i2kQYeYtPZd4I
         FK+fITjA3iXC63XWANkkhj4NvYlqDfeUjJbbuVDoJnM3Z/9egQRLEp8Koxo3BlExlm
         KJf0GkZPfII5XV5fPTrpbDnwtlOxinHOG65Ikgkmm49iP6nf4qHit/q0d/LnVY5qb5
         qa+2M5n3XKCJv1Wm+mrJgHL5nAHA2YFzyo0MHv0A+yCW12hqtwqifDnY1PrNFQltR4
         2Y+g7lZslykhg==
Received: by mail-oo1-f53.google.com with SMTP id j10-20020a4ad18a0000b02901b677a0ba98so3616658oor.1;
        Tue, 30 Mar 2021 02:00:51 -0700 (PDT)
X-Gm-Message-State: AOAM531q1tUjYttWC1Plkfc9XuItgOGcA+fFv0WHfXrMBQvc7MswRNus
        E9i6o0x2QMgnTmzWwbDN6fRjkSuusGeFcFzGuws=
X-Google-Smtp-Source: ABdhPJzpNNBXFi0zlX+fSlV+iQuwxA7n7pfSwfoGiIinCD5YA1YpFSD4jDETbIF3gyjCIllkPcG9Qx+cRKe7U+THggk=
X-Received: by 2002:a4a:304a:: with SMTP id z10mr25148861ooz.26.1617094850520;
 Tue, 30 Mar 2021 02:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210322160253.4032422-1-arnd@kernel.org> <20210322160253.4032422-7-arnd@kernel.org>
 <YGLkPjSBdgpriC0E@blackbook>
In-Reply-To: <YGLkPjSBdgpriC0E@blackbook>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 30 Mar 2021 11:00:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
Message-ID: <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Sebor <msebor@gcc.gnu.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        tboot-devel@lists.sourceforge.net,
        Intel Graphics <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Roman Gushchin <guro@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Odin Ugedal <odin@uged.al>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 10:41 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrot=
e:
>
> On Mon, Mar 22, 2021 at 05:02:44PM +0100, Arnd Bergmann <arnd@kernel.org>=
 wrote:
> > I'm not sure what is expected to happen for such a configuration,
> > presumably these functions are never calls in that case.
> Yes, the functions you patched would only be called from subsystems or
> there should be no way to obtain a struct cgroup_subsys reference
> anyway (hence it's ok to always branch as if ss=3D=3DNULL).
>
> I'd prefer a variant that wouldn't compile the affected codepaths when
> there are no subsystems registered, however, I couldn't come up with a
> way how to do it without some preprocessor ugliness.

Would it be possible to enclose most or all of kernel/cgroup/cgroup.c
in an #ifdef CGROUP_SUBSYS_COUNT block? I didn't try that
myself, but this might be a way to guarantee that there cannot
be any callers (it would cause a link error).

> Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>

Thanks

        Arnd

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA534EAD0
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbhC3OpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 10:45:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:36728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231803AbhC3Oo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 10:44:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617115495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=llTp9KMmNhLgpFrt/A/4gk0SgpNaUf1ZpYpNvho6oEk=;
        b=iKbol1UC2cYC03I2rvUtoSu92j1pz2tv1L6/9iiw7cxLhRzh90EQvV5vkd5t59I4w79b5z
        //6Ea77uYBp+fXZGWtXmCr26hrFxJVsTlICwAL4byi52zB9FKuPbHVzN1zqRgW2z3Slp3o
        4tg7hayC693qItZd+Jni902Xu3F2GZQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC1C6B315;
        Tue, 30 Mar 2021 14:44:54 +0000 (UTC)
Date:   Tue, 30 Mar 2021 16:44:52 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Martin Sebor <msebor@gcc.gnu.org>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        the arch/x86 maintainers <x86@kernel.org>,
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
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Message-ID: <YGM5ZJlK1V7ex9xR@blackbook>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-7-arnd@kernel.org>
 <YGLkPjSBdgpriC0E@blackbook>
 <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9pRQkLwCQMovNrXD"
Content-Disposition: inline
In-Reply-To: <CAK8P3a3nUCGwPpE+E820DniY8Haz1Xx72pA38P6s5MWsbi0iAQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9pRQkLwCQMovNrXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 30, 2021 at 11:00:36AM +0200, Arnd Bergmann <arnd@kernel.org> wrote:
> Would it be possible to enclose most or all of kernel/cgroup/cgroup.c
> in an #ifdef CGROUP_SUBSYS_COUNT block?
Even without any controllers, there can still be named hierarchies (v1)
or the default hierarchy (v2) (for instance) for process tracking
purposes. So only parts of kernel/cgroup/cgroup.c could be ifdef'd.

Beware that CGROUP_SUBSYS_COUNT is not known at preprocessing stage (you
could have a macro alternative though).

> I didn't try that myself, but this might be a way to guarantee that
> there cannot be any callers (it would cause a link error).
Such a guarantee would be nicer, I agree. I tried a bit but anandoned it
when I saw macros proliferate (which I found less readable than your
current variant). But YMMV.

Michal

--9pRQkLwCQMovNrXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBjOV4ACgkQia1+riC5
qSgZNQ/9FFBZs5QQqEUHmbWyF9O2R2bGF8WCBz56zh+F2OZf+/GK7z4OGhkKUlEa
1lPOUoibt4aZZhWD30RcfB3i3qJ8VqY3wqwnS6W9uN9+sU22sgsx/elCqiua3EnM
4tGDRcLBfSuktgPo1T0oNvGGbFnFJ0kUenLZ6mVkWlSTzx8kp/B8h4S5LkYmRIov
fVmHURht22FPiA8wwlUb9LAp8ONF+68t6BtMWNmZbqmJ17qHSnLyQQUiHIHytASt
xgaQCJU8/nrtv2xPfp66aCQLO12b6OxpjPoRxo1hj9IP5HZPukzNDat/VaWyh0iE
t9GO85K0PVqcuvJpymes0yRT6RvEwlqEna0T+qbh+qih4S3+xRm/Js5IV5m8KfIc
wWUve4llNT1jq6zzgn28FkXe9coH7ybpwBaWeAdwEM3Wl9GvXimKwIQqg+3ZDnm4
CbDVh6scYVu3kFYHVy6ld5+fG2GWEKvNL+9AVH+wsXUb6OXtyOtxD3FWyiVVYBkl
Q4N0KWETd67BNb2NklxTkeC4hYusuHeFvxa9Ki6K6zbdxDxVwdcTWpWFVkTDs45S
sEVkmsPU9pLu5vm5o9kBCmr6q1lW6yzudcxBvcvcHXGQnkfcmDCo+C3OEwKzKUeh
8+BhDV9zMpKBpJfuPiI8UNIt8sI7YeTpjdk14YjWYQTgZCHc7WU=
=iFNx
-----END PGP SIGNATURE-----

--9pRQkLwCQMovNrXD--

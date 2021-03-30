Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFDA34E35F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 10:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhC3Ilu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 04:41:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:55554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230224AbhC3Ilj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 04:41:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617093697; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jiLzz+FDg8IDgOr7Ru1IW7IRXYaqlH8yrJkDxBSOd+M=;
        b=SwyQOSqvaO5avOz2XsxkAeyYpWcAxuEpeTup5y2W/3hjoJIa9VL+ySLWFEDXOGMXYYzaNj
        yfuPCkvCrHUDqDn4OiHjX+VW5qEwgFf/bjJtmVzQs0eem+tKxgSvbAVrRlz0EIt6ankmR8
        9g4gU0a0vUOWreF+dSJDr1Ih1BW0A9I=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F0DDEB1C1;
        Tue, 30 Mar 2021 08:41:36 +0000 (UTC)
Date:   Tue, 30 Mar 2021 10:41:34 +0200
From:   Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Roman Gushchin <guro@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Odin Ugedal <odin@uged.al>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: Re: [PATCH 06/11] cgroup: fix -Wzero-length-bounds warnings
Message-ID: <YGLkPjSBdgpriC0E@blackbook>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-7-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Gbn4BprmVLVWv2rO"
Content-Disposition: inline
In-Reply-To: <20210322160253.4032422-7-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Gbn4BprmVLVWv2rO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2021 at 05:02:44PM +0100, Arnd Bergmann <arnd@kernel.org> w=
rote:
> I'm not sure what is expected to happen for such a configuration,
> presumably these functions are never calls in that case.
Yes, the functions you patched would only be called from subsystems or
there should be no way to obtain a struct cgroup_subsys reference
anyway (hence it's ok to always branch as if ss=3D=3DNULL).

I'd prefer a variant that wouldn't compile the affected codepaths when
there are no subsystems registered, however, I couldn't come up with a
way how to do it without some preprocessor ugliness.

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--Gbn4BprmVLVWv2rO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmBi5DcACgkQia1+riC5
qSjuqxAAkm/zoS+xvdcQUERzkcuVxIruGtTqOse/NCPQQR9aGuJl6iybyjQw7D+r
63+BYz7+BdP8zDg+NSTO354Yt0vsWFtCvuZBBabO91wCheLRPaZhHnGByJa0fXyM
SKC2VSvFHKKiFuCG7mG7/WfDQxTGSaUL2jiFXlA5HAV5dKfkia/Jpuf+KtIy5nBR
g8g4f44M2wW/TCoBzd5Elt5Cpx6fU2aKuJRCRCE04ts4CQy06/lLcc9H0N7bvgHj
0oxkHbAjXeEnylnni4pfpmJpInUT2kOZuCjSF/WPw2XeLs00AnBnNB3lDP9Pe2qo
ippcDc3AFqYMqewKnnxDWoTI3lyMTm8r0yzrDdwpb9Zv28bOCAYiwyoIsFV7+kdN
C7DnhiL6d+UgKIzCqRuTPXnluthvSmHGzeblqF1vOAaWOFif4CcRmUtsR7v3EyZN
5aiUTGqVtoKr/pcBNnRU1e2w7ulYpq5sbL/8f9HtnKsZ8MZlLdhdcDoSLjOkuohK
OlQgS6p+2otxwk3xft0CdFPPHAFb5/WM6IyKdewFGuY0fohxczWJCRI92x94cfe9
p0JSNLl19JjdM8loYpmBRcmlkoBH+MtkdZiR68b5yX5wcXypubmZPZ9o8ZzQqx1j
ZX1/nhuyDl6KHuGW7gJXx8FhCLd6nPyKYVu4wbay23oLzdL/1sk=
=nVTO
-----END PGP SIGNATURE-----

--Gbn4BprmVLVWv2rO--

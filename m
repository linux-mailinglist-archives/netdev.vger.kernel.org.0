Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0188C400344
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349997AbhICQ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 12:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbhICQ2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 12:28:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454F6C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 09:27:11 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id r13so4661708pff.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 09:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mb2E8YUZ1xqCxz/BY+yl0KwEP/4hHuRfKh9wuE8c/DQ=;
        b=CaH/wbuk9XlhstCL0q8MlIXbxm9h7yDPFbTpfgtXs65oc/HAnxUpC5/ScAvE+i5g2i
         Pr3/3baKRUBnKgMha3+rhU+qOtBraVUyxHfwiYVZZsRopPlhRibMYLgYqoy2KJ7BM7LS
         LrFCjYSgIUmCi9+2fFRa+gIdbaysNgp62nxeTRxpf+9/yZrF7ZG8mJHxNJStdHYQv/l5
         R8Qr8RaGSJwznDDqFGEY76S9QDxQNBFar3pYiWkyOWBev7xqtQx9UBGwGO8twXVfmY7X
         Ni3qmd6RspaK2ppQpgBstyc0NYah9EJZoK20I1JOy3RonjyBNby8BCIZlkBsWOeGcqfk
         sD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mb2E8YUZ1xqCxz/BY+yl0KwEP/4hHuRfKh9wuE8c/DQ=;
        b=gTRwExS1vzYRaJLi6umiKoOJk2wLI5jCRRl92mCnNgul3SMH1n07utPhtCj9TvPXP8
         V9ASp3aaE7o6G8w8HDVaetZuTfUocpZo+m3mevXb/ANxNrGLShodJ5RJd0bepWGCm/H9
         7k+y8Xt4JtssxNW3aGTFyKYzMNOt/GWVoA7a6lda4Wode/c/iQ3tCI9oaSZwM1Eh6liF
         7GqBpcEk6kTHu716MEll5bJGEpC3aImmLa4miOhCxbGyth0HZsJzmnghGIH4AZvMaDhg
         pgKvn5TEgowsfU4zEWH9ygmR11/QhrCmdTyDfA2GEIl0ECvM2DAPt+JqDDq7O+GlNvdK
         WPjQ==
X-Gm-Message-State: AOAM533PmBWCosYHR+B6FleNxt32n+kEYOFWQgFouJRXHzf9BiIeF/Yk
        QVfV1/Mlyb7YXN8EvNdasPyGxZhueeo9bQ==
X-Google-Smtp-Source: ABdhPJymVCwPgLqv/wNHfJ41ei0oH6t5oXSlFvW+dhVnB+UOYjb4Gw8PKC4J3OM3E6q8ryeceI+4Gg==
X-Received: by 2002:aa7:978d:0:b0:3f2:526b:f247 with SMTP id o13-20020aa7978d000000b003f2526bf247mr4008216pfp.68.1630686430701;
        Fri, 03 Sep 2021 09:27:10 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 17sm5566178pfp.28.2021.09.03.09.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 09:27:10 -0700 (PDT)
Date:   Fri, 3 Sep 2021 09:27:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Walker <camtarn@camtarn.org>
Cc:     netdev@vger.kernel.org
Subject: Re: TBF man page: peakrate must be greater than rate
Message-ID: <20210903092707.36a3376a@hermes.local>
In-Reply-To: <CAD6Lk=r8Yf8_09X31bcLECEKmy3gS5rKDKt+pVHfyNk2_NMHTA@mail.gmail.com>
References: <CAD6Lk=r=mCMPb3YyKHMKtLENteRPsGw2L4Axy5kdVvnd2j29Zw@mail.gmail.com>
        <CAD6Lk=r8Yf8_09X31bcLECEKmy3gS5rKDKt+pVHfyNk2_NMHTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Sep 2021 16:48:45 +0100
Andy Walker <camtarn@camtarn.org> wrote:

> Hi,
>=20
> I was struggling with the following command line:
> tc qdisc add dev eth1 parent 1:1 handle 10: tbf rate 10.0kbit maxburst
> 10kb latency 50ms peakrate 10kbit mtu 1600
> RTNETLINK answers: Invalid argument
>=20
> When I altered peakrate to be 10.1kbit, tbf accepted its parameters.
>=20
> Looking in dmesg, I found the following:
>=20
> sch_tbf: peakrate 1250 is lower than or equals to rate 1250
>=20
> The man page does not specify that peakrate needs to be greater than
> rate. This would probably be a useful addition, as it's easy to assume
> that the two can/should be set to the same value for precise rate
> limiting.
>=20
> Thanks,
> Andy

Try this:

=46rom 20f4d28336fd7b1de2df1a7478319f44b3e258e2 Mon Sep 17 00:00:00 2001
From: Stephen Hemminger <sthemmin@microsoft.com>
Date: Fri, 3 Sep 2021 09:24:52 -0700
Subject: [PATCH] net: sched: tbf replace log message with extack

The Token Bucket Filter qdisc should be using extack
to report errors, rather than forcing user to look in
dmesg.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 net/sched/sch_tbf.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 78e79029dc63..33cd712caea5 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -387,8 +387,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr =
*opt,
 			prate64 =3D nla_get_u64(tb[TCA_TBF_PRATE64]);
 		psched_ratecfg_precompute(&peak, &qopt->peakrate, prate64);
 		if (peak.rate_bytes_ps <=3D rate.rate_bytes_ps) {
-			pr_warn_ratelimited("sch_tbf: peakrate %llu is lower than or equals to =
rate %llu !\n",
-					peak.rate_bytes_ps, rate.rate_bytes_ps);
+			NL_SET_ERR_MSG(extack, "peakrate is lower than or equals to rate");
 			err =3D -EINVAL;
 			goto done;
 		}
@@ -405,9 +404,7 @@ static int tbf_change(struct Qdisc *sch, struct nlattr =
*opt,
 	}
=20
 	if (max_size < psched_mtu(qdisc_dev(sch)))
-		pr_warn_ratelimited("sch_tbf: burst %llu is lower than device %s mtu (%u=
) !\n",
-				    max_size, qdisc_dev(sch)->name,
-				    psched_mtu(qdisc_dev(sch)));
+		NL_SET_ERR_MSG(extack, "burst is lower than device mtu");
=20
 	if (!max_size) {
 		err =3D -EINVAL;
--=20
2.30.2


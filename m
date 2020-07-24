Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E22A22CB00
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgGXQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbgGXQYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:24:40 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658C0C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:24:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 184so8781911wmb.0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=yzAeBtByUuoYileXgXR2/rpqI4Yxhivgszl/ZqsYPIk=;
        b=hAZjcIwY8s0RwbhSm9dVRfihTjsEDZrJrSZVdqpp+2huj+hlJdIe+vJCYZ/DmOruoe
         NNSqFsBcWUGO8YzzCLZ1rUyjQcENs6YBcSQQ5mY/oqhfK3fU6c7bE98hYBcInzpROn/3
         CRwOHjilzKfxszuU6XEWDz3ajMKPM76VW6s0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=yzAeBtByUuoYileXgXR2/rpqI4Yxhivgszl/ZqsYPIk=;
        b=A9LXooykRYjOECQj686iXVYNgLDjpmPHLXoKCMnl40Q76YUNNkizsWSXvMLnZ4u+Uq
         VgWbMwB2fOmWcxcjj6l0uaG1TL0ZKzZCwS07rUi1hcoGyNHrCJtyuC6sLy09nbXlZKz/
         vS1vYYXu+tUHBFClecSC2CQG2WU7r+7dyD6zWCTv5xLbrPyvMsaqVg84hz2P4ttPfNzW
         uiEo7XXZHQLhI+6Cw+yZ2b3pNUUw9tcnvOfzOScskJLPqMG+Av6n2XTy6aQcMmHFmDGr
         C0pRNBeblshlO4hKdQYH7JnZe0LPp3dH3fGIBCEd6GBa0kSW43nlICfl41Bh6bd+tT83
         rvmQ==
X-Gm-Message-State: AOAM532PXF+8a6h9obbcXKtfhwIO6j4zEC2agRojeOiAyReeHCAWXwjs
        y8HzMSkxOm+z6HSQptjfwVlP5Q==
X-Google-Smtp-Source: ABdhPJzIGR2dYNIy9M6P3+AnS/f9XerWJGsisodWVmipJNWqCpaloFOwGc6YXnXIeiR5xTlHe2KW8A==
X-Received: by 2002:a05:600c:2050:: with SMTP id p16mr9054935wmg.44.1595607878313;
        Fri, 24 Jul 2020 09:24:38 -0700 (PDT)
Received: from localhost ([149.62.202.25])
        by smtp.gmail.com with ESMTPSA id s205sm1849790wme.7.2020.07.24.09.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2020 09:24:37 -0700 (PDT)
Date:   Fri, 24 Jul 2020 19:24:35 +0300
In-Reply-To: <20200724091517.7f5c2c9c@hermes.lan>
References: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com> <20200724091517.7f5c2c9c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFT iproute2] iplink_bridge: scale all time values by USER_HZ
To:     Stephen Hemminger <stephen@networkplumber.org>,
        George Shuklin <amarao@servers.com>
CC:     netdev@vger.kernel.org, jiri@resnulli.us, amarao@servers.com
From:   nikolay@cumulusnetworks.com
Message-ID: <F074B3B5-1B07-490F-87B8-887E2EFB32F3@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24 July 2020 19:15:17 EEST, Stephen Hemminger <stephen@networkplumber=2E=
org> wrote:
>
>The bridge portion of ip command was not scaling so the
>values were off=2E
>
>The netlink API's for setting and reading timers all conform
>to the kernel standard of scaling the values by USER_HZ (100)=2E
>
>Fixes: 28d84b429e4e ("add bridge master device support")
>Fixes: 7f3d55922645 ("iplink: bridge: add support for
>IFLA_BR_MCAST_MEMBERSHIP_INTVL")
>Fixes: 10082a253fb2 ("iplink: bridge: add support for
>IFLA_BR_MCAST_LAST_MEMBER_INTVL")
>Fixes: 1f2244b851dd ("iplink: bridge: add support for
>IFLA_BR_MCAST_QUERIER_INTVL")
>Signed-off-by: Stephen Hemminger <stephen@networkplumber=2Eorg>
>---

While I agree this should have been done from the start, it's too late to =
change=2E=20
We'll break everyone using these commands=2E=20
We have been discussing to add _ms version of all these which do the prope=
r scaling=2E I'd prefer that, it's least disruptive
to users=2E=20

Every user of the old commands scales the values by now=2E=20


>
>Compile tested only=2E
>
>
> ip/iplink_bridge=2Ec | 45 ++++++++++++++++++++++++++-------------------
> 1 file changed, 26 insertions(+), 19 deletions(-)
>
>diff --git a/ip/iplink_bridge=2Ec b/ip/iplink_bridge=2Ec
>index 3e81aa059cb3=2E=2E48495a08c484 100644
>--- a/ip/iplink_bridge=2Ec
>+++ b/ip/iplink_bridge=2Ec
>@@ -24,6 +24,7 @@
>=20
> static unsigned int xstats_print_attr;
> static int filter_index;
>+static unsigned int hz;
>=20
> static void print_explain(FILE *f)
> {
>@@ -85,19 +86,22 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> {
> 	__u32 val;
>=20
>+	if (!hz)
>+		hz =3D get_user_hz();
>+
> 	while (argc > 0) {
> 		if (matches(*argv, "forward_delay") =3D=3D 0) {
> 			NEXT_ARG();
> 			if (get_u32(&val, *argv, 0))
> 				invarg("invalid forward_delay", *argv);
>=20
>-			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val);
>+			addattr32(n, 1024, IFLA_BR_FORWARD_DELAY, val * hz);
> 		} else if (matches(*argv, "hello_time") =3D=3D 0) {
> 			NEXT_ARG();
> 			if (get_u32(&val, *argv, 0))
> 				invarg("invalid hello_time", *argv);
>=20
>-			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val);
>+			addattr32(n, 1024, IFLA_BR_HELLO_TIME, val * hz);
> 		} else if (matches(*argv, "max_age") =3D=3D 0) {
> 			NEXT_ARG();
> 			if (get_u32(&val, *argv, 0))
>@@ -109,7 +113,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 			if (get_u32(&val, *argv, 0))
> 				invarg("invalid ageing_time", *argv);
>=20
>-			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val);
>+			addattr32(n, 1024, IFLA_BR_AGEING_TIME, val * hz);
> 		} else if (matches(*argv, "stp_state") =3D=3D 0) {
> 			NEXT_ARG();
> 			if (get_u32(&val, *argv, 0))
>@@ -266,7 +270,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_LAST_MEMBER_INTVL,
>-				  mcast_last_member_intvl);
>+				  mcast_last_member_intvl * hz);
> 		} else if (matches(*argv, "mcast_membership_interval") =3D=3D 0) {
> 			__u64 mcast_membership_intvl;
>=20
>@@ -276,7 +280,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_MEMBERSHIP_INTVL,
>-				  mcast_membership_intvl);
>+				  mcast_membership_intvl * hz);
> 		} else if (matches(*argv, "mcast_querier_interval") =3D=3D 0) {
> 			__u64 mcast_querier_intvl;
>=20
>@@ -286,7 +290,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_QUERIER_INTVL,
>-				  mcast_querier_intvl);
>+				  mcast_querier_intvl * hz);
> 		} else if (matches(*argv, "mcast_query_interval") =3D=3D 0) {
> 			__u64 mcast_query_intvl;
>=20
>@@ -296,7 +300,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_INTVL,
>-				  mcast_query_intvl);
>+				  mcast_query_intvl * hz);
> 		} else if (!matches(*argv, "mcast_query_response_interval")) {
> 			__u64 mcast_query_resp_intvl;
>=20
>@@ -306,7 +310,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_QUERY_RESPONSE_INTVL,
>-				  mcast_query_resp_intvl);
>+				  mcast_query_resp_intvl * hz);
> 		} else if (!matches(*argv, "mcast_startup_query_interval")) {
> 			__u64 mcast_startup_query_intvl;
>=20
>@@ -316,7 +320,7 @@ static int bridge_parse_opt(struct link_util *lu,
>int argc, char **argv,
> 				       *argv);
>=20
> 			addattr64(n, 1024, IFLA_BR_MCAST_STARTUP_QUERY_INTVL,
>-				  mcast_startup_query_intvl);
>+				  mcast_startup_query_intvl * hz);
> 		} else if (matches(*argv, "mcast_stats_enabled") =3D=3D 0) {
> 			__u8 mcast_stats_enabled;
>=20
>@@ -407,29 +411,32 @@ static void bridge_print_opt(struct link_util
>*lu, FILE *f, struct rtattr *tb[])
> 	if (!tb)
> 		return;
>=20
>+	if (!hz)
>+		hz =3D get_user_hz();
>+
> 	if (tb[IFLA_BR_FORWARD_DELAY])
> 		print_uint(PRINT_ANY,
> 			   "forward_delay",
> 			   "forward_delay %u ",
>-			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]));
>+			   rta_getattr_u32(tb[IFLA_BR_FORWARD_DELAY]) / hz);
>=20
> 	if (tb[IFLA_BR_HELLO_TIME])
> 		print_uint(PRINT_ANY,
> 			   "hello_time",
> 			   "hello_time %u ",
>-			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]));
>+			   rta_getattr_u32(tb[IFLA_BR_HELLO_TIME]) / hz);
>=20
> 	if (tb[IFLA_BR_MAX_AGE])
> 		print_uint(PRINT_ANY,
> 			   "max_age",
> 			   "max_age %u ",
>-			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]));
>+			   rta_getattr_u32(tb[IFLA_BR_MAX_AGE]) / hz);
>=20
> 	if (tb[IFLA_BR_AGEING_TIME])
> 		print_uint(PRINT_ANY,
> 			   "ageing_time",
> 			   "ageing_time %u ",
>-			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]));
>+			   rta_getattr_u32(tb[IFLA_BR_AGEING_TIME]) / hz);
>=20
> 	if (tb[IFLA_BR_STP_STATE])
> 		print_uint(PRINT_ANY,
>@@ -605,37 +612,37 @@ static void bridge_print_opt(struct link_util
>*lu, FILE *f, struct rtattr *tb[])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_last_member_intvl",
> 			     "mcast_last_member_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_LAST_MEMBER_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_membership_intvl",
> 			     "mcast_membership_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_MEMBERSHIP_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_QUERIER_INTVL])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_querier_intvl",
> 			     "mcast_querier_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERIER_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_QUERY_INTVL])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_query_intvl",
> 			     "mcast_query_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_query_response_intvl",
> 			     "mcast_query_response_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_QUERY_RESPONSE_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL])
> 		print_lluint(PRINT_ANY,
> 			     "mcast_startup_query_intvl",
> 			     "mcast_startup_query_interval %llu ",
>-			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]));
>+			     rta_getattr_u64(tb[IFLA_BR_MCAST_STARTUP_QUERY_INTVL]) / hz);
>=20
> 	if (tb[IFLA_BR_MCAST_STATS_ENABLED])
> 		print_uint(PRINT_ANY,


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E

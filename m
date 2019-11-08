Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA57F51D5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfKHRAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:00:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21305 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725970AbfKHRAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573232419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=taLOTMX4lKrBuXTh/9MYkR9MDmVeS8SDpxOC7XPtg8s=;
        b=EHm2IydnZrTyWe1BtzhCXFZjZy1e6QcWcNLwnQLBKN+CNPY9gWweX2bjUOeBLWNluWCwZD
        iFMK5zjgVAXWMvvoBpZ/akdgZyFK3sFPVvfu7Yi1N4op6yG0Kh7WtDNI9KHSWoP1pbf2l3
        dNWUJj4pydbQmCgnhx+dznmb0HhhsO8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-Bg7n00rtOqaSL8lr1z6jIQ-1; Fri, 08 Nov 2019 12:00:16 -0500
Received: by mail-wr1-f69.google.com with SMTP id b4so3577941wrn.8
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:00:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0uOwZ6745Q6MF7ULdmo9l1xTQqZRG3bO3veksHRzpVw=;
        b=hXT3JXJ+ZrJD4V5QTt78w/KRy0vHDEzjgZjT0spE7aQFFz8jLaPlRqyqWAGnSyeVad
         B9mh/7gzvufdGh91T7sXv0+MKNJSm4gABBoH+K+N3iAeqXilpjWjn9mJU/pmO+mrOACj
         17uQpC+rbHV87dEOhQpCNQ67u71ZUQSaJe/R0d9N4kv4RO+j8f01YwDa3IxCLGX/grM3
         heCiLtWLOwOydkFCQ1wimQdGgRP2ys1u+c3JEZsfNVn5PEEOMteeuGxQa5ug9+dgNHZy
         KCECtlJDP75EbZ90MnKwDzCntokccqTfjM/yrpJHbXww4La2JOEkekfRcyUXcgnIZrY1
         8nSQ==
X-Gm-Message-State: APjAAAVWKt7R2BwsJW962mRsFPR7LLHrXX1aiJ35wnyZu242y6i7REHQ
        zpF5FvwTbcsEyUuwPj9Ylw97sgARRe5ENBZw8HRmVQLfv/FdcxJM3/K06Dgf99zV37yLgISAwdZ
        bDQbnNDNbaagGXvti
X-Received: by 2002:adf:ecca:: with SMTP id s10mr283484wro.22.1573232414645;
        Fri, 08 Nov 2019 09:00:14 -0800 (PST)
X-Google-Smtp-Source: APXvYqyZTrLFYKO28k+oYqUu2CMRxFzs/Q3Ve41cIReUKkTjofb+u67ATg0TR8uIuhVoNNuYbG0CPA==
X-Received: by 2002:adf:ecca:: with SMTP id s10mr283468wro.22.1573232414483;
        Fri, 08 Nov 2019 09:00:14 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r15sm6289718wrc.5.2019.11.08.09.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 09:00:13 -0800 (PST)
Date:   Fri, 8 Nov 2019 18:00:12 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next 1/5] ipnetns: treat NETNSA_NSID and
 NETNSA_CURRENT_NSID as signed
Message-ID: <a64fa7435eddbec74360d1f55dbe04203989d1d2.1573231189.git.gnault@redhat.com>
References: <cover.1573231189.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1573231189.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: Bg7n00rtOqaSL8lr1z6jIQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These attributes are signed (with -1 meaning NETNSA_NSID_NOT_ASSIGNED).
So let's use rta_getattr_s32() and print_int() instead of their
unsigned counterpart to avoid confusion.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/ipnetns.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 20110ef0..0a7912df 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -137,7 +137,7 @@ int get_netnsid_from_name(const char *name)
 =09parse_rtattr(tb, NETNSA_MAX, NETNS_RTA(rthdr), len);
=20
 =09if (tb[NETNSA_NSID]) {
-=09=09ret =3D rta_getattr_u32(tb[NETNSA_NSID]);
+=09=09ret =3D rta_getattr_s32(tb[NETNSA_NSID]);
 =09}
=20
 out:
@@ -317,20 +317,20 @@ int print_nsid(struct nlmsghdr *n, void *arg)
 =09if (n->nlmsg_type =3D=3D RTM_DELNSID)
 =09=09print_bool(PRINT_ANY, "deleted", "Deleted ", true);
=20
-=09nsid =3D rta_getattr_u32(tb[NETNSA_NSID]);
+=09nsid =3D rta_getattr_s32(tb[NETNSA_NSID]);
 =09if (nsid < 0)
 =09=09print_string(PRINT_ANY, "nsid", "nsid %s ", "not-assigned");
 =09else
-=09=09print_uint(PRINT_ANY, "nsid", "nsid %u ", nsid);
+=09=09print_int(PRINT_ANY, "nsid", "nsid %d ", nsid);
=20
 =09if (tb[NETNSA_CURRENT_NSID]) {
-=09=09current =3D rta_getattr_u32(tb[NETNSA_CURRENT_NSID]);
+=09=09current =3D rta_getattr_s32(tb[NETNSA_CURRENT_NSID]);
 =09=09if (current < 0)
 =09=09=09print_string(PRINT_ANY, "current-nsid",
 =09=09=09=09     "current-nsid %s ", "not-assigned");
 =09=09else
-=09=09=09print_uint(PRINT_ANY, "current-nsid",
-=09=09=09=09   "current-nsid %u ", current);
+=09=09=09print_int(PRINT_ANY, "current-nsid",
+=09=09=09=09  "current-nsid %d ", current);
 =09}
=20
 =09c =3D netns_map_get_by_nsid(tb[NETNSA_CURRENT_NSID] ? current : nsid);
@@ -491,8 +491,7 @@ static int netns_list(int argc, char **argv)
 =09=09if (ipnetns_have_nsid()) {
 =09=09=09id =3D get_netnsid_from_name(entry->d_name);
 =09=09=09if (id >=3D 0)
-=09=09=09=09print_uint(PRINT_ANY, "id",
-=09=09=09=09=09   " (id: %d)", id);
+=09=09=09=09print_int(PRINT_ANY, "id", " (id: %d)", id);
 =09=09}
 =09=09print_string(PRINT_FP, NULL, "\n", NULL);
 =09=09close_json_object();
--=20
2.21.0


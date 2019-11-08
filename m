Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78441F51D7
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbfKHRAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:00:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57157 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726819AbfKHRAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:00:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573232423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uAOyWdl0tprN1XDvA5+G3mDu6TjMER5zhMYHQ3Fc/ZI=;
        b=hLnfmjo8fFSFP+OesW2sMG/QoIXJM0vhfUuNcGhxlYqfPd+JCdbULXihl/+s2aKCSmCj3c
        382Achcs3kPh5NGFafteuPRIWnUBrrYy7/24zLKvYD02Y50a6xW6+EJd3S6Q05tRNGzDGZ
        65oTLFUJDjlmencJfhzRM0zhmN4ABjM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-kbyBATdbNqmjgYKrKpIY6A-1; Fri, 08 Nov 2019 12:00:21 -0500
Received: by mail-wr1-f71.google.com with SMTP id 92so3601634wro.14
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:00:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1NUREWKLYTL9WLs9VjbiyFEITtfBQtqbrTsdz42AJVM=;
        b=F0qffdA8AP9Hp2YJnznAg9JE8Q5gvVAHFz8RyW8KeFlSfdNax0lRoIlIrhYus43fmx
         HZlFR8mmBVby/UeUlogxs6icwYTyZLVeqE32VgwpbHAjCgdKLROpKFxUkcP+bUd+0lop
         o+sQW5xHW0W++HSBBla6waTQ/2qLPmGJWvuy9OZSo+ktGOFfKba1QVpmKtZoAY5R0zC/
         PpUGNAEc8EuxqfX3l0DFQDFXq1xs3803YMldwdP/DuHXQjgFphQFxByGs0y/2uK9I1bB
         BxvlXdYUy9yECjdshydBXO4FSmrB7Jjtx0sRGeEYB6RiJZ0s5cRfJ0oKcOPQ+0SxtZGF
         E9Xg==
X-Gm-Message-State: APjAAAXstNV5qYINW5CAK5+HQ+52Vx5NzIt2WBsv7UlE3z4AtyW8isyw
        21tkW/IRhZbivpbU9t/HAH3jD4Zk9DTsOuebcxj6K9VNyuCCxBiP/5I92vpuOCi94AnGXEV6OKh
        RYk/d9mgoKkdcBFre
X-Received: by 2002:a1c:7708:: with SMTP id t8mr9129757wmi.29.1573232420691;
        Fri, 08 Nov 2019 09:00:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyRQ1mEe2sXI7OBxgikZ6yTMtscbmJ09ViIxC43jxDhpHNg133cgS/cb8Q5qNmswBsqarOMA==
X-Received: by 2002:a1c:7708:: with SMTP id t8mr9129748wmi.29.1573232420528;
        Fri, 08 Nov 2019 09:00:20 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n23sm5895606wmc.18.2019.11.08.09.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 09:00:19 -0800 (PST)
Date:   Fri, 8 Nov 2019 18:00:18 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH iproute2-next 4/5] ipnetns: don't print unassigned nsid in
 json export
Message-ID: <d01111c517a07dbb07f1280c0a7055218b1fcf43.1573231189.git.gnault@redhat.com>
References: <cover.1573231189.git.gnault@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1573231189.git.gnault@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: kbyBATdbNqmjgYKrKpIY6A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't output the nsid and current-nsid json keys if they're not set.
Otherwise a parser would have to special case the "not-assigned"
string.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 ip/ipnetns.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 77531d6c..4eb4a09a 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -329,15 +329,15 @@ int print_nsid(struct nlmsghdr *n, void *arg)
=20
 =09nsid =3D rta_getattr_s32(tb[NETNSA_NSID]);
 =09if (nsid < 0)
-=09=09print_string(PRINT_ANY, "nsid", "nsid %s ", "not-assigned");
+=09=09print_string(PRINT_FP, NULL, "nsid unassigned ", NULL);
 =09else
 =09=09print_int(PRINT_ANY, "nsid", "nsid %d ", nsid);
=20
 =09if (tb[NETNSA_CURRENT_NSID]) {
 =09=09current =3D rta_getattr_s32(tb[NETNSA_CURRENT_NSID]);
 =09=09if (current < 0)
-=09=09=09print_string(PRINT_ANY, "current-nsid",
-=09=09=09=09     "current-nsid %s ", "not-assigned");
+=09=09=09print_string(PRINT_FP, NULL,
+=09=09=09=09     "current-nsid unassigned ", NULL);
 =09=09else
 =09=09=09print_int(PRINT_ANY, "current-nsid",
 =09=09=09=09  "current-nsid %d ", current);
--=20
2.21.0


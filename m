Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1A0141939
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 20:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgARTks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 14:40:48 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50241 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726806AbgARTks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 14:40:48 -0500
Received: by mail-pj1-f66.google.com with SMTP id r67so4759380pjb.0;
        Sat, 18 Jan 2020 11:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4H4HbfW7yJ3n9TBlIjK7pz+6ROcxTyetxM4lTNEqrxg=;
        b=bUmc39D1cy+6nCuC82fWL20b8Ly9Vs/w/jHjtx9Rqs9iDfZbNFy6MYv3+tVha1Bdg9
         s4ME8QHl0D4NFF4xg7KPHDodIzlazyqQ2PLX5BiWuImQ5NGsJseRW/1o3n6QAAOmWUQ2
         coBYactcZO+Lw0QWZso/Jk6vgJ2wUZuYPQL0JidaRIe7HwAKF5h1L9lL3OTiM0SQoP+V
         9PgCFVw234rph8epCB/diAGAKjZ5wYeLvdEB+Ss8Th/B/qQxXQcQyAcqgo/F7c/oHNnb
         /5RdRBS9iqocDNZgzCxmuv0bZqwopAyoADtwukWOb34KnjqGSzRmbRbksVI52bGBCyob
         s1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4H4HbfW7yJ3n9TBlIjK7pz+6ROcxTyetxM4lTNEqrxg=;
        b=jbJqEZuCgQdGzLLuPGMWI2kvNTk50WzkJ2BF7yNTqt70eFxODNY2KuGtTv/HbZdGqH
         GKg871MHlancq4ZXp9CnVemWkTmU35LXlZywbHbL7soMiaDEtfbGmwWiGWygTfg3P6z9
         EPsYsYLXMdTuoR1NlSFEOaFxzT88kBjNBgnWWR12qg7uJu8MqJr41DwHxoANP3KeZUPG
         k+D2/t4/x65bP3KaN7G7JNJNRdPy3RRuUKnVLL1y3TSZCsUNGRQQ0j/WnSsakkXlMp6g
         x3SNVf+iN8/F6j5N9jle+aOiIJo82W1BBeRazMKioFmjNUw1d2vVsGvjdE6T9ThvML3J
         vmxg==
X-Gm-Message-State: APjAAAXRj6bSoLbiEtq4atL06KK/o03TJlg0ZKaA1/TPDZZcq/NXJ2LK
        g1hkrtDwUen/GhL/0TvOFcswJG9Zf0U=
X-Google-Smtp-Source: APXvYqytTXFq8b5SIScqT5hewEh+kx9A5pun6Qb7GL2K8LoNayQjoc7vpIzGkc43tAODIzj7egwwiA==
X-Received: by 2002:a17:902:122:: with SMTP id 31mr6226016plb.183.1579376447557;
        Sat, 18 Jan 2020 11:40:47 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id k3sm32864154pgc.3.2020.01.18.11.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 11:40:46 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [Patch nf] netfilter: nft_osf: NFTA_OSF_DREG must not be null
Date:   Sat, 18 Jan 2020 11:40:15 -0800
Message-Id: <20200118194015.14988-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Reported-by: syzbot+cf23983d697c26c34f60@syzkaller.appspotmail.com
Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/nft_osf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index f54d6ae15bb1..b42247aa48a9 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -61,6 +61,9 @@ static int nft_osf_init(const struct nft_ctx *ctx,
 	int err;
 	u8 ttl;
 
+	if (!tb[NFTA_OSF_DREG])
+		return -EINVAL;
+
 	if (tb[NFTA_OSF_TTL]) {
 		ttl = nla_get_u8(tb[NFTA_OSF_TTL]);
 		if (ttl > 2)
-- 
2.21.1


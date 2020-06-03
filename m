Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275E1ED67A
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 21:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgFCTEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 15:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgFCTEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 15:04:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC796C08C5C2
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 12:04:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id gl26so3324515ejb.11
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 12:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1ob8DHHd/z/xVN5INJTzit4Jsbs2bUN8orwDkBUzED4=;
        b=VTX1tiITS/4e2XYWvoHClDpZLAHWVU2LJ514haRTCPcl4bz9/iJwO6QacpVPDurZfs
         A/2dpDfEYsg41SqIevLzEJVUcQyr+r5qiADVsFtXYquX5KW/xvNR8nu/CWMeUf7wzU3F
         x5PskuQRHwinsAuL5Qkk79P0VECGZF7++0vL8sdFF+vgpMw8pvkux0Nq0+JrOmnO8OP3
         aXXrFef+GT7u3ZE/TDY6H2Fu1Zhl2y8E8JyY7Vnw23noyzOAYVO5Ha5zZ0gCF5sY86lj
         vhgyWTg4RSZBBKATq6sQhQPwGjvIKfmk8yRRcrP7MohMA6EOIB7JnZOOj+6KgPdiEH7Z
         rSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1ob8DHHd/z/xVN5INJTzit4Jsbs2bUN8orwDkBUzED4=;
        b=s1+LpwLX+Ww6OM/7r48ROZ5SJN/HdR7SxtMAvG/uIjydSXp5G8Hg8wu22eKGALM1GW
         ohSQj4KTdILZzLbE/Es5gZO4EANFK2jZ8bCxMVKsB/MdRTsk49n2ti48k/qcrnEy1O0m
         eDykM8UjDf3Shg7usomNOSWd3XPJrM1e+lnAc0g7ZurpdeQ7zdxGP5iiN1T8Q90unzqU
         SLnBjnNXtcQN7zjA3QdCav3FUb83Ze3ktnJK3hvAR1L5c0EYeWkj0lH3xJsiIUcqdVdQ
         wBTY30kZK+5uztDJjN0pDPnJrXuAIxHUU1wIqQRaUwrMjq314VsmUK7kPIwCUf1ziumq
         gdng==
X-Gm-Message-State: AOAM532jyhvLCGCQSRzqSfRl2Of/DN0z7LwfsGvaBo1RFtXeufivT1aJ
        wMouhomXn9c3hPrq9Tx9o91bIg==
X-Google-Smtp-Source: ABdhPJw9+z6x6Ov/IIGHZ2GLEUbp2IAgUZ5fQ4jkLx95eaBELc9tb8OGzht6TOF4bHWUO0XoZVNxaQ==
X-Received: by 2002:a17:906:1cd3:: with SMTP id i19mr631125ejh.321.1591211077010;
        Wed, 03 Jun 2020 12:04:37 -0700 (PDT)
Received: from tsr-vdi-mbaerts.nix.tessares.net (static.23.216.130.94.clients.your-server.de. [94.130.216.23])
        by smtp.gmail.com with ESMTPSA id w8sm229561eds.41.2020.06.03.12.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 12:04:35 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     alexei.starovoitov@gmail.com
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, fejes@inf.elte.hu,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        matthieu.baerts@tessares.net, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com
Subject: [PATCH bpf v2] bpf: fix unused-var without NETDEVICES
Date:   Wed,  3 Jun 2020 21:03:47 +0200
Message-Id: <20200603190347.2310320-1-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAADnVQ+k7+fQmuNQL=GLLaGUvd5+zZN6GViy-oP7Sfq7aQVG1Q@mail.gmail.com>
References: <CAADnVQ+k7+fQmuNQL=GLLaGUvd5+zZN6GViy-oP7Sfq7aQVG1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent commit added new variables only used if CONFIG_NETDEVICES is
set. A simple fix would be to only declare these variables if the same
condition is valid but Alexei suggested an even simpler solution:

    since CONFIG_NETDEVICES doesn't change anything in .h I think the
    best is to remove #ifdef CONFIG_NETDEVICES from net/core/filter.c
    and rely on sock_bindtoindex() returning ENOPROTOOPT in the extreme
    case of oddly configured kernels.

Fixes: 70c58997c1e8 ("bpf: Allow SO_BINDTODEVICE opt in bpf_setsockopt")
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---

Notes:
    This fix currently applies on net-next and bpf-next only. Except that
    net-next is now closed and -net will get commits from net-next after
    Linus' pull.

    v2: remove #ifdef CONFIG_NETDEVICES (Alexei)

 net/core/filter.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d01a244b5087..90d2eb77002f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4340,8 +4340,6 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			}
 			break;
 		case SO_BINDTODEVICE:
-			ret = -ENOPROTOOPT;
-#ifdef CONFIG_NETDEVICES
 			optlen = min_t(long, optlen, IFNAMSIZ - 1);
 			strncpy(devname, optval, optlen);
 			devname[optlen] = 0;
@@ -4360,7 +4358,6 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				dev_put(dev);
 			}
 			ret = sock_bindtoindex(sk, ifindex, false);
-#endif
 			break;
 		default:
 			ret = -EINVAL;
-- 
2.25.1


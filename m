Return-Path: <netdev+bounces-11769-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B47D7345D6
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 12:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5ED63280C6B
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB7415B0;
	Sun, 18 Jun 2023 10:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C331102
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 10:31:37 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5A3E5D
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 03:31:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bb2fae9b286so2740358276.3
        for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 03:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687084295; x=1689676295;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3xCmloStcox4DGiyVEmKPPYz/GhmfZcPboS7TQp61s=;
        b=eE9NtI0H7khNMB7mtKWHQqK9MrBCftm6JTZkkzPggsH0UPbQbsBTM89Clf/lxW3Bos
         uUdiDqvdwnTr46/toTNjPzxR7wWjiXgqRg2Ol/PePfxZkCk/2x/yCZcgNWZW0egTMqK0
         QrEpwldBfZQEciuvCb1IcdWQCd4wH0JD38K0dR5h09JAGbtICl9c3BiCXStGK2T/l9cY
         EGIRB8SZvMB3hHSteeo4uB0EYjwT+bu6WJ6cpcqGDNauqx7L0vmwbpi8cuspmnemG6Rt
         mupQKORL17BCQcfJmOkbRnEUFCbd614pY0HcIxQ0UmyDQZtT6WK7p1P65UKoQg+eQtz9
         b9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687084295; x=1689676295;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N3xCmloStcox4DGiyVEmKPPYz/GhmfZcPboS7TQp61s=;
        b=HKbKZz2AT8BeOzL1F41mWAjq56y99jTdl5KDZxOgePYQuior/56J5eb5BTC1Go35BW
         t0AftEOlHx+i+mDMke8OlFjXG1xZ6gfrsfiReKdWfyxawEjLt81C3xflzDiCGA1HWaMY
         uy/0HBpkMhtZoTjItebO2MfasZq6zoUB54gtJ9KgPhMYIJzZ1UvmmPq3bwy05k/X8Dcd
         0WZ8YoCtXfxkMSqJz0iZGTIuR/0j7Dwy3BXZCuVYja5zCMEWoX/SpqksrH32n9B4HE7f
         IivheOP556fJJ+YXhMJW2TYLwRzfD24TVha8Y/SZ3eMXGrEl4+52Bj/9hl8mpjrBZ6Vf
         Q47g==
X-Gm-Message-State: AC+VfDxl1ahQ1xMhf19SNRizw5NjUWTFZUwfw3CMAb57df3hcG6EjoZ7
	gXMMcCQ3Gz1sygOFfoEnOR1gTr8G
X-Google-Smtp-Source: ACHHUZ7nfGRJPoFfx5JtBgqwKDnx/JCTT3kAzp2nWxKhToLtlNazCP9nCYXd7RirbMm9exWHsP0QgDKN
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:7111:f876:ba0d:5495])
 (user=maze job=sendgmr) by 2002:a25:d3c8:0:b0:bac:adb8:a605 with SMTP id
 e191-20020a25d3c8000000b00bacadb8a605mr590813ybf.2.1687084295433; Sun, 18 Jun
 2023 03:31:35 -0700 (PDT)
Date: Sun, 18 Jun 2023 03:31:30 -0700
In-Reply-To: <7915b31f96108bee8dd92a229df6823ebe9c55b0.camel@redhat.com>
Message-Id: <20230618103130.51628-1-maze@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <7915b31f96108bee8dd92a229df6823ebe9c55b0.camel@redhat.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Subject: [PATCH net v2] revert "net: align SO_RCVMARK required privileges with SO_MARK"
From: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To: "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>, 
	"=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>, Larysa Zaremba <larysa.zaremba@intel.com>, 
	Simon Horman <simon.horman@corigine.com>, Paolo Abeni <pabeni@redhat.com>, 
	Eyal Birger <eyal.birger@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Patrick Rohr <prohr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This reverts commit 1f86123b9749 ("net: align SO_RCVMARK required
privileges with SO_MARK") because the reasoning in the commit message
is not really correct:
  SO_RCVMARK is used for 'reading' incoming skb mark (via cmsg), as such
  it is more equivalent to 'getsockopt(SO_MARK)' which has no priv check
  and retrieves the socket mark, rather than 'setsockopt(SO_MARK) which
  sets the socket mark and does require privs.

  Additionally incoming skb->mark may already be visible if
  sysctl_fwmark_reflect and/or sysctl_tcp_fwmark_accept are enabled.

  Furthermore, it is easier to block the getsockopt via bpf
  (either cgroup setsockopt hook, or via syscall filters)
  then to unblock it if it requires CAP_NET_RAW/ADMIN.

On Android the socket mark is (among other things) used to store
the network identifier a socket is bound to.  Setting it is privileged,
but retrieving it is not.  We'd like unprivileged userspace to be able
to read the network id of incoming packets (where mark is set via
iptables [to be moved to bpf])...

An alternative would be to add another sysctl to control whether
setting SO_RCVMARK is privilged or not.
(or even a MASK of which bits in the mark can be exposed)
But this seems like over-engineering...

Note: This is a non-trivial revert, due to later merged commit e42c7beee71d
("bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_set=
sockopt()")
which changed both 'ns_capable' into 'sockopt_ns_capable' calls.

Fixes: 1f86123b9749 ("net: align SO_RCVMARK required privileges with SO_MAR=
K")
Cc: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: Simon Horman <simon.horman@corigine.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Eyal Birger <eyal.birger@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Patrick Rohr <prohr@google.com>
Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
---
 net/core/sock.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 24f2761bdb1d..6e5662ca00fe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1362,12 +1362,6 @@ int sk_setsockopt(struct sock *sk, int level, int op=
tname,
 		__sock_set_mark(sk, val);
 		break;
 	case SO_RCVMARK:
-		if (!sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
-		    !sockopt_ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
-			ret =3D -EPERM;
-			break;
-		}
-
 		sock_valbool_flag(sk, SOCK_RCVMARK, valbool);
 		break;
=20
--=20
2.41.0.162.gfafddb0af9-goog



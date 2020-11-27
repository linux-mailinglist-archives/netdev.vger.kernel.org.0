Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB41E2C61CC
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgK0Jef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:34:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgK0Jef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:34:35 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA45C0613D1;
        Fri, 27 Nov 2020 01:34:34 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so6717181ejg.1;
        Fri, 27 Nov 2020 01:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ocarC8hdvKNkrOHjjhwHdlA+zeKn5dsLCEZCQr6M228=;
        b=PAGl8Tcbwzlwi5WLZGrU/PYAtwIAN4u4L5tE+8VGPFw6RRBbIdpSV5ai1sDksG6QGu
         9O1qFyIqIZcBpygtk26GEO+CTdaCcTxo+3xcyAdvZreiDPOwR0k1FEWJYZPc4d9mH+Eb
         aCHIKpb7iuC86Imr/pyNulDweglxYWYsJlmJpacjK672vlRR77dCINBHob9AQhECJD7m
         1ZJ6vuHstdouROYY4y7Hnm8BkCmG7kTh6d4Al+CL+13uPZJki4LprDunAqhalE3VxK47
         xYqzs+iqq5oYg+CITmNU64shY0VUav4JiwWOunP+4iNGzdGE/q3jpsocp0u2DhCGrZTO
         nsPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ocarC8hdvKNkrOHjjhwHdlA+zeKn5dsLCEZCQr6M228=;
        b=Ed0AvmTnuDkRbeId60Da5AFx9XfburaBOKzGtbt/D50OC/S3PjmQ2dt+mkAbxFPxQ8
         XDGk+rvkTwTxNlLbXUiiTvdcXjyj8EA/3EeirM6Z35z7LND/XSMx43c0Vnn1Geez9jMV
         3TnCO8Hzpv5ChZe+BGoieBCri63lVW35E04qvDskCL6YPMU6+3Bo4iEmEEcBJnJouS/Y
         lnlnnzCzQBo5fxxhB9g7b87d3d7g2XDw3vGGoR/8KDWsJTEofmA0fBsy1IPJO1uvHGK0
         BH6pRFekXP0TfyxstE8dv3xADtwy8NRofN9VpFLIUyN2vVfxc/UC62hSGQAphpCwXoNp
         uu1A==
X-Gm-Message-State: AOAM533gpYlU0W7ubLFrOiydYi34pgMzzcq7hRnDpX0hoR+9Fn0HvYny
        RRZm0anKe/PUosncy/8+Kv0=
X-Google-Smtp-Source: ABdhPJwb0ldMHmgkYADzMIm7QGhxD9ojBKvlvxEUkaZWGdJfpwUdBoM8tx364zb/qd2KfkHlvmcn3A==
X-Received: by 2002:a17:906:ca0b:: with SMTP id jt11mr6575848ejb.538.1606469673490;
        Fri, 27 Nov 2020 01:34:33 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d2f:6900:c16c:e89c:9291:845f])
        by smtp.gmail.com with ESMTPSA id w3sm4756079edt.84.2020.11.27.01.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:34:32 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Christoph Hellwig <hch@lst.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net/ipv6: propagate user pointer annotation
Date:   Fri, 27 Nov 2020 10:34:21 +0100
Message-Id: <20201127093421.21673-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For IPV6_2292PKTOPTIONS, do_ipv6_getsockopt() stores the user pointer
optval in the msg_control field of the msghdr.

Hence, sparse rightfully warns at ./net/ipv6/ipv6_sockglue.c:1151:33:

  warning: incorrect type in assignment (different address spaces)
      expected void *msg_control
      got char [noderef] __user *optval

Since commit 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for
->msg_control"), user pointers shall be stored in the msg_control_user
field, and kernel pointers in the msg_control field. This allows to
propagate __user annotations nicely through this struct.

Store optval in msg_control_user to properly record and propagate the
memory space annotation of this pointer.

Note that msg_control_is_user is set to true, so the key invariant, i.e.,
use msg_control_user if and only if msg_control_is_user is true, holds.

The msghdr is further used in the six alternative put_cmsg() calls, with
msg_control_is_user being true, put_cmsg() picks msg_control_user
preserving the __user annotation and passes that properly to
copy_to_user().

No functional change. No change in object code.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Christoph, please review and ack.

David, Alexey, Hideaki-san, Jakub,
  please pick this minor non-urgent clean-up patch.

 net/ipv6/ipv6_sockglue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 43a894bf9a1b..a6804a7e34c1 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1148,7 +1148,7 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		if (sk->sk_type != SOCK_STREAM)
 			return -ENOPROTOOPT;
 
-		msg.msg_control = optval;
+		msg.msg_control_user = optval;
 		msg.msg_controllen = len;
 		msg.msg_flags = flags;
 		msg.msg_control_is_user = true;
-- 
2.17.1


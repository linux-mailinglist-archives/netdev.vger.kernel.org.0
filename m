Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2777417E78
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344898AbhIXX4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbhIXX4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:56:33 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0C3C061613
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:54:59 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id p75-20020a0c90d1000000b0037efc8547d4so42649125qvp.16
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 16:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sFAT+/xUs0DyXN/SgVFCRQGEefTsT8LvY1lcXc1xLQE=;
        b=VsBl6T4dyKWXT+ui0ea68Nvy3pAz5t3DyjHQ/Y3karVvmg0WsdDzd/0ktYZZAy5jun
         USqh3kY/ihfZoegoEKqUnfMXRuVrXAbcttXHKJWYfZezXq6AKxtsEvG0tmQUjiuwteuC
         128yRapj66WUWj7rpIB07NJT3/nVxmq3StzVTCI6iO7NXDjUBNil9oEGBvf6LAiHUZ9Z
         qt611BNEyhtefWN9lenoFNIulWIh86/S8jMCOQCGOeJLkFWcCm2QSLZ1/7Lu+JrntntY
         RCVGVpdQslv4C56N7dzCsYj9KIM+1OP234B5wBikOHY1rBepPdedXMjLADp4csfRfSH8
         rEZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sFAT+/xUs0DyXN/SgVFCRQGEefTsT8LvY1lcXc1xLQE=;
        b=uoEs00dr3qYt+lDg7OINrMwoEzv6OKTlR4UdLEZaofYDWj0sgz9qtOCd/fkk4rFaH6
         VWfwWOSAg3+TaYe36VhZPppCo2w8yqAtIUcH+93dh0NBPRT2WIn39aQdSZG2mm68R5Pb
         NMmxZod1+MGbjQOjptnC8OKbf0xBTJYlZTQ51v3YjHPZ0mfqW8y0uAkCdS7V4ia5vUas
         vWE4cN/Jhd2ge1O+j2lriFR/bQY62/xKCkbPBXojbwLhH9O8oyeS9WS8mPU6w+YswhHJ
         5xXuUPbWPHX4D5g++/TWZxqHZI/OQY+9rYr7gbH4ESBXpFLI1VW0PaI1mOucOhKSqPIR
         7Mdw==
X-Gm-Message-State: AOAM532tcj3YwBOAbOGDeGIn8JYFSxwxTTpD/KyQ5a5645XeJbX5J9O6
        3Q/99VP35jSWIHb0/tr9ViHISS1geoc=
X-Google-Smtp-Source: ABdhPJycefPayFB1j5Y74uZACz9Ysrx+PqDaafPzyMlpOxweTNc0uICzH5hXTJtCdaj7hmUwnV7WpQfysRg=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:2b3e:d957:1977:d001])
 (user=weiwan job=sendgmr) by 2002:a05:6214:726:: with SMTP id
 c6mr13022388qvz.9.1632527699082; Fri, 24 Sep 2021 16:54:59 -0700 (PDT)
Date:   Fri, 24 Sep 2021 16:54:56 -0700
Message-Id: <20210924235456.2413081-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [patch v3] tcp.7: Add description for TCP_FASTOPEN and
 TCP_FASTOPEN_CONNECT options
From:   Wei Wang <weiwan@google.com>
To:     Alejandro Colomar <alx.manpages@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Cc:     netdev@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP_FASTOPEN socket option was added by:
commit 8336886f786fdacbc19b719c1f7ea91eb70706d4
TCP_FASTOPEN_CONNECT socket option was added by the following patch
series:
commit 065263f40f0972d5f1cd294bb0242bd5aa5f06b2
commit 25776aa943401662617437841b3d3ea4693ee98a
commit 19f6d3f3c8422d65b5e3d2162e30ef07c6e21ea2
commit 3979ad7e82dfe3fb94a51c3915e64ec64afa45c3
Add detailed description for these 2 options.
Also add descriptions for /proc entry tcp_fastopen and tcp_fastopen_key.

Signed-off-by: Wei Wang <weiwan@google.com>
---
 man7/tcp.7 | 125 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/man7/tcp.7 b/man7/tcp.7
index 0a7c61a37..bdd4a33ca 100644
--- a/man7/tcp.7
+++ b/man7/tcp.7
@@ -423,6 +423,28 @@ option.
 .\" Since 2.4.0-test7
 Enable RFC\ 2883 TCP Duplicate SACK support.
 .TP
+.IR tcp_fastopen  " (Bitmask; default: 0x1; since Linux 3.7)"
+Enables RFC\ 7413 Fast Open support.
+The flag is used as a bitmap with the following values:
+.RS
+.IP 0x1
+Enables client side Fast Open support
+.IP 0x2
+Enables server side Fast Open support
+.IP 0x4
+Allows client side to transmit data in SYN without Fast Open option
+.IP 0x200
+Allows server side to accept SYN data without Fast Open option
+.IP 0x400
+Enables Fast Open on all listeners without
+.B TCP_FASTOPEN
+socket option
+.RE
+.TP
+.IR tcp_fastopen_key " (since Linux 3.7)"
+Set server side RFC\ 7413 Fast Open key to generate Fast Open cookie
+when server side Fast Open support is enabled.
+.TP
 .IR tcp_ecn " (Integer; default: see below; since Linux 2.4)"
 .\" Since 2.4.0-test7
 Enable RFC\ 3168 Explicit Congestion Notification.
@@ -1202,6 +1224,109 @@ Bound the size of the advertised window to this value.
 The kernel imposes a minimum size of SOCK_MIN_RCVBUF/2.
 This option should not be used in code intended to be
 portable.
+.TP
+.BR TCP_FASTOPEN " (since Linux 3.6)"
+This option enables Fast Open (RFC\ 7413) on the listener socket.
+The value specifies the maximum length of pending SYNs
+(similar to the backlog argument in
+.BR listen (2)).
+Once enabled,
+the listener socket grants the TCP Fast Open cookie on incoming
+SYN with TCP Fast Open option.
+.IP
+More importantly it accepts the data in SYN with a valid Fast Open cookie
+and responds SYN-ACK acknowledging both the data and the SYN sequence.
+.BR accept (2)
+returns a socket that is available for read and write when the handshake
+has not completed yet.
+Thus the data exchange can commence before the handshake completes.
+This option requires enabling the server-side support on sysctl
+.IR net.ipv4.tcp_fastopen
+(see above).
+For TCP Fast Open client-side support,
+see
+.BR send (2)
+.B MSG_FASTOPEN
+or
+.B TCP_FASTOPEN_CONNECT
+below.
+.TP
+.BR TCP_FASTOPEN_CONNECT " (since Linux 4.11)"
+This option enables an alternative way to perform Fast Open on the active
+side (client).
+When this option is enabled,
+.BR connect (2)
+would behave differently depending on if a Fast Open cookie is available
+for the destination.
+.IP
+If a cookie is not available (i.e. first contact to the destination),
+.BR connect (2)
+behaves as usual by sending a SYN immediately,
+except the SYN would include an empty Fast Open cookie option to solicit a
+cookie.
+.IP
+If a cookie is available,
+.BR connect (2)
+would return 0 immediately but the SYN transmission is defered.
+A subsequent
+.BR write (2)
+or
+.BR sendmsg (2)
+would trigger a SYN with data plus cookie in the Fast Open option.
+In other words,
+the actual connect operation is deferred until data is supplied.
+.IP
+.B Note:
+While this option is designed for convenience,
+enabling it does change the behaviors and certain system calls might set
+different
+.I errno
+values.
+With cookie present,
+.BR write (2)
+or
+.BR sendmsg (2)
+must be called right after
+.BR connect (2)
+in order to send out SYN+data to complete 3WHS and establish connection.
+Calling
+.BR read (2)
+right after
+.BR connect (2)
+without
+.BR write (2)
+will cause the blocking socket to be blocked forever.
+.IP
+The application should  either set
+.B TCP_FASTOPEN_CONNECT
+socket option before
+.BR write (2)
+or
+.BR sendmsg (2)
+,
+or call
+.BR write (2)
+or
+.BR sendmsg (2)
+with
+.B MSG_FASTOPEN
+flag directly,
+instead of both on the same connection.
+.IP
+Here is the typical call flow with this new option:
+.IP
+.in +4n
+.EX
+s = socket();
+setsockopt(s, IPPROTO_TCP, TCP_FASTOPEN_CONNECT, 1, ...);
+connect(s);
+write(s); // write() should always follow connect() in order to trigger SYN to go out
+read(s)/write(s);
+...
+close(s);
+.EE
+.in
+.IP
 .SS Sockets API
 TCP provides limited support for out-of-band data,
 in the form of (a single byte of) urgent data.
-- 
2.33.0.685.g46640cef36-goog


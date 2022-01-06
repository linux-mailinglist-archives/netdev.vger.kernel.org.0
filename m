Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B619485E48
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344477AbiAFB5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344461AbiAFB5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:57:36 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8BBC061245;
        Wed,  5 Jan 2022 17:57:36 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id g2so1241450pgo.9;
        Wed, 05 Jan 2022 17:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Z9qkHqYLIA/7ijai38ZX5F2EkiB7fJkOdc4W8a8iM0=;
        b=bLlOFMicadL6IIK8tdMi9ohEQIcVhCzhFBCQzsk3g0Zu7MrBRPEyE1UkzQLCWZF+03
         agN5BAouCf1EOG9uv1ysvKSL1dfO8eE+XGVe/pHxp/LWLANXoqkJsA2o6VKhhi98b8UQ
         Z6CKTzb1IisfCLpGDuYi++SDkKMQwRia1RiKdkuHFfcIH/dNQt750D2UvwjHOLG3wooS
         qUXxzt/d9XJXMbt0HLdAqV1DfW1KbkTPCMKRxQXECHmOHWyIYito1GmEBTRmnIcCyCCN
         V1dcBKz/1zvY53H41G5B3yaovkdLgYlFk6TNF3oCgpv9slkD+vWcIHTKmXj8n25ppH1b
         1SPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/Z9qkHqYLIA/7ijai38ZX5F2EkiB7fJkOdc4W8a8iM0=;
        b=KOpSP3PdKQaP3sngT0o2lg0adOWhsooqfdA0Ug34bI23Z4Y9tVKnUwv2kDQ0cBiEL6
         yqnY/NoZp5GfMNpVY/f3omKLD+Jwd0O+Jw8Ctr/M5U3G1SQcG5ek1nRI2y+wOvAqbuFS
         NK9exMLgeozsoRHvoeFudbjgdH7BRjRtOuXrxHrXzvRU7SJ+6glN3RjVl+74PTLdVoXA
         SSr5uLcW6+syEyl7OJGFAY57vvRHtlrIdqLTM5LtIFI6X6FXT+bc+w6Oe7iGC4ivRU5k
         Rm4bM+BIDzHQ72TGKrDckKGmDSG8LYyiSX9FWnhluYCUE5lzgOh0j1hljA3ITqJn8KoM
         s6fw==
X-Gm-Message-State: AOAM531QHlQoJPDfJJuB4dgUZ1YSDC2PAQUKpV1Ai/kyQr4o+Kdzc3PB
        KLiDDLje2CERRHHAst1T6bg=
X-Google-Smtp-Source: ABdhPJyKVbqv3npeYD/Egv3KQ9GF0CljKqtvssIQuF5fiKblg85xkAcSb9tcJqQYZ+jcRt8+8YNOYg==
X-Received: by 2002:a05:6a00:3001:b0:4bb:ea7d:6c48 with SMTP id ay1-20020a056a00300100b004bbea7d6c48mr45188110pfb.51.1641434255727;
        Wed, 05 Jan 2022 17:57:35 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id g21sm330910pfc.75.2022.01.05.17.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 17:57:35 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v4 net-next 0/3] net: bpf: handle return value of post_bind{4,6} and add selftests for it
Date:   Thu,  6 Jan 2022 09:57:18 +0800
Message-Id: <20220106015721.3038819-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND() in
__inet_bind() is not handled properly. While the return value
is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
exit:
exit:

        err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
        if (err) {
                inet->inet_saddr = inet->inet_rcv_saddr = 0;
                goto out_release_sock;
        }

Let's take UDP for example and see what will happen. For UDP
socket, it will be added to 'udp_prot.h.udp_table->hash' and
'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
called success. If 'inet->inet_rcv_saddr' is specified here,
then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
to (because inet_saddr is changed to 0), and UDP packet received
will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
specified here, the sock will work fine, as it can receive packet
properly, which is wired, as the 'bind()' is already failed.

To undo the get_port() operation, introduce the 'put_port' field
for 'struct proto'. For TCP proto, it is inet_put_port(); For UDP
proto, it is udp_lib_unhash(); For icmp proto, it is
ping_unhash().

Therefore, after sys_bind() fail caused by
BPF_CGROUP_RUN_PROG_INET4_POST_BIND(), it will be unbinded, which
means that it can try to be binded to another port.

The second patch is the selftests for this modification.

The third patch use C99 initializers in test_sock.c.

Changes since v3:
- add the third patch which use C99 initializers in test_sock.c

Changes since v2:
- NULL check for sk->sk_prot->put_port

Changes since v1:
- introduce 'put_port' field for 'struct proto'
- add selftests for it


Menglong Dong (3):
  net: bpf: handle return value of 
    BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
  bpf: selftests: add bind retry for post_bind{4, 6}
  bpf: selftests: use C99 initializers in test_sock.c

 include/net/sock.h                      |   1 +
 net/ipv4/af_inet.c                      |   2 +
 net/ipv4/ping.c                         |   1 +
 net/ipv4/tcp_ipv4.c                     |   1 +
 net/ipv4/udp.c                          |   1 +
 net/ipv6/af_inet6.c                     |   2 +
 net/ipv6/ping.c                         |   1 +
 net/ipv6/tcp_ipv6.c                     |   1 +
 net/ipv6/udp.c                          |   1 +
 tools/testing/selftests/bpf/test_sock.c | 370 ++++++++++++++----------
 10 files changed, 233 insertions(+), 148 deletions(-)

-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86DBE3EC06A
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 06:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhHNE2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 00:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHNE2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 00:28:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663BC061756
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k2so14536018plk.13
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98Zw1c+cW5zD1PWqvSDU2uTGAumLzHONU8NOH1AIF5I=;
        b=Q+n9F+W0iE4jTCL7Mvp/I7AUBl/CYg8DmsQPZ4i6rESsU+NiRwyMPe1ELQzycWiJ8T
         iggFvHBQbvcCOT6Sua9JJFxeOEd3LtZTdAKpsa4WRUlg7zpCdxLRuqsUlzrS6po9rGfz
         jXLRF2llxEaxYAf7qGq82p826zRhYLSXo7jzpsFzjGSRy9XakD7ilP5FAmc0ytA/or+0
         ayZMEL5jOexlgyz9V90nQKpWTqfag//EM49J8A25fBmcfop3KI74YPmFKqU9on4aARwR
         DwPvMrogbTwjkq67njC4A4Srh9Ct0YAM81FkIadcCcwJ3oOCwbuo0W1MCLLozxCTDrkG
         +0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=98Zw1c+cW5zD1PWqvSDU2uTGAumLzHONU8NOH1AIF5I=;
        b=RxfdWvAphg7ZKCAB1zI6uide7W6G6kPrTiNqqF1AIUNXdjcjQGdUsmXkIwIlPwH+Sc
         VSZFmBKGMf0DbsN5CDK4+Rf8M0yeEcMdQ7QPj+n6oZewKlCTtuC0LEYniK9FG6xAeVGD
         I5UqD8Dsf4Y47PYAghHcH/brifMxJpycht30f6z3PDlE+UDMpMWG2h6dQgcd9AD2eJHd
         ACIEv9mPRs9IOd9m+9jqykOt6qMAa7b3TsUQwLlmbsMPiFrSVCMOktKMUNU2UHNd9VWk
         D+YdIvaITYb0XPr8dnctrVPg8RVf1/JUAZX9X8qnixBpnopOVsMyJV8XifdZo/VbluJe
         /Baw==
X-Gm-Message-State: AOAM530Y9ctvryKakOkxBcn07dXWT7AZs3njyxYgfQKlVnn7Tw+htfRa
        6pfbSFyS6tsfmTw7lwH5Eo4INsC6gQbixg==
X-Google-Smtp-Source: ABdhPJy0AfUvyfScZ2ucRHa6sdvW6SPNRE1ZDCUTnaKBo7EpZklVX/JTPRSeVA0q0AspMMzlCRwnmA==
X-Received: by 2002:a62:5291:0:b029:397:6587:1af6 with SMTP id g139-20020a6252910000b029039765871af6mr5497726pfb.47.1628915282938;
        Fri, 13 Aug 2021 21:28:02 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id q21sm4420492pgk.71.2021.08.13.21.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 21:28:02 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v6 0/5] sockmap: add sockmap support for unix stream socket
Date:   Sat, 14 Aug 2021 04:27:45 +0000
Message-Id: <20210814042754.3351268-1-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add support for unix stream type
for sockmap. Sockmap already supports TCP, UDP,
unix dgram types. The unix stream support is similar
to unix dgram.

Also add selftests for unix stream type in sockmap tests.


Jiang Wang (5):
  af_unix: add read_sock for stream socket types
  af_unix: add unix_stream_proto for sockmap
  selftest/bpf: add tests for sockmap with unix stream type.
  selftest/bpf: change udp to inet in some function names
  selftest/bpf: add new tests in sockmap for unix stream to tcp.

 include/net/af_unix.h                         |  8 +-
 net/unix/af_unix.c                            | 91 +++++++++++++++---
 net/unix/unix_bpf.c                           | 93 ++++++++++++++-----
 .../selftests/bpf/prog_tests/sockmap_listen.c | 48 ++++++----
 4 files changed, 187 insertions(+), 53 deletions(-)

v1 -> v2 :
 - Call unhash in shutdown.
 - Clean up unix_create1 a bit.
 - Return -ENOTCONN if socket is not connected.

v2 -> v3 :
 - check for stream type in update_proto
 - remove intermediate variable in __unix_stream_recvmsg
 - fix compile warning in unix_stream_recvmsg

v3 -> v4 :
 - remove sk_is_unix_stream, just check TCP_ESTABLISHED for UNIX sockets.
 - add READ_ONCE in unix_dgram_recvmsg
 - remove type check in unix_stream_bpf_update_proto

v4 -> v5 :
 - add two missing READ_ONCE for sk_prot.

v5 -> v6 :
 - fix READ_ONCE by reading to a local variable first.

For the series:

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>

Also rebased on bpf-next
 
-- 
2.20.1


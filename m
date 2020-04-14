Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD91A8064
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405194AbgDNOvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 10:51:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405184AbgDNOuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 10:50:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586875854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=++cgNxaTJnTUqeFXINrVDsIffIgp4AONxrQaa1iE9nI=;
        b=h2aSScviHcs1SuOJz5jhU/n7GBkNxJN06pZGgzJ3T5pl70OUOpnyVRL5GzvsleHRLZhzsi
        imzGmIRaP34sXkw9nDPT+VTt11EzYLFYhdjbL0nxZ7ZjDUqWRIxfc1y1ZXKGPzNgcRKanX
        ncBTg1g8Et9xpn5+qOQL6b7JLifqD88=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-wgAGBjfxPZC6YHYj5QP4Xg-1; Tue, 14 Apr 2020 10:50:51 -0400
X-MC-Unique: wgAGBjfxPZC6YHYj5QP4Xg-1
Received: by mail-lf1-f72.google.com with SMTP id l28so12888lfp.8
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 07:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=++cgNxaTJnTUqeFXINrVDsIffIgp4AONxrQaa1iE9nI=;
        b=FPSep+/DCFXNlNhyA8ureAkLCVRyN5aLdmsHo1GqAy2/YLpQ6dPHCm0qxE5KxHSrz1
         gQ3E67XglhqPT09n1HA0/yPovwg5gUHPPF5ctZBugfXpHRPSQXl+XKqqxDjwM4YCAt+P
         F6Pv1f64ybTvGuU7zvZ+WBUzklGuFpvXpICjf8ex/MLpG1VSJlM2sHtMwAkV30MCrJG3
         HPvmEf66Fh8iv2v7oIiKx9QyT2eNTwyCWvqiEnCdXb0scZerLpfuCit9Ks1fCMPnDKU5
         POzFIjXcDxOdKfTsQC6Hc4L91sWH5Zjkkv6iCKZpviMi1F0sWs0FCcbS9hecYhg1L8eO
         d0kQ==
X-Gm-Message-State: AGi0PubmDGglWbk861i+0xdybLmYM5hkeixapn2uJ4kEmr/e/7k50uce
        kOIU0NhaV0xqur80wTTogg8m4b9ra24KXq6ecMVu2kskGeQbBf6D5arATijZDAZj1rm/w0FpnKo
        KU4UrbmFjmVsIfC5F
X-Received: by 2002:a2e:b4cc:: with SMTP id r12mr372054ljm.50.1586875850030;
        Tue, 14 Apr 2020 07:50:50 -0700 (PDT)
X-Google-Smtp-Source: APiQypI2Vtj0Iz7zJt3AEzJUtMYLFT0/Jahb4lbT/3ZQxqMmzznsEtgJJyut8/eJ9PFGJEucJrjWew==
X-Received: by 2002:a2e:b4cc:: with SMTP id r12mr372030ljm.50.1586875849671;
        Tue, 14 Apr 2020 07:50:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v30sm5781233ljd.98.2020.04.14.07.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:50:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E64A1181586; Tue, 14 Apr 2020 16:50:46 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 1/2] libbpf: Fix type of old_fd in bpf_xdp_set_link_opts
Date:   Tue, 14 Apr 2020 16:50:24 +0200
Message-Id: <20200414145025.182163-1-toke@redhat.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'old_fd' parameter used for atomic replacement of XDP programs is
supposed to be an FD, but was left as a u32 from an earlier iteration of
the patch that added it. It was converted to an int when read, so things
worked correctly even with negative values, but better change the
definition to correctly reflect the intention.

Fixes: bd5ca3ef93cd ("libbpf: Add function to set link XDP fd while specifying old program")
Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 44df1d3e7287..f1dacecb1619 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -458,7 +458,7 @@ struct xdp_link_info {
 
 struct bpf_xdp_set_link_opts {
 	size_t sz;
-	__u32 old_fd;
+	int old_fd;
 };
 #define bpf_xdp_set_link_opts__last_field old_fd
 
-- 
2.26.0


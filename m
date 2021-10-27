Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9638843C0CD
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 05:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhJ0Dic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 23:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhJ0Dib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 23:38:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C8C061570;
        Tue, 26 Oct 2021 20:36:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so1028954pjb.4;
        Tue, 26 Oct 2021 20:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cnRcsSHkRZTqikALTy3n28J23l1NEmyBgtN3a1aP9RQ=;
        b=dz41zOFWBPC76rvVnoN9L2WnpqgcAzkTakHiexDIrqcuVQ+WYbqh2d4xCLX76o+MbK
         MjtLY5fdIJwURNRxj9ggJWzh/uBcqZCkiv8Mg568ruv6FPeyBQhUcGtxiEEHXpMeQcW7
         npAKZqlaDyIKT7zGz1nY0Om8QXXx0mtSxwjZP0j6trGB4+PbUWwsgGh1hb0FT+/bEvGR
         ergDHIGBZ9uwJKxSK9nv663mMUc8KWtQZv9JevkqhruOwTctC5BkbC3ssD2rcQtu5Va+
         /SY2XZDsvq7k8bRF/lYi0ayYp6RYN/MWQG2GXVnpaEAeAk4R4Z3qzqMOnszeum+qkka3
         i4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cnRcsSHkRZTqikALTy3n28J23l1NEmyBgtN3a1aP9RQ=;
        b=lFkn7ebHdZbeoHiWSdbS/1IPyinJZ63H6wGnndufCUEyS4i5Y1k99DU5zfdM2sLzZl
         RJKaVnzLIfMBF+hbZXg6ep0qx1Nf2Kblsw6Uj9h6V5bBpkhEz2dXVKbcqaKz+9CD9q1n
         WEhlhXL2IOXfZhM/5QPnh0NsAC5zCItu7erbvIeD0SdBvJ/BgHCiO1vlA+RU18UiFA+S
         6vFVs76xRKAufSOxJjPMD7TkIukFZ+lHK08WNjZyO/jyKR7i8KeZN/juAPuXP7EIAprI
         XcdLeTCM0By//fORVTGtfSu8xONjSJJhGnph2JwKXpMjFxXUU0MzGcl2VD3jxkr1OpGP
         01fg==
X-Gm-Message-State: AOAM531dv/YcDrPJrdOv9VK7/BGctPLXsb5HJxg1yVlQVMDMWXCpG+r2
        nyiZATqD3EGEJ7rUInpMccU0DjrHy1Y=
X-Google-Smtp-Source: ABdhPJw+nBFu8Kk2z6TwbevunOL3CqThOSsopRKwhfLsuj+uADFZLSzY21T8seuobqr8QjYgYvVmvQ==
X-Received: by 2002:a17:90b:1d86:: with SMTP id pf6mr2092444pjb.241.1635305765912;
        Tue, 26 Oct 2021 20:36:05 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p1sm12080847pfo.143.2021.10.26.20.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 20:36:05 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-kselftest@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 0/4] Fix some issues for selftest test_xdp_redirect_multi.sh
Date:   Wed, 27 Oct 2021 11:35:49 +0800
Message-Id: <20211027033553.962413-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri reported some issues in test_xdp_redirect_multi.sh. Like
the test logs not cleaned after testing. The tcpdump not terminated cleanly.
arp number count may have false positive. And the most important, after
creating/deleting a lot interfaces, the interface index may exceed the
DEVMAP max entry and cause program xdp_redirect_multi exec failed.

This patch set fix all these issues.

Hangbin Liu (4):
  selftests/bpf/xdp_redirect_multi: put the logs to tmp folder
  selftests/bpf/xdp_redirect_multi: use arping to accurate the arp
    number
  selftests/bpf/xdp_redirect_multi: give tcpdump a chance to terminate
    cleanly
  selftests/bpf/xdp_redirect_multi: limit the tests in netns

 .../selftests/bpf/test_xdp_redirect_multi.sh  | 62 +++++++++++--------
 .../selftests/bpf/xdp_redirect_multi.c        |  4 +-
 2 files changed, 37 insertions(+), 29 deletions(-)

-- 
2.31.1


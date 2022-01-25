Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB8249AF20
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454667AbiAYJAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454181AbiAYI54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:57:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D63C068087;
        Tue, 25 Jan 2022 00:17:38 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h20-20020a17090adb9400b001b518bf99ffso1458121pjv.1;
        Tue, 25 Jan 2022 00:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTbUeqXpB2EXe8rHgW/mo0ZdZLLl7DCmA+2qGBk1qlI=;
        b=lw2zsEIaKAsMyw/46jIWz6dUwtvG9TwJdvYyA8ZhnqUUQoz6OvOOWmZnxVCj6nof6R
         lPf7ii3PHOtlB74vltOWwFhDrYW20KO0cMC0i4xFSIBg+LdAgs6BlBGD4okEnB8/Iqoc
         FFtF+KFullOvV4ZveB4YaFbqgYc7EoPbXhCruMglQOCmHC5mJ4qXpuVWb/GpUbpjYSIF
         bbmR8dutq4f2zvDj/UuL8cRkok7uMAyGGG90owrGFf2ZDYDGOcaK8Kwn5YlPvvyiu/1a
         W5qXI1eqiywQpCylv8m/NnObt2LJGTnPU2/Ms9jpa4jANtURqxS8RrJWqogqXA1txvoM
         T7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eTbUeqXpB2EXe8rHgW/mo0ZdZLLl7DCmA+2qGBk1qlI=;
        b=t9P98E4Ix6cCumhryg1uFHrss33d4NGCbiY2uZ532vuamyUQkj4VLO39QeJeFggVlm
         3VUMvQjJSTQZHGfr3mYH9x9SR+pMgiF/JTR6Uo3J8/C4VfdHYkJCV8Gt7Zw7Y4Shifpp
         vOXpm8UQCFXau9/PHbrDfpad64yKApa1+ZJCAax4oEPLzlq5AuAgatxfP10WkocDNvFQ
         rPQTG3QIq3n1KAYwaWPuXzaWfJxKpWdA4tGof2sf/5HFlRILdDh9jHT+e+c8dVXSdv7D
         tSLRv3Vq9UKIPjLUAO+hqXbd7VccTIYkEk9p7OSdqF398hfAX6kikOLWTnCx5tO7pOgi
         1XTA==
X-Gm-Message-State: AOAM530FLsCZuAORZ/bvoY5SbimBcjCyQAyIf/5IXo2Iioh3AQF4jsCA
        ZnD0fX8zE0Do79SQ7K4ICFUm2r2X+7E=
X-Google-Smtp-Source: ABdhPJx6L6+8l+L8jZMwdBs6avo0rhanj4MsfYNK10snJ/LnByyf8QGMMq9G9d/oXuiEq63QSzCUUg==
X-Received: by 2002:a17:903:24d:b0:149:b68f:579 with SMTP id j13-20020a170903024d00b00149b68f0579mr18371541plh.1.1643098657325;
        Tue, 25 Jan 2022 00:17:37 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm18928949pfu.120.2022.01.25.00.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 00:17:36 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        William Tu <u9012063@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf 0/7] selftests/bpf: use temp netns for testing
Date:   Tue, 25 Jan 2022 16:17:10 +0800
Message-Id: <20220125081717.1260849-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some bpf tests using hard code netns name like ns0, ns1, etc.
This kind of ns name is easily used by other tests or system. If there
is already a such netns, all the related tests will failed. So let's
use temp netns name for testing.

The first patch not only change to temp netns. But also fixed an interface
index issue. So I add fixes tag. For the later patches, I think that
should be an update instead of fixes, so the fixes tag is not added.

Hangbin Liu (7):
  selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
  selftests/bpf/test_xdp_veth: use temp netns for testing
  selftests/bpf/test_xdp_vlan: use temp netns for testing
  selftests/bpf/test_lwt_seg6local: use temp netns for testing
  selftests/bpf/test_tcp_check_syncookie: use temp netns for testing
  selftests/bpf/test_xdp_meta: use temp netns for testing
  selftests/bpf/test_xdp_redirect: use temp netns for testing

 .../selftests/bpf/test_lwt_seg6local.sh       | 170 +++++++++---------
 .../selftests/bpf/test_tcp_check_syncookie.sh |   5 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh  |  38 ++--
 .../selftests/bpf/test_xdp_redirect.sh        |  30 ++--
 .../selftests/bpf/test_xdp_redirect_multi.sh  |  60 ++++---
 tools/testing/selftests/bpf/test_xdp_veth.sh  |  39 ++--
 tools/testing/selftests/bpf/test_xdp_vlan.sh  |  66 +++----
 7 files changed, 213 insertions(+), 195 deletions(-)

-- 
2.31.1


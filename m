Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B87650AB2E
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442335AbiDUWKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442329AbiDUWKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:10:09 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8FC43EDA;
        Thu, 21 Apr 2022 15:07:18 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id d19so4628956qko.3;
        Thu, 21 Apr 2022 15:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dHjxXbwqQtvuaoMXA8rnRVhFdDW5Qn6yct5S95Sj8t8=;
        b=R0K21wwZUQgYRQkZyYk2MgjbTh1op68EOEMB7a/0wZzSCvNxKBK3SRr5scZjRjXTUv
         YgqDfK4ojDnh5VQHbHZ1u39MdB536P2yphnBnttiKbXnAutfBLX8Eio2FVU3PSeEPh/F
         gMeiRyzfQJxk61Ggkh5gk7XQM1OSWry9buPnbswlOraYP5J5JBsjQhpuTFzgqdeYprKH
         eGjGGbmllXxtBERoK2KbhVGlUziL9Y3gtCBjpSnPy5QfUeprGtBxqjSMfp0iDJ7AAjMd
         dxW/qCbFh3K4Qh8VNmCz19Pbo4oXTC1dWK2q/zMqeUJwy+76Q2p34Ddf/7N/sDUxybUJ
         PBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dHjxXbwqQtvuaoMXA8rnRVhFdDW5Qn6yct5S95Sj8t8=;
        b=OqJzbvnwQj96Xk8o+paMQPaHw7R9QPnLi7kl/RB79VfFhhL5RuIdisQ/nYSUelSy62
         KVuS0HBZi0oQ/yBAuS3a2qYBYgJeWMo+znm4dYiSNNoO1CmsHQtCaz9OnT0IivUCqI+k
         +nLNQULQWaJWtv1TEiL2kISEyZEohWZudrYfBK12x7SObaob/5oUYtqYp7gI7i3kfzNU
         o2bLoIcUOFo1XAPibCx/OMy+y+E0RUe2T8o//wPdR+qWi2cmCMK9mrH+L0AztBNP5TUD
         5MW2NC4BaASnhqd193eHF90SwF/5ZwrO/HdMsOs6DUo7rYOcNTq+itxeh52hRtZardRp
         NtIg==
X-Gm-Message-State: AOAM53251cO9kjLtEGH2t9H3I1rv9357i1bvmftX8S+eZxhz26V+U3Vz
        ti0hKNf96lhlck1/TqWuoQ==
X-Google-Smtp-Source: ABdhPJyTKFTL4G7a4bLctY8+jXS7slkKaGynDvczVmu3NReacce8r3V5EJtqIdlo4MgELG/l/xfCeQ==
X-Received: by 2002:a05:620a:13fc:b0:69e:90a3:e1bc with SMTP id h28-20020a05620a13fc00b0069e90a3e1bcmr941061qkl.645.1650578837697;
        Thu, 21 Apr 2022 15:07:17 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id b84-20020ae9eb57000000b0069c8ca73b94sm89468qkg.115.2022.04.21.15.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 15:07:17 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, "xeb@mail.ru" <xeb@mail.ru>,
        William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net 0/3] ip_gre, ip6_gre: o_seqno fixes
Date:   Thu, 21 Apr 2022 15:06:39 -0700
Message-Id: <cover.1650575919.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Hi all,

As pointed out [1] by Jakub Kicinski, currently using TUNNEL_SEQ in
collect_md mode is racy for [IP6]GRE[TAP] devices, since they (typically,
e.g. if created using "ip") use lockless TX.

Patch [3/3] fixes it by making o_seqno atomic_t.

As mentioned by Eric Dumazet in commit b790e01aee74 ("ip_gre: lockless
xmit"), making o_seqno atomic_t increases "chance for packets being out
of order at receiver" when using lockless TX.

Another way to fix it would be: users must specify "external" and "oseq"
at the same time if they want the kernel to allow using TUNNEL_SEQ (e.g.
via eBPF) in collect_md mode, but that would break userspace.

I found another issue while reading the code: patches [1,2/3] make o_seqno
start from 0 in native mode, as described in RFC 2890 [2] section 2.2.:
"The first datagram is sent with a sequence number of 0."

Now we could make [IP6]GRE[TAP] (and probably [IP6]ERSPAN ?) devices
completely NETIF_F_LLTX, but that's out of scope of this fix and will be
sent as separate [net-next] patches.

[1] https://lore.kernel.org/netdev/20220415191133.0597a79a@kernel.org/
[2] https://datatracker.ietf.org/doc/html/rfc2890#section-2.2

Thanks,
Peilin Ye (3):
  ip_gre: Make o_seqno start from 0 in native mode
  ip6_gre: Make o_seqno start from 0 in native mode
  ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode

 include/net/ip6_tunnel.h |  2 +-
 include/net/ip_tunnels.h |  2 +-
 net/ipv4/ip_gre.c        | 12 +++++-------
 net/ipv6/ip6_gre.c       | 16 ++++++++--------
 4 files changed, 15 insertions(+), 17 deletions(-)

-- 
2.20.1


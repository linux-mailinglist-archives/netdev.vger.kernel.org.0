Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5176D5AD9AB
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiIETeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiIETeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16DD422F4
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662406445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QwEEQPqY2XQyuaWqpR5xEP/Kl2aFbpZLaAQ5AZ98N8c=;
        b=AIruFzt1b7VGYK0OTwILb87lQ5HSKVrS3XAFsKhPdcZK1eykWGiW/hRKi+RlE3rCWlWd4O
        lhab5rIvDi6EpBPK4C8kCBLmxxZEzMuW+qgvOk9MtSDLNBNI5hxsOdczkd6z+YuGwemHEX
        izLcGCQVnn7mmt/khtBxOe8qLXHKWV4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-586-RzPghMJxMk26sEjtxqvotw-1; Mon, 05 Sep 2022 15:34:03 -0400
X-MC-Unique: RzPghMJxMk26sEjtxqvotw-1
Received: by mail-ed1-f72.google.com with SMTP id z6-20020a05640240c600b0043e1d52fd98so6321967edb.22
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 12:34:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=QwEEQPqY2XQyuaWqpR5xEP/Kl2aFbpZLaAQ5AZ98N8c=;
        b=mJ9Hypesk21HmvR0UEEYYv6GEuyneAoDxMGjxonPCo63XNKnZzT0UsSd0B5YURVjqj
         1Bg1sVnrDD8ELq3ZdhyMtko+q1P0h0nHx5UtjW7Xxc5JaobsqghbbukwpnmUbTqQZeOy
         moEU6OiMuirOfRu3JXwU+yhj+X42uZ0p4iProeu07GcFafkGCXZWApVoL4l/TWPbBeTn
         c4BOKzgJGhElBJz0Z0OyAKTKWMUKLtEyXrhvMirJfDi8U0ZspYRhaX3Az/fMaPd1knN9
         IrW9MMVXkGbjo1+EPPybjPtRcR1Fsmcb4dyosnZIA8CksHX5L70JgI4l2ZA7Pusy4xJl
         mDLA==
X-Gm-Message-State: ACgBeo2+XDwrL9w95hayUAlAMh4QboBdWWuKcmDobKKiYbv5mmWi9OKG
        369HHBZBypq1cljdH4nqtrd/KAcYRsItniHq4szyABGTP9Qm9UnADel1qJXjXYn329RSgYq+17O
        yN2lJwXnGPYIqfWkM
X-Received: by 2002:a05:6402:524a:b0:43d:aa71:33d8 with SMTP id t10-20020a056402524a00b0043daa7133d8mr45883473edd.33.1662406442489;
        Mon, 05 Sep 2022 12:34:02 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5hdWBOqxJUjpVm2PlbQkPxGlZTW132//GBp9WTyWigj7E38khXaPWRdbgPIK1fQRlUmpy8Vg==
X-Received: by 2002:a05:6402:524a:b0:43d:aa71:33d8 with SMTP id t10-20020a056402524a00b0043daa7133d8mr45883448edd.33.1662406442106;
        Mon, 05 Sep 2022 12:34:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s4-20020a50d484000000b004479cec6496sm7038060edi.75.2022.09.05.12.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 12:34:00 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3FEEB589580; Mon,  5 Sep 2022 21:34:00 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/3] A couple of small refactorings of BPF program call sites
Date:   Mon,  5 Sep 2022 21:33:56 +0200
Message-Id: <20220905193359.969347-1-toke@redhat.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav suggested[0] that these small refactorings could be split out from the
XDP queueing RFC series and merged separately. The first change is a small
repacking of struct softnet_data, the others change the BPF call sites to
support full 64-bit values as arguments to bpf_redirect_map() and as the return
value of a BPF program, relying on the fact that BPF registers are always 64-bit
wide to maintain backwards compatibility.

Please see the individual patches for details.

v2:
- Rebase on bpf-next (CI failure seems to be unrelated to this series)
- Collect Stanislav's Reviewed-by

[0] https://lore.kernel.org/r/CAKH8qBtdnku7StcQ-SamadvAF==DRuLLZO94yOR1WJ9Bg=uX1w@mail.gmail.com

Kumar Kartikeya Dwivedi (1):
  bpf: Use 64-bit return value for bpf_prog_run

Toke Høiland-Jørgensen (2):
  dev: Move received_rps counter next to RPS members in softnet data
  bpf: Expand map key argument of bpf_redirect_map to u64

 include/linux/bpf-cgroup.h | 12 +++++-----
 include/linux/bpf.h        | 16 ++++++-------
 include/linux/filter.h     | 46 +++++++++++++++++++-------------------
 include/linux/netdevice.h  |  2 +-
 include/uapi/linux/bpf.h   |  2 +-
 kernel/bpf/cgroup.c        | 12 +++++-----
 kernel/bpf/core.c          | 14 ++++++------
 kernel/bpf/cpumap.c        |  4 ++--
 kernel/bpf/devmap.c        |  4 ++--
 kernel/bpf/offload.c       |  4 ++--
 kernel/bpf/verifier.c      |  2 +-
 net/bpf/test_run.c         | 21 +++++++++--------
 net/core/filter.c          |  4 ++--
 net/packet/af_packet.c     |  7 ++++--
 net/xdp/xskmap.c           |  4 ++--
 15 files changed, 80 insertions(+), 74 deletions(-)

-- 
2.37.2


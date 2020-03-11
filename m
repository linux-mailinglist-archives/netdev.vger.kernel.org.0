Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59888180D3C
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgCKBJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:09:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36711 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727744AbgCKBJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 21:09:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so300195wme.1;
        Tue, 10 Mar 2020 18:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2UKmRBSgazdDi1hm3bxfhfrJmnu09DZG7aqXlMNZ2a8=;
        b=jVoyTxH3UgKlEEgoxTyCCbkQuroNHW97dqNIiknHIhSVI4+VKRZa4j8qwTfELv41um
         IIxVXqAk4gh41QLt5dLIhboWS5zztWFLesYDGvkuXx+n8WE9R8HjU1JBOfY3ggjJqZHL
         cJviBTFPHv8yNa4DRiDz88VS9lkSvgOSOC41VLfW/Jwn3H5IChbQrVltrY98ZKazrce5
         KAZJ5w4YmFtSIeDH2ZKZebKYkFcpkghEzBd19nZHlK/nW82aQpxdzyaaxOU9aiyl+vuO
         WiusbOk2y2sl5TbSKRHYIJhXOPFlylpaSy6zZRna6PXvWVgk5Lmsz4oHHnYIsG1TvfKN
         VmUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2UKmRBSgazdDi1hm3bxfhfrJmnu09DZG7aqXlMNZ2a8=;
        b=kfvEw7TGMjkQSEVUraG8CKXgfd5YUwGhazuQBTJ6c3vslv1DWjf3Mv4irnhs7w7pZa
         lFBc/VTjWl0tE7+/QXzcmalp8Kr/rUeubV+M4evPLbO3ehHiNxHaGTC4AOQeE7s9N0e8
         TfE3M2MlAy1avF7OduqtSK7ekzXs5ohEKnGPHaYSOqosU2d1RtDKqFs9YEzS/J+Wsvjk
         vf9/ngRgaXdlwrWptnLvgHoA4haCyiQZL1NJg0CwyuCeLx9nd64UBLDSzd14xY6BkLA4
         IbsJFllC55ik4yvyiu4IM8XtsaF2IO3ijwh6vK2hsDUt8wCCVPoT22VwMl8dXTieoMLn
         1SvQ==
X-Gm-Message-State: ANhLgQ2UWKg1JRJDSvIgVVo9MYX1ndTHP99yiVRkZoS6iLRN8sIimHrd
        m8JilC8PTTXyj/yb8etY2Q==
X-Google-Smtp-Source: ADFU+vtMuxpL34oQe2WNFQIHS3VeWNKnBzGrKjivGzUGfU6xgHtqcmlXExpKohyjCDQwuEzhQrEhvQ==
X-Received: by 2002:a1c:e109:: with SMTP id y9mr433205wmg.62.1583888964431;
        Tue, 10 Mar 2020 18:09:24 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-15-144.as13285.net. [2.102.15.144])
        by smtp.googlemail.com with ESMTPSA id i6sm36658097wra.42.2020.03.10.18.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 18:09:24 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     boqun.feng@gmail.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 0/8] Lock warning cleanups
Date:   Wed, 11 Mar 2020 01:09:00 +0000
Message-Id: <20200311010908.42366-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <0/8>
References: <0/8>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds missing annotations to various functions,
that register warnings of context imbalance when built with Sparse tool.
The adds fix the warnings, improve on readability odf the code
and give better insight or directive on what the functions are actually doing.

Jules Irenge (8):
  bpf: Add missing annotations for __bpf_prog_enter() and 
    __bpf_prog_exit()
  raw: Add missing annotations to raw_seq_start() and raw_seq_stop()
  tcp: Add missing annotation for tcp_child_process()
  netfilter: Add missing annotation for ctnetlink_parse_nat_setup()
  netfilter: conntrack: Add missing annotations for
    nf_conntrack_all_lock() and nf_conntrack_all_unlock()
  net: Add missing annotation for *netlink_seq_start()
  ALSA: firewire-tascam: Add missing annotation for
    tscm_hwdep_read_queue()
  ALSA: firewire-tascam: Add missing annotation for
    tscm_hwdep_read_locked()

 kernel/bpf/trampoline.c              | 2 ++
 net/ipv4/raw.c                       | 2 ++
 net/ipv4/tcp_minisocks.c             | 1 +
 net/netfilter/nf_conntrack_core.c    | 2 ++
 net/netfilter/nf_conntrack_netlink.c | 1 +
 net/netlink/af_netlink.c             | 1 +
 sound/firewire/tascam/tascam-hwdep.c | 2 ++
 7 files changed, 11 insertions(+)

-- 
2.24.1


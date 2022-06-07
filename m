Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2553F855
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiFGIke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiFGIka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:40:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37059344F4;
        Tue,  7 Jun 2022 01:40:30 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id b135so14911458pfb.12;
        Tue, 07 Jun 2022 01:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tam56bOCxx60C/qIvXCeRdAGI1jmPvWPIVD3SXYiwrY=;
        b=aSCrNqUpoDrtYz2ETC7QLP4ukg+g8q8xow+dyCJXTqBk38MpyuRN/m1F6zAmOuVmyv
         V29aB3bASZ2qN3VLOUkM/9xwz0SOvb8YMa8pRL5orDmN6DzdvkFXEIHO/4ERNHAN8HxO
         U+aYj7hHGa3VbMe7qOqsAFYVoQKhDiEdBdHoKMU3PBRwjkaApaoJY+66SEccYilXTHnZ
         sRVykfMEsnE13IAc5y5sqmjTt7vWakAezKAuCh8JvrXOZYWJ/LflQF0uTItYxThaWriS
         mlDXAORLvZZBe8S9ckuKCwLVMlL+F1HCdKYl1dqkkvvzf/zAuxfVUB4MbcFMds0wqNai
         dcqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tam56bOCxx60C/qIvXCeRdAGI1jmPvWPIVD3SXYiwrY=;
        b=Uy3tiVK/gnZio6aD3LcD+1vSIX6GMEootrb+IkFqaoEx2SEgTE/acV5HBiEJi4FJ/Q
         gX4gi0e0gDevtZCBVMGzhFVcfGiyQTI5fhJ688usbtCKjGs3fyPUBFGLRvUp68fVzXPI
         OVoPv7SATLlQJxdGJKaTF44iLfXa3D6NojtBgMlNhB8bIMtTBO7r6em0akqpXvN+IbPw
         i3Skx2ymCpaLBCPgk2Q+WDR9KGU8GbGvNYmKHVi6Xqp0QSakre/xUKvtwOEycbKD0H49
         Jb1CVcVcSCfE5J5giXKj14DgIZrWGgUu2xWdIVAyiJgdJCXINYdv3uIiBTFWOl5HoJWa
         FZzw==
X-Gm-Message-State: AOAM532DQ0Q6tmelOB/hH4VwbXHpcxjkIob5NCS5JmcC5MSz1709lu1V
        2pnZ065UOWaR97R9D1xeGsO96A8+vbM5YA==
X-Google-Smtp-Source: ABdhPJycxOFBDO4DgAnuWfSSz+Pg8ppYo5HkGW7qAeEulnsQYgsOEEiKKQ1E7D90zTcFfI5GKlnE0g==
X-Received: by 2002:a63:524a:0:b0:3fc:7f18:685d with SMTP id s10-20020a63524a000000b003fc7f18685dmr25043363pgl.387.1654591229500;
        Tue, 07 Jun 2022 01:40:29 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s18-20020aa78d52000000b0050dc76281fdsm12134047pfe.215.2022.06.07.01.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 01:40:29 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next 0/3] move AF_XDP APIs to libxdp
Date:   Tue,  7 Jun 2022 16:40:00 +0800
Message-Id: <20220607084003.898387-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf APIs for AF_XDP are deprecated starting from v0.7.
Let's move to libxdp.

The first patch removed the usage of bpf_prog_load_xattr(). As we
will remove the GCC diagnostic declaration in later patches.

Hangbin Liu (3):
  samples/bpf/xdpsock_user.c: Get rid of bpf_prog_load_xattr()
  samples/bpf: move AF_XDP APIs to libxdp
  selftests/bpf: move AF_XDP APIs to libxdp

 samples/bpf/xdpsock_ctrl_proc.c          |  5 +----
 samples/bpf/xdpsock_user.c               | 22 ++++++++++++----------
 samples/bpf/xsk_fwd.c                    |  5 +----
 tools/testing/selftests/bpf/xdpxceiver.c |  8 +-------
 4 files changed, 15 insertions(+), 25 deletions(-)

-- 
2.35.1


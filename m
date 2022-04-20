Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5196507E1D
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348397AbiDTBa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiDTBa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:30:26 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4082E24587;
        Tue, 19 Apr 2022 18:27:42 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 12so459002oix.12;
        Tue, 19 Apr 2022 18:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=V0k9qzjhZ3a2RK4WCHiW0nuB4Cc5xmFrtaxsja/sons=;
        b=oXnTwBYTH9vN6CVcjt3D6D8IthX1x2kLHEPDgUadBpR5luEqaEm+oJTzb11c26ftGm
         PmpC2ekBQPPd2/3URaoiX+luMD3a9SAQyNEpLAGmI7SetVk0iKbZArYxqynUL/HCdlBp
         R2fGz1t8G6KtBlCOLOuXy8BnbEXeuGroxbwZygUUQlEgMF5iaOO5hR45s6NYHlW9CsJM
         RnpIonD1YOcQgeG8k0MLQMepzw1AHYYSqt7+Pc2ylYTvlCigp2tRP/+GGUF3tPGGvCs3
         HkOOxORk9ww0GRsIl/VLar4nKu22PCWq5ovOCmlUd/KAhyutWd5Ccno7lRx2N9QDJ/wV
         NJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V0k9qzjhZ3a2RK4WCHiW0nuB4Cc5xmFrtaxsja/sons=;
        b=4yjRLUfS+M1tlKdK/ZgR+YfJz5wdbLevqs49wKiTXEha3a643Zq1uTyHuVKTOcEIyZ
         aQJdrStPOSIbFncuf6LhM9napvVa2YmgVjgakMhU1n84jie9OhTLQyiSLDYw9gVSwn5s
         ZhyK2PnF3aioBzNk9hkP1qFJ6Jl7UuJZUQLdsvij1YxH9UjcaF187H9fIV7/El1UqQav
         hyZ3Hb4n7G3MQjYPcfbOZdBuo+3LYaHbkmzrorQxAAHob9qoqDg1nnADzkIQugE6lBW/
         42YOwD1L2xmGzpl2GWkcpuSF2VFDk9uY42gUyNagr5bxxeIUPdaVH7M+BTpHauA1HgaI
         5pGw==
X-Gm-Message-State: AOAM532O35ZDlQKoaYk9XF2r2YTta2hnl8Z/WKCkFwVHpx3Zm53esOzO
        p9e/JyKOl5qDqsN2X/49mc4=
X-Google-Smtp-Source: ABdhPJz6fPoY72HZ0A8X6i8DHTxjL9cRL0VxogQI1VnLpoz7dqoKabjHfkMeYESK09PBFNa69oxSeg==
X-Received: by 2002:a05:6808:13d2:b0:322:7571:79e with SMTP id d18-20020a05680813d200b003227571079emr682042oiw.52.1650418061516;
        Tue, 19 Apr 2022 18:27:41 -0700 (PDT)
Received: from toe.qscaudio.com ([65.113.122.35])
        by smtp.gmail.com with ESMTPSA id i26-20020a4a929a000000b0033a29c8d564sm4284530ooh.3.2022.04.19.18.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 18:27:41 -0700 (PDT)
From:   jeff.evanson@gmail.com
X-Google-Original-From: jeff.evanson@qsc.com
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path))
Cc:     Jeff Evanson <jeff.evanson@qsc.com>
Subject: [PATCH v2 0/2] AF_XDP patches for zero-copy in igc driver
Date:   Tue, 19 Apr 2022 19:26:33 -0600
Message-Id: <20220420012635.13733-1-jeff.evanson@qsc.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Evanson <jeff.evanson@qsc.com>

Patch 1/2
In igc_xdp_xmit_zc, the local variable ntu is initialized from ring->next_to_use 
without holding the __netif_tx_lock. If another thread already held the lock, the 
ntu value is potentially incorrect. Various bad behaviors were observed ranging
from transmit timeouts to an outright hard-lock of the host. The behavior is
corrected by simply initializing ntu while __netif_tx_lock is held.

Patch 2/2
In igc_xsk_wakeup, only the q_vector interrupt for the passed queue_id was
being triggered. This worked fine so long as both the tx and rx queues shared
the same interrupt. If the tx and rx queues use separate interrupts, only
the rx interrupt would be triggered, regardless of whether flags contained
XDP_WAKEUP_TX. This patch changes the behavior so that q_vectors (rxq_vector 
and txq_vector) are looked up from the referenced tx and/or rx queues instead
of from the adapter q_vector array. If only XDP_WAKEUP_RX is set, rxq_vector
is triggered. If only XDP_WAKEUP_TX is set txq_vector is triggered. If both
are set, rxq_vector is triggered and txq_vector is triggered only if it is
not equal to rxq_vector.
The bad behavior here is apparent when packets are queued up to an AF_XDP
socket and then sendmsg is called on the socket. The packets would not be
sent until the q_vector was triggered via some other mechanism (IE
igc_xmit_frame).


Jeff Evanson (2):
  igc: Fix race in igc_xdp_xmit_zc
  igc: Trigger proper interrupts in igc_xsk_wakeup

 drivers/net/ethernet/intel/igc/igc_main.c | 44 +++++++++++++++++------
 1 file changed, 34 insertions(+), 10 deletions(-)

-- 
2.17.1


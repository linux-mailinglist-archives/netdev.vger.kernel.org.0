Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC3B4A70CE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344169AbiBBM3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiBBM25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:28:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25CFC06173B;
        Wed,  2 Feb 2022 04:28:56 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643804933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=phquJAH/eFn2G1g+0c9hxUEOmuKdthHaUYI8ZgUETGo=;
        b=iHMszlCen8NRkqvUpgVKjdID2T5N+7vuRM9PGmLVlDkr2IYbd+vD4uwMEQves2dMprAd10
        p315GMocqJzELKtro7jaVoL3Y5SGHDLrQuGcUBgT2rHVXXk+A52ZagOQqbcjdCUVW5KwGR
        8ZdHErVcHKawVFCPV/DUzkTx0dBaRGO0uaEMl959ygJBGr/I7OoWi4xTGUtzEwYOst2iRs
        nkmCq5VHkSttJMGRnl2UUK9ls+CYj1U2rITtRLmGkMbtpm3Bh1f6OBwVx6W3uNSMP4bWJg
        dwdzoqhP7RSZaOktvNvFHfm2G4QExb8Dtv5yA4Wv8+HjK6Us81CdTm24mb78WQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643804933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=phquJAH/eFn2G1g+0c9hxUEOmuKdthHaUYI8ZgUETGo=;
        b=1UcHv4TDF7z0dR+4GRjPC4C7OjXFgpkK+TuXq6/oUKgvIP+KhgsBNtoVuVpjWY0+I9qDUL
        tJKu9FWAXy+oBuBg==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net-next 0/4] net: dev: PREEMPT_RT fixups.
Date:   Wed,  2 Feb 2022 13:28:44 +0100
Message-Id: <20220202122848.647635-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series removes or replaces preempt_disable() and local_irq_save()
sections which are problematic on PREEMPT_RT.
Patch 3 makes netif_rx() work from any context after I found suggestions
for it in an old thread. Should that work, then the context-specific
variants could be removed.

Sebastian


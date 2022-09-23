Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83875E7E5F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiIWP2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiIWP2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:28:31 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE23D1449DB
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:29 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id h21so254219qta.3
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=G3Q0bX2GcIFGlF7tZKdsRxe7i5jkRuL98YC2iGMce2Q=;
        b=OoxyzaVaXRR0KB61pnJle548b0B8I0v6KM6FuC2dTpCZiZJEZyHRiZrW5Sy/Il3CHp
         zQXq77bi920fxtfGr7oCCPySo1jcitXvXQU4U0zeeJtHjy15p6IRzaRSZhf7VfPNgj+r
         7YBzkPoekHPMT7DemnMYQZ5lOf/9nCIM0dlCf3YUiLCAr6Jmz7wwzEO47DCLljWbSHOK
         hnqMv8pTCypp/deIW6zDKHkTejq1as8SMG+ncaWOM0Kx0drYW3Fne4MwnMKfYrES/ozb
         fx8hkyXV3Bx0Xu0x5InRis5Np7aWpmJ1bNjWi7FHt2vyA92o9JXrKDAalI0+yiAd8Qdo
         7Vqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=G3Q0bX2GcIFGlF7tZKdsRxe7i5jkRuL98YC2iGMce2Q=;
        b=F3qQOkfOfWPwAKiG84TuIehk7+abnvvT0cnqH/BpF0wG4jxFn23Z+utE9rre7Wegqg
         gNRRMZb+Lhs5oGN45kNMPoVP6Td4R98dmmzsNeKTLTaYXkHtRupsxnvzPjerwxH1rZFG
         SQxOwFyTNCTJsBW30Yef6/kTJ4ljWpRjsLHUcJwsFtWYNXw+S/viPiGXpfOvhagqZ4XW
         Nai7RwAtx60skhC2Gv+BUPknsrCKy8kHjXqDCKvakJAXyz46TbxBn20gaWTEHqVQ684U
         MmHyJUSERvQfGUBdhO+HkgW8yjJWNRZMssq/dor/Zyb0VqYIv67Nw1ojwtnw5r/floWn
         SW2g==
X-Gm-Message-State: ACrzQf0OfeFtvo+b8xeCrHw6aSLTsgu0BoSCF86NmHaSdbGJJTJGAXAm
        oYxoo1Av+maTWMoikW4CdhN8RerVJ6dhNg==
X-Google-Smtp-Source: AMsMyM7WMGiwLFojZcPa171qebWA5JUvATWzSdrE44LzvwWAYY9NuwUdpvT/G622PFzFOgCAVwh0PQ==
X-Received: by 2002:a05:622a:54f:b0:35c:f68f:44c3 with SMTP id m15-20020a05622a054f00b0035cf68f44c3mr7559256qtx.546.1663946908728;
        Fri, 23 Sep 2022 08:28:28 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id dm52-20020a05620a1d7400b006ce3f1af120sm6623051qkb.44.2022.09.23.08.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 08:28:28 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>
Subject: [PATCH net-next 0/2] net: sched: add helper support in act_ct for ovs offloading
Date:   Fri, 23 Sep 2022 11:28:25 -0400
Message-Id: <cover.1663946157.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Ilya reported an issue that FTP traffic would be broken when the OVS flow
with ct(commit,alg=ftp) was installed in the OVS kernel module, which was
caused by that TC didn't support the ftp helper offloaded from OVS.

This patchset is to add the helper support for ovs offloading. Note that
the 1st patch is fixing a memleak issue, and also making the 2nd patch
easier to write for the feature support.

Xin Long (2):
  net: sched: fix the err path of tcf_ct_init in act_ct
  net: sched: add helper support in act_ct

 include/net/tc_act/tc_ct.h        |   1 +
 include/uapi/linux/tc_act/tc_ct.h |   3 +
 net/sched/act_ct.c                | 193 +++++++++++++++++++++++++++---
 3 files changed, 182 insertions(+), 15 deletions(-)

-- 
2.31.1


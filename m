Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33268258E38
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgIAMb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgIAM3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:29:07 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2326CC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 05:29:06 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cy2so392167qvb.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 05:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sVMMlKJ4kHyVyf92GjPgY/mqj6aMwyeJEfFh83cO6KI=;
        b=hJxlHDCnTNk2YHJuLoTZp0bXd9uuAzuBMOscBj/PUynGrB3dgMO4LdIETZA+kjNCuk
         wOauP/ZBX6wDDAXDCWpcvBVqjBLGEzw1J4WQE3p4x7tiH8hD9/f8wXIfLlr9zmAQG3xt
         CAEQOmlDEhpQ0jfXrG8TsNuwgJw0WfF+rWaVh2Shj9la5ndz2uTKLxtYsR2eh1kAGV8J
         ZxwRTZ+EeIwqBkK7YcVwGH22u8LaI9a6L6M/vZA+dkSWdDnYSg5ZrBuNF3QUQv9ttPW8
         UzZlixtKDGHjiH6OlsSEzjjZm5ynSz1cCo5WsW3t1CAH3+ptg9QMO2iQg9TlAT2Y4Jsi
         eQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sVMMlKJ4kHyVyf92GjPgY/mqj6aMwyeJEfFh83cO6KI=;
        b=RxlqbW+sNsDCfjaTVR1BdefYJ0HlMAt3vnlIXz1LkSDTybUNDsrd9eQcqr6E6wW3Qa
         UbNRl3JYxY7ynMC3gncUs+ArqhNJXETg+a7EGLxbbsDam+UjKl9TjV6o5YLUxfNfy123
         gTFlPcapiItWgCLICmEd4/IZUfKOIL4RonErRVaWdg1cgVN16XNDBmh+Am3Cp9lH7vVy
         fOj3yKkIMMvyN/rocze1tnlhIbcozc8NqR9GNQR6SRf4+XMLZ80fXmj9dFTj2m/HVcNU
         Hf1GSjT5dGpyTOspjetin3cr+2RlcMX/R5BTJ324J/tF3KwN/0OATMoZamdnoO2YS1GN
         STHg==
X-Gm-Message-State: AOAM5318XfWxqS2+1+WvEuYNk9nlXxwqz3qs1d5+3DDzLdnXxBN8aed0
        vUaeAHXfcd5lTESCMgfXikh5Lt1ZjBk=
X-Google-Smtp-Source: ABdhPJzsdbN1h0crlV70IxeQ2T1EqBfWGaqAnDjSDgBWrunX4BMJalLEorHnpmpt1n0hcB4ibadzLw==
X-Received: by 2002:a0c:cdc9:: with SMTP id a9mr1673407qvn.187.1598963345213;
        Tue, 01 Sep 2020 05:29:05 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id q35sm1174220qtd.75.2020.09.01.05.29.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 05:29:04 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     sbrivio@redhat.com, davem@davemloft.net, pshelar@ovn.org,
        xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 0/3] net: openvswitch: improve the codes
Date:   Tue,  1 Sep 2020 20:26:11 +0800
Message-Id: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patches are not bug fix, just improve codes.

Tonghao Zhang (3):
  net: openvswitch: improve the coding style
  net: openvswitch: refactor flow free function
  net: openvswitch: remove unused keep_flows

 net/openvswitch/actions.c    |  5 +--
 net/openvswitch/datapath.c   | 38 +++++++++++---------
 net/openvswitch/flow_table.c | 70 ++++++++++++++++++------------------
 net/openvswitch/flow_table.h |  1 -
 net/openvswitch/vport.c      |  7 ++--
 5 files changed, 64 insertions(+), 57 deletions(-)

-- 
2.23.0


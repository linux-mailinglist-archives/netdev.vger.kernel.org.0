Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C3A3B0833
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 17:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhFVPHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhFVPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 11:07:32 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBB8C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:15 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id g12so16256793qtb.2
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 08:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cy9nWVYH4bwacJuVh4FYcRJ+AuO6uVGg4X2LLrhCgVk=;
        b=oHX20sqOk26bv9PxW1jbz6WeE+SXz2T4QiUYNlSK4UMdLKaliIr3T6+Wwz+sFCorg3
         koAGCljSB613u6/QFnhJupKP53swpO/eo4GGotgxHbOtYngYLZ6bilqDVrQOiIYeiOuy
         QNXKPDb07YF//mpgu5vY4gTz+SOpjww47xAwm7FBKy076GjYo/q4Z6tBSnIn5rq7BFtl
         4+xnQbDS1psNX7SwSJwDv/V012TIyFUAASYwQjbhGqS65n08996YaNvWqg1Xi3y9STbc
         xgrCCwGO99Q7SfHMvyvdLwhGxdKy66PZ5nhfq2f3JZj0+sWaHHusmlqO6GTelkjOd7Cz
         NFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cy9nWVYH4bwacJuVh4FYcRJ+AuO6uVGg4X2LLrhCgVk=;
        b=qz6mdFDWmdqNFOXT6u0u02VtJbBWlinPGl6iqxy1g7HXXy3KBrf9VLMhlaAkIBuktj
         az2aGPfaNJLqJuHwCQ4pWry1trdtS7nw7t/ahZcy5FtZE1Y+vAcTiYPKlnY57WdZM6Pw
         ul3imM2kiyj0kPdIDf+OiaDeuGfQhqBlhkJsU+YJJoI4xnhllGVMx1mr1toaDEoial0V
         cJXfpV5XUe2TZ1KI69OMMoQ/CJLIPjF5SQe1UpF7lTPXxm2kA6xnoT335icx9No7myvX
         A0WSmXJj9u9DE/pcFuWwxgO9V3vDtRbSnCSsXvK9pRvM4oHq+W/AbmCJpKR7yO6jSJ7J
         sMZQ==
X-Gm-Message-State: AOAM533byqI17MlUpKzX5m6xkroFmYyBpqbueoRb3erpdUQzkq4NQYzI
        /pS7vj9F7gLo7FCwfrObrGo=
X-Google-Smtp-Source: ABdhPJyo01mDj0KCEnnGH+Ozb3lcZKbxfwrUqyEAcxtCxDc+hbJyHM8Ylk9sFai/3dwQoKzt9t9WAA==
X-Received: by 2002:a05:622a:15cc:: with SMTP id d12mr3758389qty.67.1624374313344;
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f016:6106:596a:c2e4:c4f2:9f1e])
        by smtp.gmail.com with ESMTPSA id t4sm13211312qke.7.2021.06.22.08.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 08:05:13 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id D8687C0781; Tue, 22 Jun 2021 12:05:10 -0300 (-03)
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 0/3] tc-testing: add test for ct DNAT tuple collision
Date:   Tue, 22 Jun 2021 12:04:59 -0300
Message-Id: <cover.1624373870.git.marcelo.leitner@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That was fixed in 13c62f5371e3 ("net/sched: act_ct: handle DNAT tuple
collision").

For that, it requires that tdc is able to send diverse packets with
scapy, which is then done on the 2nd patch of this series.

Marcelo Ricardo Leitner (3):
  tc-testing: fix list handling
  tc-testing: add support for sending various scapy packets
  tc-testing: add test for ct DNAT tuple collision

 .../tc-testing/plugin-lib/scapyPlugin.py      | 42 +++++++++--------
 .../tc-testing/tc-tests/actions/ct.json       | 45 +++++++++++++++++++
 2 files changed, 68 insertions(+), 19 deletions(-)

-- 
2.31.1


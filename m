Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D96C2925AD
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgJSKX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbgJSKX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:23:28 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEA3C0613CE;
        Mon, 19 Oct 2020 03:23:28 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id q21so5742966pgi.13;
        Mon, 19 Oct 2020 03:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYGxHRGFXfXxMQCO99EESIGoh+K24yX2RgTqdp0oh5U=;
        b=mQzzV8/ZTmJuSNAdZVJZxxa6lIkN+bItJ6mBN9lGPlsG8kFbRS9HWOj6aXuwwia5bi
         wB+2TZMqBBsc2LMJJDC3loikEFDW3llawlZoujVhFrtr67nIOYMgPi+1zPL+6qzUyNqR
         63OZEBMDGeIjN86/vhH1HPlSFso/mfmSo+ThrIPY0lbswRG++VgIwivFK4IR+6Fxg6Fg
         w7T/eFWMbaV3S/iySzg3MBoXGAznXHot7uZh0k+x6pqUQlttTtzmWs/Vk+eJDl3FUeMp
         sjYmh1GRQqFQwNhq2RsRSmond50ZSbQPa1M445NrY2H+YhRI1/s34vKO75uhQ+2EbeUl
         B7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYGxHRGFXfXxMQCO99EESIGoh+K24yX2RgTqdp0oh5U=;
        b=RS5P/hWTLh+qYlSXMk3DzZOkzlluXaHVgD7XHfTM2fMMPDHY2nwn9vXQz1ZkXtfVoc
         nSfJhhSEgck6hloBO1dsE4LkbqbHDB59Tom6hKjo1gkwDMNx3+07/Ugc78DiH6co526k
         kBiAmnbvmagmTq1zXI42SyUR7EvepgMTihSi7Bxlq64Qcbnit1Pj9bxAuwFKu05UsmI5
         rWsHGAyZ4oKNv88Oc2oCb7VgKLezhLtqV0ySPuIK+1bRabD+NoHvvWrZTfLhFxr7aFSz
         N9gbqGVe5TvDi6H8F8DjB0wyNpB+5zQgbeNQhyyZHa+4yNIxV4EzZwzA8MLDqArisalV
         j0bQ==
X-Gm-Message-State: AOAM532RvNNatAAV9bfx91urLmhP7pjyGIexyyabRsimzot5WbOrM2PC
        l+EywaciP8/xMy6GdvU7yLUks9v7210RBA==
X-Google-Smtp-Source: ABdhPJwdGh2lMDZNrEgg4+tugCnk8nL41Dg2ptqGSTqo2Xpi8iGiPh+LvqOPeNh0i2rA/JngC3Kn2g==
X-Received: by 2002:a63:654:: with SMTP id 81mr13184795pgg.27.1603103007599;
        Mon, 19 Oct 2020 03:23:27 -0700 (PDT)
Received: from localhost ([2400:8800:300:11c:6776:f262:d64f:e94d])
        by smtp.gmail.com with ESMTPSA id q14sm10761319pgl.38.2020.10.19.03.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 03:23:26 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 0/2] init ahmac and port of mptcp_options_received
Date:   Mon, 19 Oct 2020 18:23:14 +0800
Message-Id: <cover.1603102503.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset deals with initializations of mptcp_options_received's two
fields, ahmac and port.

Geliang Tang (2):
  mptcp: initialize mptcp_options_received's ahmac
  mptcp: move mptcp_options_received's port initialization

 net/mptcp/options.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.26.2


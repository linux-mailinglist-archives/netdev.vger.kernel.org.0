Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD0D29FB3E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 03:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgJ3C3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 22:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgJ3C3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 22:29:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579C5C0613CF;
        Thu, 29 Oct 2020 19:29:41 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n16so3906742pgv.13;
        Thu, 29 Oct 2020 19:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wC9KOii5QLLdiCrCmEI/kxJqoF1uKhLCIUYhutpeiaE=;
        b=dHRq+eE/hWjf3xfWZ1+SllOQ6NwkmhYK+DPmR7eYXwnXQERmpLV2HF+XzgH73sK+zl
         ytG6/b0qFI+aY3Pm6aGbiEkcNCJ99tYlwUwcbTG9J9rBerp4bPmyiAA5v2WQsfSSbmHL
         SL73eaUGbNFcdyuBdHJxhK1tiFgv8p6/buw7xF+dmkzTyifx3pqYFpjeWzVmLgkqCuzZ
         PSB6XRVYKQZJ/AMQRU2o9ZsLimSBqeB7EF8VzZzKPjgt5DUL2yllyffhTY+t2tMNJ6Ta
         oszKjGiXzporYUXFKbyOJ1jyn5ZlT7MJksotJrP15mGITZuPDlpf6MdyUBzGIh4S43B/
         OH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wC9KOii5QLLdiCrCmEI/kxJqoF1uKhLCIUYhutpeiaE=;
        b=cOQXYzRxc7K7dS27+16wTKG1buwlh7l40h6W7C+Zi/VsDU9mOf3PKiYf9/gUaDohvT
         6axBW5Coih8hbsFiDiwcI//YyBUo+ZzDMu+ernxddqOv3Jt/tG6NwLBIjjbV0gEGV66m
         slpBmdoX+eifz7BPUQo/9XqbceUlODu+Nrk13voYgH7pqxQzQoGsRjoPPpDymO3shHOD
         9kz9QunrGYe40txZvv8/Wr8+OyKR3b9tNUtSXxstsrBfJ0jb6X59xo3GehHmQJM4Eja1
         ULMhKZG628VvX48PEObwMHQ9/KcpHhHhds8/onSLS8NA/zduf15g0PKUyBHaTwKjaI3J
         6nLg==
X-Gm-Message-State: AOAM533JVcpI0ZUFn005ABO77bgwVYkOyVTaStXuiXPLwX7lmUCwf8rE
        dJczynUIDBwYqIfSOSWs840=
X-Google-Smtp-Source: ABdhPJzP88v0Sy+MXIs7Fyy6sJof8VOp5x7mcK3EjQYNGTv+KDCldafUTM2uKqcbnlDSJQZlXQ/7ww==
X-Received: by 2002:a17:90b:3882:: with SMTP id mu2mr131181pjb.112.1604024980978;
        Thu, 29 Oct 2020 19:29:40 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:dd13:d62a:9d03:9a42])
        by smtp.gmail.com with ESMTPSA id i24sm4216588pfd.7.2020.10.29.19.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 19:29:40 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next v4 0/5] net: hdlc_fr: Improve fr_rx and add support for any Ethertype
Date:   Thu, 29 Oct 2020 19:28:34 -0700
Message-Id: <20201030022839.438135-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this series is the last patch. The previous 4 patches
are just code clean-ups so that the last patch will not make the code too
messy. The patches must be applied in sequence.

The receiving code of this driver doesn't support arbitrary Ethertype
values. It only recognizes a few known Ethertypes when receiving and drops
skbs with other Ethertypes.

However, the standard document RFC 2427 allows Frame Relay to support any
Ethertype values. This series adds support for this.

Change from v3:
Split the 4th patch out of the last patch.
Improve the commit message of the 1st patch to explicitly state that the
stats.rx_dropped count is also increased after "goto rx_error".

Change from v2:
Small fix to the commit message of the 2nd and 3rd patch

Change from v1:
Small fix to the commit message of the 2nd patch

Xie He (5):
  net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
  net: hdlc_fr: Change the use of "dev" in fr_rx to make the code
    cleaner
  net: hdlc_fr: Improve the initial checks when we receive an skb
  net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC
    devices
  net: hdlc_fr: Add support for any Ethertype

 drivers/net/wan/hdlc_fr.c | 119 +++++++++++++++++++++++---------------
 1 file changed, 73 insertions(+), 46 deletions(-)

-- 
2.27.0


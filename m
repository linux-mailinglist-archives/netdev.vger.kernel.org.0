Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0105E118657
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 12:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfLJLdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 06:33:13 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46845 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfLJLdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 06:33:13 -0500
Received: by mail-lj1-f196.google.com with SMTP id z17so19406879ljk.13;
        Tue, 10 Dec 2019 03:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WlGOel6ozfYcbJC1frR6+E7yE+Nd4baR7fkyrQ2PmS0=;
        b=i1s+4i6EBuU2PD6JVHtFxqWCevgaVCBY5TF1R3eXCSU3ZdjRJsD0oebvpAc3LGU24a
         iCxRMHzB4tFlL9lSyFzP4D0vW2WA9nhkly1a8Nytpof4PWgOqi+iDBoh3kruaRBMlZMG
         23yqVkJHHMDsThV2I4je/8mQlrP5GrxgTpepcLNoh9kCsjjTem3OEkh+PGZ1eR6tmXAh
         BOA8Mwx1ogjawlC7UIlDoHW/MvM6r6MlvsDdAlTemoIG+ZjWQv/EWBpCjDvqYBGvstxN
         XhmR9BFembBNVwWoaMOCboiyyYCNbDJaO8629RsU/G2DQIbvMEhGBqk4S5CZj0xmWDhN
         ZM0Q==
X-Gm-Message-State: APjAAAUQN8r0uaA3DEuOwHRE0zy1LKVCYfrB/TGzuupLO9FuS/PbW6ou
        8Ppe3qH1dn/YW/xVrHjMWspD5tnr
X-Google-Smtp-Source: APXvYqwqtzkU4Y+fFg5i+yyr3JEyChJTSJMRakvsyHC/azNkKky5OQGCDs6kpPvEn/dcofvIfWjlYg==
X-Received: by 2002:a05:651c:208:: with SMTP id y8mr20383413ljn.36.1575977590457;
        Tue, 10 Dec 2019 03:33:10 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id p26sm1391436lfh.64.2019.12.10.03.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 03:33:09 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iedlP-00010K-Tm; Tue, 10 Dec 2019 12:33:11 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/2] can: fix USB altsetting bugs
Date:   Tue, 10 Dec 2019 12:32:29 +0100
Message-Id: <20191210113231.3797-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had quite a few driver using the first alternate setting instead of
the current one when doing descriptor sanity checks. This is mostly an
issue on kernels with panic_on_warn set due to a WARN() in
usb_submit_urn(). Since we've started backporting such fixes (e.g. as
reported by syzbot), I've marked these for stable as well.

The second patch here is a related cleanup to prevent future issues.

Johan


Johan Hovold (2):
  can: kvaser_usb: fix interface sanity check
  can: gs_usb: use descriptors of current altsetting

 drivers/net/can/usb/gs_usb.c                      | 4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.24.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 079FC86D9C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 01:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733140AbfHHXG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 19:06:27 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42771 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHXG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 19:06:27 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so70206425qkm.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 16:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tD9KLKaPYUIea5/ro/f5ME8+H1d+ru5pXxbf51BpLY=;
        b=FpOF41mI49+NFybKfPhZOncZF7jvPbgfhdZXohROmDhUFFrGRsI09iqr4vRYAGq4QZ
         lLXJrdcxCZBfRi+nFEgefC10kFOVlSFJP5Pq+EvgOlami3GVTEjl2+eBcidaFL5JXcey
         nvq3OhSIzsJqfDBSQ+NbFqGyRqOoaDWjkCLfw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6tD9KLKaPYUIea5/ro/f5ME8+H1d+ru5pXxbf51BpLY=;
        b=MSCOPxCFgVUw/HDAjImy3o/htZypF6aXEz1k8IhdmvpF4lhimI8uxF3AV4KQilsBTX
         heVCZXgfAykl1bah2hmbd0b0MVg+p3rqJIyNK8SHibxQS9H7PI5TtKEdyMEZoAQgm4E7
         +Utn1yCzUwYvyTR4T+1VgRXWtl7DBcajCWRpOUiO9Y1S9JzgsNwM65NzPH5uIQ3v91H3
         wbD2+MWAfzBSl5kkM2iRe3HOfujcLlV4xhUOqh5bw2Ng2or6xeXLNar8gWcLXBYZdMTT
         7zoocRDjSh+IdTUZccaHem64g+mjIg/pVSIhpuI5sB8yG0quAKbqr7rhGozAEnvJ2xV7
         fUlQ==
X-Gm-Message-State: APjAAAWgxqo4VdJpuo7xIuyS3m4Dqxy0RO57Vynf+iGkSkuVLVdJYlCS
        ZfFUEbnxKMUnzUIR2yVjQTmU1E/WSDza9w==
X-Google-Smtp-Source: APXvYqwJUN4SlSbL1FVmOhK75V38CtIZD61w+KekSzexKUgwFjVvQjGmoeEQLUXCG1gySvnpDf3LPg==
X-Received: by 2002:a05:620a:1413:: with SMTP id d19mr15410159qkj.341.1565305585847;
        Thu, 08 Aug 2019 16:06:25 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id u1sm51299554qth.21.2019.08.08.16.06.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 16:06:25 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     Matt Pelland <mpelland@starry.com>, davem@davemloft.com,
        maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com
Subject: [PATCH v2 net-next 0/2] net: mvpp2: Implement RXAUI Support
Date:   Thu,  8 Aug 2019 19:06:04 -0400
Message-Id: <20190808230606.7900-1-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements support for configuring Marvell's mvpp2 hardware for
RXAUI operation. There are two other patches necessary for this to work
correctly that concern Marvell's cp110 comphy that were emailed to the general
linux-kernel mailing list earlier on. I can post them here if need be. This
patch set was successfully tested on both a Marvell Armada 7040 based platform
as well as an Armada 8040 based platform.

Changes since v1:

- Use reverse christmas tree formatting for all modified declaration blocks.
- Bump MVP22_MAX_COMPHYS to 4 to allow for XAUI operation.
- Implement comphy sanity checking.

Matt Pelland (2):
  net: mvpp2: implement RXAUI support
  net: mvpp2: support multiple comphy lanes

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   8 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 129 ++++++++++++++----
 2 files changed, 110 insertions(+), 27 deletions(-)

-- 
2.21.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C977F3900FF
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbhEYMaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhEYM36 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:29:58 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490EDC061574;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id g8so15427947qtp.4;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXYHSIX/xJjOruv2I5WhLwdataTV5jsXvkBmXTL/M2U=;
        b=Q4z/p4h19s6FG+Wf7F20Ym8tcqv8gwMVu0X2+yegndPhxrKdR0vrZ5i+KWsBMj0t06
         3hhBRO8EMWzGnwG9yrebJmM+B5hoXn9OQ1QGOfC6fllv7RCkq0V+zfPzAJD010j9lYmx
         k9Xm22sXDtuoq7n/AhnQpjIhicZvdCE7bfDI6fCfRct1COd1Gpx1VpGWo3DDw23XgdMY
         WymHilh1gCNpnvbpdSi7Y31Ian0iuaCpAi/cO9kfxukRimZ6xnwStZR1wTqGhkq/9kZR
         1mld9z5NsvoKWnTf5fLTbNzCgm6OhAMd/FpE/uxyQkK/g6fluY5SDCU8VJaZbxkDPpcC
         50nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXYHSIX/xJjOruv2I5WhLwdataTV5jsXvkBmXTL/M2U=;
        b=Z3oIMYpFOXy8L5YuhEBNaWJ61uaoNrpSmSaMEqHSWLKAw/ex3ASC8MMy1bJXghl85F
         Uc6g1mF7XnP9QjtfIzevRw7WbVMNLje/zIrrR2goJK3pEZzlGmFhsmf2iMrnjHOX+s4A
         cS2zaobr4Vsn1cGTb8SHQQOnyA98DMwrzUqoFy/tF2QJSP1qqOBZTuuJFR/1PzMqn4kt
         o2l17FstACP8nHm5or8fXt3HmbGmd6ACSdE29fqseqCsDXbBC+bbkr9NvDeiUV7jsfYR
         aXAmV9RewIkm9US+ejH4daBTe2WS/dLroiY2drFPxuVVq2CpOMNZmJVoIB8fPkIf6bH8
         9OGg==
X-Gm-Message-State: AOAM531OlPwqEPg8MN9l1K/5Tm+vB5D0v2vjw8dlH0DWXEtlgw+sEPh7
        sOPy50+UvTQq6AO6CNSssWY=
X-Google-Smtp-Source: ABdhPJyrwZnQmDXRR/oLCqgHcx81xU3K7Kz5OcR5N/xp0yezaq084sJ9IehmVrEW+QamBDcZ3Gy07w==
X-Received: by 2002:a05:622a:183:: with SMTP id s3mr31922015qtw.115.1621945706375;
        Tue, 25 May 2021 05:28:26 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id t6sm13292572qkh.117.2021.05.25.05.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:28:26 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>
Subject: [PATCH 0/2] fixes for yt8511 phy driver
Date:   Tue, 25 May 2021 08:26:13 -0400
Message-Id: <20210525122615.3972574-1-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Intel clang bot caught a few uninitialized variables in the new
Motorcomm driver. While investigating the issue, it was found that the
driver would have unintended effects when used in an unsupported mode.

Fixed the uninitialized ret variable and abort loading the driver in
unsupported modes.

Thank you to the Intel clang bot for catching these.

Peter Geis (2):
  net: phy: fix yt8511 clang uninitialized variable warning
  net: phy: abort loading yt8511 driver in unsupported modes

 drivers/net/phy/motorcomm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
2.25.1


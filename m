Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F3127079B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRU4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRU4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:56:41 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA2DC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:56:40 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id b79so6833136wmb.4
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura-hr.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5FMcTfB8bTNiA4IO/9hnI5vPpMpLqnjxtoFBZxrk7cE=;
        b=qcmtt6kWrvx7k2QXabW17gKwfCLKlGN7MuLc+YURLF3y8JXAUupyBXOWPXzkOgERbd
         heeBiEW3ckdFgeef0CSxlO0KtTGJyCZaSvzAhOvhG3zYvWbJPbI5yMwKN8nZrtOObvNU
         EFfpfdmivw7K23hKCFr3u8dgqBnonLw60yviyWEGBRhij5x2Sh2mshRSDU8YePF1rOSX
         aufFYW2i4xmv1RqpXOiLpN3mPPuFd2/A7rSbYVdI7KpyYVyCeVMFBJhWxma+qfnzw4W+
         ZkxjFzBtR43RbJ84MAq6elE6PZsg7F2l2Xv5N12JZ8zDFv4ME7WO/RHJNwQ9F42D5ifI
         scbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5FMcTfB8bTNiA4IO/9hnI5vPpMpLqnjxtoFBZxrk7cE=;
        b=EQINeaBjdrr4H8A7ivUneVsvHNuqLoJkAxkcyXhbz8hLYdeozNgwQ0pYR8EFFGRJtY
         TG0oPIEhuxEERtns4MquEqyEFNptaFRhlRwdiN8+RuzIDpPDdkajZSFjQYTqYtVQ5hXh
         IWupAHunZB+4OsrlOecwPHkAjs4alfnoYRHKivDp+RYX9TJvyM7LoqQmr6CK+sSu9S0w
         QHMlB5s94VJY9idRn0gb/OwfRylIUyi4LRKBQZN6y6TrQHc0su8eCGZxih6c1KtSslLM
         EwG1MGeWB6qKPeiD0HCE5NTzb9+QsSo+DEb8Bd/BlJPuZowcB5xZfitgR7zZ2xBzMFLk
         RRlw==
X-Gm-Message-State: AOAM530SZruI9UOJ8OTv5LDECffwpNQQeaEDGAf65z7+k+Tlc3ZK90oK
        eU0ZdbslS+xDGfrrmiwfbdzsVg==
X-Google-Smtp-Source: ABdhPJzhy9TPwdBBkuXxPyaO8NB4E6vvhIn4upUGvLx5IuAD7USpHZ5JEqUfW7aw5bNhdX0/RP/s0g==
X-Received: by 2002:a1c:f20b:: with SMTP id s11mr17966461wmc.144.1600462599324;
        Fri, 18 Sep 2020 13:56:39 -0700 (PDT)
Received: from localhost.localdomain (dh207-97-14.xnet.hr. [88.207.97.14])
        by smtp.googlemail.com with ESMTPSA id a17sm7661875wra.24.2020.09.18.13.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 13:56:38 -0700 (PDT)
From:   Robert Marko <robert.marko@sartura.hr>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v3 0/2] net: mdio-ipq4019: add Clause 45 support
Date:   Fri, 18 Sep 2020 22:56:31 +0200
Message-Id: <20200918205633.2698654-1-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for Clause 45 to the driver.

While at it also change some defines to upper case to match rest of the driver.

Changes since v1:
* Drop clock patches, these need further investigation and
no user for non default configuration has been found

Robert Marko (2):
  net: mdio-ipq4019: change defines to upper case
  net: mdio-ipq4019: add Clause 45 support

 drivers/net/phy/mdio-ipq4019.c | 109 ++++++++++++++++++++++++++++-----
 1 file changed, 92 insertions(+), 17 deletions(-)

-- 
2.26.2


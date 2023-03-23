Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76666C6804
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 13:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjCWMTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 08:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjCWMSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 08:18:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957692A9A4;
        Thu, 23 Mar 2023 05:18:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso962925wmo.0;
        Thu, 23 Mar 2023 05:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679573889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uj+aw3apcrngUKPRPMLcr3+lEjlXqcsjWLD6qpEOggk=;
        b=TF0d7dKohXIKjb7c8hyxSb7c5lHmmxKYxeEB4IdaNIiRbwDGomXW4CgSA3vkUfxzff
         dDN0myOv5QrS41t0egR22SaFe3Y4JvFd30+U1CEZ6xMMdGpJK23hUwQSAc/n0tkZDo8o
         ex1TUa5TouJlbJWgtZmgDpMptuxdUgOavi5vcH9EtXWgk74n8UguSkDkzMmBNWHDSMsG
         CwNhQVIJeSVvq9VxVbtNn0dOEfMY+IwV2g7hNsVuJxi2v2gQhSDf+NhQA+tv+X80OOBX
         7B/g/2ozAdC1ts48OmlvT78zVWLlwNFFtN/KcUt/bk1p31P4na9AETAXFied9LOrFaJG
         L6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679573889;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uj+aw3apcrngUKPRPMLcr3+lEjlXqcsjWLD6qpEOggk=;
        b=BUBy5YxJBY29C0HAoH7GuKnADvIp3YmVXWjLI10P2K+ep1+Cit2Bx4jHME+Qtz0ebh
         KyxKiArvGOOaypVEnSXD/3Ki8dXZfOHD9UKQAlvlWOxBd2BLlNbYz54DHB7+glI2Wjj/
         rR1aU0SdUMvRCQm4tftkppc2PS95fQlUuakCvyW/w2zKFNxlEfiHBIZ7L+DSd18Sw5KI
         UUW6M3y2XANwSm6dF8zd9QpuDMg2ug7E5q85d2cCSWAhsSSZD57CXCQPTlYDneHakfOl
         7vFTQwwaGJBDzO7fvrnCVWsQTGyjZQZrVgM6FOp6F4mH7M3LJzVV7NTXt3GZuvFzi+NR
         IJAQ==
X-Gm-Message-State: AO0yUKV7WEX3bFzrycVShq1IOBQr/p2oe7mCYPi6Z0LjHhZoWYjJzqK7
        ZRoYeKVWZZXZ8xmOffbEe2j486vRD6gn7Q==
X-Google-Smtp-Source: AK7set8sEO6zWznvdyLxUSqq0Is9pWd7OtpzJocvsfooi1VjntGrKUFRzSy5MD+WB6zljvbfPfy4Fw==
X-Received: by 2002:a1c:6a06:0:b0:3ed:88f5:160a with SMTP id f6-20020a1c6a06000000b003ed88f5160amr2089189wmc.11.1679573888683;
        Thu, 23 Mar 2023 05:18:08 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003ebff290a52sm1760211wmq.28.2023.03.23.05.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 05:18:08 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     paul.geurts@prodrive-technologies.com, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 0/2] net: dsa: b53: mdio: add support for BCM53134
Date:   Thu, 23 Mar 2023 13:18:02 +0100
Message-Id: <20230323121804.2249605-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is based on the initial work from Paul Geurts that was sent to the
incorrect linux development lists and recipients.
I've modified it by removing BCM53134_DEVICE_ID from is531x5() and therefore
adding is53134() where needed.
I also added a separate RGMII handling block for is53134() since according to
Paul, BCM53134 doesn't support RGMII_CTRL_TIMING_SEL as opposed to is531x5().

Paul Geurts (1):
  net: dsa: b53: mdio: add support for BCM53134

Álvaro Fernández Rojas (1):
  dt-bindings: net: dsa: b53: add BCM53134 support

 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  1 +
 drivers/net/dsa/b53/b53_common.c              | 53 ++++++++++++++++++-
 drivers/net/dsa/b53/b53_mdio.c                |  5 +-
 drivers/net/dsa/b53/b53_priv.h                |  9 +++-
 4 files changed, 65 insertions(+), 3 deletions(-)

-- 
2.30.2


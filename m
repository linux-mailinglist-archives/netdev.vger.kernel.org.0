Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5462B6C7A0A
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 09:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjCXIlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 04:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjCXIlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 04:41:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3390014EBA;
        Fri, 24 Mar 2023 01:41:42 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b20so4963038edd.1;
        Fri, 24 Mar 2023 01:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679647301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VhIbKp/cdaR7KG2mUXCuU3y5luof7KJ3q3EXu4d27ns=;
        b=Xumyd6wYz6Es2LKDOAmWafHJDXNsC4Ppxwzu3mQXLIC4AXG+/K2QqonTQXIkUxq77b
         3GfkARFidYWMjwTROTDWRHkzamHUC2v/g/24lKYdHLojOZL8n51IdDCJI1RwWjcJdbkO
         SwAra52EtQv4x1K4iw+R654BJsBcMbUwZpqAnQE5ZS4Aw4loDpmqGgasCHaX4Zhq9FIA
         SJ/CYGQpl47zsVRo5P9fLI60Gpotc30yt4NQZbBB3/zEAeLoSnpvBKCKlr0NtjKA6b7u
         jfu29a2wB5Ka1e485z4BPCBLMy4bYiJOkTrI8ubezyU80loDG6Re4torniDiQKFuUhj4
         uZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679647301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VhIbKp/cdaR7KG2mUXCuU3y5luof7KJ3q3EXu4d27ns=;
        b=2k7BCcKG18qRXadWYBPxjtWgjwFrGGchW1A4vTHSYXC5FGAS4Da04iRbh5O2VIco8H
         eUJAP2YJ6EMSsCoT6G7gWoQxpzGPUMzWIxIsod2rkV/W6gaKfs7jBgqgpclcNlUEIBQF
         u3OXzdrbzvBjBRnzrbTHuXUTfG+OOClxzYQhxi1bjlg7PXByb2BWKiRKHfV6a0QmpWBP
         0d13mou3gdYEmM6v3KtOWgBsXW06VrM5f4wpGHSbVtzu4ZbJNGkgQ+bitYwVnHRB+N7w
         A58GXLfre49I5Gq5/ABQqEi0Px1GtkNXRkDDp7wE4RfUD22J2cD3L52nNdYNaUOJlPwE
         bs5w==
X-Gm-Message-State: AAQBX9et/Sq3shjfTggCorCrSCafgt5oIbgrmfreyVCEocnxRa/D4CL2
        HTFsONIsuSS3a4p524Z/ml4=
X-Google-Smtp-Source: AKy350aEivyWNZNxITRXTiae8Dr4OYIBWUi6Zy3rdXwMvc41+KRK7G2GXB893+nktohsjUer/zAh/w==
X-Received: by 2002:a17:906:2ecd:b0:931:636e:de5a with SMTP id s13-20020a1709062ecd00b00931636ede5amr1763406eji.31.1679647301484;
        Fri, 24 Mar 2023 01:41:41 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id z21-20020a50cd15000000b004acbda55f6bsm10323728edi.27.2023.03.24.01.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 01:41:41 -0700 (PDT)
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
Subject: [PATCH v2 0/2] net: dsa: b53: mdio: add support for BCM53134
Date:   Fri, 24 Mar 2023 09:41:36 +0100
Message-Id: <20230324084138.664285-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323121804.2249605-1-noltari@gmail.com>
References: <20230323121804.2249605-1-noltari@gmail.com>
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
I've simplified his patches by adding BCM53134 to the is531x5() block since it
seems that the switch doesn't need a special RGMII config.

Paul Geurts (1):
  net: dsa: b53: mdio: add support for BCM53134

Álvaro Fernández Rojas (1):
  dt-bindings: net: dsa: b53: add BCM53134 support

 .../devicetree/bindings/net/dsa/brcm,b53.yaml     |  1 +
 drivers/net/dsa/b53/b53_common.c                  | 15 +++++++++++++++
 drivers/net/dsa/b53/b53_mdio.c                    |  5 ++++-
 drivers/net/dsa/b53/b53_priv.h                    |  7 +++++--
 4 files changed, 25 insertions(+), 3 deletions(-)

-- 
2.30.2


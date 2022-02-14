Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E245F4B3F5F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 03:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiBNCVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 21:21:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiBNCVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 21:21:13 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7988E55489
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:06 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id l43-20020a9d1cab000000b005aa50ff5869so10734183ota.0
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YAglB4GVOKipk35qUMqvzObg9akmFK63RMOZvXbnD2Q=;
        b=XpnEUMiE2aNI+XhOJ1ZVI32tn5soPlSnTyw/CmARId3bgFAVVAkcnVD0AEXxFforiA
         wfsz8iy1oOyS/oyUE106ba8/geFqxdsCBRbaAl8xDDBf8IKggewbsXW6r3ZbU4PrH5mO
         HPDxekT/ug7E02w0aFzxQrUAESm5kUdWZXhKzzmHHJihvhvxM3LDNPVslLsrXLwc5wYl
         Lt+kAawB2A9Zk+FBlTTqoVW6PLe/qs5VLhhQQ3BrWtySDwNN2wHhIZdNE7rr4Q2Nr+KD
         tv1FmKgynymzbWO/vVg9rCkmD5jGL7knDCEdRNTLECBsP8wl6Y28MzrnSRslikcOZ0fY
         d/BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YAglB4GVOKipk35qUMqvzObg9akmFK63RMOZvXbnD2Q=;
        b=LVFTxg3Q8cO/FmDbxXJal7WLrrbNAhzjLNw28KwCRNj6154h/y1W47KNjSLpSfEm3X
         Uv6QF8Kz3lUgZH4hsvw4ZHdB6tNBZVkwxMMpSsuwPjBYBxG6mrDLn9El+9dmI6hDj8hV
         75lI22jzgUXJ/sEYxv3OwPNeJVEsQZGdTD/HMBJf24QmABTJP+FwChpXhaEwJm+xqIbz
         SGDxAKAU7Pl2SzvyQchKgm5H/xiwG8uNY1/KNMzfUwzMSFB3qV+fsLJOLsOZJIUnV0ZH
         r1GItTSDgR0bwtiHHCZNYdUZe4TWCXz5Jg9sTBmYEYrWXC6oRXUuF3sZRZn2GnATI42l
         VBqw==
X-Gm-Message-State: AOAM5339OArCMrurlnbEKPl+3pHnDgQdCttsBUV48Xxvhyq7vFawAwSm
        AO17F+LtKov4G1VRCz9r+vzZR5K0l0cZng==
X-Google-Smtp-Source: ABdhPJyIWBsSXCOqjT4quIPeo7UCt78s18oaqPYFMv3Z4CweVUe0RHxaskq4n+olYcAWf/h2bkaYbA==
X-Received: by 2002:a9d:2f25:: with SMTP id h34mr4301740otb.346.1644805265437;
        Sun, 13 Feb 2022 18:21:05 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id h203sm12321150oif.27.2022.02.13.18.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 18:21:04 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next v3 0/2] net: dsa: realtek: realtek-mdio: reset before setup
Date:   Sun, 13 Feb 2022 23:20:10 -0300
Message-Id: <20220214022012.14787-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series cleans the realtek-smi reset code and copy that to the
realtek-mdio.

v1-v2)
- do not run reset code block if GPIO is missing. It was printing "RESET
  deasserted" even when there is no GPIO configured.
- reset switch after dsa_unregister_switch()
- demote reset messages to debug

v2-v3)
- do not assert the reset on gpiod_get. Do it explicitly aferwards.
- split the commit into two (one for each module)



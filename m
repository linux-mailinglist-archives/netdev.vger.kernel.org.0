Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9634585867
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 06:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiG3END (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 00:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiG3ENC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 00:13:02 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC3520F49
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:13:01 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v18so6145187plo.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 21:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=aiYnvpKonz65UJYWD2hOyrtF6ZKNBJka6fujfOwK1S4=;
        b=4auF3FvHvVEr0Xsx6Mj89RdsuQgzeLh2/taHaEbLn/zhjOcIFF0/rQSKa6GOeoOwiN
         FT9ys6rHGbPNJy1cSJXJyzPYiYXdEFj5PnxC21TDnuyxnpCAhNJoVKLhlKftHH0e4MfL
         w0gAtxOc+u3yYQp/PUS9inMFEa8hsc64ShmNRKG1iXDcIVasP/CCLzyyBzMsM1e5zQWb
         ryZm63AXmsR2ofjZ7QZiukBrgbuTXlVw0gszCSmtVe6J0uZ70FXvVKZBmUDl29k5vsCk
         sFHPXBpVu3gp9iqthEw7xr3TTY2Lnn4MweH4G/Ch8KupywskIzAnRGDK1/f6kw71VUzI
         QIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=aiYnvpKonz65UJYWD2hOyrtF6ZKNBJka6fujfOwK1S4=;
        b=3h2dX5hvXigzHXk6aqzxN2CQG7pIz5lH+Tz+Z603Tnnf2tZ74ep+75mLEk/m428ubO
         3dOxXunnY7dHAriIHFjDV5Ne7Z1gjj1t5fiSCj14ROm3kqq4Qi1eZkl9Ry7lzrI6f/nc
         NuuW7yQd4Ux+M6019L993dn+AAL/N841tvKQRM4UC9Yl/UPe76UsKogTgFzECPadx5+Z
         nxmvVlLET2sM0BPhUVSZlX8P4QmTGJEOaEdjNYbSErod/gTVQ4oU0Gy0o4BrtTeGjVD9
         cGW1KV1lPao9wGmx+w01u9d1EGE1deI2albknuFeFOFTN3/IcrKuN6ilt0oZP5sT3DaB
         AgPQ==
X-Gm-Message-State: ACgBeo2rftwqd+FjYKnpGQeueykEqcefibkpFXGCulDaUDnp3jwhfTog
        2WuMpBs1raQgSFIp5L5Ki2VjX9lJFdfrAA==
X-Google-Smtp-Source: AA6agR7LOdUOprry0nRUVm+Yv7uKAaFJXsC0xHIKoNONTT3QEwqSEPUw2kbVepWa66f1AXLlUNlzKg==
X-Received: by 2002:a17:90a:ac0e:b0:1f3:2507:b532 with SMTP id o14-20020a17090aac0e00b001f32507b532mr7714038pjq.48.1659154381132;
        Fri, 29 Jul 2022 21:13:01 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b0016da68b09b3sm4465725plm.87.2022.07.29.21.12.59
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 21:13:00 -0700 (PDT)
Date:   Fri, 29 Jul 2022 21:12:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Is it time to remove decnet support from the kernel?
Message-ID: <20220729211258.52c3ab81@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We removed decnet support from iproute2 several years ago.
Seriously doubt anyone is still using decnet on Linux except in a computer history museum.

Like IPX, propose it gets moved to staging in next LTS?

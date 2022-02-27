Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE3A4C5932
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 04:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiB0EA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 23:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiB0EAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 23:00:25 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C731DAC76
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:59:50 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id l25so10686154oic.13
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 19:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0Tx0szTuVegwtuiTM0BB8Oqc2q+Q6tNFAqvCkzwnbg=;
        b=S3RXkt5GcdPWewnp0nFddovvXeG8iw17hnR8OcQT7CNbG9126aUxXMVkZh0KCp/U7o
         aXkdKyWGCraw2b93OfE62bB2bLNZliFoHUHM2GboJOTuTxQbeSxkVATDKyO7WVeXTUX9
         RGHWShYZVyhLIuUen2DraUIcA/HHWelFVjHBfPDIuJtI8D2evER2KKbt40Czn8KWJDvZ
         7/iGaozZ9OhIW2UKULxJSRRWRaMA0v2W/+XDT4X0+avvGBEE+FcDwyse+2QD3EYFygdQ
         xydV7woRu5f/mN8jtqnjHXDLLoaefXtCPoG8v8CcTZmlojI7t8hO+vt1ru8hHznYpwlW
         bzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0Tx0szTuVegwtuiTM0BB8Oqc2q+Q6tNFAqvCkzwnbg=;
        b=RkyrFOomWG+9xfR1yaX/P3x6cczJmya/u7tLqL6gIUIz+G6QYQp4xVqn4YvxyNXfY3
         ahsd9uO8K+kni8/H/aJWqN3tuB0awtIVcNC7i9PoH41JmCLdz5UVpAoHWzPtX1cZee5h
         90DgPgT+w7jo6egtjT8enKozlVkSTOrO5PwuvGVul01RQty1icLcrtRapqsabl7opk2y
         GbYW25257VL0V2eBNMJsZ+7rOvOVhmF0nZFmmOxRt8SaCJ/HuucoGg/Olqp4bigfRBX+
         cq9ey/dr71leKL59wUjiVUF/nIsStvAxjmqJrg1JcZiaPYDYYQ42Ptb9QBSAENmwfENG
         qYSg==
X-Gm-Message-State: AOAM530fTNNK2213fEUDR+VILWjsgyUJoYRM73d67FkF1UxZzV4KxmO0
        tZ6LS+ImmC/DnizZH+Y9O63e5lBYouma1g==
X-Google-Smtp-Source: ABdhPJyNQzfpso02D5A3aLcwGeR7U40fObNP21zrwsUKvk3z/DIN65Cz0rhwHGNGquA3P5rwwE4J5Q==
X-Received: by 2002:aca:3e56:0:b0:2d4:c902:b851 with SMTP id l83-20020aca3e56000000b002d4c902b851mr6533733oia.114.1645934389584;
        Sat, 26 Feb 2022 19:59:49 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t9-20020a056871054900b000c53354f98esm3010285oal.13.2022.02.26.19.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 19:59:48 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next v4 0/2] net: dsa: realtek: add rtl8_4t tag 
Date:   Sun, 27 Feb 2022 00:59:17 -0300
Message-Id: <20220227035920.19101-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for rtl8_4t tag. It is a variant of rtl8_4 tag,
with identical values but placed at the end of the packet (before CRC).

It forces checksum in software before adding the tag as those extra
bytes at the end of the packet would be summed together with the rest of
the payload. When the switch removes the tag before sending the packet
to the network, that checksum will not match.

It might be useful to diagnose or avoid checksum offload issues. With an
ethertype tag like rtl8_4, the cpu port ethernet driver must work with
cksum_start and chksum_offset in order to correctly calculate checksums.
If not, the checksum field will be broken (it will contain the fake ip
header sum).  In those cases, using 'rtl8_4t' might be an alternative
way to avoid checksum offload, either using runtime or device-tree
property.

Regards,

Luiz

v3-v4)
- added rtl8_4 and rtl8_4t to dsa_port.yaml
- removed generic considerations about checksum problems with DSA tags.
  They belong to Documentation/networking/dsa/dsa.rst

v2-v3)
- updated tag documentation (file header)
- do not remove position and format from rtl8365mb_cpu
- reinstate cpu to rtl8365mb
- moved rtl8365mb_change_tag_protocol after rtl8365mb_cpu_config
- do not modify rtl8365mb_cpu_config() logic
- remove cpu arg from rtl8365mb_cpu_config(); get it from priv
- dropped tag_protocol from rtl8365mb. It is now derived from
  cpu->position.
- init cpu struct before dsa_register as default tag must be already
  defined before dsa_register()
- fix formatting issues

v1-v2)
- remove mention to tail tagger, use trailing tagger.
- use void* instead of char* for pointing to tag beginning
- use memcpy to avoid problems with unaligned tags
- calculate checksum if it still pending
- keep in-use tag protocol in memory instead of reading from switch
  register



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4324C04DD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 23:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbiBVWtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 17:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiBVWtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 17:49:07 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F316132948
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:41 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id w10-20020a4ae08a000000b0031bdf7a6d76so19717162oos.10
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 14:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WORGzRMUQjpvugQyhNz7ca7fAb7lzeu2my7DmadpJHs=;
        b=j33WELpUatN7luBWMG3MsbcxcCNiOePh17yqBUvce8Ha0MIGOlb3e9w99iCaAtz3c5
         H+mz+Z4ry4u0J6mmkW6mC2lIX9MqR+yYQ5u8y/U9AEn1kVkIHY9IKlfsWebshSa7TLSq
         L0JrQj8VMGCLBTAi/XaS3cHZZOQ9sm8qlCW5IM9gxmFV8FzK5WOX4WlTS7dktK4NgbMw
         0oph1KdTEzGgmROgljmp9nYe+RSsK+x5Zbdurr9wPQm+CiuWernV/1qkiQ1lBXZVTorm
         Uzlm2K+cqsXF2oVZaGZlKfYfEwwZZqWTHQAZYtHxKDqHn1VlxC1y15eNOBm24swr7ckK
         gv2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WORGzRMUQjpvugQyhNz7ca7fAb7lzeu2my7DmadpJHs=;
        b=KvtB7tbRW/KSJKMFaWmn6hycras9a0r7kaNTal0D537yRfNCPeBydmEhRNLQmBgUpf
         f0RIz/F2VvuUJoFWbPHB4bnEOMQGlNUtbqx0NBoVc+rgM8faj0jcCykioT/roKIa974i
         Gm4duJh9DIbe9bGzTHHbfs5B3b76S4Y+LY7wqyB+w7Be6XXludbkSrco8B7fer0nckCY
         zKEyGSh2qdBMB7rYrdLc2oQW8UrUXPaxX/ysk0sATOz/YR5if6KxImZGAPnFIN84EjZK
         /E/3whEHC4s3nW/efaJQFgIiUbb8KvcB0tw3oIprGRdZYr3lpyB/ISYnSe7X6TVca95U
         CKjA==
X-Gm-Message-State: AOAM530pWKkQAEP9orjwShaYYxZrgzxt29bdH4D9PQBnReDw73+6H15o
        IRE2VA7/EXCAe8WrP6Q+gO3LWFLN/xaJag==
X-Google-Smtp-Source: ABdhPJykcfxw2PDolBjAG4nDOZ0IPFBB3ZNGSFJLjaKl6HbbB1mYH221fKgnIKP14luF/tUnPxjkwA==
X-Received: by 2002:a05:6870:96a1:b0:ce:c0c9:62c with SMTP id o33-20020a05687096a100b000cec0c9062cmr2806098oaq.126.1645570120151;
        Tue, 22 Feb 2022 14:48:40 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id c9sm7033380otd.26.2022.02.22.14.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 14:48:39 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next v3 0/2] net: dsa: realtek: add rtl8_4t tag
Date:   Tue, 22 Feb 2022 19:47:56 -0300
Message-Id: <20220222224758.11324-1-luizluca@gmail.com>
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



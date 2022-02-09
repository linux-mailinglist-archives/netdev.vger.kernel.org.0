Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96174AFF0E
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232988AbiBIVOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:14:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiBIVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:14:03 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7883C03BFF4
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 13:14:06 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so4002210oot.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 13:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKSWAdjJ8bptlShoBHSUXTsrXmhCyHx8KUGU1nDc4vU=;
        b=W39AbaTsJ6mGo41zBN/oqL2bT7u+exH+aI+8CoRoNaMbpS28LPwFmcjZ+DfT+PIB58
         fMpgIs1Gt9MxxhphQ2+9/gLikmjLLipZW+dyBCc/tExqhm4wueKtI02qVO4vK6ZtmQLL
         YjOfZ9soNtJtZUDuPpDmc9Q5Vfrr6Eeowch6ol+gCpIPezVhupgEUqtJwt8zof40oU1K
         DlpkBPpVLaBv6cOe78av5BpVmscfbQOd0UHb/dcYOuUoE/ewQCtxPg8a0QdteLC91o6t
         Vxqenhm03DcfhZ7dXAbBNJterI6FwBika78H1HwyevJxU4RWNFRqHYaVjwXdMJKHkVDT
         McTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qKSWAdjJ8bptlShoBHSUXTsrXmhCyHx8KUGU1nDc4vU=;
        b=uCh5uyV6eCxtNTs655uS8Jo1uLLtHfWOs1tuWxKq8wCJekjP3nAYPal5Vj73mW4WJR
         YpxyNvyL6Y/+AXszyVpcaJ1e9LtZgp7Gj60dBDtFZ44J6DV/FAOPMGc8YrMJatyIg/3a
         YP4+KpPlSE0xscmWABEDzlkQqKEwh3rkasZCPAJM+IoqWKWbccGW+JrPkbT0DXTwNXEw
         SyrvZ2V/VNubrarNd4Os0SfjtcPrbhjalJEi7ItLBuRJhoVmy1VQKRT1DAupwm5mfWpH
         SQfrvV2p8kefk9OSGCTpBXkEFks2jSxVQIwbr9hFVuG2FlFJrHrkPTZkayIEBxCFkTmo
         Rkog==
X-Gm-Message-State: AOAM532HK3EkPvYW3Knjnn6GfX4XVrPdI1otAkaJJy7PvTBBakdnKTEK
        nD/uxUPJkfLt+pXv2Ji0oIvTllCEc5lAPA==
X-Google-Smtp-Source: ABdhPJyngL8b2nW0W2VaPXfibwFgHxz31CDQT31IKv2M97TrpjiZfDZWTG8fOvyKz/Xh7/bSdyvUxg==
X-Received: by 2002:a05:6870:b213:: with SMTP id a19mr1598448oam.209.1644441244455;
        Wed, 09 Feb 2022 13:14:04 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id n9sm6899945otf.9.2022.02.09.13.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:14:03 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next 0/2] net: dsa: realtek: add rtl8_4t tag
Date:   Wed,  9 Feb 2022 18:13:10 -0300
Message-Id: <20220209211312.7242-1-luizluca@gmail.com>
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

This DSA tag might not be useful in production as the conduit driver
might generate a broken checksum. It is useful, though, for test
purpose.

Luiz



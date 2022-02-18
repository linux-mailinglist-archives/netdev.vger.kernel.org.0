Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C72E4BB1D2
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 07:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiBRGLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 01:11:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbiBRGLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 01:11:09 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59CF193F7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:52 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id s8so2010301oij.13
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 22:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o9PQ6PuM/BuGHO1V5H+wEOFYDgmQ03xxmPQLmf3jVJs=;
        b=lf1gGym8FPHpu55NzBH5ej3F6HA7iL7YM0EqGwqRJUWx7/3ot/EuuvcqY3c5fWTpOx
         Ofgzlf9u0sV20KjQdIFUwCLH/rlnEtAMeq2zGjLtvd6Em7FP7GrvQh9AnXkpM0NS68OG
         x3O29wNh8ZmnpSGNYIQLHmKNBjh6RwIG6tg8W3ArBgvkCc9s+K2SbjrRal2MEg8Ce8tp
         tC5qOqWAuaSDr4IUutEVw6ZuS1o/oEZfr75DvrQML5wwwyGU6QkVC8U11J73Z6ntjyKX
         EIOhffqzjKHSOkXkBsRLVhYsKw52bx2QEcaNju2qdAG7yOmEapCBJUiK06sxA8fbr8d2
         y3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o9PQ6PuM/BuGHO1V5H+wEOFYDgmQ03xxmPQLmf3jVJs=;
        b=rQEoA6oobtw69lNGkKMlvJXjGjCvybX2lAXcd2dZxKwwQa+g3Wk8vRQ1upXgO9wSdl
         m93YVGsCY3mRS3wGZVb010g7Q0Sha7Ssj5/H8r5dTrY4x488gpgEf5ipfLhOy6KwXC0n
         mKROxLuLPJKvnwAMj/jumE3nku+HLTACjve/ackGmFCB87No1AKMylXzDbItBVyLqWRj
         ksVHR+ODEcfALPZZJZLGg+pSslSpPDerHuT9A94CGCyoGG7UZ7jXhsSrKyGn8owMP9a8
         XTfGDF3tP2f2+RB+D7FQw7b8Ixyh8slBPeNlyfHzQuyVW4sMNjp7OHkdX1JdggKraOUU
         oTtg==
X-Gm-Message-State: AOAM5327NCTAtGiaoeXbImH6WdqHYZhhcxjYX7lL0P0LBo67vcuvpPer
        /WLzTvYPCyzSQhPoYZwOn19TElv9GOtVYg==
X-Google-Smtp-Source: ABdhPJz/bHa7hqRdEnpRu5jgUcLx1SnGX+gGfBAXl3l0ddigVVa5EYV/1USuMYQ3AJINFlEKEgs99g==
X-Received: by 2002:a05:6808:1b0f:b0:2ce:2828:c2a7 with SMTP id bx15-20020a0568081b0f00b002ce2828c2a7mr4536424oib.11.1645164651827;
        Thu, 17 Feb 2022 22:10:51 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id 9sm3125214oas.27.2022.02.17.22.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 22:10:51 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com
Subject: [PATCH net-next v2 0/2] net: dsa: realtek: add rtl8_4t tag
Date:   Fri, 18 Feb 2022 03:09:57 -0300
Message-Id: <20220218060959.6631-1-luizluca@gmail.com>
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
with identical values but placed at the end of the packet. 

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

v1-v2)
- Remove mention to tail tagger, use trailing tagger.
- use void* instead of char* for pointing to tag beginning
- use memcpy to avoid problems with unaligned tags
- calculate checksum if it still pending
- keep in-use tag protocol in memory instead of reading from switch
  register



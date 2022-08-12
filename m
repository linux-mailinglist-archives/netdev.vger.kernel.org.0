Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B241591001
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiHLL0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHLL0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:26:19 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574DE99B4E;
        Fri, 12 Aug 2022 04:26:18 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id q30so863412wra.11;
        Fri, 12 Aug 2022 04:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=NS1OUkBRpuKhR6yWcTwhKigYA9ow76MHMrDf1FScipw=;
        b=R2nxGvhV1Fbw9jVtIaWt2cpoNKtI/unGQkXrrIysEkkPzVE26xCSRFEfBN82TYuFnJ
         3w+3U5k4kaM7xZT7AtNkg+oC88n5zzFmvmuFg0tZs/1MFQj+lRs3BN2FwFKBb93L6ia8
         Mf6Z7u9A7mwjuYCFcLjYgDjOfRA+yK48AUgSGY3QAp/gbH2DC/UmggToMq+8xovqkrxv
         tF8xxBBZ4/AcoIVBkHI1CihfI9hAqQnuBDhRTVTmlu2kO4BgK0bUVBaLBphXfUFpzezQ
         1gNeOZsrMXXmbfKtLI4q2qF1K0nkxr3sM+RcWmWrl35CEUR2Ptk6HlhKIo1Qxvpzb8Nk
         rrOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=NS1OUkBRpuKhR6yWcTwhKigYA9ow76MHMrDf1FScipw=;
        b=JQ54H0HTpzWFnJ9ujaJCPfzDQIuvJDa4OWM4x3w2RZ7+AZOgOVUxgXTTVqJvzaG2LN
         0Yul2N1SBRVQzWolbL9+zpDjaxayWUe/bEVAridLXm48sdSlQSt09oEcaL7Q2+1FCihB
         Ptfqufq1ZUCIep+XGovgBGpU3hId/V+pdyw8HGBneE/urOKb8HS9bpKPWiaztYRFWC5K
         NVipzA9Vx5mEoyesK+Au8if1n+pXf/KoL3VLvG9SpIcQ24TahS8k34LCBLMyt0NoYvI1
         tHRE4Hvy6ZwMtH0ga+0qUvBph3yU8sV8apgaL3NuLhJ+F0Xb/PoO2PHQxm/uz0iXFOaQ
         OAYA==
X-Gm-Message-State: ACgBeo3FceJLz2elrtBQBQWQ6PzoQoVWTiVmCUiBAQ0Zns98DiKUsV0B
        r3urB2fr5DESF4qQkLUYfgiq5hor1iyEQg==
X-Google-Smtp-Source: AA6agR71+hyYopHQ/rhLgXKVkQrptn96W8kowcyfqiGrDc4pjvRog9dx7XKIf6UgIQSY3/PzX1gQrg==
X-Received: by 2002:a05:6000:1283:b0:21f:168f:4796 with SMTP id f3-20020a056000128300b0021f168f4796mr1974369wrx.615.1660303576728;
        Fri, 12 Aug 2022 04:26:16 -0700 (PDT)
Received: from debian ([2402:3a80:a6c:8d8d:8b73:352a:a34a:c91d])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a4bb3f9bc6sm1392485wmq.41.2022.08.12.04.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 04:26:16 -0700 (PDT)
Date:   Fri, 12 Aug 2022 12:25:57 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     torvalds@linux-foundation.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: mainline build failure due to 332f1795ca20 ("Bluetooth: L2CAP: Fix
 l2cap_global_chan_by_psm regression")
Message-ID: <YvY4xdZEWAPosFdJ@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

The latest mainline kernel branch fails to build csky and mips allmodconfig
with gcc-12.

mips error is:

In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:420:16: note: in expansion of macro '__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~


csky error is:

In file included from net/bluetooth/l2cap_core.c:37:
In function 'bacmp',
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2003:15:
./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
  347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'bacmp',
    inlined from 'l2cap_global_chan_by_psm' at net/bluetooth/l2cap_core.c:2004:15:
./include/net/bluetooth/bluetooth.h:347:16: error: 'memcmp' specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
  347 |         return memcmp(ba1, ba2, sizeof(bdaddr_t));
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


git bisect pointed to 332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression").
And, reverting that commit has fixed the build failure.

Already reported at https://lore.kernel.org/lkml/YvVQEDs75pxSgxjM@debian/
and Jacub is looking at a fix, but this is just my usual build failure
mail of mainline branch for Linus's information.


--
Regards
Sudip

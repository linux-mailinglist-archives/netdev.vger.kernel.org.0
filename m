Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0271259069B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiHKSxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 14:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiHKSxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 14:53:19 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEB49E10A;
        Thu, 11 Aug 2022 11:53:17 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id p10so22276081wru.8;
        Thu, 11 Aug 2022 11:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc;
        bh=os3g0edKIMTDU2FvQTzWGxtvkNImM/E4AAN0AbFTqTw=;
        b=MrG+FtNnbmMga73Hd/PQqg2BumDSlAE16w4U9knvpnIhukagSl/JS2/Sj87gDZILKg
         8yxldD8JZXGYLBv8WFXQMfedTg3X8NetJdz0VNQLK64ChlYb+ShVQDspNq2l2qoqzdGa
         W/EAqg5YU1REGjYCrslVvYSWn8ihw3UkF1romEI4vd1wcWJXKUNXoRcyAKHTr+3KmWbT
         T1vFtqQyOLNlWSfSLbtjQuwz9LIx/ihNjUvo/f+15HsMkboLO6G8Kf+hNOW6FKi1YAad
         /HmmXqf7zW9t3EeX+Xkg+kI+Lf1DSoiE+33Xs/kY2kW0xrVJ12+AC5cpkch3GDyZayjZ
         CGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=os3g0edKIMTDU2FvQTzWGxtvkNImM/E4AAN0AbFTqTw=;
        b=RH82arE98mausTHZDsueLz4/CcRREMiHe1IUswRjO89njTnMVZJx045KMhxrmGrqxB
         Lda75U0Y1S52gW2QH1nZ8e5GMMsb3kIHEfYWgbGVPz2KuD0Hl3Ktu5RxOfPqCqdDZEIs
         IpDSsdJVuHaP6TVPJxX1Ca/TlhPUqW4MoFLtSFV2NsKQ1pFIKF6/goD4RemUKEoynxIL
         ur1M5MHxlI+0DR3Cv288/LgY9ARs/DXLWUUv6Q3l3XpGf6awxkw8AMf9wqYxSRBDzZ4L
         oBze4OnWVBxqMzYYHThpQTJxMpCguM3QZz/6cjO96Q7JZU+Vp1EYwX6RoykiO5O+hvJk
         py9w==
X-Gm-Message-State: ACgBeo21D8K7LmAAeqUDDzn5qSHgAnIzxas/h6BaxSlzMienyJV68gGu
        Xae82eRjQL46VJSvlzEa17c=
X-Google-Smtp-Source: AA6agR7V0H2RXHPWo9CnZkJvbm8Y5dMdsA/qj59j5RUNvq+GycirdFrtyJ+5HwPDPw4etBnpeFE16g==
X-Received: by 2002:a5d:548a:0:b0:220:785d:38eb with SMTP id h10-20020a5d548a000000b00220785d38ebmr224065wrv.56.1660243995580;
        Thu, 11 Aug 2022 11:53:15 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id j42-20020a05600c1c2a00b003a30c3d0c9csm8131285wms.8.2022.08.11.11.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 11:53:15 -0700 (PDT)
Date:   Thu, 11 Aug 2022 19:53:04 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-next@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
Message-ID: <YvVQEDs75pxSgxjM@debian>
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

Not sure if it has been reported, builds of csky and mips allmodconfig
failed to build next-20220811 with gcc-12.

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

I will be happy to test any patch or provide any extra log if needed.

--
Regards
Sudip

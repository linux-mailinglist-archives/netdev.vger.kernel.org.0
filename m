Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C1856A497
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiGGNzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiGGNzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:55:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB571019;
        Thu,  7 Jul 2022 06:55:49 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r18so23228926edb.9;
        Thu, 07 Jul 2022 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJpyJd33s/gxcx6SoKFKHH7RI44PpDzJmMb3d3RIzkk=;
        b=ZE5JAVlKknyHi4dTL/lISkpejX5uawjysdLYth7GcJUw86XfsOeyj83nYsQPHzoF4z
         YdRsyuPLmGQ3WNpWrkiv6D9PsVSBB4eBxhQIrKFm5C5jHUvm8PuxE1vlhmVhWHxzQZUy
         wUb7JByZ/tUQQ5Ttbz2Wx3di6s/gz1UTRdt1H+CXFsRixACaMqcBAzuSaJDKOGA+oB0+
         /ed3RQAe0JcbcreHhb8DSoKhPMXE2lkEq8slBsw33qt9U8Cp9RPQMttQRud/aPAVy3xK
         bTeu+OyFFkcLP93iqw6Gddt8rIyF/vaqVxCxJv+lJaEq7q7hwvj3cH4QKDHOnFbzynIA
         vRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FJpyJd33s/gxcx6SoKFKHH7RI44PpDzJmMb3d3RIzkk=;
        b=wMrFcULHRND2JEcG4Ho2B/3bv6cKFQNeGUeAjBOIVdKYAmIOdEQUAjWmpVy6lfEyrw
         qja4KffE1EeZE8ENJ68kQ52mWqn0wt0NWDjZjBZfLQnu2a9I+UL1ZaVyXuh6b7d9RC7d
         8RN8CRBtfTu2K0W9X48DB3CyvkZ7qtr/W4gIyB7Ms3m+6NQI8dzCX2r/2kmTACp4oraD
         oeLS7pM0WfhIGwKSSJy20cP/kazwtNdHAzFE7ME05OFM4N20Wuey1DFTPy6NpF10duqK
         pDti55eLperIW67RxBinnlXGqiD2zDsECnYFPoJjRXUdskArzKKR6Nl6wDw91TarGpWK
         /XdQ==
X-Gm-Message-State: AJIora+SqB5B+WcDTW3dLgruraHxbrswJ5L/cH52+LoJIvFwAJWsvmTz
        PRbwGnV4Qj+ZuNYiflRYkSB7hBeH6lQ=
X-Google-Smtp-Source: AGRyM1vin3LHzjRWc/b7FDIbxKnDqDXTBvxdN8N+dWDKZjjCstY0Ev8juHVvmH7NSoAUONfc5+lyZA==
X-Received: by 2002:a05:6402:518b:b0:435:c1ed:3121 with SMTP id q11-20020a056402518b00b00435c1ed3121mr61136516edd.405.1657202148015;
        Thu, 07 Jul 2022 06:55:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-117-000-249.95.117.pool.telefonica.de. [95.117.0.249])
        by smtp.googlemail.com with ESMTPSA id x10-20020a170906298a00b00705cd37fd5asm19054969eje.72.2022.07.07.06.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 06:55:47 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, shuah@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/2] selftests: forwarding: Install two missing tests
Date:   Thu,  7 Jul 2022 15:55:30 +0200
Message-Id: <20220707135532.1783925-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.37.0
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

For some distributions (e.g. OpenWrt) we don't want to rely on rsync
to copy the tests to the target as some extra dependencies need to be
installed. The Makefile in tools/testing/selftests/net/forwarding
already installs most of the tests.

This series adds the two missing tests to the list of installed tests.
That way a downstream distribution can build a package using this
Makefile (and add dependencies there as needed).


Martin Blumenstingl (2):
  selftests: forwarding: Install local_termination.sh
  selftests: forwarding: Install no_forwarding.sh

 tools/testing/selftests/net/forwarding/Makefile | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.37.0


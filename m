Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A490858C29B
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 06:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiHHEri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 00:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiHHEri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 00:47:38 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A9926C1
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 21:47:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id f11so7589776pgj.7
        for <netdev@vger.kernel.org>; Sun, 07 Aug 2022 21:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=VLncDyNQnKXtwizJBnIi5g+tK5Hl5K0IdbsONcQheqY=;
        b=pC6mMqAABQy5bbZ3TG1XhOzcqYRJ+FcoX945ekX/shUFyme2ff5RsxORfBXunqFk1G
         IqiyMSfAf6OlvUnPEV3ILSq+6SsayBrMn/VP79hxjDYIbPHNxC4eo3VFtxGAVW8RSfue
         leSy+5piVdz6bnaU99vcm7j/nUD13EawCrITcvUeE1Kmtz6HsPEO5pxaSqi5HzQ3q5RI
         SxL28Q7wXtuIah+DEt7P1ld01w/k8iy6ip4fim3VH9BryCyr0cavEsoV388teMGpt+Sh
         UF6nfvugwxPqgdyhBD+haJUSBPMN+3gmJtimiE9uu7d+hxb73ExMvAuj5FOckkyWK2nk
         ic8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=VLncDyNQnKXtwizJBnIi5g+tK5Hl5K0IdbsONcQheqY=;
        b=WQj2LyA6NSrTkkofNSpqMSb5niLCWEHaRMzCsNiMvtzTLwVeznSlcywxQOH46o43x6
         FFk94CO8Xpnps+gxBO++EuNxVg0ANJfQLWfk8Cg9sj/ZdENUSt2h7uUXpxWmzw1+AKoj
         hI/RdyetdEwgZvZBmfu0owBHUDa+FAmyI9mhPBUvJnm115lOdO+lSlyT8/rVAfxKhafE
         qI5T1GiA8XVQIuT918YhODa+hGjQ+Hql/jGislFou4hB6gYqRu2sH+xxIyvu6MeWYsR9
         bh9KzIv+hqCHc7QI6XedoShioQVxNuMLM2Wrkm9fTeA92FfCOuwQokCWNpVX5FQQFuH8
         jEPA==
X-Gm-Message-State: ACgBeo0eDrgHW4GjfYpHk/NCC5mSsW55ivQFZvUeomAllkbPoyxIu+D9
        OMPMnhVGJnLuu3F9a3irEHbY62e/6+/JhwWVbCv1FCMBitDoHg==
X-Google-Smtp-Source: AA6agR5z7B8YkJA7MOLxwTaFW7SBYxNSJ/DUUtvTVQw0JaOqaYM07eyaj6AFbzYBtp5oe4dWB0fERYAfHFAFBt19DA0=
X-Received: by 2002:a05:6a00:bc5:b0:52b:49c9:d26c with SMTP id
 x5-20020a056a000bc500b0052b49c9d26cmr16821698pfu.73.1659934055841; Sun, 07
 Aug 2022 21:47:35 -0700 (PDT)
MIME-Version: 1.0
From:   Mahendra SP <mahendra.sp@gmail.com>
Date:   Mon, 8 Aug 2022 10:17:24 +0530
Message-ID: <CADDGra1JwDNgjUm6EPUnu+d1cDaCd8VD44jfN9yeevWY45LY_g@mail.gmail.com>
Subject: TAHI IPv6 test failures on 4.19 LTS
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We are seeing a total 18 failures when TAHI IPv6 conformance test tool
is run against kernel version 4.19 ( specifically 4.19.29 )

Here are  the tests that are failing:
Section 1
13 tests failed out of 54 tests <test numbers:
16,17,42,43,44,45,46,47,48,49,50,51, 53>

Section 2
1 test failed out of 236 tests <test number 138>

Section 5
4 tests failed out of 25 tests <test numbers 12,17,20,24>

Is anyone else seeing similar kinds of failures ?
Could you please let me know if these are addressed in any of the
latest kernel versions?
If yes, please point me to commits/ fixed versions.

Please let me know if you need any additional information regarding
the above failures.

Thanks
Mahendra

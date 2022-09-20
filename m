Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D8E5BE8C5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 16:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbiITOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 10:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiITOX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 10:23:59 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8136021835;
        Tue, 20 Sep 2022 07:23:37 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e17so4093229edc.5;
        Tue, 20 Sep 2022 07:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=AdtpZB7U/EABK14zfV/flloJYC93tZl66p8xW/fKflI=;
        b=WiApm+FyIA3oAhh+un2VztEkfOLo0vOyUENAeEGzdK5Xaq/T2D3fYeUWCVg+vBB14h
         H+K4WkGh825B1M3cs6cYQ+KbNbkS/E+oMzFpVqdodOgcMMtbMFJR3w1wQ7FPdav6VQs8
         ryYdKzuDQ+U3KaGmNScrzmHlhMWL18MvcrXzxQ9w3OPN7n12vS5fccOU40vzn9gvZFJD
         aEoRrB9/3Fh7pFLgyIjudA6G5CGENdr6eZukz2gFbHDcW1grp8kQeuwYgdhkCskSoHfv
         7mVT7VAgAUGDWKGDOq/4Nzn/B+eVOHhDW03leKjiGylKhrp5bPGVBVGRiNJ2PWYIHRDd
         ALrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=AdtpZB7U/EABK14zfV/flloJYC93tZl66p8xW/fKflI=;
        b=CAWf055qUtp0JPWZ3+MVKAD7HPU5s7j0KfhXj9PRsztC3wv/39HCPrJlD6lIOQFJsP
         6JTWb/HOEEcWeTvzl/YaUMLZQjVbCBP62dcI8C3PuVNK9aZHkCbmxp302k+qkpJQ57+6
         +QtJObXF7bVRvxm9nb4YQsdnbsKW3wV6BTf1bALxbUa0607QKLJ14H3P66kR294onBWx
         Cfj6YEi4eF+K1pAn6ZsqpmBLXZFXUrTA4FeVNhJ0VvwBSNbf2oxxzSm7r4fqBakKjsXz
         rGOVoCJspUPA+nhECInGOVaV5dOt7H6gvz1NqiL2Jnwu4SZMoX80eZps3TwD0Z9XxlGW
         Lsqw==
X-Gm-Message-State: ACrzQf38GHXI3VOMIZINo0Y8W+CtXFUgN6jKUWvzMLe2Xjj9ymrkcXkE
        /aogHUyU7SeeUwEVq7NjflB9k91Y2IG519ZPHfnyc/poJE4=
X-Google-Smtp-Source: AMsMyM7A0vXmhuLnWz/JvadhLpoO0zXesiteq62wMJys2JjmQ/j4DZd0J7mR2NLFnCp8xixumNbGJKe3LOH37nNGRQQ=
X-Received: by 2002:aa7:cad5:0:b0:454:88dc:2c22 with SMTP id
 l21-20020aa7cad5000000b0045488dc2c22mr1698575edt.352.1663683816014; Tue, 20
 Sep 2022 07:23:36 -0700 (PDT)
MIME-Version: 1.0
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Tue, 20 Sep 2022 16:23:25 +0200
Message-ID: <CAGRyCJGWQagceLhnECBcpPfG5jMPZrjbsHrio1BvgpZJhk0pbA@mail.gmail.com>
Subject: MHI DTR client implementation
To:     mhi@lists.linux.dev, linux-arm-msm@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I'm looking for some guidance related to  a possible MHI client for
serial ports signals management implementation.

Testing the AT channels with Telit modems I noted that unsolicited
indications do not show: the root cause for this is DTR not set for
those ports through MHI channels 18/19, something that with current
upstream code can't be done due to the missing DTR client driver.

I currently have an hack, based on the very first mhi stack submission
(see https://lore.kernel.org/lkml/1524795811-21399-2-git-send-email-sdias@codeaurora.org/#Z31drivers:bus:mhi:core:mhi_dtr.c),
solving my issue, but I would like to understand which would be the
correct way, so maybe I can contribute some code.

Should the MHI DTR client be part of the WWAN subsystem? If yes, does
it make sense to have an associated port exposed as a char device? I
guess the answer is no, since it should be used just by the AT ports
created by mhi_wwan_ctrl, but I'm not sure if that's possible.

Or should the DTR management be somehow part of the MHI stack and
mhi_wwan_ctrl interacts with that through exported functions?

Thanks a lot in advance,
Daniele

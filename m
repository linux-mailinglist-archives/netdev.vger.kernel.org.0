Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 106136EBDED
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDWIT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 04:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjDWIT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 04:19:26 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23AB1993
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 01:19:25 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4edc63c82d1so3332509e87.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 01:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682237963; x=1684829963;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JjMh5ipiP0ns+gvKTfbXnAc8Fl+/on2ZG1AMQ2sUdts=;
        b=QzQSz8TmmW14svn75QN2HOCPqkEXcwLTXn83bVWZaNvpyhVC/TQSocl97N8eEkuaTI
         Jyl176KkYGArFIE69OA7bvKODSgqbj1MZ/7yaN/btHet10iWryGMVahGzGtSTvLAflbD
         9L9fJbOZEku/NDVpr28cOgAllDbHXpgU56I6hVGjXCAKKCAuBV3GpXV4sJPAp96ozqNW
         8f1NEpbhtBGQSaqDC8B8qhhj6GnfyWvXQpNzJ53/INqc97Z6BFzgageJQ0V+xWzvZWgu
         uCpBFUpZDnoyvwXbWBoX2cxY4RLZe/Sl2Qls7/zrTTdeCBv2g5JQakujm7Wp9jokBomu
         PNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682237963; x=1684829963;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JjMh5ipiP0ns+gvKTfbXnAc8Fl+/on2ZG1AMQ2sUdts=;
        b=NQhCNPCa7v+Wo+KAkoFE5seHU2qw5QX01YkzLBJ1Dg3/SQofu6Xk6BMmntaOrSagQ8
         kJFa4qqFc74o+SnSmGPQi4sjfE6+NoHuDElhhg73dSpOoFKoIBmRjvmcb4D0bllicufy
         kD9e3YsyH8U1Ph5vc3ZA/3iD8X9IVIASGtLNBKp6Mgt7RMfHWch+gi5pKQs8LgV/OihG
         Dub2ctos+4K47CwuRqdMRN8vFNCvxlJDmPikGxCEj/V0/Qo9gRen0WhafUGyR5zKde73
         BIsMTQwupRaVhGtSI9vLIh2Ih+25jtxBN2LhxtnqrSQNN0QVSbm5p2PmSwMkdTz5ws4L
         GV0A==
X-Gm-Message-State: AAQBX9cJNtUOUic6kWCsPeXr4VYo+U+QIP8PP+USjGAHOI2XUW7fj6fb
        ebU1K8t45e+g9af40GS2FdvkyPBRWnN0dW/NeZvtxmld8tbnDya5ZmjgTQ==
X-Google-Smtp-Source: AKy350auL1iqBj734KwU8HYpYITO+17VAXhvogS8x/5gK3DmHSl4XI4YpaKkLVGHGZ4s3/9vN3vzZniXxR4fkGi0Wu0=
X-Received: by 2002:a05:6512:250:b0:4ed:d4ac:1e17 with SMTP id
 b16-20020a056512025000b004edd4ac1e17mr2747303lfo.49.1682237963522; Sun, 23
 Apr 2023 01:19:23 -0700 (PDT)
MIME-Version: 1.0
From:   Feiyang Chen <chris.chenfeiyang@gmail.com>
Date:   Sun, 23 Apr 2023 16:19:11 +0800
Message-ID: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
Subject: Help needed: supporting new device with unique register bitfields
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

Hi, all,

We are hoping to add support for a new device which shares almost
identical logic with dwmac1000 (dwmac_lib.c, dwmac1000_core.c, and
dwmac1000_dma.c), but with significant differences in the register
bitfields (dwmac_dma.h and dwmac1000.h).

We are seeking guidance on the best approach to support this new
device. Any advice on how to proceed would be greatly appreciated.

Thank you for your time and expertise.

Thanks,
Feiyang

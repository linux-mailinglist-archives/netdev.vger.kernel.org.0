Return-Path: <netdev+bounces-8282-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0FB72385C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B32D2813B7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:06:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C44F5666;
	Tue,  6 Jun 2023 07:06:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710D33D9F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:06:56 +0000 (UTC)
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3350B2
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:06:54 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-465db156268so466846e0c.3
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686035214; x=1688627214;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C1ozZq870KAb+6oNoYDYw8jrsSo5Jl0b6K0qLqBb3b0=;
        b=rbXA8IfhANxbtLxUs+ybhYlcSzwfA5IggOmY5ZjCC4g7EmN6wmxl3e/k55M7e3XQK0
         iEIzXDN3lRYbkqhfAn77UF7lWK1OAsHxoA1UAU0JNjm2zUCBzBHd3RKK0i2P9NHVRhHL
         75BiueWX0Z5l3f4njQyUrBcEopYMF7Hgi/TmqZwQx7gFjaHoerpKfMOFiVoSakehqUwk
         aOoaTE4G/Eca+zkIwg7kduFjJeiJuNyCOTHiub3PDofWVjm0F1n1EOYgpuGKD1RnVzxw
         WkCI0S2XDfBZWwsF+csMt394c9QyHoULlMZMXZju6Hqj0UxvWUSRmaQqsP7bny5tbu0V
         0BHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686035214; x=1688627214;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C1ozZq870KAb+6oNoYDYw8jrsSo5Jl0b6K0qLqBb3b0=;
        b=gtl+HwVO1tDI75CEISsVK22EDAsHwO6jw5WeJ12E2IW+7l2dqmuOKLWZauXRX5f0yo
         Q6nPMUnYwIXd5XBWAwhhXSjbXQphODqEOSiJMbYb1I1HpEmGRteJJmwO15qylb1hXvn1
         PwswF56vCbbdf5UFH0miwWPCYyl/IMWSQiITFWoCFrZOViRArEOZzFBh0DeRH99dYUpf
         1jXBZ+XaJknuJQUgSf3OtbsXT8ADBsvN3h9jB6m1rfUjDVDqe7NKFATA+hRvNYSZveAb
         wSYeSQ7uI8iRgvZcIUL/O3MWc6E2ovZMc+cZaEiWzPaY4ZlFfolXLQfXpMLrE3qJFItG
         AgCg==
X-Gm-Message-State: AC+VfDyNl31XYC4U9AO0DKClZxfGFwJlkX2kvLqGlUcVfZZy6/MUhZ73
	Z7EFv/C2mFnLrvRqnUeL8UsIL7JGESnLe2/v4q/17w==
X-Google-Smtp-Source: ACHHUZ7aPrm570/8BxX3lP0KZqPqmfsW0iBwZYyldLzeJu7wmf09RiDglmhWrihns8goe/c96xxZ+7kNyHoA5xshzb0=
X-Received: by 2002:a1f:62c4:0:b0:43f:b997:beea with SMTP id
 w187-20020a1f62c4000000b0043fb997beeamr382368vkb.13.1686035213755; Tue, 06
 Jun 2023 00:06:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 6 Jun 2023 12:36:42 +0530
Message-ID: <CA+G9fYtD4+d3SJeCauPhQz_3cR=Z6dhOpBsW85mFbKf0jsvn1w@mail.gmail.com>
Subject: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:
 stmmac_mdio.c:(.text+0xe74): undefined reference to `lynx_pcs_destroy'
To: open list <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, 
	lkft-triage@lists.linaro.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Following build failed on Linux next arc,

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on arc:

 - build/gcc-9-vdk_hs38_smp_defconfig
 - build/gcc-9-axs103_defconfig

arc-elf32-ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in
function `stmmac_mdio_unregister':
stmmac_mdio.c:(.text+0xe74): undefined reference to `lynx_pcs_destroy'
arc-elf32-ld: stmmac_mdio.c:(.text+0xe74): undefined reference to
`lynx_pcs_destroy'
make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:35: vmlinux] Error 1


Build log:
========
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230606/testrun/17346877/suite/build/test/gcc-9-axs103_defconfig/history/
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230606/testrun/17346877/suite/build/test/gcc-9-axs103_defconfig/log


--
Linaro LKFT
https://lkft.linaro.org


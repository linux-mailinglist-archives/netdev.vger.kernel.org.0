Return-Path: <netdev+bounces-11134-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A3F6731A9B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5383F2817D1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A57E168C6;
	Thu, 15 Jun 2023 13:57:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABB6168BB
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:57:56 +0000 (UTC)
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EF71FD5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:57:46 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id a1e0cc1a2514c-789c56ead4fso1410245241.1
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 06:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686837466; x=1689429466;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gJ7qB9Ep7tkRFvnY4tP6xBdv/LSo3U9AM6agsmPVBBc=;
        b=X1jLzDcwobiSNQVfkgy0tKX2PShVc1mY+QfrQwOUHE3B5ytCla39+sgCglp8OyBtat
         x94JdoGc6u5FqAc8uAJLlBCfJhz7xFlo3Qmm6oA6fyME+Jx0MKAIO0wmPE+RXgU83a33
         DTslpSkjGVhRvBaiTHoujhsfZJmwAqUEPqIiJinO/wAXHSLOLSyxe8pX9A8bhdcO78Dj
         FEDOwz+GBvCsgyGIMSnKodh96o1ILw/+d+YpqCCcu7GtOOqp4q8WfCHMJ9MC2/dfA6dA
         EOCHuOrh+e4pMckEtA9uzHrBB2qI1/LInpGnwgTXFOH8cH3xE6GmRxQrLcB2RKD0PReB
         mVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686837466; x=1689429466;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJ7qB9Ep7tkRFvnY4tP6xBdv/LSo3U9AM6agsmPVBBc=;
        b=QVRV4DX0psaK4jfwzMemEwNTRqYmck5dspj8Ty8+U2vJe/d7GcC2GJsGEEhjRTNi1l
         v5IoNjdSIehjNIza6o/egUBXb5dwzxSDt36s+b3Yd/2xfmIoAs//6+X9/lTa9YThx2hx
         KyS+L4vZoYHCHtd+JLppp76ve4kxG4hP9fUa+WEvVN00Ex6c9RkYe/OW/xVunGem40Nx
         r04wmL7OzSJZT95IuZKo/guawD0PjJ16z7E9aezxlG5CGUc8/cIv/xNFlQklWntaDpnx
         M55gT+QZUeP2Lad6KU45mXx1/s6B2K0keDOQpfIzIbdgq3S85VTZPRf20qBhctWkqG/O
         XLkg==
X-Gm-Message-State: AC+VfDyKEnV1ishzm1SBIBaCVwPUmUPuN0xcRecQI1eoske9SOvX4WCU
	IAt8zxg2CJRkVE3T98ExFl37p/ufugqfoPWG5qRjSw==
X-Google-Smtp-Source: ACHHUZ6V6XJA88EStQsUft9YesOuyH69+RyFcPgZWb8Fev65Xgxl95jyWAcJNgJ6pLsIXD14Ui8afmCKgpEET/u6DMw=
X-Received: by 2002:a67:de0b:0:b0:439:5a25:2e39 with SMTP id
 q11-20020a67de0b000000b004395a252e39mr9005440vsk.34.1686837465649; Thu, 15
 Jun 2023 06:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 Jun 2023 19:27:34 +0530
Message-ID: <CA+G9fYsAvbqVr+W4=17sxwguGSQi6cU+9WZ_YQzg3Wj96e70uQ@mail.gmail.com>
Subject: powerpc: ERROR: modpost: "efx_tc_netevent_event" [drivers/net/ethernet/sfc/sfc.ko]
 undefined!
To: Linux-Next Mailing List <linux-next@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Anders Roxell <anders.roxell@linaro.org>, habetsm.xilinx@gmail.com, 
	Edward Cree <ecree.xilinx@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Following build regressions noticed on Linux next-20230615.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on powerpc:

 - build/gcc-8-ppc6xx_defconfig
 - build/gcc-12-ppc6xx_defconfig


buid log:
====
   ERROR: modpost: "efx_tc_netevent_event"
[drivers/net/ethernet/sfc/sfc.ko] undefined!
   ERROR: modpost: "efx_tc_netdev_event"
[drivers/net/ethernet/sfc/sfc.ko] undefined!
   make[2]: *** [/builds/linux/scripts/Makefile.modpost:137:
Module.symvers] Error 1


Links:
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230615/testrun/17530875/suite/build/test/gcc-12-ppc6xx_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230615/testrun/17530875/suite/build/tests/

--
Linaro LKFT
https://lkft.linaro.org


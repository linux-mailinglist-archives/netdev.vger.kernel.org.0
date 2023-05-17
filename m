Return-Path: <netdev+bounces-3418-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E4AF70702A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DC711C20957
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4A131EF0;
	Wed, 17 May 2023 17:57:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EEB10966
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:57:05 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666BF19A;
	Wed, 17 May 2023 10:57:04 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 34HHunoe025410;
	Wed, 17 May 2023 12:56:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1684346209;
	bh=Y5a7G0lQ4tGrkMUd9GogBnap1YhDDaj9ce2WHoIytzE=;
	h=From:To:CC:Subject:Date:In-Reply-To:References;
	b=OHFEjeIr/5Xotn/BzJYhNRpLynn9wN2SIlCiS+SLdCME3gtsNY47L5imijBiCoXln
	 4JoYY11qcbyFbZEOl5Ep9wYPKU/T5XmP0HpfthiTow2r4MmN2YKWRv++/C9WL+31I7
	 PMy2ZamfQkTOIlgX8MJWE/KrmbiZDuJ/JI7rO8d4=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 34HHunFw020022
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 17 May 2023 12:56:49 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 17
 May 2023 12:56:49 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 17 May 2023 12:56:49 -0500
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 34HHunJg106538;
	Wed, 17 May 2023 12:56:49 -0500
From: Nishanth Menon <nm@ti.com>
To: "Andrew F. Davis" <afd@ti.com>, Suman Anna <s-anna@ti.com>,
        Roger Quadros
	<rogerq@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo
	<kristo@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn
 Andersson <andersson@kernel.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        MD
 Danish Anwar <danishanwar@ti.com>
CC: Nishanth Menon <nm@ti.com>, <linux-remoteproc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <srk@ti.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v9 0/4] Introduce PRU platform consumer API
Date: Wed, 17 May 2023 12:56:48 -0500
Message-ID: <168434617580.1538524.11482827517408254591.b4-ty@ti.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414045542.3249939-1-danishanwar@ti.com>
References: <20230414045542.3249939-1-danishanwar@ti.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi MD Danish Anwar,

On Fri, 14 Apr 2023 10:25:38 +0530, MD Danish Anwar wrote:
> The Programmable Real-Time Unit and Industrial Communication Subsystem (PRU-ICSS
> or simply PRUSS) on various TI SoCs consists of dual 32-bit RISC cores
> (Programmable Real-Time Units, or PRUs) for program execution.
> 
> There are 3 foundation components for TI PRUSS subsystem: the PRUSS platform
> driver, the PRUSS INTC driver and the PRUSS remoteproc driver. All of them have
> already been merged and can be found under:
> 1) drivers/soc/ti/pruss.c
>    Documentation/devicetree/bindings/soc/ti/ti,pruss.yaml
> 2) drivers/irqchip/irq-pruss-intc.c
>    Documentation/devicetree/bindings/interrupt-controller/ti,pruss-intc.yaml
> 3) drivers/remoteproc/pru_rproc.c
>    Documentation/devicetree/bindings/remoteproc/ti,pru-consumer.yaml
> 
> [...]

I have applied the following to branch ti-drivers-soc-next on [1].
Thank you for your patience in following up and incorporating all the fixes
and the multiple hand-overs!

[1/4] soc: ti: pruss: Add pruss_get()/put() API
      commit: 67d1b0a1030fb20d54b720df6e976c06b893fb00
[2/4] soc: ti: pruss: Add pruss_{request,release}_mem_region() API
      commit: b789ca1e3380ab63b60c3356c026a7e8eb26ba01
[3/4] soc: ti: pruss: Add pruss_cfg_read()/update(), pruss_cfg_get_gpmux()/set_gpmux() APIs
      commit: 51b5760e56ef19106a3c4487a66d186d46ccc6f4
[4/4] soc: ti: pruss: Add helper functions to set GPI mode, MII_RT_event and XFR
      commit: 0211cc1e4fbbc81853227147bf0982c47362c567

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent up the chain during
the next merge window (or sooner if it is a relevant bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/ti/linux.git
-- 
Regards,
Nishanth Menon
Key (0xDDB5849D1736249D) / Fingerprint: F8A2 8693 54EB 8232 17A3  1A34 DDB5 849D 1736 249D



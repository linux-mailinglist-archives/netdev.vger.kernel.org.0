Return-Path: <netdev+bounces-4952-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D03970F589
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1939281256
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5A417ABB;
	Wed, 24 May 2023 11:45:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB402C8E9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 11:45:09 +0000 (UTC)
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3413418B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:45:07 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-510b56724caso3968013a12.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684928705; x=1687520705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w7tyzTfKRGX0t3cJP65p+vm9JOpJoXNJctsxbm2EddM=;
        b=SRrLScCLWhrXZUJUNh9ls64wKRoCWT/Xfjg/IOVrWhg/5VVlgllIBonU97Hz/3s8Bl
         0YJyB0TV8D6g8UuStq1YLqoNgHcedUu50ChU9Xmr/LDcaDeiJyNqSllhSzHcWzXzLBpj
         ZqRdET1P1EAEWler6L1sNl0OmOcVWnTk+cJllb7ABMU1II8kHEzBEBnRzO+cnFO98NGm
         AL+lgzgM9D/URvQQisKL+lBOc+ZbkiHxj97jtKtdigeP8XrwOEyFG3XaTPGS2FJal8hX
         qs1BD6wsk5z8pqHqe9Z86dJltgrRFwWZ3z3rQgC8QvLPmGi7cTHjiLhbXRI2yUjOiCBH
         uxKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684928705; x=1687520705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w7tyzTfKRGX0t3cJP65p+vm9JOpJoXNJctsxbm2EddM=;
        b=EMb1o9nMM+uAXo2wUuJ9eyIKkj/k5npIJqAJAJABb3o69ghXp1+uuBmbdGpikScc2Z
         GfrvsPSZIuz5mrVRiMBaLQajmEQdqfwM/zSMJ/Hnh/M+i1VtrRU1FUv4tOM9OuF2EwW4
         wi/vjeyF/nmov0Ms2B1Jz15pJ+2xFQvJt18XSEzDwIw5CaOqGBBbNiuyA4X2T9m2FQt8
         TAABPL5oyfNvih47F7LH8trK1lOUzEjcsZ+08zJ7+WHELxWhJ3s96S96QAmp1IZpK1Jk
         mgKHNoTIlgqr9E7ESUleFE7D46Au3rHk7dJe1htURPLM97LxxqPtH1jHKelm+o0AH5D5
         6/eA==
X-Gm-Message-State: AC+VfDzIOYQRi9a6mI43sSkYd52LD9PJdddiWa0N25CuavpY/1sb+b+9
	E/QuhkL7xduVk1/YMAyNQvkxpQ==
X-Google-Smtp-Source: ACHHUZ6jV+ONi3ybLvFIhIyvf3OiC8w+essNXZliTLvmbK4Zqg2Ma4EYAwZ47adUyL2ndFDagh/rUg==
X-Received: by 2002:a17:907:72d1:b0:96f:5511:8803 with SMTP id du17-20020a17090772d100b0096f55118803mr16379880ejc.22.1684928705349;
        Wed, 24 May 2023 04:45:05 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d11-20020a17090694cb00b0096f8509f06dsm5573636ejy.158.2023.05.24.04.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 04:45:04 -0700 (PDT)
Date: Wed, 24 May 2023 13:45:03 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Jakub Buchocki <jakubx.buchocki@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: Re: [PATCH net] ice: Fix ice module unload
Message-ID: <ZG34v/FrUoEMkpMH@nanopsycho>
References: <20230523173033.3577110-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523173033.3577110-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 23, 2023 at 07:30:33PM CEST, anthony.l.nguyen@intel.com wrote:
>From: Jakub Buchocki <jakubx.buchocki@intel.com>
>
>Clearing interrupt scheme before PFR reset, during the removal routine,
>could cause the hardware errors and possibly lead to system reboot, as
>the PF reset can cause the interrupt to be generated.
>Move clearing interrupt scheme from device deinitialization subprocedure,
>and call it directly in particular routines. In ice_remove(), call the
>ice_clear_interrupt_scheme() after the PFR is complete and all pending
>transactions are done.
>
>Error example:
>[   75.229328] ice 0000:ca:00.1: Failed to read Tx Scheduler Tree - User Selection data from flash
>[   77.571315] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
>[   77.571418] {1}[Hardware Error]: event severity: recoverable
>[   77.571459] {1}[Hardware Error]:  Error 0, type: recoverable
>[   77.571500] {1}[Hardware Error]:   section_type: PCIe error
>[   77.571540] {1}[Hardware Error]:   port_type: 4, root port
>[   77.571580] {1}[Hardware Error]:   version: 3.0
>[   77.571615] {1}[Hardware Error]:   command: 0x0547, status: 0x4010
>[   77.571661] {1}[Hardware Error]:   device_id: 0000:c9:02.0
>[   77.571703] {1}[Hardware Error]:   slot: 25
>[   77.571736] {1}[Hardware Error]:   secondary_bus: 0xca
>[   77.571773] {1}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
>[   77.571821] {1}[Hardware Error]:   class_code: 060400
>[   77.571858] {1}[Hardware Error]:   bridge: secondary_status: 0x2800, control: 0x0013
>[   77.572490] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
>[   77.572870] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
>[   77.573222] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
>[   77.573554] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
>[   77.691273] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
>[   77.691738] {2}[Hardware Error]: event severity: recoverable
>[   77.691971] {2}[Hardware Error]:  Error 0, type: recoverable
>[   77.692192] {2}[Hardware Error]:   section_type: PCIe error
>[   77.692403] {2}[Hardware Error]:   port_type: 4, root port
>[   77.692616] {2}[Hardware Error]:   version: 3.0
>[   77.692825] {2}[Hardware Error]:   command: 0x0547, status: 0x4010
>[   77.693032] {2}[Hardware Error]:   device_id: 0000:c9:02.0
>[   77.693238] {2}[Hardware Error]:   slot: 25
>[   77.693440] {2}[Hardware Error]:   secondary_bus: 0xca
>[   77.693641] {2}[Hardware Error]:   vendor_id: 0x8086, device_id: 0x347a
>[   77.693853] {2}[Hardware Error]:   class_code: 060400
>[   77.694054] {2}[Hardware Error]:   bridge: secondary_status: 0x0800, control: 0x0013
>[   77.719115] pci 0000:ca:00.1: AER: can't recover (no error_detected callback)
>[   77.719140] pcieport 0000:c9:02.0: AER: device recovery failed
>[   77.719216] pcieport 0000:c9:02.0: AER: aer_status: 0x00200000, aer_mask: 0x00100020
>[   77.719390] pcieport 0000:c9:02.0:    [21] ACSViol                (First)
>[   77.719557] pcieport 0000:c9:02.0: AER: aer_layer=Transaction Layer, aer_agent=Receiver ID
>[   77.719723] pcieport 0000:c9:02.0: AER: aer_uncor_severity: 0x00463010
>
>Fixes: 5b246e533d01 ("ice: split probe into smaller functions")
>Signed-off-by: Jakub Buchocki <jakubx.buchocki@intel.com>
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/ice/ice_main.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
>index a1f7c8edc22f..5052250b147e 100644
>--- a/drivers/net/ethernet/intel/ice/ice_main.c
>+++ b/drivers/net/ethernet/intel/ice/ice_main.c
>@@ -4802,7 +4802,6 @@ static int ice_init_dev(struct ice_pf *pf)
> static void ice_deinit_dev(struct ice_pf *pf)
> {
> 	ice_free_irq_msix_misc(pf);
>-	ice_clear_interrupt_scheme(pf);
> 	ice_deinit_pf(pf);
> 	ice_deinit_hw(&pf->hw);
> }
>@@ -5071,6 +5070,7 @@ static int ice_init(struct ice_pf *pf)
> 	ice_dealloc_vsis(pf);
> err_alloc_vsis:
> 	ice_deinit_dev(pf);
>+	ice_clear_interrupt_scheme(pf);

Can't you maintain the same order of calling
ice_clear_interrupt_scheme() and ice_deinit_pf()?

> 	return err;
> }
> 
>@@ -5098,6 +5098,8 @@ int ice_load(struct ice_pf *pf)
> 	if (err)
> 		return err;

Don't you need pci_wait_for_pending_transaction() here as well?

Btw, why can't you do reset in ice_unload to follow the same patterns as
probe/remove?


> 
>+	ice_clear_interrupt_scheme(pf);
>+
> 	err = ice_init_dev(pf);
> 	if (err)
> 		return err;
>@@ -5132,6 +5134,7 @@ int ice_load(struct ice_pf *pf)
> 	ice_vsi_decfg(ice_get_main_vsi(pf));
> err_vsi_cfg:
> 	ice_deinit_dev(pf);
>+	ice_clear_interrupt_scheme(pf);
> 	return err;
> }
> 
>@@ -5251,6 +5254,7 @@ ice_probe(struct pci_dev *pdev, const struct pci_device_id __always_unused *ent)
> 	ice_deinit_eth(pf);
> err_init_eth:
> 	ice_deinit(pf);
>+	ice_clear_interrupt_scheme(pf);
> err_init:
> 	pci_disable_device(pdev);
> 	return err;
>@@ -5360,6 +5364,7 @@ static void ice_remove(struct pci_dev *pdev)
> 	 */
> 	ice_reset(&pf->hw, ICE_RESET_PFR);
> 	pci_wait_for_pending_transaction(pdev);
>+	ice_clear_interrupt_scheme(pf);
> 	pci_disable_device(pdev);
> }
> 
>-- 
>2.38.1
>
>


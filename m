Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 328E16B0313
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCHJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCHJj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:39:29 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA099D6D
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:39:24 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x3so63080333edb.10
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 01:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678268363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=M1zlrC6RZlCKCfBD3+u+Lp2apvEP0qlKjHTzIM3eYX0=;
        b=JwJ4yXCc/FzOJ4s2gRiCfZ8okeeaADMchRu1IMMMrtvlmDFyebEkHIS1LUPRsxBbHN
         cFcbi2Xh0jjCQwmJt5+3N9o2pjV8ohJ+Dnd0IL8Jc4T9TKB+3kgIAXmxPSOGHeSmWRrb
         2pNsLwxaAv/kOv2Sxtte7CNGRQ4hh2YDx0nbIpNmxgGqpdRssBs2EvNBXdjoGXbelKPc
         jrYqaajAwuPplXxhuxryEdMsT56KZDI9gjnLRa/IczKCuoQ7DRA+yXsN/ic2zDdhSHDx
         kPdDPSaLs4iVjSIGxkPRpS/CA+9bajZefmRCWgNSI18cPAd8bQWsGYpObYGowNjAw7Xp
         m5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678268363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1zlrC6RZlCKCfBD3+u+Lp2apvEP0qlKjHTzIM3eYX0=;
        b=xzGNVqTdv5VOjMvz32gTnQwKSTEXxYpp/lHZJf7J4lYdOE3kmmkQ1gUER8WQ0OOhHe
         l2TCxi7YgQVJMJiv8mByqSKeu4apdzIdQn2VMeK2qDhcNL7OLYprvvvNyr3G94o5je90
         KRJN575Ix/yYn7AUlA29XoMz3WoEeXv5CYDE/aHjCu47esC4kiGSjbF2jjBXDwmwLMgd
         Sp0MnwDCFhqsvWtXJQUBc9U4fDjG0PoAHD8CKg0s6tAh8NpBiJpyeuvFDLntZjHLJEqX
         m/hZ4ek0VyC+hpRxMF/2Sm4S5IE162clg0tOyloS4WBE4r5o1Y4TDSjX6KHLcGW9GAxl
         cW5g==
X-Gm-Message-State: AO0yUKXt0mUZTOmphzU/ubNXDSCSu80dnKhAG5hRe5+JfKgHy+xnzsJ9
        jFM1RevHwBvOX/Ue5DsJ3a76Hw==
X-Google-Smtp-Source: AK7set+XyCpDS7FPdzO3fhreMLMf5FKbUTszBhiGPlRYQADJ1WwTJfA7JX4qZy+7/rnzDylopfZlmQ==
X-Received: by 2002:a17:906:3002:b0:8b2:fb3d:9f22 with SMTP id 2-20020a170906300200b008b2fb3d9f22mr16669116ejz.33.1678268363119;
        Wed, 08 Mar 2023 01:39:23 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c14-20020a50f60e000000b004af720b855fsm7948234edn.82.2023.03.08.01.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 01:39:22 -0800 (PST)
Date:   Wed, 8 Mar 2023 10:39:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
Subject: Re: [PATCH RFC v4 net-next 03/13] pds_core: health timer and
 workqueue
Message-ID: <ZAhXycSgSiNFwpNl@nanopsycho>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-4-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308051310.12544-4-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Mar 08, 2023 at 06:13:00AM CET, shannon.nelson@amd.com wrote:
>Add in the periodic health check and the related workqueue,
>as well as the handlers for when a FW reset is seen.

Why don't you use devlink health to let the user know that something odd
happened with HW?


>
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>---
> drivers/net/ethernet/amd/pds_core/core.c | 60 ++++++++++++++++++++++++
> drivers/net/ethernet/amd/pds_core/dev.c  |  3 ++
> drivers/net/ethernet/amd/pds_core/main.c | 51 ++++++++++++++++++++
> include/linux/pds/pds_core.h             | 10 ++++
> 4 files changed, 124 insertions(+)
>
>diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
>index 88a6aa42cc28..87717bf40e80 100644
>--- a/drivers/net/ethernet/amd/pds_core/core.c
>+++ b/drivers/net/ethernet/amd/pds_core/core.c
>@@ -34,3 +34,63 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
> 
> 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
> }
>+
>+static void pdsc_fw_down(struct pdsc *pdsc)
>+{
>+	mutex_lock(&pdsc->config_lock);
>+
>+	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>+		dev_err(pdsc->dev, "%s: already happening\n", __func__);
>+		mutex_unlock(&pdsc->config_lock);
>+		return;
>+	}
>+
>+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
>+
>+	mutex_unlock(&pdsc->config_lock);
>+}
>+
>+static void pdsc_fw_up(struct pdsc *pdsc)
>+{
>+	int err;
>+
>+	mutex_lock(&pdsc->config_lock);
>+
>+	if (!test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>+		dev_err(pdsc->dev, "%s: fw not dead\n", __func__);
>+		mutex_unlock(&pdsc->config_lock);
>+		return;
>+	}
>+
>+	err = pdsc_setup(pdsc, PDSC_SETUP_RECOVERY);
>+	if (err)
>+		goto err_out;
>+
>+	mutex_unlock(&pdsc->config_lock);
>+
>+	return;
>+
>+err_out:
>+	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
>+	mutex_unlock(&pdsc->config_lock);
>+}
>+
>+void pdsc_health_thread(struct work_struct *work)
>+{
>+	struct pdsc *pdsc = container_of(work, struct pdsc, health_work);
>+	bool healthy;
>+
>+	healthy = pdsc_is_fw_good(pdsc);
>+	dev_dbg(pdsc->dev, "%s: health %d fw_status %#02x fw_heartbeat %d\n",
>+		__func__, healthy, pdsc->fw_status, pdsc->last_hb);
>+
>+	if (test_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
>+		if (healthy)
>+			pdsc_fw_up(pdsc);
>+	} else {
>+		if (!healthy)
>+			pdsc_fw_down(pdsc);
>+	}
>+
>+	pdsc->fw_generation = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
>+}
>diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
>index 7a9db1505c1f..43229c149b2f 100644
>--- a/drivers/net/ethernet/amd/pds_core/dev.c
>+++ b/drivers/net/ethernet/amd/pds_core/dev.c
>@@ -177,6 +177,9 @@ int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
> 	err = pdsc_devcmd_wait(pdsc, max_seconds);
> 	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
> 
>+	if (err == -ENXIO || err == -ETIMEDOUT)
>+		pdsc_queue_health_check(pdsc);
>+
> 	return err;
> }
> 
>diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
>index 0c63bbe8b417..ac1b30f78e0e 100644
>--- a/drivers/net/ethernet/amd/pds_core/main.c
>+++ b/drivers/net/ethernet/amd/pds_core/main.c
>@@ -25,6 +25,31 @@ static const struct pci_device_id pdsc_id_table[] = {
> };
> MODULE_DEVICE_TABLE(pci, pdsc_id_table);
> 
>+void pdsc_queue_health_check(struct pdsc *pdsc)
>+{
>+	unsigned long mask;
>+
>+	/* Don't do a check when in a transition state */
>+	mask = BIT_ULL(PDSC_S_INITING_DRIVER) |
>+	       BIT_ULL(PDSC_S_STOPPING_DRIVER);
>+	if (pdsc->state & mask)
>+		return;
>+
>+	/* Queue a new health check if one isn't already queued */
>+	queue_work(pdsc->wq, &pdsc->health_work);
>+}
>+
>+static void pdsc_wdtimer_cb(struct timer_list *t)
>+{
>+	struct pdsc *pdsc = from_timer(pdsc, t, wdtimer);
>+
>+	dev_dbg(pdsc->dev, "%s: jiffies %ld\n", __func__, jiffies);
>+	mod_timer(&pdsc->wdtimer,
>+		  round_jiffies(jiffies + pdsc->wdtimer_period));
>+
>+	pdsc_queue_health_check(pdsc);
>+}
>+
> static void pdsc_unmap_bars(struct pdsc *pdsc)
> {
> 	struct pdsc_dev_bar *bars = pdsc->bars;
>@@ -135,8 +160,11 @@ static int pdsc_init_vf(struct pdsc *pdsc)
> 	return -1;
> }
> 
>+#define PDSC_WQ_NAME_LEN 24
>+
> static int pdsc_init_pf(struct pdsc *pdsc)
> {
>+	char wq_name[PDSC_WQ_NAME_LEN];
> 	int err;
> 
> 	pcie_print_link_status(pdsc->pdev);
>@@ -151,6 +179,13 @@ static int pdsc_init_pf(struct pdsc *pdsc)
> 	if (err)
> 		goto err_out_release_regions;
> 
>+	/* General workqueue and timer, but don't start timer yet */
>+	snprintf(wq_name, sizeof(wq_name), "%s.%d", PDS_CORE_DRV_NAME, pdsc->id);
>+	pdsc->wq = create_singlethread_workqueue(wq_name);
>+	INIT_WORK(&pdsc->health_work, pdsc_health_thread);
>+	timer_setup(&pdsc->wdtimer, pdsc_wdtimer_cb, 0);
>+	pdsc->wdtimer_period = PDSC_WATCHDOG_SECS * HZ;
>+
> 	mutex_init(&pdsc->devcmd_lock);
> 	mutex_init(&pdsc->config_lock);
> 
>@@ -167,11 +202,20 @@ static int pdsc_init_pf(struct pdsc *pdsc)
> 
> 	mutex_unlock(&pdsc->config_lock);
> 
>+	/* Lastly, start the health check timer */
>+	mod_timer(&pdsc->wdtimer, round_jiffies(jiffies + pdsc->wdtimer_period));
>+
> 	return 0;
> 
> err_out_teardown:
> 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
> err_out_unmap_bars:
>+	del_timer_sync(&pdsc->wdtimer);
>+	if (pdsc->wq) {
>+		flush_workqueue(pdsc->wq);
>+		destroy_workqueue(pdsc->wq);
>+		pdsc->wq = NULL;
>+	}
> 	mutex_unlock(&pdsc->config_lock);
> 	mutex_destroy(&pdsc->config_lock);
> 	mutex_destroy(&pdsc->devcmd_lock);
>@@ -262,6 +306,13 @@ static void pdsc_remove(struct pci_dev *pdev)
> 		mutex_lock(&pdsc->config_lock);
> 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
> 
>+		del_timer_sync(&pdsc->wdtimer);
>+		if (pdsc->wq) {
>+			flush_workqueue(pdsc->wq);
>+			destroy_workqueue(pdsc->wq);
>+			pdsc->wq = NULL;
>+		}
>+
> 		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
> 		mutex_unlock(&pdsc->config_lock);
> 		mutex_destroy(&pdsc->config_lock);
>diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
>index da0663925018..e73af422fae0 100644
>--- a/include/linux/pds/pds_core.h
>+++ b/include/linux/pds/pds_core.h
>@@ -12,6 +12,8 @@
> #include <linux/pds/pds_intr.h>
> 
> #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
>+
>+#define PDSC_WATCHDOG_SECS	5
> #define PDSC_TEARDOWN_RECOVERY	false
> #define PDSC_TEARDOWN_REMOVING	true
> #define PDSC_SETUP_RECOVERY	false
>@@ -63,12 +65,17 @@ struct pdsc {
> 	u8 fw_generation;
> 	unsigned long last_fw_time;
> 	u32 last_hb;
>+	struct timer_list wdtimer;
>+	unsigned int wdtimer_period;
>+	struct work_struct health_work;
> 
> 	struct pdsc_devinfo dev_info;
> 	struct pds_core_dev_identity dev_ident;
> 	unsigned int nintrs;
> 	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
> 
>+	struct workqueue_struct *wq;
>+
> 	unsigned int devcmd_timeout;
> 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
> 	struct mutex config_lock;	/* lock for configuration operations */
>@@ -81,6 +88,8 @@ struct pdsc {
> 	u64 __iomem *kern_dbpage;
> };
> 
>+void pdsc_queue_health_check(struct pdsc *pdsc);
>+
> struct pdsc *pdsc_dl_alloc(struct device *dev, bool is_pf);
> void pdsc_dl_free(struct pdsc *pdsc);
> int pdsc_dl_register(struct pdsc *pdsc);
>@@ -116,5 +125,6 @@ int pdsc_dev_init(struct pdsc *pdsc);
> 
> int pdsc_setup(struct pdsc *pdsc, bool init);
> void pdsc_teardown(struct pdsc *pdsc, bool removing);
>+void pdsc_health_thread(struct work_struct *work);
> 
> #endif /* _PDSC_H_ */
>-- 
>2.17.1
>

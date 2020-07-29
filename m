Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1E231F03
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgG2NIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2NIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:08:35 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C92FC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:08:35 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k8so2905913wma.2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=84yCJjdD2suX18dQu9ia7Nj7ffpzMukNgEXmklWNHoQ=;
        b=ISXXI0kMzGGkTFt2EoHn6Rex9r0li2by8WeP1v5HKJzZMm7TI7CUfLL6cOPwlj9CJM
         abWhCBJn9cNL1v/vWZG7stBZPGRV7GzUutPLXACEVdR0QGY2ZZCkH5Xh9e9iCjdVW3gl
         amCqZY6MBFb4h4lZpUO/rx16nF6CDox/oTI4DH0aYlUZp2PTUd795ry6gJIvnM7WMNRP
         DmUnrD4TJ3YculIn0OCUN5ks1Ru4CTrqUkZrgPF6kq64v8qQTUTRijBupN5upURQkk6o
         zyU1tim/1A6lls19jXuaq43wcMbAT4JEujrmbcQfaSHW1YePsZveWU/RDsp+PRDHeGjK
         lGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84yCJjdD2suX18dQu9ia7Nj7ffpzMukNgEXmklWNHoQ=;
        b=WEzjiQNGTKdnhyKqG9PR114YSjR/jH/sHMhTUVS+JnnuCiRTBVPi9zFSWyjc6zbWey
         xiTRXN9+3yOhFX68ZNwDzOFBXPFgh0fC8ABJXyAlUBDR/yVg3ib4x7STaicJM1MwDxgR
         zfmykbiyZXjAdifDVSbAxKG6urjBkkr2d8tqTaJNx4YFUakwriX3Ns6Xb8nR2UQ6DxeJ
         L2KUddTknByPzL/webiv7r3Th93uNAVYeDGYEXY06Dvb8YrcCivJGQoDnZ/Rcjfwwcia
         cRPrFXHfjfLRyyD+2iNQsMM2cu+EvLL63U93SpAxBvk0jGKZEX2zK/+1eidFpGVw4CFR
         Qw9w==
X-Gm-Message-State: AOAM531K5oonCVi524qoV7V7aWXnxqNNLkJYXUKmynIuFRTqra6Js9vu
        dirn3NUiLuSdnpTgYUcm8Jahjg==
X-Google-Smtp-Source: ABdhPJyB5ufqfe5ondAdfiLwMAPdPZgwqt8J8H/g1Jdu9Olx5tOJIVvx1LaYkStDQK95rk0PZuj4Ng==
X-Received: by 2002:a1c:6583:: with SMTP id z125mr8351111wmb.173.1596028114117;
        Wed, 29 Jul 2020 06:08:34 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k126sm5439903wme.17.2020.07.29.06.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 06:08:33 -0700 (PDT)
Date:   Wed, 29 Jul 2020 15:08:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v3 net-next 07/11] qed: use devlink logic to report errors
Message-ID: <20200729130833.GE2204@nanopsycho>
References: <20200729113846.1551-1-irusskikh@marvell.com>
 <20200729113846.1551-8-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729113846.1551-8-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 29, 2020 at 01:38:42PM CEST, irusskikh@marvell.com wrote:
>Use devlink_health_report to push error indications.
>We implement this in qede via callback function to make it possible
>to reuse the same for other drivers sitting on top of qed in future.
>
>Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
>Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>---
> drivers/net/ethernet/qlogic/qed/qed_devlink.c | 17 +++++++++++++++++
> drivers/net/ethernet/qlogic/qed/qed_devlink.h |  2 ++
> drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
> drivers/net/ethernet/qlogic/qede/qede.h       |  1 +
> drivers/net/ethernet/qlogic/qede/qede_main.c  |  5 ++++-
> include/linux/qed/qed_if.h                    |  3 +++
> 6 files changed, 28 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>index 843a35f14cca..ffe776a4f99a 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>@@ -14,6 +14,23 @@ enum qed_devlink_param_id {
> 	QED_DEVLINK_PARAM_ID_IWARP_CMT,
> };
> 
>+struct qed_fw_fatal_ctx {
>+	enum qed_hw_err_type err_type;
>+};
>+
>+int qed_report_fatal_error(struct devlink *devlink, enum qed_hw_err_type err_type)
>+{
>+	struct qed_devlink *qdl = devlink_priv(devlink);
>+	struct qed_fw_fatal_ctx fw_fatal_ctx = {
>+		.err_type = err_type,
>+	};
>+
>+	devlink_health_report(qdl->fw_reporter,
>+			      "Fatal error reported", &fw_fatal_ctx);

saying "reported" to the reporter sounds odd. Maybe occurred?


>+
>+	return 0;
>+}
>+
> static const struct devlink_health_reporter_ops qed_fw_fatal_reporter_ops = {
> 		.name = "fw_fatal",
> };
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.h b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>index c68ecf778826..ccc7d1d1bfd4 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.h
>@@ -15,4 +15,6 @@ void qed_devlink_unregister(struct devlink *devlink);
> void qed_fw_reporters_create(struct devlink *devlink);
> void qed_fw_reporters_destroy(struct devlink *devlink);
> 
>+int qed_report_fatal_error(struct devlink *dl, enum qed_hw_err_type err_type);
>+
> #endif
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
>index d1a559ccf516..a64d594f9294 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
>@@ -3007,6 +3007,7 @@ const struct qed_common_ops qed_common_ops_pass = {
> 	.update_msglvl = &qed_init_dp,
> 	.devlink_register = qed_devlink_register,
> 	.devlink_unregister = qed_devlink_unregister,
>+	.report_fatal_error = qed_report_fatal_error,
> 	.dbg_all_data = &qed_dbg_all_data,
> 	.dbg_all_data_size = &qed_dbg_all_data_size,
> 	.chain_alloc = &qed_chain_alloc,
>diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
>index 1f0e7505a973..3efc5899f656 100644
>--- a/drivers/net/ethernet/qlogic/qede/qede.h
>+++ b/drivers/net/ethernet/qlogic/qede/qede.h
>@@ -264,6 +264,7 @@ struct qede_dev {
> 
> 	struct bpf_prog			*xdp_prog;
> 
>+	enum qed_hw_err_type		last_err_type;
> 	unsigned long			err_flags;
> #define QEDE_ERR_IS_HANDLED		31
> #define QEDE_ERR_ATTN_CLR_EN		0
>diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
>index 7c2d948b2035..df437c3f1fc9 100644
>--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
>+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
>@@ -1181,7 +1181,6 @@ static int __qede_probe(struct pci_dev *pdev, u32 dp_module, u8 dp_level,
> 		}
> 	} else {
> 		struct net_device *ndev = pci_get_drvdata(pdev);
>-

Leftover. Please remove.


> 		edev = netdev_priv(ndev);
> 
> 		if (edev && edev->devlink) {
>@@ -2603,6 +2602,9 @@ static void qede_generic_hw_err_handler(struct qede_dev *edev)
> 		  "Generic sleepable HW error handling started - err_flags 0x%lx\n",
> 		  edev->err_flags);
> 
>+	if (edev->devlink)
>+		edev->ops->common->report_fatal_error(edev->devlink, edev->last_err_type);
>+
> 	/* Trigger a recovery process.
> 	 * This is placed in the sleep requiring section just to make
> 	 * sure it is the last one, and that all the other operations
>@@ -2663,6 +2665,7 @@ static void qede_schedule_hw_err_handler(void *dev,
> 		return;
> 	}
> 
>+	edev->last_err_type = err_type;
> 	qede_set_hw_err_flags(edev, err_type);
> 	qede_atomic_hw_err_handler(edev);
> 	set_bit(QEDE_SP_HW_ERR, &edev->sp_flags);
>diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
>index 30fe06fe06a0..1297726f2b25 100644
>--- a/include/linux/qed/qed_if.h
>+++ b/include/linux/qed/qed_if.h
>@@ -906,6 +906,9 @@ struct qed_common_ops {
> 
> 	int (*dbg_all_data_size) (struct qed_dev *cdev);
> 
>+	int		(*report_fatal_error)(struct devlink *devlink,
>+					      enum qed_hw_err_type err_type);
>+
> /**
>  * @brief can_link_change - can the instance change the link or not
>  *
>-- 
>2.17.1
>

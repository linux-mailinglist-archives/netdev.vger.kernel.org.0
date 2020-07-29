Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E0A231ED1
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 14:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgG2Mwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 08:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2Mwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 08:52:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7631CC061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:52:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z18so17978519wrm.12
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8818DZ6lHDMXehTjR3d44dzubyYD1NOYlMoafMEU3g=;
        b=Bs1HXgHDXj93/XPHr+j3fgQau/eHYpaNA0Cfq+0MXaIOOZAWishsOaoySlsixXp/D5
         x2oqa/dQCPvDx1ZGajIHPKinU6isJbC4/yF+ulPVKARrOjapW0BO6vPvbAhZFw4Gq25j
         V6oTW37uDxBoIjVrzLJOrrqPptPO3hsHge5LvVL27PqMlHnAxyW3W34qJfX2qx7NnOZ1
         U08VkZsD/La/Ga6vng42uRBZY6oQldk80dCYw8/wC9JLNSo62YGBUzwGmFzwgzInfeDy
         taHFCvnugSGeoCNobM0dyqMHV/8SsqaI4DRn7bkuxwfWtz1NIejOVqNYD0cM22K2z9hb
         udPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8818DZ6lHDMXehTjR3d44dzubyYD1NOYlMoafMEU3g=;
        b=JKWexDFYGrnKf45WVTDo86NXaXaxYUYmFvjm/6LI2zJw3DijEoNfkls05AQR/hnk4s
         AdMZh22ufIA4Ru8ZumFWfRcBM5mfOdPjYCRwYVv7k95ZBzgkRIpk4qtIAMCZ++HLjici
         uIVohzrv0LiSAYKGek6VK9+XiybQ7i2DxsEcXZTknH22bdRHUaE2dfpGvJfcZvF7M+t4
         rXoG2KsSQDeXuvXzcmabZAB7gd4PCLkmTbuel1m5Ly6ZNOe/56CswtH8v8kOptT7DzVk
         leiRE/o2LFPdC6fbtobnC9c6XdVNe2IagY2w+Ch2Wshiej5ADycq6ZDJMUpuTRC3vDLx
         XwGQ==
X-Gm-Message-State: AOAM532thNV9F3jfDiQNunaiM6I2P5kwk+7c7nc7cJNzQsi59hNZW+pq
        WUSUwQjrQp/EEafN6MgrTjw8cw==
X-Google-Smtp-Source: ABdhPJzWWz/SruXlvf3vurYRLBZTWG2VwRx8tXa9T+vqEcpMA0NRkws+9o6l2qsSialfOnYJw1PGqA==
X-Received: by 2002:adf:e98c:: with SMTP id h12mr29032995wrm.3.1596027172177;
        Wed, 29 Jul 2020 05:52:52 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p14sm6089955wrx.90.2020.07.29.05.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 05:52:51 -0700 (PDT)
Date:   Wed, 29 Jul 2020 14:52:51 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v3 net-next 05/11] qed: implement devlink info request
Message-ID: <20200729125251.GD2204@nanopsycho>
References: <20200729113846.1551-1-irusskikh@marvell.com>
 <20200729113846.1551-6-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729113846.1551-6-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 29, 2020 at 01:38:40PM CEST, irusskikh@marvell.com wrote:
>Here we return existing fw & mfw versions, we also fetch device's
>serial number.
>
>The base device specific structure (qed_dev_info) was not directly
>available to the base driver before.
>Thus, here we create and store a private copy of this structure
>in qed_dev root object.
>
>Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
>Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>---
> drivers/net/ethernet/qlogic/qed/qed.h         |  1 +
> drivers/net/ethernet/qlogic/qed/qed_dev.c     | 10 ++++
> drivers/net/ethernet/qlogic/qed/qed_devlink.c | 52 ++++++++++++++++++-
> drivers/net/ethernet/qlogic/qed/qed_main.c    |  1 +
> 4 files changed, 63 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
>index b6ce1488abcc..ccd789eeda3e 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed.h
>+++ b/drivers/net/ethernet/qlogic/qed/qed.h
>@@ -807,6 +807,7 @@ struct qed_dev {
> 	struct qed_llh_info *p_llh_info;
> 
> 	/* Linux specific here */
>+	struct qed_dev_info		common_dev_info;
> 	struct  qede_dev		*edev;
> 	struct  pci_dev			*pdev;
> 	u32 flags;
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>index b3c9ebaf2280..377950ce8ea2 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
>@@ -4290,6 +4290,16 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
> 		__set_bit(QED_DEV_CAP_ROCE,
> 			  &p_hwfn->hw_info.device_capabilities);
> 
>+	/* Read device serial number information from shmem */
>+	addr = MCP_REG_SCRATCH + nvm_cfg1_offset +
>+		offsetof(struct nvm_cfg1, glob) +
>+		offsetof(struct nvm_cfg1_glob, serial_number);
>+
>+	p_hwfn->hw_info.part_num[0] = qed_rd(p_hwfn, p_ptt, addr);
>+	p_hwfn->hw_info.part_num[1] = qed_rd(p_hwfn, p_ptt, addr + 4);
>+	p_hwfn->hw_info.part_num[2] = qed_rd(p_hwfn, p_ptt, addr + 8);
>+	p_hwfn->hw_info.part_num[3] = qed_rd(p_hwfn, p_ptt, addr + 12);

for() ?


>+
> 	return qed_mcp_fill_shmem_func_info(p_hwfn, p_ptt);
> }
> 
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>index 4e3316c6beb6..5bd5528dc409 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>@@ -45,7 +45,57 @@ static const struct devlink_param qed_devlink_params[] = {
> 			     qed_dl_param_get, qed_dl_param_set, NULL),
> };
> 
>-static const struct devlink_ops qed_dl_ops;
>+static int qed_devlink_info_get(struct devlink *devlink,
>+				struct devlink_info_req *req,
>+				struct netlink_ext_ack *extack)
>+{
>+	struct qed_devlink *qed_dl = devlink_priv(devlink);
>+	struct qed_dev *cdev = qed_dl->cdev;
>+	struct qed_dev_info *dev_info;
>+	char buf[100];
>+	int err;
>+
>+	dev_info = &cdev->common_dev_info;
>+
>+	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
>+	if (err)
>+		return err;
>+
>+	memcpy(buf, cdev->hwfns[0].hw_info.part_num, sizeof(cdev->hwfns[0].hw_info.part_num));
>+	buf[sizeof(cdev->hwfns[0].hw_info.part_num)] = 0;
>+
>+	if (buf[0]) {
>+		err = devlink_info_serial_number_put(req, buf);
>+		if (err)
>+			return err;
>+	}
>+
>+	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
>+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_3),
>+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_2),
>+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_1),
>+		 GET_MFW_FIELD(dev_info->mfw_rev, QED_MFW_VERSION_0));
>+
>+	err = devlink_info_version_stored_put(req,
>+					      DEVLINK_INFO_VERSION_GENERIC_FW_MGMT, buf);
>+	if (err)
>+		return err;
>+
>+	snprintf(buf, sizeof(buf), "%d.%d.%d.%d",
>+		 dev_info->fw_major,
>+		 dev_info->fw_minor,
>+		 dev_info->fw_rev,
>+		 dev_info->fw_eng);
>+
>+	err = devlink_info_version_running_put(req,
>+					       DEVLINK_INFO_VERSION_GENERIC_FW, buf);

return = devlink...


>+
>+	return err;
>+}
>+
>+static const struct devlink_ops qed_dl_ops = {
>+	.info_get = qed_devlink_info_get,
>+};
> 
> struct devlink *qed_devlink_register(struct qed_dev *cdev)
> {
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
>index d6f76421379b..d1a559ccf516 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
>@@ -479,6 +479,7 @@ int qed_fill_dev_info(struct qed_dev *cdev,
> 	}
> 
> 	dev_info->mtu = hw_info->mtu;
>+	cdev->common_dev_info = *dev_info;
> 
> 	return 0;
> }
>-- 
>2.17.1
>

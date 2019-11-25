Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD5F108B84
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfKYKUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:20:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36628 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbfKYKUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:20:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id n188so13293131wme.1
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 02:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Us3qZpPW+o5WzN8X1EHn/ef9hjXmJ0M2q3EFvfHEjsQ=;
        b=R9t2XQ9fjv8G9AYQYgHpPAojOUzpa6jr+InQnFAXzsuN919gYUXObizp9/EAlfdHtb
         LIt0tIDZ3uGAKNgPAQoLPvW+8MSfGRcN+KeuPHRCzbXFYDMQcC2qtE4VemGA5mEQoglt
         ZT6grpVnZpGoczn27McO7NMPb/nUiIGMN2j5AenRMW9rsPhVfeQzQ9jzdz3YvXplZgUd
         mdwwl5iB+J2zRwKz57JIyboXQg11udnLsGvC4xtgu45J0zB9L8qVl80QuKgY30Pr6LR/
         3z/HX/25LgdKi0wOD0STdgsSFz8oe0mco0zp7A7j1N5BU98isPaMfxJWW9bf73exMYAP
         emsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Us3qZpPW+o5WzN8X1EHn/ef9hjXmJ0M2q3EFvfHEjsQ=;
        b=jg3aDV3RcpNpFYE8ADF1VXIVXoDm/DnJePevzs+GRfV/IfsHaCrXWHGX09nvoUNZBl
         YMl4lEib0e3jXwnjxXlahWn6TVe7mkLfM6TE1boHbL+Yu6JesaiS81pcb4UQXMMVHHmI
         aFKWdm0HCixCrDh88/VOc9mPWqBZ+bYpd5BPUx/7IkYVOuOcMGb2m9W43asDcbvyzahx
         YRNU3AObmyFHedaeuUmrsQllPnuWj9ck8dvGfvJbbZG8z5gqKKNWsS1ypii76tbEoV9D
         XOEkArb4Dryf4aL1QwZA1J+1tqLTPTFzm7dD2KAMAG/vO+dMsVJrHCqyCLZgb4VN9H7m
         x9/g==
X-Gm-Message-State: APjAAAWQpk/OyS7PaanN/iKaCLUKWjwD62fwLx9YZLxuKinvARMba4rD
        211TCn3azSisUt+3f3wOTT1uLzA0INY=
X-Google-Smtp-Source: APXvYqxZL1SE3tzeBlGLk4hUWDY5C1oAcGygwvJZqd2gWCMQa8/fPPob5rpgIN2+o+m8onkm6yr4hQ==
X-Received: by 2002:a05:600c:2254:: with SMTP id a20mr9060630wmm.97.1574677200783;
        Mon, 25 Nov 2019 02:20:00 -0800 (PST)
Received: from localhost (ip-94-113-116-128.net.upcbroadband.cz. [94.113.116.128])
        by smtp.gmail.com with ESMTPSA id u16sm9840714wrr.65.2019.11.25.02.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 02:19:59 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:19:59 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next v2 13/13] bnxt_en: Add support for flashing the
 device via devlink
Message-ID: <20191125101959.GA5526@nanopsycho>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
 <1574566250-7546-14-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574566250-7546-14-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Nov 24, 2019 at 04:30:50AM CET, michael.chan@broadcom.com wrote:
>From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
>Use the same bnxt_flash_package_from_file() function to support
>devlink flash operation.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>---
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 20 ++++++++++++++++++++
> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 ++--
> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 ++
> 3 files changed, 24 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index 7078271..acb2dd6 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -14,6 +14,25 @@
> #include "bnxt.h"
> #include "bnxt_vfr.h"
> #include "bnxt_devlink.h"
>+#include "bnxt_ethtool.h"
>+
>+static int
>+bnxt_dl_flash_update(struct devlink *dl, const char *filename,
>+		     const char *region, struct netlink_ext_ack *extack)
>+{
>+	struct bnxt *bp = bnxt_get_bp_from_dl(dl);
>+
>+	if (region)
>+		return -EOPNOTSUPP;
>+
>+	if (!BNXT_PF(bp)) {
>+		NL_SET_ERR_MSG_MOD(extack,
>+				   "flash update not supported from a VF");
>+		return -EPERM;
>+	}
>+
>+	return bnxt_flash_package_from_file(bp->dev, filename, 0);
>+}
> 
> static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
> 				     struct devlink_fmsg *fmsg,
>@@ -225,6 +244,7 @@ static const struct devlink_ops bnxt_dl_ops = {
> 	.eswitch_mode_set = bnxt_dl_eswitch_mode_set,
> 	.eswitch_mode_get = bnxt_dl_eswitch_mode_get,
> #endif /* CONFIG_BNXT_SRIOV */
>+	.flash_update	  = bnxt_dl_flash_update,

Could you please consider implementing flash status notifications?
See:
devlink_flash_update_begin_notify()
devlink_flash_update_end_notify()
devlink_flash_update_status_notify()


Thanks!


> };
> 
> enum bnxt_dl_param_id {
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
>index e455aaa..2ccf79c 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
>@@ -2000,8 +2000,8 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
> 	return rc;
> }
> 
>-static int bnxt_flash_package_from_file(struct net_device *dev,
>-					char *filename, u32 install_type)
>+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
>+				 u32 install_type)
> {
> 	struct bnxt *bp = netdev_priv(dev);
> 	struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
>index 01de7e7..4428d0a 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
>@@ -81,6 +81,8 @@ extern const struct ethtool_ops bnxt_ethtool_ops;
> u32 _bnxt_fw_to_ethtool_adv_spds(u16, u8);
> u32 bnxt_fw_to_ethtool_speed(u16);
> u16 bnxt_get_fw_auto_link_speeds(u32);
>+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
>+				 u32 install_type);
> void bnxt_ethtool_init(struct bnxt *bp);
> void bnxt_ethtool_free(struct bnxt *bp);
> 
>-- 
>2.5.1
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F238D109827
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 04:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfKZDw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 22:52:28 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45179 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbfKZDw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 22:52:28 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so12806092lfa.12
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 19:52:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ldPLXbC/GI0ETw4G8kqyLMvjGw3q+i0+jwx/mhTTq4=;
        b=LDXCn7F64WXK3J0D6l/8lOqeEdJByUTZ0RuCrvqXwgAaMg1VzBQJQKjp5Co9Eo7bzP
         IuIzvsQ0ICUawX8TQu1YoZ3m+LY5bC/aXcA3bRCG7Kr8LRlPaie9xdnXAsER7flxdcj+
         Z02QvF2CrD+9y1OnyCu97pL7EjhpOuxhQBOWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ldPLXbC/GI0ETw4G8kqyLMvjGw3q+i0+jwx/mhTTq4=;
        b=BDfF6tsz+Nh7eUo76sxNp2whOSQ53YuKur5FYwb5LgcBCogRrCEeg1CACQ+ZWKYnIY
         YSsxMv5yDPCC+zM7irTriWLLDX60c0b74qXBTGEYwibPOLx5OMTmN1FaLKSkXbGtwjQK
         IAHLydppTG6+DY8wxJzt+hCEHBzvfzKFagPrqOo30fjeuLKeHd4G+FB2B8Tt7blycmtS
         /FhRMAr6BxpQYQZjZnJM1Sio+602kAQeXMJ1ZvJi52dVRXUc9l0P//JlZ5/sqixGMfPF
         xQ3ESoHwBtOuHBwihi+G/WmSuarSMzDmWtRpu25SoloVLMV60KoyfMisX63agsogfk/v
         IxVA==
X-Gm-Message-State: APjAAAUz+j+kc3NaMBgXoqcE7ZpLE+LhohKPahWFArs5ePkAhMDOggrK
        FU25h/fD7TFfTGwhNKc9qYr2dFOEZuNEOLtz3y73RA==
X-Google-Smtp-Source: APXvYqwI3J+AHPrZctJQ2JHMHc80t+uUVUmNFqj8EyBjTmMQN7jf5kvYphdMOkRgIi2kYgadjzdGeO+Vn0SKXJqsT94=
X-Received: by 2002:a19:f811:: with SMTP id a17mr22421246lff.132.1574740345891;
 Mon, 25 Nov 2019 19:52:25 -0800 (PST)
MIME-Version: 1.0
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
 <1574566250-7546-14-git-send-email-michael.chan@broadcom.com> <20191125101959.GA5526@nanopsycho>
In-Reply-To: <20191125101959.GA5526@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 26 Nov 2019 09:22:13 +0530
Message-ID: <CAACQVJqpT8aYdQZGzg=9iv=wejZN3AKbMDACv4RF8uFinkEuwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 13/13] bnxt_en: Add support for flashing the
 device via devlink
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 3:50 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sun, Nov 24, 2019 at 04:30:50AM CET, michael.chan@broadcom.com wrote:
> >From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >
> >Use the same bnxt_flash_package_from_file() function to support
> >devlink flash operation.
> >
> >Cc: Jiri Pirko <jiri@mellanox.com>
> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >---
> > drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 20 ++++++++++++++++++++
> > drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  4 ++--
> > drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 ++
> > 3 files changed, 24 insertions(+), 2 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >index 7078271..acb2dd6 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >@@ -14,6 +14,25 @@
> > #include "bnxt.h"
> > #include "bnxt_vfr.h"
> > #include "bnxt_devlink.h"
> >+#include "bnxt_ethtool.h"
> >+
> >+static int
> >+bnxt_dl_flash_update(struct devlink *dl, const char *filename,
> >+                   const char *region, struct netlink_ext_ack *extack)
> >+{
> >+      struct bnxt *bp = bnxt_get_bp_from_dl(dl);
> >+
> >+      if (region)
> >+              return -EOPNOTSUPP;
> >+
> >+      if (!BNXT_PF(bp)) {
> >+              NL_SET_ERR_MSG_MOD(extack,
> >+                                 "flash update not supported from a VF");
> >+              return -EPERM;
> >+      }
> >+
> >+      return bnxt_flash_package_from_file(bp->dev, filename, 0);
> >+}
> >
> > static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
> >                                    struct devlink_fmsg *fmsg,
> >@@ -225,6 +244,7 @@ static const struct devlink_ops bnxt_dl_ops = {
> >       .eswitch_mode_set = bnxt_dl_eswitch_mode_set,
> >       .eswitch_mode_get = bnxt_dl_eswitch_mode_get,
> > #endif /* CONFIG_BNXT_SRIOV */
> >+      .flash_update     = bnxt_dl_flash_update,
>
> Could you please consider implementing flash status notifications?
> See:
> devlink_flash_update_begin_notify()
> devlink_flash_update_end_notify()
> devlink_flash_update_status_notify()
>
>
> Thanks!
Sure. Thanks.
>
>
> > };
> >
> > enum bnxt_dl_param_id {
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> >index e455aaa..2ccf79c 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> >@@ -2000,8 +2000,8 @@ static int bnxt_flash_firmware_from_file(struct net_device *dev,
> >       return rc;
> > }
> >
> >-static int bnxt_flash_package_from_file(struct net_device *dev,
> >-                                      char *filename, u32 install_type)
> >+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
> >+                               u32 install_type)
> > {
> >       struct bnxt *bp = netdev_priv(dev);
> >       struct hwrm_nvm_install_update_output *resp = bp->hwrm_cmd_resp_addr;
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> >index 01de7e7..4428d0a 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> >@@ -81,6 +81,8 @@ extern const struct ethtool_ops bnxt_ethtool_ops;
> > u32 _bnxt_fw_to_ethtool_adv_spds(u16, u8);
> > u32 bnxt_fw_to_ethtool_speed(u16);
> > u16 bnxt_get_fw_auto_link_speeds(u32);
> >+int bnxt_flash_package_from_file(struct net_device *dev, const char *filename,
> >+                               u32 install_type);
> > void bnxt_ethtool_init(struct bnxt *bp);
> > void bnxt_ethtool_free(struct bnxt *bp);
> >
> >--
> >2.5.1
> >

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B376200815
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 13:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgFSLuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 07:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbgFSLuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 07:50:37 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F45C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 04:50:36 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id q19so9885700eja.7
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 04:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=SBS+mvGi67HgJNtzhQqZXnFFo0amR2a8sxOiwv5KE/c=;
        b=tiLY1K255hG8qWgijYs1MFvZdFPg4jSA1Qq2esBpUUAD8wRjpzFqUfL/QmKERJOjBb
         Lwycd6f1IIAzb4Zn8dKohlNCjUpPwKffWxb6aJt0Trd7Sqq122arp/oz729C6F+0pvLC
         vlU+BON8o8p4X5c16WIebVUwlnpmDcSO/wJQ/t27EOoSnq18npFLZsOql84uyG4ekUJ9
         1tcyEyCmRV/anfifJVwmgVp12PTh7A7Rypoh//8wHkuJHaFrFrn8L3TafImEY3Gg8tOe
         PWbGbgtKJ1haibAxGGd3tbrbpg6+fFCflsFx8AZwt2igvGbeUqhoi09ccxkAgCB2HK09
         KG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SBS+mvGi67HgJNtzhQqZXnFFo0amR2a8sxOiwv5KE/c=;
        b=bHp1pIlerUU/qfHziOC6LxCANlPmktoa6lUGYjK5bNhBug+i1JJ48bz+y5JTQypsJU
         qPLd8VmP/K57qI1uJ0yy5VMdBp/NEQ981gf2Ybcz0Yg9sKnf8hBfl9oI5ORrxNHXDbi7
         XLFJZiWR+7neaafnJ9dIsjcnnEwwILLbuabbQ1HQdhnSSQ4HWDKPePU7Ff2z7wt3y1DB
         yQWseQ5oWLlNlY9NKvImRBpfsi9gkyNGSRtlI5bPrHCRHTZmBuAevdLByMi47EDAVuSs
         Js98tCPqXXSld4T4D4clsKaQMYEwXHx9Bp6KI0iuB7c4leyggf97ijPVbajs0I/Ft0A6
         IbJQ==
X-Gm-Message-State: AOAM532Ri7wKUvpvb3Wsa3pj6d6uFj4r33d0+9H9mRqLG9n+2YXuMBOr
        lDDYzzcIzsmUoNBf9nNozorNNIjijQ2DWFHbo+tg+CO2QD3c63NuxEC7ZwkMwl2vsDIQUS69/W/
        9yJ4rAil+4etuGDFicRfyJIV+sGmxwG96as5lB+r/+HvgWn6KJ5K8OMWkDVppeTRFFpuwGk4OsQ
        ==
X-Google-Smtp-Source: ABdhPJyZO/oc2VOKl8vWz7C4UoerNDJbClDBroYf9T0gNG+sWeTxNfo9csKu5HdI/SM5vHBYYvAm5A==
X-Received: by 2002:a17:906:a288:: with SMTP id i8mr3386117ejz.324.1592567434974;
        Fri, 19 Jun 2020 04:50:34 -0700 (PDT)
Received: from tardismint.netronome.com (102-65-182-147.dsl.web.africa. [102.65.182.147])
        by smtp.googlemail.com with ESMTPSA id f1sm4422176edn.66.2020.06.19.04.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 04:50:34 -0700 (PDT)
From:   louis.peens@netronome.com
To:     netdev@vger.kernel.org
Cc:     dsahem@gmail.com, oss-drivers@netronome.com,
        Louis Peens <louis.peens@netronome.com>
Subject: [PATCH iproute2-next] devlink: add 'disk' to 'fw_load_policy' string validation
Date:   Fri, 19 Jun 2020 13:50:07 +0200
Message-Id: <20200619115007.10463-1-louis.peens@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@netronome.com>

The 'fw_load_policy' devlink parameter supports the 'disk' value
since kernel v5.4, seems like there was some oversight in adding
this to iproute, fixed by this patch.

Signed-off-by: Louis Peens <louis.peens@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 devlink/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 507972c3..a0a7770a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2349,6 +2349,11 @@ static const struct param_val_conv param_val_conv[] = {
 		.vstr = "flash",
 		.vuint = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_FLASH,
 	},
+	{
+		.name = "fw_load_policy",
+		.vstr = "disk",
+		.vuint = DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
+	},
 	{
 		.name = "reset_dev_on_drv_probe",
 		.vstr = "unknown",
-- 
2.17.1


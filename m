Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B3F3A8032
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFONgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:36:46 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:18826 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhFONgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:36:19 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623764033; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=bIqp0AJnjs3EN1lBoq0EnBfT5OYxVkJiYgGjYhQo4uRow1+nDjiXjjUFKxs1bTikB2
    UN1nk/Cmv63z+ywiXyRApZRPZvt04nWauxHjk5XVIdlsdw89tdBWlYR4zaoaMQ7sDOcP
    uLi4uCSaMB7Jo2+EwDZ9fztUpX3WgEVFb2TNfjg8EzOzgSX7/uVSPZqh3a6UUcEIPPsw
    gpjUbGNpJOaORxDIFHoonAK1y69ijcnZvuulfm5atimH2w/OlkyWgsk1BbOmxSYewKIb
    US2zv4PvbQTwp79G8Gm/ujANTJ7tTEzgcHMe/iOFx2XxyEvksSdjGxV1Ke1vmNfT/OD9
    sKsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764033;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3TdVNRSVdWVw+TLJWZU/FaKUgvTAWh+NLNbOyH7Egqo=;
    b=NkJvkf2r6HRpRVFDtP5GrqbunOrmKKcbWqE+h2jGGuEY0OXDgd8AN7rc/uR8ZXXN6y
    o6PBYLMPrqqUgk51zFRN17bpluRKilY1lkJhpb9Rrfgb9LKri3OcZm89vRwRWAzm7Gq8
    ZI4OrNJATonX+th/t9kKy3MUfiCDsrMMBCGMEyOligRNXc8RyoLvN5qwGzWYXtaUpoqt
    sRCOhuy4Yt0ntZjlTWJnytw4gBXh7IY19Km+/tjaSSn+Dd18rprQrzIsg0XzL26K98D5
    uOT27avskD+mnfG/47bLscMp+LnyK+W/ppyl186e/8SPkNJhy8rKLEenxUplFAu9jpQ5
    xCQg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623764033;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=3TdVNRSVdWVw+TLJWZU/FaKUgvTAWh+NLNbOyH7Egqo=;
    b=rU/M87SIQ2fP0OgGR1bWk2BKe8E4Bwg9oPzVfiiP5LseRl+PsC5NpJr2s5mqxG+/3c
    hXhZpL+R+ULkNTgKpVJlN/r9XqlE9YqFRW37CCPr0nauCN2lliPYY54ORlTl/GOpmEVj
    LdLwPaQC78uRkejcPF4Ekq/xhMH0VbvuyLCE/EaVt3vjk7HKDZgIiZ89N1PVK0FjXw80
    NW7ChYouJjFH+J/2lXRZ0p12DaNedBmYGECCP7Y2Xf43xKOdtEQYHyU1AiMYuTQtpuBw
    xK6WVFfuJIgfwOowbYTV07mk3FetgS33A75OKMW5tWzuw39HcejBFLKLWvCxi6fThQtA
    JwJg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxA6m6NutzT"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id y01375x5FDXqOsm
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 15 Jun 2021 15:33:52 +0200 (CEST)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, phone-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next 1/3] rpmsg: core: Add driver_data for rpmsg_device_id
Date:   Tue, 15 Jun 2021 15:32:27 +0200
Message-Id: <20210615133229.213064-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210615133229.213064-1-stephan@gerhold.net>
References: <20210615133229.213064-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most device_id structs provide a driver_data field that can be used
by drivers to associate data more easily for a particular device ID.
Add the same for the rpmsg_device_id.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 drivers/rpmsg/rpmsg_core.c      | 4 +++-
 include/linux/mod_devicetable.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/rpmsg_core.c b/drivers/rpmsg/rpmsg_core.c
index e5daee4f9373..c1404d3dae2c 100644
--- a/drivers/rpmsg/rpmsg_core.c
+++ b/drivers/rpmsg/rpmsg_core.c
@@ -459,8 +459,10 @@ static int rpmsg_dev_match(struct device *dev, struct device_driver *drv)
 
 	if (ids)
 		for (i = 0; ids[i].name[0]; i++)
-			if (rpmsg_id_match(rpdev, &ids[i]))
+			if (rpmsg_id_match(rpdev, &ids[i])) {
+				rpdev->id.driver_data = ids[i].driver_data;
 				return 1;
+			}
 
 	return of_driver_match_device(dev, drv);
 }
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 7d45b5f989b0..8e291cfdaf06 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -447,6 +447,7 @@ struct hv_vmbus_device_id {
 
 struct rpmsg_device_id {
 	char name[RPMSG_NAME_SIZE];
+	kernel_ulong_t driver_data;
 };
 
 /* i2c */
-- 
2.32.0


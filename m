Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D912DEEAD
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 13:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgLSMU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 07:20:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22892 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgLSMU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 07:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608380370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mEZ3iiZSubrgfLl2Uja4+r/ORFBgkENywrKNeCuFP7Q=;
        b=MTwXLRY0fYBJEIO9mfv5iqpmKicchNGm8xjDGPMJ2IAue2FAX3HM2qd7AocaSGTn2SCMU5
        Wdme7AIXnw+mlVDr7ZakQUt1h9iGJiCdFpoNNTmtM2gM1bdYvqyT6CDUnd7qMyHpiB/Akp
        Qda6mnYj2yS6Q1EpoFyU8rwhfu7+whg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-EKeCuMp8MVOMpF-krQ6OXA-1; Sat, 19 Dec 2020 07:19:28 -0500
X-MC-Unique: EKeCuMp8MVOMpF-krQ6OXA-1
Received: by mail-wr1-f72.google.com with SMTP id b8so3059788wrv.14
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 04:19:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=mEZ3iiZSubrgfLl2Uja4+r/ORFBgkENywrKNeCuFP7Q=;
        b=Jk4poS5yerMYG+qq10F0pEpceByQXAgQ4C94IIJRbuCvuoF5ewWLoZTaTF0teV8eOX
         WDtjZXmHMT9rwh696mQme3Hc7vlO/mafwRAx0+uwhuEyoI2jM/7piYZ2/pqB/M19Qwhu
         UNcxeqGFWrMc77YeG6pxoH9AaNh9KVDJZfMeM5a07x2m3pzIsy3LM15frHTQOOHVK9JC
         +7eTXpeeKY2jBEI6ib5eyN2sc08hHu8Pfme9ap+bWwxt1qmaEHA//yJXQc87aElzfj6F
         qAMpIDsac9HSCe5E3h93RIK5TFePvmxV/0Eo/VHg3xW9rMeG2OKEdYFho3ofkAQbIMXe
         wAhg==
X-Gm-Message-State: AOAM5305MxwsEg3jQXgtEl1lPjEXzCBvBlDhA47nG//9oqZWNHDUftJe
        /s/jwT4xdUB1sThZiLQbNC+paZZo4OxBtXqhpNtihF+6rvvV6hfqYQB84HqQXkjNYx7Bd3+4AOS
        YmaPASmyBLHtfnuSF
X-Received: by 2002:adf:fd0c:: with SMTP id e12mr9212280wrr.61.1608380366752;
        Sat, 19 Dec 2020 04:19:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwm2UOMFNx8MmE7PoFHNHnTNuWuv53iMg+BZ6u4eIP+q0dYSqp3XItVqGBFx3C4fUVGfY6T6w==
X-Received: by 2002:adf:fd0c:: with SMTP id e12mr9212269wrr.61.1608380366593;
        Sat, 19 Dec 2020 04:19:26 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id h15sm17281572wru.4.2020.12.19.04.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 04:19:26 -0800 (PST)
Date:   Sat, 19 Dec 2020 13:19:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tom Parkin <tparkin@katalix.com>,
        James Chapman <jchapman@katalix.com>
Subject: [PATCH net] ppp: Fix PPPIOCUNBRIDGECHAN request number
Message-ID: <e3a4c355e3820331d8e1fffef8522739aae58b57.1608380117.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PPPIOCGL2TPSTATS already uses 54. This shouldn't be a problem in
practice, but let's keep the logical decreasing assignment scheme.

Fixes: 4cf476ced45d ("ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---

Original patch was committed to net-next just 9 days ago. It isn't part
of any released kernel yet. So it should be safe to apply this change.

 include/uapi/linux/ppp-ioctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index 8dbecb3ad036..1cc5ce0ae062 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -116,7 +116,7 @@ struct pppol2tp_ioc_stats {
 #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
 #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
 #define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
-#define PPPIOCUNBRIDGECHAN _IO('t', 54)	/* unbridge channel */
+#define PPPIOCUNBRIDGECHAN _IO('t', 52)	/* unbridge channel */
 
 #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
 #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
-- 
2.21.3


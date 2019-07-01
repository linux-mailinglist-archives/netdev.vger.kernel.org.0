Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868C05BDE5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 16:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfGAOQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 10:16:19 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34205 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbfGAOQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 10:16:19 -0400
Received: by mail-pf1-f195.google.com with SMTP id c85so6666675pfc.1;
        Mon, 01 Jul 2019 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aU81YLmtNxqWZklfwNAkUBvxOdz2ODKbjR3KAUMEhlQ=;
        b=lO3wmrJpC6g9zZD+1L5/ejH39084n8XF2JiLQ3DoGhfguS1cm3qszgP8Hn8OhqMImn
         8vbvTveK4rPUtXlPTB6U9JKnKcy9YeFgbo1xwl15MuLzcjMglsQZGxVgP46B3BLDYu3x
         fsJDSLHwUPXD1W7aOpRNkSCHd+IVpBGGkRIcZliEyaZez8H+YzhUSlFlnXn4ad3eTGfR
         m/jWRsM6ubP+KPK+AeMDyfKDC85REVwFolhWbBA97xbs9BLluwcJq/rNytgk+TRVDr5B
         kb24AphWGSXzjpddnIHPHgjRt6bZYRgz1da6epdCM38UxNmAKyYzR/9fwM2R9IfXAFiE
         NJGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aU81YLmtNxqWZklfwNAkUBvxOdz2ODKbjR3KAUMEhlQ=;
        b=o2rXPmf29XWctFKKaY9Y55vjBVG6R6aBJd9Nkj0HweuDQfrtawqgUeyPdbW0VC+yEt
         IaKgLrkISUW46XWJ66nQbldbSbP5mATLp5bIxt0AiPosU+nt0vC2fPhfrD+I+9IsipoK
         4Gl8zcVyCta4Sjl3OksXuHX9ySK18XVJ4asXJMm/SoXW4W0JJad2XtAd78GWeJPnPEk8
         mw9lngVsO45+o9W/V+dSepUNxMfRua31gznP/erKjinLad98Hlo++8xV/vhguxSSqSpz
         7qwtCOLGWWrudV8rpKutD49FlFDDjk7/VGRnOB+TmGU8NHVPXQo6CFAsT+guMlSOOg6c
         RywQ==
X-Gm-Message-State: APjAAAXCBPtqac57CHzzb9OeBtaA8sH5arZZXFMSkKd0l74/V3c8ZOYe
        0vwFNkIWdbBOrEF99jW8yFQ=
X-Google-Smtp-Source: APXvYqyXnijCB5EGBO8i0ckMnvz0NKunjw+peIQzJVg2w7ejSGl9lKH2gy1mgzYCv1ZmMq6ll2rB9w==
X-Received: by 2002:a63:6ec4:: with SMTP id j187mr7271663pgc.420.1561990578513;
        Mon, 01 Jul 2019 07:16:18 -0700 (PDT)
Received: from bnva-HP-Pavilion-g6-Notebook-PC.domain.name ([117.248.64.59])
        by smtp.gmail.com with ESMTPSA id s15sm12015991pfd.183.2019.07.01.07.16.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 07:16:17 -0700 (PDT)
From:   Vandana BN <bnvandana@gmail.com>
To:     "David S . Miller " <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Vandana BN <bnvandana@gmail.com>
Subject: [PATCH] net:gue.h:Fix shifting signed 32-bit value by 31 bits problem
Date:   Mon,  1 Jul 2019 19:46:10 +0530
Message-Id: <20190701141610.3681-1-bnvandana@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix GUE_PFLAG_REMCSUM to use "U" cast to avoid shifting signed
32-bit value by 31 bits problem.

Signed-off-by: Vandana BN <bnvandana@gmail.com>
---
 include/net/gue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index fdad41469b65..3a6595bfa641 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -60,7 +60,7 @@ struct guehdr {

 /* Private flags in the private option extension */

-#define GUE_PFLAG_REMCSUM	htonl(1 << 31)
+#define GUE_PFLAG_REMCSUM	htonl(1U << 31)
 #define GUE_PLEN_REMCSUM	4

 #define GUE_PFLAGS_ALL	(GUE_PFLAG_REMCSUM)
--
2.17.1


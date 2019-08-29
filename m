Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44179A250D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfH2S1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:27:53 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:40896 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbfH2S1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 14:27:50 -0400
Received: by mail-pg1-f169.google.com with SMTP id w10so2027691pgj.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TtPxceUlIq8zPPlX23dSFW/mk6vB0aKQghFjNBu7v4o=;
        b=Tr+SyrSRKQBqzqw++rPC59klaicRJ0XjbXG9JtzD3z4caWV0MR8wGGiZvfn46JrbQR
         4of7ad8Zeg4KxIbon75ErIB2g0zOJspS/JUTSAl3eO7BNZiQU9VQJcd2iHrA+kc4VHsS
         W9T3lKdSg5W7F7Ac8QwwFEs+4nvPsPK2QFLE+fkrPvrFafkXMxyyl/nZNWRkXcalPWxp
         RmKvrAaEKpWNuQLHX5fpVcHgaLMGljEf5WZ32NXTRSJOcPgz9cGLhG2XHY0IHslIYu2D
         eHl8XgPBMjQzgiSQRwK4M6UqwwrU9vJCOqbCwlO0KNGrv0e2OJtl1zop5LU/jyxYFZfL
         nBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TtPxceUlIq8zPPlX23dSFW/mk6vB0aKQghFjNBu7v4o=;
        b=I1WRdv2FxDc5s8Zdqmj5EiQj66U4DGZXmwaxnGl0Ka0iJl5Wr+20nYwlTtGCuI1Aek
         6SjvMZsOT7e4vaqtPLP1Z5Goqcl1hr2riMSrTV1VgTPzvZak8Kt4HUnV/oLwOmfumpFZ
         OzqyiwyjRj57+wFDPDxscY5DLBCVRnKGelJSji/TXYegF/tbTaoFkKP84C1vRGMMgIL/
         YcCCWlm7JIzwAlBQIy/2kU9Xhc0C3wOLm6NljddTYXB+YEIUR2VV319HxOcqeEDWk/la
         BHnLT/ATGfP/X3YHntpAn5tGwJHe8ZO7xucgoIIBcNljYQORe5QQGot/SwgNuMoASuhM
         6mDg==
X-Gm-Message-State: APjAAAVqMhMlTar+fzrKZ353KEyW+fWDF1iItKPM962hBrE2ZB/VaPc0
        /RnowmYJWgbAWOZ406NFRP3T+w==
X-Google-Smtp-Source: APXvYqz7fAvL3x4OkplDA7xL7RJAbt7qMU/sccsxa4zCixGjzKlwfu4cT0IISAMKL/RZqrFDn8fb9A==
X-Received: by 2002:a62:3887:: with SMTP id f129mr13545288pfa.245.1567103270063;
        Thu, 29 Aug 2019 11:27:50 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id t70sm3082824pjb.2.2019.08.29.11.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Aug 2019 11:27:49 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     snelson@pensando.io, netdev@vger.kernel.org, davem@davemloft.net
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v6 net-next 01/19] devlink: Add new info version tags for ASIC and FW
Date:   Thu, 29 Aug 2019 11:27:02 -0700
Message-Id: <20190829182720.68419-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190829182720.68419-1-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current tag set is still rather small and needs a couple
more tags to help with ASIC identification and to have a
more generic FW version.

Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../networking/devlink-info-versions.rst         | 16 ++++++++++++++++
 include/net/devlink.h                            |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/Documentation/networking/devlink-info-versions.rst b/Documentation/networking/devlink-info-versions.rst
index 4316342b7746..4914f581b1fd 100644
--- a/Documentation/networking/devlink-info-versions.rst
+++ b/Documentation/networking/devlink-info-versions.rst
@@ -14,11 +14,27 @@ board.rev
 
 Board design revision.
 
+asic.id
+=======
+
+ASIC design identifier.
+
+asic.rev
+========
+
+ASIC design revision.
+
 board.manufacture
 =================
 
 An identifier of the company or the facility which produced the part.
 
+fw
+==
+
+Overall firmware version, often representing the collection of
+fw.mgmt, fw.app, etc.
+
 fw.mgmt
 =======
 
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 7f43c48f54cd..b5476db66cfa 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -458,6 +458,13 @@ enum devlink_param_generic_id {
 /* Maker of the board */
 #define DEVLINK_INFO_VERSION_GENERIC_BOARD_MANUFACTURE	"board.manufacture"
 
+/* Part number, identifier of asic design */
+#define DEVLINK_INFO_VERSION_GENERIC_ASIC_ID	"asic.id"
+/* Revision of asic design */
+#define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
+
+/* Overall FW version */
+#define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
 /* Control processor FW version */
 #define DEVLINK_INFO_VERSION_GENERIC_FW_MGMT	"fw.mgmt"
 /* Data path microcode controlling high-speed packet processing */
-- 
2.17.1


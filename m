Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190CF3AA3E4
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhFPTKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbhFPTK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:29 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007DAC06175F
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:22 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id q20so6066402lfo.2
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TveMsDiAYx4LUYO2CwQNe1XuHAWA/htRnEHF57RNIUk=;
        b=GRsi4mjEdWOx+gMqyTrmBY/2Gv/cbZtMo8YR7hmlhMP3rs6fRBZW9ugznhpZ4OMTJW
         k7dDYwiKDz96MZXNrcZfJ+N2UwllLAZLSD9wHfog3GDFsCGRtB/a6DH/q2flC3SSelfx
         AKwV8qH/zbot4YVVtuuxZQW3OpTAY1y811nftEGil1NNVEB2gZPFY7ujBW4Wv62CqR1l
         2ok8+Y/Z0rKhWRGqiPncLWGyG98wd07AxEcS3sBZ2AICzfJuE/+6d7jtvQBzfcU+3m7r
         47pgvTd68nrb/bAD9wi02PDqfurlGV9NdKd8mBpR3HmFXpMiRFgXspWOEYqCq6FJgRvT
         VtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TveMsDiAYx4LUYO2CwQNe1XuHAWA/htRnEHF57RNIUk=;
        b=GcoKFG1dvf0lh4vF5nu+DBVLEkKhfOi46H1GEx/cfi+lsHS2gclvpe+SdJw/t5+aux
         VC0YTkG0ba59l/WA/Hwvy1OlPE4Aw+9aIeQnlaJDwTvlGSR8wyijz0QEVCWSfGN2AT4j
         e8+WqAtgPatKaqJSVnrdLSWRa8SbvT6rK/eRzDzSk57LjYaJkDVv7VAPjQkE3LMbvB8e
         o9kOHD1baNflH5RTaR7jerHvf0FWVjS1Xl223x7tkbpxf9tuvuLi9ROxF6Tocdk6vgNm
         C/b/IAJ2NG0q95y+XQuJ3ySWBMwwQ64r0z8UvY5Tb2KjxoKBlraZH/8shCqzGqnMKn+B
         OnVA==
X-Gm-Message-State: AOAM532e99MEAHAqKT3Eg4sfnSgfFpxPiIce9RIw9P7KL/G6BcOYtzIp
        tkeg1jAn0KaaCggP/t8v4bJ2tg==
X-Google-Smtp-Source: ABdhPJxbTIBuB3iEoPlYr9f6hNq0NoROhaoCgimHWQJyrfe0VIVNfHnaNP74V5TZrbypNgG5vgnfzA==
X-Received: by 2002:a05:6512:3a85:: with SMTP id q5mr887099lfu.404.1623870501251;
        Wed, 16 Jun 2021 12:08:21 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:20 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 1/7] Documentation: ACPI: DSD: describe additional MAC configuration
Date:   Wed, 16 Jun 2021 21:07:53 +0200
Message-Id: <20210616190759.2832033-2-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210616190759.2832033-1-mw@semihalf.com>
References: <20210616190759.2832033-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document additional MAC configuration modes which can be processed
by the existing fwnode_ phylink helpers:

* "managed" standard ACPI _DSD property [1]
* "fixed-link" data-only subnode linked in the _DSD package via
  generic mechanism of the hierarchical data extension [2]

[1] https://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
[2] https://github.com/UEFI/DSD-Guide/blob/main/dsd-guide.pdf

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 Documentation/firmware-guide/acpi/dsd/phy.rst | 55 ++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/Documentation/firmware-guide/acpi/dsd/phy.rst b/Documentation/firmware-guide/acpi/dsd/phy.rst
index 7d01ae8b3cc6..839710b94a7f 100644
--- a/Documentation/firmware-guide/acpi/dsd/phy.rst
+++ b/Documentation/firmware-guide/acpi/dsd/phy.rst
@@ -49,6 +49,21 @@ phy-mode
 The "phy-mode" _DSD property is used to describe the connection to
 the PHY. The valid values for "phy-mode" are defined in [4].
 
+managed
+-------
+Optional property, which specifies the PHY management type.
+The valid values for "managed" are defined in [4].
+
+fixed-link
+----------
+The "fixed-link" is described by a the data-only subnode of the
+MAC port, which is linked in the _DSD package via
+hierarchical data extension (UUID dbb8e3e6-5886-4ba6-8795-1319f52a966b
+in accordance with [5] "_DSD Implementation Guide" document).
+The subnode should comprise a required property ("speed") and
+possibly the optional ones - complete list of parameters and
+their values are specified in [4].
+
 The following ASL example illustrates the usage of these properties.
 
 DSDT entry for MDIO node
@@ -121,6 +136,44 @@ phy-mode and phy-handle are used as explained earlier.
 	  })
 	}
 
+MAC node example where "managed" property is specified.
+-------------------------------------------------------
+::
+	Scope(\_SB.PP21.ETH0)
+	{
+	  Name (_DSD, Package () {
+	     ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package () {"phy-mode", "sgmii"},
+		     Package () {"managed", "in-band-status"}
+		 }
+	   })
+	}
+
+MAC node example with a "fixed-link" subnode.
+---------------------------------------------
+::
+	Scope(\_SB.PP21.ETH1)
+	{
+	  Name (_DSD, Package () {
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package () {"phy-mode", "sgmii"},
+		 },
+	    ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
+		 Package () {
+		     Package () {"fixed-link", "LNK0"}
+		 }
+	  })
+	  Name (LNK0, Package(){ // Data-only subnode of port
+	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+		 Package () {
+		     Package () {"speed", 1000},
+		     Package () {"full-duplex", 1}
+		 }
+	  })
+	}
+
 References
 ==========
 
@@ -131,3 +184,5 @@ References
 [3] Documentation/firmware-guide/acpi/DSD-properties-rules.rst
 
 [4] Documentation/devicetree/bindings/net/ethernet-controller.yaml
+
+[5] https://github.com/UEFI/DSD-Guide/blob/main/dsd-guide.pdf
-- 
2.29.0


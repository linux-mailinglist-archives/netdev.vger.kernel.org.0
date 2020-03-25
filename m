Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDFF193023
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgCYSMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:12:15 -0400
Received: from mail-lf1-f98.google.com ([209.85.167.98]:41661 "EHLO
        mail-lf1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgCYSMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 14:12:03 -0400
Received: by mail-lf1-f98.google.com with SMTP id z23so2622639lfh.8
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 11:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fLsD0pf0Z2Qy/ATTVpbRFX98Scq2+qNt41yDSpwIQQk=;
        b=iLyoXKlKVAEeJKb4GZYsqeun1adVsC9YRwFHuXskB9nuaEPBvhLao07deNQYw72RQZ
         wUwwf0sN6Ny/pl8t5eyZT7VfFmA3hHfjm0p/6KznAlT68UT2/NfUk4WM2Bzg2QPFbQNK
         Dq1SSAcgbZ97s/TTEkSa8wqn5E9oLog/QQ9+ti8S0vepfcEUM3V4wFHq5Zow6/K/fYGH
         U/veqSNDhMM86ByHOJR9SIOtlnkc38IhLnho9ySmFzY8ZsFnUvBQ23Ybb+NcJ4a7pQMO
         XTwn5dlOUF1oWN2ly2rRSEI7VzWpGaIUzS7n+zM1bjONc+vbSRGCjXC0QOf+r1RIlru6
         +A3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fLsD0pf0Z2Qy/ATTVpbRFX98Scq2+qNt41yDSpwIQQk=;
        b=cxxDuzij52+5/PkGbYsuH5KRWffMMFYt25WprJyypi5A+iiQaG2mjFo1UfsybHVcd0
         2flHq1GIQ44b44KWuJvL4ACXxpXIUNVwFBO7PfSgyBR1EP7h3HXjK7AIsDkwZxn69/bB
         pQVpkAveWtSvoV48jPo2nPRW7bbMvJuIxqwFbR7C+iGkQ7Rx954yd1vEp5N8rgqgjvJ9
         H8lw61dG5v8CXlmQVlOgLLsDTxMeKk1mR2yuJ0nBvHx5ZwXFY7UzafzJvRkrLVDw43q7
         qSeQJlwgjbP5Jx876U8dsfjhaByNyM3liF8rMhv9sRMXybenrdSJY9RE0hONLJHIIHZw
         bjiQ==
X-Gm-Message-State: ANhLgQ2QTbny/db49eHMRd8bj6Vu7I+gcG/C5l9ev8UQY0vLo9DO0Wx6
        iNh6XfqX9cm0lJScMsreVqYhhAqv3MBMfsBWxIMJBCkRAFlP
X-Google-Smtp-Source: ADFU+vu3J9uRTLiIP5vf8lSLTAkoSWCPvzFRTGJZ+RRp6NqycNXaFIzinWVyrA2u9iaNoUfPCIbblHthN6mv
X-Received: by 2002:a19:660a:: with SMTP id a10mr3091046lfc.9.1585159921405;
        Wed, 25 Mar 2020 11:12:01 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id x11sm55799lji.25.2020.03.25.11.12.01
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 11:12:01 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.190] (port=39524 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jHAVU-0003Oy-K9; Wed, 25 Mar 2020 19:12:00 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 4/4] ARM: dts: imx6: add fec gpr property.
Date:   Wed, 25 Mar 2020 19:11:59 +0100
Message-Id: <1585159919-11491-5-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is required for wake on lan on i.MX6

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index bc488df..65b0c8a 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1045,6 +1045,7 @@
 					 <&clks IMX6QDL_CLK_ENET>,
 					 <&clks IMX6QDL_CLK_ENET_REF>;
 				clock-names = "ipg", "ahb", "ptp";
+				gpr = <&gpr>;
 				status = "disabled";
 			};
 
-- 
1.9.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505CC10A3A3
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 18:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfKZRzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 12:55:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38002 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfKZRzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 12:55:52 -0500
Received: by mail-pg1-f194.google.com with SMTP id t3so8925013pgl.5;
        Tue, 26 Nov 2019 09:55:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TvvdTSqyYu1UERC53GMtsiAam2mDxhTlJf/JArDCSrQ=;
        b=OWHmv0rwNliBmYsjj8smIocF1JTsvaq9ItSMbiJn6nyDPUqSmrmj/rnuEL29GILHg/
         5c2AQ/giRF9hTOccWsp96yMWBot8xnUJKhxJIbs1hpknA+oJPABUjrPrvlf3XekzVB/q
         HHx3oOD8EzhFuRgGmWqQNa5jlkWi3tlz0ZCzizLTnaxSf/WL2zi9eJ9ixGLncAHmrGa6
         PCWoqGGTC2YK4TgVADQbwO3BfKKDzvNDZqUZubw+3oOlIEMjSR8pXjm3yHch0dB6yMsl
         YLYI4byIxjzAHH0IRgFWRaQYwVlfenObZpd16jdE15X3gHc0IjQSc2IkqRJSfw1bpkUu
         6u+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TvvdTSqyYu1UERC53GMtsiAam2mDxhTlJf/JArDCSrQ=;
        b=sH31WfQkpFTLgqda8eyBruqgE3eXik5DlZq6zGeeCAIPa7GT62vtRhFUOyz1C2a4AQ
         ZVYECAGQ/ua4JUkh5s6vHSWVMxIR2J0pNP+czyboQhEJSnbxYUIsbW6aQ430ftl4uLFE
         qdnjOyVt8bL2l4ZrKb1XGpuUKjS1t2MQ93GLD2VlvTd09YPKyqL4/DJ2Uk4o7mu7zpyI
         r2XhGIF1FmrCZPpLGh3oZRL6dRoWukELDmY3mYFIj84+xjwHrghYRCBaNJnlaEMwpIAL
         lLjGK9O8q9DtsmtHSKm3S8u9iSp5tBYd0MZlz6xTy/H5C3b7/rsvy0oONlKZd7WN/H0y
         1AvA==
X-Gm-Message-State: APjAAAWKM9lvHWAf/vS1t+M3j/5bXISiY9WO6ZADM+TLEUx55MlUfG7/
        AXVPLB9IyJAXjJvM6+qDu/c=
X-Google-Smtp-Source: APXvYqyOpcmH+LQLNqKMpeT7iy2nxBR7WsUOcR0vrbLmbLTb3Hw+LcDWtk0d4hjF2hFpb5IMctFCHg==
X-Received: by 2002:a63:5851:: with SMTP id i17mr39852959pgm.181.1574790950285;
        Tue, 26 Nov 2019 09:55:50 -0800 (PST)
Received: from debian.net.fpt ([2405:4800:58f7:2f79:ce3b:4b9:a68f:959f])
        by smtp.gmail.com with ESMTPSA id q6sm781577pfl.140.2019.11.26.09.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 09:55:49 -0800 (PST)
From:   Phong Tran <tranmanphong@gmail.com>
To:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org
Cc:     tranmanphong@gmail.com, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org,
        p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: [Patch v2 0/4] wireless: Fix -Wcast-function-type 
Date:   Wed, 27 Nov 2019 00:55:25 +0700
Message-Id: <20191126175529.10909-1-tranmanphong@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125150215.29263-1-tranmanphong@gmail.com>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change with v1:
 - align commit subject prefix with review comments.
 - split patch "drivers: net: intel: Fix -Wcast-function-type"
   into "ipw2x00" and "iwlegacy"
 - update tested by as
https://lore.kernel.org/linux-wireless/8eb8d6fd-de20-2d04-8210-ad8304d7da9e@lwfinger.net/

Phong Tran (4):
  b43legacy: Fix -Wcast-function-type
  ipw2x00: Fix -Wcast-function-type
  iwlegacy: Fix -Wcast-function-type
  rtlwifi: rtl_pci: Fix -Wcast-function-type

 drivers/net/wireless/broadcom/b43legacy/main.c |  5 +++--
 drivers/net/wireless/intel/ipw2x00/ipw2100.c   |  7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c   |  5 +++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c |  5 +++--
 drivers/net/wireless/intel/iwlegacy/4965-mac.c |  5 +++--
 drivers/net/wireless/realtek/rtlwifi/pci.c     | 10 ++++++----
 6 files changed, 22 insertions(+), 15 deletions(-)

-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2EE2274E2
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgGUBmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgGUBl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:41:59 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E7C061794;
        Mon, 20 Jul 2020 18:41:59 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id u8so8619937qvj.12;
        Mon, 20 Jul 2020 18:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ur2c1kUkd9ZrQzq4VWWYLEmliS5nAct4PfXTc3ZWjY=;
        b=PGoxY6nu2J8KZ7n7m/NoHkyfsX+L/y9vQngEN1sABqc6hlsNXA9g4vbkT6wlOcSzJz
         T0DpCPkYNX69HcMekAKCUURPHkDLS0ZB5Ygr4Df8Pva8Xt6aZNSb1Jc7ajXSSjYymlRZ
         Tao5D9rOJvz+VO2+nGj9hIQLlf2NA6x8Rj0vtycJh1EyPuiy5XRh7TcRbcLhPVmsLXRX
         O3ijWUvhzu/4V8XHwKhGdyhykf657+x8wqoWrcs7gbwhOuo6rY2sj5A3BhpotdXDU/A1
         vqJIC45nP7QJ39A/iSrNBbVtONV9HJm8QVTFXTjih20ERaEP2GxTYqyRzd9LOzny0k1Y
         GoJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ur2c1kUkd9ZrQzq4VWWYLEmliS5nAct4PfXTc3ZWjY=;
        b=Mzo9kzE4Qz+YOZ1uzxrnR976FctnEb0i9qABhAFcytm+U9kVWYBmgxGg3nFDrIQjTv
         gQcmXkS8EmcTnWvXwdHFQAP/rXHk4d+2D1sLGogq+MgtEHMCZli2KNA/QXv5oR8a+w7Q
         iUNn6G+7CvzJ74TrQuPcivJp8dQWvw2ryk+l0Cp+9Lv5bmrBNmF4nllsi4K64QAO2Xnu
         +Xoi6dpz6fmvtku83WeAgYSHh5TFvQJ778x45D574OIx+f24LSD4Gx8GPKAujIKYKNdk
         uzeEZ4ICB6+/Oez/6HMWVpCT1QzK13VPcfxmNr5ovlW42qNWSbw2exuoVaGQxJ9Tf9h/
         e+Jg==
X-Gm-Message-State: AOAM532p47YTNC3/hGo2nwc0bmzz96BOOnP+gg3GQpiyJnMUqBkEF4lI
        vc1igt4p6XW+6t0A8ozW+sU=
X-Google-Smtp-Source: ABdhPJwSEr2UsfiirjE/+bNK90Rc5zeKo8QpagBVewilFQBjOqxxvxPRnJpjBJSv9PKbaS6IMSootA==
X-Received: by 2002:ad4:54e9:: with SMTP id k9mr23042938qvx.193.1595295718964;
        Mon, 20 Jul 2020 18:41:58 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id a28sm1121967qko.45.2020.07.20.18.41.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2020 18:41:58 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id A18FF27C0054;
        Mon, 20 Jul 2020 21:41:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 20 Jul 2020 21:41:57 -0400
X-ME-Sender: <xms:5UcWXw6Mrjj8D_Wq_vLaRMVbIAEeWETjujozdxaH3e8AYua5UDSsQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeehgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenog
    fuohhrthgvugftvggtihhpvdculdegtddmnecujfgurhephffvufffkffojghfggfgsedt
    keertdertddtnecuhfhrohhmpeeuohhquhhnucfhvghnghcuoegsohhquhhnrdhfvghngh
    esghhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhephedvveetfefgiedutedtfeev
    vddvleekjeeuffffleeguefhhfejteekieeuueelnecukfhppeehvddrudehhedrudduud
    drjedunecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    sghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtie
    egqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhi
    gihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:5UcWXx5SBH1zrAVyTe_q9zdBIfR15pDIgIesjLboe2LWWximxo4UGA>
    <xmx:5UcWX_dCpsshrGnHCztI3NP5wSxbb9MFcFKiNd0owZ5mkoO1TuipOQ>
    <xmx:5UcWX1LZi0g5_8b-29YXL71lOSp9RJadkT9wek85hJlDu74-ol7Mnw>
    <xmx:5UcWX2ijX_FtvAKgdZOyEoGyZpgsl1ZeNFFW_g9xwJhZ_9lK0PoTo_5x4AU>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 200C230600A9;
        Mon, 20 Jul 2020 21:41:56 -0400 (EDT)
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [RFC 04/11] Drivers: hv: Use HV_HYP_PAGE in hv_synic_enable_regs()
Date:   Tue, 21 Jul 2020 09:41:28 +0800
Message-Id: <20200721014135.84140-5-boqun.feng@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200721014135.84140-1-boqun.feng@gmail.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the base_*_gpa should use the guest page number in Hyper-V page, so
use HV_HYP_PAGE instead of PAGE.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
---
 drivers/hv/hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 41b2ee06cc2f..e4f50dcdc46c 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -167,7 +167,7 @@ void hv_synic_enable_regs(unsigned int cpu)
 	hv_get_simp(simp.as_uint64);
 	simp.simp_enabled = 1;
 	simp.base_simp_gpa = virt_to_phys(hv_cpu->synic_message_page)
-		>> PAGE_SHIFT;
+		>> HV_HYP_PAGE_SHIFT;
 
 	hv_set_simp(simp.as_uint64);
 
@@ -175,7 +175,7 @@ void hv_synic_enable_regs(unsigned int cpu)
 	hv_get_siefp(siefp.as_uint64);
 	siefp.siefp_enabled = 1;
 	siefp.base_siefp_gpa = virt_to_phys(hv_cpu->synic_event_page)
-		>> PAGE_SHIFT;
+		>> HV_HYP_PAGE_SHIFT;
 
 	hv_set_siefp(siefp.as_uint64);
 
-- 
2.27.0


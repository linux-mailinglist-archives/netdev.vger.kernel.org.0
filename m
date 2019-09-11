Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23B5AFB18
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbfIKLIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:08:51 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38919 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfIKLIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:08:50 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so24704617qtb.6
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=axfcNZ/bC29h7dYz9Zn0syjDqRnOdjO40Rz4inJlsr4=;
        b=YLpPWAupUbWFMnXvhsZ3ptYNC05VABx5KYCg/G12jc4bWWRUJvcRYGNMLOzHdRpec4
         aeAa2QsYTKbwoI28zJ1W8mvwqN1YpNKll60IplGn1kOZ47Q2okH/rN13QMVSDn3qKib8
         7GA9oKq1oFHmfSTKG4bytn5xlKoNSrvXlZIa4vc1RsQtBlRMYGb70g/ourEWyFdmbau6
         FO09F03rzvy10Kyhpf5P0mNBj1Cq17H3pZlc1TIEI6B4b3WcrVYLcnpxLMoeOaaMkqud
         YK4I0c+2rWB1EtpixQjFqnDxei4gxt6nA4XNcdMMTbX2StQa3HZzVIYM624v9vW1CyRS
         sG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=axfcNZ/bC29h7dYz9Zn0syjDqRnOdjO40Rz4inJlsr4=;
        b=MyO5tLTyop62gw79bKooOIo/lP2DHYyzKXg4Sx5lW+reAvGak7Q8CbMrvuugOOZVJS
         HUafTSugPCiTk+UC899hFzxVMqhJ1S7AdtIJnQMESR86mU5XJpZGZsNCMidQAdOHzwn8
         9YRsvv9du+u6ELSjOdyfOuM6I82ge86E4k2xclLPcydu60dDh3aLlY4+uatUFfmo9EFE
         2mMLkYXdy+qJp4hdqjU66/TpGqeNIUHFw35BlWxy9SX/z9CZH0IKV61uJ4kfKAxmsT87
         +5MnPjMHprlGqx8nAhFR13FIZThfVXTSw6z/CV+EXNT/iVLEucpE2MZPbBE86h0JzWhS
         vLdw==
X-Gm-Message-State: APjAAAUJOkMgCs1CvmT/0CGiDqbSNOL9bZv4iwVU1hKbWTapIqCGVe4y
        4oJhiEYQAA/TdZc3FQM8IOFeCA==
X-Google-Smtp-Source: APXvYqyKqRziO4ohIw7LqjSfrswNdWm7v/46iQ50mPu/iyM9jMy1yR1TS1q6GQ8J+iPbIidB2J7vnw==
X-Received: by 2002:a0c:e74b:: with SMTP id g11mr16010814qvn.62.1568200129574;
        Wed, 11 Sep 2019 04:08:49 -0700 (PDT)
Received: from penelope.pa.netronome.com ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id a190sm10232501qkf.118.2019.09.11.04.08.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:08:48 -0700 (PDT)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH net-next 2/2] nfp: devlink: set unknown fw_load_policy
Date:   Wed, 11 Sep 2019 12:08:33 +0100
Message-Id: <20190911110833.9005-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190911110833.9005-1-simon.horman@netronome.com>
References: <20190911110833.9005-1-simon.horman@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

If the 'app_fw_from_flash' HWinfo key is invalid, set the
'fw_load_policy' devlink parameter value to unknown.

Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/devlink_param.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/devlink_param.c b/drivers/net/ethernet/netronome/nfp/devlink_param.c
index 4a8141b4d625..36491835ac65 100644
--- a/drivers/net/ethernet/netronome/nfp/devlink_param.c
+++ b/drivers/net/ethernet/netronome/nfp/devlink_param.c
@@ -32,7 +32,8 @@ static const struct nfp_devlink_param_u8_arg nfp_devlink_u8_args[] = {
 	[DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY] = {
 		.hwinfo_name = "app_fw_from_flash",
 		.default_hi_val = NFP_NSP_APP_FW_LOAD_DEFAULT,
-		.invalid_dl_val = -EINVAL,
+		.invalid_dl_val =
+			DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_UNKNOWN,
 		.hi_to_dl = {
 			[NFP_NSP_APP_FW_LOAD_DISK] =
 				DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_DISK,
-- 
2.11.0


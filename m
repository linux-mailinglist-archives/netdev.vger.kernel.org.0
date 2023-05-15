Return-Path: <netdev+bounces-2756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF67703D9E
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 21:22:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4195E1C20BB8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 19:22:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53B0A18C3C;
	Mon, 15 May 2023 19:22:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7290EFBF9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04484C433EF;
	Mon, 15 May 2023 19:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684178520;
	bh=dzKqueiaHaieX4+u+VL0PHmUBtkteWDdFF1DX61gWSE=;
	h=Date:From:To:Cc:Subject:From;
	b=V5k6DIgiH/dlVpUdsMUEr8rKPeg7MPaQ60Bo5vOUKYZ+ZhNZVVZxwVgNFWRs/PyE+
	 815d/HlzGv/AsqhaZIJa+eAxpzJVczrik3YjSBNBB1Qbb9NVPwNSVncciDaxzO2TwU
	 surfV1shNXy8mxM5ph3+IOaSCmxSitMoeuac9dfkikbLllgRvUbk+6tUX5zqPdORcu
	 LlMQNu1uLuSmGgZLyVUi+SdoGBdLR8lqhmXduFSaF1gILEzT+xXDhO+TECAsoAfbns
	 WtiGrJ5k//Onnyle/pkcsKyXmLb92tcE3hALUi5gGuEDdx+/LsDKvQcb1QidcxDP62
	 jKNQHRzlQ67KA==
Date: Mon, 15 May 2023 13:22:48 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: mlxsw@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] mlxfw: Replace zero-length array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <ZGKGiBxP0zHo6XSK@work>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Zero-length arrays are deprecated and we are moving towards adopting
C99 flexible-array members, instead. So, replace zero-length arrays
declarations alone in structs with the new DECLARE_FLEX_ARRAY()
helper macro.

This helper allows for flexible-array members alone in structs.

Link: https://github.com/KSPP/linux/issues/193
Link: https://github.com/KSPP/linux/issues/285
Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_format.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_format.h b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_format.h
index b001e5258091..47f6cc0401c3 100644
--- a/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_format.h
+++ b/drivers/net/ethernet/mellanox/mlxfw/mlxfw_mfa2_format.h
@@ -44,7 +44,7 @@ MLXFW_MFA2_TLV(multi, struct mlxfw_mfa2_tlv_multi,
 	       MLXFW_MFA2_TLV_MULTI_PART);
 
 struct mlxfw_mfa2_tlv_psid {
-	u8 psid[0];
+	DECLARE_FLEX_ARRAY(u8, psid);
 } __packed;
 
 MLXFW_MFA2_TLV_VARSIZE(psid, struct mlxfw_mfa2_tlv_psid,
-- 
2.34.1



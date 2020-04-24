Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E971B6BA6
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgDXC5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:57:25 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55919 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgDXC5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 22:57:24 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id CD09BD10;
        Thu, 23 Apr 2020 22:57:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Apr 2020 22:57:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rylan.coffee; h=
        date:from:to:subject:message-id:mime-version:content-type; s=
        fm3; bh=brsFHTOcuqgo//M85imCKMi4ly+rvtpPJ/C1YNSJwjE=; b=Q1SRUDH4
        6CIIezndmyoo3LIlmYEWFiRCUSbukb5EaUg9mJjtdHgIBRrUhgCVD9k1YbyxSgRD
        ZmYSSZzknqOjoIyJrdXIAEpxoGiz4Ae2U3YKRfsYcJHumQoKV3FdFf44EZpjHhN4
        /76rlKgStMGYTqKPC4Ztxxb4LBc+JULaWOzwjMoeKFQM8rsVjGym4T2fTxauWjKQ
        XxCztUp4shWS8e8IX+T4Xqcc64iK9WZ9bJMVP6smOmhjScHBCH7Pr5oy/X4y3sCu
        kyBEFZ6N2wuUAwJAyq+2ZpD/8DKjnCXC+/ptWbsRnSbQ0kyQCTmdMb5tq2X1fJ1+
        NxYqygFBM7KvCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=brsFHTOcuqgo//M85imCKMi4ly+rv
        tpPJ/C1YNSJwjE=; b=vF2er2Z+7N4uORZRrONoFrcP2Gxvi6OOu44nrF0U6MfO5
        8ldsuGE6vfdzU7E9yi5RCxtE/NA4Ic1x8nxudXRESUDxIIwPYol+qIQBaMDV2wDY
        GACd4U2+h3htPwdxXw/ide9hnhiAkLQPHgxfkxMQKiS0NmJgQnI1mrcPsImx9qvH
        AxIQhRvn9GYNZRRWhTrWmrnZNKME0C98nk5ymbDMf8eXTrqAOtQEYlyES0uEt7T9
        /EzKD/rGqOgrg3+o0LmpDyTaFRKDEK/ExE/dIqIKI8Zn1XSsL7Yc5h8PV63he5PD
        Z7+t86Nk0fA3xboPQdAeh5rJMD8/IRJCF7Lve9J0Q==
X-ME-Sender: <xms:k1WiXoHnP0mPLWCYQ6FPgG8m0k-dwYFiXKIQghIFBrHnIcas0WN-gA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrhedtgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtjeenucfhrhhomheptfihlhgrnhcuffhm
    vghllhhouceomhgrihhlsehrhihlrghnrdgtohhffhgvvgeqnecukfhppedutdekrdegle
    drudehkedrkeegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepmhgrihhlsehrhihlrghnrdgtohhffhgvvg
X-ME-Proxy: <xmx:k1WiXoHI4mVwhLkDXdH7S62Mvksv3GvZCvPlbuZsHGhIl0Tsa-BH1Q>
    <xmx:k1WiXj4lUwmH4z_G1pVpa_GvrmzIZFpNvumtlLEPBo61VsbtG3JsEA>
    <xmx:k1WiXlxkIkxtq8AlM8Fo3v1NzCkj7zTItlBARmwe8z--7u00Ng_VPQ>
    <xmx:k1WiXgDr5w9y_tR3OEg34Ww7f4hfDIv7ZKBa5xrfxNABOjyIrWT4qw>
Received: from athena (pool-108-49-158-84.bstnma.fios.verizon.net [108.49.158.84])
        by mail.messagingengine.com (Postfix) with ESMTPA id CF76A3280060;
        Thu, 23 Apr 2020 22:57:22 -0400 (EDT)
Date:   Thu, 23 Apr 2020 22:57:23 -0400
From:   Rylan Dmello <mail@rylan.coffee>
To:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_dbg.c: Remove trailing semicolon from
 macro
Message-ID: <20200424025723.GA28156@athena>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix checkpatch.pl warning: macros should not use a trailing semicolon

Signed-off-by: Rylan Dmello <mail@rylan.coffee>
---
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 1795533cbd3a..216b13d8c131 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1564,7 +1564,7 @@ void ql_dump_stat(struct ql_adapter *qdev)
 	pr_err("qdev->%-24s = %llx\n", #field, (unsigned long long)qdev->field)
 #define DUMP_QDEV_ARRAY(qdev, type, array, index, field) \
 	pr_err("%s[%d].%s = " type "\n",		 \
-	       #array, index, #field, (qdev)->array[index].field);
+	       #array, index, #field, (qdev)->array[index].field)
 void ql_dump_qdev(struct ql_adapter *qdev)
 {
 	int i;
-- 
2.26.2


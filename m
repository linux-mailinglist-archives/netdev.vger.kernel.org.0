Return-Path: <netdev+bounces-5722-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9159A7128AF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 447281C210E4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:39:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07881F172;
	Fri, 26 May 2023 14:39:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BEC742EE
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:39:44 +0000 (UTC)
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57F210EB;
	Fri, 26 May 2023 07:39:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by comms.puri.sm (Postfix) with ESMTP id 42F0CF14B1;
	Fri, 26 May 2023 07:38:49 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
	by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bBdOD9a9ftPt; Fri, 26 May 2023 07:38:48 -0700 (PDT)
From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=comms;
	t=1685111928; bh=dfF6XaE50ihs23TtTkgdj4tNvRZZ2hvvhNDTozYcucI=;
	h=From:Date:Subject:To:Cc:From;
	b=gseJCe7Eb3YHf7jqVIbSsYZjhanawrOeGdDn+kK067om4+ZohvVWAJZZYRWUMXrjz
	 8QSDjqE+DXUzGf/K0+bBP1OHQPGivFL2/Ye90cMeBuikDPJlnT1GZOe3ZZKIL1jD+E
	 l6xs2kZ+mg5PoPvDr2tqij0Re3xdU1PpjDktlrf3ABpWygu+YcytYdcR8qQwFUb+z8
	 3FhIBDU419omuX1I41s5g+9FkEB/tP8+Epf28fY8sKeU2k/WlHFI7jGJ5bKNuwa3gF
	 XZF1wAf9lCZf2n0Pjz7gh2yn3FM+sMYFg7FxHsnIq66YMzhcQU1tjL03R7PdNzulP/
	 FAj1Ede2VgDBw==
Date: Fri, 26 May 2023 16:38:11 +0200
Subject: [PATCH] net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm>
X-B4-Tracking: v=1; b=H4sIAFLEcGQC/x2NywqDMBBFf0Vm3YEkPgj+inSRxGkd0CiTthQk/
 +7g8lzO5ZxQSJgKjM0JQj8uvGcF+2ggLSG/CXlWBmdca3o3YNy89Th/BC11NjjfkzEJ1I+hEEY
 JOS36yN911fEQevH/DkzPWi/W/LmncAAAAA==
To: =?utf-8?q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 "Angus Ainslie (Purism)" <angus@akkea.ca>, Bob Ham <bob.ham@puri.sm>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel@puri.sm, stable@vger.kernel.org, 
 Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1285;
 i=sebastian.krzyszkowiak@puri.sm; h=from:subject:message-id;
 bh=dfF6XaE50ihs23TtTkgdj4tNvRZZ2hvvhNDTozYcucI=;
 b=owEBbQKS/ZANAwAIAejyNc8728P/AcsmYgBkcMRvt0yPJ9mk/umNTjjMrTS5aXZ8PH+bsuxiZ
 d6PFy2DiLOJAjMEAAEIAB0WIQQi3Z+uAGoRQ1g2YXzo8jXPO9vD/wUCZHDEbwAKCRDo8jXPO9vD
 /7cHD/0QMo7yE+WKQsaWAm17cMslWLpDUFYE48RwGHMKWCcJlb6Jl5xFFLcrdJS3RtzwFbexVWy
 6VGXuwecgDtlkiglY7v4TOP8dHdlwyG9nmHSTHlBVHLAAZfK9MEC1Pjex2M9078N8rRENBgiVH4
 1c5/Khi3kjoYsaDH4rNvhys+dR40XSZ8fbN+n8v9S1NzPKfYNNg5bTt7/b0rwEDCy4ZKB4DQ1gY
 5MASTnd1YxbPysx2RmopoIKW2GolJzoYTeUomEKYX3A99DQOXIoncNGzwLWWlUIwFo9zWKFOiMY
 PTenAbc/L0+iquI/FNI2DETkhvr+dG8+gT+ZI5NkePUIi3z6Amyumw8yf7QVCGGpUahxbnIfSIc
 WcmXHur0fVFt2mFBgHTWuAwFDJTeSxEMwwTdry588kcYaEnvMpLMOuTuzbY3PK/wtOx0PU4fn8u
 aclcyPQaa5aevucYdJhD8hdmIKWggWTKZZLqP+FmWd8GUJwzaBofR+HRObzafyU3TYKfk9PSfOh
 1uBxGsZEf3YCd98fnDMgmN9YcUyUG/U6ImvEaqTWsXxnWgKASi8KW2+5wAyhfG+YOeDU/fh4Zqp
 Bd0fCyIg9Qnm7yvbUAj3VhxOdAPaR+UsRD8PBEGsVLvBTBaBWMTpD6ATdptOp41E/aqIq8/N6eK
 z9d8sPtTn94Z/CA==
X-Developer-Key: i=sebastian.krzyszkowiak@puri.sm; a=openpgp;
 fpr=22DD9FAE006A11435836617CE8F235CF3BDBC3FF
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

BM818 is based on Qualcomm MDM9607 chipset.

Fixes: 9a07406b00cd ("net: usb: qmi_wwan: Add the BroadMobi BM818 card")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
---
 drivers/net/usb/qmi_wwan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 571e37e67f9c..f1865d047971 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1325,7 +1325,7 @@ static const struct usb_device_id products[] = {
 	{QMI_FIXED_INTF(0x2001, 0x7e3d, 4)},	/* D-Link DWM-222 A2 */
 	{QMI_FIXED_INTF(0x2020, 0x2031, 4)},	/* Olicard 600 */
 	{QMI_FIXED_INTF(0x2020, 0x2033, 4)},	/* BroadMobi BM806U */
-	{QMI_FIXED_INTF(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
+	{QMI_QUIRK_SET_DTR(0x2020, 0x2060, 4)},	/* BroadMobi BM818 */
 	{QMI_FIXED_INTF(0x0f3d, 0x68a2, 8)},    /* Sierra Wireless MC7700 */
 	{QMI_FIXED_INTF(0x114f, 0x68a2, 8)},    /* Sierra Wireless MC7750 */
 	{QMI_FIXED_INTF(0x1199, 0x68a2, 8)},	/* Sierra Wireless MC7710 in QMI mode */

---
base-commit: 9b9e46aa07273ceb96866b2e812b46f1ee0b8d2f
change-id: 20230526-bm818-dtr-1e41a285e00c

Best regards,
-- 
Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>



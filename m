Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885D658F9FD
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 11:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiHKJWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 05:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbiHKJWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 05:22:17 -0400
Received: from fallback16.mail.ru (fallback16.mail.ru [94.100.177.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C4F66A76;
        Thu, 11 Aug 2022 02:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=tGHIH9BqE3csTbHgRChMMslimk5FBI5DrJ9Eud1Kyes=;
        t=1660209735;x=1660299735; 
        b=T/Z7wyup10OmdzalBNnXkVdc7vmB5iXY1vxwBKPGQqvrU7RSET1UO1kisAkaXnL+N21rlga0jvYJQyOaULnlzn4yLy5y7MF5EdCLL2FgJqoUM24mGKI9rC4FGaBEhOHMtEID4hU/TcI5er3+GDepJhg6xcfR331ntTk7aPT1NPPvWb5xLGBTOrQMhIHkLChDzWtCmkpsyvv7v1HQ/LHkoKFgCSRFvMmpYzCnfioE0y7E/xEW5V0/Q+OFxo5PNn2/uTTnBS+qoPmCvPW62qbgvNqKoMFq1H6Q1GYtSV/Eoi3SOY27NcXdfD7NwoUre1T+G/BBt8ZjI70V2LjlkjBA4A==;
Received: from [10.161.55.49] (port=44190 helo=smtpng1.i.mail.ru)
        by fallback16.i with esmtp (envelope-from <fido_max@inbox.ru>)
        id 1oM4OL-0004MI-65; Thu, 11 Aug 2022 12:22:13 +0300
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail4;
        h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:Cc:To:From:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=tGHIH9BqE3csTbHgRChMMslimk5FBI5DrJ9Eud1Kyes=;
        t=1660209733;x=1660299733; 
        b=uW9Q1/hqposMI3M1yFCpQ5fGenjyWWXsmqIXOyr397+lK0Q3qe8A5OJ4n07XapZbh+NcNYEk8W9CCIP6QRSoGQ1eMkNbEThDTtighHUBpduE5DbxO6Wj923oevzApEL8V/LYwwYJaGCBUF0iJrdmwQwhAJ4TFTeTegTJdktbv8RQ5lU23/ujdN90AsZQ1kc84HMUbQY1um7qjGyzVqjAj5RbfglS2HD5fWvzKTU3O4MigVmfdrzR18VcTX2gXK5G9W+Tjc7me1bxTZc4/7dbUrJyKiIwd6hL2UTcsbVXkWSXS9qshStgnYm/S6cx+eBMGriBq3ZsfdLuaqZphWNcOA==;
Received: by smtpng1.m.smailru.net with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1oM4O6-0005oG-NL; Thu, 11 Aug 2022 12:21:59 +0300
From:   Maxim Kochetkov <fido_max@inbox.ru>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Hemant Kumar <quic_hemantk@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 1/1] net: qrtr: start MHI channel after endpoit creation
Date:   Thu, 11 Aug 2022 12:21:45 +0300
Message-Id: <20220811092145.1648008-1-fido_max@inbox.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mailru-Src: smtp
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD999D8F08CF16C6CA79689DFCD3191088E20666E5EE319E7FF00894C459B0CD1B9BB194EAFB573CD99C68F45343C7B52C63A7229FCB28CCC1058574C2FEBD6103D
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE78E8764B5BC580342EA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F79006377E85B0EC44E8FD73EA1F7E6F0F101C6723150C8DA25C47586E58E00D9D99D84E1BDDB23E98D2D38B8859CA687ABA27BA50FE8A83A20E16FD255E2C6A1D39943720879F7C8C5043D14489FFFB0AA5F4BF176DF2183F8FC7C0D9442B0B5983000E8941B15DA834481FA18204E546F3947CEB7D890E3377C531F6B57BC7E64490618DEB871D839B7333395957E7521B51C2DFABB839C843B9C08941B15DA834481F8AA50765F790063767B9C6E70FBE8DD8389733CBF5DBD5E9B5C8C57E37DE458B9E9CE733340B9D5F3BBE47FD9DD3FB595F5C1EE8F4F765FC72CEEB2601E22B093A03B725D353964B0B7D0EA88DDEDAC722CA9DD8327EE4930A3850AC1BE2E73557739F23D657EF2BB5C8C57E37DE458BEDA766A37F9254B7
X-C1DE0DAB: C20DE7B7AB408E4181F030C43753B8183A4AFAF3EA6BDC4421840F38DCE934C09C2B6934AE262D3EE7EAB7254005DCEDB42964B25BD985600003EFFB447AF238D59269BC5F550898728CF7B057D10C7078444BBB7636F62A47B764294357833B1AEF9F1D68E0CC2A0639DA717AEEEEEB0D89974173551D4FA9D420A4CFB5DD3E135BE9F26F305BAF9A737730E50632E14EECFE9CDCF99457D59269BC5F550898DBE8DEE28BC9005CAA1EED9ED2403833638A446BE3E5C627BF0CFE790FC11A7261332C5CB50AE517886A5961035A09600383DAD389E261318FB05168BE4CE3AF
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D34FDC9529E4578B99C00D01223E62638C66506C237F1EDC715D343234DDBB22C175A984F9424434C771D7E09C32AA3244CE2229C67B2AA2500343E0829042BCD4924AF4FAF06DA24FD27AC49D2B05FCCD8
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojfXJM3siCnClSN+JFL8baiQ==
X-Mailru-Sender: 689FA8AB762F7393CC2E0F076E87284E1310CF0C612FF4B7439EB8E4D84B453698CC072019C18A892CA7F8C7C9492E1F2F5E575105D0B01ADBE2EF17B331888EEAB4BC95F72C04283CDA0F3B3F5B9367
X-Mras: Ok
X-7564579A: B8F34718100C35BD
X-77F55803: 6242723A09DB00B4D658BAC37535336315E51F804904E618693D0691B45BE143049FFFDB7839CE9E77C206023D2982CC76A3375E36BAF72EE4748ACB9152490E1E1B2D9D5ED01862
X-7FA49CB5: 0D63561A33F958A51D1F4A01D53429B1708E9835FC0BADFB7A63F040C3BB339DCACD7DF95DA8FC8BD5E8D9A59859A8B6A096F61ED9298604
X-C1DE0DAB: C20DE7B7AB408E4181F030C43753B8183A4AFAF3EA6BDC4421840F38DCE934C09C2B6934AE262D3EE7EAB7254005DCEDF6D7B710435BCC9269C5EB00AB6EC95F38CAC7F44FE29C967BCC32E49D76C4CC1BC22E60DA9664CBA9D420A4CFB5DD3E1D1F4A01D53429B1708E9835FC0BADFB260ECC9E756EE21DD59269BC5F550898DBE8DEE28BC9005CBF77E1FFDBD4BA85410CA545F18667F91A7EA1CDA0B5A7A0
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5xhPKz0ZEsZ5k6NOOPWz5QAiZSCXKGQRq3/7KxbCLSB2ESzQkaOXqCBFZPLWFrEGlV1shfWe2EVcxl5toh0c/aCGOghz/frdRhzMe95NxDFdEnfY/XW8vr2MqDoWFmfMqw==
X-Mailru-MI: C000000000000800
X-Mras: Ok
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MHI channel may generates event/interrupt right after enabling.
It may leads to 2 race conditions issues.

1)
Such event may be dropped by qcom_mhi_qrtr_dl_callback() at check:

	if (!qdev || mhi_res->transaction_status)
		return;

Because dev_set_drvdata(&mhi_dev->dev, qdev) may be not performed at
this moment. In this situation qrtr-ns will be unable to enumerate
services in device.
---------------------------------------------------------------

2)
Such event may come at the moment after dev_set_drvdata() and
before qrtr_endpoint_register(). In this case kernel will panic with
accessing wrong pointer at qcom_mhi_qrtr_dl_callback():

	rc = qrtr_endpoint_post(&qdev->ep, mhi_res->buf_addr,
				mhi_res->bytes_xferd);

Because endpoint is not created yet.
--------------------------------------------------------------
So move mhi_prepare_for_transfer_autoqueue after endpoint creation
to fix it.

Fixes: a2e2cc0dbb11 ("net: qrtr: Start MHI channels during init")
Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Hemant Kumar <quic_hemantk@quicinc.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
---
 net/qrtr/mhi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 18196e1c8c2f..17520d9e7a51 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -78,11 +78,6 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	struct qrtr_mhi_dev *qdev;
 	int rc;
 
-	/* start channels */
-	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
-	if (rc)
-		return rc;
-
 	qdev = devm_kzalloc(&mhi_dev->dev, sizeof(*qdev), GFP_KERNEL);
 	if (!qdev)
 		return -ENOMEM;
@@ -96,6 +91,11 @@ static int qcom_mhi_qrtr_probe(struct mhi_device *mhi_dev,
 	if (rc)
 		return rc;
 
+	/* start channels */
+	rc = mhi_prepare_for_transfer_autoqueue(mhi_dev);
+	if (rc)
+		return rc;
+
 	dev_dbg(qdev->dev, "Qualcomm MHI QRTR driver probed\n");
 
 	return 0;
-- 
2.34.1


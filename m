Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAEB5CCEE
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 11:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfGBJul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 05:50:41 -0400
Received: from mout.web.de ([212.227.17.12]:55975 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfGBJuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 05:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562061022;
        bh=iCyjFEsFbP9E2gjuUs9RhQNMZ4EWNf6g9m5XYPk0YGU=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=Se8KBEA4v5YnQn/pjuWWaNKziyu3i5cCnScREsyTf0bD4EUit06VboiJ9SBRiN7s3
         F9av6xvkDCQh6QVaDnXFVvFJ62mJWdXDldBge0y+3yLNdTIWRN2YhnC84MBBAKOzmM
         5q22bG4vLE2jc8pdociy+n/FC56IlNXQHNw4nwp4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.11.114]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LvSU3-1ihC3B1Mhf-010YwQ; Tue, 02
 Jul 2019 11:50:22 +0200
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Wright Feng <wright.feng@cypress.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] brcmfmac: Replace two seq_printf() calls in
 brcmf_feat_fwcap_debugfs_read()
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <7d96085a-76e8-c290-698a-e1473d3f4be7@web.de>
Date:   Tue, 2 Jul 2019 11:50:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PF5gJ1KYGE6sBYJu6b5K5HpJrPz/0D0L/G08/MsEjt5f3vN/Quq
 aRlJwgS1CIbVvoA2wAJQe27ocvjpHfm2XIYqG7TqAkVPIdgYX3wAeLjd+BeCpeQM9wejKyD
 tseU5rMVAffIbQdPxmJFHdlb7NX8Dh34BnG3TaWvhQFkrrkrkT1YXpyA0FCiOdTTCVhbnNM
 +3sVerSIlrLWrm79Fc/AA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l/G/KTK7KrY=:znOHhRCVTJSCSX1Wk1Ilp+
 jey+SCa9lIZ3T3+ATGN+0TkSSgWCgAxfXjZv2St2mNT4ioV+tEn/3zkfbwZJ+7levcLDlpuFB
 65d9iBrKzHxMI3Zrrw37e91VMqX9TMGgG1OBtmP3q30CXnuduMb1Www8f4/senq/zli0EOBii
 ukJkvUADsNpaWgDj8cGosVspAUXAP7AoNeVKJ4/jbpLCLxjyf1qq+dSx0VvXtDRBwR5lNryB0
 N63oI7LifUozTj4INcros69b1MrSCqUaW4lioaAvEwk3pzs/fqsHcue74Pd1cNuNsyRfLH/1c
 Pn7ZQPmg12ZsBdL8EcSUAVxj8lWQCZE1Ib/FcLRxRoFlzldvJIk7Fl0BkbM4vgG3LgGQ9HAhc
 OJbI93lj0ig+ldBiUhfnBG/gQYbdatIcmsfgfWobZ1yApX449G5KS31zMPo1oPdMVGI6wyJL2
 0LGIH1T9OhMhl2EWgiep8Pk1InVke596hFTboBdGI5q5sGc5D8pFcaOl39sCcfcdoWS+v0DNW
 22sN6sqmjHzVU2A8dDo7T+4Athgke21NZ5RoVDB5hhsbiXYa5oeBTGMY3FSR9X07DiHvBAjtF
 QMs7iI5p41bqUsa7SSDzSToCAPBNXj8s2GNjv5vvWB3eFpFLSH/BamJ1EiMcQh+SYxOrrJTH/
 xaG+0La8R6qyCcdQFIW4fYktmh7ydmYIMcZot/lIhspHbaX4b/ZW0X0Ia3JLlR6fs6DWFWQVd
 9h5H50KREaocdqYc7cdru2EmnP0be35ud3i1xtrfMKkXaL9Azm+QszSQRC8iBCpMhcZ8A2s9N
 iCO7EEMQrY+CtOKd87J7H7La60sRqStb/Utdc7yQI6rrsEatZjOVabtQT8PtZBDeSrik4wMOZ
 hO0rTlQ4wWQgFWq72uRBuej4y5u/AatchvmrTvb6LCa4aCSgUSk/ro2Ww6bMIAuaRWc9RbgTJ
 14gdJkmASMWSIab62J+HMGOOfbvIUmEEIhDFBD13bahxhfou7tV5/tEw6DWdN6HcY3kOm03Cw
 eKv2vl6vNguTrj3wEdxvBcjbq5XBLuhg+IRacXHGvMoLUTN2hpfpBWtZgrkwMavek6QLSIPKX
 aHKFha+hpP2J65zxZgrn0mDSq1F4l3cF1Uw
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Jul 2019 11:31:07 +0200

A line break and a single string should be put into a sequence.
Thus use the corresponding output functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/=
drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 73aff4e4039d..ec0e80296e43 100644
=2D-- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -225,10 +225,10 @@ static int brcmf_feat_fwcap_debugfs_read(struct seq_=
file *seq, void *data)
 	}

 	/* Usually there is a space at the end of capabilities string */
-	seq_printf(seq, "%s", caps);
+	seq_puts(seq, caps);
 	/* So make sure we don't print two line breaks */
 	if (tmp > caps && *(tmp - 1) !=3D '\n')
-		seq_printf(seq, "\n");
+		seq_putc(seq, '\n');

 	return 0;
 }
=2D-
2.22.0


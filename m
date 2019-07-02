Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0171A5D5ED
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGBSMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:12:08 -0400
Received: from mout.web.de ([212.227.17.12]:48275 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfGBSMI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 14:12:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1562091115;
        bh=/a9zSwi0Y/pi9ROY+DTVB0GUvSlQ80eCZXaqiI2JNVc=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=gSwVsfYeBqH9RY6ez6Iq2RACegCF642TuLg7qzF/PHtZb9FNKZbW6sjhWJHaTSRJ8
         N0gqDRYvzfIu6FO5HylZqXlCdzqzyxA5RApqyuh8//iIo1eASS1Hq7GHpHmjhdF2Gu
         htw34lEyuSOPesFs/OIRsrPaQslw56mQhe6t44FU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.11.114]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MFcE5-1hnc342ghp-00Ecra; Tue, 02
 Jul 2019 20:11:55 +0200
To:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] netfilter: nf_log: Replace a seq_printf() call by seq_puts()
 in seq_show()
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <c7d397c8-4f41-1831-505f-b3fbcc3663fb@web.de>
Date:   Tue, 2 Jul 2019 20:11:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:cpD8/pZMkphFpZd+n8qkZ7B8EWpJuKAlsEvsw4IrfzMw31wilNC
 MAiYqlBo8+Z9gMpj5AycLqtoxFExuXZ552k8Oo+3vtKmGNNG0+wSdGjDcH07JEXeRjRei22
 SNosxeTi6tRyQ9KgnfS1chVVHHhDB94BxgisXYCEy6ghMWNArCVFP9gDbxryj0/2hhoSi/2
 M08i9+99ZX0on8/4PEeSA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:j1UiI//MHNI=:1q24Fozeym9A7czh4lSZS5
 aH+BxtCw63leli5wijwHfUdz+2jxbNknNC9AW2xg4dNAJk8NGHDrD9H2Az1XpHcEbIiJm2DMP
 D8ytuikh6S00ycKh4DJ/cSdmwEw1fxL7Tc3cFu5uB3sAbysl9vAkcrzOjjX0ClGRIxHXbUYuw
 hYyXsts50pCpGkRNL0nYLQ6Q7/L0qTFRywRRFvmpVCTLzVBHAvQKJ2+7IX9gjf2yCFHeAd+BJ
 hr1ErjsMSRcGijCS93eVBniWJT54WTBiLP4GDu7zQxAc+vmofApw6dZNvbs0rcLaQgKrqlCCx
 7BOrOqC8aPicdVQIY/2V4rzZDTYg+c5PW/Bqa/wPjNQFWn8UOAq4Lu0vqgDjLXYixXjFKaLx5
 U+ORT9L6ooEpM8DiQuPwahHx+bFUd0Oxb9YO961YfKKPS3avDqEoPW4c2XqpBjLl57/Nt0OqU
 1z3TYeU1dZxpS4WbwlrFadIRPIhkZ43Chzaos1WMIxfbq3kE3tx9TvlfTUhJ5gcqaKwT6xHIn
 EXBpTSKehdVTg7uCJG4YdWRO0aFCquH1Z0mra3XQI7KEpeveNMIYmtA5lZr7JuGtkDLdS21aL
 sgk8N6VkmdsFz0LT30hA58hBjxNoMqp9+Wqef9st7U1AybxxWgdoLk1F8wd0ZcDxnddT/EDR1
 DmTGBHWPvgfuZaNYksD0nYm+AKVU4TuFncL9K1yRf+BedLiO7+e6qM+VKCkH/mvJax5H+DMnv
 HeCpAY+JJOdOfEcThaq+4M6u4qkpgNf0MUJnH+D0Z+OqXhThILeBjwUAvN/s1PwQvVQ/v6tpW
 W3jEIVUtBVYUmSn0UMEkjdiqzZXv1ecsEHYb6M0caNMrrV7uCpLXnjIDMbZW0QgIBnOra+QIO
 AFE4Q2KAJmB8pm3Ll9rldJqQUZx30/YZX4EfL7PrzSapt+xyW1OYFnSEr5myPzaCfeGuCQ4FR
 l7SlX1NldDVIFyegajhWAOG5KdjwALpfHsJp8jAxjXpBJLVzWNEFX8sTATQf24royR36Irf2B
 Lh23rx7HqZLyn1Xa/HHBBIPhou4Ohlevu6KYcwE0RRD6kWhEzGl+sOvTa1V8HufmR98Kh6bIE
 PVAzNAqhpHVsLslaTmsd20kLPNbgRhy75iY
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Jul 2019 20:06:30 +0200

A string which did not contain a data format specification should be put
into a sequence. Thus use the corresponding function =E2=80=9Cseq_puts=E2=
=80=9D.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 net/netfilter/nf_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 3574a212bdc2..bb25d4c794c7 100644
=2D-- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -374,7 +374,7 @@ static int seq_show(struct seq_file *s, void *v)
 			continue;

 		logger =3D nft_log_dereference(loggers[*pos][i]);
-		seq_printf(s, "%s", logger->name);
+		seq_puts(s, logger->name);
 		if (i =3D=3D 0 && loggers[*pos][i + 1] !=3D NULL)
 			seq_puts(s, ",");

=2D-
2.22.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978011C2F35
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbgECUZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 16:25:50 -0400
Received: from mout.web.de ([212.227.15.4]:55217 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729081AbgECUZt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 16:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588537532;
        bh=+rOf7wzYZ24guVO6dSkAZcWagsazdX9BRZj0qYMnu/A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=rm0F4KBpi8K3bl4IlgRJesD5tZl5bkTj1Ibiznr3sElb+BC1w0V+0tXfwIhop4Gnv
         6zv+O2UYEhIOFwk8Ar9qpZEFFzadUbCZPUPe8sy2aaviXcusT48YVCh0WoPTaNDgIB
         7ipuzuga/lGgcVoAI+ZmjrKP1XSW2GCNS3hU8N98=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.26.31]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lpw63-1iymNP2QDP-00fkNc; Sun, 03
 May 2020 22:25:32 +0200
Subject: Re: [PATCH v2] nfp: abm: Fix incomplete release of system resources
 in nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, oss-drivers@netronome.com,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>
References: <20200503184220.6209-1-wu000273@umn.edu>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <88eecbe4-89b3-2b4d-87c7-5487cf23cadb@web.de>
Date:   Sun, 3 May 2020 22:25:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503184220.6209-1-wu000273@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:4dVsQFfab4hiFErMRMDbyJdWtmu7mUM2oanMiPdoGYUsnKv5YBX
 uTuY1a0+Fit7UtWlmqKH5WEmzialh9rDe2N4Yygj9cW6Qd1Ld4cZ47enG1hgIts+PLCpfhZ
 FxT607cNqH4F3LbIZqOD/0hdkS35cC7g3EUM9EkfQGye/ILxUhZ3uK0LkxRE9RUGjQGxsQJ
 cG8ra3zJfcphUTzbiQFZg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pzL/aeVbPr8=:d/zdX1waBCRDdGrs1Df5gM
 5x6uSEavCvPFpzc9W3nl2c0+vxhN+j4hebJl6VaRsnk1bZU1vqkz+6+09iRWAUpIh6QgE69y5
 Mhwyk5g9/DA0o+I6I0OpBxgdtyehNGbOJsb/gXiRVLBUrlJXhu+xlXbJgtG/7eV1VFBqwKe+2
 rJh27BZvH2CIadooHmOuiaPklPYxsHw0Yr9VcaBYvTy0bnVEzS7cfII5X1n8FTu8ZIW3KW5C2
 CbkCOEYSw5UY2FIPKu5/5lbB+3DwO8Meem41f+Nx55B4arl3BGelVTw3yAOGNOHKzbl2YhtJX
 sc92GoInfubO7Brxp4BZrsyunek6HybXN8gma2FTepeFAYrPunU2RTWbOHQ+jntdcDkQAkW0L
 6DeL6qHNE6eSFP6IVT8jfHXW/aFpsFGogD2YybXq/hKTUmh41zA/nZhD9lxvgonw7xMNxW8cJ
 uOMkiKYWzdPJ29yR+Cz+zJau7GnqgKz94HIyHGOoZbVBy7Wwl2Pnsfo3E1mj56xuNLr5xOLMs
 LL7JLfUwmUYLDmA9e8vhVQ1TJuMwRIdLixhKuSp6I5iDLZqIWkyKcB9b/oCZ6OW3aLuRooTES
 APzABsK7ejk5mu4qXlPIgR+nrl7hl2XgTWAOnLDtIFDWQmuVEbBlxYskENAivoMeWyRIhHcuF
 IKtSRiaYxANHbSN7lKzwsPOhNsZODF37LerxKad/voEDHVhykWG3NxqIL7KaGTsHCh7F9bF7o
 /fAr72RVdEGDKSTghearWh7ewGT/3vrLIXJrKgNEbSBGW0+9UzzRMuR2awr4C7DrwhJ1UBRGo
 CKjQ2IIdFMWAYJ86PXHoD9mePk4lxdJ0qIZQTis5SWwCEZsI4YryYp3CuEg2D0zyZ/BOJpSky
 sSLIcCFNz69tTywO6MCKtCHjRTXVWilO6XeJhg7Uq0HTVOV1KD2FC3QQBUq2SjBWVPaURkmug
 M4PT9+1L5FCflpl8/Tuy98xES0VtTqTaV3gDwKDFVFcrWC9449wVRWnOJ0j7jfpHIfvGRAwLu
 kCeRPQegxyyIwzkyBFDsz05EekHtkb5+etqmhxUhb3g0SRnci/OgfxAeF3XRROIV3G+rZys4w
 xSweNMdBAN7GnR+7zsfsq+ZI0gjVCJVnm/M2vF6EL9qqeGqku+c4K53iOTmgCo+eNYZRAizp0
 VCslweA1Mr+HwmqRG9yOEIVDpeAI04EvgkuP8/7X8ZhvWyVmo1E3rnm4AnwEZ/2nFj0AMNA3m
 KxmVkbLf+f3SNjWFQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 Thus add a call of the function
> =E2=80=9Cnfp_nsp_close=E2=80=9D for the completion of the exception hand=
ling.

Thanks for your positive response.

I imagined that a small patch series would be more reasonable
than this direct change combination.


=E2=80=A6
> +++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
=E2=80=A6
>  	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
> +
> +generate_random_address:
> +	eth_hw_addr_random(nn->dp.netdev);
> +	return;
>  }
=E2=80=A6

Unfortunately, you interpreted my update suggestion in a questionable way
at this source code place.
I guess that the following code variant can be considered instead.

 	ether_addr_copy(nn->dp.netdev->perm_addr, mac_addr);
+	return;
+
+generate_random_address:
+	eth_hw_addr_random(nn->dp.netdev);
 }


Regards,
Markus

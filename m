Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C18D3CC397
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233873AbhGQNhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 09:37:16 -0400
Received: from mout.gmx.net ([212.227.15.15]:59489 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229746AbhGQNhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 09:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626528836;
        bh=5faHKHYVx9kCTpkagsw8dkAx55M4pUI8xJe1C1N28ag=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=U8qUXFX/+guW1owffKHlzQa1YopPIQls/yHtdXUpxQY9WMz85EcSEF01TBbMhJKic
         paaQEA59LZGL5PT0j97ZnUnoeRJk//WFk4iGL4V3djOcAdUEeQhakjtNi3PPBuWkHp
         zB+yqlKRdAqFGV5m/3QWN2h4OfJLAlFl1Joi1qj4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([83.52.228.41]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1M3UUy-1m4CUD334M-000Yfe; Sat, 17
 Jul 2021 15:33:55 +0200
Date:   Sat, 17 Jul 2021 15:33:43 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Brian Norris <briannorris@chromium.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] rtw88: Fix out-of-bounds write
Message-ID: <20210717133343.GA2009@titan>
References: <20210716155311.5570-1-len.baker@gmx.com>
 <YPG/8F7yYLm3vAlG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPG/8F7yYLm3vAlG@kroah.com>
X-Provags-ID: V03:K1:vljdN4kn+ro0ymxfW/qqodGQnXMgpyERHL28x2eV5d8VQeB8NbN
 qUCxTkm6e8XBhjZgAJ2X07qFMGOkDFwodJWVH7brjbzQsW599/zEDssz/zpaZxTBz5xFFEH
 sXU7Qu8awfQGbehGfgHFyXxl7IPTIV9mIAME8lNldi+PQuWxdrbiZZHjQcIfHuPBIjtMym0
 l0EajMfdYcHBVHR4d1ffQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:EYWrHxHOAEc=:2SZ+C1fTyRzy5fRD5BO4M0
 AVwg9wGDsxNakXzaAOySVUV2MyaLeVHl9h6TOUkXuXr1Yxte0aH6lBaw9gDogOso6rrOcgzVC
 f++reXrs9lE9E/+1vj8fXn/z/fHAnRiXkb292IqiN5w6NU+F5J/F9Hp5k3CI2Q//VYQoMCIam
 zUPtUncZFh/Pd3pwPhVcazNL23XjmUbA2PG/K8byGcIXTy/AeljvR5fVYTWxDMXq1n3UtJXz7
 9gVaICXIFVQ54DU4n0+CuPM9Dy4bMuMTjYIM0YtGxKkSsSpDQvwUBNx2jHx1F7KzsJfQsHUa3
 R1hRdoc+02bAzuDmlQlhipKsXCwH1E7hjG7ko2vrRTUuCgh2OInKjN5vbNYTs6WZpo7q9dgKp
 RnHUUlq2gEk7TTJjTq4ec3vnYgOREWR79h8C34JiUXC513cliIoTubFh4sftO2twoVGkqUJer
 I+8kmMNh79eGkOOfk2jdUr1448f1Xs/4tUtPx39/Pgs4cezyO6ipva4PzI7/U5QAWJWn3Em0I
 476XAVoCJYHX8RbnUWBD9DNA0Qptwa89SmnZpeNshxUWnSfUmyotE24ASyApapJGOdsHtrJe8
 OUHmkuFiuzWzusDzxxAoyHmIv70oblbhTfFGFcQSHmFKcJKq1VAl1RrFcZHyHDqFAWp4JNAg2
 mgTgzOKjvWIxlsHJzV/SR5I7rByGUt6Fk/Wd07+HMVSFdQ5bqY3v3cZIAJiDCrW1NlrLDq7Bi
 ACHUNbe/eQ0FQZuFmDeIs8a4KXUB6mh4jQrfW9REzt3I4w5vDZXXHC00s0IC0NT/rGKgE/9V+
 hgpqumS3x+hua1P74sz5MViSa1TKmY3xO0H2m1qy+yAANobbaxN6BwGtdAoY6uK5ZXoCn54Ze
 RBEK7zIUszVtdACrYflKbK1KRbWZAlqLS01UEr3Jhc5skLSY9BAuetQhKu8AY+8apFcBNfp4f
 UbmMhg6YumYbSuNH4L0toK8G2AKbhWCQT5CmOnKDEysUlBt/TDA6m3b5WbVRg6fCY6SMzCaXw
 0JvBjSp0tXQSs8mLO9jxzVgSWBwMCcW7eY2CoLBMjTWk50z3BaRQQYzG/bdtXq5+yCqKQz+Hd
 VrVM29ClBE9nUQOvwVlBKdRxVhu1VGNglh7
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 07:20:48PM +0200, Greg KH wrote:
> On Fri, Jul 16, 2021 at 05:53:11PM +0200, Len Baker wrote:
> > In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> > statement guarantees that len is less than or equal to GENMASK(11, 0) =
or
> > in other words that len is less than or equal to 4095. However the
> > rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> > way it is possible an out-of-bounds write in the for statement due to
> > the i variable can exceed the rx_ring->buff size.
> >
> > However, this overflow never happens due to the rtw_pci_init_rx_ring i=
s
> > only ever called with a fixed constant of RTK_MAX_RX_DESC_NUM. But it =
is
> > better to be defensive in this case and add a new check to avoid
> > overflows if this function is called in a future with a value greater
> > than 512.
>
> If this can never happen, then no, this is not needed.

Then, if this can never happen, the current check would not be necessary
either.

> Why would you check twice for the same thing?

Ok, it makes no sense to double check the "len" variable twice. So, I
propose to modify the current check as follows:

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirele=
ss/realtek/rtw88/pci.c
index e7d17ab8f113..0fd140523868 100644
=2D-- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -268,8 +268,8 @@ static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev=
,
        int i, allocated;
        int ret =3D 0;

-       if (len > TRX_BD_IDX_MASK) {
-               rtw_err(rtwdev, "len %d exceeds maximum RX entries\n", len=
);
+       if (len > ARRAY_SIZE(rx_ring->buf)) {
+               rtw_err(rtwdev, "len %d exceeds maximum RX ring buffer\n",=
 len);
                return -EINVAL;
        }

This way the overflow can never happen with the current call to
rtw_pci_init_rx_ring function or with a future call with a "len" parameter
greater than 512. What do you think?

If there are no objections I will send a v3 for review.

Another question: If this can never happen should I include the "Fixes" ta=
g,
"Addresses-Coverity-ID" tag and Cc to stable?

Thanks,
Len

>
> thanks,
>
> greg k-h

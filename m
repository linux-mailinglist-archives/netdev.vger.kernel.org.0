Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 104C7F5E1D
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfKIIzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:55:35 -0500
Received: from mout.web.de ([212.227.15.3]:52803 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfKIIzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 03:55:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1573289728;
        bh=shZCC5n7T8ZQhPZiCqPIC7Bgfx1bsymtV0UG9FawVzA=;
        h=X-UI-Sender-Class:To:From:Subject:Cc:Date;
        b=Scqg19vLuCZb6I8bP+7buG6xk2gKpgEWKmVZBFmZ5u6hssfghFLytTCYadW/XBwRi
         F4V/Qg2D8SE1dN30GpzIJ5oXsL9FCGYGAqpW1HcLj3RdekKDtIhMeb8WyHWSZfeCNj
         g0P9e/D8hQKSXHn9hlPIK+MArJDbPfWyXBFo7hjE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.82.67]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LtXDY-1hkIJP3C7Q-010vxg; Sat, 09
 Nov 2019 09:55:28 +0100
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Igal Liberman <igal.liberman@freescale.com>,
        Madalin Bucur <madalin.bucur@nxp.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH 0/3] FMan MAC: Improve exception handling in mac_probe()
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <132e8369-c4da-249f-76b8-834e394dc6d5@web.de>
Date:   Sat, 9 Nov 2019 09:55:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EKlU2FpOoEz7jzGClzGSzk6VeeHQgOnTYSITsYsu3hPe82ckTsc
 F9K7b5UqJ+MnTCGJwwei6GES9I4Z5B8uWiOR5EKmy5+vlutVi/v7GG5fOO0LI2DbxEs9ASR
 V0Gv6VpjcfkMthGNqZUC5LgGHEvFXuGWqXQiOxcAJ/aHpuEAn2G7knaok0fiMkt2poNRDwD
 vrql9SXot77EYcDxjlN9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Gvd2ySSyr9A=:/SB/yFIrKqDy/ngyNn6vJt
 v6CtQ6RAjYi29P1DwzPLgRSq9zXtBn7Yd4Lb4jpG2jIkJaTEokZMwLxW5BK5W2APc3cfBlqyY
 j/1MPtO4pFtCWMLt2Yis7wlgiY3SE61S+Kqaji6mxus40OKCknPTjHfQMUXKESpQCW6B3HUS+
 g2AN7TA9tGUaCHgq+FOd2H80dDu9pxbOF4OMB+1LsnwI1VBVQItOogKLxUaUe4MTqvlqYMYhx
 9awuz/7s1odWL87I9wrDANfj6S49STZ73AjYEpRmUtyCyRDDCt9BmPe1PqEyS8KC642nSqKzA
 137FfzjRNrUXgagWtxXepLlAYcM/pMHNb45nbZwvbB4Iwx2NvcucPGacNvJvCgZ7kzDlkNJpw
 BRBurPhoKRQ0g/ZugMNtePLSmQEBrDmarPx3NKNxme+SWdcx8VnZx4dt0DJ8Nwgwq5IKPnLIX
 /F5xtI4FD9RF8cwFZ5qcOYMq6axTXdE9wjR+j+DfPx4jqDBc4HRvZ0WWTTILtehe+cwlGCoVF
 rFYztOaPIVWxwhS/66bJADp01OvK1VeouyJKSgxdKM3EJJYLJKTfT3AGxgdpH9J/+ZBw/f0rp
 spzFwT1LD6W4PenZpRGHT0GF9aVBNienvVWAvLvpCxIRIn3svm2PqGPTI43BHjT7AcMyBpsbp
 tI8L1M+sgjVve3LPjc4I/1BLMNFsCM7PmLcCHIgsJlmsad11BU9nGfs8CxjKLMR8ddfOTf2UD
 1kg+pmC6OdnYTWZoB+ATqr6pHPiqSWTZE6ZA5+Rg1238kCLW5i5rX1pegZIVzA+MO2qCaZaLR
 Unl5gBQDevcsRRK5NHAI875Ck7KKrVA4YYgP7q2g+co7GVMKYgyDiAgtG2S7If4f/eNaXmgWT
 gjcZK5AXQqx0CvRf2p8q9U5XUrt6KmirPsWgmJA1cQSNaR1xOrpZ7xEpaYRD2ubKSkKAjVVBo
 HOMAeCyGJyeo8TMwIjjc7yfrDHs7I6cumflKvv+/iIxFy3UV9GoDPTnlS17IylJZS5J8nItQd
 EvgOeH0bkITl3F4Uo23m3DZhO1g9f1Cm91YqD3V+qJ3fxW293wzR0ZSNywlJKOO+zgU/7IUyb
 rAArrusO/GV/S/rKsGn+PnwOMbKQwsWP6pTYlt0UIrVyKPnNDaOH5S3jK9xb6BTR6t8mnDYJA
 2JgDwiNyjY8YZjDUDNd1YAAvypblaI6RXY8l05DyD1EVQDbXpdizAPxxkOnHtX6DrJv15Tf8w
 MgcCQuxdMeMUb94QrRCpSRIr5fVXZVnuMrLqD8FmXjAji0cQLzbGO9FkQUMU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Nov 2019 09:44:55 +0100

Three update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Add missing put_device() calls
  Use common error handling code
  Return directly after a failed devm_kzalloc()

 drivers/net/ethernet/freescale/fman/mac.c | 73 ++++++++++++-----------
 1 file changed, 39 insertions(+), 34 deletions(-)

=2D-
2.24.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19AE1AFBE1
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgDSQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:19:34 -0400
Received: from mout.web.de ([212.227.15.4]:40887 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgDSQTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 12:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587313162;
        bh=of2wU8RTRYMU0kaC7Ph3S3HMYNADQMI81zLrLNzHgpI=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=K0gD1dUbJSeH83PRPy990QeZVdDtqyBAE+R1mrgOlGcdLMeYj/GmvuTJ2eUOWM6qG
         qdGDiVMFsvd5jjlx4z4ch9BRV+2xtFSEoO53eQxwZnJGdwrzSyJB64f2eCyEF8Tm1e
         WvdKhmlEtWN6mH3+/lpevit+PsZ5wrJGnEimfJA4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.85.208]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LlJzS-1iqazs0si6-00b4Sc; Sun, 19
 Apr 2020 18:19:22 +0200
To:     Dejin Zheng <zhengdejin5@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH net-next v1] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <08979629-d9b8-6656-222f-4e84667651a1@web.de>
Date:   Sun, 19 Apr 2020 18:19:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Keg/E4Y7RjiqLK1+kspg/czOnv06G10YWSta4VRSEwYUJnc1WKb
 xsvVCGKOJxOSxH8UTTm+FzwIoQeoHV6TXYSp3oh4TLfyLOLZ46Wvwt2DhfgCMj7zzmcndW6
 SpJza4bZ8+ygOqEPVMrqJpJxSYLre0KexLMQEtzR4F76S8KG9OERO/tJ34JQv3lDR5tPA5H
 LrE/lfp+lrBNwd0zVutfA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3ol83GrGi6k=:w/LZwwojFVtRTWMWqr+JVg
 7EJwekt2kKO8yRCTNYQlfSnbwSHTn4wGH0tWacmthuvXRsiOOzfTsK3+lGHj8bLbhVibnbJZ0
 3s2r3EN7qNHVgYvNliymfmd0OBx3C5F9tI/vrrdlGLQJ1eju6rHmV8FE5mheVvgcWYv9WLY6H
 poDu4TuVi8vKVAW8atIW76cF/2khFT9XtpsYYf2PyfQrqdbzjyvKMpbjB3eFw4SK482lud2IL
 5Cj5PMcQ7VNhzfQP6RUEM8/r/7CjfJy/g7fvpr427xJpKQsjA4WqqDmDTsKj8QxwKkuceAnH2
 a11DILJppdsPCoMBlSiHVn9dlcG9YaAxrgP/QFxwZTX3hMX/QlBNK2e8OFeAnM+4ZCDXErZjD
 M/fa/XDQwsK6iVPE9/vMcEZVbNK/ckFj/SQWv6yAl41o/XcnYEunPXrTX3QcaiAmSMFPWBtr/
 6VtvCJwpRCUMPIRnDehWDKPotC/FwZKG4wtVYcKLM3ybjzNY11phctBqELdlp647woJYLm3L3
 hOhfInDKa/sk8CdkdQ/TF18KLb9yGCEo4pa1/qeNwiAmqnYO2svbluTvvI8FFGzOVTQjRByP6
 txpZGVMB9q0khJrTmCm8n0B/r5TgD4CnvqOWD9z1odhC4+7H2cr7727jH0Kj1QSRXLOmJ4AxV
 SDyC55jI3jmQwvy7mLTZ5bCp7I0dnPnCzqJ1NgLNpYJh+ZXknoeyGzO2MoVqh5+lkWyDS+XTH
 dJfWkYV7mpTD56Ppsk0xTgXI2uvCZmrQ7IM9QSXHkaRzY1R0XSnaqAEE2Hcp5lP+8yAYb2V/1
 E/utfoR5PpKW8K2VQs5iESq3CfUfieTkLnSYtPntNI7E2gzsXco9cTIpPMaaPbNLhS5X7poW4
 5REiPgkmUe1IKp0Xb/DB3caYpL1C5EeHHhuSGmq9plh0wC3pO/7Jbwe+S6bqj3bwXJpQF0D32
 wcnioumxdmB0XbDf7+jKyujxQ3308F2vHXW9whCj64lrAR68zYdErQVRcXkAsmmR0KwX4sTub
 Hck13c3pOh9gKMuXKsEjhLCbgWaDJo6+TGpsXGDkDTZR5HCjm0uaIL7oGji/puho5LnpioOod
 UH/SzWKJQhiF8oHRcau6yyzdSrvOQT/UXckLTfOrluVVUxFLHdul80zi9spP9ZRDXgClKjJ/i
 EMHW/M4Z/6tY2IAtPYrUS3ZsmnJPnUBXeO9UOIz98DMnTqFAuUfGFTJT6WcOkqCNo/JjN5hkR
 1CyC/uEzS1eGamOt5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> use devm_platform_ioremap_resource_byname() to simplify code,
> it contains platform_get_resource_byname() and
> devm_ioremap_resource(), and also remove some duplicate error
> message.

How do you think about a wording variant like the following?

   Use the function =E2=80=9Cdevm_platform_ioremap_resource_byname=E2=80=
=9D to simplify
   source code which calls the functions =E2=80=9Cplatform_get_resource_by=
name=E2=80=9D
   and =E2=80=9Cdevm_ioremap_resource=E2=80=9D.
   Remove also a few error messages which became unnecessary with this
   software refactoring.


Will any more contributors get into the development mood to achieve
similar collateral evolution by the means of the semantic patch language?
Would you like to increase applications of the Coccinelle software?

Regards,
Markus

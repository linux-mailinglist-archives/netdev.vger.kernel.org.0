Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD811238A7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbfLQV1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:27:34 -0500
Received: from mout.web.de ([212.227.15.4]:55627 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726731AbfLQV1d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1576618031;
        bh=33IPvrVK6gje/u9qqC0f6+0yOZHAqs009QQpghuQUjU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZOxWstGDvGSYFwMi/Jh2rmVkemKjVN+6hr/IBcSzlnB5xDYDoTKlWnO8VqKBAfD7v
         FqGU2SvFYRnHmPXUffUzUfWRPgli//u8lOwZBw+O2amEv2flpbJazbxZUnQe39/JBC
         Mu3OAy0NO/e2WXdGEU5t6JYa2uMymnIDtnWimdlc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([2.243.185.133]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LdalO-1i03SO3TDW-00ilkq; Tue, 17
 Dec 2019 22:27:10 +0100
Subject: Re: [PATCH v2] hdlcdrv: replace unnecessary assertion in
 hdlcdrv_register
To:     Aditya Pakki <pakki001@umn.edu>, netdev@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <20191217210620.29775-1-pakki001@umn.edu>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <96cddfde-f0d9-4186-9e23-fe4285637c0f@web.de>
Date:   Tue, 17 Dec 2019 22:27:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217210620.29775-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gmpqdUuSqMUyzBu7rUHRhEj3KoVtVM6ZQ4cZdtfENTln7TE57o2
 GT+vkr+xK9mrG/EM9QcYjQfVxyAbZGRBKhZmTIHAqzofo9DK1Ls+EwGaoFdsCpMKD2aQcMn
 6lGKBtjyWfr1WwfwctinZ40crbTOobUtuCXERtjSukQel+mbWUtoH8w9g9R5bH3Xb9BSRjh
 kUR5b366bZ+TCFPPnTtqg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:I/SsTU3h7hI=:AehP7I8xJ9B6hYzrlnpl+P
 xz+bWnXyxqcfWHrSGC8rb+O25yH97sYnZGV4Jg669eboXQM1QpiY+vBM/bmYIrjC7MQIkiSJk
 Dz6Js5SKNN+vuOeE1F5brF6HQodegsJ3vkwv0aYvpmfRcA4WxYbcaEfz217knHJwh7vxMrGs2
 uZvcUf+7ee5bg00gDZMaohVQSZunfFmOLwGSAMFH0oCKzRlkgRqNd/IfaYDxZMsVowr6yp1qM
 AfZj/b2FzOgBGYJt51UFYczj4YyjMFun0GY3RB9Av07AZvu7fhRRTs/dnPlu/vtoXe0IYsmWh
 XH6SXMXFLqCImpIzm2uXjTzzudu0mWL11vDHEThUT2bSLRz3Wx+zcPCjcTyWJCSJwpHVzN+I4
 v+ZZfZOI9aHFXsWSVA0YP9myOK2GxMH09WrYitPIAVsffAFn00nsFK5J4Gi/8HeRwTbTmbMl9
 9UsXk6ic/r3rJ+Z3yIB+u7GmPufvVH8HCHQbgsOr7O6lWd/qlpqIKnCcxN2x2+oG/6Nec2uy7
 Iw8qG55Y4MlJLk4hvOZJlgHSP8rSuw7O0w/TOOllO7i73H3qgVafqQTi36PdDorxhffMLrODY
 6QsUxR/OOMGVZ/eFzABycQaoV5kjf/wmpzzXYAAmU259Ax5l2753CToY3bl4p+Jz58iiDwDei
 rZjmml5CtGKXjUREw26GzdhYuog8AlhQy16bk6UjuyKzwYWtHNUfIDoG6gAkYzn+nChELOqIz
 6pkA1cpG8vAGIZbF7xuwFJaKs92ygPd2EpB0ADNZuMszlFo7T9hWXSMIwA1ikof0BwQ4Z2BnG
 76C16wPLrGBWaB1Bhxzz0BrGqX8mVqzUZdDnAuW7nZ1Fqim7Is0CDrVPd2NJ/fbXeF3GRKKFN
 njuR0fCHpmhNjBc3vq3UyVMsWTx3JsHL+4hOlpl1ObRSjg7SMFzFQwsE+KmwyPPbE9rPYL820
 LgHHLIse7D7AUi2yTbRvT+eoVE27HVTBW2CTwohkR9sEeJDxrxoHHiYgXaODu2pKGQjnchY81
 J9X+gZk1vZ4cQPssvnUvHyP9i69szz9+nuYLfZ/UASxrannGjRryGPFqFbTV6JbRMoCy3noLT
 KI3HaZtL1xoYIWXOlzZ8FdRr23Hinp8RWv8EfFF7vs0OW2FmppqtXqGd4V27tJqz/mPDv03gc
 u7NfgqRrZTXcuvZAVDwiuarJ9Cy/OXrqqcL6jnMUP1GaGzeVh+HTsCUw+TOP9PabU9TXDIz9N
 ggWwn7wauSRvjEdabdaz8dhVHoitLzwJz/SDTEj7DAkUbcmVoNV98o33cFYY=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The three callers of hdlcdrv_register all pass valid pointers and
> do not fail. The patch eliminates the unnecessary BUG_ON assertion.

I suggest to replace the wording =E2=80=9CThe patch eliminates=E2=80=9D by=
 =E2=80=9CThus delete=E2=80=9D
to make it imperative as desired.

Will the tag =E2=80=9CFixes=E2=80=9D be added to the final change descript=
ion?


> ---
>  drivers/net/hamradio/hdlcdrv.c | 2 --

Please replace these triple dashes by a blank line.

Regards,
Markus

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08A91C3BC1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 15:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgEDNw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 09:52:29 -0400
Received: from mout.web.de ([212.227.17.11]:60733 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgEDNw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 09:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588600322;
        bh=cFVXkRUk6UJaSpBI/VIx/GR5RITKsiriExba2uaETAY=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=pAg+iBXh0v63DQOToH1XqZ2WGSAZJVnl2bNg5TIFIuTvdPeelMGVgvtQ+2J1tckkt
         H0WJirV38uqObQfpgnDfXMtdUogMnbWiYudFjiG9tWm2xk8FJjPJ13dIANqtXGjRZ1
         G/JCoFo95Wp7a+egu7ab39P2WbdiUe6bzUw+RPo4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MUnUe-1jdNRW10to-00YAvs; Mon, 04
 May 2020 15:52:02 +0200
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Subject: Re: [PATCH] net: rtw88: fix an issue about leak system resources
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Dejin Zheng <zhengdejin5@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <79591cab-fe3e-0597-3126-c251d41d492b@web.de>
Date:   Mon, 4 May 2020 15:51:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3Q0yOt/oAiOS1O7c3Hdjl6qzdo3m20XKBVz2bJ1oMCAYp2iCjlx
 rJr+ctoTrrpjOWCOBR4qS/pp3uguwcSdYI9yyZGUZSrPyGEBYHyH67lBcPDkqFJCKW7NCHR
 i/M8iUiPnK3XsYJv3guI4juC3Eh9zJ9lOu5B7zy3IKUKwjsKKndMqi9gu6P1MQk7PAndUUx
 DWsJcWpt01Sz8g6UK0sCg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aKSvsNpMAO4=:Ly1KZx6a7fIU7UFehGSu26
 A2g+9d+R9MloGS9A8NA872lGFp5B3dkgdYiX2FTso9K58NSva65uiJguKSQNh0e9lSCzc0nAw
 XQGb96c5cBo1IlvwvKOH63edxpSEcFQOFJyzEWOVJBfC4S54ZmPXT6xJdKJrfnQxyqYo0KQVG
 KSsuHCEayPJCkHxqQuWGFPIKOFrUj26Lfql01hhZiXJN14EO7FRIYwkKyRYJ4UYeLkjhMHXZ1
 iuQeAR1ZgqOdjZIwDPnKqPBHbiwpSuSjtbC0I52iccJSfUQpsERWSzZgFFESIVGEcq0jwgD0m
 dg5pkQN8W315BEWM6k+QuDCGOydrol5L2MSndOnBAhYy/xJzm7aWohiUo0VNb1YTmL0vxRmZ/
 KXBnOk5iyIq9VMfaF4MR1JN/jc1IwM9FKWB+UGbAhi1wbT4Wey0jZ3dkZIjbsyOqZGFJnst3W
 Ah7W7Ky6An39OuWH9RBcNokHAzO/hm08FpPc+4hRoDqOnyExMmOJt7xzypYVlIlkxHl1xX0UG
 KDe9VbhZ8CZyQNm4RbPnynMTDPQmQHywuF9bJ3EB9X0rS7C/1PFHLvIJejfWqUR4SypJiFA30
 dpgnH+Fh8o7jqt6Smjb0ZNGgf2yHafibI3cluOtTKQkEq8h7blh2LAK6Vs9Mp1s7kkOpUR6TC
 y382ZPFJEpmQ/sqzRNuio9lpIpcnJ1LzL6N6B5+B2rjMiTTE4dRCldRPwcTDDVDoqHHChzN3E
 5TArfC6y4tQ1EZE6QbUI1mnJ6F/aKpUybTy3K9aBPrmlj1f+UrQK+O8CqfsEBeyAg0+z7jqDz
 eCFFyES2cytUZ8Dp7wdjjhebyx6HgoK7vcB6hTqje+v19CkJvDBBOWGppfQ5+6Ji5pc7QkMt6
 PwkoxJifG2lu6srxnlIImGp+u9NONKetXY8IREOgvzV4KRHJzgfJRW/9BNhRDNBA3n3bzVPiy
 mitrO4QXOrDFaIJ5fHemqjEeaLhS57dZ7oKwXy53VhiDwgLPxm8wJJzPeaTxnOvZNq9Fj7xqy
 cpcoV9U/fn4kJzBpkmcFmxx04LcTR0ePft544egb2adfspYW1VwVDHakNXszzbl6Raf/W5Ow/
 fQVicdFxHWoioJJxft7PmTP9DYySmkiiRiad0GthuWwEgDGOoQZ4cU/GTW9L41S9SgnAx0FvB
 u8MhZjJjfrrNT5UzVZncn3e3PzVmt6J2yh7tBttqvf7IyJwP7Et72GLkZNG3Jok4jtZUp8a8m
 piH24JV1diC8x5KPj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> the related system resources were not released when pci_iomap() return
> error in the rtw_pci_io_mapping() function. add pci_release_regions() to
> fix it.

How do you think about a wording variant like the following?

   Subject:
   [PATCH v2] net: rtw88: Complete exception handling in rtw_pci_io_mappin=
g()

   Change description:
   A call of the function =E2=80=9Cpci_request_regions=E2=80=9D can fail h=
ere.
   The corresponding system resources were not released then.
   Thus add a call of the function =E2=80=9Cpci_release_regions=E2=80=9D.


Regards,
Markus

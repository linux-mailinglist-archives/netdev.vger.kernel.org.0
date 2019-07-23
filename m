Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D774713EE
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbfGWI0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:26:17 -0400
Received: from mout.web.de ([212.227.15.4]:34979 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbfGWI0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 04:26:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563870368;
        bh=u5H8y3WVDUnYfFIi/whUZ27m3ZihCo1fQyDUenzoXdY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=oEdGfOJnP7wvnZWF3lGzuh7to7nDU0IzBAnOIm6A1xpF1J3ebi6WZMaIt99ASxMB+
         zRQdZcZnAkCHK0AfTRduzH40qFeuBjaRtjaUCpg/cAXzzD2WAZE6b3O2xAyduROHkw
         AsHkCA3uRSVybwGH61v9nZ1MYGgw7BoUDobnOg/M=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.83.115]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M09z2-1ihXAq0nfQ-00uMsU; Tue, 23
 Jul 2019 10:26:08 +0200
Subject: Re: ss: Checking efficient analysis for network connections
To:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Josh Hunt <johunt@akamai.com>, linux-kernel@vger.kernel.org
References: <1556674718-5081-1-git-send-email-johunt@akamai.com>
 <3d1c67c8-7dfe-905b-4548-dae23592edc5@web.de>
 <20190601.164838.1496580524715275443.davem@davemloft.net>
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <a9c38b54-c3f8-9e2c-e526-e15c692d1f7c@web.de>
Date:   Tue, 23 Jul 2019 10:25:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190601.164838.1496580524715275443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:0UeO+q79FBikwwCAvrqth81qIYVmI9m9TsYzYqV9ApCuN9Cmhnj
 dw2ji5LM3DYoui36ooveisdjFcsejEWT9QwZisRAZv7Ule0rvll5FJmUqJaNAu++1+9XUup
 9NdkQDC8YZtzSMB9VtrHmLs0RpUVIDpMLTPJPgc/eVOlkVgGeKn5PZtl9AnHat160MjyiRg
 7ymXV0BsdmPSpxE02Sdag==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8VihV7TzLXA=:Ey6P61f8CbpBn2mjLcG77P
 dJKmDtY47u4ra9M3dbooCc8tUYvBu3meAPtR/eIDBwjbwknS0cq+kVdEVHwNue7tZVQqVqqmk
 J4LmGnzXRuGyQMAXOkJlJvAX2qFfNvuK395wXdF87ETkked5UllOY949lBYcEUOBEfNS4r69J
 lPVfVgbTLdqnU7xDwueFgtZLTVeTdBftS6dEJAkao5d86fNa8wRjMt0T5OGJ95wSJ/VE+nHkc
 JuLcZ4h8uVDvDXlGTU9yW/rApo0tuWNQJpaQIJoMDJbMSazfAxXzE20gIxpASaC2nMKCKWS71
 WV7bpWDitZeVPWm8gx/5ZQYtyRX7yxttztVkPRU0O/z6LeW+YqYiiOy0rIj1LWM3Bww7oGoTh
 qguRxIFughFfpknF66EZAZG/8y0eJtjEkrwId5+mZZEu39JCWns2neGQzdmz0b+6erEOOv4MO
 LcPGOi5t1Z6bV2xy8ND70mwT2e8oGGmiYJRwmszyypAnZUBBBaLPI60L9hXziApwakJeXyzt1
 x1JW5HTP8uLviwqimnIeCWlI6PX1SKZRgv5/9imMBOsKGQRVXwnK4pKDrE08KZ1C9rsP7Ygsh
 JZEx4VMF5FIHmP3VHxds+3D1vvsBxBC3Z72zFsS8Q/3/2MWulQ83qdT8gIw9VuWF80PX6Nbp2
 F7i6J5mn7n6TGagXMWCZXvKCdGdmO7nPUnbu7CynrT9aAgNhSD1/QQZy8AGVWrKVwL8dxNo9g
 +SEItm8J2XvEdxzWL3fQuLzKnznNZRn2NhC/DqRLZs/h9o+qp0rm9PmIX991QDECceqUJW/Nl
 uIoI56h2EqOtwsZ4lrrjzbG4Uv72qpgM738KwZhX1r9YCWNS+Ey/EhG/w3+UyTSBaDsDMrT66
 /Fwj/Ep1goPVe/JdJsvsIhjXJPZCpBFNfCyKp6QNjP83DMWubHpvZgVOdqOxySYH1RpthHlt7
 6IAX0DHE2/nx+E/Bddf7JlJDBxhKVigeve9oJkRDqV7GvdunwAgwf7EouPwGU7d2VEzoPQU9t
 nj3m1RuK89jaufE494BchYS7TSbHfAXbfjoh93jERWrU3hzrw2s9tLCAxGvO5V+0RluGCbFuQ
 D82ohpfklBP6GFzQNq3gIMevqQYnsHs2v+e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This whole discussion has zero to do with what text format 'ss' outputs.

Do any more software developers care for the clarification of
additional data formats for the usage of specific information by tools
around socket statistics (from the directory =E2=80=9C/proc/net=E2=80=9D a=
nd related ones)?

Would you like to achieve any improvements in this area?

Regards,
Markus

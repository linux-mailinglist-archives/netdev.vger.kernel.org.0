Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46021A6CF9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733199AbgDMUKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:10:33 -0400
Received: from mout.web.de ([217.72.192.78]:37351 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgDMUK3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 16:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586808610;
        bh=hohdPQZE7AeOOy6DzbYybr/CUWc/bO1yJDL5ARvFSMw=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=Ii9BQNUHyNmdB1tX9DQpcC5vCeI5lVBA+74fEnS1vyWSoH4yhoWphnatvnO9ZdOlA
         rlcPcpDCKrv3GAWf22g19QcZf9fkxINxoxDrhGAIpcz3OKhOiOjj0SJ6+HH3YOzsgi
         zovlHzn/If1oW0Q3fvn1L9lUZ4YSnwE+53HNkwds=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.133.146.177]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M40zO-1j6pVI2rX0-00rbJp; Mon, 13
 Apr 2020 22:10:10 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: ethernet: ixp4xx: Add error handling in ixp4xx_eth_probe()
To:     Tang Bin <tangbin@cmss.chinamobile.com>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <167fa941-6531-7ede-3a2c-cc4f2bde0845@web.de>
Date:   Mon, 13 Apr 2020 22:10:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QqIufzfLP97h/oxSewSwBcYkS7m2tN9Ls0qVgcEzveqru+eCqJr
 QjhB5DMz6UuM0oGIVBcK9PlNmY/Nrp4S1uit21P4WMIJDgbBvTdeLkTiD+qvPJIri4gzJIv
 0kMlCRDEFUnvD/vUorVKJqStjr6fRO+2ZciQtqfnNFwSF3WClgFhdTKOaOaOwIH7BiKSIeK
 lzn/nKr55Hg6c33ObDdSg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:I/8vNH4z2OE=:pwCb9PdPnBsR8UV6WUXXsc
 9hz+2kYXy8mdWVUlcgbo2mZ3nT6z7dR3ckt5A0UtlcWw10pGpu0/TpBd1uUnV6T7q/uEf8oWq
 WVP4IBuNVGVaB2Hhh14RLqIu09QVlGnDQ8lXu+WImMzd0J1vc73GyKFeTvEJPzARtcTpjvBMN
 Qbalw2rxo2XpB8zfeT/46AEoCxnf7WLRXQKGi5VxVUwRPhbV74J6ZmIMHtZMf3oGiteD453T9
 CWq9GZmvuMkWcpsWyBuFrpdwkoGAhAJgfms6hVcPnJc1O0YQrkH46jMsqfwgrAHs02O6vTYzH
 hQmNRY9tinISGr0bIbjiY/CM5Dor2TV1y5mbldf2ueCC2QSoJlxYhhLls/wF5mXqZSuOOxizO
 I7S7Zhj7sqT1X/J5OjEolUVX+CHD9zhn+lspUSq/r8zr48hbmKb1A91JqtHVbBpJPaxqW1ddj
 nmrZ9+UHWegtnBFAA17Kc6nrFE1nq+HdAEFgx4l7nDj4JU6vx+WtLTDqvrFqRo10szsEnlWP0
 x3OLFFGoRm98skKx/qmMDzsx8LX+uswu3sYnD96e9lobN8T5UlRSgEWKOOt9zJqU+jsMeJf8O
 buIYQOooMJQgvodTX0Ywq8xS5+v+SNm4+j4GGnrkGiqoaaNhugwuBEUhX7kZx0lCwf2z9bt0H
 DrR90nOTV24838r61WGYllBZ++Nf3hxYM323euKqnkc6I1u3lYPwrpbnYq9e+1Tdon6AxnbKA
 JSWB4GGz+kUJdwU6WlGRTo7OE3BRQmSBz1F1L/ZrPG5fU9hwUseeqyA78DWgNvUck5BL1Ia1l
 IFuSAQi4hPEln3D1z7KSBTGwtVp4ij+XZID6aj9pNVOaw0IvFe5uRnNleVUHJg4d25AbNc3l/
 aEDW+odRah6fAK408Bgr/ndCQmWWYCJFMldyxAKoUVWJs81JZBtQZ0W4SP+FBsdHC8twW7AnT
 sSemvXxA+Wl35+ed8X+ymsRhnVGZyKuwUg5EkMOrjaaZ1cYZtFKinvKtQUVAdxDcjw9z530g3
 SbDfsHQ9j28Po2+6+Fu+3jIqCXJM2CRpO9yeZmf82FBtcbmZWaOKpZTnYUsr02okyDIhCGSf3
 pxxr1gFt+wcpwLMUOz6d8KzxkNmVgDK/8c0iqReB0Mrt5tP79HEvMxcG/bNhfRUkXPaUj7aBd
 92eU4qcrz5z2Ujl+QBPIiVnj+IJ8RZ9Hpw/If7aRuqFlkXt0qIfEfkNQQCSTnmkOzpnd8DPCy
 McLIjy+Pok9No+FDL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fixes: f458ac47 ("ARM/net: ixp4xx: Pass ethernet physical base as
> resource").

Please adjust your tag suggestion.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?id=3D8f3d9f354286745c751374f5f1=
fcafee6b3f3136#n183

* The identification is too short.

* Do not use a line break in the tag subject.

Regards,
Markus

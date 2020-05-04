Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF641C3ED2
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbgEDPml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:42:41 -0400
Received: from mout.web.de ([212.227.17.11]:52933 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgEDPmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 11:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588606945;
        bh=kTdJoXl3KihM907TcZsBRc2W6R4KPhYFBlrHy96bxEU=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=J50Yc3tsucubTtUrl63togQLmFo+2Szj6XxRSxaWcBKQKYTPHAJUtUrCqbl+tD7A8
         03hPmJ4jxNWof2FslFm/yAkxd5IScKyd6VVxmR1GzEo9H5REiP6KLaMX3ZlYVUPfLU
         DjCT92ebHpZVIvvwqTbJ2uUNZb+8mUSIX1pKr+yI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lba35-1iqldS1Ftb-00lAY5; Mon, 04
 May 2020 17:42:25 +0200
To:     Maxim Petrov <mmrmaximuzz@gmail.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v2] stmmac: fix pointer check after utilization in
 stmmac_interrupt
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <af38eb97-d734-3911-2f5d-eb666deaad7e@web.de>
Date:   Mon, 4 May 2020 17:42:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZqWFU/Ep00QRhnJVF0Ey7fqh0s4qdzWKsmdFQLqzRnIGN4im0ug
 QLgJaEbCfhp0nlw4NkcRoCa2Z5a0rX88tEhDbfAmv24S+Qu/HEHxmjZmnwD9c0gF0U37VDq
 TJiqRN9+60p9yX5yHY+WEofWcCYR10PfCpo7+cbOgcirnIry24ZLRJ54mmIeFPT44o8Hws8
 cPRYTzr4ZF2mMpy6vd2pg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eoIDu8Cm6qE=:Cyte8JDVMvZuD3US9WBtA1
 OVZOqFEzmziuiOacYme3IbY/qFFHEBfTmBnfnZ+8OWC3YFLyQ2Wv4heLPkGSgrNnDsq/z36eF
 j7yX9l/SRsW/hRU+boG9RMFEoRuudVTFpeBG/JNhDAW2KQdVZi4czbA9YZwtEEJbnXxtmEVrZ
 otQY6j1p6zrqR+T9Q8CN+IMBl7ejjB+fBEeEx8Z6hHnWf9qZEblzwUWo/My4ooDCkeoFKSHLw
 NGZMc0O3SQx+yldJ5YGEzbey9ve8ZjVaKC0ebN+1INC5R4I1U1g9xqbLM//RYjQxLaJksH5dC
 dCmb/n+Iwarjnbl2NDdyXaPq1E6EWRwEF2UrjsZ5jG+jEdOQa8G6awFV7hWyYmCZU9yZR1C3G
 v07WDD0sJwh7y0eaL67iRD/XI4FGGlpXbFUwQTzpYP+YSWlF3HY9qyPin/yjCPq4+pa1IR53+
 huTc5njfGWrOaaDW6EpbfhI764WGK1WEC0c+xnJhAVTkfNOr/hysl1t+dJmd9xyjpKm59WHBF
 F8pY8IjhkhfdD8Cnr35YpWN/vJnsRgFpo0S6QSIQFQv1zgJ61WBWCaD4DuRf9SRwrhOt8xLf9
 Cp0cbYe4cilTvHWA6KO+8N44XqaG8ZgzbbeSpo7JiOX2C3oQwCzMj4SVTbcD6AJQkyo1NXDXw
 /mAfO/az22IR8YUGWg3Q7+kAT2V9HQogSxZKwMILa7JgkrcfnBFDrnr311no64gBOETQww1d2
 sOMf/DOqDecWOTjZz/ym3hRssqvYDCzbKTzp61RoQKEd3vLDUTwdx9BPLuLfPdoKdtTj+TXsr
 tpRX4zWAo7CnmVO4qt85aat3B1aIeotF/FZZ14llqvrNDfS7S3YLfsYtViaApRA8WaIEd1lB9
 TINrzZGAVhBUZkl9+yfeicbl65sUs1X/5YKr6ofE4ZJtnELBcgkCtGfa3bYmaLUAAHT0tgLzd
 LySyVIHuwDVcfgV+Yf9MqsKbPaYQh7iHhhaEHu6DsVmid3pe/xqxsyOfxIcXKTqHnbuApu+kp
 DKlHjuSc2m5/9h6BwneWfmASq0YGDDQKE+L0x8stuaz76PuG28aGAlifIlg/ssymyv2V3qWlE
 alaXlCG2CNykOOapqww+THRpGr0JONc+PsNdKT4lUiBGGxNn9D28IdZgt0i1ghfef/OsbVGC+
 GTxlPiarN2pUKnkdHmg0l6SiPuvOO7pMJ4DS5NVWqyxZMD5MRhw4G7DSU5m/Cz6soJsG7nCHo
 x2qqD/LpkU6t028+p
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 However, the code fragment is incorrect
> because the dev pointer is used before the actual check

I find such information interesting.


> which leads to undefined behavior. =E2=80=A6

I suggest to adjust the wording for this =E2=80=9Cconclusion=E2=80=9D.

Regards,
Markus

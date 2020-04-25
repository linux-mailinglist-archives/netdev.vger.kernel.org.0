Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90171B87E0
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgDYRAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 13:00:54 -0400
Received: from mout.web.de ([212.227.15.3]:53191 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgDYRAy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 13:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587834039;
        bh=lKpSPjYpPGQXWma85OulE16yMA85/rVKlAPZzB/3y0I=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=Mv7oztloAjKX9VfhTx9+LXdYCp0n8VvZYT7IQ1QH8mvakXINDhOhpzy7ksdXjsRbF
         87MD5b/MW2nI45bPMPrSYu4Tl1z+FFC6K6ytci0rdRrhqDhgx8tkElzt3BYL1N8Gdt
         VxypLUZJ3q5BqF9c2Xhwp3bwdHeFOowIfUYaYzH4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.49.160.204]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M4ZVE-1jGMWY3Tpc-00yhim; Sat, 25
 Apr 2020 19:00:38 +0200
Cc:     linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Yash Shah <yash.shah@sifive.com>
Subject: Re: [PATCH] net: macb: fix an issue about leak related to system
 resources
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
Message-ID: <a0891e70-d39f-7822-f81a-04eb824c6fd0@web.de>
Date:   Sat, 25 Apr 2020 19:00:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:Wvf0Tj9YXRThpDAVM5/vvxCEA8fNyZ4Xd55fgk74ZLFrKutbX2X
 IgHscW6wWj2WXLfeVPj76RVtIuLidpH0NiqeKNwz6EppDGF3dzW0aaZkrKBGcO4SQBmUP4a
 CdAl/1d9nDf/EeJHxGcHPNDX8uzaEcwDqMvGRPaWXTpwvP7ZWdeHLJdKiF142ywYP+m/vCs
 104oSoZlbMNKnB8rKLUew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RjXyGDG3ey0=:XpE+HpBTjheQtENTVFbZZ1
 82MO2gHojzK/FRFp18czTbVbcf0aeI/TrWEUiZFr2EuxNCHsjkktpXY3/rKguuEETrKAaNgBq
 jO6N3TDlyff5cogijpLI2f6TgfCjyBr1FvlcRqbcTUPsD0S5BWnrHxTVoAX9ScOqrrMrIH4+/
 bVTtUHVdeJdyLJRRe4U0tqYySiVzWwOKGx/TMCU9gKxdQSNDVzsOlHUhcIsgULkN7wodGZwIm
 vrKQUw4irZK3zzUWlHZw1f87Yq2YA69jFz6JhgfbmadgtTdLsueXDfjbsYVwQuOcw5pGrIJCu
 7vDVsk2S3hm7knzN0NAtMjg2oYxJQHoAlnhMlLnAHSxgnaKQkgHuCMh4Wg9uv1L0xt0Pbc9Hz
 5/jw/tJt4sqPnkhkEc18RU6cOn6GY5oTqnrULB47R8n3govp11FfBAFTu+W3HIHcIjcYK/Dgb
 BiQ5WgeYhsxIAxYUfXnJkEQZ2qmzou1Tr+WaJ5MySimVlNVO7atf6vLT0z3b1Th+3yD/bpKEg
 8eQFUJ6CyZExoL2burps3ZvUSifFsejuxvzXkXuCKPcaVK5sspJgDEi+FWYEF3LdkdzYdfO7u
 oojxzK99ehXMOO5aA9VQGIiDYWPGW5MJb85XtQxeaT3C+G/dh/AzODeeHNj4trLvr+ql4o0+j
 26gO5ZSsSR/EvP5g4YQCgkcoZTnYXB84K7vE15JQRrFkwWI3z25L2eJudqwtfPPvyPkfJrcrQ
 DT/a+UCsc7VQWfSPaM0F8tpwakT/ybASuTD8kAez7NOap0yfxzOix3L/AKUjb1Rii7OT+AUCm
 lt2RyzpgBe9w3yKUFcqpIfuYfPe3cfVxcOS9NWkxA45FQin5MxUQSFX6TBjbuZcL1nARktWbK
 1nYKknRVE9yH0puYYUGS3VbPehyDkD5cpy1YhYNcvKVEaM9q/7cG5bNOMtzHvkbkYRcaKplfF
 rPzE+s3VLuQFHAFQRpGHH4Pmyu1qlodVAxNlIIRASdFNwoACuPwr+R4qLXnIimpxxTWRJ/YBK
 imoYHLkRQixVfqYWt2R7FbS86/Z/l4OMWGk/LH9Li2teCIRvP95gwM0xWHfoso0ID2Z0epYgI
 kljwrteyNnelrYJvmCrbNnzz4ghQzKfd3dGN0hIi/AOK87eXloXC1x2JPDTXdkUYNXnbh7P7F
 cpgzRv68cqdB41jfw9gn9GNfaWgcdOOfuLPLKx9a9gxg3lAB6gDGgNujD9RXqF5keRuUBQesa
 5CEqpy95C9g4a5Tul
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> A call of the function macb_init() can fail in the function
> fu540_c000_init. The related system resources were not released
> then. use devm_ioremap() to replace ioremap() for fix it.

How do you think about a wording variant like the following?

   Subject:
   [PATCH v2] net: macb: Use devm_ioremap() in fu540_c000_init()

   Change description:
   A call of the macb_init() function can fail here.
   The corresponding system resources were not released then.
   Thus replace a call of the ioremap() function by devm_ioremap().


Regards,
Markus

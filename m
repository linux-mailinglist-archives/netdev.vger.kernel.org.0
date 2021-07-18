Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E0E3CC820
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 09:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhGRH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 03:56:58 -0400
Received: from mout.gmx.net ([212.227.15.15]:55591 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhGRH44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 03:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626594818;
        bh=sSf1sanoNyOf1s8ToImMPkw6H4e74dn8eSrq/chg8Q0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=QkiEAqWbOy8TBkMzD6dJ6iOxmbJNklBnmN5fmO5auXc39bOBUZNmCiMMq6BzSe3SL
         JHlnNQq3lUG0HnHZh3kFx69V2wfElMn+LWVlmRU9AMyXD6X98DNztXI7iYaFJD8WVU
         AzgwOEPvZWB6eThd5AW+lSxBnGfy2WPJ8pLOBjwM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from titan ([83.52.228.41]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MSbxD-1lgVh247tR-00Swiu; Sun, 18
 Jul 2021 09:53:38 +0200
Date:   Sun, 18 Jul 2021 09:53:24 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Brian Norris <briannorris@chromium.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] rtw88: Fix out-of-bounds write
Message-ID: <20210718075324.GA3118@titan>
References: <20210716155311.5570-1-len.baker@gmx.com>
 <YPG/8F7yYLm3vAlG@kroah.com>
 <20210717133343.GA2009@titan>
 <YPMUfbDh3jnV8hRZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPMUfbDh3jnV8hRZ@kroah.com>
X-Provags-ID: V03:K1:JhNSeBGs0zGSWWl5J6a1ocVLtAtD6Ugtat/wFNLVSUgDhgjxb5V
 88TXcSkGduQlfyCmZIXMllL7WXSwL0iYJIw/HRkeXLaGkZt9TQA+F3lTwKSJ4PMEDZUBFVP
 FLriM5kbh8nenUg/RbsZH/EMXmeLuR5QD+0VVHlH2ej/P0J6aGKh1GeARjfWvPk9GjpaUWZ
 eYTCYljvuLwUa/GHZ3XOQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3Gsqx7Fsm5s=:SUyH/zdppSSWWeT2atMcIU
 OJoajrmk7YOGbQc4atP37nheeL7mYoA/rCw2itbYprFYuOIOcvpG/uhtrhqt513ABup1wKihj
 aywtvxmPXkr3HjbD71jtoMaOUgwhUXTI5LrPGWV4Siatim/zgF8hBWSHRu8g6c1yvvzNScnvh
 YYCPLWk10iETYJ/pwWnqMfuKcyOje5409Q9Ck6AjL2vBqO57s4+UoewIdxxqxMC45D3W5Lt7e
 VtKnvWLaF0Ps68uSJZCH9fVBnj/YCZiePUTQWekXwDQPLq1IcF3Kmdvg8uDr2GotLf/cveiQF
 bhrtwI4IWT4vf94erqhnwMlGaQU83owU/+ynUZ7D1dQ3LNRaRe0v5R9OVrfBGIU+lquSqoJZ2
 2Hkc/US8xqD46BAuvLgnfkP6/Br4TR0gRmqjwZo/4K1n8Ore8Ktn22a7N3bNp6W1/yAft7pTv
 otxrm/PtOb4jz4nebcLPeMb9nnspC1IqzzUApN8fRlNDvWriLbUpcUQsLFIHe3bFe6zjN9Q2K
 i35EiwD0le+aP45iaJkjeTZdWx4M+9Ft/edoIxSZ8FUEgE4hU7D9XDtDHUTG4nFK0FBe1n3Qf
 Kn+JuTihguTNaAQKz2LTYfsoUldZviCz6Fp6x+oqIKvN28tJ+jTb/v8w2BLF7TH0C9CGT6LYY
 5KfLkwW5ou/BlZaXuL5z9+LzkDG98Yy/5fwoJ6Ucdv4NJA5iQwEaVVjC8ISNuy8iwLLY8n0KT
 lgBUBZWe+5h1TsGTKQobDbr8GdJT4hfTJtBZggyeU4KxkxjXZUNBCMjNtr6Yr7p5NzKxjVG5V
 y9o3DPzhuMhzAGWYRXXvUxiBLvfPsEPqEhn9EpnxJ78iQXBRGdlUsB0v03ZTWqKo/VgTXezPb
 GBWLKKnCn73OkJx6dAvP6h7sNXz4GZmbRMMqWMUlI9TgZx1dZcF78z7vYBTsTQkBta1YybX+m
 r3TDnmq8PAqjpYrI71CT+2KPP9xwak5lehy9uMSpkrPRAI52Vfzf2q6vpY86wy2MYiavE7gXA
 kvSO+HJ1k7SBrkgIMHEqRprmy8Yo6tqvQgh51nhH4lOhk0ClsilVBKuDJ1OTRn/FSJvTKSEob
 npgU56hW0Zg+ALy5mwXTqA/H3bqcmxIq9de
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 07:33:49PM +0200, Greg KH wrote:
> On Sat, Jul 17, 2021 at 03:33:43PM +0200, Len Baker wrote:
> > Another question: If this can never happen should I include the "Fixes=
" tag,
> > "Addresses-Coverity-ID" tag and Cc to stable?
>
> If it can never happen, why have this check at all?
>
> Looks like a Coverity false positive?

Ok, then I will remove the check and I will send a patch for review.

>
> thanks,
>
> greg k-h

Regards,
Len

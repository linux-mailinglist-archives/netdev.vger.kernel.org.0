Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737B21ED15
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGNJnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:43:22 -0400
Received: from mout.web.de ([217.72.192.78]:49411 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgGNJnS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 05:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594719758;
        bh=b1zgLLM7aSsCcV07FLWap9Bv6VC1FSN60ZmqjMS2gHg=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=gF29rAnHUA+btvMscfcjzOQJRpJffjZiRpW8lLXQikReQft5qOWu8s/v3n7x0NXv6
         bSXaKNAdSm3k3PZ9TMa//6D35fc7QIlT2nuPkmJnu3l82BfQaAiqpmOCQmjruBNcox
         Sab55jDcJ7tSbNfLCquT/cEbEDLRBgnU3Aw6SFYo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([78.48.21.3]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MBTEQ-1k3UOu1GvW-00AZMa; Tue, 14
 Jul 2020 11:42:38 +0200
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Esben Haabendal <esben@geanix.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: Re: [PATCH] net: xilinx: fix potential NULL dereference in
 temac_probe()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Xu Wang <vulab@iscas.ac.cn>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Message-ID: <d0873e01-4e07-ca59-ff6b-64ac6ee6aba4@web.de>
Date:   Tue, 14 Jul 2020 11:42:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vLi6h1xpjWMUCKcSNNNgX+icND2lD7ixmP/+xib65ObXwxp/pN6
 Requoa3BsHECASb/PaU0viV5ZNyfdtqA7vVkT7filAT2oZ4d5mdvkjxMm9ma2pQRLCIXG3F
 z1dftJP+Y9PQp54GUwtsS1LPy+kT8IhprU810ByqExc2oOr/+bRcI1WmhG5chuBH2Kbvb1k
 oKp9G2RfG8ycPGEutGvPg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:SmFznmHh7L8=:RF9548JLrgaZgM/UjOeIvT
 SzqVtYGkgKAfr3jvou1iJnaEToaslpN2x+1bz+rEsUgnAig4gOzQ6OG5bhPaPaakAn7FJzm4m
 LrScKma38z+exxUH5z5YP/TNZPHs79YimS9aw4TOLKPAdn6EwpRE/DXXwAxX1tfb01cgQBjtB
 EEw3/OU0Y3vG/UcdazDX30c4fVpZaQ3cu0ErpeUSgiTrfdlJgwCHL5rh72F3B/MhCGWf7p1Yt
 h5+rTlFNfj887z3rAtDi3mqG9mcLTlpLn49DCC4SOP3go6KcBxBm40DO4SunP8lnG9ht5hMAB
 lbkwRyV8KoJWeNSMhzPJutWGFmMh1umzZhOtx8zCQI65PwJmLwmnxV8CYX3l7KQCu7A1gWfN5
 lqWdtJMMah6WbMR7vH+krtQ3nxPQmQd4vbmQNNeRb16d+lvpRupffqCY80/KSU9uiUGXxxzIT
 meWteWZUm2IRskruFqgmwuWR6QC5N3dhTRH0G0y8pKXDlsnG2PeLzC2FaBagzonadLSUoGu8j
 DZirrtB4Cz9r0GSbqLO4H6GPBCQuwkVQQxlJOW26FbKPfC5j5lkfHAWN4Hh1FUq5HDi+yvoB4
 JwLh5b9+x7HRw1ZADOJnMHX3pNmtf7O4qfCbGa/yuC/zJcKxdvIZypLWYuE/7fsKJgDQFUR09
 4fa3KwinHJpplVv6IEPZiqSaCci5ree9BJMu09Tde/dNxB8jgiQpQF/LwcWPPoXKa4liO2sHO
 b8BIGwyba8uWUh4sYLuW8VZ5nTl79VGvu5jcxCaN1Dz6Ww7b4V1A6vREhOsReAOrFRNAq1aUn
 VXypJLMDLaI39cS3fcEDlX1LejeBawzGJHlie8KHXYlqyEFNvxYUP9Xjt65bNFiZjdufKFiAd
 PwIJbZoKhs3VDQcE5oFgu7YWYV4gioA5ShaTMptCJZ36WXcp3nwSG3BkuoN9vFSLvxzosaOn4
 qdmwxeY6pjf1owmiY+f7v7C9LjVqdfrggpc7EXVSRN4DCeKhUd2yIw4vdL57WtwcDmi6PZzNe
 UYf08WxUD2OYRiPw8T2XZu3s3OF9E/yO5Fkk2MYQi0h/eJvEbk/1vDfNa4oVUghrNL1fAcfkB
 +IIsKxPrCjOiCLinoCzTImhp5o4Ifzk05Ll5XGFqH9VOnxN2HwSytA3sz7RsnBWWrCPTq4Tp0
 bRreulSgz15l1aaLwGNw/DKQ+gkTj2KPm/GTunroSPzxde3ScVrqJzVUYp7EyAUet4D2o1+5D
 twfZKyOCk32jVMAr4RE7gn5IB5iTu9Ji4PwsYdQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If you use devm_ioremap_resource() you can remove the !res check
> entirely which would be equally acceptable as a fix.

Would you like to use the wrapper function =E2=80=9Cdevm_platform_get_and_=
ioremap_resource=E2=80=9D then?
https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/base/platform.c#L=
66
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/dr=
ivers/base/platform.c?id=3D0dc589da873b58b70f4caf4b070fb0cf70fdd1dc#n66

Regards,
Markus

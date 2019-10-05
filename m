Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B6ACCB73
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbfJEQsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:48:40 -0400
Received: from mout.web.de ([212.227.15.4]:58843 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfJEQsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 12:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570294103;
        bh=4qFUPO9sA/yWcKHS0hB5s2sv3vbiaz+inyvgXC+9GqY=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=dNqajf4seyfblS0GaU4vd7UpDxaFHWj8Q31GqiZTAAR0kPakmwbMIWo0gQR1h9oZZ
         7HJcDw5QhNlpCB/rW66myfCLo1Ctc4uddmNZuDFyfpnmmHWd8DT43m3g4tObd908Zb
         4I2Ozofl7uhL6bDzgsZl5oQExWxMP2shIjn5//Q0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.178.111]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M0R25-1hy9ql2vGP-00uaCt; Sat, 05
 Oct 2019 18:48:22 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191004200853.23353-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_alloc_cmdrsp_buf
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <7d8314a8-2f92-112b-fffd-83a47044a015@web.de>
Date:   Sat, 5 Oct 2019 18:48:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191004200853.23353-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:9EBG+gpJatT+eCDnMM/cq3BjNhAWwOZMk4egakQttSe0qGxW6P9
 HGLPe3bTNV6pS4/Mtij+nVvh0J3IHIMgLGKJlRW2SqktTnF1zUTXFuAhoRbqwpXEkj7btVp
 vdU19Q/Bt+glAvbF2C5Sq8xGk16SgkqKs4qTh21FLn07of7Usrus1BO23mL1SC6ntGdMAd0
 eC8ygAJKUY7+LrdDPYMZw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sm+gVJWBLVI=:pZ6rwBb5cmfNSeF9XAhINx
 k8cEAgZRqmdyT4rZSanttNSllzIw1yUsreIAiOaqOHf/A4Uj5j2XqhewnW0zZI6S9IQ4zb0VC
 BvHk3PfgYmVOMYdUhuuhByXk3Lqp+SK1/u7S7t4r296pyqZo+bLnuALZiWQj4KRLFXDnxOYWV
 JHdSs1jxnRrEqDYdMHDoiAffBiG9oBLTYUC8QSQ+0R4OPSaADTlDt3RcWpMawQ1eTGOTYuM4v
 HrDkId7QOZ3w71sndBGrHJ2kw2yyx8yq0hkrOaFuOt0WhP5nb3Df1IYb4BLgIdSukwtVmBWAR
 XLEcAi/4GqNM+OedAog9q9apsn25UU4ibBLjiZG55aMDcYfgIwQ8hnPbFE4lXFRpmK+O47tKp
 BVN1+vICyWqRzxsoOu6+zEzDE9u7DquApd2hvKFDTBIptjb28jcBogd3ClhvKwxwTylvmF3/J
 dEoNg+w+LEmjS295ir/3Ht+iBTrOV7kBSx4VvGQUw+Cgl+0lopAFNj4o2phKNzdjEzCDwk+Ub
 r2JhjGa9bhm58vx386tuUSH5nnmJYkm3azWkxrARkWtrW4dfwWdDWa6/Cj3PJQKAIck3rkvGO
 Ek6TjzGNqM2J3enXERQuibV3ceWKQZIHaoVzNsbt37ogs7yK3bmjOeBCAsfzDKkb6wQAEvdcf
 95zvabmp47NbeQoctBXVh2uuRIw46mIFnDtj0of6ZJghkMB+rKiDd8Gu0bA7SdxqsZTqbvTzY
 bOT5nk3SpLyui5uRgkw3HAZAy4NFHL0Wfj0TQB07b96luMWX0hvE4JxZ9Dv487OoUGocnr1Xg
 QZYnUxHIPx5buzCqhtfnMswxuVIlH5/IZZQf21PpZsobIjjmnfA2gRKrW46txmlN7xJASsTho
 uxEUSZpHyCqV7pHh7Mtl1FB4V3qBmEr7ASV9R4OytrWQ7bnXULWVVVjKVsubpFcMfvkYK+VSg
 ZnWR86nytDE/M4WbTWaIiB2Ju0bBByNQY6Xm/iMBxrGOqC2Bb2418Fq8FoGpl7ZTo3K0rC5tc
 YfffoBNwmIMQ0EjLie1J4FmBGchAEPLREAwbD4rTryEFMMtOfa/jZUg2HVuCk8jLuoDttYUeT
 f+3x7GtdGO1GtHyckQ3TDlQX0sptLwhZGjg6dXv/TzB0HE+0fJ+DHn3vboN0v5/Zoi0OXBdmU
 mgkXF+aNcFpYMUVwlcnH21PYayg+SAPqv1Ro4w3LMBeqTcU5KI1B8oU0YvxOxNi32CtTViM1y
 2y5fHHKQeEqUST7myMO16tJ2sk4ndYPqwP5n0dVhpG2t1nh7rpPYU6B1vQ4U=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In mwifiex_pcie_alloc_cmdrsp_buf, a new skb is allocated which should be
> released if mwifiex_map_pci_memory() fails. The release is added.

Please improve this change description.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=4ea655343ce4180fe9b2c7ec8cb8ef9884a47901#n151

Regards,
Markus

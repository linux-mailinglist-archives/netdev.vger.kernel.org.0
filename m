Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A621E0F95
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 15:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403838AbgEYNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 09:35:11 -0400
Received: from mout.web.de ([212.227.15.4]:58533 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390792AbgEYNfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 09:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1590413691;
        bh=/UPC0lBIcfgs1AAvbAxZv7NEpVLaxM41zDdg21xlFPw=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=ScwtO9AS5zw1mwk7ZXd+1bcjxOzpinVY1R+nc0YOB2oT+WMaFsPUfq3EZxog89Yhl
         6LWrq/EywIN3QYyrtLcwXZGBiANLQe8+cNt5TkPKytdp1FnvR7/3x6yx8awxTAuc7e
         7OwYZXb3yB/avyfixbNvzghp7uypyJDwbOi/vvwg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.186.124]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MNg5K-1jesCn0vXu-007AXa; Mon, 25
 May 2020 15:34:51 +0200
Cc:     GR-Linux-NIC-Dev@marvell.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>,
        Manish Chopra <manishc@marvell.com>, shshaikh@marvell.com
Subject: Re: [PATCH] qlcnic: Complete exception handling in
 qlcnic_83xx_interrupt_test()
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Qiushi Wu <wu000273@umn.edu>
Message-ID: <bcc1585d-b32a-8f62-f061-46bfbb212961@web.de>
Date:   Mon, 25 May 2020 15:34:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EqeeVHur9zQuf4ZBxpowEPYtOBxtjbcL/pro21Tir0T/Kv50Sp0
 jiHERdMKSAj65HXqKaQLnIiD1sYghmVATI3srrUwLZVnmrxs3+CE9dkf6ekJl1MNZg0/kx3
 ORY8UXdvEziYg7GyxnlGEorzVn8P3MtUdJX7CfIT/HWo2YSNtEYY2UZHdNdbRyKCiJGDLpE
 fQnJPhgm4BrkVUsrNqUbA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rxeo3oQypAs=:Kvq+Bx4grFg0yG48hxJ2ZN
 BqhRmd4/oCw3ACiVUy58hEMXf2LoTZPdw5MPv9QL8RfxRDRomc0t1YTWgSQ/yqSC1XP/Nqng+
 GSEowdxyFLlXzp6QKQ1P1qdvpk0pidket+AJ/Vh5uoH78Tp1kLBc+9hKZd4JtDAJ//058JOQb
 5F0DZ6fKijMiitY7b8QSE3AlgI4+enzgQHx3rUOaPpZ2WfqXhbqgOgqhgrqVthFUQlzPwmNxZ
 jj9J9+2PDazAXOD2fw/90+AnEqFLCGgCbKNBeslGe+cIoUtXg4J6MO0lS/dRPJsa1ZWDMbEla
 /oIr7O1+Sy7edT34njahkv41iegkqc20J6yI4+Cqvr9GpSRD+JZDC2iatwB2/klypJdKG9lWn
 39fEBjUseuP+A8ohqWEn4N8tL/u+kaCvA4KkvO1wExJuLzFxB80l/NrLN7A4kSmy6ju96VIgy
 TO9x3SLCIdldhFQ9RBjRb3fzKVuHDG4ldJ9qg1xXmbQunJyZ1hfCgsth9k1kIrPz0Cee3ndNv
 EpdAl6ppG2k5nhKsE4/mRbes33NJgvMw16jHoLnL9q3wYvbmle9nc+B0fBlukVLJxS1qiyBS2
 A7WcFW2BFnhVmLoMmbic+y+sk/RUEdiOvTl9vb43IV9RBcYK1cIHlLsl645rQK0iGSmtULSfo
 E7crGoCZwsIlR9NfcAtTtOqS/w6kBTMjsYS+mB/Pqlx/pdz5OaU3Yi7Ugb/9dWMaP8nyMpIrH
 gkxz7QAuJa+58l2CcooZC0rc5Mb/dxbHCK/Lmk2KV7RUrebY+52LNUA4eLkULWfTN1na57afR
 dfdg1wsxS7a/GH0RmBhrvCE1L6K5PNRLFBT9gmZVwQ7iaJtIXAFMeTvgnEfGa2vrhw7vqOGxB
 J1aQkuH/75RWXDVllwa+v0dojreCEF29Xw6kLbOAhnIX+hWvp1hcm59EU1kSYoiMncCXYQgnv
 pBNFhJTfPTt65M4JeS25n264MdnGvkQQz8Jp8v7NbgrcKFYcjfuiO3yYf6EfwmZM1MNrIwfeP
 WMX2o9jYusTXfGrdHW/wY7nSOt8mpqDKXNp13NtNjGczS9yGeF3pzpFSiz3JsLhbalSQriwHC
 e+vySyp5KlOsEPxOo6PtaRuUk6DIjVS9+dY2pRi7nbuVxy9P+nNczlINiiyyzXWaBR8CyZFpF
 FqEXDvWXkJ2ZajqF/lWAE5pqSixLY1cKYUCCU3YpQrlZRJdvzzRnwNtij4QDt+v/SNH5azTNI
 VGJwclwJCW+4Kl0d4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6, function qlcnic_83xx_diag_alloc_res() is not handled by
> function qlcnic_83xx_diag_free_res() after a call of =E2=80=A6

I have got understanding difficulties for this wording.


> Fix this issue by adding a jump target "fail_mbx_args",
> and jump to this new target when qlcnic_alloc_mbx_args() failed.

Would a wording variant like the following be more succinct?

  Thus add the jump target =E2=80=9Cfail_mbx_args=E2=80=9D to complete the=
 exception handling.


Regards,
Markus

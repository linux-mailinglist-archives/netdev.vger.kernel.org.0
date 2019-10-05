Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7364CCB8A
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 19:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbfJERAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 13:00:43 -0400
Received: from mout.web.de ([212.227.15.14]:58213 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729348AbfJERAm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 13:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1570294825;
        bh=hO8pVDCnGnN+L44oZmDwg+octkPnrarHqchufRH28SQ=;
        h=X-UI-Sender-Class:Cc:References:Subject:To:From:Date:In-Reply-To;
        b=X2KcB4+MVH4AtiY7iOpMSjByVqhFJ3CnTmXckLca72B/dmRBtqXQTNpaeiPcMhaDF
         KWdrATD7nhVBX2psgp2O5X2wyl7aIC4YxTr2ZrV282rvXY1IMwgPAHLKhrj4BwaHbP
         6lJNY71DsWj2wPsjwTBkDaWjUVqoBefGDy8NViCM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.178.111]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0Lfipe-1hkFwg3pvu-00pJT3; Sat, 05
 Oct 2019 19:00:25 +0200
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20191004201649.25087-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH] mwifiex: pcie: Fix memory leak in
 mwifiex_pcie_init_evt_ring
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <0bbe35aa-dddb-a3b6-bdeb-c54322f3efc3@web.de>
Date:   Sat, 5 Oct 2019 19:00:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191004201649.25087-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:zcvLwnmtfhCHYyJgU/tiFy4rDDM2wKToyRQpP+liiq6gccwceuP
 FIeB9+Abhr+8ITpm8v132Rl3IKOkebyWkHlhWxIoDjncO/RxtEyuE1LGftLHIpMfHy9CtuS
 IZwGj0ZWePtcM+BrlTcZoFZpG6ldxY02ZXJAwwTDMGtpYV15TwwBvAG01ApvPDYBkFvhayv
 4CDde+vYBtkwf7JZhspVQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q+luW6sB9F0=:tC/mi3mzRZxTXeMa7ylv4u
 +1VyAR44Qt/T+DhSw6NdmHuQ2Nv6HjuFeSHCMi8FywWAshHflRP1J6t+cVTvbGPlaIsBgBcpe
 hKMQUfzwn8SLaFhFPhkKbg4/p3V98Wh/v0glWgNzFCNeliku3t7BoRJ1THpdPe4IZ2Q7HbhEK
 30pnDs/Pz+4Ej2kbEfXAHkVvKIfdm2RGj03LbUOcvlw0VML6ntOY0XhsqGs681MUlW11ErDC9
 3EAzn9nj7tdpCWDQjfPGUK2u/3iLUq81uBwV08n3Y8i3vDz8P6cSnelCLpkFBhWhrNjFCI6AJ
 DYT3u1OULnaatzaOjEgT7+LW1TJglYHhjkY8AhuiThUY+AbL4DtfqhEh1qV5Q74JEGnWJK0t8
 Xkfe6IWB41kjt1BGI5ibVkM3D4Zo03FdHX0bQTjFhLBAkzHYSbRAsi0UpetStZDqeAgseL9fV
 IQKGNfFAt9Eq8jtwN3O7+izEsdUFgFin9yNn/nAOEpgvd/KZnZJaELBn84cHzWFERlGvSg6K0
 JNdjGVr+Lgo4HQps4msDazO7QbsXXJGd1CSkbezjpw7HPjboUhFT5gCQeGlfaa5UqTO8Ys6lt
 2tcQ851mJo8uLUFF8C6oP2pmL+KyxMa1M3cFl3v5/HR3eGzZMmWQ76WVbNAZ8LE3cFFRcPgGv
 xpNb06FwmMxjagadJDy2PJ3B7PnHeWoBM77/sXVo8eVSRyY6Wdqs022ptOAsZaQpSAz0bPVEQ
 ShjvceydWUTk3lmsNVXDEXKpCqqW5XDXwvvqLdqWr2ruhOjjI16quh11pOShhirsvlCpTS8Zc
 xJwK7p5xawn6bSrgOCZFJj/qbfhFmtIyLK57kD9tL0xJK7DJCWrJjSEgH89HhBGCD2SskuByM
 QADyv5LJBldcWD3pPmVCMGhER+vMB88Y7iUZXD5o10V937n3Rx5eF9clt3uf2ub4pFza7tIp5
 Z7Gl8eglY+jNsSm/3sC7Q9xePTKRakYUVR6orQ0fwTsukYE9SLoxQKr+JuIECd6eUuyiPkrEn
 MbuKx6aBi+PX7hiT/C13tI0QzM1PiCieM7v3sux5ujB1lPe4SpcGo87DJAFPcILkKSoFZJakL
 xlG6LoGnlzapbnhN6Y7MgAglA6FG5SvX5PRLK8bV0mCI5rjXfSVJqpLDybNcXM1O77R38MSzF
 lvJMmrECUyXe4G2e4vwLeyhl4mIoQ+cuO4Cm5JfHbqzzyRtvzX3oDlxFlzhFvVfVHpde8NVbe
 9Pz6XOU+OdA/BEFugJnHtr02iz8h8KhK240Bc1d41n/n81H8i5BJHob6biMQ=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In mwifiex_pcie_init_evt_ring, a new skb is allocated which should be
> released if mwifiex_map_pci_memory() fails. The release for skb and
> card->evtbd_ring_vbase is added.

Please improve also this change description.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=4ea655343ce4180fe9b2c7ec8cb8ef9884a47901#n151

Regards,
Markus

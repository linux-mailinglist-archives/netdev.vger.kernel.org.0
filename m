Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55AE405909
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243429AbhIIOaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:30:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:49729 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343552AbhIIOaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 10:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631197743;
        bh=SrzovyttAcKVSAtr6u9eRl2MdXd1NuR4UoArSDLLiKQ=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=J17L7qNjeek5mC3sR8ASfIMZ6BAt1lJzG1HzFMdkTfsxXhnXKJZ39qXqhyhzYe3WR
         8ebXve9Z5pryBHo/+U+AuWZ0DlZXMBHMq829/gG9UyTgxwLgS1j9VSO0AU0wwpAxyT
         Ms+JbNMqS1mAST+Ikk1+A/eRex90QbN87IIIP/eI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.51] ([46.223.119.124]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M2O2Q-1mMgLo434g-003vHN; Thu, 09
 Sep 2021 16:29:03 +0200
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
Message-ID: <781fe00f-046f-28e2-0e23-ea34c1432fd5@gmx.de>
Date:   Thu, 9 Sep 2021 16:29:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZIBNnfoGWY6mMPacP9U/QFdOPQ2ocSG3p43fN+MpQWVthy4sTYj
 Hxw53BJXQBfgMSnbXC7OQSCerW8tcC5YtAryfF8mWylfF7rMP+Jc29NoWjP79BBCnVndbeY
 OxgLNsBZlYEIj2SXYVMC/mC22/ZNIs0g8Eq0tIkSfeBniBJSLbX85kBn/KZsiB4mTMD5PQQ
 Lf0EHoPlwpwjoUiIR0WGA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:But/oxILJJE=:RemG3C2oL84Ni6Jt/sAgJs
 g5DPkW19rjxT25H6Gs89+hR77GY0D4NPXtS1N9gxTOsKMUOeUxy2KKQQBgjQ2a8vra+hte9O1
 BPhRi2b4dguMEiNtZqBX0UyC8TV6SlivfVD/sCj7YtW9kdoCxiq2tSXKyw5xNcnhD9h+DHxrs
 btG9/Tm/z4K2hMNvrMaGzlZ9gH2C9KSqkzRq8bUdjE1PvcESOMXvjNZxanf6ThDDfbtgpvQxE
 fWoCTBL6fOR22r+6NJjIieKaCe/PvJe1/y5wlQfiCAnrl7hgd7+eqKsdU2GaTf+lYtqnuusFa
 bPVngmElF5ajvs2+e/Rq7MrjS4xlN1x+bQkCrSRyaSWXZkDo/8fuK8uMqmi3ORyqhg/0Rml+D
 FCAXtHtIBVQFgrU1yR1IQVziA5eO4wmqPfYWv4VcX65LyS+sgJB/s1vhRm+fQOyJGS0wMoQV/
 hMh/lBs4wewV5ZPr+2HfiO7yNwSwU1s7V/CurGLTOzwCggRdWh+e2XEq0f5w291EwtFOl7qox
 jD+CctG9FHTLAVpXwptb5XceaE4OKzaRUyKgswJuVlei13OlkoKgJ79MCeWLIWl38O0hr+gE8
 bE+F3ujdiAzm1znN158dyWFwhhbj1g05mKybDG+FXLaL2QDMAJsoAPPHzAnwJJtWfcQa7duPC
 NOziqf7GPab4yV3bpDIcgmjkNuhiygxQeO3ob+XaGKiqz/yDDtKQzjBJG90/rthUouv20VblQ
 ejZYnq52z9KiACjBVF5tNckjnhfSqTN58drDpL9balNterf08VG7vWyMvO8LYtiepnK5BFL08
 Ebm+s9t92DdIKFm8CIWK8lFY3nDeXt9ZHDU2TwKzG1E4oVosIzqUFUqzFxw4K/Z35HZSkjqN4
 V5qTPyP7yHDuHZ06e9TyPK4w+pqGc4uYrtF4sn0VOGdy0FxhAMfDTXerWyMUIBP91mmt7HnVU
 P5rlbTTKl7F9GEJAAWRPXN5TBURSwayisuUFnJjBviwMAbXOx3sJ7cmf4/b/xZOUG2kpBEmos
 NqyKF7FcPd8gYVKfZikNqfaI78hOyZmr/O/NPWgjj+xc7o74K7K8Rq6cMp1RwlTRihrEKT5hc
 haeydXTKn4oWy0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.09.21 at 15:19, Lino Sanfilippo wrote:

>>
>
> The kernel I use is the Raspberry Pi 5.10 kernel. The commit number in t=
his kernel is d0b97c8cd63e37e6d4dc9fefd6381b09f6c31a67
>

This is not correct. The kernel I use right now is based on Gregs stable l=
inux-5.10.y.
The commit number is correct here. Sorry for the confusion.

Regards,
Lino

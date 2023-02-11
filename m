Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2FF6932F2
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 19:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBKSFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 13:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKSFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 13:05:03 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEBA10410;
        Sat, 11 Feb 2023 10:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1676138658;
        bh=28OqwzMczbBnmFl55pTjZ3gvNBAL8TvorcFiXJ75KCQ=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=ECSK4yWdNoemE+cCBAgLfXD60BepoIdTEIFpe7nuuW8CtzxtBaOFe2/G6VCkOzUgY
         pQF/NVFD1uWNZH0lEwK8Khw7taSlymBhiem3JWTGFTtWMuDB2OdxT7LeM80D7vNoI1
         GPLNCWAtbPWCjwaKEDfM0mjdJmrIZS9jZDpLFB20r1wBilY1w56APFa2zYsKLvZIFe
         uhi0kFft9AwfschT8d/eMdmwZN10pDuLfTpIzOHZ7P5PSF4NPjG5ae6Sul8aaYkvyn
         D9A5Rn/gfj/rWdYru9fYM5xNEYW+ylPPMt9oLXy267LW2IYfyOcyGncemhctXHbIdZ
         I48BI9lK4IXIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([217.61.152.186]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6sit-1oVnIr0UEZ-018NDE; Sat, 11
 Feb 2023 19:04:18 +0100
Date:   Sat, 11 Feb 2023 19:04:14 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net=5D_net=3A_dsa=3A_mt7530=3A_don=27t_chang?= =?US-ASCII?Q?e_PVC=5FEG=5FTAG_when_CPU_port_becomes_VLAN-aware?=
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
References: <20230205140713.1609281-1-vladimir.oltean@nxp.com>
Message-ID: <1C64196D-371F-41AC-B357-41100DC66C2D@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SNjFAbPRNFfoTNnvYGgdmYJcqUiHRQ3qrLy965bMJv1604ANcU3
 r4yh85tvfLGSiRU5wSWoU0QgHBY53nbMyxuICdSjBKzGdrJu384A+BmTHZwXnpN778ZNrDq
 67G5w2ED4WrVqIldQDanuuNt+5RiTnxomcs6ztl9g+fevVKGlMGzA7EfLMHMUpWf2F9Drnc
 RiM4CRDD6fiqso/up2Afg==
UI-OutboundReport: notjunk:1;M01:P0:AntX5itq5M4=;VF74289oWQIAN+nPAdD/r83w895
 d6eMssTXJyYIU+/Pg6tNFXYiEz+svlikUjPuqQ8DOzZXTUYWOswrd5xfQDiTq536xWHi95D1V
 utlo2Isi7zagQpgmYb0Y5Qny7C2MECpOIKNiTj6O9drWN42tACQBntyuT8jmUuR69BMeZNWIt
 W0dWiRL0pzsxrsBkkyE9zRJG7Lq4pQlkAN+Zu6wzT2w8Fk5OEFJqdc3N/cDq6iDvswaz+0NQC
 QprKMc0Gb7BJcS7HT9l9ZdD0kIB8Meye8dG4ah/Ml514t5O/XBx9kZ6NAiEUPJm0T5r7zRSJz
 CusVA+gaD0SdwOLW4hpTiRe36DKXlH9ZB9jjlkb/nU+SOuG85Uw5TVC3DkIuSmbb8T2JZNud1
 0hXEbE7v+GxyY+5A02Brz8w4hfQLmH4rPMNs24NuGHc3IacYxxImJRxj8Prtmu39VChsGJQ2Y
 wbjQcdelzfozLwFg2pNLsC1bHm/Jc2XGYJ0nA3/v/MeKEtc3Tb8edAuiH+8wFAJwO6cItUiqZ
 8pdwucMII6BOrXKq/eOas5PlAE3OGW7Yc3KwDt3MAAfMIH0eWi6VOVxX/tNiW/Ap790Xxrgob
 0iWBzkey03kW8xZ9Ej9XsXtrEjz+fZM+d/WUtLvZRSHX4S7+X88lNLUTXsG3cI1rdq6moI5d0
 /qqI5hq/s2rpMegefh+lQjB52I0MRWj0t5K5AZRjoh+YxgFVMNLkNn85zU4tMVFtjTYxyw8rR
 1KSeoQAxSFGQ1ZE0HL4P+wqXnXL8GesoFrORSs3le8zFBCC0NCMGFbUforMvXncUGgvKuWU94
 kHTLO8KnAju9IywSqjPvq5OzMJ7lNUybOlSgzOlgSO4A7xMk/VwKL22XlgfUei4xSq+QA8Fji
 M7AIcF/iuDpkLGHPwYb3q3JtNHsLDMrGB9nal0ebiUBcvHcCmvRxNWbNwjwLHW+iBMn5Nt8Uw
 i0qSMg==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Can this be applied to next too?

It looks like discussion about different issues in mt7530 driver prevents =
it picking it up=2E
regards Frank

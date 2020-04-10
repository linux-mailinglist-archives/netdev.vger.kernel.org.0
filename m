Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40111A4467
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDJJSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:18:55 -0400
Received: from mout.web.de ([212.227.17.12]:36323 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgDJJSy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 05:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1586510308;
        bh=mCn1z1tGuIYnnTUaBNCZypa4loeBfczH5QVw4v7DK5M=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=fViTLyj3ZzMD6lBqDWjVEav+aXivFAAyUqZSY2ISyS/UztzMHWEZXt+MvGbROm4IO
         1d2C99pNwVvkoyFm51MulNW8npm5OD4wpKsc7zMsj+uzfDiyDG7L9+whADIa1HyeyF
         YNqTJfPljFL8KO3BhsHdXncgB5jCnD9OXj1oSMNE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([78.48.110.107]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LnjBT-1inTj90qz9-00hufr; Fri, 10
 Apr 2020 11:18:28 +0200
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        syzbot+fc0674cde00b66844470@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: crypto: api - Fix use-after-free and race in crypto_spawn_alg
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <44b4aa3d-0d3b-c10a-7d79-5fcc4d76fe98@web.de>
Date:   Fri, 10 Apr 2020 11:18:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:2REz4BHESTVvuSupufjwzHPBmsCBUbSKLECT19qSRP/khNd14yF
 LNe2n66I1X4iwphnL/kpphO/ZoCrsm8c0kPfXp/TDOT5uRsc0uGJj4rhvpnZhuMZwZC7VVp
 syXjntDjUAy+G6SO6XLItSSU3OWzerODr0gzOcGGx40Ve7wpgyIsT2EXyLQdDvNM09jc93w
 ZhBevrFoCFoCrxyPudyhQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:rousSTg+/90=:lKInXWtdJxC1th8/2YYWMl
 5G414cIVkQ+fXPbFEQp9Qm5Om9MdOHJ1PWZVrnx9t4aedc964g1ipO+xnr1K5br1Ww9wOqEdZ
 8wGrt6DFVcinJJXHfPTqXufZXztmAwFhfj/XxfdpyfCLdJNhAXgYfHKipjfxjPxYoNJCuBnb+
 xZrTUsy0XTFNO59eMDS0tNf6ppobDp5LWmsALKxkp8T1QisSAYVLaMvlXeLer6wbdSUYhVv19
 asmmY3IX8NSwiAc1Mb+LD2w/pSt8R5Cx9Z5Jslhr1+4KJ4voEy5PPXSDzMn1Fu4pJJDoYL0nk
 MqamrwpZeDu9uHa6XvENWrHDzJTkNLvuOomI64PWikv9chE+tTJmrbkEjBzhCRyVvb0HV27vU
 L2TUpynXb/qgp+lJE+Ej1cQ8UrsCEvGmSjHh//oJs2IAHSBbGEHQl5CjgaUvk6aWuaQ42BdRH
 8FtRqYxlSrAGdsLUU/rVPje/9xxYStZHxZAL5kGE3FyLFaVH+HJ2PnORCxjbPBwC6X11AsDyZ
 Kjf9ZigM2Fj6KQjzAMhVEkhNVmPVsA25G8A6YsA7RgaAuNByCAlo2BdnOaSjuFfy8ufC2Zv+a
 EjN/XEr5gRMqohwQ+27m8stqggKHnSL7wVDovE10sGcm9oggSKB9RnYQasAQGlNDRS4LFxFSE
 mniUx4SmcCXtMDAdXI4xOAsjP7Cmsqb9nm6qUf0DcAfLAlrraXI2yyr6rPH4XZVHVg96mnJq2
 VEWT+HBQoMZL1B3U0F7uApWkhWiRWmoTZYGZ3J0I1bdOEARrLsq+emr9vN1wjvPWv4o+VxvKv
 Z3yzb85XfJLNvAMjvDr4mSrbgVg9D8bjjbHsKLzN5nfvzEfCF6cv/UWMmZjSRjhgO4NkpziH/
 0vh7qSQndgwNMaMe11b5gecYzs467n/nLL+6ED3dbLBHPeDJVLsVGw3z0nWyvf2xeprvFBdr1
 64tTPFu9GzWA1ZGN8XNF/oe+F1+fucjsF8heS147DmYwl46rnD+XpBHF9yB5p5qgaciA1ba0F
 gZEpbqMmNgJx+u9qQz1xoJC9wqL82ZCQ735OAS+z6uHGvbIG7GHSlCkH0DHdI6BiHySBdpQOE
 18p6JTIF/PbAWJlTgMTlbTl1gJOvDE3lAuEPlnb/0++zwPKFBHmuB5FMhVVRPVW/5I4WqR/ab
 JaSX395xagJU99bTfFg9isRUpQ6MsF3V8OkM2q97TXpemU2E7Hj/3cE0pJjRRd7zzHZ0EpYA3
 UX1EsH97rEmgxmkBs
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Secondly the setting of the DYING flag is racy because we hold
> the read-lock instead of the write-lock.  We should instead call

Would an imperative wording be preferred for this change description?


> This patch fixes both problems.

Will another wording alternative become relevant?

Are the provided tags sufficient for such information?

Regards,
Markus

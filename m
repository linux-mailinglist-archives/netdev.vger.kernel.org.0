Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA40A830CE
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbfHFLi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:38:29 -0400
Received: from mout.web.de ([212.227.17.12]:37241 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729702AbfHFLi2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 07:38:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1565091493;
        bh=IhJyazBEBalDSeWuEedbjcdyVmUJaJqyuIjj/cCvAqI=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=Rkr6oON18AX3DVAyHwRwIlPdMXPY/KYbYROShhdfF0LdnEm90Ao8L1FhakAaH9zPH
         JJWeu9RV9rSdnrAiWEkOXcrHRf3zRFhol+oPeYkNgIMUUVUQ8jpJavCEYrpX8giS9h
         FcqXX8u3Vz+HgTD/ibbzq4nRH+WiAwAPooM4K7Is=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.135.79.190]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0M0hne-1iC5Cl1s46-00up8g; Tue, 06
 Aug 2019 13:38:13 +0200
To:     Mao Wenan <maowenan@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190806013701.71159-1-maowenan@huawei.com>
Subject: Re: [v4] net: can: Fix compiling warnings for two functions
From:   Markus Elfring <Markus.Elfring@web.de>
Openpgp: preference=signencrypt
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <d928a635-accd-2a8f-1829-5d7da551a8e8@web.de>
Date:   Tue, 6 Aug 2019 13:37:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806013701.71159-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:sKvtKEVdGSTCRF9jm8v5D8pSbBnlQr48FmMdUviHk7RhNDJzZk2
 26meHMzITfJsp48/R4BNUXgWE9fsQGYGVmqN3HNCnQJkoh4nF+Tnm7WyYNWL5F/NAuWz0P5
 LwMqAo88WWCThdvKjGpYRHFvmEXrBLrLGEVsUgizngPfaYFQbtvx8+OrieyuUTyl1t3gzI8
 EWpDqp402yj7AxlxE1KFg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1eOueph7O2Y=:v0mvnSh5HHPc/yroLM5hxW
 2/Qoj1sAL9bTPXHUdwIVj/pFSe4JfCUNitQMyiVbLiIZG6Gcw2+7uhC45e3ydef/FAyz74/ds
 ip01AZ6w9eV3wkuzCSiXnl+eAYozxDyCKvhHkvE5OZuxxo4leFYBhXDWyWFD3Unx1pXygB+aX
 VEIAHBojce2s0TyD66Nxa3i108MiEp08JFBy6ahgQST1Nltc6mVyy0C6VciD39BJJY2osIkBQ
 8mTad4XUapVCRnsv8KhYIWyrlW3VlEcihLJKoimXcVqk6dHM/WPAg6tWu1X1bqevYzonzKnWA
 hd3COiKys/VopxN/MSWBcXQUlUAF/92DBK3sdR+0sr50WA7XALMzjze4vDY6oBKid6VNLvFzw
 JnjSDPFcwDKEPTQNH+EfKqtgy1Iltta7uLIgKR2nkrYYcbl9F2Y72K/Y9JWKuCn3JDHQpc4GI
 XOnObqfIlycNxBcEGYsQxFlwnIDMCPgP7NVtx6rZe/pPp1OxUYwjUZUtHRbPGttQOrsZkWhlE
 uVAFRcQRJlfoTXDaSunrLtj1vLMGFMNdexc9IEbUtkGaRSVRAEDVzICIPzcF+J7sGuSNpiYAD
 rEAYP1Eqbcg0s0t2YGJUt/83RNiqJwWJKjJEg4pmeX+V6LI9ZJAG4KDUGuAUCUpeYuXV8iyTx
 tkzUORX5dSC00nQPQPfMRpqLHeM34tqQoR13UhWuGVmSoGZGlsvALc3M5RsnremkIRSd/2wor
 MGF8CruKJ1vFR6Yzluw+4Qm3//N4VShcsKJrKOrK3ejBB/SRNT2PNZSI+8P9No1HEWUBXd7vV
 sD+kJKVZZ5uKm90rkjAmHOhJfFWQYFQos4ehxQPkxAa8cFF8rfg1bcubd9wNKsI7rLQd5+iPy
 eSfkSPek9j/VsLXRdMY44+Qd+MDBh7EhMi0H8puAN0LKXBNAYkyC9Xm1myWz88qteZWzdU+We
 Cg86jyf5VmocRz7uiaRQ63F9X8etcayVrUIf7kkTcsPv8bopuYCthrOVDQjsSp78keE3dInqL
 JVrH22zfpH1Fy7uTqp8Fvd6/pZWrecbyXdc6ttBWGnwNAWGti0JoCEVoR5pmNHBa3KatOgcy+
 iWarWvfte3YfzZIIUV9dxpSrxL9mCYQRryomTReVlTG/E+IsmT53cOU3cbR6aVNR1CCnMv4j1
 NAtss=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  v2->v3: change subject of patch.

Will it be nicer to use the word =E2=80=9Ccompilation=E2=80=9D in your pat=
ch subject?


>  v3->v4: change the alignment of two functions.

I would refer to an adjusted indentation.

How do you think about to omit =E2=80=9Carrows=E2=80=9D in these version i=
dentifications?

Regards,
Markus

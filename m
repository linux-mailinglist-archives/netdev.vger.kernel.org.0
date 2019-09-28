Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904F2C0FE4
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 07:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfI1F4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 01:56:09 -0400
Received: from mout.web.de ([212.227.17.11]:54091 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfI1F4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 01:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569650151;
        bh=p/6ibRT7G4qcS2jOMN/JZwLHM4VspLJTbEteIUbc8rA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Y0ykmU7I8AqS34p9+g8A4nrRDfCZc/v5CsxF2f1PeAsYNRa6MnszUZ1YDA8vZ7UaN
         1224VL10c7S6EZFnxcwQmAsO+Db3Q5tDO0v7gU/1kquUHPX6xzSIPnNnAeI9+nKlwJ
         kLIjQnD9ShnaI3UQJCFKymxJO9nWCRR3ZU6KV2NY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.13.241]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LyDlZ-1i8bPG26KL-015cTI; Sat, 28
 Sep 2019 07:55:51 +0200
Subject: Re: nfp: abm: fix memory leak in nfp_abm_u32_knode_replace
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Pablo Neira <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190927015157.20070-1-navid.emamdoost@gmail.com>
 <1cde6417-5942-598b-3670-c0a7227ffe25@web.de>
 <20190927144242.7e0d8fde@cakuba.netronome.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6854393f-8222-3077-1ff8-8be6b07d4862@web.de>
Date:   Sat, 28 Sep 2019 07:55:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190927144242.7e0d8fde@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZzqFEtfTDlVAy7mvsxRgkTxrKin6N/T4mlk0zQn58mJvfB4mZIy
 e1aeGvsVIFTicXAWMe7Jqgw/qdKdc87Sapn+Jb/UM1TVlqA1AyRKCqo2kD64pMXgZwW1jsr
 lekWanRKTTZhGH9XrLxT1MAcX4sQzIrfCy4/z2FqwOiwpTd0lxy7tJRsnDetrPC1Wq0fw/O
 WDM2ZlYUtxfsKlQ/Q/nFQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:d1y5qIuWfMg=:tSlFseDZrFgtmhsqIheWBH
 Sb5q49YGKbXLPVOgLSL6f0/2iZ+k7LoMRGVB1oCmy5ghGMVley/FIb4UhLjyFzcNi5289MZ2+
 H3uJPHgLOl3Cb7yIi/WhfOib0RatUG8WZyIqny4H5kCBHQlmVSOIzPIlpKY+qKxSlB6uFMVML
 kIG/TbaAAX2ZSCRxZikE/R8TD/KjxlwLosrvaLkBkn9chts0KUsp/DLO+tnBSXgOI17kSGREi
 42OpJovkeJQ6kPYUPGYSz+Zhx/gTVuI4O5ib1h0ZCYUkoDe9TIktnTkF16Fw3Jmp2YOmSDaCp
 uzBJCe9VB6WBiBTX+LgUkikMid0jnPgq9D1J6f2BzJWMxCjFDUCKNc5IxY2mDiERUvopZLkWm
 4NW8UEA1p9dM6ATXTK8+m2GF+OPc5wc3qJ6KFGghE8oUywdKu7mpn/uTdLEA0R398t/9962Xc
 5+9XZH50U2zF5CMkGschHvIUIWRUNrQVJtO3qKFIHPGSN2tEh8YWOyBjm0QBB+mSz0t4nfLRh
 fFCDuNQWLbBba/bCyRS4L2ZRXE0VdtYCiJCP1B5dL3j7N1POLjHir9+4eg/YwUCfIW8uxNQF4
 kDeDiy4C9EpO5e601K1SSu/mkyBKbABzhB+Nz/eY+my6uFFyShM3IYKafO6MdGdMxCqNC2wzu
 QyJzVc+uZaQY4r2llkFVLNZaNjtCOs23LyncD2F7235YPgQWL5EJANNmqaEvPrLpPO5/T3chh
 eZ+Sgz91gNt+PXyySlcrQUZk2vYPl5cHmkxObOTJzXHBfFKsDnNFPheonYfA7DXtrAFxcvsRb
 +DNqJQq7PRX1om2+U4UPX1SZ4mnWC+b/J5fZMsmAw8AAWpdGrSdLj9OY5vNxy9OBBnyrJrcL6
 NAalkMwCcx9PGrkXvEEDkEXoZjnSQEk9FJMA1W7n/pcYGBe46/TJ9GMp15BoKjb4NzNb+oc6q
 HQreC56+TCp3OFAbQV4z0o9qqfQMC8tq36GinKar8wq0m9iLqHcBS+FhjpG8onxyHzh2dn3DU
 5zUPn2kSAh45TWHCoHnW3yHPIuv7FTb75O0xfLJEAowzky2SeOt3k85ZNK/0mKrx8oLco9crk
 Qh8CtaCi/AQ4qrrLZhXRSt/fxmUtgqxRadLAQfsj+l7XksJYxYQOTzeMcDtqI1LmVzcsuTLNH
 Uj6waUOfGkQlKEgE8+RdTaCXEcuEkz2k5XyWW6JamaBYrqt//BiHE8JEfXaoEte9n73t7yRX2
 nyeGdM5ddVncFh5nUOe7Z2VRpIINa7EKI7kSm/YHxZKxBS91rc6qZjTSFnp0=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Can such a change variant be a bit nicer?
>
> Definitely not.
>
> Looks good as is, thanks Navid!

I find it interesting how the software development opinions are different
also in this use case for the implementation of correct and efficient
exception handling.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?id=3Df1f2f614d535564992f32e720739cb53=
cf03489f#n450

Regards,
Markus

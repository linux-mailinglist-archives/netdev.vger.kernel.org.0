Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B08125982E
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731905AbgIAQXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:23:25 -0400
Received: from mout.gmx.net ([212.227.15.19]:50421 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbgIAQXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 12:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598977327;
        bh=VcT1PIqQZcXCFi4aQmXr+rx2ZuYJ73wnhTYMW8H7+PU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=fFtlmKxv2Y+p2huMqlURIGwCnY+YHR3OxCrqTmR7/c09gtEsmBQajpEBeWdzANXQU
         nOtwsOvykJoSrphCQY3l60MBSUuF98AeyYjUWc4soGvag+zKXapN25SAOhCuREYuas
         If9yS7veEqLQYXu1KBoCsQbtBSPXTizjivA2Vmz0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.187.2]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MK3W0-1jrdNg3lmA-00LUav; Tue, 01
 Sep 2020 18:22:07 +0200
Subject: Re: [PATCH 07/28] 53c700: improve non-coherent DMA handling
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, alsa-devel@alsa-project.org
References: <20200819065555.1802761-1-hch@lst.de>
 <20200819065555.1802761-8-hch@lst.de>
 <1598971960.4238.5.camel@HansenPartnership.com>
 <20200901150554.GN14765@casper.infradead.org>
 <1598973776.4238.11.camel@HansenPartnership.com>
From:   Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <3369218e-eea4-14e9-15f1-870269e4649d@gmx.de>
Date:   Tue, 1 Sep 2020 18:21:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1598973776.4238.11.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZB4M5bHJm2lT0eoLHk37MoNKcSKNbWnO0I+HozfOxJD3VBajWa/
 2YmeAFUi9NWtJ+BwUk/HUg0wTP7BOmNOnQ/gn+knEGQKbwqDbO3XJTfcv99kwA2MdYWpTg/
 OELXP8GWQ4gUfymXUhK/7WblA+uNciI9f2zTsxEcsgOFoyBI0fFfIrl3FCp9IVjo9r0WPlF
 dWbroS2KiZXHO835wd86Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:M4PZy0wxx2o=:CpsZCDcX0hTdkQnvx3IlKn
 GAUEQQNQ7kNtc917PGYWcbYooCkewvBFUfOy/DpMNfcN1K/TM2fQAhdlJz7pYCkHO94Fhq0gN
 ZgVHlpHuuqpj8B5dFc4RwNGyns9gvuyn6faJpEloMlGsraJXmxZCyEnWCI5zHgavwNmb9mrnM
 y2nWJN2L462idmrD18bFjqWCzYo3Mg/qjoCLQKn1pmFcctArxevyCDPcvyZdmsC6TJ7euxSyv
 ykFbq7WOOa2ZPdD0c+OBjlGQjFs18FuwEQ+oB7yw3KHbifQZqL94RPmG9LUHK60WQ5Cm+v1su
 AUonzRplXMtNsj0tbKoZ3XaL0Ji6dXXTAMwd4GNQzTo8sm5fUmEpNrGOT90Rei1b2axNj4mpv
 WzoTUIC74wYe2spAtIwvNMszcn8GfQCIL41q9UP7Ae1V7PioT1UQF7F1IZ7sxz63/dMqkKq77
 OVuCGhdZcTR6olpfCKP53X1ycW6molAI9F/mL4o1AIpYYYsr3Fi/ZHqtCBPTexmg9kedSbJKw
 Rphuwf8SoVT6qY+BsTFgOWeEj8Q6Uot5TFJ92NHahXyqcP5YFytIa8q0WB0jkCrAW88Dj7hMI
 9V7zr8sJfQEIA8jnpy+xYazCGSBiyboARJyXc1q/7azwarcFqQfND0eshCJoT/9XOhEKBk4Fn
 2Sj8bAW4K964PSpgSQAwjPQwknsqdtqA2QH9RfbiKdsXjWIYIALSzWJKl2yIv/VUU4KA298xq
 HNBYBnkFRxBsU2ILxR8zNOz36tvXvcLPHSg5DRRP7B+3C0dy81S346dnAoAVmK0DjPCXOpp67
 Lm2w80/SRje5NzG1jnygwmyNxiyaQ3kfttEXfCtwoGpgVifyhvaY80skP2iz1KLDBGS6HKB18
 BOCOBRn/deUeVee+0rc/42aFMsNRvtruHMinehuGBfqk2ou1BkKCptlWOck2S0RSxe47/AI5Y
 wnkVTwtC+iNIlU0W82GouYyLkqh55gUsh2gJvnmTvSvGwk7ArUABCJCOOnxDU5WuX3Si22AL1
 O6N/9k9J4HrnnTwOaecHKSa8k1wQdPBkKviAg1ct9KW47XyZYBDP42txCUV7IZzT6JP5J67tN
 fBdJsKU/eqipSYf4M1IfwBiE8o/h/Pcu4RKFAyIWtX7C8sFVGVyAkyY+klHrPFf+PnMGclPI7
 TDcPzNnXJQWLXNXIXHJso8DdEEU5NjEbmgcWh0RN7oBxOANTZWQ4aXOfNt5dhZsXHjR7bzg7E
 twgqH/LFHU56Rgmij
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.09.20 17:22, James Bottomley wrote:
> On Tue, 2020-09-01 at 16:05 +0100, Matthew Wilcox wrote:
>> On Tue, Sep 01, 2020 at 07:52:40AM -0700, James Bottomley wrote:
>>> I think this looks mostly OK, except for one misnamed parameter
>>> below. Unfortunately, the last non-coherent parisc was the 700
>>> series and I no longer own a box, so I can't test that part of it
>>> (I can fire up the C360 to test it on a coherent arch).
>>
>> I have a 715/50 that probably hasn't been powered on in 15 years if
>> you need something that old to test on (I believe the 725/100 uses
>> the 7100LC and so is coherent).  I'll need to set up a cross-compiler
>> ...
>
> I'm not going to say no to actual testing, but it's going to be a world
> of pain getting something so old going.  I do have a box of older
> systems I keep for architectural testing that I need to rummage around
> in ... I just have a vague memory that my 715 actually caught fire a
> decade ago and had to be disposed of.

I still have a zoo of machines running for such testing, including a
715/64 and two 730.
I'm going to test this git tree on the 715/64:
git://git.infradead.org/users/hch/misc.git dma_alloc_pages

Helge

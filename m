Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C9D40CE0A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 22:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhIOUct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 16:32:49 -0400
Received: from mout.gmx.net ([212.227.15.19]:38563 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232168AbhIOUco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 16:32:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631737840;
        bh=FT1bt5R/FOH6npv9XqUhIBjmnDojF0uwYc99SARbO9E=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=OuQsLKfmqSknDnjRmvpvF5gZFfr0LxiH64Sy2NNNbnXhiVtCWs2THcnQrkZ2gJfa0
         FarOSuApUNS2SMtGZvzkKU/bBX+QOgxALG+Cyvz4Kynaff3TI7IoXsTtP37rpElwBa
         wXl23EPHtoDcxUmKP/aZt692RXg3O2x7+PAF6JR0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.186.236]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MkHMZ-1nBFtp1KtF-00kkA3; Wed, 15
 Sep 2021 22:30:40 +0200
Subject: Re: [PATCH v2 0/4] Introduce and use absolute_pointer macro
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-parisc@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Sparse Mailing-list <linux-sparse@vger.kernel.org>
References: <20210915035227.630204-1-linux@roeck-us.net>
 <CAHk-=wjXr+NnNPTorhaW81eAbdF90foVo-5pQqRmXZi-ZGaX6Q@mail.gmail.com>
 <47fcc9cc-7d2e-bc79-122b-8eccfe00d8f3@roeck-us.net>
 <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
From:   Helge Deller <deller@gmx.de>
Message-ID: <3d30d1e0-f60a-3f48-65d9-f53b76640a9d@gmx.de>
Date:   Wed, 15 Sep 2021 22:30:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgdEHPm6vGcJ_Zr-Q_p=Muv1Oby5H2+6QyPGxiZ7_Wv+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:kzjIuZ4FF57XuRnrtWz/7WvoEwJGS3VQsRTh7uoXah9oP27a9Fm
 +YEHuPwy6Q8UkKWzaw8n+fHjilOKjuMGVzh4kcgGQ3ZXoEvrQSDcUCHcZlKbAuj+97BKCnz
 DMxjrDA3ED7ThzeTC5DMK8tr+FjLHJVOL7l4beGLMCe414C3l/oEFp7UWf9hmFi3XHsD58h
 Y8B6Naso2YHgadVrGC2NA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:HePgIiYQe0Q=:TYFKNrzKcQpBG3fJTKvXHg
 S8l+Bfp0balC1rVZw07SbFMvRvFxnjKMJeyibWXfgfobr/EovYMy3POv44RA8KAn1ycriemwf
 zXP1NbLDmtaR2+7DIMLQEn+3/WzmX4veYBcVDFQcKEvfMxFqqM/kRP4NsPJLDdzlzKHyWPHKe
 b3MQ0iHP9P0g8zncl6akQre9ciKQAj+9S+sOJx077jKMF2/wtvE7HIDINn2I4hfwkW5Ffw0up
 ZMAnrF3CaHQCb6+nbuJ4JLTLKaCJ8AvBAFBZ5osBm+vXaQpW8t1IEEf1IqOI01xGiHNoI6VMc
 8DXBcb091bFpHUJtw8F0VEQKyeJ8HDkVZQDaOk2wb6rQ9BC/xtx4tBaXPX5xbHhOrJi6flmEI
 hNUvUCH/+GpfR6QgfC7sk0RC3X0QsPC/phrGUHYP+fifnLpIIZk58L7q+GoSC9c0uCusTyil4
 +19lNweVA0eZZUTtHJSY2U+dJkoeHBMNzCq5mQn1JFQ9S/9ZqpgicO4Mayo3/+pSY8rRpTzpP
 GDcIIstKjwfIGMnyV1XTFbFqOzSKgfnniK17U1eJPooqwDpRKPS2c8Hpj8KZbirNfxMcWYv0E
 EWgG8C56UowFXtW09e0eE9zspTqaFYfx+5yVly+j/c4UPtU/zVLo1rrWvD3VAB3LG2pSTwBmF
 OR1IieQzR6fk3kqBJ0kEOIWmS41M6SCFMaW+Xi63q+RCBtX0alNLytMe1VUucGldrsX4R322c
 bQ1KhtSfRLM5rTdyYckvs3VrFc2V/2Eq5ceHOVsRT/Bp0/SfWYuYuhM1vrcOPm0VbnEoT0IP/
 LkSmFwauiipmdMq0T5LbbaZpBNUkNVaJUYe9YcI9t02CfirrV2n3CIGMFcwJb91sU+prPJe5F
 C7E3cjt8aKLdBZp/FY5KUajRlFYFD9+qZk3pQVct83i40oF1H5cvI37MhvhohzKHF427sW1sN
 PBMIByo1I3MtOliX4FWF0zwBQOzKHRB8gWW4VW7YoZEEc0vdVm2fIivFYTs7sQIRg+fGAN92J
 jdFzecx0E+xhLH8az4Celd87YvnVa3ucpxNUMQjn/lgagGDS4Yz+Fh+klgoXC24hBqfeY/3P5
 n2e83PBoEd06qc=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/15/21 9:47 PM, Linus Torvalds wrote:
> On Wed, Sep 15, 2021 at 12:35 PM Guenter Roeck <linux@roeck-us.net> wrot=
e:
>>
>> On a side note, we may revive the parisc patch. Helge isn't entirely
>> happy with the other solution for parisc; it is quite invasive and
>> touches a total of 19 files if I counted correctly.
>
> Ok, my suggestion to use the linker was not a "do it this way", it
> really was just a "maybe alternate approach". So no objections if
> absolute_pointer() ends up being the simpler solution.

Yes, it's a lot simpler and makes backporting patches later much easier.
I'll send a pull request with the updated parisc patch tomorrow.

Thanks,
Helge

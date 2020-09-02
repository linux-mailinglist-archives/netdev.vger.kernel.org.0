Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67025AF73
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 17:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgIBPi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 11:38:56 -0400
Received: from mout.gmx.net ([212.227.17.20]:50663 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgIBPC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 11:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599058860;
        bh=9mONAPviboKjYh84a+hy1GCQTwP3D+gQs9CslXOAS7A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=L8sV5DSyxZUjMdCJhBHYorScxg6Z4vf+qm5xzt+bAm4G4iOhKeQORYS34kwE/JbdB
         rSg/pnYjdeGX/vczI3Au4GC/AISEAjmvpla+YBUSsn1+9ZZIThR1CZxpTTFl/pWKKE
         2JYJbWOBPJPv1+9uzRxIQ/Bk/261ZOsS/Kx0dlF8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.155.63]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MZTmY-1k7SOI0Ure-00WV2u; Wed, 02
 Sep 2020 17:01:00 +0200
Subject: Re: [PATCH 07/28] 53c700: improve non-coherent DMA handling
To:     Matthew Wilcox <willy@infradead.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
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
 <3369218e-eea4-14e9-15f1-870269e4649d@gmx.de>
 <77c9b2b6-bedc-d090-8b23-6ac664df1d1f@gmx.de>
 <20200901165311.GS14765@casper.infradead.org>
From:   Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <30bfa844-00ea-1abe-9022-d73cf309e580@gmx.de>
Date:   Wed, 2 Sep 2020 17:00:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200901165311.GS14765@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ylKgDqFU+gFaPC2d+WzSCQXxiLQIXKySkLqivXa28qMeQ0h5Pxr
 tXM5x2Bo4S8TIKWGUWrbkkNuyKUME2NUvg3jtsmf8vkXFe4smPhe14q2DVLmoJE/VrrUvC8
 63TbKzPDS66vjFhBhFr+EMjQN0laqJgo2Hk+foHitxLhjyTxAJGMdprDPYH1wX4OBUsoyKp
 QMsIM54OSGNwhG+Lr3XfQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aS28Gzfeplo=:J9k98LfUdjGOuaDrD12GXy
 mzSgOO4XwP9o4WwUrfevHPZft60XRYzaydJg0seTLUP9PUMe4SCR8wnt+FqJb2KmNErTSF3Yz
 mlEuV2ypNQhyeT8Zb7TFH9gIDYr63Tn/49r4uWCsv7KGts2XskLUKRIcTRjTyZ3fFf2AfYibs
 BzDfzF9v3j4/idusDth0av+x88Bd3jXvRuZ7oJJF2HqnBG4SkKXa0NLw7UkTYhhf//eGiBY6L
 Tz4eqwGRg7UwwOHV8G+kLUYax69snHYMWRmONRp+4GHeEto3D1SVN2jF+XEdTo8EG6GK7mVkf
 REE4YOujtqDjHiR6Ot35dAEtJQsFsZG4uNaEY+BHAPdoB2Df8TOc3SqjwTa1Ieccn9gGFcI0v
 HHi8UTCZoevjnXCWVau4Y/zHGSN/AvvivjSjDJh7E2zIcG2RsvnL1QRgMV2O5i8o0o0mkywRA
 7f7mDxGgqyo/OXeuv19tt2n2HqKCUEns1YJ87JOE/tZhZzKHulZvXXB66rnFRt+wNw/tRV1ft
 9Hv0ciJkPH32Jjmj3fbLVbhytxvULtITMmRk6+0rf0MLbgyAu89Ax6nNGds65lCXxgsshpdaw
 73NW8eCpFbuCSovlK4TWz1l58mYvKCfFcm7x2NeJ0dOieetl4mzs3HcI5qq6WHdSH4o4WvPww
 lGbsyrOodVY3EiL6Dvj0o+RCTbWMiZaG9cwrWeQzIsjYAFnZ0YNI7k5IOxf8FqZ3FZilscmm4
 1aHFf1DqijKWy8YrPe5SLLGm7jipNlbM97JdT8Rky3LFIzh6n4cS92aBdLFDSMG5m8JFPzZyV
 nSDYrKeU19FFhsekzwqljpEW2mIFGl9Wl07u9Sip7k6aoMhwb74pJUjrtd4RazX00tgfI3Jv5
 cbyBhn+XCUXDCMbBCHZGsG23/3V32rVakAqts6bEfUkqclD0zAytopG2cvnwsLqpYdubwTIN3
 kUmpUTgLkIzzdNSz9uF58RQPOyRSV2yH/L/klzgKzaIZC8LHyq6i1S7e2N4ZD+jcidq45xXM7
 dxde84/84J6CvL4H+9k93kdrMM+as6D+M+klxCE/E51ydob240bTvF6xRBq0aTd9xSQcRJTBm
 Kb4lpYVFKQfTy9KqWPa1ZEWaqLY8gC2E/gIYnnMq+m49vVWvY/xMJdiGLExTZ7lfIdx9XsKQZ
 bj3+thm3qGCfuP6o6d33ewaGx84nW8EaWKaRAZZqHK0i4qKqTW7aR2AL4dtU4tMIrbzNV/2DK
 7fOan6bBrutQ8vuLD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willy,

On 01.09.20 18:53, Matthew Wilcox wrote:
> On Tue, Sep 01, 2020 at 06:41:12PM +0200, Helge Deller wrote:
>>> I still have a zoo of machines running for such testing, including a
>>> 715/64 and two 730.
>>> I'm going to test this git tree on the 715/64:
>
> The 715/64 is a 7100LC machine though.  I think you need to boot on
> the 730 to test the non-coherent path.

Just tested the 730, and it works as well.

Helge

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A9315AB93
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgBLPAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:00:10 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:27493 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727231AbgBLPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 10:00:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581519607;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=3yrlgbwpWQZTwSSfMKPtb8XHqELW1Q2VHBhevB4Ahuo=;
        b=n429HJfv3UUpI05fIeMj5pZySRovNjCWs/mlTHPY+2+mACKh0bhGjfxbGJrfUAshNP
        9bR6+nSvSeKKjaLtITuNv/9MnO0ssUXjkmrHv2umT4GRSLLNvZeHudT7H4V5c+z6N6EL
        zgMBehjnm4A9DyQ40ciyNiO86Z2ga3HJiv6siiI7WFVggOo0gWCoLBhDRnBXsrDRcjPe
        j1vvF8xgtYRJx9oEvrjFeqCde/2rsitarfdvVILBiwNaUWmpQTYU0jtBjKuXr5XB+zvU
        BV4CJjcngBim0w6cHTw9yxthudI2coByo3DVCOatFrz+dM+xWKM1gTbEucs67OCYn8ro
        T80A==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlSbXAgODw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1CExt59j
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 12 Feb 2020 15:59:55 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: i2c: jz4780: silence log flood on txabrt
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200212145356.GB2492@ninjato>
Date:   Wed, 12 Feb 2020 15:59:55 +0100
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?utf-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: 7bit
Message-Id: <0C9F4243-159B-418C-B481-4B45B210F9F6@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com> <7facef52af9cff6ebe26ff321a7fd4f1ac640f74.1581457290.git.hns@goldelico.com> <20200212094628.GB1143@ninjato> <213C52CC-E5DC-4641-BE68-3D5C4FEA1FB5@goldelico.com> <20200212145356.GB2492@ninjato>
To:     Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Am 12.02.2020 um 15:53 schrieb Wolfram Sang <wsa@the-dreams.de>:
> 
> Hi,
> 
>>> Sorry, normally I don't do counter patches. Yet, this time I realized
>>> that it would be faster to actually do what I envisioned than to
>>> describe it in words. I hope you don't feel offended.
>> 
>> No problem. I had thought a little about that myself, but did not
>> dare to solve more than my problem...
> 
> Glad you like it. Well, it still kinda solves your problem only, because
> there are still too many dev_err in there, but I think this is good
> enough for now.
> 
>>> Obviously, I can't test, does it work for you?
>> 
>> Yes,it works.
> 
> Good!
> 
>> Do you want to push your patch yourself, or should I add it to my
>> patch series and resubmit in a v2?
> 
> I'll apply the patch to my tree directly as a bugfix for 5.6. You can
> drop the I2C list from V2 then.

Ok, fine.

BR and thanks,
Nikolaus


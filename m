Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60C347B47F
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfG3UrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:47:04 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:36364 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfG3UrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:47:04 -0400
Received: by mail-ed1-f65.google.com with SMTP id k21so63743017edq.3;
        Tue, 30 Jul 2019 13:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rnJlkh/Q87VmPKlKJL1ihGGE96lC4RRb7Zru8TgeksQ=;
        b=f8IqJ/pAch002pXspZ6OhH5kYQoo6n1EqdqJxxjFLE57pclEzoGGY2TuFeRh82x+zB
         SIl0/VlupxrlWOPyFbQDl8BbRrewXg4quGXAcSW6woMu+RZPN2tGTv0GQ7IXkqLF/jX0
         fS9CmLsIw9tu+wJt3JHv/PzL0WYLt7U+fCXlxpEXVDlz58ZzE00bnUQh1vWI5zcePL8h
         kn9zsjk9w062Z2ommrJu9r7pi4k6oqnOKUPwM4Ked5mnBGpDXregTGTwfZ9BRiRibfop
         yqAYPra2h7LuufqdOZT2CzkWpG9HaN+gED8jAM2oTW/hOi/EKvx5zmmp5qwDY5QXYJEr
         wNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rnJlkh/Q87VmPKlKJL1ihGGE96lC4RRb7Zru8TgeksQ=;
        b=atImn6qFoHSJZxPjfoWbKtE6qO5xocSogIuQYxInXodrSiqb8d285nSafVHF3mGUVY
         BSezSCPC2J+hi6BpT5IWMmVY2AI6pyzcq4tmLJ6AiCt2Lc050/zgWjiinDWGiUcbCYQQ
         UZHch8T4wIgA2h6ba4IR92KxmvvIOHFGKt/MK27BH2ySuyowx4ywqCcneGEOXkkl+6Gv
         h7nYuKM2MjXjA3VdvKVcg/GNxHmQmJEohhscVWjwx1J7MH+0MWFl7oxqX14OVrxKhYsa
         Ka1kLA0pH44+5/P5YdoeDcEllXxvorMV+K09lYpR9TFfcESpB9mWl45ayaxLD4xJK7vH
         7nJA==
X-Gm-Message-State: APjAAAXH6CNOUVk7Um59P1tQ7OCDJ7vLdckkiuNB0CcAjMZxKh8vkeuQ
        TMqROf6tOkeRHHcclLXVJ2na00JIJ9gPabNIO94=
X-Google-Smtp-Source: APXvYqzTmA9ZCLaCKv2CjU1OaBPUeBWS/AGhjp211bQ/qkymDMs/MNLT7MCGyxg0UuoVaCphkUeSjUzlsg21CoyXsYk=
X-Received: by 2002:a50:ba19:: with SMTP id g25mr103537071edc.123.1564519622422;
 Tue, 30 Jul 2019 13:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190730100429.32479-1-h.feurstein@gmail.com> <20190730100429.32479-5-h.feurstein@gmail.com>
 <20190730160032.GA1251@localhost> <CAFfN3gUCqGuC7WB_UjYYNt+VWGfEBsdfgvPBqxoJi_xitH=yog@mail.gmail.com>
 <20190730171246.GB1251@localhost>
In-Reply-To: <20190730171246.GB1251@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 30 Jul 2019 23:46:51 +0300
Message-ID: <CA+h21hqWO=qT6EuQOVgX=J1=m60AWT6EGvQgfzGS=BNNq1cyTg@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250 family
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hubert, Richard,

On Tue, 30 Jul 2019 at 19:44, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Tue, Jul 30, 2019 at 12:04:29PM +0200, Hubert Feurstein wrote:
> > diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
> > index 768d256f7c9f..51cdf4712517 100644
> > --- a/drivers/net/dsa/mv88e6xxx/ptp.c
> > +++ b/drivers/net/dsa/mv88e6xxx/ptp.c
> > @@ -15,11 +15,38 @@
> >  #include "hwtstamp.h"
> >  #include "ptp.h"
> >
> > -/* Raw timestamps are in units of 8-ns clock periods. */
> > -#define CC_SHIFT     28
> > -#define CC_MULT              (8 << CC_SHIFT)
> > -#define CC_MULT_NUM  (1 << 9)
> > -#define CC_MULT_DEM  15625ULL
> > +/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
>
> That is not true.
>

I was referring to this:
https://github.com/richardcochran/linuxptp/blob/master/phc.c#L38

/*
* On 32 bit platforms, the PHC driver's maximum adjustment (type
* 'int' in units of ppb) can overflow the timex.freq field (type
* 'long'). So in this case we clamp the maximum to the largest
* possible adjustment that fits into a 32 bit long.
*/
#define BITS_PER_LONG (sizeof(long)*8)
#define MAX_PPB_32 32767999 /* 2^31 - 1 / 65.536 */

Technically it is not "not true".

[snip]

On Tue, 30 Jul 2019 at 21:09, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Tue, Jul 30, 2019 at 06:20:00PM +0200, Hubert Feurstein wrote:
> > > Please don't re-write this logic.  It is written like that for a reason.
> > I used the sja1105_ptp.c as a reference. So it is also wrong there.
>
> I'll let that driver's author worry about that.
>
> Thanks,
> Richard
>

And what is the reason for the neg_adj thing? Can you give an example
of when does the "normal way" of doing signed arithmetics not work?

Thanks,
-Vladimir

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2144DB0E61
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbfILL6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:58:44 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43256 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfILL6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:58:44 -0400
Received: by mail-ed1-f68.google.com with SMTP id c19so23642107edy.10
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=g1W+jkQy4polbm+PMUXbsa1XJj1ws6nhi2AdgQnJngU=;
        b=I57JRYefLTE1e9QgcsXsuVSoHd9CRwPrpVqz+iTnKsO42EI9zjI1U+2VumyvdU5DWh
         DS47zqsi3DJMaTPY6M2qUFY8qePE9im+J7HaNCYQ1J4MEiDzvvz/o0IPS6iOLhWonQd8
         OTde4O8b7irV2gOfEF+HsntIizBUGQpgyg8R/cLp3FTH5eye5x3KMP8CWyd45coPs5fN
         kyk/AwIMSQ9dZyL5O9YoFMzaJLoBTqMeefH/EPAwI8nd71Ui70gsaGRRlYzJtoidEryP
         tPWgGWSAZ1upL2rd9+1mWruM3rteADslCwj59ECkhUrVDMUPH7TDmRBqmhdepTnfhSMU
         ogLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=g1W+jkQy4polbm+PMUXbsa1XJj1ws6nhi2AdgQnJngU=;
        b=EbRxQksGY7HOD8jt000g6j5uE7Drk5GVxvDWcnR0+0zCWQyMXHAE3QXvZ2SzKDPNvV
         ZIpDXO6MndupGQt/A//yakElepo/zvhqNbrQI9/krzbQKiYj8njAa6gZVnLXW2o/tavV
         HXFVgztIdhQ3EgWxjS7ldepdgvFDzK+CfFLDJGlOu3BZltGTL1DStYG/iKZkAm7yAvei
         zkbDjnDJ7z+2lPMcrHeKsK8p7inBw+tNblLa8bS8geaC75v7COy9CHchhU7XG3C/GB9p
         Mib4L44/6QT099/Aue0XgO8pihGE0rLujSJmjQOC9IO34FCTYxCKFs1uGyE1QZqaWP4f
         kRgw==
X-Gm-Message-State: APjAAAVvb/0a7ePS7q9LS+U3UhTkeqFkd/fQ+2L5ZhaHKQ7pUrzX0HU1
        shQ6tgLAdPk3oiJ2JsBlp/qGnwfcFUX4LIyn0vg=
X-Google-Smtp-Source: APXvYqx4E7+gdA+HKHMzCKQ6LGov/jne0JiY6IRVfcT34F75ssQJeY/rJqYuHostNpkVV5eqD+v6X+Dmje3Doy+5faM=
X-Received: by 2002:a17:906:35c2:: with SMTP id p2mr23510902ejb.241.1568289522368;
 Thu, 12 Sep 2019 04:58:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:5a99:0:0:0:0 with HTTP; Thu, 12 Sep 2019 04:58:41
 -0700 (PDT)
In-Reply-To: <20190912.133753.1473374980190418320.davem@davemloft.net>
References: <20190910013501.3262-4-olteanv@gmail.com> <20190912.121203.1106283271122334199.davem@davemloft.net>
 <CA+h21hoBQ=4pSCgwcYWErA7k7BQ02LMun_qZ476-bB4eY6RjjQ@mail.gmail.com> <20190912.133753.1473374980190418320.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Sep 2019 12:58:41 +0100
Message-ID: <CA+h21hqLJLADbL+7QZVFSyno9H8rxxTM=G7w_=_bzS37mKHodA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 3/7] net: dsa: sja1105: Switch to hardware
 operations for PTP
To:     David Miller <davem@davemloft.net>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        richardcochran@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/09/2019, David Miller <davem@davemloft.net> wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu, 12 Sep 2019 11:17:11 +0100
>
>> Hi Dave,
>>
>> On 12/09/2019, David Miller <davem@davemloft.net> wrote:
>>> From: Vladimir Oltean <olteanv@gmail.com>
>>> Date: Tue, 10 Sep 2019 04:34:57 +0300
>>>
>>>>  static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long
>>>> scaled_ppm)
>>>>  {
>>>>  	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>>>> +	const struct sja1105_regs *regs = priv->info->regs;
>>>>  	s64 clkrate;
>>>> +	int rc;
>>>  ..
>>>> -static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>>>> -{
>>>> -	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>>>> +	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
>>>> +				  &clkrate, 4);
>>>
>>> You're sending an arbitrary 4 bytes of a 64-bit value.  This works on
>>> little
>>> endian
>>> but will not on big endian.
>>>
>>> Please properly copy this clkrate into a "u32" variable and pass that
>>> into
>>> sja1105_spi_send_int().
>>>
>>> It also seems to suggest that you want to use abs() to perform that
>>> weird
>>> centering around 1 << 31 calculation.
>>>
>>> Thank you.
>>>
>>
>> It looks 'wrong' but it isn't. The driver uses the 'packing' framework
>> (lib/packing.c) which is endian-agnostic (converts between CPU and
>> peripheral endianness) and operates on u64 as the CPU word size. On
>> the contrary, u32 would not work with the 'packing' API in its current
>> form, but I don't see yet any reasons to extend it (packing64,
>> packing32 etc).
>
> That's extremely unintuitive and makes auditing patches next to impossible.
>

Through static analysis maybe you're right - I don't yet grasp what it
takes to prove an API is used correctly at build time, but I can look
at how others are doing it.
At runtime, there is sanity checking throughout and all the bugs I've
had while calling packing() incorrectly I caught them right away.
spi_send_int in particular is just a wrapper for packing an N byte
sized word (which fits in u64) in bits [8*N-1, 0] of the buffer, as
per peripheral memory ordering quirks. This is perhaps the trivial
case that can be handled through other APIs as well, but there are
times when I need to pack an u64 into a bit field that crosses even
64-bit boundaries. Combine that with weird byte ordering, and the
sja1105 driver would have simply not existed if it had to open-code
all of that. The API's high-level goal is for readers to be able to
follow along smoothly with the register manual.
All I'm saying is that I'm willing to make the packing API more
sane/checkable, but at the moment I just don't see the better
alternative.

Thanks,
-Vladimir

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB09B0C72
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbfILKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:17:14 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40771 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbfILKRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:17:14 -0400
Received: by mail-ed1-f67.google.com with SMTP id v38so23438991edm.7
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 03:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=VDfrOSXjwA6flC51oVkPpHkt8cs+wtdOQ+Ylea7Oy8s=;
        b=owPJyKaQ7J2YN9E7fLTqLY7pNw2eK7XCcBQFXX9QKpbTyU2F8TcGapux1mS4IACWf2
         wUMfJMmFsHyZpVN8BVX7UhM11H8/FYyGafKc5x5+yjO1jZe8DKk/gM18xEiQdKjGl7wv
         1aQFst9N/y8rVLEr7EEWlMEny4+mwhw9HDQ7HD8Xny//fyMVxKoOdLa/C/7ZKlt1riWM
         Z1DlS+7ZRe/Ce10iu5EPMkNypLZBMkRiu4ZG8b8gI7Rr0lbVYuFZ8ec2jY7+Bi5fOcSx
         cYaMTu9vQveK2ahkc+f1v1WuC6/f+9N4Kylu9OaFwfReTcfslaq8DSPSpfInGUMMp+uH
         1o5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=VDfrOSXjwA6flC51oVkPpHkt8cs+wtdOQ+Ylea7Oy8s=;
        b=Us8jRyJTksxYP0R6M4VLBALfge6ZT2NndEL+A14OI+xTkRvpV/mKZF44oZzw48sXVZ
         G6EHbruwszx+AhBE7arMyWkruL0Wvn8z7u7Z8iuA0/N7DfQD3zChLjrrM15XfBTgVS9G
         ayTUPZTNjNKwO0H21uFtNKABHHlIeeudDWIXc6BAALzetgAt+SEM0toSpremLTUE6NgO
         qBlyv0pMsKNoIr3+cw6A3HyOOnR1NYjYjzoUXABs8ma9rPaquPGwxD9aGIFAztq+w9xN
         GVi6Uct+0jjLDqikyAAKBQUk+KtFkytYrU7B3bp1fE9AeOUCPCcAOPCEk4OurqxA2RvR
         CMkQ==
X-Gm-Message-State: APjAAAVwH3FEbh9RMwePc1+Bz80V+3OOfrMnnnDgIGT6JVloL8xJagD5
        fBLBmO30Ix6qu7qy766cfFW3H2gn/HQUQvCs+VE=
X-Google-Smtp-Source: APXvYqzfZlxybQVaWU2jNDKQ3S2Z7y0Hfg8cudfKCK1XIbuvnOnwGzitgSofyz/O5jpnHdT9YrW75VZlbdtRtYllVr4=
X-Received: by 2002:a17:906:7cc7:: with SMTP id h7mr11760699ejp.204.1568283432259;
 Thu, 12 Sep 2019 03:17:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Thu, 12 Sep 2019 03:17:11
 -0700 (PDT)
In-Reply-To: <20190912.121203.1106283271122334199.davem@davemloft.net>
References: <20190910013501.3262-1-olteanv@gmail.com> <20190910013501.3262-4-olteanv@gmail.com>
 <20190912.121203.1106283271122334199.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Sep 2019 11:17:11 +0100
Message-ID: <CA+h21hoBQ=4pSCgwcYWErA7k7BQ02LMun_qZ476-bB4eY6RjjQ@mail.gmail.com>
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

Hi Dave,

On 12/09/2019, David Miller <davem@davemloft.net> wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 10 Sep 2019 04:34:57 +0300
>
>>  static int sja1105_ptp_adjfine(struct ptp_clock_info *ptp, long
>> scaled_ppm)
>>  {
>>  	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>> +	const struct sja1105_regs *regs = priv->info->regs;
>>  	s64 clkrate;
>> +	int rc;
>  ..
>> -static int sja1105_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>> -{
>> -	struct sja1105_private *priv = ptp_to_sja1105(ptp);
>> +	rc = sja1105_spi_send_int(priv, SPI_WRITE, regs->ptpclkrate,
>> +				  &clkrate, 4);
>
> You're sending an arbitrary 4 bytes of a 64-bit value.  This works on little
> endian
> but will not on big endian.
>
> Please properly copy this clkrate into a "u32" variable and pass that into
> sja1105_spi_send_int().
>
> It also seems to suggest that you want to use abs() to perform that weird
> centering around 1 << 31 calculation.
>
> Thank you.
>

It looks 'wrong' but it isn't. The driver uses the 'packing' framework
(lib/packing.c) which is endian-agnostic (converts between CPU and
peripheral endianness) and operates on u64 as the CPU word size. On
the contrary, u32 would not work with the 'packing' API in its current
form, but I don't see yet any reasons to extend it (packing64,
packing32 etc).

Thanks,
-Vladimir

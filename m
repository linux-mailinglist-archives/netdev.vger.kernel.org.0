Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BD8AE210
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 03:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392542AbfIJBqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 21:46:05 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35932 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfIJBqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 21:46:05 -0400
Received: by mail-ed1-f68.google.com with SMTP id f2so8915068edw.3
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 18:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=bz6gFC3bYQTF8bPV9Bvdht2bfrfwaSI9evcm/oFoV8w=;
        b=OI1ZUz62TTvMxaNgvRGcgt/gl8kHGPjZZXTP9/Qsfaa8iGdpX28NN0fLkp7oendiqa
         wEqvyd+P26eZ2eiMInveNb2ALzjfZgXoOcTj0ozCDsHrm1PPGsju2LOk2NInt/HrU3wq
         QOdx4Dxq9VmVKEyU0QVA8c4wdNCFUUdTet1vAGtApWCJauni1uRQmIoyNr90Ga+UYk3E
         1qBnTodNegMgi1SsxJOgdZ4tSNB2bdna0D3sxY1EJb/1LKvKTeZ/DAMWX1Dbx8pZjpHF
         XTHNWaMaGTkU66QrpoZzPY0l6jFiiEOg5g3/C7f06vzvcJMIaVUDDtOw7GEzxZWVFHaL
         T1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=bz6gFC3bYQTF8bPV9Bvdht2bfrfwaSI9evcm/oFoV8w=;
        b=gumlEcvJD9akhh7tdufMB3BMvvf2X2F8RAb1Fulf8gylKeR9WUAQir1POYijJ+2mM3
         gGVS8h6aLPWoEkL7nj6UATQyIn8gSDNwAezvbjwW6Ib1ktWlm2/o95dhjEQnJBpVaclv
         Oa9/KBNNyYkUTd5VRDoIWlsvoqndW2/0Ky8CNBvjFqZjEn2z/1wdzMGvOgMWnb+5tl4r
         ZeQQLJJCzm4AdYyQ9nFwtmISSzUZTgKQgs2N+L8+1Y5R8uxlL7QqVLiW7l4p161g68C3
         b4rhckVg/gitcCqqa4B+Jo+HY6xYpd7Yxr6xBctzJr3I06Lux5RXmNj1eK6ui2HQGdxK
         vf7Q==
X-Gm-Message-State: APjAAAW/Dy52A/gWVKGm5KZZcQthTEp16pvHzEFvs3yaPPHb6O6e2MLV
        qMIMbJpK6puxaHVj7tgN9WAFkru1tlsxSoc7fso=
X-Google-Smtp-Source: APXvYqw4aQ2ZCz85XtK8oF+qQWDKWyEsmmJl4IQGPwyf1Eduosid5df8+vzkg5EhVYbQI/hKFQJBuNjWsxkrqbr8z34=
X-Received: by 2002:aa7:d755:: with SMTP id a21mr27415556eds.18.1568079963702;
 Mon, 09 Sep 2019 18:46:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:906:e258:0:0:0:0 with HTTP; Mon, 9 Sep 2019 18:46:02
 -0700 (PDT)
In-Reply-To: <20190909123632.nvlmfdtw3otyx3xh@soft-dev16>
References: <20190902162544.24613-1-olteanv@gmail.com> <20190906.145403.657322945046640538.davem@davemloft.net>
 <20190907144548.GA21922@lunn.ch> <CA+h21hqLF1gE+aDH9xQPadCuo6ih=xWY73JZvg7c58C1tC+0Jg@mail.gmail.com>
 <20190908204224.GA2730@lunn.ch> <20190909123632.nvlmfdtw3otyx3xh@soft-dev16>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 10 Sep 2019 02:46:02 +0100
Message-ID: <CA+h21hp_8s=NqhFGd31TrkL_c+x59sRKFmGPEEZwanMhX4Do2w@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 00/15] tc-taprio offload for SJA1105 DSA
To:     Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        richardcochran@gmail.com, weifeng.voon@intel.com,
        jiri@mellanox.com, m-karicheri2@ti.com, Jose.Abreu@synopsys.com,
        ilias.apalodimas@linaro.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kurt.kanzenbach@linutronix.de,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Joergen, Richard,

On 09/09/2019, Joergen Andreasen <joergen.andreasen@microchip.com> wrote:
> The 09/08/2019 22:42, Andrew Lunn wrote:
>> On Sun, Sep 08, 2019 at 12:07:27PM +0100, Vladimir Oltean wrote:
>> > I think Richard has been there when the taprio, etf qdiscs, SO_TXTIME
>> > were first defined and developed:
>> > https://patchwork.ozlabs.org/cover/808504/
>> > I expect he is capable of delivering a competent review of the entire
>> > series, possibly way more competent than my patch set itself.
>> >
>> > The reason why I'm not splitting it up is because I lose around 10 ns
>> > of synchronization offset when using the hardware-corrected PTPCLKVAL
>> > clock for timestamping rather than the PTPTSCLK free-running counter.
>>
>> Hi Vladimir
>>
>> I'm not suggesting anything is wrong with your concept, when i say
>> split it up. It is more than when somebody sees 15 patches, they
>> decide they don't have the time at the moment, and put it off until
>> later. And often later never happens. If however they see a smaller
>> number of patches, they think that yes they have time now, and do the
>> review.
>>
>> So if you are struggling to get something reviewed, make it more
>> appealing for the reviewer. Salami tactics.
>>
>>     Andrew
>
> I vote for splitting it up.
> I don't know enough about PTP and taprio/qdisc to review the entire series
> but the interface presented in patch 09/15 fits well with our future TSN
> switches.
>
> Joergen Andreasen, Microchip
>

Thanks for the feedback. I split the PTP portion that is loosely
coupled (patches 01-07) into a different series. The rest is qdisc
stuff and hardware implementation details. They belong together
because it would be otherwise strange to provide an interface with no
user. You can still review only the patches you are interested in,
however.

Thanks,
-Vladimir

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD414A40F
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730468AbgA0Mn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:43:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37574 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgA0Mn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:43:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so11125741wru.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t+gsWbzPHXD56W/YpRuIns5DpPUVaU93o4vAOMdBKos=;
        b=NT+rM8y9fLzizKgsG6sh+pOihQRA3jlaF4irQZN5GkfnaST2+Gj+KRuHMSKwBd4H8z
         py02jyHK9/RN7lVl1yiw1bmhilXDw8xmk6IZLOhlZwkZ1sfjpL+7mAlmzkgvlAUSB4ky
         g0ASOlk2b45qbGu4RuTK0hyPrZ+ajBhsWQoQcFXRN0HQVqCg1vEpz/zwvGfhNbMKHQ6l
         BvKGlzNn/j+x6IJWxGwt5okfcFK1tPk2KFgMZWhEmOITiCeQMJoeIZ+VfhNQNjPNtN/3
         LWgafd2g55F7xjz+DBFZhIa/SB16CiZqCc+LIbrfbISus9xBQYAdRuvlZ1sBcMEZ17xw
         4eSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t+gsWbzPHXD56W/YpRuIns5DpPUVaU93o4vAOMdBKos=;
        b=clMsA7jeXz6q4mItDeCLF9C+xUyrEfcaPhsrYNrlJ5R5PVevJuIU/N2sBW62z9nKZx
         xGhgq2zslm8yjjP+VScrXckhpnVnVUjPaHclAeHCxwGvjAKHCp8en5wESH2WYR68u2d4
         IBOSBC2MCE+2kCoNhc/YGO6fNoJaDKtQaqvM6mGbf6476hl7BiSpZ0nojgShOFxkL+T5
         po37oYfGYBP+nqFy58GAptHtvUUYhORrJfyHdhEIfEtMcen2iAPHyEMdJ6LqWKKC5F/2
         ayJedx/75tI9FRBnA3JBiG37eK4QLOWyy5b+1EQ1WAWMA+UZ+SpExj2Gf8JEXcuruhKZ
         Qy3Q==
X-Gm-Message-State: APjAAAUD8saYqnbQx2gwVeOgOP9R0iXtdgPXl8oDukgKtbZ4YJiKh5We
        VaCH0n4bKM8sVUbHzbH+8jGIdGo/185VF/+j5hA=
X-Google-Smtp-Source: APXvYqzVRGj2XadrfgbaCFcqxfPM/B6Y5ol8kzH2wH+zOPZTNu5N+f2DCxFjIjF2rHfcJ2gfKGTg283/eJ/pRjZh5go=
X-Received: by 2002:a5d:4984:: with SMTP id r4mr20958671wrq.137.1580129036263;
 Mon, 27 Jan 2020 04:43:56 -0800 (PST)
MIME-Version: 1.0
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com> <CAA93jw63P06fc=64tss_GJDsw7N=Ucg3pXai_25eT-EK4FysHA@mail.gmail.com>
In-Reply-To: <CAA93jw63P06fc=64tss_GJDsw7N=Ucg3pXai_25eT-EK4FysHA@mail.gmail.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 27 Jan 2020 18:13:45 +0530
Message-ID: <CA+sq2Cd12c29AT6BPk0O4BTw+JA+ZOt7o-kWJKWfq7ZN7fTnzQ@mail.gmail.com>
Subject: Re: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kubakici@wp.pl>,
        =?UTF-8?Q?Michal_Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 12:30 AM Dave Taht <dave.taht@gmail.com> wrote:
>
> I guess my question generally is, what form of RED is implemented in
> the hardware?
>
> http://mirrors.bufferbloat.net/~jg/RelevantPapers/Red_in_a_different_light.pdf
>
> > +/* RED and drop levels of CQ on packet reception.
> > + * For CQ level is measure of emptiness ( 0x0 = full, 255 = empty).
> > + */
> > +#define RQ_PASS_LVL_CQ(skid, qsize)    ((((skid) + 16) * 256) / (qsize))
> > +#define RQ_DROP_LVL_CQ(skid, qsize)    (((skid) * 256) / (qsize))
> > +
> > +/* RED and drop levels of AURA for packet reception.
> > + * For AURA level is measure of fullness (0x0 = empty, 255 = full).
> > + * Eg: For RQ length 1K, for pass/drop level 204/230.
> > + * RED accepts pkts if free pointers > 102 & <= 205.
> > + * Drops pkts if free pointers < 102.
> > + */
> > +#define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
> > +#define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
>
> I guess my question generally is, what form of RED is implemented in
> the hardware?

Periodically or per packet (based on configuration) a average level of
receive side resources
(ie number of free receive buffer pointers, number of unused receive
packet notification descriptors)
is calculated and compared against configured values to determine
whether to do RED dropping or not.

>
> (what's aura?)
>

Aura is a HW term, this maintains receive buffer pointers.
When a packet is received HW allocates a pointer from Aura and does a
DMA to it and
then prepares a descriptor and adds to CQ (completion queue) and
notifies software.

Thanks,
Sunil.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E610455401
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhKRFBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 00:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhKRFBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 00:01:08 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31986C061570;
        Wed, 17 Nov 2021 20:58:09 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so7174009pja.1;
        Wed, 17 Nov 2021 20:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=s2F6ecwjoAyEcLmw8SlekGncBzWpHTn4YZcihts10HI=;
        b=EfGWD89Ic5s3gJnwaq06XbaZpsUDJpnKOyo/hOWIhKWAVpSiDRIPpXNUsGVm03wR3E
         4bM9FqTXxPThsHOqqHaqlhJPvvqzJH8V/OnceevenqSOG83Lxv/KrDn/gu4/tlZCP5oH
         Mhz6UIKi9WGVXhtdGxKRCDpF/qLGxUHjA/PArd8jEx4+PMpq9ULRG040NWyGHR1QX5GQ
         rmZlhgB8WFNttEH54RBKEBLWGeyhlcn0GBXk5iSdBlRRbPB2mJte4edHyKGbmRnLFQ5C
         EjsY9P6IANIyxA7EcTbiTyIPxzgIps+Z8Jj0OrZqJCC9vW2mSUPpEmTA6wWMhfbMdm2h
         fOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=s2F6ecwjoAyEcLmw8SlekGncBzWpHTn4YZcihts10HI=;
        b=RoWiu6gnOMklOOvjvRRpnOTsLbwyW+qq9uy6h9GYVzr5w/zOaGjpn4zQ/Fjdwvnhpn
         jUTmjkXfv4dg3fl04knb334YZJKl27/cZf1uwXFNCG9x1PWcPDfebZeYw85MC436+NC3
         xzKtShi/rrA8KfOGY1XNWigq+VRFKp3yGOqqdNaWUtgOwSc0UdZo+z/qA12ZwNXxr5W3
         /FceHSfuxz0nWU2oDsLKjvRmpcRPPG1DROInk+c9eXsQaCc+pn7LLIDqvp9SIRkFRTbz
         2eTpRYk0hW2vosxdWWt2Fy52wyhX1h1eLJRv5hCboyxkZqfARsD2egWYQlIiiXlK9TeR
         qx7w==
X-Gm-Message-State: AOAM530t6Y67CmWlbqYy6L7JLuu1RbvEVtyJ+ka/Cfny3EYQiv28mdjj
        CLsdosq+3HHG/zOA91niADbEkGCca088DQ==
X-Google-Smtp-Source: ABdhPJzNGivlm/x2aCujozqzlNUeUd12NdXZXYmEePRpfRwj7pqOuGNa4gmXG7Rg8fRjtOggQeqU8Q==
X-Received: by 2002:a17:902:7007:b0:143:c6e8:4117 with SMTP id y7-20020a170902700700b00143c6e84117mr37801509plk.55.1637211488293;
        Wed, 17 Nov 2021 20:58:08 -0800 (PST)
Received: from [10.1.1.26] (222-155-101-117-fibre.sparkbb.co.nz. [222.155.101.117])
        by smtp.gmail.com with ESMTPSA id v15sm1093065pfu.195.2021.11.17.20.58.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Nov 2021 20:58:07 -0800 (PST)
Subject: Re: [PATCH net v11 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Geert Uytterhoeven <geert@linux-m68k.org>
References: <20211114234005.335-1-schmitzmic@gmail.com>
 <20211114234005.335-4-schmitzmic@gmail.com>
 <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        ALeX Kazik <alex@kazik.de>, netdev <netdev@vger.kernel.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <ceacbd6b-8151-fc94-58c4-3a24d3308705@gmail.com>
Date:   Thu, 18 Nov 2021 17:58:02 +1300
User-Agent: Mozilla/5.0 (X11; Linux ppc64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXj4-D9R_QAgj+vr1j79pPYmoU3uokKHBZFUv5J5jvpaA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

thanks for your review!

On 18/11/21 03:42, Geert Uytterhoeven wrote:
> Hi Michael,
>
> On Mon, Nov 15, 2021 at 12:40 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Add module parameter, IO mode autoprobe and PCMCIA reset code
>> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
>>
>> 10 Mbit and 100 Mbit mode are supported by the same module.
>> Use the core PCMCIA cftable parser to detect 16 bit cards,
>> and automatically enable 16 bit ISA IO access for those cards
>> by changing isa_type at runtime. The user must select PCCARD
>> and PCMCIA in the kernel config to make the necessary support
>> modules available
>>
>> Code to reset the PCMCIA hardware required for 16 bit cards is
>> also added to the driver probe.
>>
>> An optional module parameter switches Amiga ISA IO accessors
>> to 8 or 16 bit access in case autoprobe fails.
>>
>> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
>> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
>> Kazik <alex@kazik.de>.
>>
>> CC: netdev@vger.kernel.org
>> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
>> Tested-by: Alex Kazik <alex@kazik.de>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>
> Thanks for your patch!
>
>> --- a/drivers/net/ethernet/8390/apne.c
>> +++ b/drivers/net/ethernet/8390/apne.c
>> @@ -119,6 +119,48 @@ static u32 apne_msg_enable;
>>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>>
>> +static int apne_100_mbit = -1;
>> +module_param_named(100_mbit, apne_100_mbit, int, 0444);
>> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
>> +
>> +#if IS_ENABLED(CONFIG_PCMCIA)
>
> What if CONFIG_PCMIA=m, and CONFIG_APNE=y?

Fails to build (undefined reference to `pcmcia_parse_tuple').

That's what 'select PCMCIA' was avoiding before, but got vetoed. I can 
add a dependency on PCMCIA in the APNE Kconfig entry which does force 
APNE the same as what's selected for PCMCIA, but that means we can't 
build APNE without PCMCIA anymore. Is there a way to express 'constrain 
build type if PCMCIA is enabled, else leave choice to user' ??

>
>> +static int pcmcia_is_16bit(void)
>> +{
>> +       u_char cftuple[258];
>> +       int cftuple_len;
>> +       tuple_t cftable_tuple;
>> +       cistpl_cftable_entry_t cftable_entry;
>> +
>> +       cftuple_len = pcmcia_copy_tuple(CISTPL_CFTABLE_ENTRY, cftuple, 256);
>> +       if (cftuple_len < 3)
>> +               return 0;
>> +#ifdef DEBUG
>> +       else
>> +               print_hex_dump(KERN_WARNING, "cftable: ", DUMP_PREFIX_NONE, 8,
>> +                              sizeof(char), cftuple, cftuple_len, false);
>> +#endif
>> +
>> +       /* build tuple_t struct and call pcmcia_parse_tuple */
>> +       cftable_tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
>> +       cftable_tuple.TupleCode = CISTPL_CFTABLE_ENTRY;
>> +       cftable_tuple.TupleData = &cftuple[2];
>> +       cftable_tuple.TupleDataLen = cftuple_len - 2;
>> +       cftable_tuple.TupleDataMax = cftuple_len - 2;
>> +
>> +       if (pcmcia_parse_tuple(&cftable_tuple, (cisparse_t *)&cftable_entry))
>
> Can't you avoid the cast, by changing the type of cftable_entry?

Sure, could declare cisparse_t cfparse above, and prepend cfparse. at 
all uses of cftable_entry below.

> Perhaps you don't want to do that, to avoid abusing it below, but
> perhaps you can use container_of() instead of the cast?

Wasn't sure container_of() works with unions, but that seems to avoid 
the cast OK as well.

>
>> +               return 0;
>> +
>> +#ifdef DEBUG
>> +       pr_info("IO flags: %x\n", cftable_entry.io.flags);
>> +#endif
>> +
>> +       if (cftable_entry.io.flags & CISTPL_IO_16BIT)
>> +               return 1;
>> +
>> +       return 0;
>> +}
>> +#endif
>> +
>>  static struct net_device * __init apne_probe(void)
>>  {
>>         struct net_device *dev;
>> @@ -140,6 +182,13 @@ static struct net_device * __init apne_probe(void)
>>
>>         pr_info("Looking for PCMCIA ethernet card : ");
>>
>> +       if (apne_100_mbit == 1)
>> +               isa_type = ISA_TYPE_AG16;
>> +       else if (apne_100_mbit == 0)
>> +               isa_type = ISA_TYPE_AG;
>> +       else
>> +               pr_cont(" (autoprobing 16 bit mode) ");
>> +
>>         /* check if a card is inserted */
>>         if (!(PCMCIA_INSERTED)) {
>>                 pr_cont("NO PCMCIA card inserted\n");
>> @@ -167,6 +216,14 @@ static struct net_device * __init apne_probe(void)
>>
>>         pr_cont("ethernet PCMCIA card inserted\n");
>>
>> +#if IS_ENABLED(CONFIG_PCMCIA)
>> +       if (apne_100_mbit < 0 && pcmcia_is_16bit()) {
>> +               pr_info("16-bit PCMCIA card detected!\n");
>> +               isa_type = ISA_TYPE_AG16;
>> +               apne_100_mbit = 1;
>> +       }
>
> I think you should reset apne_100_mbit to zero if apne_100_mbit < 0
> && !pcmcia_is_16bit(), so rmmod + switching card + modprobe
> has a chance to work.

Good catch - though when switching to another card using this same 
driver, the module parameter can be used again to select IO mode or 
force autoprobe.

I'll wait for your response about the sysfs parameter issue before 
sending out v12.

Cheers,

	Michael


>
>> +#endif
>> +
>>         if (!init_pcmcia()) {
>>                 /* XXX: shouldn't we re-enable irq here? */
>>                 free_netdev(dev);
>
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>

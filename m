Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0040C582641
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiG0MTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiG0MTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CAD14A829
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658924340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmCiTMtuhWI7oCif0/8Z84LPgcREuckswJDytFqvLLY=;
        b=deS+yBKhWeidm5xtP74dB9ugBYMz/Mxoy4xI5TE4KiOt3xhPZ8XVA9+3FFzfXefkurbyQB
        dnyiMu1/hG9MC3wQf3zQaeSEo4dPxkJHoseE9awyRpC82mP3B4d4y+bf5idU3S/JVXjVi/
        6J70rsViudyVS95F+a0UQmBkzCjP7EE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-463-EMvmN_7cO1CuEZ6oCoHVLQ-1; Wed, 27 Jul 2022 08:18:57 -0400
X-MC-Unique: EMvmN_7cO1CuEZ6oCoHVLQ-1
Received: by mail-ed1-f72.google.com with SMTP id o2-20020a056402438200b0043ccb3ed7dfso266210edc.22
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WmCiTMtuhWI7oCif0/8Z84LPgcREuckswJDytFqvLLY=;
        b=16svf0Basvp0gRrYzFEhvn5wJLt9jF8y40yL25ku1POrILzNF2DjWX9Uyl7FgSye/s
         L5pNle8UHDuxJWLUssNjB93MyhHYCS6TMvQCCIvpNQLwj068LGwtQdxAHWvpG5KTV7gc
         XSWjzeNx9kiewuXw6I2jdxjecmbQgRW/wyShpekhidxJWcBqQjJpE3buLN2D67q7GKcX
         yOF4a31BrExEzG9FzNC2xqFCCliiN6//jD7iU/47i8P7nuqhnD2E3AobXfL9CPJUPJLH
         SDcbjmebjL4Fve7FTWQ7O+Sxbvz9UceS0PNIuHdVszO540yRG1kNdutxqzVgeZj3ZACF
         XVHw==
X-Gm-Message-State: AJIora+6ZneNc+fpfAEzhBJtCtQssAHrp19HU9NMIYQ8CbeWua/giPqG
        XB8CaCoN9/q54GGyLRnks48rwQWTpcmiriey4PI9NKl9w1yivQ0Ul2FFcwentJ4T8ohgRH714Q7
        OMCRwxakthlHHhf13
X-Received: by 2002:a17:907:7245:b0:72f:39e7:1207 with SMTP id ds5-20020a170907724500b0072f39e71207mr17507016ejc.201.1658924336261;
        Wed, 27 Jul 2022 05:18:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tq77tz3LjPQkemKAdpM2HQ6LQo5dMeyMGCTEGREBkr8scpvEfFdsmnmo1I0sOl4/nEv/Ym3Q==
X-Received: by 2002:a17:907:7245:b0:72f:39e7:1207 with SMTP id ds5-20020a170907724500b0072f39e71207mr17506990ejc.201.1658924335983;
        Wed, 27 Jul 2022 05:18:55 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id 11-20020a170906310b00b00722fc0779e3sm7443534ejx.85.2022.07.27.05.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 05:18:55 -0700 (PDT)
Message-ID: <08c744e6-385b-8fcf-ecdf-1292b5869f94@redhat.com>
Date:   Wed, 27 Jul 2022 14:18:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [BISECTED] igb initialization failure on Bay Trail
Content-Language: en-US
To:     "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc:     andriy.shevchenko@linux.intel.com, carlo@endlessm.com,
        davem@davemloft.net, hkallweit1@gmail.com, js@sig21.net,
        linux-clk@vger.kernel.org, linux-wireless@vger.kernel.org,
        mturquette@baylibre.com, netdev@vger.kernel.org,
        pierre-louis.bossart@linux.intel.com, sboyd@kernel.org
References: <20180912093456.23400-4-hdegoede@redhat.com>
 <20220724210037.3906-1-matwey.kornilov@gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20220724210037.3906-1-matwey.kornilov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On 7/24/22 23:00, Matwey V. Kornilov wrote:
> Hello,
> 
> I've just found that the following commit
> 
>     648e921888ad ("clk: x86: Stop marking clocks as CLK_IS_CRITICAL")
> 
> breaks the ethernet on my Lex 3I380CW (Atom E3845) motherboard. The board is
> equipped with dual Intel I211 based 1Gbps copper ethernet.
> 
> Before the commit I see the following:
> 
>      igb 0000:01:00.0: added PHC on eth0
>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>      igb 0000:02:00.0: added PHC on eth1
>      igb 0000:02:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:02:00.0: eth1: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e5
>      igb 0000:02:00.0: eth1: PBA No: FFFFFF-0FF
>      igb 0000:02:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
> 
> while when the commit is applied I see the following:
> 
>      igb 0000:01:00.0: added PHC on eth0
>      igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
>      igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 4c:02:89:10:02:e4
>      igb 0000:01:00.0: eth0: PBA No: FFFFFF-0FF
>      igb 0000:01:00.0: Using MSI-X interrupts. 2 rx queue(s), 2 tx queue(s)
>      igb: probe of 0000:02:00.0 failed with error -2
> 
> Please note, that the second ethernet initialization is failed.
> 
> 
> See also: http://www.lex.com.tw/products/pdf/3I380A&3I380CW.pdf

Yes some boards use more then 1 clk for the ethernet and do not take
care of enabling/disabling the clk in their ACPI.

As Pierre-Louis mentioned already the disabling of the clocks is necessary
to make 100-s of different (tablet) models suspend properly.

Unfortunately this is known to break ethernet on some boards. As a workaround
we use DMI quirks on those few boards to keep the clocks enabled there, see:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/platform/x86/pmc_atom.c#n381

If you can submit a patch adding your board to this DMI table, then I will
merge it and get it on its way to Linus Torvalds asap.

If you instead want me to write the patch for you, please run:

sudo dmidecode > dmidecode.txt

And attach the generated dmidecode.txt file to your next email.

Regards,

Hans


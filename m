Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D1550F348
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344408AbiDZIER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344496AbiDZIEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:04:13 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E3327B20;
        Tue, 26 Apr 2022 01:01:06 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id e7so8349456vkh.2;
        Tue, 26 Apr 2022 01:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JpdFifKs7CxW50jPfs3i6TqXo2OQsTxzT2rNlZQve7o=;
        b=XLLmcZJORWm2MA9YZBulpcc0AbfDmwCq/jjtCH3RF+8AjkBmwRvUhpoUrr/D7XObul
         TlPlIY023CjDfxJye/vZfj7ERoTu/9Hgl6hkKNyJRqFGeAPLT+AvRw3CRd0ZMedhsxG6
         i6LaNLIwFYzCUSw0UDM1m1sNQHWcCLCYdwsrHCUuYO7uHCOkNHbLF7X8iOLSEIcS4IIX
         +2uauYW9vIVINCjvlSiDrt16tiFpiT73IKWYNjPl2J4tgrGuUtY82W1hAcUjJDfexDwC
         KYrO5QRSNUoG1OszGnr+DxTfGPRlg70Ig6uRVTAamYhYFdp8H2Zhw0RN+Ha1Leg8enqQ
         yKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JpdFifKs7CxW50jPfs3i6TqXo2OQsTxzT2rNlZQve7o=;
        b=X0bdGQypU+3i32w1HiOA7oSC/EjjU/3J3gKXR0ZK5OT75D7BWium9g4PYQbqh0cXe2
         p5F/uI4SajtDXuzbhdntjM1OKuJxi69GK88kYJ1YZ6jMwbOVWsENNJVTMGH9Rsdw5laL
         i8xQ4vpL51ILs7stB6ydgbgSmR6FMZX99oDTfyrJK3B5H6+YTKNm7IzdEPtukzWu1b/i
         I/wu/xfyFu/l28uRA1RNPBJKnwZPC6l5OLYPN/tKW8dEP57bbg8bDdpzDesGTinkDLFI
         LchPU4U8syIwyBou5r31HMoavsDpgcJ6pehY5ilJ3Fh3k1bWVjsIz0i6xiew3l2MmyK0
         i8/g==
X-Gm-Message-State: AOAM5300ZlmHvfR04CgOlpeoJ1KCif0Qx/Xb9TNvwDpnQ17UWnIFPxk7
        o2Xw7lxCcE5EKs7WxIwo3190+gcvKx9+T5aakdo=
X-Google-Smtp-Source: ABdhPJz9VhrNbleoLUWmOjFU7Whei1c8JVE2x1hXtnT4UKv3R32PqntxjBBKx45GHyFvlutsA3LXv4wGCWJ74vVmuAw=
X-Received: by 2002:a1f:e2c7:0:b0:34d:310f:6b0 with SMTP id
 z190-20020a1fe2c7000000b0034d310f06b0mr4052769vkg.19.1650960065178; Tue, 26
 Apr 2022 01:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-9-ricardo.martinez@linux.intel.com> <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
 <d829315b-79ca-ff88-c76-e352d8fb5b5b@linux.intel.com>
In-Reply-To: <d829315b-79ca-ff88-c76-e352d8fb5b5b@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 26 Apr 2022 11:00:54 +0300
Message-ID: <CAHNKnsRMp9kbVLuYCe_-7BUeptmssqAN0fXJtNQ+j-ZmVEiwiw@mail.gmail.com>
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path interface
To:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 10:30 AM Ilpo J=C3=A4rvinen
<ilpo.jarvinen@linux.intel.com> wrote:
> On Tue, 26 Apr 2022, Sergey Ryazanov wrote:
>> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
>> <ricardo.martinez@linux.intel.com> wrote:
>>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>>> for initialization, ISR, control and event handling of TX/RX flows.
>>>
>>> DPMAIF TX
>>> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
>>> network device to transmit packets.
>>> The uplink data management uses a Descriptor Ring Buffer (DRB).
>>> First DRB entry is a message type that will be followed by 1 or more
>>> normal DRB entries. Message type DRB will hold the skb information
>>> and each normal DRB entry holds a pointer to the skb payload.
>>>
>>> DPMAIF RX
>>> The downlink buffer management uses Buffer Address Table (BAT) and
>>> Packet Information Table (PIT) rings.
>>> The BAT ring holds the address of skb data buffer for the HW to use,
>>> while the PIT contains metadata about a whole network packet including
>>> a reference to the BAT entry holding the data buffer address.
>>> The driver reads the PIT and BAT entries written by the modem, when
>>> reaching a threshold, the driver will reload the PIT and BAT rings.
>>>
>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.c=
om>
>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>
>>> From a WWAN framework perspective:
>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>
>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>
>> and a small question below.
>>
>>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/w=
wan/t7xx/t7xx_hif_dpmaif_rx.c
>>> ...
>>> +static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpma=
if_ctrl,
>>> +                                       const unsigned int size, struct=
 dpmaif_bat_skb *cur_skb)
>>> +{
>>> +       dma_addr_t data_bus_addr;
>>> +       struct sk_buff *skb;
>>> +       size_t data_len;
>>> +
>>> +       skb =3D __dev_alloc_skb(size, GFP_KERNEL);
>>> +       if (!skb)
>>> +               return false;
>>> +
>>> +       data_len =3D skb_end_pointer(skb) - skb->data;
>>
>> Earlier you use a nice t7xx_skb_data_area_size() function here, but
>> now you opencode it. Is it a consequence of t7xx_common.h removing?
>>
>> I would even encourage you to make this function common and place it
>> into include/linux/skbuff.h with a dedicated patch and call it
>> something like skb_data_size(). Surprisingly, there is no such helper
>> function in the kernel, and several other drivers will benefit from
>> it:
>
> I agree other than the name. IMHO, skb_data_size sounds too much "data
> size" which it exactly isn't but just how large the memory area is (we
> already have "datalen" anyway and on language level, those two don't soun=
d
> different at all). The memory area allocated may or may not have actual
> data in it, I suggested adding "area" into it.

I agree, using the "area" word in the helper name gives more clue
about its purpose, thanks.

--
Sergey

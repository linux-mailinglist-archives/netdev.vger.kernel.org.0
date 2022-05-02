Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950355175F7
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbiEBRnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 13:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbiEBRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 13:43:33 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 976C7BE36;
        Mon,  2 May 2022 10:40:03 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id m62so13633802vsc.2;
        Mon, 02 May 2022 10:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=camkMsHADeMrXa4AMLDSfBWqeAJxrU8KTK9CoSo2Ws4=;
        b=oKm8PfXQo/fs5n3fryHbbVG03dr2wEg/Mfn1trRKBXNKCX8UpxY3tBM8Zty9t3zzOF
         ibuOgsRnS9JF3DDzjq+AkPHmhyrUN8B+CgB/Ndd0Yh5Fq2tPPlf7PZRlPLDXxb8VG4SS
         vqsduZN41nphB+bsy7CwqSjL/vXFKzMgN9eEpQQONkJB5wZDxrJKCKWpZOqvewYzpkK7
         vuhmMBpf72Z5WWUO+v2S81fiMAIZoiJBZ8RI7HHs5uIaHIVCgOr27PU5yTQh3KixA3nG
         PImG0nJr/hFtXYaD+UlwORZ9db4pggHiDF1OSEZq7oeK5SQ6HGia0f2EtUK+2utta617
         0EAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=camkMsHADeMrXa4AMLDSfBWqeAJxrU8KTK9CoSo2Ws4=;
        b=5/NCsgJUkEx2Op6F7ZpNbprxaHQDPk3ZJGn5X5ESwDTPKn5TU2C2F0p+B5yFHqN4m8
         Ew8mXWtRZZmwaLhxhzvOFbz6tqqsM3NG/vURk7ripu2TYLri+JuiemBftEEvCAQ6PfyJ
         OWAkiyMhCEj6BxMDE07hCUQVds6vWow2yUUW3FwotUxQxykdWOvUfelOWhAU/NiuCmSQ
         lh54/R0f/IOElvNTo5MmzpQjhO3l4PTIZwtSyCqPnyCbNzbEP6aFSjsjkb7MaGHDfX1r
         R+hTjwOhkc5FwKAmjGVIekouGZYK7Lv/hMVS0xKUjQaDIixm1kRnxhkVM2ZF+6RFVxpD
         D7Qg==
X-Gm-Message-State: AOAM532SXBwKQ8pZcV3tiaG4b8y4t1/ka1pneUWXIZCyhsBs/El5BUdj
        CLoIkgpvObA+b+p0QphVum5dKIMllWoIvRNMdKc=
X-Google-Smtp-Source: ABdhPJz9t0Ofb+tcpUEuXtWyApd2T1ToEeoz8AtmyDlUGXVuNofmCa8lNdPesuUNeiyaNR9M80gSwy62SRl7+qg82FA=
X-Received: by 2002:a67:2ec4:0:b0:32c:c442:a309 with SMTP id
 u187-20020a672ec4000000b0032cc442a309mr3559511vsu.32.1651513202727; Mon, 02
 May 2022 10:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-9-ricardo.martinez@linux.intel.com> <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
 <d829315b-79ca-ff88-c76-e352d8fb5b5b@linux.intel.com> <CAHNKnsRMp9kbVLuYCe_-7BUeptmssqAN0fXJtNQ+j-ZmVEiwiw@mail.gmail.com>
 <20a16430-f68c-3df4-1592-e7dad5ec9d53@linux.intel.com>
In-Reply-To: <20a16430-f68c-3df4-1592-e7dad5ec9d53@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Mon, 2 May 2022 20:40:01 +0300
Message-ID: <CAHNKnsSKatqpV7cJjUbJBQgOpNL1Gu3+WgT-EoYaKQX-_k6OTQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path interface
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
Cc:     =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ricardo,

On Mon, May 2, 2022 at 7:51 PM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 4/26/2022 1:00 AM, Sergey Ryazanov wrote:
>> On Tue, Apr 26, 2022 at 10:30 AM Ilpo J=C3=A4rvinen
>> <ilpo.jarvinen@linux.intel.com> wrote:
>>> On Tue, 26 Apr 2022, Sergey Ryazanov wrote:
>>>> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
>>>> <ricardo.martinez@linux.intel.com> wrote:
>>>>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>>>>> for initialization, ISR, control and event handling of TX/RX flows.
>>>>>
>>>>> DPMAIF TX
>>>>> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
>>>>> network device to transmit packets.
>>>>> The uplink data management uses a Descriptor Ring Buffer (DRB).
>>>>> First DRB entry is a message type that will be followed by 1 or more
>>>>> normal DRB entries. Message type DRB will hold the skb information
>>>>> and each normal DRB entry holds a pointer to the skb payload.
>>>>>
>>>>> DPMAIF RX
>>>>> The downlink buffer management uses Buffer Address Table (BAT) and
>>>>> Packet Information Table (PIT) rings.
>>>>> The BAT ring holds the address of skb data buffer for the HW to use,
>>>>> while the PIT contains metadata about a whole network packet includin=
g
>>>>> a reference to the BAT entry holding the data buffer address.
>>>>> The driver reads the PIT and BAT entries written by the modem, when
>>>>> reaching a threshold, the driver will reload the PIT and BAT rings.
>>>>>
>>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel=
.com>
>>>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>>>
>>>>>  From a WWAN framework perspective:
>>>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>>>
>>>> and a small question below.
>>>>
>>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net=
/wwan/t7xx/t7xx_hif_dpmaif_rx.c
>>>>> ...
>>>>> +static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dp=
maif_ctrl,
>>>>> +                                       const unsigned int size, stru=
ct dpmaif_bat_skb *cur_skb)
>>>>> +{
>>>>> +       dma_addr_t data_bus_addr;
>>>>> +       struct sk_buff *skb;
>>>>> +       size_t data_len;
>>>>> +
>>>>> +       skb =3D __dev_alloc_skb(size, GFP_KERNEL);
>>>>> +       if (!skb)
>>>>> +               return false;
>>>>> +
>>>>> +       data_len =3D skb_end_pointer(skb) - skb->data;
>>>>
>>>> Earlier you use a nice t7xx_skb_data_area_size() function here, but
>>>> now you opencode it. Is it a consequence of t7xx_common.h removing?
>>>>
>>>> I would even encourage you to make this function common and place it
>>>> into include/linux/skbuff.h with a dedicated patch and call it
>>>> something like skb_data_size(). Surprisingly, there is no such helper
>>>> function in the kernel, and several other drivers will benefit from
>>>> it:
>>>
>>> I agree other than the name. IMHO, skb_data_size sounds too much "data
>>> size" which it exactly isn't but just how large the memory area is (we
>>> already have "datalen" anyway and on language level, those two don't so=
und
>>> different at all). The memory area allocated may or may not have actual
>>> data in it, I suggested adding "area" into it.
>>
>> I agree, using the "area" word in the helper name gives more clue
>> about its purpose, thanks.
>>
>
> Sounds good. I'll add a patch to introduce skb_data_area_size(),
> I'm not planning to update other drivers to use it, at least in this seri=
es.

Sure. Introduction of the helper function will be enough in the
context of this series.

This will make life easier for future contributors. And perhaps over
time the earlier opencoded places will be updated to the new API.

--=20
Sergey

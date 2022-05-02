Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8849E517508
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386418AbiEBQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386483AbiEBQzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:55:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EC8636D;
        Mon,  2 May 2022 09:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651510302; x=1683046302;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Uap22b8vBrOF9cROfSAfWdTRU5KnLLaZWaIvbRRuYbk=;
  b=PbBb2f9v+0IZmzOt47MqifhgrTNv/nH0QLKH1XFz3JlomtejoI0JXIES
   v/Spb8ymVg3H1Wnx1t+ktNFFOj+uC6IjD4XRsS6WC9MfOQCLl4KTdzfZW
   Izn0+6OIaYlU1wKsqyz2yrGjPKYzXOurIkJm7Ao8JLPvy+oEl5nTKgXHE
   QHWo/HdzpCmsKgUE+PiVs67LnVrBMa7ZHRtoFR059uinz6blD88vXQlO7
   gTwxKjX7J9qRMIcV8dJpl7jtjWnHsKKqGQGBms27t3rPHRPk+HTLy5sVJ
   ohxis9WOX4982HCn+gCHtxhUSQRyr+2V5/j7ovdbaP9agxVdbGfBkto/r
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="267415944"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="267415944"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 09:51:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="887122788"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.197.139]) ([10.212.197.139])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 09:51:40 -0700
Message-ID: <20a16430-f68c-3df4-1592-e7dad5ec9d53@linux.intel.com>
Date:   Mon, 2 May 2022 09:51:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path
 interface
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
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
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com>
 <20220407223629.21487-9-ricardo.martinez@linux.intel.com>
 <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
 <d829315b-79ca-ff88-c76-e352d8fb5b5b@linux.intel.com>
 <CAHNKnsRMp9kbVLuYCe_-7BUeptmssqAN0fXJtNQ+j-ZmVEiwiw@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsRMp9kbVLuYCe_-7BUeptmssqAN0fXJtNQ+j-ZmVEiwiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/26/2022 1:00 AM, Sergey Ryazanov wrote:
> On Tue, Apr 26, 2022 at 10:30 AM Ilpo Järvinen
> <ilpo.jarvinen@linux.intel.com> wrote:
>> On Tue, 26 Apr 2022, Sergey Ryazanov wrote:
>>> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
>>> <ricardo.martinez@linux.intel.com> wrote:
>>>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>>>> for initialization, ISR, control and event handling of TX/RX flows.
>>>>
>>>> DPMAIF TX
>>>> Exposes the 'dmpaif_tx_send_skb' function which can be used by the
>>>> network device to transmit packets.
>>>> The uplink data management uses a Descriptor Ring Buffer (DRB).
>>>> First DRB entry is a message type that will be followed by 1 or more
>>>> normal DRB entries. Message type DRB will hold the skb information
>>>> and each normal DRB entry holds a pointer to the skb payload.
>>>>
>>>> DPMAIF RX
>>>> The downlink buffer management uses Buffer Address Table (BAT) and
>>>> Packet Information Table (PIT) rings.
>>>> The BAT ring holds the address of skb data buffer for the HW to use,
>>>> while the PIT contains metadata about a whole network packet including
>>>> a reference to the BAT entry holding the data buffer address.
>>>> The driver reads the PIT and BAT entries written by the modem, when
>>>> reaching a threshold, the driver will reload the PIT and BAT rings.
>>>>
>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>>>> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
>>>>
>>>>  From a WWAN framework perspective:
>>>> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
>>> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
>>>
>>> and a small question below.
>>>
>>>> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
>>>> ...
>>>> +static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
>>>> +                                       const unsigned int size, struct dpmaif_bat_skb *cur_skb)
>>>> +{
>>>> +       dma_addr_t data_bus_addr;
>>>> +       struct sk_buff *skb;
>>>> +       size_t data_len;
>>>> +
>>>> +       skb = __dev_alloc_skb(size, GFP_KERNEL);
>>>> +       if (!skb)
>>>> +               return false;
>>>> +
>>>> +       data_len = skb_end_pointer(skb) - skb->data;
>>> Earlier you use a nice t7xx_skb_data_area_size() function here, but
>>> now you opencode it. Is it a consequence of t7xx_common.h removing?
>>>
>>> I would even encourage you to make this function common and place it
>>> into include/linux/skbuff.h with a dedicated patch and call it
>>> something like skb_data_size(). Surprisingly, there is no such helper
>>> function in the kernel, and several other drivers will benefit from
>>> it:
>> I agree other than the name. IMHO, skb_data_size sounds too much "data
>> size" which it exactly isn't but just how large the memory area is (we
>> already have "datalen" anyway and on language level, those two don't sound
>> different at all). The memory area allocated may or may not have actual
>> data in it, I suggested adding "area" into it.
> I agree, using the "area" word in the helper name gives more clue
> about its purpose, thanks.
>
Sounds good. I'll add a patch to introduce skb_data_area_size(),
I'm not planning to update other drivers to use it, at least in this series.
Please let me know if you think otherwise.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B8E4F216B
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiDECsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiDECqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:46:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DDA1168D5;
        Mon,  4 Apr 2022 18:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649123538; x=1680659538;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EtCrc2gjv17wshAa8AeMi66A4o5IinGstxpcUa/oURM=;
  b=CEZZ7g+t16IBLqAkS7wTPnqXZcEN01qhltBoTYQ7/jp9NN6aGvBceQen
   0gqCrYaCdS7GQFQ+i8Fw6anim3G3j2L9E1eDv1ozebYxnd27Emf4w6o7i
   m+jL+S0jA4KLxJcNrTJxjh10lXxXv/Lp5tICp0b5f1ni4wvKn2goe0gu3
   8YyKEPW0SmUbL/SR/MUxu+rS/D4l74FQHwhxuJE4wTjzjKXqYhX4LBXhv
   8ToOLjMUb4VcYwF/mcBA9k+I1d5+3jzVzewtXbclplt4K0av0cUiDUss0
   vmutH0pSCBcrxctkLpcCigGtslCzeS1NWMVyjWuMULq3EUAKJNeVYhLBN
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="240571424"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="240571424"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 17:10:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="657703044"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.1.231]) ([10.251.1.231])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 17:10:04 -0700
Message-ID: <65b583fe-0013-9100-8fbf-2e87e4bce091@linux.intel.com>
Date:   Mon, 4 Apr 2022 17:10:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v5 08/13] net: wwan: t7xx: Add data path
 interface
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
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
        ilpo.johannes.jarvinen@intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-9-ricardo.martinez@linux.intel.com>
 <CAHNKnsTZ57hZfy_CTv8-AXuXJEuYVCaO0oax03eMMYzerB-Oyw@mail.gmail.com>
 <a0f3d677-e3a8-ecef-a17e-0638764bd425@linux.intel.com>
 <CAHNKnsRrvz+pnpeGoJdRDD=Qto3eQR79E29Jz2k2kKM0vXMaTQ@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsRrvz+pnpeGoJdRDD=Qto3eQR79E29Jz2k2kKM0vXMaTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/4/2022 4:50 PM, Sergey Ryazanov wrote:
> Hello Ricardo,
>
> On Tue, Apr 5, 2022 at 2:29 AM Martinez, Ricardo
> <ricardo.martinez@linux.intel.com> wrote:
>> On 3/6/2022 6:58 PM, Sergey Ryazanov wrote:
>>> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
>>> <ricardo.martinez@linux.intel.com> wrote:
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>>>> for initialization, ISR, control and event handling of TX/RX flows.
>>>>
>>>> DPMAIF TX
>>>> Exposes the `dmpaif_tx_send_skb` function which can be used by the
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
>> ...
>>>> +static int t7xx_dpmaif_add_skb_to_ring(struct dpmaif_ctrl *dpmaif_ctrl, struct sk_buff *skb)
>>>> +{
>>>> +       unsigned short cur_idx, drb_wr_idx_backup;
>>>> ...
>>>> +       txq = &dpmaif_ctrl->txq[skb_cb->txq_number];
>>>> ...
>>>> +       cur_idx = txq->drb_wr_idx;
>>>> +       drb_wr_idx_backup = cur_idx;
>>>> ...
>>>> +       for (wr_cnt = 0; wr_cnt < payload_cnt; wr_cnt++) {
>>>> ...
>>>> +               bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
>>>> +               if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
>>>> +                       dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
>>>> +                       atomic_set(&txq->tx_processing, 0);
>>>> +
>>>> +                       spin_lock_irqsave(&txq->tx_lock, flags);
>>>> +                       txq->drb_wr_idx = drb_wr_idx_backup;
>>>> +                       spin_unlock_irqrestore(&txq->tx_lock, flags);
>>> What is the purpose of locking here?
>> The intention is to protect against concurrent access of drb_wr_idx by t7xx_txq_drb_wr_available()
> t7xx_txq_drb_wr_available() only reads the drb_wr_idx field, why would
> you serialize that concurrent read?

Good point, drb_wr_idx has only 1 writer which is this thread.

>>>> +                       return -ENOMEM;
>>>> +               }
>>>> ...
>>>> +       }
>>>> ...
>>>> +}

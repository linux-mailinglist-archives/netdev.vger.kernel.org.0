Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6394F21DF
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiDECjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiDECjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:39:20 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3757B264579;
        Mon,  4 Apr 2022 18:40:48 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id b17-20020a0568301df100b005ce0456a9efso8419292otj.9;
        Mon, 04 Apr 2022 18:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p+DXFHCF2UvEXqcV3saeipg+Jd2FbLMogSaL4CBw2NA=;
        b=g8OlHjsQ1CtzdObYDfcJ76xmzyb6G4j7QhB69J4zH1fv1/MLPELUdRUh8nN59fFsE9
         TASiTYslSLbhFpTO607+Mt35hU6DkCibj9ewG0SETVINHFoa+WXeBrfeBI1cBJ7NMVWh
         kvG0ZmcZRigeoyXH/wV/Hmj0JIGUXdQS4Qr0lkRW/JM6mDqXplYh8+xW6pIEjogWjEWQ
         4EUVTWawsbvgHGAXIomwHeDupGWad2XjdHLt98LD2bVvSwV4YSP5LIti4Vh7mNUAwZyN
         kMUdwjvSP8/p0qqYBNsEHjs4CIRjyvLHS3ewsqXE78fwWp4EPctk7LAaXFHFVjJxXzcF
         4xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p+DXFHCF2UvEXqcV3saeipg+Jd2FbLMogSaL4CBw2NA=;
        b=Ygq7y3O8bpRdUOMDczK77O2CPQVdr+5hJAMdHtIMPy+v0YI/l/Gwhv6ZCiBOWyhoGB
         XuioFovaGetqxr8yH3b+ZKV4mqFayTLAG6eMpuqG/WsMj9bkB8jsyKMXNzmSGWoyHHrP
         Qa/fuOfVz7f+/8XY2JI/DC35Zhdks5QrfmMCkbaPsABFZfJkrV+owBs5emJmqaEBow+d
         Ag6OfmSXjoFgHZ+vKPBr0yivmofBAr6fJxA/B4TVgFw9QJWarrdaO0X750zF3JcWb3Tl
         7kYv0IBnnIp30wZ0mIlT47UpSSHIZFcKhdbd3ixZdRuAM7+OWOg5/CKIUPTpqR46MCBZ
         eOFw==
X-Gm-Message-State: AOAM532Rw/oMdS9ezP67q0cYXB5XRcUUhvE+8lSCICK/J+ifwDrGd1WU
        Iek9PSCz62MFqlo6nieEp9vOF59M3XdYpSynXeZt68Wwj9yMVg==
X-Google-Smtp-Source: ABdhPJxsdfGFVmbIngcIiGZU2Dze1DRrqxDCy8pTpRcHDbkqO00RV7IXw+jlMla6F7mZ32UdR2ryN77pZ+9uUsh0K+s=
X-Received: by 2002:ab0:35f8:0:b0:35c:e49b:ede9 with SMTP id
 w24-20020ab035f8000000b0035ce49bede9mr177224uau.74.1649116258588; Mon, 04 Apr
 2022 16:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-9-ricardo.martinez@linux.intel.com> <CAHNKnsTZ57hZfy_CTv8-AXuXJEuYVCaO0oax03eMMYzerB-Oyw@mail.gmail.com>
 <a0f3d677-e3a8-ecef-a17e-0638764bd425@linux.intel.com>
In-Reply-To: <a0f3d677-e3a8-ecef-a17e-0638764bd425@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 5 Apr 2022 02:50:49 +0300
Message-ID: <CAHNKnsRrvz+pnpeGoJdRDD=Qto3eQR79E29Jz2k2kKM0vXMaTQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 08/13] net: wwan: t7xx: Add data path interface
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
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

On Tue, Apr 5, 2022 at 2:29 AM Martinez, Ricardo
<ricardo.martinez@linux.intel.com> wrote:
> On 3/6/2022 6:58 PM, Sergey Ryazanov wrote:
>> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
>> <ricardo.martinez@linux.intel.com> wrote:
>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>
>>> Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
>>> for initialization, ISR, control and event handling of TX/RX flows.
>>>
>>> DPMAIF TX
>>> Exposes the `dmpaif_tx_send_skb` function which can be used by the
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
> ...
>>> +static int t7xx_dpmaif_add_skb_to_ring(struct dpmaif_ctrl *dpmaif_ctrl, struct sk_buff *skb)
>>> +{
>>> +       unsigned short cur_idx, drb_wr_idx_backup;
>>> ...
>>> +       txq = &dpmaif_ctrl->txq[skb_cb->txq_number];
>>> ...
>>> +       cur_idx = txq->drb_wr_idx;
>>> +       drb_wr_idx_backup = cur_idx;
>>> ...
>>> +       for (wr_cnt = 0; wr_cnt < payload_cnt; wr_cnt++) {
>>> ...
>>> +               bus_addr = dma_map_single(dpmaif_ctrl->dev, data_addr, data_len, DMA_TO_DEVICE);
>>> +               if (dma_mapping_error(dpmaif_ctrl->dev, bus_addr)) {
>>> +                       dev_err(dpmaif_ctrl->dev, "DMA mapping fail\n");
>>> +                       atomic_set(&txq->tx_processing, 0);
>>> +
>>> +                       spin_lock_irqsave(&txq->tx_lock, flags);
>>> +                       txq->drb_wr_idx = drb_wr_idx_backup;
>>> +                       spin_unlock_irqrestore(&txq->tx_lock, flags);
>>
>> What is the purpose of locking here?
>
> The intention is to protect against concurrent access of drb_wr_idx by t7xx_txq_drb_wr_available()

t7xx_txq_drb_wr_available() only reads the drb_wr_idx field, why would
you serialize that concurrent read?

>>> +                       return -ENOMEM;
>>> +               }
>>> ...
>>> +       }
>>> ...
>>> +}

-- 
Sergey

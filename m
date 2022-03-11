Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 703B04D6A78
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiCKWxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiCKWwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:52:54 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7F71FAA09;
        Fri, 11 Mar 2022 14:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647037810; x=1678573810;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eSzmMIGIrJS+4e3ZKvdUQ77kDCTP3HKCm91gyCJ4/t8=;
  b=FKUSbuaKNP96sLPUlt051heKQ2+gvWH849xlgwhio9uXEZnQR/p8wHDO
   qud3LtOzo2TTGs+5bMnr6ulwaa8dCuQrmRHSTNItkIuUms6UXHIgTeZbr
   9AUEle94lAO5LtOnxcXuwU+EPFj5/nYXYQrQ98mH7hFrks+urWRg5is/k
   06s//plAh4EGUWVK5KKqwdmdABELyIxR7knb3vdg48mP2eKDQARLNRGpb
   hZNrxJgNG7mm91380YmKeHvDIKefGmkiB1DuXkDqTgUqxnvy65Jobx2QT
   IgewapnbYoBbjzUw7xlPFRKuSdWyGqOrnzveyFQj/30pykfSdOenNdJm0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="235611598"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="235611598"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:41:59 -0800
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="612278197"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.194.234]) ([10.212.194.234])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 13:41:58 -0800
Message-ID: <682d7215-4a46-5e30-60e4-dceaa4172aac@linux.intel.com>
Date:   Fri, 11 Mar 2022 13:41:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 06/13] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
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
 <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
 <CAHNKnsSZ_2DAPQRsa45VZZ1UYD6mga_T0jfX_J+sb1HNCwpOPA@mail.gmail.com>
 <5cf76041-77be-2651-f421-ad2521966570@linux.intel.com>
 <CAHNKnsQ2mKzVNyH+cyw4k+U1PXNz-dB8a0YfqSYqtBAROAwAmg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsQ2mKzVNyH+cyw4k+U1PXNz-dB8a0YfqSYqtBAROAwAmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/9/2022 4:13 PM, Sergey Ryazanov wrote:
> On Wed, Mar 9, 2022 at 3:02 AM Martinez, Ricardo
> <ricardo.martinez@linux.intel.com> wrote:
>> On 3/6/2022 6:56 PM, Sergey Ryazanov wrote:
>>> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
>>> <ricardo.martinez@linux.intel.com> wrote:
>>>> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>>>>
>>>> Adds AT and MBIM ports to the port proxy infrastructure.
>>>> The initialization method is responsible for creating the corresponding
>>>> ports using the WWAN framework infrastructure. The implemented WWAN port
>>>> operations are start, stop, and TX.
>>> [skipped]
>>>
>>>> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>>>> +{
>>>> +       struct t7xx_port *port_private = wwan_port_get_drvdata(port);
>>>> +       size_t actual_len, alloc_size, txq_mtu = CLDMA_MTU;
>>>> +       struct t7xx_port_static *port_static;
>>>> +       unsigned int len, i, packets;
>>>> +       struct t7xx_fsm_ctl *ctl;
>>>> +       enum md_state md_state;
>>>> +
>>>> +       len = skb->len;
>>>> +       if (!len || !port_private->rx_length_th || !port_private->chan_enable)
>>>> +               return -EINVAL;
>>>> +
>>>> +       port_static = port_private->port_static;
>>>> +       ctl = port_private->t7xx_dev->md->fsm_ctl;
>>>> +       md_state = t7xx_fsm_get_md_state(ctl);
>>>> +       if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
>>>> +               dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
>>>> +                        port_static->name, md_state);
>>>> +               return -ENODEV;
>>>> +       }
>>>> +
>>>> +       alloc_size = min_t(size_t, txq_mtu, len + CCCI_HEADROOM);
>>>> +       actual_len = alloc_size - CCCI_HEADROOM;
>>>> +       packets = DIV_ROUND_UP(len, txq_mtu - CCCI_HEADROOM);
>>>> +
>>>> +       for (i = 0; i < packets; i++) {
>>>> +               struct ccci_header *ccci_h;
>>>> +               struct sk_buff *skb_ccci;
>>>> +               int ret;
>>>> +
>>>> +               if (packets > 1 && packets == i + 1) {
>>>> +                       actual_len = len % (txq_mtu - CCCI_HEADROOM);
>>>> +                       alloc_size = actual_len + CCCI_HEADROOM;
>>>> +               }
>>> Why do you track the packet number? Why not track the offset in the
>>> passed data? E.g.:
>>>
>>> for (off = 0; off < len; off += chunklen) {
>>>       chunklen = min(len - off, CLDMA_MTU - sizeof(struct ccci_header);
>>>       skb_ccci = alloc_skb(chunklen + sizeof(struct ccci_header), ...);
>>>       skb_put_data(skb_ccci, skb->data + off, chunklen);
>>>       /* Send skb_ccci */
>>> }
>> Sure, I'll make that change.
>>
>>>> +               skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
>>>> +               if (!skb_ccci)
>>>> +                       return -ENOMEM;
>>>> +
>>>> +               ccci_h = skb_put(skb_ccci, sizeof(*ccci_h));
>>>> +               t7xx_ccci_header_init(ccci_h, 0, actual_len + sizeof(*ccci_h),
>>>> +                                     port_static->tx_ch, 0);
>>>> +               skb_put_data(skb_ccci, skb->data + i * (txq_mtu - CCCI_HEADROOM), actual_len);
>>>> +               t7xx_port_proxy_set_tx_seq_num(port_private, ccci_h);
>>>> +
>>>> +               ret = t7xx_port_send_skb_to_md(port_private, skb_ccci);
>>>> +               if (ret) {
>>>> +                       dev_kfree_skb_any(skb_ccci);
>>>> +                       dev_err(port_private->dev, "Write error on %s port, %d\n",
>>>> +                               port_static->name, ret);
>>>> +                       return ret;
>>>> +               }
>>>> +
>>>> +               port_private->seq_nums[MTK_TX]++;
>>> Sequence number tracking as well as CCCI header construction are
>>> common operations, so why not move them to t7xx_port_send_skb_to_md()?
>> Sequence number should be set as part of CCCI header construction.
>>
>> I think it's a bit more readable to initialize the CCCI header right
>> after the corresponding skb_put(). Not a big deal, any thoughts?
> I do not _think_ creating the CCCI header in the WWAN or CTRL port
> functions is any good idea. In case of stacked protocols, each layer
> should create its own header, pass the packet down the stack, and then
> a next layer will create a next header.
>
> In case of the CTRL port, this means that the control port code should
> take an opaque data block from an upper layer (e.g. features request),
> prepend it with a control msg header, and pass it down the stack to
> the port proxy layer, where the CCCI header will be prepended.
>
> In case a WWAN port, all headers are passed from user space, so there
> шы nothing to prepend. And the only remaining function is to fragment
> a user input, and then pass all  the fragments to the port proxy
> layer, where the CCCI header will be prepended.
>
> This way, you do not overload the CTRL/WWAN port with code of other
> protocols (i.e. CCCI), reduce code duplication. Which in itself
> improves the code maintainability and future development. Creating a
> CCCI header at the WWAN port layer is like forcing a user to manually
> create IP and UDP headers before writing a data block into a network
> socket :)
>
> Anyway, it is up to you to decide exactly how to create headers and
> assign sequence numbers. I just wanted to point out the code
> inconsistency. It does not make the code wrong, it just makes the code
> look stranger.
Agree, the next iteration will implement a layered approach.
>> Note that the upcoming fw update feature doesn't require a CCCI header,
>> so we could rename the TX function as t7xx_port_send_ccci_skb_to_md(),
>> this would give a hint that it is taking care of the CCCI header.
> Does this mean the firmware upgrade does not utilize the channel id,
> and just pushes data directly to a specific CLDMA queue? In that case
> it looks like the firmware upgrade code needs to entirely bypass the
> port proxy layer and communicate directly with CLDMA. Isn't it?

It could bypass port proxy, or it could use a new helper function 
implemented for the layered approach, this function 
(t7xx_port_send_raw_skb) sends an skb to the right CLDMA instance and 
queue based on the port configuration.

>
>>>> +       }
>>>> +
>>>> +       dev_kfree_skb(skb);
>>>> +       return 0;
>>>> +}

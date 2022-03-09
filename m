Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5214D27AA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiCICLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 21:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiCICLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 21:11:38 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A28C7C01;
        Tue,  8 Mar 2022 18:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646791836; x=1678327836;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y60x8KUwwQm0CqhHOHK2veCE1Sb6qltC5mrj1VlLcbI=;
  b=nMhSNgpEsTLQiTqcGJR5kJc58zUvaEIDzdiSQX1kr+qdrPn9xnEb+xCa
   Hsd/N9b/4roaRNzzPDpMi8ulkixOOGVaSSnC/JZqefPLy7glxG7BuWZqE
   +8IqfKMjW8QBHQYUukNUf1mnocfIM/99isria1XVP5xIRYM1R2SMQNB+w
   +cL/okTNSsgn//cTFZ7J4jl6EChWVweoWHLYHR83STCvPCSgstLO5LeFd
   iVvfh1sSostWBm57nGtPE/ElDyG7CqGyllKdHZWCI1GMWHgc880kxh9KQ
   /HfRuwN9na03d5FhQQkJeplS26x37Y+tN+cq+4g3O0PdK4f4dgZ4uh3U6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="254575859"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="254575859"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 16:01:56 -0800
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="632420326"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.212.205.123]) ([10.212.205.123])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 16:01:54 -0800
Message-ID: <5cf76041-77be-2651-f421-ad2521966570@linux.intel.com>
Date:   Tue, 8 Mar 2022 16:01:53 -0800
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
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsSZ_2DAPQRsa45VZZ1UYD6mga_T0jfX_J+sb1HNCwpOPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/6/2022 6:56 PM, Sergey Ryazanov wrote:
> On Thu, Feb 24, 2022 at 1:35 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
>> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
>>
>> Adds AT and MBIM ports to the port proxy infrastructure.
>> The initialization method is responsible for creating the corresponding
>> ports using the WWAN framework infrastructure. The implemented WWAN port
>> operations are start, stop, and TX.
> [skipped]
>
>> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
>> +{
>> +       struct t7xx_port *port_private = wwan_port_get_drvdata(port);
>> +       size_t actual_len, alloc_size, txq_mtu = CLDMA_MTU;
>> +       struct t7xx_port_static *port_static;
>> +       unsigned int len, i, packets;
>> +       struct t7xx_fsm_ctl *ctl;
>> +       enum md_state md_state;
>> +
>> +       len = skb->len;
>> +       if (!len || !port_private->rx_length_th || !port_private->chan_enable)
>> +               return -EINVAL;
>> +
>> +       port_static = port_private->port_static;
>> +       ctl = port_private->t7xx_dev->md->fsm_ctl;
>> +       md_state = t7xx_fsm_get_md_state(ctl);
>> +       if (md_state == MD_STATE_WAITING_FOR_HS1 || md_state == MD_STATE_WAITING_FOR_HS2) {
>> +               dev_warn(port_private->dev, "Cannot write to %s port when md_state=%d\n",
>> +                        port_static->name, md_state);
>> +               return -ENODEV;
>> +       }
>> +
>> +       alloc_size = min_t(size_t, txq_mtu, len + CCCI_HEADROOM);
>> +       actual_len = alloc_size - CCCI_HEADROOM;
>> +       packets = DIV_ROUND_UP(len, txq_mtu - CCCI_HEADROOM);
>> +
>> +       for (i = 0; i < packets; i++) {
>> +               struct ccci_header *ccci_h;
>> +               struct sk_buff *skb_ccci;
>> +               int ret;
>> +
>> +               if (packets > 1 && packets == i + 1) {
>> +                       actual_len = len % (txq_mtu - CCCI_HEADROOM);
>> +                       alloc_size = actual_len + CCCI_HEADROOM;
>> +               }
> Why do you track the packet number? Why not track the offset in the
> passed data? E.g.:
>
> for (off = 0; off < len; off += chunklen) {
>      chunklen = min(len - off, CLDMA_MTU - sizeof(struct ccci_header);
>      skb_ccci = alloc_skb(chunklen + sizeof(struct ccci_header), ...);
>      skb_put_data(skb_ccci, skb->data + off, chunklen);
>      /* Send skb_ccci */
> }
Sure, I'll make that change.
>> +               skb_ccci = __dev_alloc_skb(alloc_size, GFP_KERNEL);
>> +               if (!skb_ccci)
>> +                       return -ENOMEM;
>> +
>> +               ccci_h = skb_put(skb_ccci, sizeof(*ccci_h));
>> +               t7xx_ccci_header_init(ccci_h, 0, actual_len + sizeof(*ccci_h),
>> +                                     port_static->tx_ch, 0);
>> +               skb_put_data(skb_ccci, skb->data + i * (txq_mtu - CCCI_HEADROOM), actual_len);
>> +               t7xx_port_proxy_set_tx_seq_num(port_private, ccci_h);
>> +
>> +               ret = t7xx_port_send_skb_to_md(port_private, skb_ccci);
>> +               if (ret) {
>> +                       dev_kfree_skb_any(skb_ccci);
>> +                       dev_err(port_private->dev, "Write error on %s port, %d\n",
>> +                               port_static->name, ret);
>> +                       return ret;
>> +               }
>> +
>> +               port_private->seq_nums[MTK_TX]++;
> Sequence number tracking as well as CCCI header construction are
> common operations, so why not move them to t7xx_port_send_skb_to_md()?

Sequence number should be set as part of CCCI header construction.

I think it's a bit more readable to initialize the CCCI header right 
after the corresponding skb_put(). Not a big deal, any thoughts?

Note that the upcoming fw update feature doesn't require a CCCI header, 
so we could rename the TX function as t7xx_port_send_ccci_skb_to_md(), 
this would give a hint that it is taking care of the CCCI header.
>> +       }
>> +
>> +       dev_kfree_skb(skb);
>> +       return 0;
>> +}
> --
> Sergey

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7D350F26B
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 09:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343966AbiDZHdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343964AbiDZHdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:33:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B78B13E05;
        Tue, 26 Apr 2022 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650958207; x=1682494207;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=wKObrh7fSqP3n86ZK/ItNBIaS4Oe4iZY4KItAxqxkks=;
  b=ktjkc46yn9UwCsW4lCls/kWWVbYfUAx9lBqtOphMD3mEgMfnI+iTKBRl
   +myQSawtGUcp9siXAvbKmX4GHU2z9ydzgqU/kmsJMTcnfU2AnWjpxAsUM
   dkfGsqh4oSONDPipqPUfpY/TPo9Zh01MrK9scJiP6P71ksZEOt3I2VHrF
   siO4t0MkyIB9bJBdQAy2bWa64TB6yMhNVRZ1z45vWCzgwulm21pLttAZh
   5tAGUHjNHfDjXkLeH1bPj6W32OXmeChyDsL7b7bc8cZQ+eRXSqv7U5cOY
   hPCGlCkozOxz6nwr9+0QuVxWOZ4HdQ8SItOvvGm4wklkfyBmAidKZtXSh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265650207"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="265650207"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 00:30:06 -0700
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="579735322"
Received: from mmilkovx-mobl.amr.corp.intel.com ([10.249.47.245])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 00:30:00 -0700
Date:   Tue, 26 Apr 2022 10:29:55 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?GB2312?Q?Haijun_Liu_=28=C1=F5=BA=A3=BE=FC=29?= 
        <haijun.liu@mediatek.com>, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v6 08/13] net: wwan: t7xx: Add data path
 interface
In-Reply-To: <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
Message-ID: <d829315b-79ca-ff88-c76-e352d8fb5b5b@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-9-ricardo.martinez@linux.intel.com> <CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022, Sergey Ryazanov wrote:

> On Fri, Apr 8, 2022 at 1:37 AM Ricardo Martinez
> <ricardo.martinez@linux.intel.com> wrote:
> > Data Path Modem AP Interface (DPMAIF) HIF layer provides methods
> > for initialization, ISR, control and event handling of TX/RX flows.
> >
> > DPMAIF TX
> > Exposes the 'dmpaif_tx_send_skb' function which can be used by the
> > network device to transmit packets.
> > The uplink data management uses a Descriptor Ring Buffer (DRB).
> > First DRB entry is a message type that will be followed by 1 or more
> > normal DRB entries. Message type DRB will hold the skb information
> > and each normal DRB entry holds a pointer to the skb payload.
> >
> > DPMAIF RX
> > The downlink buffer management uses Buffer Address Table (BAT) and
> > Packet Information Table (PIT) rings.
> > The BAT ring holds the address of skb data buffer for the HW to use,
> > while the PIT contains metadata about a whole network packet including
> > a reference to the BAT entry holding the data buffer address.
> > The driver reads the PIT and BAT entries written by the modem, when
> > reaching a threshold, the driver will reload the PIT and BAT rings.
> >
> > Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> > Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> > Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> > Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> >
> > From a WWAN framework perspective:
> > Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> 
> Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> 
> and a small question below.
> 
> > diff --git a/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c b/drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c
> > ...
> > +static bool t7xx_alloc_and_map_skb_info(const struct dpmaif_ctrl *dpmaif_ctrl,
> > +                                       const unsigned int size, struct dpmaif_bat_skb *cur_skb)
> > +{
> > +       dma_addr_t data_bus_addr;
> > +       struct sk_buff *skb;
> > +       size_t data_len;
> > +
> > +       skb = __dev_alloc_skb(size, GFP_KERNEL);
> > +       if (!skb)
> > +               return false;
> > +
> > +       data_len = skb_end_pointer(skb) - skb->data;
> 
> Earlier you use a nice t7xx_skb_data_area_size() function here, but
> now you opencode it. Is it a consequence of t7xx_common.h removing?
> 
> I would even encourage you to make this function common and place it
> into include/linux/skbuff.h with a dedicated patch and call it
> something like skb_data_size(). Surprisingly, there is no such helper
> function in the kernel, and several other drivers will benefit from
> it:

I agree other than the name. IMHO, skb_data_size sounds too much "data 
size" which it exactly isn't but just how large the memory area is (we 
already have "datalen" anyway and on language level, those two don't sound 
different at all). The memory area allocated may or may not have actual 
data in it, I suggested adding "area" into it.


-- 
 i.


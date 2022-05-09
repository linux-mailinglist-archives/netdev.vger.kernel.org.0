Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE7E52057C
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240692AbiEITyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiEITyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946C21BB9B3;
        Mon,  9 May 2022 12:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30E5B61684;
        Mon,  9 May 2022 19:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA530C385B6;
        Mon,  9 May 2022 19:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652125810;
        bh=9o1gMbiwPZEcGhhb1bc9TVarD6lGPtAQk+yjDxMyoL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wu9QT56XiwYqRuZTwO5MM9ZyLTFuNoEuVHQtvdfHEB13nqfOtGdq/NKYMD1AVnagH
         Ibmon2ucaLm5Q53L1ndd85HrPRkhv55expLU6aaeUEPHwnJknvk5i9qmrOApC+eMeb
         WKlarnNTmnHB+sHLLyWpdNP0DnH9Z9MAGdunvrDciRtI9zLOnLvAsQWiUP34rU12wG
         Vx+rZQxxZFf7Fa+Gqmh/UJUAautCxVUzMCDjh41xwRirf+zlowckwnHVCMzv7MS/ef
         0eXmEwT5+ZAh3wIZpn4Qt+h52rHPhm9gboA+5UhfxJAgkEGOh8Fy+k/suvBh6a5yhf
         3ZAZZgW8oR08w==
Date:   Mon, 9 May 2022 12:50:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        "Haijun Liu ( =?UTF-8?B?5YiY5rW35Yab?=) " <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
Subject: Re: [PATCH net-next v8 02/14] net: skb: introduce
 skb_data_area_size()
Message-ID: <20220509125008.6d1c3b9b@kernel.org>
In-Reply-To: <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
        <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
        <20220509094930.6d5db0f8@kernel.org>
        <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 21:34:58 +0300 Sergey Ryazanov wrote:
> >> +static inline unsigned int skb_data_area_size(struct sk_buff *skb)
> >> +{
> >> +     return skb_end_pointer(skb) - skb->data;
> >> +}  
> >
> > Not a great name, skb->data_len is the length of paged data.
> > There is no such thing as "data area", data is just a pointer
> > somewhere into skb->head.  
> 
> What name would you recommend for this helper?

We are assuming that skb->data is where we want to start to write
to so we own the skb. If it's a fresh skb skb->data == skb->tail. 
If it's not fresh but recycled - skb->data is presumably reset
correctly, and then skb_reset_tail_pointer() has to be called. Either
way we give HW empty skbs, tailroom is an existing concept we can use.

> > Why do you need this? Why can't you use the size you passed
> > to the dev_alloc_skb() like everyone else?  
> 
> It was I who suggested to Ricardo to make this helper a common
> function [1]. So let me begin the discussion, perhaps Ricardo will add
> to my thoughts as the driver author.
> 
> There are many other places where authors do the same but without a
> helper function:
> 
> [...]
>
> There are at least two reasons to evaluate the linear data size from skb:
> 1) it is difficult to access the same variable that contains a size
> during skb allocation (consider skb in a queue);

Usually all the Rx skbs on the queue are equally sized so no need to
save the length per buffer, but perhaps that's not universally true.

> 2) you may not have access to an allocation size because a driver does
> not allocate that skb (consider a xmit path).

On Tx you should only map the data that's actually populated, for that
we have skb_headlen().

> Eventually you found themself in a position where you need to carry
> additional info along with skb. But, on the other hand, you can simply
> calculate this value from the skb pointers themselves.
> 
> 1. https://lore.kernel.org/netdev/CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com/

Fair enough, I didn't know more drivers are doing this.

We have two cases:
 - for Tx - drivers should use skb_headlen();
 - for Rx - I presume we are either dealing with fresh or correctly
   reset skbs, so we can use skb_tailroom().

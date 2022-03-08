Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678914D0CF3
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 01:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243222AbiCHArE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 19:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiCHArD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 19:47:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5500B7C7;
        Mon,  7 Mar 2022 16:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646700367; x=1678236367;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ttov+fXKUsuYJLzP7ap1uGkifbfnjwJFlpN+xvPS9FQ=;
  b=HpuVKYnqMtvcYphVOQl7YTOYIrjEGBNGjx3lFAJ5NK55FFEmee/ga5Xf
   jNhLGBJGiOjF4GMCoKPwdMR5sDCurFAR9kZn4fT+pm0PVUlgla69ObH2o
   qwsp5x/FPnFalyUDk5ilwO31/kPqAU2fqn5NamqBVL6qBav2v+3nD6Ye6
   zZ9mEbbdNIIkuwEc/NCKKlxR0B6XJsM+AgbCFSB0wvtIyuyB9JDPSzoR3
   v/fcM44/g8eKspP/OVnJWcCtlpJiQla799kr1V13fh4LDbtjCyuHyp5/a
   kBTvI0NdW6Wn/JGyAhKhxE+AMMS04eN5dRKhsESfo39VisXpjn6qCBx+I
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="279259849"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="279259849"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:46:07 -0800
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="512899246"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.251.10.64]) ([10.251.10.64])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 16:46:06 -0800
Message-ID: <d83e8fa4-a22f-6e3f-ec9d-16e798904efe@linux.intel.com>
Date:   Mon, 7 Mar 2022 16:46:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v5 02/13] net: wwan: t7xx: Add control DMA
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com>
 <20220223223326.28021-3-ricardo.martinez@linux.intel.com>
 <3867a1ee-9ff2-9afd-faf-ca5c31c0151d@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <3867a1ee-9ff2-9afd-faf-ca5c31c0151d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/25/2022 2:54 AM, Ilpo Järvinen wrote:
> On Wed, 23 Feb 2022, Ricardo Martinez wrote:
...
>> +/**
>> + * t7xx_cldma_send_skb() - Send control data to modem.
>> + * @md_ctrl: CLDMA context structure.
>> + * @qno: Queue number.
>> + * @skb: Socket buffer.
>> + *
>> + * Return:
> ...
>> + * * -EBUSY	- Resource lock failure.
> Leftover?

This function can still return -EBUSY if 
t7xx_pci_sleep_disable_complete() fails.

Maybe returning -ETIMED would make more sense based on the 
implementation of t7xx_pci_sleep_disable_complete().

>
> ...with those addressed
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>
>
> And kudos for rx_not_done -> pending_rx_int change. It was a minor
> thing for me but the logic is so much easier to understand now with
> that better name :-).
>
> Some other nice cleanups compared with v4 also noted.
>
>

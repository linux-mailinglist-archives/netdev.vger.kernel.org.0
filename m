Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183C82B4C2E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 18:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbgKPRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 12:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730296AbgKPRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 12:09:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D81CC0613CF;
        Mon, 16 Nov 2020 09:09:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=EwncCPVgoEMLud+9jtBYe/8a+f8uGYo+Rgy8BUzftI0=; b=lzUn4WrHyTxaD/I5ABbZJfjCOm
        VW1z9QoQnDd7tVY9GyV0g3xZRETNYlOQ0rhcYit+gG3DCL9/M8NQaMvzGBR41iM7mjlw4aM16Qij4
        IX7KAu4/EsI9O+FEMN+vcU6imZ/hdfP0Iuh0k5lgI0KTGtfyuBsHSPXaY+qUi3qS1IbIgtJUHVZf7
        gbpS5NUKbWe/W5M1Hi5h0L722p81DrqPgeXUkvUzOkeQr6bsyBV+I747osaW8j6I3gv2AG8OvTiin
        bfh5TP57ix9neGzq2qOM9yVyc5TmEpO58rjGjEXJlACVOtyg3gAkN3fewmTnhXrhmsRY+Z0a10lnV
        cW1UyNoQ==;
Received: from [2601:1c0:6280:3f0::f32]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehzw-00077a-AU; Mon, 16 Nov 2020 17:09:00 +0000
Subject: Re: [PATCH net-next v4] net: linux/skbuff.h: combine SKB_EXTENSIONS +
 KCOV handling
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org
References: <20201116031715.7891-1-rdunlap@infradead.org>
 <ffe01857-8609-bad7-ae89-acdaff830278@tessares.net>
 <20201116143121.GC22792@breakpoint.cc>
 <20201116073013.24d45385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <53e73344-3a3a-4a11-9914-8490efa1a3b9@infradead.org>
Date:   Mon, 16 Nov 2020 09:08:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201116073013.24d45385@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 7:30 AM, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 15:31:21 +0100 Florian Westphal wrote:
>>>> @@ -4151,12 +4150,11 @@ enum skb_ext_id {
>>>>   #if IS_ENABLED(CONFIG_MPTCP)
>>>>   	SKB_EXT_MPTCP,
>>>>   #endif
>>>> -#if IS_ENABLED(CONFIG_KCOV)
>>>>   	SKB_EXT_KCOV_HANDLE,
>>>> -#endif  
>>>
>>> I don't think we should remove this #ifdef: the number of extensions are
>>> currently limited to 8, we might not want to always have KCOV there even if
>>> we don't want it. I think adding items in this enum only when needed was the
>>> intension of Florian (+cc) when creating these SKB extensions.
>>> Also, this will increase a tiny bit some structures, see "struct skb_ext()".  
>>
>> Yes, I would also prefer to retrain the ifdef.
>>
>> Another reason was to make sure that any skb_ext_add(..., MY_EXT) gives
>> a compile error if the extension is not enabled.
> 
> Oh well, sorry for taking you down the wrong path Randy!

No problem.
So we are back to v2, right?
Do I need to resend that one?

thanks.
-- 
~Randy


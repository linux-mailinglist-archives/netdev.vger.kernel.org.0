Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CA02586C0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 06:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgIAETE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 00:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgIAETE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 00:19:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4725C0612FE
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:19:03 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ds1so74568pjb.1
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ax3cjPQFtoCXTia41zUFgQjl0WAQxP2tosymrfzQPTg=;
        b=TScWChG2qDbiQz7lDWFvy1gagfh8rsVfz9FCYIogyUbFCJtPHv7fnSAZcJuoPBJ8ti
         jfwWwwm2ljQ8kXvHjRvr6cpT3tSPkoPN9xkVBZ7Tvjy8YCRzdzaRJp96/RhiG4JfWllM
         C5Bz4ZlORyehzCVTww7OCqmMw21R9SdRuLQdzSTj3ZZhNG81vvTO9V23sACKtCZGE/6D
         HvLLOydsQXe2yFeFYk2J32OW992aiWEowXu4naSdzd8n77Vl8jUhVbePs2mMqHZfKuM0
         jtEb3CcO6K28qCRazvEDYQMzN1ZshpFMZyoEnm9wJC/DkfaTS1YbtrlyLH7CNNeZMMkQ
         da5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ax3cjPQFtoCXTia41zUFgQjl0WAQxP2tosymrfzQPTg=;
        b=pJBjI62p+l6IRXsLlT96yBuCjHeJm6dl8MH3i+rmUEojf43Ax5huNuzhYRp6AjbUFp
         yWA+n/5GJ+NbBLXHutK5qYGBlDpYptTXfdgHJ9jWAWC+wfkdA71p0m83zTG0bebOqaDl
         /XhpNlvfCqDGDQXVmRKyirdUBwv13CY0dbxsd8aEv8O2uswTBqVpyzFEfzdcKtv7TAkD
         u815bzIdZkHe4iBMdhVJ13XGBXKoQf6ClrScmshZonVR1jVeO5zdML7mrS0WX7K9K+6v
         u8unP9W1KzgbzDSwp/zOS2iFsxvrO7D2cEe9u8R+XhwPlnjS1z3Jptpm82DTdZug0CGg
         xAcw==
X-Gm-Message-State: AOAM532I+tNdTy/wS1im0IycBOYqQsqKq6jP9K/8eKUB3srAefGP/KWV
        fZ5GFUDzTXkNeHhVhh21SvE4Uw==
X-Google-Smtp-Source: ABdhPJytLtSyZcvnJjUiwJ5rWKc0rNwFUL8lrb3RKG11JVAsdY1ncCoVmMOdw0lBkp/I6n9aanb03g==
X-Received: by 2002:a17:90b:2341:: with SMTP id ms1mr36970pjb.80.1598933943244;
        Mon, 31 Aug 2020 21:19:03 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id n1sm9820225pfu.154.2020.08.31.21.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 21:19:02 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] ionic: clean up page handling code
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, neel@pensando.io
References: <20200831233558.71417-1-snelson@pensando.io>
 <20200831233558.71417-2-snelson@pensando.io>
 <20200831.171454.2235150331629306394.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7ba34f16-dff9-12bb-889e-b9542740f19a@pensando.io>
Date:   Mon, 31 Aug 2020 21:19:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200831.171454.2235150331629306394.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 5:14 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Mon, 31 Aug 2020 16:35:54 -0700
>
>> @@ -100,6 +100,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>>   		frag_len = min(len, (u16)PAGE_SIZE);
>>   		len -= frag_len;
>>   
>> +		dma_sync_single_for_cpu(dev, dma_unmap_addr(page_info, dma_addr),
>> +					len, DMA_FROM_DEVICE);
>>   		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>>   			       PAGE_SIZE, DMA_FROM_DEVICE);
>>   		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> The unmap operation performs a sync, if necessary, for you.
>
> That's the pattern of usage:
>
> 	map();
> 	device read/write memory
> 	unmap();
>
> That's it, no more, no less.
>
> The time to use sync is when you want to maintain the mapping and keep
> using it.

Thanks, I'll drop that part.
sln

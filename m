Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C944354528
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbhDEQ2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbhDEQ2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:28:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08230C061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 09:28:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y2so5921886plg.5
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 09:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=pJ/sTXb40aVRvwtnarKWOPi5GQ7A30VKT2lH5CND+hg=;
        b=wDNwNSYbQVFtEP8fGF2bbinSIFfs3U08GyigFWkguRzWzVKQUk6qiIf0+tY2siwmvV
         SZPFl2ijddaaXOj6AqVHGuVxEu7p5EPdbiJdAV3C+wt/8K5T1ujJSaFmNIrnmqGRlyYU
         vDKQvEgZnevZgBkL674dy1p2muApZhjS2u2zwTkOfOBhyps+NCU5+0qGgNGmJ/Ol6Tlp
         xiMKE6p38mm4M1jLFfZwlDbKz8DIzZf2jyt6mjz/he+mqUavucFsprEB/M7VMbbJlDSv
         QVkUYZ3OynnLFC83lzgB4WYTOmPX148CKNit38tWP481yQrZ9obpv0PBkHDpENjgKpRX
         mdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pJ/sTXb40aVRvwtnarKWOPi5GQ7A30VKT2lH5CND+hg=;
        b=fHXaBje9f8pg154pHVRiVc3MJsC1nI92+HWdRf4CzAxT0QzW2tvgi7jHjyHY6XPb4y
         L883bnaCjAUd5mwR/Ase/imtbPMOWM9lSjEsHX1JPaDM2jZ3XHE+VGsJ0huagoPsreMS
         ZxBX/gQYBP+rnNLh4fsLtAv3CHponEOzqQZO5PUOO2nDM64z4dhaJQPB0TD5x72Wwicw
         EMSN43UJKOWcRBfD3nRtq3EcH6cMbWboH/5nW4FqkhstlgbuE8VXtQkPMybdjimufOox
         ZUwRee29IuD0WenugekRTLj8D5v0LCXSv9IOEeGNnz/gGXxuGHQKxukfoRfkU8RbP5u9
         WK7w==
X-Gm-Message-State: AOAM533YL+F7JvEYvnWS4wi/qp9KfTf0iAlA7VfnhcQ7M/BWcpSRz4pj
        fwm+H9u7Ow4bUsLGokeNYVx+zpeT2yUpuA==
X-Google-Smtp-Source: ABdhPJwRiH/nS9m8b8RECJfXdFU++vAE1Xuvtq86M2+Q4RP7mErThVKMbimE0A84Sr0e+KPZ16BiOA==
X-Received: by 2002:a17:902:704b:b029:e9:b5e:5333 with SMTP id h11-20020a170902704bb02900e90b5e5333mr5700688plt.78.1617640126586;
        Mon, 05 Apr 2021 09:28:46 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id s26sm16041013pfd.5.2021.04.05.09.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:28:45 -0700 (PDT)
Subject: Re: [PATCH net-next 09/12] ionic: add and enable tx and rx timestamp
 handling
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-10-snelson@pensando.io>
 <20210404234107.GD24720@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <6e0e4d73-f436-21c0-59fe-ee4f5c133f95@pensando.io>
Date:   Mon, 5 Apr 2021 09:28:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404234107.GD24720@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 4:41 PM, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:07AM -0700, Shannon Nelson wrote:
>
>> @@ -1150,6 +1232,10 @@ netdev_tx_t ionic_start_xmit(struct sk_buff *skb, struct net_device *netdev)
>>   		return NETDEV_TX_OK;
>>   	}
>>   
>> +	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
>> +		if (lif->hwstamp_txq)
>> +			return ionic_start_hwstamp_xmit(skb, netdev);
> The check for SKBTX_HW_TSTAMP and hwstamp_txq is good, but I didn't
> see hwstamp_txq getting cleared in ionic_lif_hwstamp_set() when the
> user turns off Tx time stamping via the SIOCSHWTSTAMP ioctl.

Once the hwstamp queues are up, we leave them there for future use until 
the interface is stopped, assuming that the stack isn't going to send us 
SKBTX_HW_STAMP after it has disabled the offload.

>
> In addition, the code should set
>
> 	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
>
> once the above tests pass.

I can add that in a followup patch.

Thanks,
sln

>
> Thanks,
> Richard
>
>


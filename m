Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B88361190
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhDOSAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhDOSAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:00:41 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3F0C061574;
        Thu, 15 Apr 2021 11:00:16 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so5573850oop.12;
        Thu, 15 Apr 2021 11:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uCTgNUtrQaN47ypy4tlXXz/Fqi8+o6qT6fOZMZagGcw=;
        b=nMFZ/OL7qNpHZzONQgpskAMU2rJwmvJSnPP/c3MXcgBlksmsSXUhXJOFkk0h8qujs4
         MrGJeKQi3/XiGZfVsN+Id8MmIXRrpzrON5VWyhp+FXdeglX27qTnQ7h2BVrm5ptDH3fw
         o5iI3aB/WfBEZQaad1aiEefb3gHYH8RRxf7mdQpLGVDk/ylYKzHmkL81YEnQhAF3gKvA
         U4y4QsqPTGUeHW+a5t6JNjZfOs1ZBYY+PTaFtAK5USuu4YHmLRk5ksI32/2MA7/YtKk/
         1NZB+RV2itpbq/IUPx74jO0nT8Ph6h5Sfyxbn2P8AFm7ElTA+82CwbXFonQFWWd0gbHR
         L5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uCTgNUtrQaN47ypy4tlXXz/Fqi8+o6qT6fOZMZagGcw=;
        b=IVGXGOIenZ9uW1hTfSzrP/LAiKDnVN8NB8v5X8IRyO6q7H4I9rKFwMQ2iN924ynxPL
         h2a+2ulCvpfP+lFFLoL1YfOZCzUUxLjYJtAjLiuOsPyI3cJmQ3WmwYXak4HiLxa/ba+1
         1anxMedqu0UiynTQOcUkmpb5qqc2kd0YtYMHqP2yPKiiNrGpkGmw4xZ53hh9kVUIYk0S
         Qgf/xhJhfvzL86Ox8PngBS6+tNI2HqoLhjmiLErT4oHFNSWUWR+Z9xFceUWkfAEQu4DI
         gh9Ni8broLD9vjAfkZMIKqDf2sZuu3rfGC8bIFqeLdDkBUio57spm/S2mxbj2r418ogj
         Lhhw==
X-Gm-Message-State: AOAM532p85rTBocD3DGAneCrC9qsfpbpcs0S7DYD+Vezb4QWKXZ20Wt3
        TeQ/uVlmjJIR28RclKH/Rj1SiHReMkE=
X-Google-Smtp-Source: ABdhPJzskz6SKpTG6OSI6vcbvbVbR1R20AjrI8DTmF6340xaIC58QJh0RcEsILE01IaV7XH3DZ1AOA==
X-Received: by 2002:a4a:9e42:: with SMTP id w2mr330605ook.4.1618509614837;
        Thu, 15 Apr 2021 11:00:14 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.70])
        by smtp.googlemail.com with ESMTPSA id d17sm798298oth.19.2021.04.15.11.00.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 11:00:14 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, song@kernel.org
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
 <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
 <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com> <YHhj61rDPai8YKjL@lore-desk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7cbba160-c56a-8ec5-b9e1-455889bacb86@gmail.com>
Date:   Thu, 15 Apr 2021 11:00:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YHhj61rDPai8YKjL@lore-desk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 9:03 AM, Lorenzo Bianconi wrote:
>> On 4/15/21 8:05 AM, Daniel Borkmann wrote:
> 
> [...]
>>>> &stats);
>>>
>>> Given we stop counting drops with the netif_receive_skb_list(), we
>>> should then
>>> also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise it
>>> is rather
>>> misleading (as in: drops actually happening, but 0 are shown from the
>>> tracepoint).
>>> Given they are not considered stable API, I would just remove those to
>>> make it clear
>>> to users that they cannot rely on this counter anymore anyway.
>>>
>>
>> What's the visibility into drops then? Seems like it would be fairly
>> easy to have netif_receive_skb_list return number of drops.
>>
> 
> In order to return drops from netif_receive_skb_list() I guess we need to introduce
> some extra checks in the hot path. Moreover packet drops are already accounted
> in the networking stack and this is currently the only consumer for this info.
> Does it worth to do so?

right - softnet_stat shows the drop. So the loss here is that the packet
is from a cpumap XDP redirect.

Better insights into drops is needed, but I guess in this case coming
from the cpumap does not really aid into why it is dropped - that is
more core to __netif_receive_skb_list_core. I guess this is ok to drop
the counter from the tracepoint.

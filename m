Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F040116A6FF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbgBXNLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:11:05 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38470 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgBXNLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:11:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so9336467wmj.3
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 05:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=whMHJGEESkS15tQdqWjRLF76MTLJ0PmJzdnWG4lgHNw=;
        b=EiWJqRBAfxKHjnAM7BouwM2zRSe0kjr98Km1ltSNqqizAUkzjnZvuEGkZ1KKXb9xtq
         aaUpbietz7hagKA+PkwjSOzOf+3yDq6PLmFxBXJz01EEfmiBmSw4yfGurOS8ZdjPQNZE
         nwFDSLSA/NtbWHLRLHnLXSpU6NqE7luiuTF4eURjXpCjZ27JRMk4esYaGiHYsK/TrW6L
         mHzWdikpX0LB7n3dYgoZRxN0pZwwsi6TUuYbLzNF0uM4hU9onx1ebg9nWxWOj5ksBsWJ
         r+BMM+Se5mJj1cexVSt9Lp7pZJTtsZiLLwAh2C7DmUYA9AooV/6GK2l/ON6+fGPy3XtX
         BVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=whMHJGEESkS15tQdqWjRLF76MTLJ0PmJzdnWG4lgHNw=;
        b=nINMhf+pWZcbBNeh5igmASV24f6XibDmEkXOhcx7uxs2xQU9CkJc7cI91oud2PbaoE
         ieWMe5PpXWHXAj/LlHvRyt5oz4Jyu0US6MXV2XOwGEupznBuB31TbNJk08cPfk/O2WIz
         cPBMCHgUc4l9X7TW4nDfGNLhXQw4hQitiXrE3WTTYUpN2vErw5cohKiKkMGVQmpHxI5D
         jXthEYtXEba1hpTLFH05Va1jSPkaVkPMi7XEpAPVBcyLD5ct5iEaqyFonprKTsM+kkTF
         Sl8k5dEczFrvKLHxMSTdQENBgFf18sekeZB8EqlNBN6Qow/qgF2s2M/vxewbCcQGPHk5
         nWWw==
X-Gm-Message-State: APjAAAXlAO6RVn3vUpzm9pDfzqsTq1rjxAmn1zj40jpcVEJkjAzrwS0k
        MkUuUlD7YGvYH5w0oVkxbFCOvg==
X-Google-Smtp-Source: APXvYqxYqGFdsoE+6w5aVMh+Ig3Y4C0rsKsInCTyWeTdWhpG4crcnYpB7nqJRkgitUAgM/wXJ0+Ebw==
X-Received: by 2002:a7b:c249:: with SMTP id b9mr21322426wmj.61.1582549863095;
        Mon, 24 Feb 2020 05:11:03 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id g2sm17963221wrw.76.2020.02.24.05.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:11:02 -0800 (PST)
Date:   Mon, 24 Feb 2020 14:11:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200224131101.GC16270@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Feb 24, 2020 at 12:38:20PM CET, ecree@solarflare.com wrote:
>On 22/02/2020 06:38, Jiri Pirko wrote:
>> Fri, Feb 21, 2020 at 07:22:00PM CET, kuba@kernel.org wrote:
>>> Hmm, but the statistics are on actions, it feels a little bit like we
>>> are perpetuating the mistake of counting on filters here.
>> You are right, the stats in tc are per-action. However, in both mlxsw
>> and mlx5, the stats are per-filter. What hw_stats does is that it
>> basically allows the user to set the type for all the actions in the
>> filter at once.
>>
>> Could you imagine a usecase that would use different HW stats type for
>> different actions in one action-chain?
>Potentially a user could only want stats on one action and disable them
> on another.  For instance, if their action chain does delivery to the
> 'customer' and also mirrors the packets for monitoring, they might only
> want stats on the first delivery (e.g. for billing) and not want to
> waste a counter on the mirror.

Okay.


>
>> Plus, if the fine grained setup is ever needed, the hw_stats could be in
>> future easilyt extended to be specified per-action too overriding
>> the per-filter setup only for specific action. What do you think?
>I think this is improper; the stats type should be defined per-action in
> the uapi, even if userland initially only has UI to set it across the
> entire filter.  (I imagine `tc action` would grow the corresponding UI
> pretty quickly.)  Then on the driver side, you must determine whether
> your hardware can support the user's request, and if not, return an
> appropriate error code.
>
>Let's try not to encourage people (users, future HW & driver developers)
> to keep thinking of stats as per-filter entities.

Okay, but in that case, it does not make sense to have "UI to set it
across the entire filter". The UI would have to set it per-action too.
Othewise it would make people think it is per-filter entity.
But I guess the tc cmdline is chatty already an it can take other
repetitive cmdline options.

What do you think?


Thanks!

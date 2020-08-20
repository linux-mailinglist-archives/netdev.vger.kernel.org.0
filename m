Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4224BDC8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgHTNNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728821AbgHTNNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:13:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A092C061385;
        Thu, 20 Aug 2020 06:13:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o5so1124847pgb.2;
        Thu, 20 Aug 2020 06:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y98i18O2foTJlu6H0XakJVtjdpESc2Ki2h/a3V/WzHg=;
        b=AwjcyWB+fnfZsiELE1LughLq2XItPYPUVGJ9cIYN+lvC2lOWqbERVFNY0MkOTz1XmY
         e6fRrH9Irc8zjH2kSFr443jAEqAhKvO0g5ARrJZWo//fFwIUjdZaGKrux7bFsGbGKi1C
         WgjLC3nBad3EqHBaQ8xMhSzWXa1G4ltMPHuSc7xUwY+395qqk3KGpbaOqbMbcIFaV/zy
         GqZ9txVzPkL0xlz5ZxM0zmMKRYch8GqJf0YgAlxlPYU5leVwiymW+QM/J2YwgwzqzTAq
         +e1UMxQBflKQBDjIXF/nuBfUB/JJ5YacchBpRTuEP6U09xviEPGqfUOWILLo95oSeaIY
         iXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y98i18O2foTJlu6H0XakJVtjdpESc2Ki2h/a3V/WzHg=;
        b=McVGNrt5wQ3rbEvQUqPN7NN2Wfov8TfuwYrzMGQFkbggPzfefFOQT0Sk5Ql/mxoFYU
         LilgL6VyjjtBmrA6MJVtFNywUTXVuukxU6mZenErP/eMMFvX2pABcZeq7eEWB2ROAVnE
         ihJf3BhrdngYYk9FUmmHgVboZRvxPzQNXmk33nXWdqYa59BYa//jChQxGhCIeEj92gvW
         njlK+hTNuklmShbPAQJpN7iRT7kHKy3UYKkQHZjexHoXk93oDfjGhfifXFStKRe8iVeH
         7214fhFIm5dno6oFZjPrjrWOJ0PRM6y3uT+iCvitgSP27HpPUlSZzuZU2M1jssedK5JS
         WFhg==
X-Gm-Message-State: AOAM533lhj9zGDocZ7zI1C3hnvLSC/iY0qOeaAURR2zU9HsCd/IGgqH6
        G9TKj97q/rh4L0hYxR9NRr/lqhNsymg=
X-Google-Smtp-Source: ABdhPJz58ZOO/VQcLaiqe8bwVjSNTLTElTvKI3954cG/wMh0ryR5800ct+xVhLeNqQAu4pU5wApR/Q==
X-Received: by 2002:a63:7a19:: with SMTP id v25mr1243261pgc.386.1597929184100;
        Thu, 20 Aug 2020 06:13:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x136sm2974292pfc.28.2020.08.20.06.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 06:13:03 -0700 (PDT)
Subject: Re: [PATCH net] sctp: not disable bh in the whole
 sctp_get_port_local()
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
References: <b3da88b999373d2518ac52a9e1d0fcb935109ea8.1597906119.git.lucien.xin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <661ff148-627d-3b1f-f450-015dafefd137@gmail.com>
Date:   Thu, 20 Aug 2020 06:13:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <b3da88b999373d2518ac52a9e1d0fcb935109ea8.1597906119.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 11:48 PM, Xin Long wrote:
> With disabling bh in the whole sctp_get_port_local(), when
> snum == 0 and too many ports have been used, the do-while
> loop will take the cpu for a long time and cause cpu stuck:
> 
>   [ ] watchdog: BUG: soft lockup - CPU#11 stuck for 22s!
>   [ ] RIP: 0010:native_queued_spin_lock_slowpath+0x4de/0x940
>   [ ] Call Trace:
>   [ ]  _raw_spin_lock+0xc1/0xd0
>   [ ]  sctp_get_port_local+0x527/0x650 [sctp]
>   [ ]  sctp_do_bind+0x208/0x5e0 [sctp]
>   [ ]  sctp_autobind+0x165/0x1e0 [sctp]
>   [ ]  sctp_connect_new_asoc+0x355/0x480 [sctp]
>   [ ]  __sctp_connect+0x360/0xb10 [sctp]
> 
> There's no need to disable bh in the whole function of
> sctp_get_port_local. So fix this cpu stuck by removing
> local_bh_disable() called at the beginning, and using
> spin_lock_bh() instead.
> 
> The same thing was actually done for inet_csk_get_port() in
> Commit ea8add2b1903 ("tcp/dccp: better use of ephemeral
> ports in bind()").
> 
> Thanks to Marcelo for pointing the buggy code out.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---


Any reason you chose to not use a cond_resched() then ?

Clearly this function needs to yield, not only BH, but to other threads.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD0B34ED47
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3QNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhC3QNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:13:30 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF990C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:13:29 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id i6so4899918pgs.1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DHZ3uymJvGJN87q3+1H8w5ANstp2AzuWt3zz7s9SIW8=;
        b=XI4RWwxu6zG/DEeBZgDsKsoFzdG045MzJdjbDe6R9W9TCTSMETJ75f0UmZi1maj1IK
         /568KJzqvBzqw386YgzSRFHShMG3tdYm/ynI/hNbmH1kq+mnm3AUZNsC6Eup3qBUDcOj
         OAzfRnJgkQ7zjlYlemWrHY2sAGfw8DitP8BqilmKkfbgmA4UqKVCaNXYFsSXgoQQarl8
         zjH/z9rq7OkPXnzmff+SszAYmzb7l/Y0OQi0QsbtwhX4jNQ6QPdBeO/1U433EjKu/SYY
         uOkkY7WJHJdgCNdHoqnbcXzVCgKHVt0QmhvNBNTMmSX+3mTQPbHXsDQFzYU5lChb8pzd
         OOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DHZ3uymJvGJN87q3+1H8w5ANstp2AzuWt3zz7s9SIW8=;
        b=HT9Rx9VPrPVUBfYHQAOMUoQI14HDzmmCxB7K5L1fjjyi3Cqzc2zVtoybKJvJULqe1a
         D0hHEZoH3auincGb8mcR8ieUAS/GlzNcC4+h/yN+hffCR+WEzltNF0WTbpB4wd0vqLO5
         gLWeh1qgIY55LtyrZ6gqvzpaw0VR4YQ/ItQFXdHD0sfQgA1Q/wnVL4UR/jHgn9v+IgZd
         4FtAkZIzb22Bf/6tAie0ydVir1tI/LTDUY8MmCvtbci+gZ8O4r+JR2E0KF5X7tOzGfGb
         sDHswAhgugMsx8Ab0QN3zvOkVbNRzeS0EzlOurlJJ6Toc6mm4qf4tCABoj/fm+i260YA
         26kg==
X-Gm-Message-State: AOAM532bY/uo5jI3KI+cRxGdB9QzGVcMRsRC7Ez2AhOYvTKvAeKi9AyJ
        1VP4D6AMn9sHfseXswz6jFM=
X-Google-Smtp-Source: ABdhPJxiEi7Xnb/x9/DTjAYkapOdcEsJjY2I0YkPLYSFBMg4LG43U75k5lrdWbXc6tDhFJLlRKa9Ow==
X-Received: by 2002:aa7:8814:0:b029:21d:d2ce:7be with SMTP id c20-20020aa788140000b029021dd2ce07bemr29680610pfo.80.1617120809489;
        Tue, 30 Mar 2021 09:13:29 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 81sm21110770pfu.164.2021.03.30.09.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 09:13:29 -0700 (PDT)
Subject: Re: [PATCH net-next] mld: add missing rtnl_lock() in
 do_ipv6_getsockopt()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210330153106.31614-1-ap420073@gmail.com>
 <CANn89iJ1G8vU-Jw6gaTsZHamQv1ncLmoJ1FOop25OzrYmjh4kA@mail.gmail.com>
 <634ed5a7-eccc-3749-e386-841141a30038@gmail.com>
 <CANn89iKeeWLkzrrW8Yre+iHkbfL6kLR33vDae8y01Hfn-nz5_A@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <fd15f71e-1e91-210c-e067-9c0a43250bd8@gmail.com>
Date:   Wed, 31 Mar 2021 01:13:25 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKeeWLkzrrW8Yre+iHkbfL6kLR33vDae8y01Hfn-nz5_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 1:08 AM, Eric Dumazet wrote:
 > On Tue, Mar 30, 2021 at 6:02 PM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> On 3/31/21 12:40 AM, Eric Dumazet wrote:
 >>   > This seems a serious regression compared to old code (in net tree)
 >>   >
 >>   > Have you added RTNL requirement in all this code ?
 >>   >
 >>   > We would like to use RTNL only if strictly needed.
 >>
 >> Yes, I agree with you.
 >> This patchset actually relies on existed RTNL, which is
 >> setsockopt_needs_rtnl().
 >> And remained RTNL was replaced by mc_lock.
 >> So, this patchset actually doesn't add new RTNL except in this case.
 >>
 >> Fortunately, I think It can be replaced by RCU because,
 >> 1. ip6_mc_msfget() doesn't need the sleepable functions.
 >> 2. It is not the write critical section.
 >> So, RCU can be used instead of RTNL for ip6_mc_msfget().
 >> How do you think about it?
 >
 > Yes please, do not add RTNL here if we can avoid it.
 >
Okay, I will send a new patch.

 > Otherwise some applications will slow down the whole stack, even with
 > different containers/netns.
 >
 > (There is a single RTNL for the whole machine)
 >

Thanks a lot for the review!

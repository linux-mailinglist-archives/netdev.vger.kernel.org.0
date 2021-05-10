Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC363779B2
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 03:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJBTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 21:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhEJBTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 21:19:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F60C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 18:18:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ge1so8814864pjb.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 18:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RAc/UirCO0X0lR4WGBRY5U0tjWVnbbiZP3m8rg9vuug=;
        b=eJLxNVFgvuFFO0Flt84UKfFzeYCW9S3NFcMM7YuVH3265QIsvxMcJxxbc0667AMAtO
         8N+rBSvLAl84ECcXTY1WcZ6kyTjaV3QsWcjxU1n6JuGJG+PsY8HXd7NUzPt0vCT//JGI
         urPp2imP8Wn+knHlLJK3DfZv4eLubcWXYbQkd2QNBDgmQ8O12Dsoho89sPHX5ReBptud
         1zSCb7iKaGiuOY4sZtZtk9A7zhMkzqqsjA5oKJn7UaeDS0cw8K+psuXAUKNyqz9wihm9
         uffOZhVvD0Ys/lRoG2ERnkS0dP8ONCABI3I07fEUFoUdD2Cka3JXd3focdJBz8XmaSUD
         /0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAc/UirCO0X0lR4WGBRY5U0tjWVnbbiZP3m8rg9vuug=;
        b=pE60EEYCR/AzdwK07czAnb3S5KToyEFwivZCpatrT2RL/jwRE7ZRVvRsyBEyEUn+sH
         7fLI5wpyRYssYgVzX5Rr00qr9NJYR/J/v6ZwELZd/YxW8s9VYAsSo+G7HYv14MKlHSNg
         pIrslfEBcazQdOj5g8bCL2BiYtJwbAHSnuFxp41ySAgZ6MtKzW2YRiHU/nTdMhXcn0hV
         19ZGm8xZYUfGCLZXBc+aia0PclC7xMtZ6UiuaLTqaWf5FJ2KQJrpWZ0/kBz77ZTrTKkW
         d5neprFVWXRj33gTeDcZPUcbwSoDlPtchpNQPLN6pAHO0dAFryu3A0BPT9vPvagHnLjJ
         MABQ==
X-Gm-Message-State: AOAM532d93wtfkVLW3GTLs3iO0D+qE2/Ghxtj9KLszBtsL+FPC/EE16l
        4ivp8pE7G4eIe8f9mcA36zg=
X-Google-Smtp-Source: ABdhPJwG0clmZdK9PSfYCH0YxO4gnPDLAkgc2tC0BzT6OEN+jQ+JG26EV+ipW1dd+XqkLqbZQgcSaQ==
X-Received: by 2002:a17:902:7444:b029:ed:5334:40b6 with SMTP id e4-20020a1709027444b02900ed533440b6mr21443110plt.35.1620609522870;
        Sun, 09 May 2021 18:18:42 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e23sm9664103pfd.104.2021.05.09.18.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 18:18:42 -0700 (PDT)
Subject: Re: [PATCH net] net: dsa: fix error code getting shifted with 4 in
 dsa_slave_get_sset_count
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210509115513.4121549-1-olteanv@gmail.com>
 <53834b37-16c5-2d1d-ab72-78f699603dca@gmail.com>
 <CA+h21hoKocOhidF_wNaQhOgiq_KqMsi4LJisdPTkEiWo3x4ZDA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <01a3fd41-5f53-a5fd-ccd6-f65827626ea0@gmail.com>
Date:   Sun, 9 May 2021 18:18:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+h21hoKocOhidF_wNaQhOgiq_KqMsi4LJisdPTkEiWo3x4ZDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2021 2:54 PM, Vladimir Oltean wrote:
> On Sun, May 09, 2021 at 10:35:27AM -0700, Florian Fainelli wrote:
>> On 5/9/2021 4:55 AM, Vladimir Oltean wrote:
>> I would have a preference for keeping the count variable and treating it
>> specifically in case it is negative.
> 
> Thanks. I hope I've understood you correctly that renaming "err" back to
> "count" was all that you were asking for. Anyway, patch is superseded by
> https://patchwork.kernel.org/project/netdevbpf/patch/20210509193338.451174-1-olteanv@gmail.com/

You did, thanks for the quick spin.
-- 
Florian

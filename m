Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6D13B4F44
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 17:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFZPrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 11:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhFZPrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 11:47:06 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAFFC061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 08:44:42 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h17so17779634edw.11
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 08:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZ8IGPIHs4CXPcgNEwFSxGDvp7LnLJfqRLnAqdPtDrE=;
        b=DJszL1bTAIZSp/kMzOOvLRMLVCG4z6nF9HGFs7xj7Gf/e/iNRpMjGQe5iP/0DG+kj0
         2WRYDp2+lEGPq9fdvnhff6mv4FFF4rsJZxqz3RSq5jwMvX7NeHlG89nFFPMBZNp6Ikk4
         gV43xW+Xho9Mg/6SDFwwMjEOsiCetGgEXBsOUE5OjKJ0bZU9adgcQpvxhHFzSsL9qDmS
         /mAlOA9yi3NlNNSHNml6Si74QBuDbQBi1fk88tFFEx1mXYY2NdJg2z1SkaM+FDNwiKhZ
         p0Y6sKLtpmN0+bjCHYZaTjjzy9uWIkcDLqUTvH4dTqAW1u2vku/OPgd04/HLNvy8Ugy+
         CDXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZ8IGPIHs4CXPcgNEwFSxGDvp7LnLJfqRLnAqdPtDrE=;
        b=jR0cVX+5jBu3urgxRS5oYKWpGCnEVBc74m5eHv4w2GQ7q+OfvYV9JuqfvV3zYfNT1U
         mhfcCFSxFS4RQtT1OEYsyY74fcHKMAsdv0urm+KpU8KNgsYjXgsrl5CfawTVe7S7WLXC
         dGx+EKfOP0mbCrhfxpeoDG1toZEgJ+fEKqFW9qIirio03iRZoyo3priqEoK2X6BWbaGM
         RTbfiYLvhffQq4AZMVA8H/tts9cPnWkv3+ZOxiJsTNfLHiLic95sRMxyzZWzyg4lFrQh
         yuqioUACB5N+D5gaS5MbqzM7AKOyvpof76ydqVrAPMsA8xvXUTec1LTomlD7nHikKbl9
         T9SA==
X-Gm-Message-State: AOAM531iLBOUvEMBc6TYYuEaLtQiKkcNfzeraJeCp1AtlYAJneNjCCOJ
        9iQYaMKnQ0mUzj4gOHZnobAGywh2mkkeVw==
X-Google-Smtp-Source: ABdhPJwRvt9aqG14PvtQ1+1Vfo5JJe7wCEYq/FBtxj5UI1HJbxEv0Whgntb72b8/clKRV74D5O7psw==
X-Received: by 2002:a50:f10a:: with SMTP id w10mr22528049edl.137.1624722281311;
        Sat, 26 Jun 2021 08:44:41 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id h7sm295335edb.13.2021.06.26.08.44.40
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 08:44:40 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id u8-20020a7bcb080000b02901e44e9caa2aso7701529wmj.4
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 08:44:40 -0700 (PDT)
X-Received: by 2002:a7b:c20d:: with SMTP id x13mr16794210wmi.70.1624722279814;
 Sat, 26 Jun 2021 08:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <c9bd6d9006f446b7eebd3a5bf06cb92f61e5f3a8.1624716130.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <c9bd6d9006f446b7eebd3a5bf06cb92f61e5f3a8.1624716130.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 26 Jun 2021 11:44:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeirEnkOuPwsD2CH9TX5=rppNF8k9ZhBdFdSS9rn+CjbQ@mail.gmail.com>
Message-ID: <CA+FuTSeirEnkOuPwsD2CH9TX5=rppNF8k9ZhBdFdSS9rn+CjbQ@mail.gmail.com>
Subject: Re: [PATCH net-next V4] ipv6: ICMPV6: add response to ICMPV6 RFC 8335
 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 26, 2021 at 10:08 AM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> This patch builds off of commit 2b246b2569cd2ac6ff700d0dce56b8bae29b1842
> and adds functionality to respond to ICMPV6 PROBE requests.
>
> Add icmp_build_probe function to construct PROBE requests for both
> ICMPV4 and ICMPV6.
>
> Modify icmpv6_rcv to detect ICMPV6 PROBE messages and call the
> icmpv6_echo_reply handler.
>
> Modify icmpv6_echo_reply to build a PROBE response message based on the
> queried interface.
>
> This patch has been tested using a branch of the iputils git repo which can
> be found here: https://github.com/Juniper-Clinic-2020/iputils/tree/probe-request
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

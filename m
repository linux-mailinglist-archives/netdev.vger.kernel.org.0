Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F6334ED14
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 18:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbhC3QCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 12:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbhC3QCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 12:02:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D6EC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:02:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t18so7985164pjs.3
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nrcL3+wnZA0dMm6EcYq5aIFjF4qmWouOcVsi2LnqznA=;
        b=skFOK2B+BKGzuQpIm0xtPXDIppStjAUk5RxOFU5WOJHdoaH2aope8BS/Pzr1sxB4gT
         z+VbBOmJiEb6tUOknv2wvQ/DZhUPsbWClYKffGjNSXCB18fK4+9SnuQnYWXjslJ217Rj
         eqdqfD6DFR6yf+9HcQYhYgS6sV7vJygt43iJPxtXV5wJXiyI/79mKj6AbW08oYPiBqif
         y+011Gz9lPLCui31fwAnfJ6aBlS58F4ZJGiziqLW77EYO/3ubpP+8UaNZ98JeqPK4NBb
         VHcEzYZo2XrFy3ksQYOKL6uPxWz+aHnBg+li+Wa4kRx1UbuKpOEvz2jOsPVvPDRWxuYF
         jG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nrcL3+wnZA0dMm6EcYq5aIFjF4qmWouOcVsi2LnqznA=;
        b=DvvPSYz0drLaQH8NGz1y+m27dy2wsUqiH3pBarHwbX6Bd7CgGqcUCmrumLmZvpwTpI
         Wn9x2XRQcTbPl3CrEdEAl9LHkvxClNf7WOIyemSGmXbXcaSr2U2ZIa4UFMUwFJR25ViD
         AoMbnJhBSvw7zGbowXzZIHh42S/PueYaxFf6b7auR9dVPqOu1AMzwV+Z/JnTBFloqBhk
         0s8hgoWLXZiNfF8K2sIkiwr88SuGJsPiWYmMBYYg5jurFDXR1VM+dEpR27rkWap1fW9L
         YuUOxzpkQk1wfoZDupXy61kcBXtuav/pa9f41IEKg2/gz3z9+1YCZG+/p0XqIQI4OSiC
         eGIg==
X-Gm-Message-State: AOAM531GUTZGHlySSX3nrVETWDsNexYqAd+rnlCh8P64JjbvuI2Pz81z
        fm424BTVe5JBA03mB8M/X5c=
X-Google-Smtp-Source: ABdhPJw3tLhh4wWyu0XtHALfXm1BIFSIFR+l8OAaJVighl9HMzG9oS8PaUu8jUDyaPzLqMu6p2cxQA==
X-Received: by 2002:a17:90a:4894:: with SMTP id b20mr5141111pjh.50.1617120157496;
        Tue, 30 Mar 2021 09:02:37 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id t4sm3186785pjs.12.2021.03.30.09.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 09:02:37 -0700 (PDT)
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
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <634ed5a7-eccc-3749-e386-841141a30038@gmail.com>
Date:   Wed, 31 Mar 2021 01:02:34 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJ1G8vU-Jw6gaTsZHamQv1ncLmoJ1FOop25OzrYmjh4kA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 12:40 AM, Eric Dumazet wrote:
 > This seems a serious regression compared to old code (in net tree)
 >
 > Have you added RTNL requirement in all this code ?
 >
 > We would like to use RTNL only if strictly needed.

Yes, I agree with you.
This patchset actually relies on existed RTNL, which is 
setsockopt_needs_rtnl().
And remained RTNL was replaced by mc_lock.
So, this patchset actually doesn't add new RTNL except in this case.

Fortunately, I think It can be replaced by RCU because,
1. ip6_mc_msfget() doesn't need the sleepable functions.
2. It is not the write critical section.
So, RCU can be used instead of RTNL for ip6_mc_msfget().
How do you think about it?

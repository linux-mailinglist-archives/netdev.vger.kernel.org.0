Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F6F7E73A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 02:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390549AbfHBAit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 20:38:49 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42064 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfHBAis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 20:38:48 -0400
Received: by mail-lf1-f67.google.com with SMTP id s19so51636539lfb.9
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 17:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ddWKWrMPlRNzwUi7tu7acZVyIb6Fxbj7c6u3GdNlWxE=;
        b=OLiggddbzvXTeseZwRY2+R6otVkSDJAL05kqzZgTh5b+cj2XJaGCR3aV4A5CQIoKjR
         vp2otVeNe1jU8hkv96zPFFRMgHDsQj89q2rRlNeO21kJq8qP0MRRtxe0x3WICji3qRor
         wiR9zjhlTM65YAkyGWWWHhqVa20I1SjLW+PRI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ddWKWrMPlRNzwUi7tu7acZVyIb6Fxbj7c6u3GdNlWxE=;
        b=KL4KXpHiCBFaZg0JiN6VbD63iNQrPpRVV8tCicWBvfWXtAAybLTSqtd3Z9EuYbEGyK
         6PGGfAAD2G5U3gT5ul/N3q3RQKJXnv1v86EmpkYmLvpmeusexum/ypvRaTnBV+CDl5Sx
         IiBuymhiEOMz7poSrrxl3qbIKEdMBFMas+cd4MQIDCvqbee2viS8FAW9wu6plmCT2sKb
         kpdOrlVHZ+wjHEn8fxDlgjxnQT3WNoi/pfpl1CvoeOECp9+iMhosGGAv8Ufi0LR0XN+/
         0O/r/749hnuB2pLDVN/3p1prJB6eRu80jrvzq2vAkJ1OaCPa3bBeiNtbKtALb8KfV7dQ
         0hHw==
X-Gm-Message-State: APjAAAUAhdTlifdhXGHsA6J5jX24AyEq4NAhFPIYpt6OX1lB+KCq52U8
        UwrE1eMxJpa2N1vAC4EUiDArDA==
X-Google-Smtp-Source: APXvYqzu57U/1pIkywnl5MVoRCjWzHY3v4I+7PFfrMuU4kDGXcEGq4pCsJwLL/zBZO57FhESAw2ovg==
X-Received: by 2002:ac2:5336:: with SMTP id f22mr60765223lfh.180.1564706326453;
        Thu, 01 Aug 2019 17:38:46 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id u24sm172703lfc.35.2019.08.01.17.38.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 17:38:45 -0700 (PDT)
Subject: Re: [PATCH net v3] net: bridge: move vlan init/deinit to
 NETDEV_REGISTER/UNREGISTER
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
References: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
 <20190731224955.10908-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <0a015a21-c1ae-e275-e675-431f08bece86@cumulusnetworks.com>
Date:   Fri, 2 Aug 2019 03:38:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190731224955.10908-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/19 1:49 AM, Nikolay Aleksandrov wrote:
[snip]
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204389
> 
> Reported-by: michael-dev <michael-dev@fami-braun.de>
> Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> I tried a few different approaches to resolve this but they were all
> unsuitable for some kernels, this approach can go to stables easily
> and IMO is the way this had to be done from the start. Alternatively
> we could move only the br_vlan_add and pair it with a br_vlan_del of
> default_pvid on the same events, but I don't think it hurts to move
> the whole init/deinit there as it'd help older stable releases as well.
> 
> I also tested the br_vlan_init error handling after the move by always
> returning errors from all over it. Since errors at NETDEV_REGISTER cause
> NETDEV_UNREGISTER we can deinit vlans properly for all cases regardless
> why it happened (e.g. device destruction or init error).
> 
>  net/bridge/br.c         |  5 ++++-
>  net/bridge/br_device.c  | 10 ----------
>  net/bridge/br_private.h | 20 +++++---------------
>  net/bridge/br_vlan.c    | 25 ++++++++++++++++++-------
>  4 files changed, 27 insertions(+), 33 deletions(-)
> 

Self-NAK, after thinking more about how to best handle this and running more
tests I believe it'll be better to go with the alternative I suggested above -
to move out only the default pvid add out of br_vlan_init to NETDEV_REGSITER
and pair it with br_vlan_delete in NETDEV_UNREGISTER. That way we'll split
the init/deinit in 2 steps, but we'll keep the current order and will reduce
the churn for this fix, functionally it should be equivalent as that is the
problematic part of the init which has to be done after the netdev has been
registered.

I'll spin v4 tomorrow after running more tests with it.


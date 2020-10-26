Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54BD1298986
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1767615AbgJZJj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 05:39:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1422461AbgJZJjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603705164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W3igjvLBR4kUJd5LaUfJyQh7pTmZOKCUWCbIiFsBhhU=;
        b=CNLlNKBM02wVqXz8F/4fSTrVIxb9do0/BFCsX2mTIu7HUVNCdLftdn+kEKroYx+f0VySbA
        Yj01f+/F/vyVlWTUOGkza7dQgfbVseJiF1ad6946ihaxAF+mLlR8ZHa263LlquD/V9Fz3d
        xegaJTsQlCtp8FlhvCYUQ82FjgwwwZ0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-BT2xSPtfOyKR6pCgB1sa3Q-1; Mon, 26 Oct 2020 05:39:22 -0400
X-MC-Unique: BT2xSPtfOyKR6pCgB1sa3Q-1
Received: by mail-wr1-f72.google.com with SMTP id 2so8130181wrd.14
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 02:39:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W3igjvLBR4kUJd5LaUfJyQh7pTmZOKCUWCbIiFsBhhU=;
        b=eAi7/PANV7UtgwbQESbdZxAs17JTCYHqaH44HOt7uAWq6JoE6+8Xb5Ex1gv7I8AiuQ
         g5qJ5rjBoFphXpZfrkKCc/a3pd07h0XQLZ/1Bz/ZQAShEIVYK21oIQNl1qP3pPtdTX5l
         3YMKPZnzQ22RZCHUxY7MkMYpKPiAS5ikKMqzeQxAhF5jJt/FS394jHraMswSkxgfMzYx
         RvEWRMUHgMriYmyRu0BI7jvdFXCdvSN+DPbSB/N8XZHaBtc+QL7rQ45KdpmJLyALjqKS
         dFvYfoIHY7TM+8oJo1vTdUOdY1oCw2JWWtzqjdUkZ4EGAAl2XOZwU2/862IriIpEMc8V
         BF8w==
X-Gm-Message-State: AOAM533sxouttjt+zrG3fYCGBWoWS77O9iWg2Q3QSwUGAYnvgsEKiRci
        3zeX3S6Ri0P7HBBUcikmF6fzxA0y2jtXJW/ufz09Xb7mIYn/N4JLVmHk5k1kWdYI3qAAPNGMELp
        NDGj9FFzSjeDNv065
X-Received: by 2002:a05:6000:1005:: with SMTP id a5mr17582417wrx.360.1603705160688;
        Mon, 26 Oct 2020 02:39:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSMcsnyZnV8PkIQ5ABboKIvaJ6AQ0ItE2+Yu4Wgw8NI4UKqld0S8GPKG9dTSTYUUdFnUSjqQ==
X-Received: by 2002:a05:6000:1005:: with SMTP id a5mr17582390wrx.360.1603705160411;
        Mon, 26 Oct 2020 02:39:20 -0700 (PDT)
Received: from steredhat (host-79-17-248-215.retail.telecomitalia.it. [79.17.248.215])
        by smtp.gmail.com with ESMTPSA id q8sm21761319wro.32.2020.10.26.02.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:39:19 -0700 (PDT)
Date:   Mon, 26 Oct 2020 10:39:17 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026093917.5zgginii65pq6ezd@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
 <20201023140947.kurglnklaqteovkp@steredhat>
 <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
 <20201026084300.5ag24vck3zeb4mcz@steredhat>
 <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 09:13:23AM +0000, David Laight wrote:
>From: Stefano Garzarella
>> Sent: 26 October 2020 08:43
>...
>> >Isn't the canonical error for unknown ioctl codes -ENOTTY?
>> >
>>
>> Oh, thanks for pointing that out!
>>
>> I had not paid attention to the error returned, but looking at it I
>> noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
>> In the ioctl syscall we return -ENOTTY, if the callback returns
>> -ENOIOCTLCMD.
>>
>> What do you think?
>
>It is 729 v 443 in favour of ENOTTY (based on grep).

Under net/ it is 6 vs 83 in favour of ENOIOCTLCMD.

>
>No idea where ENOIOCTLCMD comes from, but ENOTTY probably
>goes back to the early 1970s.

Me too.

>
>The fact that the ioctl wrapper converts the value is a good
>hint that userspace expects ENOTTY.

Agree on that, but since we are not interfacing directly with userspace, 
I think it is better to return the more specific error (ENOIOCTLCMD).

Thanks,
Stefano


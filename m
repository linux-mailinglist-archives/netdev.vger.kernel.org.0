Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52EBA3214D8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBVLLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:11:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21182 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230348AbhBVLLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:11:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613992202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rTTgTnnEUriuNUbTSpJOg3TlbAf8UgyHGlIQQW3D8og=;
        b=Ji/52dYKr9oevUiMEuagexNNZyltQloGag7QnRa9Tidpxfy+Lga0/x6UfIqNv0+N4fc1Ph
        /dOSPTWp1y19tJfWLrzXznd2FABL1tEyS/buNUOFKa3UzoQapef89gE2uEp7q8FLXmlnWC
        H4B1cmHDJ9iySMxHdzTGpZym5bEF+Sc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-P9D9fPkrMaugpmsaMfbTpQ-1; Mon, 22 Feb 2021 06:10:00 -0500
X-MC-Unique: P9D9fPkrMaugpmsaMfbTpQ-1
Received: by mail-wm1-f70.google.com with SMTP id v130so3071804wma.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 03:10:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTTgTnnEUriuNUbTSpJOg3TlbAf8UgyHGlIQQW3D8og=;
        b=YOP9CrBMesJ0Cer2XwjhKo4edZxxBVzVe/8GxGN9f48q2kV3kXoC6cNYlPu3Nr6ssp
         rxSJpR6WOAAe37LY3ecqEXa6zE1+jhIqHnwOgxY7kZVTPnUrZzzrHxikwPWcPo+nnthJ
         n6tbif7ZjksRMdNLYkLKcNdrG5THbm8YBPyQKRagG0AjoQZY/z3YGLUF3gtqYfwahtXr
         zLtRy4U4MyF0javJqYwILVGS2gBdVzMMpZLr9N3S7dh0Y/rQWyyaH1h6XT97Upel/gKk
         TtQxzFyAFZqj0P+1BbJOWOp4+5NBcbagIarbHHIh01vDjYv+UBkX/5+yQdDTc+y3IBdo
         zoPA==
X-Gm-Message-State: AOAM531vFh+dANAItJiKR+3xV4DNrPLe808pQQLpTUKWG36UbhXZM0fZ
        qwEzHyK08tI5b29xAtE0eMygD3EnHAItvMfvQMc2Sr4q7hogoofOknNjD0+XJ/U4z08RMqCXqrb
        Iz4bCahgHamiYTpfD
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr21067109wro.252.1613992199430;
        Mon, 22 Feb 2021 03:09:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdwsRnGTQg4evIi4sY1oeSfuGUyHVWJW11J4EDEj0zsR/YaE8ZRE2845KqqVThW1r2aO7OIA==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr21067090wro.252.1613992199287;
        Mon, 22 Feb 2021 03:09:59 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id o2sm300089wrw.2.2021.02.22.03.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:09:58 -0800 (PST)
Date:   Mon, 22 Feb 2021 12:09:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v5 01/19] af_vsock: update functions for connectible
 socket
Message-ID: <20210222110956.3rwm2zm2ntctayci@steredhat>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218053607.1066783-1-arseny.krasnov@kaspersky.com>
 <20210222105023.aqcu25irkeed6div@steredhat>
 <279059b2-4c08-16d4-3bca-03640c7932d9@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <279059b2-4c08-16d4-3bca-03640c7932d9@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 01:58:11PM +0300, Arseny Krasnov wrote:
>
>On 22.02.2021 13:50, Stefano Garzarella wrote:
>> On Thu, Feb 18, 2021 at 08:36:03AM +0300, Arseny Krasnov wrote:
>>> This prepares af_vsock.c for SEQPACKET support: some functions such
>>> as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
>>> shared between both types of sockets, so rename them in general
>>> manner.
>>>
>>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>>> ---
>>> net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
>>> 1 file changed, 34 insertions(+), 30 deletions(-)
>> IIRC I had already given my R-b to this patch. Please carry it over when
>> you post a new version.
>>
>> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>>
>> Thanks,
>> Stefano
>Ack, sorry, didn't know that

Don't worry :-)

It is documented here: Documentation/process/submitting-patches.rst

	Both Tested-by and Reviewed-by tags, once received on mailing list from tester
	or reviewer, should be added by author to the applicable patches when sending
	next versions.  However if the patch has changed substantially in following
	version, these tags might not be applicable anymore and thus should be removed.
	Usually removal of someone's Tested-by or Reviewed-by tags should be mentioned
	in the patch changelog (after the '---' separator).

Thanks,
Stefano


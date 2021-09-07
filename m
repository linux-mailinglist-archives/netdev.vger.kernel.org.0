Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B910402423
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241720AbhIGHW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238034AbhIGHWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:22:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630999303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oaKB7upFfFLl+Pp6dLBHJb3Ed1n4Piy1w3dtvzMllDk=;
        b=ORTztN0VjnB+8j8/Jas0QubDGlulq0Qq47W9w/4wdZcXXNJvOMdV4Ltc9RSgN0hqed7QE8
        gf1+j/aEn06fUuoF7BWkzB5oav6PHzaGF23qMwG5Pnxk9/buAoCRd69b+q1AAgCVO87NSh
        8328cKwQvrzTszfaTLEBDlKrCd+J0J8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-_MvVzoTdM2O-DAi8Pabb1g-1; Tue, 07 Sep 2021 03:21:37 -0400
X-MC-Unique: _MvVzoTdM2O-DAi8Pabb1g-1
Received: by mail-ed1-f69.google.com with SMTP id j13-20020aa7ca4d000000b003c44c679d73so4774262edt.8
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 00:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oaKB7upFfFLl+Pp6dLBHJb3Ed1n4Piy1w3dtvzMllDk=;
        b=fm0MuFE+x5A9GlzFKxK7WcHvlfMrribbRhDGMqhFKtjI4mkvwDgYQSMcrDNCt81GtG
         woOoeniXX6X0pLSlwvOQunpI559wbaDUOEmb/mgc9X6k46CVM2DyKmRCmzB5/SlzLArY
         0t2XNgRjlxzt9nTAU+GnsYV4Y51HkGLROFapW7PqEQpnMSpU+Vo8VZu5h2Dt67ZusFvk
         Xbxj5pW7dsOorqfVuI3cckCyKD02x0NFY2XurDbNO7QK32+NisqBV02XlO8mwNel+oI5
         apT2MB+E1hp1T5W2CPO0nNF02j/fPszRwD/6NteVQ4UOoNUjrLlLXvF18Hy+scAdrN0C
         H6YQ==
X-Gm-Message-State: AOAM530PMNcghhFcpxOD16B6Gd36ErN1CEr9ktpQf3OHruA36XgzLRRj
        7bNFiyRpGRH61Y3kppE6IO6VcUsL23YjCUh+2fuLLM+FeVlfR2xCdRPpmQKqUVQ1HBolgpKzjAY
        fs5sHZ5J4nQDGD4YT
X-Received: by 2002:aa7:cd92:: with SMTP id x18mr16824604edv.325.1630999295981;
        Tue, 07 Sep 2021 00:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6Uc8T7kEgxWO5FQfq7yWolBxu7KgEZ38BIbUnYz9ZEWtsIPRwsqwwuW4waLHl5HXsZmNjuQ==
X-Received: by 2002:aa7:cd92:: with SMTP id x18mr16824591edv.325.1630999295860;
        Tue, 07 Sep 2021 00:21:35 -0700 (PDT)
Received: from steredhat (host-79-51-2-59.retail.telecomitalia.it. [79.51.2.59])
        by smtp.gmail.com with ESMTPSA id ee18sm5872580edb.62.2021.09.07.00.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 00:21:35 -0700 (PDT)
Date:   Tue, 7 Sep 2021 09:21:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Message-ID: <20210907072133.mzyqugkob3yqm2ek@steredhat>
References: <20210906091159.66181-1-sgarzare@redhat.com>
 <BYAPR21MB1270B80C872030CA534C667EBFD29@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <BYAPR21MB1270B80C872030CA534C667EBFD29@BYAPR21MB1270.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 07:10:46PM +0000, Dexuan Cui wrote:
>> From: Stefano Garzarella <sgarzare@redhat.com>
>> Sent: Monday, September 6, 2021 2:12 AM
>>
>> Add a new entry for VM Sockets (AF_VSOCK) that covers vsock core,
>> tests, and headers. Move some general vsock stuff from virtio-vsock
>> entry into this new more general vsock entry.
>>
>> I've been reviewing and contributing for the last few years,
>> so I'm available to help maintain this code.
>>
>> Cc: Dexuan Cui <decui@microsoft.com>
>> Cc: Jorgen Hansen <jhansen@vmware.com>
>> Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Dexuan, Jorgen, Stefan, would you like to co-maintain or
>> be added as a reviewer?
>>
>> Thanks,
>> Stefano
>
>Please skip me (I still review the hv_sock related patches).

Yep, thanks for the help with hv_vsock!

Stefano


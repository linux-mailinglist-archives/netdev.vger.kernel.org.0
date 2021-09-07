Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0AB4023F2
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbhIGHU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:20:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237917AbhIGHU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630999161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SJ+BQHl0jBl7TBG1tqREEvwhD9MCuAV7riDwhB45i0Q=;
        b=chFfYqeU4TqFx6NLGwmCXP5SByJOFygcNwEGtpJWyUe3p9koaPJ7oYjgmTCbNLMd+nSfjC
        JksRau7EUV1ZkzQl01415HsBOZhac7vOk3lkbxy/0bQdybJHgvE4vYqJOPOTM2PV7SrWRW
        AvT7XkPYeDGeZyH5/2DZPt1J8gQmOb8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-BWQnHFazO8qOWioJlILysQ-1; Tue, 07 Sep 2021 03:19:13 -0400
X-MC-Unique: BWQnHFazO8qOWioJlILysQ-1
Received: by mail-ed1-f69.google.com with SMTP id s25-20020a50d499000000b003c1a8573042so4758609edi.11
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 00:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJ+BQHl0jBl7TBG1tqREEvwhD9MCuAV7riDwhB45i0Q=;
        b=pRiYMqc+KTsZGUmOt0eS9R2849gBkOW3V0M2g+a39uDsdSGsR0bEMplnGd9AJ81Kxf
         1gy9SG10RTZMRrQOzcWl9RL8VrV+4NGRAfAi6Fv+CVKrHznJdEeV+q7/zAW8GPKabsJI
         xgFxHa7Pa6GtpwO1Pd4SwiH9oBs2xCNfrPI3qe4uyWPz8EePVeJ/f2pV0ELac4qZdUZs
         gOxJ+/2n22r02XSwl4E7myb191XBbHfmjQm9Vk+SyWx+zchzt5P5EUlDkE7HI3U6Rtzh
         hdkFE5ATO97QeThVs2ryBwucfoFZ+Fkzpwmf4BR9IriYW/RLymwErBpUWEJKcYLmtphF
         kfUA==
X-Gm-Message-State: AOAM531Koy6uFnfUDbTubPbhUxhAPMrb4Lq7Jgrrg68Qie1xUsEbZjPP
        3oWySG6TcesQMWIlWcbxOe7j5BvmagDKJE4VZr7zgWz2nwnyTo9znfodfrmEjTYS6JblcfozoOj
        7Fx5S7Cnb1MCX/QLR
X-Received: by 2002:a50:8ad7:: with SMTP id k23mr17205127edk.310.1630999152308;
        Tue, 07 Sep 2021 00:19:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpO8ZRCV3gq3aPjZE3eB6TifvVjWEdqq6Grmkwr7q3eq7TIU5OWKnXbaQl5M7Z42F15H2Fvw==
X-Received: by 2002:a50:8ad7:: with SMTP id k23mr17205116edk.310.1630999152132;
        Tue, 07 Sep 2021 00:19:12 -0700 (PDT)
Received: from steredhat (host-79-51-2-59.retail.telecomitalia.it. [79.51.2.59])
        by smtp.gmail.com with ESMTPSA id lu4sm4923354ejb.103.2021.09.07.00.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 00:19:11 -0700 (PDT)
Date:   Tue, 7 Sep 2021 09:19:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add VM SOCKETS (AF_VSOCK) entry
Message-ID: <20210907071909.qooj2opczrklljwi@steredhat>
References: <20210906091159.66181-1-sgarzare@redhat.com>
 <YTYWkupSYR29IMuM@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YTYWkupSYR29IMuM@stefanha-x1.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 02:24:34PM +0100, Stefan Hajnoczi wrote:
>On Mon, Sep 06, 2021 at 11:11:59AM +0200, Stefano Garzarella wrote:
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
>
>Please skip me for now. I'm available if you take an extended period of
>time off and other special situations but don't have enough time to play
>an active role.

Yep, thanks for that!

Stefano


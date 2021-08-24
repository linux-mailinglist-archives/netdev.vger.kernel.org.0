Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35433F5C2B
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbhHXKcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:32:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235905AbhHXKcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:32:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629801102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=feIhjhva5jefoIxfoE0azoq+AbsdStJdrlY7GGgP55M=;
        b=Grp/aBGff6h+IQKzcuhP/volgFxSahSJj1muP9IeiGj7oGmiZSE36X3qiwXyuhVBf5EFrf
        W4K4wPx5IzdGKqYnD4G4faGs0xCPCLn6xFHR9eJnAWQOCpTfqzawi1sPNxXhn6wnE4THEu
        CaH+7hgkszL/EP52op9TNBSVnxWPmpY=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-EGrXaWUqPfWczrhIU5GPXQ-1; Tue, 24 Aug 2021 06:31:41 -0400
X-MC-Unique: EGrXaWUqPfWczrhIU5GPXQ-1
Received: by mail-ed1-f69.google.com with SMTP id b16-20020a0564022790b02903be6352006cso10279210ede.15
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 03:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=feIhjhva5jefoIxfoE0azoq+AbsdStJdrlY7GGgP55M=;
        b=G0jkwy+pzbzSpBFL3b45Fx3mMRu8cKA1qZ472lB7E8uLOT+zSJk8X+NN2uaHFzjnhi
         WcRfTpSjP/zPMqb4XDzey80uI7gljUoHbKYGviLDhnCT5lDyIK4nOT1NHm7EBlSkoKVH
         hfvWCP6B73bGuztTRRYfvDT7wlImtPoOcq1LS95mwUiE6q72Txp0Qz5jDeaNbJqnqt4C
         Vw4AWM+pW/15trJFZsfunqfmeK29wW3SD7Kb4gg7Sk/SUWwIgfqU7kRF7Mxo9pfalIiE
         rg+sD68eb9i09sXHffHmN/Jmb6XPweIk4duqIJEGPPvaQRUvMhokTO6N0vfDgesnyNiN
         x1rA==
X-Gm-Message-State: AOAM531hftB0jjS9iPqf2rQiTQEJQxHwBVraMjPSTRKIHmtwvfxt05m3
        IZrazcCTNLeO4Cvu4BRN5/IEG857qjk9uHKQbe8lY/yXwvw1ZbZKw7XliUW2Q5RwdSbhfekDsxN
        Z3siup4gO5K5sRRKk
X-Received: by 2002:a17:906:d04b:: with SMTP id bo11mr40707204ejb.513.1629801100363;
        Tue, 24 Aug 2021 03:31:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1lClZImhRtvJCoGEAqkfeG/l8kJgXUskqq5Rw2DFLftK9EBSu/dk7LEDZ72T8m++O+df9pA==
X-Received: by 2002:a17:906:d04b:: with SMTP id bo11mr40707195ejb.513.1629801100235;
        Tue, 24 Aug 2021 03:31:40 -0700 (PDT)
Received: from steredhat (host-79-45-8-152.retail.telecomitalia.it. [79.45.8.152])
        by smtp.gmail.com with ESMTPSA id c28sm9029348ejc.102.2021.08.24.03.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 03:31:39 -0700 (PDT)
Date:   Tue, 24 Aug 2021 12:31:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v3 0/6] virtio/vsock: introduce MSG_EOR flag for
 SEQPACKET
Message-ID: <20210824103137.v3fny2yc5ww46p33@steredhat>
References: <20210816085036.4173627-1-arseny.krasnov@kaspersky.com>
 <3f3fc268-10fc-1917-32c2-dc0e7737dc48@kaspersky.com>
 <20210824100523.yn5hgiycz2ysdnvm@steredhat>
 <d28ff03e-c8ab-f7c6-68a2-90c9a400d029@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d28ff03e-c8ab-f7c6-68a2-90c9a400d029@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 01:18:06PM +0300, Arseny Krasnov wrote:
>
>On 24.08.2021 13:05, Stefano Garzarella wrote:
>> Caution: This is an external email. Be cautious while opening links or attachments.
>>
>>
>>
>> Hi Arseny,
>>
>> On Mon, Aug 23, 2021 at 09:41:16PM +0300, Arseny Krasnov wrote:
>>> Hello, please ping :)
>>>
>> Sorry, I was off last week.
>> I left some minor comments in the patches.
>>
>> Let's wait a bit for other comments before next version, also on the
>> spec, then I think you can send the next version without RFC tag.
>> The target should be the net-next tree, since this is a new feature.
>Hello,
>
>E.g. next version will be [net-next] instead of [RFC] for both
>kernel and spec patches?

Nope, net-next tag is useful only for kernel patches (net tree - 
Documentation/networking/netdev-FAQ.rst).

Thanks,
Stefano


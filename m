Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2483A390452
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 16:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhEYOyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 10:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234135AbhEYOx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 10:53:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621954348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qSC9QpCDqCazF2mZq6d/82qLDoFltpJkJoLoXKJjvvg=;
        b=UZohAr0z2OxDHmDLuHVO7MUL/OV+4kjfoNG0Rd82tP0HhVv/fcSu+1S9q+SGq1ZTbRSlbB
        5R27BWoG6HdRxz3QRpb/ChVp2L46t5VtTMTCdOv1DCUHFlwxOQoMyJJMPyz2pCeaT3yE97
        d3rux3Q7JCLGCkKxUHUoXqx3Wcu1Q68=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-4TDXAuxEOca8ZwENvxb-sA-1; Tue, 25 May 2021 10:52:24 -0400
X-MC-Unique: 4TDXAuxEOca8ZwENvxb-sA-1
Received: by mail-ed1-f69.google.com with SMTP id da10-20020a056402176ab029038f0fea1f51so9269256edb.13
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 07:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qSC9QpCDqCazF2mZq6d/82qLDoFltpJkJoLoXKJjvvg=;
        b=p1mNzOxQtGPO83FnEwEqm1QNma1a8W4X+VNPqGahUMvok85kazjDcJvZIrD6Q+uy6k
         pXkgR6SEvg295o+0zlDRSBJ35WKxmCbiV3DLDCZm9IJM5rUPJzy44ZV9fKcopbf9bK1n
         EjOWv2ekNFk9mK/NxnuhoQU464k+UoFe/8/tbfEEpN4KTpMwf0KLAdKdBb6sZ9olnmO+
         fFnus8a3b2IVLF5cuhQZKy45/v6RYcTN0uSSmE8z+JptXZ5O3C+7MTxuwbCm8OtGb+4H
         Yb5w5umAWeN+6IUFiNyMrbSEXGQeiI5BxeiHaCkO0m7P1qFQ1NuRCcNt+ikQg7r5zp76
         Qj5g==
X-Gm-Message-State: AOAM532LI4Oiwi4YGtXM3Vanz0hr/dy7jaBiqBXOw3YfHj7d0daQp4rI
        4qMH+/8P3WrlGxr01W/TWShW5Q+a2qlKbmlYQEaWKH5/iA3ixJPVxuiY+wyQBjbOndxWwGWQuKq
        +/MN0IbDi4e5J96Kt
X-Received: by 2002:aa7:d843:: with SMTP id f3mr32220065eds.270.1621954343100;
        Tue, 25 May 2021 07:52:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDlSSMgDZFTIhLb5CNVeQ1FOGcYDV/D4Z+HKGAvXmcW1X5RbFzEx/ev3BuN5v5ARSJGUCLSQ==
X-Received: by 2002:aa7:d843:: with SMTP id f3mr32220039eds.270.1621954342913;
        Tue, 25 May 2021 07:52:22 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id h9sm10912173edt.18.2021.05.25.07.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 07:52:22 -0700 (PDT)
Date:   Tue, 25 May 2021 16:52:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [PATCH v10 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
Message-ID: <20210525145220.amzme5mqqv4npirt@steredhat>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
 <20210521075520.ghg75wpzz42zorxg@steredhat>
 <108b0bba-5909-cdde-97ee-321b3f5351ca@kaspersky.com>
 <b8dd3b55-0e2c-935a-d9bb-b13b7adc4458@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b8dd3b55-0e2c-935a-d9bb-b13b7adc4458@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 11:22:09AM +0300, Arseny Krasnov wrote:
>
>On 23.05.2021 15:14, Arseny Krasnov wrote:
>> On 21.05.2021 10:55, Stefano Garzarella wrote:
>>> Hi Arseny,
>>>
>>> On Thu, May 20, 2021 at 10:13:53PM +0300, Arseny Krasnov wrote:
>>>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>>>> transport.
>>> I'll carefully review and test this series next Monday, in the mean time
>>> I think we should have at least an agreement about the changes that
>>> regards virtio-spec before merge this series, to avoid any compatibility
>>> issues.
>>>
>>> Do you plan to send a new version of the specification changes?
>>>
>>> Thanks,
>>> Stefano
>> Hello, sorry for long answer. I'm on vacation now, but i plan to send
>>
>> it in next several days, because with current implementation it is short
>>
>>
>> Thank You
>
>Hello, here is spec patch:
>
>https://lists.oasis-open.org/archives/virtio-comment/202105/msg00017.html
>
>Let's discuss it

Yep, sure.

About this series I think is better to split in two series since it 
became very long. Patchwork [1] also complains here [2].

You can send a first series with patches from 1 to 7. These patches are 
reviewed by me and can go regardless of the discussion of the VIRTIO 
specifications.
Maybe you can also add the patch with the test to this first series.

Please specify in the cover letter that the implementation for virtio 
devices is under development and will be sent later.


When it will be merged in the net-next tree, you can post the second 
part with the rest of the series that implements SEQPACKET for virtio 
devices, possibly after we received an agreement for the specifications.

Please use the "net-next" tag and take a look at 
Documentation/networking/netdev-FAQ.rst about netdev development.


Anyway, in the next days (hopefully tomorrow) I'll review the rest of 
the series related to virtio devices and spec.

Thanks,
Stefano

[1] 
https://patchwork.kernel.org/project/netdevbpf/list/?series=486011&state=*

[2] 
https://patchwork.kernel.org/project/netdevbpf/patch/20210520191449.1270723-1-arseny.krasnov@kaspersky.com/


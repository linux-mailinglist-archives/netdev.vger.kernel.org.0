Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465AF3B128F
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 06:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhFWEFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 00:05:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229485AbhFWEE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 00:04:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624420962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3v2u3R2lyZzHwU1afyfLtqn+GNaqNl8GZdeMTLeXX+E=;
        b=We9lzZF/+zm70AtLaFt7I3xb3MSI9P7tDCGcgCvA5Shp+vPw7kNKnhaHWJPfQHi8VX0yi7
        3DXFtyt8GBmpZZNBdbF2qKQ/JDSD6UQC+z46cAy4fggTx3/h4xEwAD2jh/0NGtxEbP7ZTp
        nmWmSJG0aD+ozZUdnPBYyuStW0B/obQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-xiWLc8SSNBicBBDrt8Z7DA-1; Wed, 23 Jun 2021 00:02:39 -0400
X-MC-Unique: xiWLc8SSNBicBBDrt8Z7DA-1
Received: by mail-pf1-f198.google.com with SMTP id s13-20020a056a00194db02902ed97b465c2so965004pfk.17
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 21:02:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3v2u3R2lyZzHwU1afyfLtqn+GNaqNl8GZdeMTLeXX+E=;
        b=Yx26vq5LSzGtGjHD2DsVCZJ2cAVIrBrNMAVLTysnaYq1iPOn4i4mNpt4IZRP+hnegh
         mQbDFutG3OG80h3TAEFJdyDQ2h12pcXXXRAS24Mp9OfzGtOXnvWAc+MBZIJPLedZyCnJ
         N0gJaHwTmVf/A0pf+mT4zGYLTTs6H68g4v8qVTJiCZfTzrf2mSmJ2bR/WGY4MBiQcWRR
         yAv1wfINkF4JNMGq8AXas7j/5qTpjFo23Lj7Dw+EozADbO94PP8iV7GYeGMbVp9m/362
         Qe9oJfaW0sHfB5d5/yVRJkZr5EU6B5UfDjOowbyzRfGhfjK8DuTLmnayhfx03Q/mobZc
         GDDg==
X-Gm-Message-State: AOAM531ZvI4hdJS0zIKD1k7mzR+BO2xUgP7Q0JXn7EErlBjGiaMzeD1K
        fG2PSDlFAm96C/A9ttXXWSnt3So3DKScMrWiPo+A7H0vGr6uNW4Ofx9y88+s5xMzmlnhzgRDbou
        aXAwa1Txc8YEaohxM
X-Received: by 2002:a17:90a:fb46:: with SMTP id iq6mr6028014pjb.104.1624420958570;
        Tue, 22 Jun 2021 21:02:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyG82tg+FYGDw2JnR19VBzcYbz62n6FXbLqt6hhMJuOhK7AQ+3gL/ROHTUCNGUX3vN4zN19ig==
X-Received: by 2002:a17:90a:fb46:: with SMTP id iq6mr6027991pjb.104.1624420958257;
        Tue, 22 Jun 2021 21:02:38 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g5sm783727pfb.191.2021.06.22.21.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 21:02:37 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] vhost_net: Add self test with tun device
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
 <20210622161533.1214662-4-dwmw2@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <85e55d53-4ef2-0b61-234e-4b5f30909efa@redhat.com>
Date:   Wed, 23 Jun 2021 12:02:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210622161533.1214662-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/23 上午12:15, David Woodhouse 写道:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> This creates a tun device and brings it up, then finds out the link-local
> address the kernel automatically assigns to it.
>
> It sends a ping to that address, from a fake LL address of its own, and
> then waits for a response.
>
> If the virtio_net_hdr stuff is all working correctly, it gets a response
> and manages to understand it.


I wonder whether it worth to bother the dependency like ipv6 or kernel 
networking stack.

How about simply use packet socket that is bound to tun to receive and 
send packets?


>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   tools/testing/selftests/Makefile              |   1 +
>   tools/testing/selftests/vhost/Makefile        |  16 +
>   tools/testing/selftests/vhost/config          |   2 +
>   .../testing/selftests/vhost/test_vhost_net.c  | 522 ++++++++++++++++++
>   4 files changed, 541 insertions(+)
>   create mode 100644 tools/testing/selftests/vhost/Makefile
>   create mode 100644 tools/testing/selftests/vhost/config
>   create mode 100644 tools/testing/selftests/vhost/test_vhost_net.c


[...]


> +	/*
> +	 * I just want to map the *whole* of userspace address space. But
> +	 * from userspace I don't know what that is. On x86_64 it would be:
> +	 *
> +	 * vmem->regions[0].guest_phys_addr = 4096;
> +	 * vmem->regions[0].memory_size = 0x7fffffffe000;
> +	 * vmem->regions[0].userspace_addr = 4096;
> +	 *
> +	 * For now, just ensure we put everything inside a single BSS region.
> +	 */
> +	vmem->regions[0].guest_phys_addr = (uint64_t)&rings;
> +	vmem->regions[0].userspace_addr = (uint64_t)&rings;
> +	vmem->regions[0].memory_size = sizeof(rings);


Instead of doing tricks like this, we can do it in another way:

1) enable device IOTLB
2) wait for the IOTLB miss request (iova, len) and update identity 
mapping accordingly

This should work for all the archs (with some performance hit).

Thanks



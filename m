Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A083E3B5819
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 06:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhF1EZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 00:25:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhF1EZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 00:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624854200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLeqIOgpBkD1FX+tqeP1n2Jv04KIufJT9c8xXyMNgRY=;
        b=WQ9eDrddA/Cjlwl/S54UrbF/6LAlLi0OnQaLMrlLPxjDQmdq978lvwpPJqbicsvlhPLy36
        x00JQ6AgCW5rZ1BUEUKHv0vPwWNQwVdHY+SJGAsQBFatSD7MzIGMfwLygXcmk+Qkbieshr
        J56ZFbQJf2KRHQiGUifVnKQairlW4Xc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-RITVEDQ9Plq_008N2zuKsg-1; Mon, 28 Jun 2021 00:23:18 -0400
X-MC-Unique: RITVEDQ9Plq_008N2zuKsg-1
Received: by mail-pj1-f69.google.com with SMTP id j8-20020a17090a8408b02901651fe80217so9751330pjn.1
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 21:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oLeqIOgpBkD1FX+tqeP1n2Jv04KIufJT9c8xXyMNgRY=;
        b=GTvDrN1GCAjfdpoKAi7dnoGJl80LZBntiZXeW5hjGUvGcskUK0Y6lIJB0p4oB2WU75
         JQNq94lAWvnnXtTGMIJ/y7tbwJP/UF6lUYfd32QNmbZWFF7fZPv3A7gwJFpESmonCPP4
         Xy9krUH+AH0XyziWfzY+yMR+smXAF+bidSu2w/g4WK2lxF5kyIj3ThBaAspWTU+LTE4+
         dQo1fhGRLnNhGRsn+sLpsj6YrLEyMpaTGlXBA3noCDICqV8wqS4FCd+GHBjrw/R7nB1G
         GtzBPQaweoQXGUIKfp/ryXKHczb1MA/Kr2ALF+JfzNkEutpvq2loueKY2kVdS7weVJE0
         4IXQ==
X-Gm-Message-State: AOAM530yE/N2ZrEVX1stWF5jVVERACGUqRd4rl6YMgQhFyPGGdgA3v/M
        uVCnaNBX4xpV6nPrX7j6i+fItvsMnGca/dHRmJ005ia72Ucq6mA6issO6T4CzEOKYP14pHnwUry
        iJLCD9T6y6FAjlsHP
X-Received: by 2002:a17:90a:b94c:: with SMTP id f12mr34283591pjw.58.1624854197426;
        Sun, 27 Jun 2021 21:23:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyRvBc20XCEQjaRdjsIVaQUcgdppdduDYx4ICNx+8Zwn4eueVsNJJToQho/N37fXHMcJk33A==
X-Received: by 2002:a17:90a:b94c:: with SMTP id f12mr34283575pjw.58.1624854197275;
        Sun, 27 Jun 2021 21:23:17 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q3sm12327716pfj.89.2021.06.27.21.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Jun 2021 21:23:16 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
Date:   Mon, 28 Jun 2021 12:23:13 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/25 下午4:37, David Woodhouse 写道:
> On Fri, 2021-06-25 at 15:33 +0800, Jason Wang wrote:
>> 在 2021/6/24 下午8:30, David Woodhouse 写道:
>>> From: David Woodhouse<dwmw@amazon.co.uk>
>>>
>>> When the underlying socket isn't configured with a virtio_net_hdr, the
>>> existing code in vhost_net_build_xdp() would attempt to validate
>>> uninitialised data, by copying zero bytes (sock_hlen) into the local
>>> copy of the header and then trying to validate that.
>>>
>>> Fixing it is somewhat non-trivial because the tun device might put a
>>> struct tun_pi*before*  the virtio_net_hdr, which makes it hard to find.
>>> So just stop messing with someone else's data in vhost_net_build_xdp(),
>>> and let tap and tun validate it for themselves, as they do in the
>>> non-XDP case anyway.
>>
>> Thinking in another way. All XDP stuffs for vhost is prepared for TAP.
>> XDP is not expected to work for TUN.
>>
>> So we can simply let's vhost doesn't go with XDP path is the underlayer
>> socket is TUN.
> Actually, IFF_TUN mode per se isn't that complex. It's fixed purely on
> the tun side by that first patch I posted, which I later expanded a
> little to factor out tun_skb_set_protocol().
>
> The next two patches in my original set were fixing up the fact that
> XDP currently assumes that the *socket* will be doing the vhdr, not
> vhost. Those two weren't tun-specific at all.
>
> It's supporting the PI header (which tun puts *before* the virtio
> header as I just said) which introduces a tiny bit more complexity.


This reminds me we need to fix tun_put_user_xdp(), but as we've 
discussed, we need first figure out if PI is worth to support for vhost-net.


>
> So yes, avoiding the XDP path if PI is being used would make some
> sense.
>
> In fact I wouldn't be entirely averse to refusing PI mode completely,
> as long as we fail gracefully at setup time by refusing the
> SET_BACKEND. Not by just silently failing to receive packets.


That's another way. Actually, macvtap mandate IFF_TAP | IFF_NO_PI.

Thanks


>
> But then again, it's not actually *that* hard to support, and it's
> working fine in my selftests at the end of my patch series.
>


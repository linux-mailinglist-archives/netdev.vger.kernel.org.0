Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC64C4618D6
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344993AbhK2Oep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:34:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48274 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1378834AbhK2Oca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:32:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638196152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rf8O5ctAw0vGE3sOZEtvXA5okWE5nRdwUi7RWsMQCzw=;
        b=Z3MWlBzCpZaXMjZ6HytNUHJzQRDfNsaTwknuq7MhwCWZXbZYh9f4DrWN+JDm9S1cDGnhRF
        25cClBBlSWIrV7cTecf6F09hiD3clUznN1asy9H6dSpzMm5eZSRgEM3OqaehtTVnk4vgoz
        muaJl4qyxmq4OM3KsruAGS40ZEJ2wpc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-wcD6G2hsOACZB8UjWs1JsQ-1; Mon, 29 Nov 2021 09:29:11 -0500
X-MC-Unique: wcD6G2hsOACZB8UjWs1JsQ-1
Received: by mail-ed1-f70.google.com with SMTP id w4-20020aa7cb44000000b003e7c0f7cfffso13909440edt.2
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 06:29:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=rf8O5ctAw0vGE3sOZEtvXA5okWE5nRdwUi7RWsMQCzw=;
        b=k7a1VjWVksvX1+gRV5caKqxKUeanUeVAIMU7QXKn6d46612sC8YtEeWAJNQ/spqXde
         XVgiTI+2xFIOjf7V5RB89WRFySY3vRm9BBiDQkKMw4SvgRn0NUmFkyQ1DQ3r7NFGfFs7
         abidPVkqF3goKHS3gwvBx7x977ZAQlaa/cjIgzj6TvNC9iXV9bFqrnCYirwGtDz+mVyV
         7yDnVpyILVw/r9dHvEROh2bdJSo4Ih9ZJHXB2Soq0WwFPzWwnNiRbitCfIQPc5+vwV3z
         fwDkVpHsu7KdAQhpBx/uoFGgVo2ZXwjs4HmYfxivghvpDYTnCycHDMTHnAlVXmjH20CN
         wvPw==
X-Gm-Message-State: AOAM530zfkZRLLwNuLOicLCL7tgHJdwx7qGjMySho+DJciGOPpqbvIUA
        O1hHAJpxXklDiQEyo830Oec4eDVTFUog84xi6IcPcvMFY4Vyhtfj3AzTj0KmD5zLbgZK0jzMUIO
        rzBgn1BPbCG21Sack
X-Received: by 2002:a17:907:e86:: with SMTP id ho6mr62462228ejc.209.1638196149947;
        Mon, 29 Nov 2021 06:29:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5srlFAN9dumOiSNmAAdhgitW5lf/zV1A0C1Mxkj4ak17HFZsRXxea9V+nJ/LVfKWv7yl4OA==
X-Received: by 2002:a17:907:e86:: with SMTP id ho6mr62462210ejc.209.1638196149799;
        Mon, 29 Nov 2021 06:29:09 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id qz24sm7393876ejc.29.2021.11.29.06.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 06:29:09 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <de14fefc-a8c1-ff6c-5354-8cce4a3f66f9@redhat.com>
Date:   Mon, 29 Nov 2021 15:29:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        jesse.brandeburg@intel.com, intel-wired-lan@lists.osuosl.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 0/2] igc: driver change to support XDP metadata
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
References: <163700856423.565980.10162564921347693758.stgit@firesoul>
 <20211129141047.8939-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211129141047.8939-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 29/11/2021 15.10, Alexander Lobakin wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Mon, 15 Nov 2021 21:36:20 +0100
> 
>> Changes to fix and enable XDP metadata to a specific Intel driver igc.
>> Tested with hardware i225 that uses driver igc, while testing AF_XDP
>> access to metadata area.
> 
> Would you mind if I take this your series into my bigger one that
> takes care of it throughout all the Intel drivers?

I have a customer that depend on this fix.  They will have to do the 
backport anyway (to v5.13), but it would bring confidence on their side 
if the commits appear in an official git-tree before doing the backport 
(and optimally with a SHA they can refer to).

Tony Nguyen have these landed in your git-tree?

--JEsper


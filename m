Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0B916F683
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 05:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBZEfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 23:35:10 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39860 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgBZEfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 23:35:10 -0500
Received: by mail-qt1-f196.google.com with SMTP id p34so1359053qtb.6
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 20:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZHAee9qSr3OpxF8hstujHHQZdrMFMCSBlRGTRUEa28c=;
        b=M/axFhBmzzonVRjUibvgCOdCtLn4Hezpc/oPReilVSOI78nrR/7QqhAHkHJWm5A8cy
         /2SLnJfhlYyyqZPCD3HFQJtxrdTE4xbkyuHk2HpBMpdLPWBH0TRz/JBIWDKLb4V8ES+x
         WaWEOr/DjX2011q1CGmX6BT7pn2wN/4CrE+AT83NuaMg5jroFCZKiyEVWgJcfZ9ZFn6f
         9iUycM6TmueRt3sFtErRkWmjcV46SDmA9fJxRrRXQPuok4tqLuD0y4lhHr317LUtx6Ck
         QG0+7ieju4rwG0A5FW4e5SI3nuqPaXWfSM4BcL/A8dnIv8hN+DfZH7A4Ab6veVKrQW/I
         Os0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZHAee9qSr3OpxF8hstujHHQZdrMFMCSBlRGTRUEa28c=;
        b=KnolGej9rfV4T+tpKSSL8rBc1KdUpNtJeJzUpL2ZAdA7HQJmJGbA7AbkIXOU7u7M30
         Prj/wMwSMphEFr0De/HCYLEbUvZcVMTdt3jBtbUXxP231rdO+A02lnGndGTCpvWTTMqB
         y1Qf8LRqH/Fv22NaImSN9mrwTBmdo1zZ11gvsMFFC+8egzLLv1E73+2fm4gPeywN3AtF
         S3ZAZPWTLauDezkC6hGkd1ELHiBYEVy+G2cmur4BfoadCS73ojdG45K3M+1LYVU7Oc85
         xm6xEfR9jW7VSk+dxSinaoBK0ohXOi68Quqq0mDfThzZsAkSohn6zspI8h06bgs0iu69
         obeg==
X-Gm-Message-State: APjAAAXWKL6xWvdAZck2tFblpkhi8Vuedu7vPQoKfjw/Y+dLdSjjrXJZ
        MG/hB5tAGwcXmhq4dJ7qARM=
X-Google-Smtp-Source: APXvYqz/W/3oGZNA64PYPvSlZFjncQCJZbz8rPtPuvk4pZNv69hOFdWpNGacVKh/0SR/pnh7pSG+JQ==
X-Received: by 2002:ac8:768d:: with SMTP id g13mr2688809qtr.7.1582691707651;
        Tue, 25 Feb 2020 20:35:07 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4f3:14fb:fa99:757f? ([2601:282:803:7700:e4f3:14fb:fa99:757f])
        by smtp.googlemail.com with ESMTPSA id o55sm459606qtf.46.2020.02.25.20.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 20:35:06 -0800 (PST)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     Jason Wang <jasowang@redhat.com>,
        David Ahern <dahern@digitalocean.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <772b6d6f-0728-c338-b541-fcf4114a1d32@redhat.com>
 <3ab884ab-f7f8-18eb-3d18-c7636c84f9b4@digitalocean.com>
 <cf132d5f-5359-b3a5-38c2-34583aae3f36@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5861350a-a0f6-9a74-e06d-4b7fd688e5e7@gmail.com>
Date:   Tue, 25 Feb 2020 21:35:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <cf132d5f-5359-b3a5-38c2-34583aae3f36@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 8:52 PM, Jason Wang wrote:
> 
> On 2020/2/26 上午11:34, David Ahern wrote:
>> On 2/25/20 8:29 PM, Jason Wang wrote:
>>> TAP uses spinlock for XDP_TX.
>> code reference? I can not find that.
>>
> 
> In tun_xdp_xmit(), ptr_ring is synchronized through producer_lock.
> 

thanks. I was confused by the tap comment when it is the tun code.

So you mean a spinlock around virtnet_xdp_xmit for XDP_TX:

+                       if (!vi->can_do_xdp_tx)
+                               spin_lock(&vi->xdp_tx_lock);
                        err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
+                       if (!vi->can_do_xdp_tx)
+                               spin_unlock(&vi->xdp_tx_lock);


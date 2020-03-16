Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B00186257
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgCPCgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:36:17 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34839 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729924AbgCPCgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:36:16 -0400
Received: by mail-qt1-f196.google.com with SMTP id v15so12967396qto.2
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y1j6PnKHT2h1YOO9oFSmwRw0AJ311hhA25AjtJNAkEw=;
        b=fRk7F3kju0PACLQqHLT8lKVETCm3o9tbD6HiB/A7X6rp16EfeW9WXPDRPBio0OaAo6
         /xW8bKZwo62DBysWVzx3L7n8Hz0vY3hJ6EQY9bVUzbE4cxsn7fQc32+jm73jQVhZN1Gj
         01fLvAx7v7Om6ZmUltMyWgaupv9MujGalyqmQbppWPgQwxw+pPERAB2FUn4nHqwvTNqr
         bjOMhsLsy0QVbrpMTS/YoirXGcaIqnTeqEEK/kYzchJtU3yp/mnmibDTsqdrvyTOpbj2
         94O7hOB9pU5OgiBwhYlRrScO2ZTHjdPE6PE2LfubBzh76unBCymMUjfo0FUPJqYdvsKX
         +YmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1j6PnKHT2h1YOO9oFSmwRw0AJ311hhA25AjtJNAkEw=;
        b=ZrZkO8n1uyJtiJ4zgtq35JZRUG1ku8/6ytVRTdEd+p68TIt5AmNyqZftJ3wCfcvjFK
         bgPgPMjhktL2S4hXstYoxK+FeM4i7LAvoPkY8LaqPsLUlv1v6h29SlBlDEm37SiVcd0Y
         sP+RYxgzLFVMQh2Wfofxr3nuil5WDfyT+a5vOoviUZd6vgCJ+8FQ4SB12m9jpT88QMf+
         Txpd2YIU6oH/x6Eb9gXfWWGnAlzNWYpERURV6gHUpeuNBEVvw2acJZqz9eAv7fdnnOAq
         uL6vYqg9T3k1bKzAgM5SFhJs46HYCXMqGE7Bx4HnLj2+XQvJkm87pdpfCuaYlAwOxpLt
         lbGw==
X-Gm-Message-State: ANhLgQ3sxbssqHMyO24HKXS0jkEoOmbMKcHcaJisX/xQWVCoAPTA3DmC
        Hnh1QYvu34/ULMeXbr3AhlE=
X-Google-Smtp-Source: ADFU+vv4QmpMtpvrOT5yyL0etheq+XSuzRius4uyN5iu/ZiSsZOtmRL4FKQp4QMAd/d/yPi5EG+h3A==
X-Received: by 2002:ac8:184f:: with SMTP id n15mr21554452qtk.371.1584326174261;
        Sun, 15 Mar 2020 19:36:14 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1068:8e8d:73f8:b838? ([2601:282:803:7700:1068:8e8d:73f8:b838])
        by smtp.googlemail.com with ESMTPSA id g6sm8651572qtd.85.2020.03.15.19.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:36:13 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v1] net: core: enable SO_BINDTODEVICE for
 non-root users
To:     David Miller <davem@davemloft.net>, vincent@bernat.ch
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        kafai@fb.com
References: <20200315155910.3262015-1-vincent@bernat.ch>
 <20200315.170231.388798443331914470.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a2d2b020-c2a7-5efa-497e-44eff651b9ce@gmail.com>
Date:   Sun, 15 Mar 2020 20:36:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200315.170231.388798443331914470.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/20 6:02 PM, David Miller wrote:
> From: Vincent Bernat <vincent@bernat.ch>
> Date: Sun, 15 Mar 2020 16:59:11 +0100
> 
>> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
>> non-root user to bind a socket to an interface if it is not already
>> bound. This is useful to allow an application to bind itself to a
>> specific VRF for outgoing or incoming connections. Currently, an
>> application wanting to manage connections through several VRF need to
>> be privileged. Moreover, I don't see a reason why an application
>> couldn't restrict its own scope. Such a privilege is already possible
>> with UDP through IP_UNICAST_IF.
> 
> It could be argued that IP_UNICAST_IF and similar should be privileged
> as well.
> 
> When the administrator sets up the routes, they don't expect that
> arbitrary user applications can "escape" the route configuration by
> specifying the interface so readily.
> 

Hi Dave:

As a reminder, there are currently 3 APIs to specify a preferred device
association which influences route lookups:

1. SO_BINDTODEVICE - sets sk_bound_dev_if and is the strongest binding
(ie., can not be overridden),

2. IP_UNICAST_IF / IPV6_UNICAST_IF - sets uc_index / ucast_oif and is
sticky for a socket, and

3. IP_PKTINFO / IPV6_PKTINFO - which is per message.

The first, SO_BINDTODEVICE, requires root privileges. The last 2 do not
require root privileges but only apply to raw and UDP sockets making TCP
the outlier.

Further, a downside to the last 2 is that they work for sendmsg only;
there is no way to definitively match a response to the sending socket.
The key point is that UDP and raw have multiple non-root APIs to dictate
a preferred device for sending messages.

Vincent's patch simplifies things quite a bit - allowing consistency
across the protocols and directions - but without overriding any
administrator settings (e.g., inherited bindings via ebpf programs).

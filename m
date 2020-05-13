Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366431D1F5C
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbgEMTh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390607AbgEMTh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:37:56 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A714FC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:37:56 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id i5so478515qkl.12
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 12:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kt7t0TqhmCxlzlXBpeJY3DgosHKQetyWsCnD6CujIP4=;
        b=T+7Rh8TqNph/0QNU0+/eL43JvawzfRXsrY9YPyu6x94hagJ/uB1rQMY8at9MGQP76f
         lFPKX9ahGR3AcboLd3aBlHnZkt9jQ4jD2YsFJOjWqj5I8qALgyL/bcmVEn7kCIdCuDLz
         xKKWMC5h9K65AJrRYmg4vAURSLLuWkpzhM8qDHH67xMhOzytb606lGn//cxG0juBEVrg
         wy1ZvcpE+fs9o3rhxWTpIRGMVPwWZCzqQxpYuJTktySLy1RAq/QKg6P2XH//M8bt3SF7
         /DeWuq5C+OqVKLnMnzTCnOrLBKac383rJnpojwhaQLWYMK4Dyfcjjww/89n7iYxAXSx3
         3zmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kt7t0TqhmCxlzlXBpeJY3DgosHKQetyWsCnD6CujIP4=;
        b=R0b5hKNdic+mH4jX2H8TIiB//a6AIeLoXl5zfP+LrLEUWxzJa0pwx0s6YRntTR/akO
         JaMXjuPS0j1li8/wjbAQarmhcAP7RFRkwZeVRi4SQZ6ydPOq9oRUZ73Jmpwe+PL5CB8D
         lxgi2WXDcQNZvwyOKI0dEh+AmrOWNsNnHb4hPu9/ngdjXyGEYwTigdXVMgHD//hJX6FH
         +BEeRv4uK9GxaAQ1SQJ9K75c8XdEQCA8S7IzyXHZzp2sUsONGsoaj9ZlwTcsBOskv7+0
         QygxIrcO+3km/KN93BNvjBrvwSnVjMjke1YvxIYvmGlBVDG8Pwt4Iyw9PTIQ1oTca9Ci
         XZIQ==
X-Gm-Message-State: AOAM533pTzaVruigRDCZyhb2U0J1AP2NokfUAO3LGW6GK3+2bhe+MPab
        uC1y1T09wE+9rGzxwj8YKck=
X-Google-Smtp-Source: ABdhPJxhKeGhHqXdY4mX5CdOGPr+sD2gqJjXhb5Lls4RjymnZrS50DxleLO/N0wZM2uFXs0qcs3lSA==
X-Received: by 2002:a37:4786:: with SMTP id u128mr1402430qka.378.1589398675937;
        Wed, 13 May 2020 12:37:55 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:4082:2138:4ed8:3e6? ([2601:282:803:7700:4082:2138:4ed8:3e6])
        by smtp.googlemail.com with ESMTPSA id g187sm630271qkf.115.2020.05.13.12.37.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:37:55 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
Date:   Wed, 13 May 2020 13:37:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87sgg4t8ro.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 4:43 AM, Toke Høiland-Jørgensen wrote:
> I don't like this. I makes the egress hook asymmetrical with the ingress
> hook (ingress hook sees all traffic, egress only some of it). If the
> performance hit of disabling GSO is the concern, maybe it's better to
> wait until we figure out how to deal with that (presumably by
> multi-buffer XDP)?

XDP is for accelerated networking. Disabling a h/w offload feature to
use a s/w feature is just wrong. But it is more than just disabling GSO,
and multi-buffer support for XDP is still not going to solve the
problem. XDP is free form allowing any packet modifications - pushing
and popping headers - and, for example, that blows up all of the skb
markers for mac, network, transport and their inner versions. Walking
the skb after an XDP program has run to reset the markers does not make
sense. Combine this with the generic xdp overhead (e.g., handling skb
clone and linearize), and the whole thing just does not make sense.

We have to accept there a lot of use cases / code paths that simply can
not be converted to work with both skbs and xdp_frames. The qdisc code
is one example. This is another. Requiring a tc program for the skb path
is an acceptable trade off.

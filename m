Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294643C269F
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhGIPJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232308AbhGIPJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625843232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWA5O/fhJ8QG9Es+ZrrMNjfeStSGWhfU1k/gnymKsz8=;
        b=eS651hcovGCsVdnU5zScWSW5thX2Al3mKezniL5kmm3I4SIjvzr47V6RKJyfllgnxmjmbp
        Oi49qeTenujorsG5Z1GQPo9RL3XthBwROPKobpg5jxPl0vC8Fe4Ww2mL/q8FOdskgCc5OO
        YoA/Vx7VoUPNuvKL33oZwCLmm2wo4bg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-w9HunNviMAW8M03IdVpBrA-1; Fri, 09 Jul 2021 11:07:00 -0400
X-MC-Unique: w9HunNviMAW8M03IdVpBrA-1
Received: by mail-wm1-f71.google.com with SMTP id r5-20020a05600c35c5b029020fcaed9f61so2142300wmq.1
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 08:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FWA5O/fhJ8QG9Es+ZrrMNjfeStSGWhfU1k/gnymKsz8=;
        b=OkQtELAjXT5f1VV4HGfqv2fgnnDnAlTgNKaXzOnZyiuU7L72cS1viWgS8KuZPoNWFZ
         6SL9/7ApGlPnImBzTiBMOVGtkXTyNh3qe7XkRuy9zfjkNXdryPoYG7Io7TEufLNJWXxH
         mF+HAbuuruTes+Nz+a2AKta1iwUu1GeboIDncOq9diWwAUy14ccXoMIAmG9rJbcFFNp7
         2ei4Il6yIXMBEfgVrCCX2XTK/4fYt/HvzyMPGmGGvtl3gTRywHzjxeZ9ZO6xTiC/LXtc
         PdYtYMzPq54rxW0idQi54pyY4fcb7n8tDMGjutS5U+o7xm3AdNzvNrwu4++znWJDHBkE
         rNbQ==
X-Gm-Message-State: AOAM5307zXic0ChyiKzk6ABgIveDzi2amxSmrmnkfBJJmMpNOL59vxEq
        N3UOQBQioD4ZB7G7CnG2SmQs0fuduSET1i0vsKWavEt15BjNd7ll6GvTLnHbHupGBsdbCtjNfqD
        SF7nPkdJU8fTOUuBd
X-Received: by 2002:a5d:634e:: with SMTP id b14mr41328466wrw.96.1625843219034;
        Fri, 09 Jul 2021 08:06:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwjckPclixBzng5V5bRX0cSKid2GesLh4PVEfD8l5v5qxpchlXzvreXPPJaCjjUh+QsasDSg==
X-Received: by 2002:a5d:634e:: with SMTP id b14mr41328430wrw.96.1625843218788;
        Fri, 09 Jul 2021 08:06:58 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id q19sm12150756wmc.44.2021.07.09.08.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 08:06:58 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev
 queues"
To:     Edward Cree <ecree.xilinx@gmail.com>,
        =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
 <20210707130140.rgbbhvboozzvfoe3@gmail.com>
 <CACT4oud6R3tPFpGuiyNM9kjV5kXqzRcg8J_exv-2MaHWLPm-sA@mail.gmail.com>
 <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com>
Message-ID: <4189ac6d-94c9-5818-ae9b-ef22dfbdeb27@redhat.com>
Date:   Fri, 9 Jul 2021 17:06:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b11886d2-d2de-35be-fab3-d1c65252a9a8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/07/2021 16.07, Edward Cree wrote:
> On 08/07/2021 13:14, Íñigo Huguet wrote:
>> In my opinion, there is no reason to make that distinction between
>> normal traffic and XDP traffic.
>> [...]
>> If the user wants to prevent XDP from mixing with normal traffic, just
>> not attaching an XDP program to the interface, or not using
>> XDP_TX/REDIRECT in it would be enough. Probably I don't understand
>> what you want to say here.
> 
> I think it's less about that and more about avoiding lock contention.
> If two sources (XDP and the regular stack) are both trying to use a TXQ,
>   and contending for a lock, it's possible that the resulting total
>   throughput could be far less than either source alone would get if it
>   had exclusive use of a queue.
> There don't really seem to be any good answers to this; any CPU in the
>   system can initiate an XDP_REDIRECT at any time and if they can't each
>   get a queue to themselves then I don't see how the arbitration can be
>   performant.  (There is the middle-ground possibility of TXQs shared by
>   multiple XDP CPUs but not shared with the regular stack, in which case
>   if only a subset of CPUs are actually handling RX on the device(s) with
>   an XDP_REDIRECTing program it may be possible to avoid contention if
>   the core-to-XDP-TXQ mapping can be carefully configured.)

Yes, I prefer the 'middle-ground' fallback you describe.  XDP gets it's 
own set of TXQ-queues, and when driver detect TXQ's are less than CPUs 
that can redirect packets it uses an ndo_xdp_xmit function that takes a 
(hashed) lock (happens per packet burst (max 16)).

--Jesper


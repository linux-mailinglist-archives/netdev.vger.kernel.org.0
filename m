Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA161E4740
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbgE0PYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgE0PYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:24:24 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E47C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:24:24 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 205so11569536qkg.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Yi7+iHRYQ8OWEMfVa78HFcdfDUsVwxQcfoowVXBQ3Zo=;
        b=E3Cygbvlixm+DfscmTxsbLgkAaERIqQoPVWt1nYcpRgRrsT+T5IXk0eqqTgjdH4hFx
         RUlWJ5ZhTyTHdiisBoFAfAMRtTWEDM7ZXXGFA98BH4rGIEdBg6au95xK2sTqYuDSB0dr
         LvAI3LDbZosSrKkRwViXiSa+IrmXGW3VDVpEuvdrS0Zq8+DFrML9SNtPFh8Iz5XeUkL8
         9GcTpfBb+StXQw6FbZO8zDuY15+f4+kWdE5vFJLfNmxWY+sD90oeb+rHY6WKVrPenq4j
         /9cStwVF8Su5cOXFhUcndgQ/WGfjwNkV6qTWeWjUU61yE3RzZQdpTAHxRPbtvn/xmaVp
         rM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Yi7+iHRYQ8OWEMfVa78HFcdfDUsVwxQcfoowVXBQ3Zo=;
        b=MCzq8CYcck33/Xd22n5XaxEBL2xYOC28bi5qc003lvOoO9KmBL7Ilp37e0e+cHs63c
         dolyw1/wCSMXOUYPRE7VpKX2VTFZ4S7BY83H51QlRuaK9Rda2V7oCCfXdKClF/yW0lDO
         IPO+Vfz6aRYYYStBVMRnaFkkgyXNnp9KVY2LWfRyH3rYBGBhWxI53nnh7TJ3Gv+hUOYW
         0P3W6ph0YmdiRjFbd5Yu567e9u9oAYSg2ICJLspajOzUQIXBmyQ4gKNO6JUzr9TXR6W/
         0WnVW0dulICUF+5gI1Zf3ej8VxRinlvhNyEc5gt22oRYyXDbj1b6xhp3Hvl9ryBqKiwq
         xyKA==
X-Gm-Message-State: AOAM531lpImIh880iZFWk0OyFvXh7SseRj41s8gRkLsjsGY4VsZXQKJH
        8g2piSj6QsnQXY5mDjHkk34=
X-Google-Smtp-Source: ABdhPJwUK7290RgqgtyMr/HogTEfCe8WB1wUNU7jgP+rE1WubCmRehKwC/AvtU7lgwnFT0P9VE+rNw==
X-Received: by 2002:a05:620a:95d:: with SMTP id w29mr4246460qkw.445.1590593063264;
        Wed, 27 May 2020 08:24:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id q187sm2528036qka.34.2020.05.27.08.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 08:24:22 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-2-dsahern@kernel.org> <20200527122612.579fbb25@carbon>
 <c58f11be-af67-baff-bd70-753ca84de0dd@gmail.com> <87tv011l4m.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d8e9cc89-16c8-859d-62a7-65ff8806871f@gmail.com>
Date:   Wed, 27 May 2020 09:24:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87tv011l4m.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 8:57 AM, Toke Høiland-Jørgensen wrote:
> 
> Either way you're creating a contract where the kernel says "first four
> bytes is the ifindex, second four bytes is the fd/id". BTF just makes
> that explicit, and allows userspace to declare that it agrees this is
> what the fields should mean. And gives us more flexibility when
> extending the API later than just adding stuff at the end and looking at
> the size...
> 
>> You need to know precisely which 4 bytes is the program fd that needs
>> to be looked up, and that AFAIK is beyond the scope of BTF.
> 
> Exactly - BTF is a way for userspace to explicitly tell the kernel "I am
> going to put the fd into these four bytes of the value field", instead
> of the kernel implicitly assuming it's always bytes 5-8.
> 

Really, I should define that struct in uapi/linux/bpf.h. The ifindex
field has special meaning: the kernel needs to convert it to a
net_device. The prog_fd field has special meaning: it should map to a
bpf program.

This use case is not in BTF's scope. But, prove me wrong. Ideas are
cheap; code is hard. Show me the code that implements your idea.

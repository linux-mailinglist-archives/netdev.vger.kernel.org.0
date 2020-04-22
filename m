Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504B11B493E
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgDVP4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDVP4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:56:44 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD81C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:56:44 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g74so2835037qke.13
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rGmB898oTjBjLVGHgQRSoVFMeKsTRIJj+DSH0JiqLnY=;
        b=eifLVLwMQWsAkTYfG4GfYTxaAjC4+Xyh36082c93/H6NXiq//WhPvg7gOP6/QHx8CX
         +Rhv0Qf1mvuACImg1+fAbdOLMjqMXJAzs37NajsULzIy0RNBLDjnqWv+MFBTK3x/+/PV
         QWZzuzHmIwYZC0W4IdsyQgo7Ai+WEdOfDuLcz2v4VyApVWNaZXnwhuilD9fuzd0i2gB+
         VkYKfEWfkU1XnyZCedL3JnmG+nOahrBP1TQzkixuREpmi2ma7b+ImJUwePNbYLosXOOE
         xKMVQNBKpslBYoHwTE/0BaOI7wd+kQdBNK+e2wb1PTds5YWwChpNcfvrGEvePHyyvpcH
         tc1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rGmB898oTjBjLVGHgQRSoVFMeKsTRIJj+DSH0JiqLnY=;
        b=o1bJ0qwDvg9Z1IGgwlU8B/ZVjj3+chff8B3JHw1sIzDGJeez2UKLnPKaonKN4e4NoY
         vkZI2AyzdcbUafPg6Z+HFrhoGHcb+vgtJufaKj9PzYCO2Lr7iLBEvUkp0cjyjU5iQE0L
         kTQS/+n7P7Rt0fE49cW6FPH8hIaTKFEE23p3uGo5LfcZUl94SVppQUKfaZfcaNh7QojN
         xCUcrLY1xPd5pmArvPiNOkGOGJtFTYYyT86XHRG3MsqqKgUqGRfBrWoOc8gAZyplbidv
         bF7/u06ugdNkwb+vlAGB7TsCKaQvVYl6H68AdEaknFDYViJJZD6z9sqEAWTvtzOnh4Ds
         oVgw==
X-Gm-Message-State: AGi0PuZnoVt19ZBMU57sh03GsST9LD+ReZKsIGt1tUoFobc36/qIAq/O
        h0fRYZMXSu5DFEr81bHPzr4=
X-Google-Smtp-Source: APiQypJv2QwhMWQIq56fv9VZZm/GxZbAJYJ3VvZIcE6uXmZoe/JY+wYNteOOqmbi6soHr7jGScUVRQ==
X-Received: by 2002:a37:b183:: with SMTP id a125mr17787016qkf.199.1587571004004;
        Wed, 22 Apr 2020 08:56:44 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id r51sm4232892qtk.89.2020.04.22.08.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 08:56:43 -0700 (PDT)
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk>
 <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk>
 <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk>
 <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com> <875zdr8rrx.fsf@toke.dk>
 <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com> <87368v8qnr.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6009ff42-5981-6fe7-5b67-30ecbb7d7842@gmail.com>
Date:   Wed, 22 Apr 2020 09:56:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87368v8qnr.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 9:51 AM, Toke Høiland-Jørgensen wrote:
> Your patch is relying on the (potentially buggy) behaviour, so I don't
> think it's out of scope to mention it in this context.

This is getting ridiculous. I am in no way, shape, or form relying on
freplace.

If you think there is a problem with existing code, then you prove it.
Don't ask someone else to stop what they are doing and prove you right
or wrong.

I guess we'll see tomorrow the outcome of your investigations.

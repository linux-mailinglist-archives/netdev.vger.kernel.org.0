Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3514314FEAF
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 18:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgBBRyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 12:54:04 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46007 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgBBRyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 12:54:04 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so14065828ioi.12
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 09:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AQkS2j0swn3QiX+29nuALkvBXXAqJbReZsiyDpK3L4A=;
        b=gDreb4gkmTzyZ1yzLREmu7+7iBI7MvH0sFNuicvkz+HBVLmJER3SKn8SNsGRdrvq09
         LV4DGbdIi4m7WHTuWy9UQSkIgyIpthv2Ry8LCjzA7owcGGJ+Zs9o3jCz0OiDzD3zMUcy
         ToDtAI5CY18An5Iud9g7KGYzuK5SvcIGZ1IB3U/ZcGfyqTm7SUNJblbdL/ZbKgUUfnwu
         VDIDR+Gmh+Qw1/Ll3irD363zlI1O0Mqi5I8TS10ieLI4XLMVrnFhjPJ6G7tv87NoZ6fQ
         knmAgDVhYT8WUg/EJQOmdkiYfKR9hO2jjmuVwUbfXHX1WyAe1PfobB5yQX27ueRE8LJL
         anzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AQkS2j0swn3QiX+29nuALkvBXXAqJbReZsiyDpK3L4A=;
        b=adYFIAZlS/WE5H3Mf+55GlvNSOLH1WWHSiG7yc07o5VrVLC6UQGuqeWbK1JmsZNvlQ
         n0U/3zWXb5n9hb0L2J//2zPWw8Nf/iqLOBkhJJPEv4PlQK+ObKkPtLI4hyPka7KDjPbK
         nj9gPNWEABjLvxFqhAADcaEE1IqjmjBMJa6odrMMsFsUvmI3uATc7+B1A/iuz5+Xgrku
         Ne4/RTAgGRebjseqG0EeSIVi9EuIAHNzOaODcQsDiHcrRaHOdPoVk4CDZok49tOlEpSw
         YlPKTRGqhEgRucCW/tmrmXiN8Rl9svdi7YMKxS6WTKanPwCvpzgvGDX3uRvfv98Y4SFY
         l3qg==
X-Gm-Message-State: APjAAAV83nZOEaWYZZ3G2AzVe3ZS2EfmsUme69/w5bwL0M7H436T7ywW
        pWAdkt0UATwoGV2S0/n3Vmk=
X-Google-Smtp-Source: APXvYqxwtc45uvFeyv8i70vjhvZTGsCif2HZ583+EcdiOGW/8+zwRanDKyY0dimhhdcdHLl9LtEDcA==
X-Received: by 2002:a6b:c703:: with SMTP id x3mr5179938iof.118.1580666043618;
        Sun, 02 Feb 2020 09:54:03 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id c12sm6057329ile.12.2020.02.02.09.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 09:54:02 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <87o8uie1t5.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9779cff1-5117-41aa-968d-414867244f37@gmail.com>
Date:   Sun, 2 Feb 2020 10:54:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87o8uie1t5.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/20 8:59 AM, Toke Høiland-Jørgensen wrote:
> 
> In any case an egress program will differ in:
> 
> - The context object (the RX-related fields will be invalid on egress,
>   and we'll probably want to add new TX-related ones, such as HW
>   TX-queue occupancy).

Jakub has suggested that rx_queue_index can be a union with
tx_queue_index; the former for the Rx path and the latter for the egress.

The rest of the fields in xdp_md are legit for either direction.

>   
> - The return code semantics (even if XDP_TX becomes equivalent to
>   XDP_PASS, that is still a semantic difference from the RX side; and
>   it's not necessarily clear whether we'll want to support REDIRECT on
>   the egress side either, is it?)

Why should REDIRECT not be allowed in the egress path? e.g., service
chaining or capturing suspicious packets (e.g., encap with a header and
redirect somewhere for analysis).

> 
> So we'll have to disambiguate between the two different types of
> programs. Which means that what we're discussing is really whether that
> disambiguation should be encoded in the program type, or in the attach
> type. IMO, making it a separate program type is a clearer and more
> explicit UAPI. The verifier could still treat the two program types as
> basically equivalent except for those cases where there has to be a
> difference anyway. So it seems to me that all you are saving by using
> attach_type instead of program type is the need for a new enum value and
> a bunch of additions to switch statements? Or am I wildly
> underestimating the effort to add a new program type?
> 

IMHO that is duplicating code and APIs for no real reason. XDP refers to
fast path processing, the only difference is where the program is
attached - Rx side or Tx side.

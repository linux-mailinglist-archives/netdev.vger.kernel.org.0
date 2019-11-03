Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E751ED3E6
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfKCQwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 11:52:54 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45128 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfKCQwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 11:52:53 -0500
Received: by mail-il1-f193.google.com with SMTP id o18so563050ils.12;
        Sun, 03 Nov 2019 08:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B/VCY4UVd/90N2eWiSbHzRsdJZkRPgFH6gJxOk9IQeY=;
        b=AmjMcNlI3fLQ+7KWxvz03Vm5jddRxzPkiwk1hfxtxResLKdLV4E4gR1CP8yGi7Iu1S
         nbMiwzTT30H9z9WyYlJAs1BVZHosVzfuVnxOjk1FYvuU+/r7hdr4z5vYh9nIGzEgU2O/
         CRE5jFWAjf3IOs39lY4+2fzfSf49ksMy+lLOnuOggLWUqwHU5l9/kD2OTf5XMsxMavpX
         MfwEvg8Q/34T2rvAuhKdOTjZkfVPaKRHJTc+DpwmXfAZBlCPPXVaBzXm8uMUVZ1CLxv8
         D8urH5cy4JFx6TEAr9Ft9e0MVsL8orrIyjmCvQVDimf+lLVuotiTFoA/9DXVHteAc+M1
         T/uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B/VCY4UVd/90N2eWiSbHzRsdJZkRPgFH6gJxOk9IQeY=;
        b=Azl2xU+59xLsfk9Ex4X9SbZywPQhRDXt4RIhsbbaAaXgwQHoIZYZptesWpABRTWI5o
         EyLgfMGHqdQLR6NZbhZiMAX9WQDE1JVkhO93wFdLwLzn8hqPim5jYDBO05Uzzu66py3N
         RCZxdTl2as7YsUFeZ2ox60SIwp3OW4/ZaGV1IwaCLukZfe1yaeLL1kamqcfWpfq3KIwd
         kYHdAgJ2cEhsAzNopu+Sti37grI6NregzBMNfiogJiUPWUvrzAxQ/5eTgjrcjgxT/aNx
         YXgrPKTED4lIS9et7InVhGLPKN5/nnrHCdw5Lh/BOI+L+IJGKFLT4rEvOsn0ZoV3nIYN
         lh9g==
X-Gm-Message-State: APjAAAXdC7eS1ZegrDzeMHGc36krvgaebfkzVyLV7SeOjtAsjrS+i6Mg
        u6gMK0l+vgwVeyPPOZMIcPXxkw3d
X-Google-Smtp-Source: APXvYqxJJOM8eyhYRIpBu8Q+TS5S3ErBmnM/i6A9QOCrbngpAyviCep4QX6wFaXecOKYLddiIbfdCQ==
X-Received: by 2002:a92:d5c4:: with SMTP id d4mr24076184ilq.44.1572799972715;
        Sun, 03 Nov 2019 08:52:52 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b1d3:36cc:8df:d784])
        by smtp.googlemail.com with ESMTPSA id z15sm1339043ilo.37.2019.11.03.08.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2019 08:52:51 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] selftest: net: add icmp reply address test
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     David Miller <davem@davemloft.net>, shuah@kernel.org,
        netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
References: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
 <0a03def6-3ea0-090f-048f-877700836df2@gmail.com>
 <CA+HUmGgDrY9A7kz7268ycAOhExA3Y1h-QhBS6xwbWYxpUODDWw@mail.gmail.com>
 <690336d7-0478-e555-a49b-143091e6e818@gmail.com>
 <CA+HUmGgKakVpS8UsKWUwm9QdCf+T2Pi1wNS-Kr7NE+TQ8ABGaQ@mail.gmail.com>
 <06dd5c8e-7eeb-a00f-e437-11897fe01ad1@gmail.com>
 <CA+HUmGjra-=GeRApvYRgX6iQZPG73xWyfXqR-_fxjKS0WcmYrQ@mail.gmail.com>
 <CA+HUmGhYzSE-ruiOfQa9UCKcMuN361asxwCD=Nmdjar9jC0bTA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d07ad847-634f-fcd3-6b8a-77ca29c622d0@gmail.com>
Date:   Sun, 3 Nov 2019 09:52:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CA+HUmGhYzSE-ruiOfQa9UCKcMuN361asxwCD=Nmdjar9jC0bTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/19 4:08 PM, Francesco Ruggeri wrote:
>>>> I apologize in advance  for being slow ...
>>>> I have 3 namespaces that have to share the same LAN, I am not trying
>>>> 1-1 connections among those namespaces.
>>>>
>>>
>>> How would you cable this if it were an actual network with physical nodes?
>>> - bridge on R1 (since it is the gw for H1), with connections to R2 and
>>> H1 into the bridge
>>> - second connection between R1 and R2
>>> - connection between R2 and H2
>>>
>>> For the simulation, network namespaces represent physical nodes, veth
>>> pairs act like a cable between the nodes / namespaces and the bridge
>>> makes the LAN.
> 
> Thanks, I see what you mean now.
> I was assuming a different physical model, with all the namespaces on the LAN
> connected to a hub (simulated by the dummy device). For simulation purposes this
> model seem simpler: there are N interfaces instead of N pairs, and one does not
> have to deal with the bridge end of the pairs.
> Why is the model you described preferable?
> 

The tests are about traceroute in modern networks, not broadcast
domains. As such, it is preferable for these tests to be constructed
similar to other extisting networking tests.

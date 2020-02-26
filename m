Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03F61703B2
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBZQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:03:51 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46375 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgBZQDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:03:51 -0500
Received: by mail-qv1-f65.google.com with SMTP id y2so1492622qvu.13
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WzyLQQlWicNnCdqBvaK52lOW7eZ6ig2hmAzlMiTl794=;
        b=GOXJmdveHDe/qk6HNGM7BGJosP672dn2o4d45p7pEZbMd4V/uk5F3wsVYl6fQ7bB2b
         XCtpje0BUV+BXAf7Hyq0IcTr0gRTQL0J2VxN+UggjuvZZPLFyDT7uNKk58JIKUEHgLAo
         hXcx5RMMdBK4q8v9ubQx2FH/QI8rTg4fg4Xv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WzyLQQlWicNnCdqBvaK52lOW7eZ6ig2hmAzlMiTl794=;
        b=sOQh+B0Ps956viDWW2rqFuyl/OadLWaIyB/I1iCfG8+MxHfDNXaMHc0JCosCH8iRDc
         GFZmpcBWM2dZfScmOLVo0nohEp2r/9eBBurE96W8H66458b/vn6VPQExEYt4wK8vEER5
         Xr2+uAJleRVx+e4GSgjj9HFU/VIu0+DCW+an+Q3UPy2ckTxqqhFbAxy084O8cRV+9TL/
         IjeVM3Wm0bwMlmjO4m367U+wG8uUuRiC2WAkQJiG/xGhjJ8YrPP0Kppc8t2Hh8HWTftv
         M9KrhoAQg84b1vD3t9elTJh8herbSo67fQABUSBFV0o7wubORHLPBvZEAYtFwNngVyUT
         SkOw==
X-Gm-Message-State: APjAAAXNOWdwN3HLh5xFx3M0zfpL/7ZQsLcUV5myboXSaZmfZ8rHRNbf
        wgcIQ3wwFtiI44MgcTdCSz1b8n02Hl34D2L/
X-Google-Smtp-Source: APXvYqzodUc5w0ZwwJbED1VHXVL2biZxIyO7gWSTlCOhE10SozCYqOfFlqHE3SfCuOyU1tub4MLlww==
X-Received: by 2002:ad4:408c:: with SMTP id l12mr6164305qvp.164.1582733029452;
        Wed, 26 Feb 2020 08:03:49 -0800 (PST)
Received: from [10.0.45.36] ([65.158.212.130])
        by smtp.gmail.com with ESMTPSA id p2sm1327671qkg.102.2020.02.26.08.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 08:03:48 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200226093330.GA711395@redhat.com> <87lfopznfe.fsf@toke.dk>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
Date:   Wed, 26 Feb 2020 09:03:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87lfopznfe.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 2:51 AM, Toke Høiland-Jørgensen wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
>> On Tue, Feb 25, 2020 at 08:32:14PM -0700, David Ahern wrote:
>>> Another issue is that virtio_net checks the MTU when a program is
>>> installed, but does not restrict an MTU change after:
>>>
>>> # ip li sh dev eth0
>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 xdp qdisc fq_codel
>>> state UP mode DEFAULT group default qlen 1000
>>>     link/ether 5a:39:e6:01:a5:36 brd ff:ff:ff:ff:ff:ff
>>>     prog/xdp id 13 tag c5595e4590d58063 jited
>>>
>>> # ip li set dev eth0 mtu 8192
>>>
>>> # ip li sh dev eth0
>>> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 8192 xdp qdisc fq_codel
>>> state UP mode DEFAULT group default qlen 1000
>>>
>>>
>>
>> Cc Toke who has tested this on other cards and has some input.
> 
> Well, my comment was just that we already restrict MTU changes on mlx5
> when an XDP program is loaded:
> 
> $ sudo ip link set dev ens1f1 mtu 8192
> RTNETLINK answers: Invalid argument
> 
> Reading through the rest of the thread I don't have any strong opinions
> about whether this should propagate out from the host or not. I suspect
> it would not be worth the trouble, though, and as you say it's already
> possible to configure regular network devices in a way that is
> incompatible with the rest of the network.
> 

Both mlx5 and sfc restrict MTU change to XDP limits; virtio does not
which strikes me as a problem.

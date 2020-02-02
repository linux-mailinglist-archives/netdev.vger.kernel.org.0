Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CAA14FF72
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 22:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBBVvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 16:51:07 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41574 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgBBVvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 16:51:07 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so10938810ils.8
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 13:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TKoSB6QsFgU9T5NiT7nE1jtswy1JMr/mF5Z/7ZHO+uQ=;
        b=eIfkUeaX+b8BJVG9uufxVqvKkJaSJJkVZLmZgMTxzIUoSXP0tlqwQeB0OSN4gxU+NR
         qDaqpMyP5/xH+qodiuP78QgmrVsE4La5ROrY2pfhpN/ox7poY7OAH8+A11isTEsrZ56O
         RYZK8b4y/A1bRDjwHrpAKlLFqLOpkgXMXmEkMdYDLF6uB9HC242G2eLGagZkGJ2/UoSl
         Ac2gRkLcVgIl2IHvR5I8wpYJ6P3uK3Nplphb9SeJ0jCFo2+CuaqvqT6uGXf1fonjkpLH
         c5MK1vLw7fZa6hGpwKvtU2u5frvLH6aanpqwgQ5P0BfT3T/uLLUi7DUiduewX+wxKBEb
         WHcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TKoSB6QsFgU9T5NiT7nE1jtswy1JMr/mF5Z/7ZHO+uQ=;
        b=E2SN+tW8elTJjm/Cts4Eyh77pE+L9TWGWRxzrk5TXbFu4oU28wJiRceI3Q7PzRrTGR
         MtJQxMPMdmdOp5Z/zwHYJjEXeEMEcWD5lLBeY/65vr4aVW0oAL0bi1N+LLN3+X/QxV/+
         sbYMAX1gqTc0MS+AOUR5Lhs646FdqrmwHCx1BV18G71iGOGEEB6fiK5I3Pu+4ZegKkIy
         2V+7E+7Jc2OX/xgQ1SHUK1oR0vnAhuR9MgkdegqCabAFAfW1iZT9tMIFKFa37WSWlr90
         cXqHLaLZH4a0iu9iKhxZ2JKmbgCyAJGCHGRxY5iAKmFupp8WlX4Cv/1Iab8bkC39/PDd
         kCrA==
X-Gm-Message-State: APjAAAXVr2QqT2yhMvxjqOGiNY7JQrRtd9ttZHYp+V9iXn6LtoUPLuCh
        n1NOCYOkEwB0uG6HKDkAkSM=
X-Google-Smtp-Source: APXvYqxi1dgRpL4DU1NBSng0gyRR8CZcElyJ933bpw7MobdoH80yPDS5UDPS278UZnwMhQuID1/7Ww==
X-Received: by 2002:a92:ce92:: with SMTP id r18mr12320349ilo.135.1580680266962;
        Sun, 02 Feb 2020 13:51:06 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id o6sm3260849ilm.74.2020.02.02.13.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 13:51:06 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, jbrouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126141141.0b773aba@cakuba>
 <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
 <20200127061623.1cf42cd0@cakuba>
 <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
 <20200128055752.617aebc7@cakuba>
 <e3f52be9-e5c8-ba4f-dd99-ddcc5d13bc91@gmail.com>
 <20200202113152.321b665f@cakuba.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <89fb234d-b6fe-cc96-52f5-7ed310ee9dff@gmail.com>
Date:   Sun, 2 Feb 2020 14:51:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200202113152.321b665f@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/20 12:31 PM, Jakub Kicinski wrote:
> 
> I think our perspectives will be difficult to reconcile.
> 
> My reading is that you look at this from slow software device
> perspective. Of which there are few (and already loaded with hacks).
> And you want the control plane to be simple rather than performance.
> 
> I look at this from HW driver perspective of which there are many.
> Saying that it's fine to load TX paths of all drivers with extra 
> code, and that it's fine to effectively disable SG in the entire 
> system just doesn't compute.
> 
> Is that a fair summary of the arguments?
> 

I do not believe so.

My argument is about allowing XDP and full stack to work
synergistically: Fast path for known unicast traffic, and slow path for
BUM traffic without duplicating config such as ACLs and forcing a
specific design (such as forcing all programs in the XDP Rx path which
does not work for all traffic patterns). For example, if I am willing to
trade a few cycles of over head (redirect processing) for a simpler
overall solution then I should be to do that. Fast path with XDP is
still faster than the full host stack for known unicast traffic.


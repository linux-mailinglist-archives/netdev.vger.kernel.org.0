Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB66514A0B7
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgA0J2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:28:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38947 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729449AbgA0J2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:28:14 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so6222739wme.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0HMWe4wYmmsqrMUcUA05sQh0EkXmzPCxXGY/OUA2mv8=;
        b=SgRwizwp0ZKK+FUBN0BL9WcZqcjZ6y9OHw57NaHAHWSTz3YBv6VKUN9VK2CfWSuPb5
         62TDFUcf2oYEFKAW5Zz3iXPNv826Q8Fs2l+7mxHLtBsL+KVFySVtzIKKgwfmzeQ69JsJ
         T96/OERCsTksJyAPpr3PrgosdFkloyvuGnMS9QolOHONnGx/NQxtv+DcCothzVs9wBtm
         x4v4gDHJLjC4SqzDbE8H8oclPXe160CrDv++hTaBL/CKfCRflkJBHd0QfEn2WIFi2Weh
         68UkoJ5zLr1gPnp2dc9xt/zPinu29f6WqhdJoMKtrOqZrix58FU97uqMnRi5/Ipb36Bm
         H3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=0HMWe4wYmmsqrMUcUA05sQh0EkXmzPCxXGY/OUA2mv8=;
        b=VllIasiyRZO49LtNkgXJCqMD7NkAftl943zxJpDR2HdTj/szTd5N55EYbXtcRGSU3/
         xKjyQyUgVaACvcbVX4+ZetPVf6MuyP8xhR9I1piPHle+X+t5TiL/rsUYRBII/hB8hv4Y
         qKT6tJVZrByQpL3oQVTi+24s/ewc4sadmy2f9UrmnEo4BMPCSR/KZnxnBk5ZO3aOOX1K
         Lx660IkYH94Yzy1BsNUdcPxSYzFNElridVVLnLkDqtK3FhTjB2HO0Q1z/Ij30nhHR83Q
         N+UGhBRCnG5zqIYR81KYs0dAo0gHMp+Bd+i9B+P0eS9jUDrhIvWF8uUqVDXeyRLn38Ap
         HIqA==
X-Gm-Message-State: APjAAAVqFIvP1quayWP72U/O+Jal1kq40v6qxPgTF7yTdaW6UDVnCQXA
        jLz3UrUlvSVd7KdV3UoBghPhuPUuLAk=
X-Google-Smtp-Source: APXvYqwV/TMgfVntqzHNQLSefHtzbKpaki+MTNicZGElxuhYM1I80JIGVyt/IQfL9oX8w4wVc0voLQ==
X-Received: by 2002:a1c:9849:: with SMTP id a70mr12317379wme.76.1580117292131;
        Mon, 27 Jan 2020 01:28:12 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:84eb:1bd0:49ec:9a40? ([2a01:e0a:410:bb00:84eb:1bd0:49ec:9a40])
        by smtp.gmail.com with ESMTPSA id b137sm19120763wme.26.2020.01.27.01.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:28:10 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec v3 0/2] ipsec interfaces: fix sending with
 bpf_redirect() / AF_PACKET sockets
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <6407b52a-b01d-5580-32e2-fbe352c2f47e@6wind.com>
 <20200113083247.14650-1-nicolas.dichtel@6wind.com>
 <20200115095652.GR8621@gauss3.secunet.de>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <35524394-8ba1-1868-4e85-ddfd9d829c6c@6wind.com>
Date:   Mon, 27 Jan 2020 10:28:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200115095652.GR8621@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/01/2020 à 10:56, Steffen Klassert a écrit :
> On Mon, Jan 13, 2020 at 09:32:45AM +0100, Nicolas Dichtel wrote:
>> Before those patches, packets sent to a vti[6]/xfrm interface via
>> bpf_redirect() or via an AF_PACKET socket were dropped, mostly because
>> no dst was attached.
>>
>> v2 -> v3:
>>   - fix flowi info for the route lookup
>>
>> v1 -> v2:
>>   - remove useless check against skb_dst() in xfrmi_xmit2()
>>   - keep incrementing tx_carrier_errors in case of route lookup failure
>>
>>  net/ipv4/ip_vti.c         | 13 +++++++++++--
>>  net/ipv6/ip6_vti.c        | 13 +++++++++++--
>>  net/xfrm/xfrm_interface.c | 32 +++++++++++++++++++++++++-------
>>  3 files changed, 47 insertions(+), 11 deletions(-)
> 
> Applied to the ipsec tree, thanks a lot!
> 
Thanks. Those patches are now in Linus tree:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=95224166a903
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f042365dbffe

Could you queue them for stable trees?


Thank you,
Nicolas

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78A4489CE
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfFQROP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:14:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32925 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfFQROP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:14:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id k187so6181466pga.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 10:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=En+qiiqwAKnNgxo5TxqiVSn7kICNhKhquzG8iOpMlLY=;
        b=sGaHi33906SjLcvsowBVAqALfIudJ8BTf+EoWzx+/gbK7UFqYYQjqMgMc3mN7foRgV
         6htYosj9S+QH9JI7ChgSVxlEVi2/Eux3MflpGPX2R5oqZeb5ZTNwqhWVHJKmx2JkxWQt
         z1Ok4kWiN4VJzXj2kPx2+8b0GztmtCV+CUMvkIoJjs9cW/3WQ03o9tQpALjvUeGTzzc5
         Ix7XuZ0pthuA2Mz+wDZHdD09WEduWnw6aTvnk+KgiGeHPa+0Z4yKp4rSLkSl9HR7yncF
         KXR/Ph4QHOedQbwvS/Akyrva0aL8JCo9GvIEKjcFAA4rQGyyFrNi6XoV4mJ2x1RMWC06
         de1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=En+qiiqwAKnNgxo5TxqiVSn7kICNhKhquzG8iOpMlLY=;
        b=YMYzelqeHSxMAu23VqRKS2fU8HiG4BvVYttIQ3T9+c+RUG+kiXeJUaqrk4gEo/3n26
         9bArKauacgRlCKpvZGngejIdS9NdnLQwBMoOPwj5IyYsL0rK5c/8mBYS06lPmwx9XkMG
         BkSM0doMfUX6fXfHUN5iiEARtt62UifOrCEvPSHoULwzW3as41M0p6IEa1JaD9tRfjk6
         //ApcHBSSRnuMMt5lI+bbSBv5gtjEJL1Na5upR9+/TRHGYzf6TkcZSw9rcfMBfTTxy7z
         oOgZr6MaasYm3LTVN3hFVPY0plLuy11sRrhkyHrZAsrKG0YO84FjXHpZqpRWCUF+ZypM
         lB2Q==
X-Gm-Message-State: APjAAAUVbHxKMQ4sDw79vbYXW/2u8ohi4w0IXZXeb6IjJ4sP1RKL2kgU
        UTj6IOFhW1ekIZrJcs+xorg=
X-Google-Smtp-Source: APXvYqwxrWfDtC9dxHwv8dpVaRYF3PyeR5FU5e6fkOCEV4g5CXxTNMvrfT3VLLX4dAppMT4hv+Vr/g==
X-Received: by 2002:a65:42cd:: with SMTP id l13mr49083276pgp.72.1560791654519;
        Mon, 17 Jun 2019 10:14:14 -0700 (PDT)
Received: from [172.26.125.68] ([2620:10d:c090:180::1:e1dd])
        by smtp.gmail.com with ESMTPSA id h62sm9077665pgc.54.2019.06.17.10.14.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 10:14:13 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>
Subject: Re: [PATCH net 1/4] tcp: limit payload size of sacked skbs
Date:   Mon, 17 Jun 2019 10:14:12 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <A4CFC6DF-2519-4286-9CF2-6994500EFB86@gmail.com>
In-Reply-To: <20190617170354.37770-2-edumazet@google.com>
References: <20190617170354.37770-1-edumazet@google.com>
 <20190617170354.37770-2-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17 Jun 2019, at 10:03, Eric Dumazet wrote:

> Jonathan Looney reported that TCP can trigger the following crash
> in tcp_shifted_skb() :
>
> 	BUG_ON(tcp_skb_pcount(skb) < pcount);
>
> This can happen if the remote peer has advertized the smallest
> MSS that linux TCP accepts : 48
>
> An skb can hold 17 fragments, and each fragment can hold 32KB
> on x86, or 64KB on PowerPC.
>
> This means that the 16bit witdh of TCP_SKB_CB(skb)->tcp_gso_segs
> can overflow.
>
> Note that tcp_sendmsg() builds skbs with less than 64KB
> of payload, so this problem needs SACK to be enabled.
> SACK blocks allow TCP to coalesce multiple skbs in the retransmit
> queue, thus filling the 17 fragments to maximal capacity.
>
> CVE-2019-11477 -- u16 overflow of TCP_SKB_CB(skb)->tcp_gso_segs
>
> Fixes: 832d11c5cd07 ("tcp: Try to restore large SKBs while SACK 
> processing")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Jonathan Looney <jtl@netflix.com>
> Acked-by: Neal Cardwell <ncardwell@google.com>
> Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

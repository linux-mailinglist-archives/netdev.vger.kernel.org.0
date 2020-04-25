Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580531B836E
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 05:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDYDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 23:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726038AbgDYDKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 23:10:10 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD9EC09B049;
        Fri, 24 Apr 2020 20:10:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id n16so5558527pgb.7;
        Fri, 24 Apr 2020 20:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3An5zV6imRC+MQIFrgbQ0gvHOTWynqrauJShX0dmKts=;
        b=MYEdq/eTD4rdn3zhn1Ergy9PNNUNXEq+UEVn6GnEm+z6dpAr8LyOHOhE1gNm4rl6ez
         ekD5FcKs0hr4Wzew5TWOt0qd4B1C4PGIfM0Z37Y4w4Abcif+WHP8iJziD8D6RMbXBE2n
         4FrG56S7L71SiUKO06IhcxU2bAPRIHs3MG6C3L3fdFtaGl2A5q7rqjHjs3gQBhtkVecd
         TUdVVYeuO8lgJYLrWS5sLgBCOUbgCJVxNU8Vc4XO5n1oAqf8CXRXjJkt0+ZowRdyNonE
         s32I4g3eMGzoe5Wi3WRDWaM3FiFc0jeeI5pC+2pU24mrWm15E6dMsrW/zLGp04hPhsGF
         jsIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3An5zV6imRC+MQIFrgbQ0gvHOTWynqrauJShX0dmKts=;
        b=hNx34yb/8tLGPHieSCgIaEjrcOjxSARJcvgu3C8bt1rAKDdJ72AlL4q6klITQ6wr/e
         TXtrldHRJrKgA8JOioiyWGnMoSSnkJdLE3QcHqt7nfSEVLvwmUykIzVPGzaG6KKBvi9P
         DHK9+cuPezZPZ9saNdMVpx8dwr1BRnS6HoMa5aKxfF3uB7Tk1F1+i3j+RFPl2BKIgEF7
         lnFRAPj4FbBm0a+pM/Q3benyRAsObRqHLaFSGAWJQVWSllYGXsEi7urlZkqwttNIbV7b
         +BYzcJYADgt+0tMZeMoDGNV/NLeuvoVCMn56BmwicpIwkkarHjcTwEw+cn7BJlX/6a7T
         P4pQ==
X-Gm-Message-State: AGi0PuYUUXoB33CGRhopAiity2OUvCs/CJ5DQVU3noZPAwZ7yIkjCPJ0
        OhHbyjFzi+8gcpJk5IKm0I8=
X-Google-Smtp-Source: APiQypJ5lQb8KRo5FsIFCbeSRqPasd04JlYYSAi0OH1rZCIR7Ksb232Kb71KXURwj+bUTLaWzQBkhQ==
X-Received: by 2002:a62:174a:: with SMTP id 71mr13634230pfx.297.1587784208488;
        Fri, 24 Apr 2020 20:10:08 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id i18sm5899669pjx.33.2020.04.24.20.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 20:10:07 -0700 (PDT)
Subject: Re: [PATCH net-next 10/33] veth: xdp using frame_sz in veth driver
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757169184.1370371.6898362883018539033.stgit@firesoul>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <ec7bde1d-3d0e-b43c-b4dd-667106ef4cf9@gmail.com>
Date:   Sat, 25 Apr 2020 12:10:01 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158757169184.1370371.6898362883018539033.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/04/23 1:08, Jesper Dangaard Brouer wrote:
> The veth driver can run XDP in "native" mode in it's own NAPI
> handler, and since commit 9fc8d518d9d5 ("veth: Handle xdp_frames in
> xdp napi ring") packets can come in two forms either xdp_frame or
> skb, calling respectively veth_xdp_rcv_one() or veth_xdp_rcv_skb().
> 
> For packets to arrive in xdp_frame format, they will have been
> redirected from an XDP native driver. In case of XDP_PASS or no
> XDP-prog attached, the veth driver will allocate and create an SKB.
> 
> The current code in veth_xdp_rcv_one() xdp_frame case, had to guess
> the frame truesize of the incoming xdp_frame, when using
> veth_build_skb(). With xdp_frame->frame_sz this is not longer
> necessary.
> 
> Calculating the frame_sz in veth_xdp_rcv_skb() skb case, is done
> similar to the XDP-generic handling code in net/core/dev.c.
> 
> Cc: Toshiaki Makita <toshiaki.makita1@gmail.com>
> Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9222C2864A4
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgJGQi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgJGQi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:38:58 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714F9C061755;
        Wed,  7 Oct 2020 09:38:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1257608pll.11;
        Wed, 07 Oct 2020 09:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eleMNIQb7gHtATh1xUcvTG7HUCdElenFbTTcPyhDSnc=;
        b=tRTmiTM9jwWvOTzvDET4KhQtnAoz2ZUQqrBD5kuSR/B1ypVTwD/0yixJDGXLWwl4qo
         CPED75gI9buKhnlEwn4nK0ZJTVeIgra8iUeuIId/cWA3kfKZPlqtxHWKd5UdIlczxY0l
         IHKK9tUf7becvMeUDXnTMFzipMoVuArErHNuFRr1TcGc7+rSSOjG3vsIpGuCKIEnL55D
         +T/nc9ugENV/4avggtpnWNKbmhAOD5ffcbx4Vm8hZPxp/KPr2Nk3Mh7BgcqqW+EVD3U3
         wy79Nipf9NtEkwFW8AisuuUxd2uBx2EOHS+FQzIjK9PhPFOLNRwYSj8dAAI7jeAZ6zfp
         SIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eleMNIQb7gHtATh1xUcvTG7HUCdElenFbTTcPyhDSnc=;
        b=RzfPQUQLSZ804+VXPJWx2CtwbO420eGYHrvc65SfbKpcuhOxUJUJxoLaliGe44L4++
         7H5/HIyBqYqyZKyiXIWmxdavB+ddLGYQpOjIJgrQ9Q2GSP2LXJdAHtm9FzEJ5MGgVuDt
         pPuHstdrQWZUeQ/S1x0lJlWYRWDv8LOMqWOasoqE2PbVHc6uFRVCUyjB/JFWIuik0CVZ
         TnIOYdQ2mRwJCD//ys288SnU0PtJrTacQIDu4hqpDOh3s6SIXctFbFRrtLRHYwwR9IQd
         Y0snjFPxWhDHk6jdxfKP16Z6N79lvcfwjEmrGu6b10jjg51Y1PUJYT+PJ9H/TLDzfI5X
         EtSg==
X-Gm-Message-State: AOAM530uCouKhSWcbfKqckyOyc9q6XrFjyQ1GjmKrNC8B4UJy8abApEq
        bJCHCvqkC2JBRDnZZTOEJgo=
X-Google-Smtp-Source: ABdhPJz0GT8qO12nu0i8QQACgcARFrYLfleCdraKFW8xrzsUprTU5cx8o0DOy0ROBpeZpWg/j5/UoQ==
X-Received: by 2002:a17:902:6ac7:b029:d3:9c6b:9311 with SMTP id i7-20020a1709026ac7b02900d39c6b9311mr3553394plt.0.1602088738055;
        Wed, 07 Oct 2020 09:38:58 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id u18sm4142621pgk.18.2020.10.07.09.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 09:38:57 -0700 (PDT)
Subject: Re: [PATCH bpf-next V1 2/6] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
 <160200017655.719143.17344942455389603664.stgit@firesoul>
 <CANP3RGfeh=a=h2C4voLtfWtvKG7ezaPb7y6r0W1eOjA2ZoNHaw@mail.gmail.com>
 <20201007094228.5919998b@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <23e087e7-066c-2228-8df7-3a6b81ad2ba0@gmail.com>
Date:   Wed, 7 Oct 2020 09:38:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201007094228.5919998b@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/20 12:42 AM, Jesper Dangaard Brouer wrote:
> 
> The struct bpf_fib_lookup is exactly 1 cache-line (64 bytes) for
> performance reasons.  I do believe that it can be extended, as Ahern
> designed the BPF-helper API cleverly via a plen (detail below signature).

Yes, I kept it to 64B for performance reasons which is why most fields
have 1 value on input and another on output.

Technically it can be extended, but any cost in doing so should be
abosrbed by the new feature(s). Meaning, users just doing a fib lookup
based on current API should not take a hit with the extra size.


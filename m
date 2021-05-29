Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618293949D9
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhE2Be7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhE2Bez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 21:34:55 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B6C061574;
        Fri, 28 May 2021 18:33:18 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so5250805otp.4;
        Fri, 28 May 2021 18:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZdTpmdx7Jp4Q6fJ8wnwETtC6abF/h+FRps3zIoaug5M=;
        b=YiKtOeYpbKrTZ1YR+/qseCOdpEZqMzRI+o7k5Ayb3IRR0ei6eD1zv3DwVRxf9ptg4O
         Ual0AooJqw8yZZcP65NKY45ZODYPIMTOYVj6CcxZwkzUTmezUURveZAsLXLVTwjWdvN/
         W6pDPKsHbZ0SHcjZNXrvGxCBwSfk6o8q/H8Y2zOSOlMDsZ0B2d61PMkpuyK2/RyAjJri
         Ws8PxdfjH0zm5JXnpA5rl19Xl/jSHauz7aRnnlUB1kqIgu5yGWbXzU1BrNl+5h4xekOh
         sqEfYohm5nPA8Ie7QjDeCKpUS5+X/IL48l5uei8v4Tt6rluO9D3ELLkt+ARxuSKHWrZ2
         9b5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZdTpmdx7Jp4Q6fJ8wnwETtC6abF/h+FRps3zIoaug5M=;
        b=J7gsHotwZ6fu/8xHLrB0KjV1PxULXoXarB6cDzpU68IeV/iZG4qnfyAsKRlBqHxEF0
         a/DhYeHCJR6hFkkoiZFkaw/iwP+C5J+Ra15NJSXcIe/oyg51tQZ/fPWTWsjau7P30mNN
         uW8zKvxtquv076n/6LuNuOo3pUKwfFaURDWjwPUfevGe867+ROI58XXkoHxDv8x8ftDA
         MxHR8vAWzS9LU5sUx6aF9v4Mhki8gEygtImv9dwJZEbmSmhtbZ3vnFB/gl09Of/0mYng
         1FcAL8mbGB7Ytjj+VA/JSznkm1ryuOhc4VBCSx8G60wKIUAqJSDwSctIFHI0zI/TQP++
         EjYQ==
X-Gm-Message-State: AOAM533DRAbg8IhLiln3tD6MLd83bvdiwQw1BJqGxrJzD02FLunziimX
        c+EhipdGETLP+S00BNoZlrk=
X-Google-Smtp-Source: ABdhPJygNYzOeoEMmquoKEqSPQW8bFWl2IlZ/vn7SfwbgblbRCifBlE4fMYBqU1/WTP+iFpHQyLfeA==
X-Received: by 2002:a9d:6c46:: with SMTP id g6mr9127649otq.260.1622251997723;
        Fri, 28 May 2021 18:33:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x65sm1512213otb.59.2021.05.28.18.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 18:33:17 -0700 (PDT)
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
To:     Tom Herbert <tom@herbertland.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        magnus.karlsson@intel.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, bjorn@kernel.org,
        =?UTF-8?Q?Maciej_Fija=c5=82kowski_=28Intel=29?= 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>
References: <cover.1622222367.git.lorenzo@kernel.org>
 <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
 <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a0c5814d-62b1-d138-65f3-db42485476cc@gmail.com>
Date:   Fri, 28 May 2021 19:33:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 3:18 PM, Tom Herbert wrote:
> On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>
>> Introduce flag field in xdp_buff and xdp_frame data structure in order
>> to report xdp_buffer metadata. For the moment just hw checksum hints
>> are defined but flags field will be reused for xdp multi-buffer
>> For the moment just CHECKSUM_UNNECESSARY is supported.
>> CHECKSUM_COMPLETE will need to set csum value in metada space.
>>
> Lorenzo,
> 
> This isn't sufficient for the checksum-unnecessary interface, we'd
> also need ability to set csum_level for cases the device validated
> more than one checksum.

That's on me. The original patch was for XDP_REDIRECT to VMs and the
VIRTIO_NET_HDR_ API does not support csum_level.
VIRTIO_NET_HDR_F_DATA_VALID means CHECKSUM_UNNECESSARY, an API
implemented 10 years ago.

> 
> IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
> For years now, the Linux community has been pleading with vendors to
> provide CHECKSUM_COMPLETE which is far more useful and robust than
> CHECSUM_UNNECESSARY, and yet some still haven't got with the program
> even though we see more and more instances where CHECKSUM_UNNECESSARY
> doesn't even work at all (e.g. cases with SRv6, new encaps device
> doesn't understand). I believe it's time to take a stand! :-)
>

There is no new hardware or new feature at play here. This about XDP
frames getting the checksum validation setting that an skb enjoys today.
You are taking a stand against S/W equivalency with the existing NICs?
That basically penalizes XDP, continuing to limit its usefulness with
very well established use cases that could benefit from it.


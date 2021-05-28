Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA2C3946BC
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhE1SC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 14:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhE1SCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 14:02:55 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D0FC061574;
        Fri, 28 May 2021 11:01:19 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id d21so5036653oic.11;
        Fri, 28 May 2021 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4oRbDxiKiaJ8NU9MeXqhyulsKjVs1HP5NtzGL3mFOxs=;
        b=lTV/5w1xweq7bB94IGwkHk99cHMtma+eh7lQ8hFAq5gr0GQEG+0XzBkJFzXnLLYKQI
         9o3drGnOl4kw+LAJC69u9ruBnhXQDQiuxKSGgyGCaCoofh+6tGmlE6uLPVynAueq2gt7
         IJEfTm9Hipi3bfmlwM/HnsVzNMPfkBARhmYCu2BUEzrYQB2AlhWxzwfCULLqVYOrYkR9
         FHBEFpefA/iVzq9IGVRDwowVmergcwW7/gCS6mn8pFFpdogeL+NWq3guDPUABNXd82xg
         8GXOLTLFC53hOXlNVMFYIzlj0rS3dhTPF8FUOMouY9oVC0mU4N1j/seTPbQcexqVY+gN
         D8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4oRbDxiKiaJ8NU9MeXqhyulsKjVs1HP5NtzGL3mFOxs=;
        b=ST6KyG7J1cmAyzt2HiRg6g4d57WikhBG3cNsUKLT5r8hRHlSqj5BnM09qaHMtaZVMT
         wCbo77PTB2iM3V2cf+urEooLSXp2T7iNBbncpc2NsIR5qgb1azShzECYSJ5endzAKjQl
         GiJjWeAo+DUpqMc5WWj/VpzZyPdCc4rmpaq/jkwMGoT/PHL2KouYf/dYCEm/A6ymxfE1
         xSHbMDV6t1vKabIsuKn4sPQag17XnMZSm7h9Gitqlzv1bXKSoTH6ebbaiGJC8izZNpi1
         83TQ4GzMNlJ9ZJJdRxU3j3D2OYKtDaENRJdXnAkYDut5ZVO6rQ/7NciPHorEwWj2jPCU
         WTMg==
X-Gm-Message-State: AOAM5327A0ccwTghi/DiSP+B/P6BsIupRzqMLb0MAtHIQ5PHNPXvVKaY
        6Ugpl1vZ369Qozk+6c3UOmE=
X-Google-Smtp-Source: ABdhPJycyNoffQyB8UAO2RC7Op/Wq86x6vTCf5XNYcnn6P5vo7IeZvhTwZQKoNewRWkOYSLCYmcXeA==
X-Received: by 2002:a54:4794:: with SMTP id o20mr6629918oic.99.1622224878922;
        Fri, 28 May 2021 11:01:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id a7sm1248885ooo.9.2021.05.28.11.01.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 11:01:18 -0700 (PDT)
Subject: Re: [RFC bpf-next 0/4] add partial rx hw csum offload support for XDP
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, echaudro@redhat.com,
        magnus.karlsson@intel.com, toke@redhat.com, brouer@redhat.com,
        bjorn@kernel.org, maciej.fijalkowski@intel.com,
        john.fastabend@gmail.com
References: <cover.1622222367.git.lorenzo@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a16282b-6bf4-e0dc-96ec-bde54758b504@gmail.com>
Date:   Fri, 28 May 2021 12:01:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <cover.1622222367.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/21 11:43 AM, Lorenzo Bianconi wrote:
> Enable xdp rx checksum offload support for CHECKSUM_UNNECESSARY use-case.
> Introduce flag field in xdp_buff/xdp_frame in order to save the checksum
> result from the NIC and have a fast access to it performing XDP_REDIRECT.
> CHECKSUM_COMPLETE is not supported yet since it will require adding the
> csum result to the xdp_metadata area.
> Moreover flag field will be reused for xdp multi-buff support.
> This series has been tested generating UDP traffic with pktgen and performing
> a xdp_redirect from an ixgbe device to a remote CPUMAP entry. PPS results show
> a negligible penalty respect to the baseline where the UDP checksum has been
> disabled. More info about the test can be found here [0].
> 
> [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp_frame01_checksum.org
> 

For the wider audience, another example of the performance benefit of
this rather simple change is XDP_REDIRECT to VMs (and containers) for
TCP traffic which requires checksum.

The VM piece requires the change to the tun driver from my original
patch which passes the VIRTIO_NET_HDR_F_DATA_VALID flag for
CHECKSUM_UNNECESSARY:

https://github.com/dsahern/linux/commit/b6b4d4ef9562383d8b407a873d30082afdc1b89c

(I can send that followup after this set lands.)

Using ConnectX-5 and the mlx5 change in the above commit I was seeing at
least a 300k pps improvement depending on the test. e.g., from 2M pps to
2.3M for 1500 MTU packets or 1.3M to 1.6M for 3400 MTU.

Similar results for containers.

Right now the checksum validation done by H/W is lost on the redirect.
This change propagates the validation and avoids the csum_partial
overhead as the skb is processed.

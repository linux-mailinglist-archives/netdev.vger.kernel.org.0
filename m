Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151C74552F2
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 03:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242280AbhKRC57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 21:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240790AbhKRC56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 21:57:58 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF76AC061570;
        Wed, 17 Nov 2021 18:54:58 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 8so4507813pfo.4;
        Wed, 17 Nov 2021 18:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=77sXzKb3qBixJ++XdkRbMoa0EMCrbI7IHQol4+NzyOE=;
        b=Vznxm/aa3HjY+YYXl6cGDc/uSN6ZsMWBnjlfA9TTPt1TUWK5TINwUrlDs89DD3WNDN
         ANKkgUGHXj7K28Y265Pf+4KxOf2tPVfwQdGPoui5wgx8k2kAZHKwMXIlX7wpoGv6MH49
         R7iPt1NQ7eYbM9Gul0rK849PON9UgAwghKZl5Z6TEbmHMUP3faFm/X4oShklfCRUDbVy
         seaoeKBPME/yE+j7I9V+xeARgFsxw1Lm8wq+9nGbS8QW19x6fpH/hn4glQ1St7LGBh/4
         krH8KRQ6W9K6tmXt13/KP+rQpmfltAITQ+D6zNcPFG/wUGmb68zkF0jL8QT8X0n1sspi
         pQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=77sXzKb3qBixJ++XdkRbMoa0EMCrbI7IHQol4+NzyOE=;
        b=nnoar2uZonPwESOYhZjNNN4MLi5N3eclY1bqMexXDFxB/Ra3rdISxsBkqUcDjKgSSC
         JWQzO21w0IUf6samGsfnsI18scBYvAQla9T9MYvKzW/JsvuoKLhrPr3SPMlp582tptf/
         ZbeFFV+PtsQU0ZaaIH9/S+JDdGnyp8SnpxYfbEW8hKxswQ/SjOoFI43SBw0nlPTYYtN4
         CfSG6/YMfAfFEmau4B0ihiTZXM/2PwaDA2C4ETp4+7CwKHUJ7GBCfE3XKnV2vr4Kqsy3
         gau4TlCKRDZdrHYr1qJn4ufQOzU0VIo7eA97yI5MpC2ecwZPThzSIiRi+yk8hhtGrEk6
         6rXg==
X-Gm-Message-State: AOAM531vqVdc5ld8kvVEXvRhjES6vni3w4wGWA/9JCxs5j7xTiaOLUUM
        QT2LcnFv3dBy+yIkW5uoKwE=
X-Google-Smtp-Source: ABdhPJwDOLhpnqhm0ivUMgz3f9BSSWLw+re/TmubZXcsrA+/xDsqVai7QPQKZhbeI1BhQdzROSEj0w==
X-Received: by 2002:a63:a5f:: with SMTP id z31mr8840139pgk.426.1637204098298;
        Wed, 17 Nov 2021 18:54:58 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2349])
        by smtp.gmail.com with ESMTPSA id z10sm994382pfh.106.2021.11.17.18.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 18:54:57 -0800 (PST)
Date:   Wed, 17 Nov 2021 18:54:55 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com
Subject: Re: [RFC PATCH bpf-next 0/8] XDP_REDIRECT_XSK and Batched AF_XDP Rx
Message-ID: <20211118025455.5nizcavybink4a4b@ast-mbp.dhcp.thefacebook.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 07:37:34AM +0000, Ciara Loftus wrote:
> The common case for AF_XDP sockets (xsks) is creating a single xsk on a queue for sending and 
> receiving frames as this is analogous to HW packet steering through RSS and other classification 
> methods in the NIC. AF_XDP uses the xdp redirect infrastructure to direct packets to the socket. It 
> was designed for the much more complicated case of DEVMAP xdp_redirects which directs traffic to 
> another netdev and thus potentially another driver. In the xsk redirect case, by skipping the 
> unnecessary parts of this common code we can significantly improve performance and pave the way 
> for batching in the driver. This RFC proposes one such way to simplify the infrastructure which 
> yields a 27% increase in throughput and a decrease in cycles per packet of 24 cycles [1]. The goal 
> of this RFC is to start a discussion on how best to simplify the single-socket datapath while 
> providing one method as an example.
> 
> Current approach:
> 1. XSK pointer: an xsk is created and a handle to the xsk is stored in the XSKMAP.
> 2. XDP program: bpf_redirect_map helper triggers the XSKMAP lookup which stores the result (handle 
> to the xsk) and the map type (XSKMAP) in the percpu bpf_redirect_info struct. The XDP_REDIRECT 
> action is returned.
> 3. XDP_REDIRECT handling called by the driver: the map type (XSKMAP) is read from the 
> bpf_redirect_info which selects the xsk_map_redirect path. The xsk pointer is retrieved from the
> bpf_redirect_info and the XDP descriptor is pushed to the xsk's Rx ring. The socket is added to a
> list for flushing later.
> 4. xdp_do_flush: iterate through the lists of all maps that can be used for redirect (CPUMAP, 
> DEVMAP and XSKMAP). When XSKMAP is flushed, go through all xsks that had any traffic redirected to 
> them and bump the Rx ring head pointer(s).
> 
> For the end goal of submitting the descriptor to the Rx ring and bumping the head pointer of that 
> ring, only some of these steps are needed. The rest is overhead. The bpf_redirect_map 
> infrastructure is needed for all other redirect operations, but is not necessary when redirecting 
> to a single AF_XDP socket. And similarly, flushing the list for every map type in step 4 is not 
> necessary when only one socket needs to be flushed.
> 
> Proposed approach:
> 1. XSK pointer: an xsk is created and a handle to the xsk is stored both in the XSKMAP and also the 
> netdev_rx_queue struct.
> 2. XDP program: new bpf_redirect_xsk helper returns XDP_REDIRECT_XSK.
> 3. XDP_REDIRECT_XSK handling called by the driver: the xsk pointer is retrieved from the 
> netdev_rx_queue struct and the XDP descriptor is pushed to the xsk's Rx ring.
> 4. xsk_flush: fetch the handle from the netdev_rx_queue and flush the xsk.
> 
> This fast path is triggered on XDP_REDIRECT_XSK if:
>   (i) AF_XDP socket SW Rx ring configured
>  (ii) Exactly one xsk attached to the queue
> If any of these conditions are not met, fall back to the same behavior as the original approach: 
> xdp_redirect_map. This is handled under-the-hood in the new bpf_xdp_redirect_xsk helper so the user
> does not need to be aware of these conditions.

I don't think the micro optimization for specific use case warrants addition of new apis.
Please optimize it without adding new actions and new helpers.

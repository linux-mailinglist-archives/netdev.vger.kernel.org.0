Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B847752F3
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbfGYPjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:39:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41505 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728392AbfGYPjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:39:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so22965223pff.8;
        Thu, 25 Jul 2019 08:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gjFiRYd7PJXDiaH07R1tdzSfdYQ8jSyV4Rg/fDB7H6Q=;
        b=eSdUUCjVxdWi1k/cpqscjd7EO/M7+vEUrQ3BPtcLeDSkLyUtz+PA4IbpFYxSnHkWWN
         Gg7UCkBF75m48cfEJIXE83HWhSW0WFNMZKj+lrQh/WfJ7l43gv94E5Xg9yTnuC74a05g
         edJR8zkN8fCrc17Uulqox/z0c+fyxRx3S1MDwhI7InF9hNDCG7kN9mJQmkDynzuoSHpT
         4BnmoWypx3+/hD9a4x/ollXGy5EFt8OZbb9iIs8dQosUdffXGQ42K53/JRghgnCZqFBt
         t2/OGU1WvSczMt/tYuBJfM5dlRYVca0yb5F3Dpw9zlaj+bZowo4xU7OEb/V0P4GhbLMs
         al8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gjFiRYd7PJXDiaH07R1tdzSfdYQ8jSyV4Rg/fDB7H6Q=;
        b=V2At1kwUQbBTnXb7CStKv/LzMGO9cfLzBfwhsFyGfwPB4JdswEN5QR6BVaPt3Awp/p
         zKLcWe/CCr4j9NzfQ+ckMpQBTHhO4GfXS9/ib15zACoLprX6oquUilMJuEny2rF0xehC
         P6VjO+K68QekdSTSHsAVUogmxXE6DCTwnaV8eo1c4ULYCdujnvQIfsPjFFe66BzNeOJa
         ikPzK1AjMy6ZIybQE64LVdPrBqItJ9T/b+HJlIPQ5dfgKUYr9tpYvl9/uyYO4lxhcbGf
         UvdMA2pDA+w8Z2VX/hiqv1ARoAZ6KWsOx38oFaSmucN5atAo88668Z6zHyaq29HGudZ1
         K4kg==
X-Gm-Message-State: APjAAAWjVUgbrez9eEGwQIe1rmbI8t3tJ0Hl12NGjaXWQMm/agrrrAF4
        YPD61QR7bNF6+80nOTVtwLE=
X-Google-Smtp-Source: APXvYqw5W/Fw0G7+SAY9GLr1ZK9dvqwrSp/xY2xVl7d8EtFEQp7LX9rcEhQ3UMDhF+/g9KfXui50/g==
X-Received: by 2002:a63:f857:: with SMTP id v23mr62010467pgj.228.1564069161037;
        Thu, 25 Jul 2019 08:39:21 -0700 (PDT)
Received: from [172.20.174.128] ([2620:10d:c090:180::1:622f])
        by smtp.gmail.com with ESMTPSA id f6sm52701201pga.50.2019.07.25.08.39.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 08:39:20 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Kevin Laatz" <kevin.laatz@intel.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com,
        maximmi@mellanox.com, stephen@networkplumber.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v3 00/11] XDP unaligned chunk placement support
Date:   Thu, 25 Jul 2019 08:39:19 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <94EAD717-F632-499F-8BBD-FFF5A5333CBF@gmail.com>
In-Reply-To: <20190724051043.14348-1-kevin.laatz@intel.com>
References: <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190724051043.14348-1-kevin.laatz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Jul 2019, at 22:10, Kevin Laatz wrote:

> This patch set adds the ability to use unaligned chunks in the XDP umem.
>
> Currently, all chunk addresses passed to the umem are masked to be chunk
> size aligned (max is PAGE_SIZE). This limits where we can place chunks
> within the umem as well as limiting the packet sizes that are supported.
>
> The changes in this patch set removes these restrictions, allowing XDP to
> be more flexible in where it can place a chunk within a umem. By relaxing
> where the chunks can be placed, it allows us to use an arbitrary buffer
> size and place that wherever we have a free address in the umem. These
> changes add the ability to support arbitrary frame sizes up to 4k
> (PAGE_SIZE) and make it easy to integrate with other existing frameworks
> that have their own memory management systems, such as DPDK.
> In DPDK, for example, there is already support for AF_XDP with zero-copy.
> However, with this patch set the integration will be much more seamless.
> You can find the DPDK AF_XDP driver at:
> https://git.dpdk.org/dpdk/tree/drivers/net/af_xdp
>
> Since we are now dealing with arbitrary frame sizes, we need also need to
> update how we pass around addresses. Currently, the addresses can simply be
> masked to 2k to get back to the original address. This becomes less trivial
> when using frame sizes that are not a 'power of 2' size. This patch set
> modifies the Rx/Tx descriptor format to use the upper 16-bits of the addr
> field for an offset value, leaving the lower 48-bits for the address (this
> leaves us with 256 Terabytes, which should be enough!). We only need to use
> the upper 16-bits to store the offset when running in unaligned mode.
> Rather than adding the offset (headroom etc) to the address, we will store
> it in the upper 16-bits of the address field. This way, we can easily add
> the offset to the address where we need it, using some bit manipulation and
> addition, and we can also easily get the original address wherever we need
> it (for example in i40e_zca_fr-- ee) by simply masking to get the lower
> 48-bits of the address field.

I wonder if it would be better to break backwards compatibility here and
say that a handle is going to change from [addr] to [base | offset], or
even [index | offset], where address = (index * chunk size) + offset, and
then use accessor macros to manipulate the queue entries.

This way, the XDP hotpath can adjust the handle with simple arithmetic,
bypassing the "if (unaligned)", check, as it changes the offset directly.

Using a chunk index instead of a base address is safer, otherwise it is
too easy to corrupt things.
-- 
Jonathan

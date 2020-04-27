Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FDA1BAC8C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD0SZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgD0SZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:25:41 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFDEC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:25:41 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id u189so17686056ilc.4
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=UB/59gTA+3qnl/w1EdBNmgmwgaFKjeMEYssIEx4ZngI=;
        b=JyWsfCvxRbToQSU+/xbrUWfDp25gjtaSknJTHuGZWzQVhryQ9R3Pg+vziOdd8FePka
         4ABsQvMMzO1/R9+t8VoehTjZ53BUzXe4oYJI1Nwx9rdYJN7CC9vF0Gsrf7B2pVOazmML
         5oq/YLc5Vfm0tc2YH5RJGgILgFXz4DI7gOpaNvwBINkOJlbkbSuDwOe2U1jDCfHLfkFF
         uwCZzvq1yPOP0upaiFtaqO6yI8WvDwo+XtdkmQHQgAulEDnmgpx2f/+IzApKz4j7ULzc
         EfzBBWhRV0U+jKpWUi/CR+rG8+UTqcidfAKNeYoZ6FHeKH9+o/oAsqa8t5GKtjoW0hTj
         X+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=UB/59gTA+3qnl/w1EdBNmgmwgaFKjeMEYssIEx4ZngI=;
        b=GHsQ4yZg1tCUConSMceN3dF+0hHxHgex9JNBXNfp2kk7UI8qFDftVtrAIBBNVmIJJo
         F2WfI5zKluJsslC2aQwQS2beRHRXH2MeqCscyiPJSG+WxoKVTnDqVA08AYjhSaU4QTpg
         XRehkAxfFaiBA+WvQF82BGAe24A4Qss1URHrMvVcvKRrHkPfrm8IIgLABSXAs4cx42vT
         w/pPTISJx8Es0RzjZ+ocKeyPG2dxz0i9uIqw6hrlU+Tog3Mn22+gWApuEqfEhHEPUIS1
         pNg1kB4pF9Nf9PYUMypy6KPhghcfT7jdYvVHYIQSb8yztohpNWHN6YHFZaMo/Z0WjPRH
         zVEw==
X-Gm-Message-State: AGi0PuY/QbwCUhfx4xKKugpkpXQTe5RPdew9m/dDRtmX6o6QzoTobTam
        mwoRII3LhN9Vj9EoO6q9RKA=
X-Google-Smtp-Source: APiQypKHTjMj6zmWy8ArhgRNCEEf/g8hV2dQGzIiADJZz+9ast4rIohYLfKVVrOeDdNXCN8YFQvlJQ==
X-Received: by 2002:a92:5b05:: with SMTP id p5mr21092447ilb.94.1588011940397;
        Mon, 27 Apr 2020 11:25:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 140sm5740337ilc.44.2020.04.27.11.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 11:25:39 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:25:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Message-ID: <5ea7239c8df43_a372ad3a5ecc5b82c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200424201428.89514-1-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
Subject: RE: [PATCH v3 bpf-next 00/15] net: Add support for XDP in egress path
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> This series adds support for XDP in the egress path by introducing
> a new XDP attachment type, BPF_XDP_EGRESS, and adding a UAPI to
> if_link.h for attaching the program to a netdevice and reporting
> the program. bpf programs can be run on all packets in the Tx path -
> skbs or redirected xdp frames. The intent is to emulate the current
> RX path for XDP as much as possible to maintain consistency and
> symmetry in the 2 paths with their APIs.
> 
> This is a missing primitive for XDP allowing solutions to build small,
> targeted programs properly distributed in the networking path allowing,
> for example, an egress firewall/ACL/traffic verification or packet
> manipulation and encapping an entire ethernet frame whether it is
> locally generated traffic, forwarded via the slow path (ie., full
> stack processing) or xdp redirected frames.

I'm still a bit unsure why the BPF programs would not push logic into
ingress XDP program + skb egress. Is there a case where that does not
work or is it mostly about ease of use for some use case?

Do we have overhead performance numbers? I'm wondering how close the
redirect case with these TX hooks are vs redirect without TX hooks.
The main reason I ask is if it slows performance down by more than say
5% (sort of made up number, but point is some N%) then I don't think
we would recommend using it.

> 
> Nothing about running a program in the Tx path requires driver specific
> resources like the Rx path has. Thus, programs can be run in core
> code and attached to the net_device struct similar to skb mode. The
> egress attach is done using the new XDP_FLAGS_EGRESS_MODE flag, and
> is reported by the kernel using the XDP_ATTACHED_EGRESS_CORE attach
> flag with IFLA_XDP_EGRESS_PROG_ID making the api similar to existing
> APIs for XDP.
> 
> The locations chosen to run the egress program - __netdev_start_xmit
> before the call to ndo_start_xmit and bq_xmit_all before invoking
> ndo_xdp_xmit - allow follow on patch sets to handle tx queueing and
> setting the queue index if multi-queue with consistency in handling
> both packet formats.
> 
> A few of the patches trace back to work done on offloading programs
> from a VM by Jason Wang and Prashant Bole.

The idea for offloading VM programs would be to take a BPF program
from the VM somehow out of band or over mgmt interface and load it
into the egress hook of virtio?

Code LGTM other than a couple suggestions on the test side but I'm
missing something on the use case picture.

Thanks,
John

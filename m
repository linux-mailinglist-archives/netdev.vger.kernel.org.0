Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D591ED42C
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 18:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgFCQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 12:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCQXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 12:23:02 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD90C08C5C0;
        Wed,  3 Jun 2020 09:23:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o8so2072376pgm.7;
        Wed, 03 Jun 2020 09:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s7Ko6upiKAIvqYL063g9Rc3Xn7QRvM5OJQcOqOMGn4U=;
        b=rrwhxy37h03q7p2U6a2+yR9r95zdtmyfsaGq+5/pmM54tFyLU53gbwIxy327hv4jFa
         ZfCxGhnyTaBfFwlmSfYbn9TshqD8dhElUGlCTPAyv3DF+sc6pJyrEmOTD0a/ASuI0jsE
         RTrHhVQ0MnvN29qP3uBCsnAHDjxg8hVLh/gvK/R0+QwbIw8VnfMgyNLUixH6YqN7Qx6i
         SKQVG/Mh2piAabxY/s10LDi3WAd8fWqNlSnTirVpjMd0hPspUeG4nkhDa/g0W/YSf1tk
         Gb6TU7we4yruHT1IaFz/VpJC9h3sXtkZ+SMCt8VfRtxuNx4OREycte31PmrrIiM7jz5g
         Wy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s7Ko6upiKAIvqYL063g9Rc3Xn7QRvM5OJQcOqOMGn4U=;
        b=JZCmgm8urwYCqKR0CrF9Ft66zkS7fV83LOcoXP1LpowO0tk18e89IyieQJEmM9P9+C
         O5gk79gBIeWGzNRw5EndThGPy6WQUui6mDX3TXoCAc+cVKAVoT8y1KhSI3M1LKGQuYk0
         fBcNQXtV+s+1xOquzHDomo21GODMsL5XgN+VTNxOin72UdprnMxIptFnhq+LdDFgLPEO
         /egZGtiO1CCf65tiNFgaEAeju0tsDNn8+w9zU/sWUv2fQaOmqnrr3blWjQM/MQrNV/t/
         RbsF6SrkCA4gXxx1ldR2FrqEAMvu94K40XqCn6wr4R6/BBgXPS1gkdP+4pSoGgfN2Zhg
         FrCQ==
X-Gm-Message-State: AOAM531eaeICvxGqWcy91f6hghZ+tGjsM5R7sm7odq+xgno4Cwwqhr+9
        emw8K/smTUlcyyqmiMAtT0Q=
X-Google-Smtp-Source: ABdhPJw6rBWTPBUW9ehxH1BKjm+dkXuXj74CvXevwAvXkT3gUOhDdmcX8TDlYiLPUdP5AtFDIqv4bQ==
X-Received: by 2002:a63:6604:: with SMTP id a4mr218583pgc.12.1591201380246;
        Wed, 03 Jun 2020 09:23:00 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:514a])
        by smtp.gmail.com with ESMTPSA id m12sm3000411pjs.41.2020.06.03.09.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 09:22:59 -0700 (PDT)
Date:   Wed, 3 Jun 2020 09:22:57 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
Message-ID: <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159119908343.1649854.17264745504030734400.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 05:44:43PM +0200, Jesper Dangaard Brouer wrote:
> The recent commit fbee97feed9b ("bpf: Add support to attach bpf program to a
> devmap entry"), introduced ability to attach (and run) a separate XDP
> bpf_prog for each devmap entry. A bpf_prog is added via a file-descriptor,
> thus not using the feature requires using value minus-1. The UAPI is
> extended via tail-extending struct bpf_devmap_val and using map->value_size
> to determine the feature set.
> 
> There is a specific problem with dev_map_can_have_prog() check, which is
> called from net/core/dev.c in generic_xdp_install() to refuse usage of
> devmap's from generic-XDP that support these bpf_prog's. The check is size
> based. This means that all newer features will be blocked from being use by
> generic-XDP.
> 
> This patch allows userspace to skip handling of 'bpf_prog' on map-inserts.
> The feature can be skipped, via not including the member 'bpf_prog' in the
> map-value struct, which is propagated/described via BTF.
> 
> Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com

The patch makes no sense to me.
please expose 'struct struct bpf_devmap_val' in uapi/bpf.h
That's what it is whether you want to acknowledge that or not.

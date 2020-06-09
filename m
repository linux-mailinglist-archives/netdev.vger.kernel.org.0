Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCA11F3208
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgFIBeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgFIBeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 21:34:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23052C03E969;
        Mon,  8 Jun 2020 18:34:14 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d10so9583452pgn.4;
        Mon, 08 Jun 2020 18:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jhL9ib6Qh1vBgJAv4YXNv9y7jnx3ua/7/dlVLGaEkfU=;
        b=f5sLNW9gYB2SmY/52HyeO/PqFaZQO0Fz3S2bogmvU9vHk+mLFcbRiJRwjZ0nwy268q
         2db9ANGqcY3F1dB+z0Kt7fJ94Qhz1t1LHzR+ENG1m+gpWfCf4/oiolvKSd5LeWuCCyFM
         lJk9OiISOcoy+fSwNg6uLyro1kBQMgm+o2oTaVtqoxud8n0a0hLayxujWw1MGgSMZrfP
         o3IBBLRTDGNheTxRJthGGDAb7ITFwVRJc/5rcdr7ba+yDKR9feLxGFyA99cDcRjH7QTk
         MA8DkGTVcj5gohyHAOtUqt7XzqW3ipyemBSnhTNyUCL+vk2n6iogXZ9Pqx32xhOB7BEU
         J0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jhL9ib6Qh1vBgJAv4YXNv9y7jnx3ua/7/dlVLGaEkfU=;
        b=MxjUcJkMa9ZbMcVQ93zCYq2Y6GVeDagAn1h79EkWMI1/C6g6rhQinRvuGnnhOl7xu+
         jjIspF7q/4WgyJt5wfWUad1LuZIP+GYuZ47HdWfyDgIDni5DByT7vXBAHds6VBqNu8T+
         +zcJuN54x4CGearJsMs/RXYvK4cUAQRhnKSF0NNFc/WcSrfo1FOHn8rl0iUdzTBGgkUY
         DMKCu66Mzxj+ogxpfNf1c/+8QtSsnxI5kJfhpfR2jPn8hX7Kt2tw7qfRrysp3mxWN6iO
         OIkYnxlVGKdIc5WCfFYps7c+Q0JCCv50krrHEEfTEbaedUKLHmSw16nEBK93iSxR9vQu
         01Gw==
X-Gm-Message-State: AOAM531PTVRmRBMWnKntnq4CHswE/v+U1LF7LfsTVijTXDR0a0rV/PXf
        HdthRHYDi+VU2YsG8DakwsNS2O6j
X-Google-Smtp-Source: ABdhPJz5b8azXlyQZ+ntJNGoYOVwRSbF2b0SQ5/7EuoM0alvySRf/6LZepFHVXhxris5byjHMJEMaw==
X-Received: by 2002:a63:7a12:: with SMTP id v18mr22906725pgc.131.1591666453433;
        Mon, 08 Jun 2020 18:34:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:73f9])
        by smtp.gmail.com with ESMTPSA id e78sm8290079pfh.50.2020.06.08.18.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 18:34:12 -0700 (PDT)
Date:   Mon, 8 Jun 2020 18:34:10 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf 0/3] bpf: avoid using/returning file descriptor value
 zero
Message-ID: <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159163498340.1967373.5048584263152085317.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 06:51:12PM +0200, Jesper Dangaard Brouer wrote:
> Make it easier to handle UAPI/kABI extensions by avoid BPF using/returning
> file descriptor value zero. Use this in recent devmap extension to keep
> older applications compatible with newer kernels.
> 
> For special type maps (e.g. devmap and cpumap) the map-value data-layout is
> a configuration interface. This is a kernel Application Binary Interface
> (kABI) that can only be tail extended. Thus, new members (and thus features)
> can only be added to the end of this structure, and the kernel uses the
> map->value_size from userspace to determine feature set 'version'.

please drop these kabi references. As far as I know kabi is a redhat invention
and I'm not even sure what exactly it means.
'struct bpf_devmap_val' is uapi. No need to invent new names for existing concept.

> The recent extension of devmap with a bpf_prog.fd requires end-user to
> supply the file-descriptor value minus-1 to communicate that the features
> isn't used. This isn't compatible with the described kABI extension model.

non-zero prog_fd requirement exists already in bpf syscall. It's not recent.
So I don't think patch 1 is appropriate at this point. Certainly not
for bpf tree. We can argue about it usefulness when bpf-next reopens.
For now I think patches 2 and 3 are good to go.
Don't delete 'enum sk_action' in patch 2 though.
The rest looks good to me.
Thanks!

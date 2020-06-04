Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451081EE976
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbgFDRdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbgFDRdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 13:33:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E38C08C5C0;
        Thu,  4 Jun 2020 10:33:45 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q16so2473971plr.2;
        Thu, 04 Jun 2020 10:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=T+6H1+9Hc5xNAJNMrtQes/xq+kxehbavBD4hX3343tc=;
        b=iG5gsumFGxrHozrLYw1FZsfw0QE6p6Gu+15o8yVaiX4tnxixG9Qt2T9FBU0s953Dti
         NBukuJ7gc4HmmlhSqQGOR/2MfnNOlxajLMWxzhnCx1YmUuAkViDfWhz9XUt5xX5Y3Hgd
         /QmDT76vAMAa3S6kUS83NyfHw6HnVAa+reQaXYrNviTgze25w4J9yZzRWG4OUCzI062t
         npntV62shwKD0YJrH93Cf7aakUFEVfIw8ju36Tv5f47XD8tH1SQ8s+itoMfTFGcmM2sB
         UGRwW3G5QYv4/1h7M9N/YRXNE1uHOMpJFbMl3kbBpJZUgnNQv8Z6JGSYxlu63pt/LWOx
         ymBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T+6H1+9Hc5xNAJNMrtQes/xq+kxehbavBD4hX3343tc=;
        b=iHZh5PCr9fSgc0mYbR8M549lAxOBtQsnmqIA1cxLpebKqTMG46exCEaQTyvI+n63JT
         qmT9ePmLPXJNbLHiLjJf/389gULEnehs4Y2IPha5VtOenEYHiFAS7u3CekAlbK3yreXo
         V6rgs4lPcIV7Nf1FtS1OYjYncry0qOGnYLU5w2ItfpkcGIv3acmA0vU1besWrqy4+e17
         3z92ERujsVTIvIyFEKFg7HvRMhy6Vp2Pz3br7XISlrSrxOYQSgbuJXzT/l9cW/MuHsYn
         3ZYvUg0soCjlimzpdRdNDbGkAx+gFDXcPVoUxzl70p3qK6BEH73IPard6FSFaxeWSGxq
         dBdA==
X-Gm-Message-State: AOAM533rYY4fJL2/4gjBtlKKCfobutqWk5evOJ5OW7+80skKbFn9WH4b
        Q9SLmfkdXzcnToxPwj0SmP2xuN/F
X-Google-Smtp-Source: ABdhPJx4aXokw4cruyLTjv2VAzhwa96dczxbYm7egnoAc3Aj6nRkORGY+72mpY5agCz4kLX8aaJ4pg==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr5917653plt.108.1591292024612;
        Thu, 04 Jun 2020 10:33:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:3d39])
        by smtp.gmail.com with ESMTPSA id a2sm4537851pgh.81.2020.06.04.10.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:33:43 -0700 (PDT)
Date:   Thu, 4 Jun 2020 10:33:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH bpf-next V1] bpf: devmap dynamic map-value area based on
 BTF
Message-ID: <20200604173341.rvfrjmt433knl3uv@ast-mbp.dhcp.thefacebook.com>
References: <159119908343.1649854.17264745504030734400.stgit@firesoul>
 <20200603162257.nxgultkidnb7yb6q@ast-mbp.dhcp.thefacebook.com>
 <20200604174806.29130b81@carbon>
 <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <205b3716-e571-b38f-614f-86819d153c4e@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 10:40:06AM -0600, David Ahern wrote:
> On 6/4/20 9:48 AM, Jesper Dangaard Brouer wrote:
> > I will NOT send a patch that expose this in uapi/bpf.h.  As I explained
> > before, this caused the issues for my userspace application, that
> > automatically picked-up struct bpf_devmap_val, and started to fail
> > (with no code changes), because it needed minus-1 as input.  I fear
> > that this will cause more work for me later, when I have to helpout and
> > support end-users on e.g. xdp-newbies list, as it will not be obvious
> > to end-users why their programs map-insert start to fail.  I have given
> > up, so I will not NACK anyone sending such a patch.

Jesper,

you gave wrong direction to David during development of the patches and
now the devmap uapi is suffering the consequences.

> > 
> > Why is it we need to support file-descriptor zero as a valid
> > file-descriptor for a bpf-prog?
> 
> That was a nice property of using the id instead of fd. And the init to
> -1 is not unique to this; adopters of the bpf_set_link_xdp_fd_opts for
> example have to do the same.

I think it's better to adopt "fd==0 -> invalid" approach.
It won't be unique here. We're already using it in other places in bpf syscall.
I agree with Jesper that requiring -1 init of 2nd field is quite ugly
and inconvenient.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0572C7F44
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 08:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgK3HwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 02:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgK3HwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 02:52:06 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E520C0613CF;
        Sun, 29 Nov 2020 23:51:20 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s63so9586004pgc.8;
        Sun, 29 Nov 2020 23:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PYWhJRiOgotZYYClsfrp07y736emopZzXjnrubbQrF4=;
        b=cvqwUH+f4qKHlYBIV0rI0+3z94MJale62QdBDSMj52HuZ8lcY0G0K/t7/hxIVt/g+H
         atf7QHuWjBy2lq+zjPGJ3EEbRRmEF5xQBVmlMheyf1p/q0/VJ43jgUiopF4t4F8MGWFX
         cIwTXxbUvF9DzHih7CAImA3uoNxzKB6Ov9OM5xt5PWFCdWvPHtQgihudhBb6RHNiX6zc
         TrRF4hPc5QerhVkS58pwqonV2FVKccqDkA1yGd/ONEtmfqdxTU1jU3ROgz7ygMrpl4x6
         wZlfM3NZ5kuvc63ZFWZZkC2Qd22PElrSVFmHxdlggebbxiwjN77uhgHz+dEPUfILYvzi
         sGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PYWhJRiOgotZYYClsfrp07y736emopZzXjnrubbQrF4=;
        b=uJ6+bVbz99K37MKEPc2d6v8/PSP+KFLfakCwZTRN/1w6ClTwUsRLgMTynBjMjt5jHX
         QdS+1I4qK9JoWUFM9sMuklIiZ4pl1aoUPibgFQ1dV/xfnKWC4QAMk9bIZERCUy6i3tsp
         f3VYTXajtu8MNApM8PP8J42x7fkN3UtCtNAKprd3r4JCta0yswcr3IDk1w+8t+u+8ExI
         jrbrimze8Ob0E3bWuSg8RIajerJA+cYJyF0AnHsGu9q8LdQi43S+LNl8vqmD8HIhRu/W
         33wEysEdc7oR6pyeDzeg3AckOJh59KrUPvsmDd4CNudqfwcRrR+si6ojZGcKliC6oR4M
         qtfg==
X-Gm-Message-State: AOAM531GhMXT9riiIVo2iA+PbvYdpqLGwIvrHbvRBwUtu/mxVs8qNFW5
        Y0tkTk4FPK4VEvY13CS23Uw=
X-Google-Smtp-Source: ABdhPJxkgEnVR/TFCgzbgLVLZDbTMnKG/z9CEUEWvC1YGnNAYkM0X3rUNLDwWxaEkUs80tZNeivSQw==
X-Received: by 2002:aa7:9f8b:0:b029:18b:9c0e:a617 with SMTP id z11-20020aa79f8b0000b029018b9c0ea617mr17164673pfr.16.1606722679849;
        Sun, 29 Nov 2020 23:51:19 -0800 (PST)
Received: from localhost.localdomain ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b4sm5098883pju.33.2020.11.29.23.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 23:51:19 -0800 (PST)
Date:   Mon, 30 Nov 2020 15:51:07 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv2 bpf-next] samples/bpf: add xdp program on egress for
 xdp_redirect_map
Message-ID: <20201130075107.GB277949@localhost.localdomain>
References: <20201110124639.1941654-1-liuhangbin@gmail.com>
 <20201126084325.477470-1-liuhangbin@gmail.com>
 <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54642499-57d7-5f03-f51e-c0be72fb89de@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 10:31:56PM -0800, Yonghong Song wrote:
> > index 35e16dee613e..8bdec0865e1d 100644
> > --- a/samples/bpf/xdp_redirect_map_user.c
> > +++ b/samples/bpf/xdp_redirect_map_user.c
> > @@ -21,12 +21,13 @@
> >   static int ifindex_in;
> >   static int ifindex_out;
> > -static bool ifindex_out_xdp_dummy_attached = true;
> > +static bool ifindex_out_xdp_dummy_attached = false;
> > +static bool xdp_prog_attached = false;
> 
> Maybe xdp_devmap_prog_attached? Feel xdp_prog_attached
> is too generic since actually it controls xdp_devmap program
> attachment.

Hi Yonghong,

Thanks for your comments. As Jesper replied, The 2nd xdp_prog on egress
doesn't tell us if the redirect was successful. So the number is meaningless.

I plan to write a example about vlan header modification based on egress
index. I will post the patch later.

Thanks
Hangbin

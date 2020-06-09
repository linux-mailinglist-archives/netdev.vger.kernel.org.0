Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4EF1F46BB
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 21:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730191AbgFITDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 15:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729806AbgFITDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 15:03:16 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2779C05BD1E;
        Tue,  9 Jun 2020 12:03:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u5so10712132pgn.5;
        Tue, 09 Jun 2020 12:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gGyIV6UxNUHV7DjM1a2LqubEJEXLMYkVW9VjppkBHpI=;
        b=UIVuxdEN2zRdJRiCZmsVCLJ20AR0QoWuqHPqlvA5RFEkf/DSXtMInyukg02/TAyjdj
         ixOTYtKq2jlN/6VDbasUZZsGnjjnFChSLpZuHk4qhJh+vm5tFkzQ0ESxrYgte5+525cO
         JF03NhIm0sb6osnYtEV/yyZX9JJQSw7a/uMxhmjZ1rjtd4Kg0kgLrr6OuaROo6nQS6ym
         u9xPBJ5AlGdyJe9s4pf7g9dvrKAzSE6PKTeTSwT0Uz4dytcUciOkI1+W4YNbiwdTeh5s
         BaUn/gG06iFIIWcp5Abidmcc0PARVYa/LGrRYij5w2zTA/kdL/fgaLLuS8pcIqwNu5pQ
         pAZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gGyIV6UxNUHV7DjM1a2LqubEJEXLMYkVW9VjppkBHpI=;
        b=AXQznsyubVT2MpAgOG1WYSvE0yKh71K6/FemgXNJXuAp7HowjyeMjaFIeN0Epaxnni
         bBy7WWB5ZhI7Jhf8s7ejV4TBDjYp5VYeNMi0DnQZA+HUoGLGnZqXlrGFeJdBZS4XSU4w
         +JaBOmwUOoVhtbTkMXRlztRur+LatGta2n4T1PFPIsnrkUoIKAnumAyio0Ag92eQ13kk
         hFL/iYBmZ7LEIpyFb4/O/hm62Wui5M4fqEfID5N1aLZCXVNvQAMP9OFzFLEIqIXAtpiH
         IukVCeiy3rlVS0xOeAlCaAS2lRML9PPSwVlRMBnYQFW7ySt+gqGviR2j3nRvm69FMpYd
         ge8Q==
X-Gm-Message-State: AOAM530eP9cpx0TbE+QETKmCm6SZXJ+kbB81tmPlx44lbF3wp2jSaZi/
        AyiTcGbm+OYvNuvKF7jPyQc=
X-Google-Smtp-Source: ABdhPJxmm43xmoi3b4iNxuTyglXh970KPyLvSJMVBn3QPi9G7NOT50VlUOA70Ek8sFwpEWMAsvKhNQ==
X-Received: by 2002:a63:5961:: with SMTP id j33mr25841067pgm.372.1591729395179;
        Tue, 09 Jun 2020 12:03:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:73f9])
        by smtp.gmail.com with ESMTPSA id w10sm9155982pgm.70.2020.06.09.12.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 12:03:14 -0700 (PDT)
Date:   Tue, 9 Jun 2020 12:03:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf V2 0/2] bpf: adjust uapi for devmap prior to kernel
 release
Message-ID: <20200609190312.cymwvcbxdnrelatx@ast-mbp.dhcp.thefacebook.com>
References: <20200609013410.5ktyuzlqu5xpbp4a@ast-mbp.dhcp.thefacebook.com>
 <159170947966.2102545.14401752480810420709.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159170947966.2102545.14401752480810420709.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 03:31:41PM +0200, Jesper Dangaard Brouer wrote:
> For special type maps (e.g. devmap and cpumap) the map-value data-layout is
> a configuration interface. This is uapi that can only be tail extended.
> Thus, new members (and thus features) can only be added to the end of this
> structure, and the kernel uses the map->value_size from userspace to
> determine feature set 'version'.
> 
> For this kind of uapi to be extensible and backward compatible, is it common
> that new members/fields (that represent a new feature) in the struct are
> initialized as zero, which indicate that the feature isn't used. This makes
> it possible to write userspace applications that are unaware of new kernel
> features, but just include latest uapi headers, zero-init struct and
> populate features it knows about.
> 
> The recent extension of devmap with a bpf_prog.fd requires end-user to
> supply the file-descriptor value minus-1 to communicate that the features
> isn't used. This isn't compatible with the described kABI extension model.

Applied to bpf tree without this cover letter, because I don't want
folks to read above and start using kabi terminology liks this.
I've never seen a definition of kabi. I've heard redhat has something, but
I don't know what it is and really not interested to find out.
Studying amd64 psABI, sparc psABI, gABI was enough of time sink.
When folks use ABI they really mean binary. 
Old binaries that use devmap_val will work as-is with newer kernel.
There is no binary breakage due to devmap_val.
Whereas what you describe above is what will happen if something gets
recompiled. It's an API quirk. And arguable not an UAPI breakage.
UAPI structs have to initialized.
There is a struct and there is initializer for it.
Like if you did 'spinlock_t lock;' and it got broken with new kernel
it's programmers fault. It's not uapi and certainly not abi issue.
DEFINE_SPINLOCK() should have been used.
Same thing with user space.
'struct bpf_devmap_val' would be ok from uapi pov even with -1.
It's just much more convenient to have zero init. Less error prone, etc.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E122F9434
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbhAQRmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 12:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbhAQRma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 12:42:30 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C82C061574;
        Sun, 17 Jan 2021 09:41:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id a12so14261943wrv.8;
        Sun, 17 Jan 2021 09:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UYMoZ6+5O7rsbn3y945Q7rMiBcctyRNGeFXSZdUPqcs=;
        b=I/sSYI4F2Pmb20bZxcC0CRjEleos3oPRgm5dd4K3TN6oMKBU38V56PtucYIAjAMEvh
         MWf7hxuAZDpykvfcWoi42GS5U7gahLfJpzsgwDC9NCpGLrIXXrrITmEgwarO15eaB5UF
         GwPpE0ZVb3oZqWCR25+Ucg9hASuzM/QhasSj3uKp8JoHDSsuGnM4tKjVcV9vjCv7CjVm
         l/n418KhmZqHrYgKVLbdqbTm3FZln3Fq85dJ37bDdLi+0cChV0IMpFAW1t72Jc63TtIi
         qc9adFyCCIfr8ArPc+HXBxvIjDNdlUEF4TwklrHJ2Xo0E17MykoTzkrjRKWplSslUdnG
         pfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UYMoZ6+5O7rsbn3y945Q7rMiBcctyRNGeFXSZdUPqcs=;
        b=ZPW4eD1fgM2By7rwBWojnM2KDrwJ3xVSiT4rxOJBET2k+k2C3oEO+tNDD7bUsRHc8Y
         tHAcY2ZMOzBHeKaIb1eOG5brTbcCSYfukkcsND6IJDXQEJtDIETNz4LAPvoe4JDtMxP4
         so3i/Ax4Rg7qBI+svQaSiiN3eptkH2YNoeDa5HMdXiIkMrSCrufGoxYckRgTfp6oadpJ
         otA+uPo3OD7myGh6N/pkRdpwpfkHhULw0AYkyW6Jl5iw9r6PsAdVjsmzvcWsGrULjwsS
         EGfRY6KnyGviH3Q8C94joVkBJM2rF7hO73PmL8gnHcXQt8MdI9PhXZnq5tZ5/EeS8ZbS
         N63A==
X-Gm-Message-State: AOAM531ssdgJLFGEjqwYtxo+KQm+HO+5cxhwzUrqdVrjSFrhkuokxqwb
        k4CO00TbkRdLgPHm2pyUK4Q=
X-Google-Smtp-Source: ABdhPJwJVBfBsA66kQSBW/v1x/uB2Z0GRdEKBsxRxMM4Ho283uN3vxoR9hvi4njIPb01u9ma4n8BKw==
X-Received: by 2002:adf:80d0:: with SMTP id 74mr22798592wrl.110.1610905308558;
        Sun, 17 Jan 2021 09:41:48 -0800 (PST)
Received: from anparri (host-79-50-177-118.retail.telecomitalia.it. [79.50.177.118])
        by smtp.gmail.com with ESMTPSA id f7sm9524423wmg.43.2021.01.17.09.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 09:41:47 -0800 (PST)
Date:   Sun, 17 Jan 2021 18:41:39 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] hv_netvsc: Add (more) validation for untrusted
 Hyper-V values
Message-ID: <20210117174139.GA1703@anparri>
References: <20210114202628.119541-1-parri.andrea@gmail.com>
 <20210115203022.7005e66a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210116130201.GA1579@anparri>
 <20210117151032.sbhjryq2hs3ctnlx@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210117151032.sbhjryq2hs3ctnlx@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 03:10:32PM +0000, Wei Liu wrote:
> On Sat, Jan 16, 2021 at 02:02:01PM +0100, Andrea Parri wrote:
> > On Fri, Jan 15, 2021 at 08:30:22PM -0800, Jakub Kicinski wrote:
> > > On Thu, 14 Jan 2021 21:26:28 +0100 Andrea Parri (Microsoft) wrote:
> > > > For additional robustness in the face of Hyper-V errors or malicious
> > > > behavior, validate all values that originate from packets that Hyper-V
> > > > has sent to the guest.  Ensure that invalid values cannot cause indexing
> > > > off the end of an array, or subvert an existing validation via integer
> > > > overflow.  Ensure that outgoing packets do not have any leftover guest
> > > > memory that has not been zeroed out.
> > > > 
> > > > Reported-by: Juan Vazquez <juvazq@microsoft.com>
> > > > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: Andrii Nakryiko <andrii@kernel.org>
> > > > Cc: Martin KaFai Lau <kafai@fb.com>
> > > > Cc: Song Liu <songliubraving@fb.com>
> > > > Cc: Yonghong Song <yhs@fb.com>
> > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > Cc: KP Singh <kpsingh@kernel.org>
> > > > Cc: netdev@vger.kernel.org
> > > > Cc: bpf@vger.kernel.org
> > > > ---
> > > > Applies to 5.11-rc3 (and hyperv-next).
> > > 
> > > So this is for hyperv-next or should we take it via netdev trees?
> > 
> > No preference, either way is good for me.
> 
> To be clear: There is no dependency on any patch in hyperv-next, right?
> 
> That's my understanding, but I would like to confirm it.

Well, I wrote that this *applies* to hyperv-next... but that's indeed
the only 'dependency' I can think of.

Hope this helps.

Thanks,
  Andrea

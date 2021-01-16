Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0C62F8DF7
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbhAPRMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbhAPRKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:10:49 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E315C061793;
        Sat, 16 Jan 2021 05:02:11 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m187so3394583wme.2;
        Sat, 16 Jan 2021 05:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C2JP0xKJYBxZO1WeICFkIE+mCTKdXxqepJkA8Lj212o=;
        b=kbKTROjfQFJUwD/4rNC/DAhfG1lMJGO5jFmHYF44t0ZsxDShBzvRPF6+eK9HI5F5Y8
         rvB/FRPmenRFNERN/1LHtR77IYiCJiY/6SAEe0afUddyb9+XBsF2yUn11yTrf1JBox0O
         pTp/AYOmgtDQLnRJt4GEV38fgAsvsJdk7Us6pb7D1Li4ebLXNTAfR4BaOe2c5IDhf3kV
         kYUhrJKhwSGdpMCItKlQ0lD7NMMHzWCNe8BxVPUTsx/Q8QN6BbC633Ze5j/s9+X5T4Er
         CTGJ3070ZCn584HSF9vJLCW5HMryOwBawLAHhdUfdHRntnmqcDuDkUYfYXmZz1tOj4gy
         GD1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C2JP0xKJYBxZO1WeICFkIE+mCTKdXxqepJkA8Lj212o=;
        b=CGd3mR3Q0RzQ/C9JaJ4K7//rHtPqBYwYvKJwsHR4OJkjNXXJUZS63fcwNOjDdMsMB6
         zoy71Yst10/48lX2swJWWZYXl9UdT4SI7QKhOFllk8ivf2Uhu1r2FOvRJHB1swGrJ5wC
         +FKuHP4Dsyl/yV6vGzw2a83l/RTFwqh1BJI9QlXu204aghYx1byJduwDWOp+jKH1KOh3
         55GHDtSsf2yNRYbM97VK8yYXnur266n2Fg4sVyTgNezDBoeMvHiubWew/5Daj7yHI9ns
         NpqTbX8Y4+A4gMaDACqIU3r9b3M/mAVjgulLkR4hPv+8zbr29EZ28ELoicQ3qQBBWS2r
         TE+Q==
X-Gm-Message-State: AOAM533n7XpKp+0FZ7K4iKMQ9oro1np4DBsc4LUhjsSwtBA7cNVDnAE6
        J6b724vdjZkUouvIEwFJv8Q=
X-Google-Smtp-Source: ABdhPJwv27p7CsJkNcxsvOJ3l0roT0VTEtXuYGbqGvyeDNgjF31dRyGVWpgWs7zy4PbLuisd4XHa+Q==
X-Received: by 2002:a7b:c4c7:: with SMTP id g7mr13406870wmk.29.1610802129834;
        Sat, 16 Jan 2021 05:02:09 -0800 (PST)
Received: from anparri (host-79-50-177-118.retail.telecomitalia.it. [79.50.177.118])
        by smtp.gmail.com with ESMTPSA id x18sm21306944wrg.55.2021.01.16.05.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 05:02:09 -0800 (PST)
Date:   Sat, 16 Jan 2021 14:02:01 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
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
Message-ID: <20210116130201.GA1579@anparri>
References: <20210114202628.119541-1-parri.andrea@gmail.com>
 <20210115203022.7005e66a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115203022.7005e66a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 08:30:22PM -0800, Jakub Kicinski wrote:
> On Thu, 14 Jan 2021 21:26:28 +0100 Andrea Parri (Microsoft) wrote:
> > For additional robustness in the face of Hyper-V errors or malicious
> > behavior, validate all values that originate from packets that Hyper-V
> > has sent to the guest.  Ensure that invalid values cannot cause indexing
> > off the end of an array, or subvert an existing validation via integer
> > overflow.  Ensure that outgoing packets do not have any leftover guest
> > memory that has not been zeroed out.
> > 
> > Reported-by: Juan Vazquez <juvazq@microsoft.com>
> > Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Andrii Nakryiko <andrii@kernel.org>
> > Cc: Martin KaFai Lau <kafai@fb.com>
> > Cc: Song Liu <songliubraving@fb.com>
> > Cc: Yonghong Song <yhs@fb.com>
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: KP Singh <kpsingh@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Cc: bpf@vger.kernel.org
> > ---
> > Applies to 5.11-rc3 (and hyperv-next).
> 
> So this is for hyperv-next or should we take it via netdev trees?

No preference, either way is good for me.

Thanks,
  Andrea

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878E0A9808
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfIEBcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 21:32:51 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45529 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfIEBcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 21:32:51 -0400
Received: by mail-pg1-f194.google.com with SMTP id 4so410163pgm.12;
        Wed, 04 Sep 2019 18:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XgsZEUINJb/sdtMHaBsrZPBuUAzc7NcFduJRU8eaG0k=;
        b=vHfszr3sMklPGEJ5FI0NIf4sn7Dp0DN7d0Hu1xq8NpgPu0/181XkOcS2X4n+HzZwzd
         Yh5iyXjIdJ0iGWYxkkwbhJVenqTimhmcPHMArwkVv5uzhZVG+FlndBPgmekbml4o5JCJ
         M3w+ECdggD+pmX5hyPvGKN3va/vJMKfwxdjLyT4T4sn2oxizZMj68NTQpADHN3Nox7nb
         JbKc4RkC9KccwyW82b12HKgJQlbx9nu3V3wwO5FeD90QtSSYfbzviA5lsZKZAq8rn/BH
         nTYtsVmUCZjTJbwH9etvG4Kd1ta2Ou3ffnqEncca8h2gr041XBw3SfJudzY0GauzUS4m
         NAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XgsZEUINJb/sdtMHaBsrZPBuUAzc7NcFduJRU8eaG0k=;
        b=q4/nMtqXA3Ab0UC0xjtTgLmY1IvLtpPOTiMb5HFz57qw29E3h/UdnBSQRv+CuuzGH+
         GRFm7MuLGanpd+TqLtv1xIfrseZSQa2CFgs/Iq3AszzbSGSzIAreud+yqyROvqj4LyL3
         lZjI9j+YNt+9fjuSOI7mYH+2nBjgJpnkcr/SRF7lzJLbwJeksQ2EHi9Zsla1jyDR6VnY
         2QX8RWXfpGhAm49OdncxAyPxNMiGo12kkFo2tafilCIluJ5/cP3E88Ig0VLZiOGteXqx
         RqXb6t2wFCMS9YGS3oE3LOYAr96SlUz0N5cagqVPqSg9Kc+ehDx5cNnShAlfioU4D8hS
         p7RQ==
X-Gm-Message-State: APjAAAXYi5/C0GaKiNQvoxjsdaY6jECgNyCp7gdSEkmORGRlyAnwjkrM
        JVVCMguLFMjj12XRKSQ/bTc=
X-Google-Smtp-Source: APXvYqwp63vYPD4NvQMzBvsn2IShTR+k3VoCpSTsiFe02Ci8Syu91/k4uYAVeGqZIcuazY2jKPtc4g==
X-Received: by 2002:a17:90a:fa96:: with SMTP id cu22mr44116pjb.137.1567647170161;
        Wed, 04 Sep 2019 18:32:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::62a])
        by smtp.gmail.com with ESMTPSA id z6sm331848pgk.18.2019.09.04.18.32.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 18:32:49 -0700 (PDT)
Date:   Wed, 4 Sep 2019 18:32:46 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <20190905013245.wguhhcxvxt5rnc6h@ast-mbp.dhcp.thefacebook.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
 <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 05, 2019 at 12:34:36AM +0000, Song Liu wrote:
> 
> 
> > On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
> > 
> > Implement permissions as stated in uapi/linux/capability.h
> > 
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > 
> 
> [...]
> 
> > @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
> > 	is_gpl = license_is_gpl_compatible(license);
> > 
> > 	if (attr->insn_cnt == 0 ||
> > -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> > +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_MAXINSNS))
> > 		return -E2BIG;
> > 	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
> > 	    type != BPF_PROG_TYPE_CGROUP_SKB &&
> > -	    !capable(CAP_SYS_ADMIN))
> > +	    !capable_bpf())
> > 		return -EPERM;
> 
> Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SKB
> without CAP_BPF? If so, maybe highlight in the header?

of course. there is no change in behavior.
'highlight in the header'?
you mean in commit log?
I think it's a bit weird to describe things in commit that patch
is _not_ changing vs things that patch does actually change.
This type of comment would be great in a doc though.
The doc will be coming separately in the follow up assuming
the whole thing lands. I'll remember to note that bit.


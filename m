Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0811F9C6
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 18:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfLORkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 12:40:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32860 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLORkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 12:40:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id y206so4333422pfb.0;
        Sun, 15 Dec 2019 09:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F9UYCtCrGdOk+xKB0MDeZ535mR/2KxCX0dcd2IMnugg=;
        b=bktz8uT2MCj1SNs3nMc52zA0oP9wqAp2+hvWNHDDXQPf7H/DxpPC92ZB37X8JajhuF
         sXlesVYDoPnLiolgj8enLsJn3xb81A5PgWtMIon6O2dDtz1/JHPJgrfmE0jGqYW6zFtJ
         DzEBNfs6gLrpydMSF+5LVgTMpFc8+gwdIqSWbEDOuzi731yB5tXbeUyep2Ydi2Mh0V+M
         Q24AoZzDkRZFxZnTc/cX1ac6SAKhgb6U3UobloY4Z9izVSZqEjPttwBaVRdDwdLsTmkM
         CUAxEfjPYQLUtHjKsWbhCq5kcWkYJ/VPIV7S8IKhNQrrmuZBvpu8SqVnDhrw8ST3jPyl
         AQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F9UYCtCrGdOk+xKB0MDeZ535mR/2KxCX0dcd2IMnugg=;
        b=sgBBBz/nD14qjIIfKsNw549jAjTEmJ65AIw57b8dwZw0Ovy/plfpbzoYM0DXRVqSF/
         wklM1AL62SZKfpjRroYmrojl7041Qqf51Ok6u3DxKw5ZESYP2KYLdCPBBfcl5xavYGq9
         We/BEptPSpe8Gbsjj60Ur2U2dM6GQ5vE8OSdZE+dHldmfEuzsLeCsz60vA9/4AyK16cU
         Jp9FNt5eDFznlT9+mWNSxLelV1F0cLEqNMMh8JgIpulur2XrUH2+I4J7v44EAjz0A3HT
         54Y19ZNyfOxHLTeJ+38hocneS6exsK8SxvOzKRl1cGHt3eSU0RK86rr3nwu0XiyPew4O
         8gsg==
X-Gm-Message-State: APjAAAWyp6Td24o8KvOCAutGpt8u1xyC7vDex8v/kXyfaeIPi1WWvPQZ
        M7rrXiKvm89P+SQHXSX77GY=
X-Google-Smtp-Source: APXvYqzuEhZv9nhnqY4R/y4n0/p/hB+TDzNYzPM9e/llDvpNLtMyey4/BZbu9PbGxgH6FIQDs6T7ZA==
X-Received: by 2002:aa7:8007:: with SMTP id j7mr11869543pfi.73.1576431608446;
        Sun, 15 Dec 2019 09:40:08 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::2157])
        by smtp.gmail.com with ESMTPSA id h16sm19301094pfn.85.2019.12.15.09.40.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Dec 2019 09:40:07 -0800 (PST)
Date:   Sun, 15 Dec 2019 09:40:05 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     bpf@vger.kernel.org, Quentin Monnet <quentin.monnet@netronome.com>,
        paul.chaignon@gmail.com, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 0/3] bpftool: match programs and maps by names
Message-ID: <20191215174004.57deg3fs7665jokd@ast-mbp.dhcp.thefacebook.com>
References: <cover.1576263640.git.paul.chaignon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1576263640.git.paul.chaignon@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 08:09:52PM +0100, Paul Chaignon wrote:
> When working with frequently modified BPF programs, both the ID and the
> tag may change.  bpftool currently doesn't provide a "stable" way to match
> such programs.  This patchset allows bpftool to match programs and maps by
> name.
> 
> When given a tag that matches several programs, bpftool currently only
> considers the first match.  The first patch changes that behavior to
> either process all matching programs (for the show and dump commands) or
> error out.  The second patch implements program lookup by name, with the
> same behavior as for tags in case of ambiguity.  The last patch implements
> map lookup by name.
> 
> Changelogs:
>   Changes in v2:
>     - Fix buffer overflow after realloc.
>     - Add example output to commit message.
>     - Properly close JSON arrays on errors.
>     - Fix style errors (line breaks, for loops, exit labels, type for
>       tagname).
>     - Move do_show code for argc == 2 to do_show_subset functions.
>     - Rebase.

Loogs good. Applied.

I found the exact match logic unintuitive though.
Since 'prog show' can print multiple may be allow partial match on name?
So 'bpftool p s name tracepoint__' would print all BCC-based programs
that attach to tracepoints.
It would be roughly equivalent to 'bpftool p s |grep tracepoint__',
but grep captures single line.
There is 'bpftool perf|grep tracepoint' as well, but since the tool
matches on name it probably should match partial name too.


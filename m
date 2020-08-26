Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75501253894
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 21:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgHZTwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 15:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgHZTwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 15:52:54 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0A3C061574;
        Wed, 26 Aug 2020 12:52:54 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 67so1619774pgd.12;
        Wed, 26 Aug 2020 12:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=94/SNbSIYD+Xo9JGqNVO2RH4yAJNdDu/Srjv1flV1xU=;
        b=B9oo0fYO83YraeDiISzi9wTvMOYANVtCssR31gsYfbP26/yLDn62YivLWh28/HRLuW
         5E3flOJzN9eMe0WK11fWSUldNF/kjJWzEexyBSQpp1894bKqzkJJskj14VIxYVK9qXL9
         P6730iOT4DKPNAbcDlNxN9BWambABkuUnFs/8Sf+v60d6o2+G5/yFZvd/tvE4Ui+r3Wb
         XnYazDzrSHPsbHTIgiFfAofWF0M/qqH1eHN6ZfMhl1JD1NacfmnQNrYyP5LatergKUnF
         /PFzdw3koueaaOVUGFClaZrew8vDS3NBRo5OhH1q8zxDtPm5n/Zlp5xkeI7cAskhQ6Wk
         gTfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=94/SNbSIYD+Xo9JGqNVO2RH4yAJNdDu/Srjv1flV1xU=;
        b=d/t53aXHiH54vIMCYmG0ZeNyuPHsBYGsFVr8yNEN4YmXtZZ2fvEqcNjum3xnWIEzP8
         MILzApx5QBxzDPhns8CzeJyrAlLiieX1gSbJaVmReyrenm1Qw1bGxy7tvSXZrSfAhMB9
         EBPUODg61CpbzVRatQylopD1ZQq0iAvP/1INgQi8ADarsLqA8TjmFksZLW508ElwlRtk
         SmR8qWdMZK7tuJ5TwaVZO8VHyjgvcU/8dJ9zTv7PeMPgKLHR3MC3Kwsuel28QksJLGlP
         eyTGgaSJGQMxyKifkHnhb0Oeo8bg5ksxHoYiUhgpFwkQIhjyVH2GzduWD6HHkMopwgxy
         BSvQ==
X-Gm-Message-State: AOAM532jFjz62QUuBVdhbykj953jFSGu+jQLJPt5HFQFjSa8V2w5qQzw
        3VjRVUOyQyWtpZBa8fLr3KQ=
X-Google-Smtp-Source: ABdhPJzSnqwgeAkAqN2xJDE0qEBkdhNetW25TS9HYgmaf31pTd7MgP/c7bHA7cLtQF0Bg3Ng4vnQqw==
X-Received: by 2002:a65:670d:: with SMTP id u13mr11775755pgf.280.1598471573542;
        Wed, 26 Aug 2020 12:52:53 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e18])
        by smtp.gmail.com with ESMTPSA id x12sm3738117pff.48.2020.08.26.12.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 12:52:52 -0700 (PDT)
Date:   Wed, 26 Aug 2020 12:52:50 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Udip Pant <udippant@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 0/4] bpf: verifier: use target program's type
 for access verifications
Message-ID: <20200826195250.jnbl3oca5lqrdgbs@ast-mbp.dhcp.thefacebook.com>
References: <20200825232003.2877030-1-udippant@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25, 2020 at 04:19:59PM -0700, Udip Pant wrote:
> This patch series adds changes in verifier to make decisions such as granting
> of read / write access or enforcement of return code status based on
> the program type of the target program while using dynamic program
> extension (of type BPF_PROG_TYPE_EXT).
> 
> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
> placeholder for those, we need this extended check for those extended
> programs to actually work with proper access, while using this option.
> 
> Patch #1 includes changes in the verifier.
> Patch #2 adds selftests to verify write access on a packet for a valid 
> extension program type
> Patch #3 adds selftests to verify proper check for the return code
> Patch #4 adds selftests to ensure access permissions and restrictions 
> for some map types such sockmap.
> 
> Changelogs:
>   v2 -> v3:
>     * more comprehensive resolution of the program type in the verifier
>       based on the target program (and not just for the packet access)
>     * selftests for checking return code and map access
>     * Also moved this patch to 'bpf-next' from 'bpf' tree

Applied. Thanks

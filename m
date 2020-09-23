Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0432C2763AB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIWWOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgIWWOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:14:19 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361F1C0613CE;
        Wed, 23 Sep 2020 15:14:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u3so446196pjr.3;
        Wed, 23 Sep 2020 15:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HEXud4JUPdyEUugGacLf7MYdEUVh0fPvWAD7Yih0pkE=;
        b=Je8CYvSSLVyy/wxR/Wh4AE0xQxsOsiYzJsNQPSjuZZgOQ7Y1UoMH7RlPp+dUYDFCGB
         Res/zeWT9Dlbo7oF+qyjpm1Uk5tR4Vz3RNL3MJtF9sArO75JFIlxwlQSAJZuz98/URv6
         ykMvjE+MTJK70kKCNum1q+/7xyGUEy0c4mY/n7FWXptgFhnyWy07qHYAL5+oa2vMrHKf
         oszvxJjdUgnAPK+0eyx4KQForbsJPEUlFRd5/uAMdvSpJQH/Uo3P9uRarEbKbc1lE6dd
         giiFrH2TX/NcIhLMEQIQilYV22tuEbJeKIqXBOlirMq5uN0LMwPfPtxNhNhFUJpca9zz
         Mamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HEXud4JUPdyEUugGacLf7MYdEUVh0fPvWAD7Yih0pkE=;
        b=f8E+SvDPHZrBtZS2lr2GYqwKzfkyvHZhXS9SbAwptTfEgLToFwPeqwlBiz2qfmRPCB
         C0Rm17hc92q3gNthU4S7vVU8Z7s3jm9t9gegVwoo2lzj0Zs72hjS4LzWPyAKBHlpe/CK
         g8UmRQvq3b0MnjD3lUqRv2ILBxp3hFdIlR2o+64ngYS0qxfix07KQ9g8dyITthqisFaT
         PXJWG6Rf1t5eZRckpRWtX9TvAPDwlt3p4aQB+uv81XMrdIs9BJxfu/p5SZVHsAZRSFAe
         Z3wLevYbHrGANhDrxnTZN4EYkX5J6g7gy0nVeSOWkGJbZXpEpOxJ0/ztOWkKVqfLpefb
         yA5Q==
X-Gm-Message-State: AOAM530e/2/Xc406pcI3SnSB4//BG+7BoV0f9qs/OhFYm4WRTzm4CBIC
        e7iCtwjl1VZJPnHsni6BMu8=
X-Google-Smtp-Source: ABdhPJzu2VRvFLyd0kKkCVC5LB1/9GK2BfQ8KH/8TZRJAtUkYKXaqPA8e0rQQSDZNbD4XLT1W7GSFQ==
X-Received: by 2002:a17:902:7889:b029:d2:26da:7c13 with SMTP id q9-20020a1709027889b02900d226da7c13mr1684798pll.38.1600899258688;
        Wed, 23 Sep 2020 15:14:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id c24sm595526pfd.24.2020.09.23.15.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 15:14:17 -0700 (PDT)
Date:   Wed, 23 Sep 2020 15:14:15 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: Keep bpf-next always open
Message-ID: <20200923221415.jxy6hcpqusodpqsr@ast-mbp.dhcp.thefacebook.com>
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
 <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 02:48:24PM -0700, Andrii Nakryiko wrote:
> On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > BPF developers,
> >
> > The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the past we
> > observed a rush of patches to get in before bpf-next closes for the duration of
> > the merge window. Then there is a flood of patches right after bpf-next
> > reopens. Both periods create unnecessary tension for developers and maintainers.
> > In order to mitigate these issues we're planning to keep bpf-next open
> > during upcoming merge window and if this experiment works out we will keep
> > doing it in the future. The problem that bpf-next cannot be fully open, since
> > during the merge window lots of trees get pulled by Linus with inevitable bugs
> > and conflicts. The merge window is the time to fix bugs that got exposed
> > because of merges and because more people test torvalds/linux.git than
> > bpf/bpf-next.git.
> >
> > Hence starting roughly one week before the merge window few risky patches will
> > be applied to the 'next' branch in the bpf-next tree instead of
> 
> Riskiness would be up to maintainers to determine or should we mark
> patches with a different tag (bpf-next-next?) explicitly?

"Risky" in a sense of needing a revert. The bpf tree and two plus -rc1 to -rc7
weeks should be enough to address any issues except the most fundamental ones.
Something like the recent bpf_tail_call support in subprograms I would consider
for the "next" branch if it was posted a day before the merge window.
In practice, I suspect, such cases will be rare.

I think bpf-next-next tag should not be used. All features are for [bpf-next].
Fixes are for [bpf]. The bpf-next/next is a temporary parking place for patches
while the merge window is ongoing.

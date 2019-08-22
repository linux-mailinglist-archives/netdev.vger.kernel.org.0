Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DADC199EE5
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389074AbfHVScn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:32:43 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38926 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731266AbfHVScm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:32:42 -0400
Received: by mail-lf1-f68.google.com with SMTP id x3so5256404lfn.6
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 11:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+lqoIzvuT58jZN9t04fZzkyURKWnlXog/G4cwQjz5Xs=;
        b=WUUgj4ckOqvT6Teb7PyF10rEWZMTWg21EuYG9cpteP6YmJHodZEXkWjrYgnGyiaWPI
         hQR5iAcXK99Ky08dvrx2y+E8WXZlVw+BePwGQW8BjkpbT5Yz2b8THAfLvHCBBZeNBCP3
         rfcFecwR0JDZptp3my7M9fBN6HZCxBef8vrT2BMnZvhu6eg/PHXGs0QYeg3ciXaki1N2
         jFBHBibffGjjxj585AeCkGWdQG4L62AHxjJYt4xWENku99Qi99W5/CbmS5TM01P2L3N/
         xCdigmIgjHyPK+3I9TgbTdxGh6m4+8Tb1HNCrUL8W8sSoIIms+WOb3bsvuoRZv8rXesI
         ZTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+lqoIzvuT58jZN9t04fZzkyURKWnlXog/G4cwQjz5Xs=;
        b=o1yq+FEPuc6kTry483HJB/PzO39k7gTtlB0uRuLvXHElM64p1kf1q27fTkqqNmoaV1
         iWyBu2b3lp7NjYmv+1JG/BtmgsfuDkf+DPtSvLriVawt6A8+PGfLMjZdUQmICfVLfqOm
         Ibvz5ZLNB/24v29wLq7i8OtZu3uUhGJvTd3EYVgRFwVNCnL1eW3N2nk6Tbyybw1PgWxO
         2e9YEXtDkIF6Hd+gFE6tUIYTODsyCDceiwJcKhq4l2ieiI2gm3/OrLpgaVhJwjcCRKq3
         rTgoIl7i5MScmveLLgVDF96ZB7xbNGXXEitKohNDPPSBWqpvcsG2F+S4J7UNfjTo5lxZ
         2EZg==
X-Gm-Message-State: APjAAAURmcszr0QDrSg1/0AhaQev0bxTdluLHJFCp5+luLQajqf7Cwpx
        jvJgGM7JYfnkb5rOhsThGhNBsBhiUfCDH+2UYf4=
X-Google-Smtp-Source: APXvYqxh83z2ON7etwNIaTa7EDpiQtaQueaKV4neEC7ZBORz78jHSNHoVH7uM7Qn3igElP5khesAyX58el3EWeshE3s=
X-Received: by 2002:a19:c80b:: with SMTP id y11mr279445lff.81.1566498760656;
 Thu, 22 Aug 2019 11:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <1566432854-35880-1-git-send-email-yihung.wei@gmail.com> <201908230208.0aRY5GdN%lkp@intel.com>
In-Reply-To: <201908230208.0aRY5GdN%lkp@intel.com>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Thu, 22 Aug 2019 11:32:29 -0700
Message-ID: <CAG1aQhJUW8uB7w6bqwrobpnNKr--n2e5eOpNzQtQyPs1DZ=p=g@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: Fix conntrack cache with timeout
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 11:12 AM kbuild test robot <lkp@intel.com> wrote:
>
> Hi Yi-Hung,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net/master]
>
> url:    https://github.com/0day-ci/linux/commits/Yi-Hung-Wei/openvswitch-Fix-conntrack-cache-with-timeout/20190822-212539
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.1-rc1-7-g2b96cd8-dirty
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
>
> sparse warnings: (new ones prefixed by >>)
>
>    include/linux/sched.h:609:43: sparse: sparse: bad integer constant expression
>    include/linux/sched.h:609:73: sparse: sparse: invalid named zero-width bitfield `value'
>    include/linux/sched.h:610:43: sparse: sparse: bad integer constant expression
>    include/linux/sched.h:610:67: sparse: sparse: invalid named zero-width bitfield `bucket_id'
> >> net/openvswitch/conntrack.c:706:41: sparse: sparse: incompatible types in comparison expression (different address spaces):
> >> net/openvswitch/conntrack.c:706:41: sparse:    struct nf_ct_timeout *
> >> net/openvswitch/conntrack.c:706:41: sparse:    struct nf_ct_timeout [noderef] <asn:4> *

My v1 does not take care of the rcu pointer properly.  I will fix the
reported issue and send v2.

Thanks,

-Yi-Hung

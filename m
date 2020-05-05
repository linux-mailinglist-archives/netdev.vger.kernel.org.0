Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B04AE1C5CF6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgEEQGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbgEEQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:06:43 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDFDC061A0F;
        Tue,  5 May 2020 09:06:43 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id c10so2843267qka.4;
        Tue, 05 May 2020 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bv8d5auwv8WPKBW85dEhvwg9llp+d9U+MUHdBWxQ/AA=;
        b=YXZUrR/FBzuSZDfpKyddp1h4Q3IEai/+synGatezI1urLNAo/GqDaNbGAM9LoDkeJA
         gzaObuXQxJdC3rrvG/FR/5EeiUTZlK6odsPf1p2j4udJUVYqoD/ixxWPQ3wlnh6Ugoj0
         vYy2wGt9ujB5Jsvwcbjm+GoiqKD2A2/exauGq8LvJ2S4UBZhS+fXlOwif5kPyc9klZmB
         9pp6rHNVpVcYYqLKhsd8OLFqIo0pi5jKkzudk8kKoFvPirFDS9eZPbtzFjaqUlvibmD1
         zA1nh/SEvZlB/pAWTKki+2g6j2zyhskCgHDaHXMFDI2s+KdFCtrcgdJ2wtHFQf42tAqX
         W3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=bv8d5auwv8WPKBW85dEhvwg9llp+d9U+MUHdBWxQ/AA=;
        b=EA0Fb44EaAqRz1NnMYOLAHJzhMFSRw2FtCfgtH7FH70IkeW7Yc2yqNvlUZewtvLefb
         2AR2dGMVVgJoevVzidxd8oB5/VA6q50/xEXiZKZzidt8gFK5gG5gx4P3dLnf3iDQ4hqC
         7ZXTiZWiBWF57xlF5xpVlAF/Uo1kdnbBousP6fwhH9jUMNA02uvdfBT09SweWWLsPrLf
         6FMWwsAT5k9Esstmj4riG5RhZeluWqZzH5fBJj47mJxpjLWigU60Z/44INWjiwFus4WL
         TyqxlgzBnEGNad576yFBc9Z9/+DXZUrWXVQDXI67jhVd1nHmetnlbjuoGoDDLs4mFnQl
         uyGQ==
X-Gm-Message-State: AGi0PuafDBCMejXuKKZEXwypOHQyoUzE4omgAAu1b/diCvHAoki7lDHc
        m2Cjht7ViVO2cQz1au7gQBsRVxNvdzU=
X-Google-Smtp-Source: APiQypL5/C35QYYNodlbdp+B4QZRwv17VqFw+9s44HXXYSewnnFddcstPi/LKf8jnUN7YSzyi3YHSA==
X-Received: by 2002:a05:620a:16aa:: with SMTP id s10mr4277450qkj.216.1588694802205;
        Tue, 05 May 2020 09:06:42 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:5ece])
        by smtp.gmail.com with ESMTPSA id w69sm2087380qka.75.2020.05.05.09.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 09:06:41 -0700 (PDT)
Date:   Tue, 5 May 2020 12:06:39 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "Libin (Huawei)" <huawei.libin@huawei.com>,
        guofan5@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: cgroup pointed by sock is leaked on mode switch
Message-ID: <20200505160639.GG12217@mtj.thefacebook.com>
References: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03dab6ab-0ffe-3cae-193f-a7f84e9b14c5@huawei.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, Yang.

On Sat, May 02, 2020 at 06:27:21PM +0800, Yang Yingliang wrote:
> I find the number nr_dying_descendants is increasing:
> linux-dVpNUK:~ # find /sys/fs/cgroup/ -name cgroup.stat -exec grep
> '^nr_dying_descendants [^0]'  {} +
> /sys/fs/cgroup/unified/cgroup.stat:nr_dying_descendants 80
> /sys/fs/cgroup/unified/system.slice/cgroup.stat:nr_dying_descendants 1
> /sys/fs/cgroup/unified/system.slice/system-hostos.slice/cgroup.stat:nr_dying_descendants
> 1
> /sys/fs/cgroup/unified/lxc/cgroup.stat:nr_dying_descendants 79
> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/cgroup.stat:nr_dying_descendants
> 78
> /sys/fs/cgroup/unified/lxc/5f1fdb8c54fa40c3e599613dab6e4815058b76ebada8a27bc1fe80c0d4801764/system.slice/cgroup.stat:nr_dying_descendants
> 78

Those numbers are nowhere close to causing oom issues. There are some
aspects of page and other cache draining which is being improved but unless
you're seeing numbers multiple orders of magnitude higher, this isn't the
source of your problem.

> The situation is as same as the commit bd1060a1d671 ("sock, cgroup: add
> sock->sk_cgroup") describes.
> "On mode switch, cgroup references which are already being pointed to by
> socks may be leaked."

I'm doubtful that you're hitting that issue. Mode switching means memcg
being switched between cgroup1 and cgroup2 hierarchies, which is unlikely to
be what's happening when you're launching docker containers.

The first step would be identifying where memory is going and finding out
whether memcg is actually being switched between cgroup1 and 2 - look at the
hierarchy number in /proc/cgroups, if that's switching between 0 and
someting not zero, it is switching.

Thanks.

-- 
tejun

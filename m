Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2900731921
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfFACsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:48:08 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36820 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFACsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:48:07 -0400
Received: by mail-pf1-f193.google.com with SMTP id u22so7288699pfm.3;
        Fri, 31 May 2019 19:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wA6Nag5cogefANISMYEj8MTYfV7u56NtZXfu3ry/z74=;
        b=iLLsRGv5rZG2Z2S1xBjyxzN2EiMpCOjxyobS4Kjt63lDR9BvrmiQKI8Z6KRR1cKDAS
         T/elngl98c1HflHiYL2VK+WBLcwfvzg3p2brNe/PijlOZilflzHDABXBHGd3doMV5qm5
         7k+vRi4HZ8LE01xkHSNMH4fc8G+apBDcKiyxn5SF54Lo3lyTKWJzgpSqBO2kxe7RgwF1
         LjcaIwvwZKU8WXWL0YsG1/7Ly737J9odKGWEKYSZluOtXoF1wWphx82qZJn6zBbWvyhQ
         Wr1m1M6RA4iwQ17iruIeE1lAZU6drlS4AQyoKU4WCiTQmQzW2y4EFVKA69mIcKloJlJb
         mnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wA6Nag5cogefANISMYEj8MTYfV7u56NtZXfu3ry/z74=;
        b=pBTjkbHACsjchefUqPirUQA+q5C6+9qWTFnLDWAJpWWuCPqHdjHET44Plt6hpb8fZx
         p5b8o3kjxPm3LM+EiJn5WBrK6UWpBQEDi9l1MVNy9y1oxv1AKmtGmjxiTfHtcwTDRvWx
         9xEZVdJ9YtHJwN8pIYGmq5PAyTMW8V5vAzoG8LMNgpy6Ly+EaNU+qp61K2n3TwxhJf1V
         1iIcbQYhxmYjRqzmYHDq8/ZAiJ0b3jKEqBV/1M2LHankjPhirDZW7DvX6o4lom7VkpOh
         40Icnafjfw5s6H36jrcwCWAIt5neIyZUzIXbZbISW8NoKk/I0LxsU9GScDqBULQLzyIB
         1mWw==
X-Gm-Message-State: APjAAAV+cv1cutuiFmmcDj+7rK5OFzyoUkP8V7x2cEhGWDaRY6HxFA0T
        tQQ7R4k/30k2x9hTJ0iZdms=
X-Google-Smtp-Source: APXvYqwOHSP6VGI+c+WCLijOFl5QUgm7TIFm8uBRjKS560u4/63ZU3mOmv1fIgQ0ufdJeHFLrtehMQ==
X-Received: by 2002:aa7:9256:: with SMTP id 22mr338244pfp.69.1559357287182;
        Fri, 31 May 2019 19:48:07 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id f11sm8189908pfd.27.2019.05.31.19.48.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:48:06 -0700 (PDT)
Date:   Sat, 1 Jun 2019 10:47:53 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        omosnace@redhat.com, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in
 selinux_sb_eat_lsm_opts()
Message-ID: <20190601024753.GA8962@zhanggen-UX430UQ>
References: <20190601021526.GA8264@zhanggen-UX430UQ>
 <20190601022527.GR17978@ZenIV.linux.org.uk>
 <20190601023449.GS17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601023449.GS17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 03:34:49AM +0100, Al Viro wrote:
> On Sat, Jun 01, 2019 at 03:25:27AM +0100, Al Viro wrote:
> > On Sat, Jun 01, 2019 at 10:15:26AM +0800, Gen Zhang wrote:
> > > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts' 
> > > should be freed when error.
> > 
> > What's the latter one for?  On failure we'll get to put_fs_context()
> > pretty soon, so
> >         security_free_mnt_opts(&fc->security);
> > will be called just fine.  Leaving it allocated on failure is fine...
> 
> Actually, right now in mainline it is not (btrfs_mount_root() has
> an odd call of security_sb_eat_lsm_opts()); eventually we will be
> down to just the callers in ->parse_monolithic() instances, at which
> point the above will become correct.  At the moment it is not, so
> consider the objection withdrawn (and I really need to get some sleep,
> seeing how long did it take me to recall the context... ;-/)
Thanks for your comments. And have a good dream.

Thanks
Gen

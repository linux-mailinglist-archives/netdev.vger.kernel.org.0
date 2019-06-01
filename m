Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2817C3191B
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfFACpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:45:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46042 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFACpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:45:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so7261211pfm.12;
        Fri, 31 May 2019 19:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4WbOFpAxQL4GYirBFbaw9qNj5js+de7uHKM69224ISc=;
        b=btAv0B3tPyxvMQWB+TzFj44YtGbNBcAMzNF2EfFH9LSrbcLfMP86or7GB0cLDJTngZ
         qXDNxMuuChQPtUOk4fDr9t8sWQ25IprzfgSSL4Qsyjpo3GZ8L+QKc7aLgPheHXct81av
         Z/Tn/WOrUfBXU49MlKClNjlqpuUoK59lAE+/FcSZZ2jx4ZkSLxP3FVRK9t9xKL5wy95h
         4amP4krdrmTcFuPqgjdFo0h91T6DR68ftdyYuM6ijAcb4FLWJuydbkP6s+jJIcEevcyI
         AZT17Vu+BUUGJ7FhXxHlcV04SrfLTyA3CLdxPqxQ4W9JRzHeKSewYAP0RqlvByVQAw+h
         nl5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4WbOFpAxQL4GYirBFbaw9qNj5js+de7uHKM69224ISc=;
        b=W4wOReEMqEn+ogci5kiBGqUhGJKvA18AcVqabtDuMOdyARAK3xacB5iegnB2n/EIkD
         JhJb5IZEtbaqyAB+6eredTj0ZEhZep5xQUpcWn17XFlcSHr4V2ZWS4LiuTevIDctSmK2
         7i3Gjp2+/Jh3X1A63AbhbMA3yOR7Bgcan1Lh6cia8FpfPyvgdgAsFRCvvp6RCwB8QNKQ
         2VuRxmRxDJCfUauD7kM4NdCR6wS+ehbcVXf/C559QsaKAefJx44M64PLOvZa4oYRpPxm
         5NvYDGjY/eVcraPqd+VMmkxcLBQ0/G3KkEYnjuy5C5e257Cd8us2GzclgcEA7QgoDP63
         CEhw==
X-Gm-Message-State: APjAAAVcKt3ds6CTjlvyHqOPWwgzhmxVRd2NIfsLH4X7Soro2oCHuojh
        7gCLiI5Bpq6Rs5U2PKj6soM=
X-Google-Smtp-Source: APXvYqx1YCdlnL/YqWmI7XGo2JOr352EGosOuZP1j8xh6q8za8TeSGPW4FP79gz/viKH8jPwzfEPLA==
X-Received: by 2002:a63:158:: with SMTP id 85mr13194120pgb.101.1559357113197;
        Fri, 31 May 2019 19:45:13 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id g17sm12182716pfk.55.2019.05.31.19.45.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:45:12 -0700 (PDT)
Date:   Sat, 1 Jun 2019 10:44:59 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        omosnace@redhat.com, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in
 selinux_sb_eat_lsm_opts()
Message-ID: <20190601024459.GA8563@zhanggen-UX430UQ>
References: <20190601021526.GA8264@zhanggen-UX430UQ>
 <20190601022527.GR17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601022527.GR17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 01, 2019 at 03:25:27AM +0100, Al Viro wrote:
> On Sat, Jun 01, 2019 at 10:15:26AM +0800, Gen Zhang wrote:
> > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts' 
> > should be freed when error.
> 
> What's the latter one for?  On failure we'll get to put_fs_context()
> pretty soon, so
>         security_free_mnt_opts(&fc->security);
> will be called just fine.  Leaving it allocated on failure is fine...
Paul Moore <paul@paul-moore.com> wrote:
>It seems like we should also check for, and potentially free *mnt_opts
>as the selinux_add_opt() error handling does just below this change,
>yes?  If that is the case we might want to move that error handling
>code to the bottom of the function and jump there on error.
I am not familiar with this part. So could you please show the function
call sequence?

Thanks
Gen

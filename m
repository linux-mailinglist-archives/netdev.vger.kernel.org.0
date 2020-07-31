Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA3D234ABA
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbgGaSQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387704AbgGaSQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:16:38 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287EBC061756
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:16:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so17812028pls.4
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TDjonBmuUQvyaWYJBgC/o+3/IEmbAX8AfV7I+TtewFc=;
        b=E4PyFhb0Ar5YqNdxhxX2a8wKFZEu/2ST7bv4QIUoGaSgkHPvdACktcHN8BvF+SCGL8
         gZJWGBtbJ1MutPmzg/MeNlYSrhO057Pj/J6ehg7IaGuZ0a9DQrTRDkr2F2AUHxyGQHaX
         o5ShFgfIeLuy7MxsZOrcqX/TEMhQthtAB0JiHr2774RA3qNIALhx8H1uHTP/NC31E9OO
         1sRdKk8GeU8qWga0AdkgKJ7aVu9Z38Gzq+ONP+rbl/VONE3s6VkbkgrgAE/99YuGzbma
         qkC31644KiV7Oo89U+xeFBWKkaLzShUKTYXxiZ3dr1g1cvQdGWka9CgJ2SY/P/OpyITQ
         orEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TDjonBmuUQvyaWYJBgC/o+3/IEmbAX8AfV7I+TtewFc=;
        b=AyU1KtCpgkc+vQgHJ3Cy9ZCe5evpgqz7WDS3NpcFBm5VRyI4Y+2I497PukMogGjFGF
         U8LERxGECtikiE2uizRCgzElgQ3pQ8Ev3juEmPWn8La+JJ/ydBKxyj+be+sutcvrpXmC
         DEaptf5rxyJopeXz/ktl/7L24WldJhA2h+SszSXfD4TlSPo7O6cQpJq36WRAJjoscOti
         /sV+INuey0Mvp/LJUnHc0fJeWEkRizNN4DaEmZ1tuwEfB2a/Oj6MsGyLUWQuK5zQFveQ
         UZoI0snEu9bOTPf9hZQiXXEkN6i6Ut2t26+L6UVuBc8vx8k6ur4j3ytUDz7wYiRPFYnw
         4mJQ==
X-Gm-Message-State: AOAM532mi/We02uB6cC0Jmpp5L5ns3k5M20bbADGNianqlxkO0MuHejL
        9b1u4GMCPX4ez7fuIgYnJJK6jQ==
X-Google-Smtp-Source: ABdhPJy17ACnRhf/sGausTWgDf+SetvtMH9mGnHzTZzE1/rZpZ/uKspET9z1pmDSWMBXKgG8hmfHAg==
X-Received: by 2002:a17:90b:514:: with SMTP id r20mr5377570pjz.82.1596219397381;
        Fri, 31 Jul 2020 11:16:37 -0700 (PDT)
Received: from google.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id a24sm10542844pfg.113.2020.07.31.11.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 11:16:36 -0700 (PDT)
Date:   Fri, 31 Jul 2020 18:16:33 +0000
From:   William Mcvicker <willmcvicker@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH 1/1] netfilter: nat: add range checks for access to
 nf_nat_l[34]protos[]
Message-ID: <20200731181633.GA1209076@google.com>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com>
 <20200731175115.GA16982@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731175115.GA16982@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

> Note that this code does not exist in the tree anymore. I'm not sure
> if this problem still exists upstream, this patch does not apply to
> nf.git. This fix should only go for -stable maintainers.

Right, the vulnerability has been fixed by the refactor commit fe2d0020994cd
("netfilter: nat: remove l4proto->in_range"), but this patch is a part of
a full re-work of the code and doesn't backport very cleanly to the LTS
branches. So this fix is only applicable to the 4.19, 4.14, 4.9, and 4.4 LTS
branches. I missed the -stable email, but will re-add it to this thread with
the re-worked patch.

Thanks,
Will

On 07/31/2020, Pablo Neira Ayuso wrote:
> Hi William,
> 
> On Fri, Jul 31, 2020 at 12:26:11AM +0000, William Mcvicker wrote:
> > Hi Pablo,
> > 
> > Yes, I believe this oops is only triggered by userspace when the user
> > specifically passes in an invalid nf_nat_l3protos index. I'm happy to re-work
> > the patch to check for this in ctnetlink_create_conntrack().
> 
> Great.
> 
> Note that this code does not exist in the tree anymore. I'm not sure
> if this problem still exists upstream, this patch does not apply to
> nf.git. This fix should only go for -stable maintainers.
> 
> > > BTW, do you have a Fixes: tag for this? This will be useful for
> > > -stable maintainer to pick up this fix.
> > 
> > Regarding the Fixes: tag, I don't have one offhand since this bug was reported
> > to me, but I can search through the code history to find the commit that
> > exposed this vulnerability.
> 
> That would be great.
> 
> Thank you.

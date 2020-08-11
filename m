Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E31241575
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 05:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgHKD5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 23:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbgHKD5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 23:57:31 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A22C06174A;
        Mon, 10 Aug 2020 20:57:31 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 77so9445547ilc.5;
        Mon, 10 Aug 2020 20:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Ej3O/P5forMr7lkh8Irj0X/aIJv290wNqPXSY+K8SQ=;
        b=Dy6m6mzpsrA6AiUFbCE/bSjm0Ha27RRY29MhbJd/pIkrgoNaBTwHAWHseayvDnrnCA
         HwxjeaxYINZHazGU3LyZTfhUmoxozHW8eUuuTVJ2bChVO3S4jc5gnpGqdixrngOjOvZb
         pT0JrlO6rdHNLUXHOw+rGQRqzehZQ2t0HR9Ie3vLxrt+zMZ3FFs1DyT/jBuUMxkJfg6h
         cMxGGUnbb16zLxzIVzIFBfrt08riVQ01vqyYYEiqsVUQRbTPP4a+aQTdOpE7Um4t77vW
         SGhixNnowuHWYLNeYCXspG6tRjf8su5CFtSR4DePU5Ta+mGtOJLAs6rjesqLj0qHV7qj
         PU3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Ej3O/P5forMr7lkh8Irj0X/aIJv290wNqPXSY+K8SQ=;
        b=T6WOTko7kXd2VZjt6DMoCG1kWM1ouXj1agzkqwbYfTHj/FPvG+a++w+38KVMsFyRiT
         tAw/v4nKiA5i0SqLNvaD053ffwN4YlyyofJYBFmYYHzzUpTnRU31EV7BavzKauzlSM+6
         JlKZ+ktVGYOFpUIrnrc1Wg/xqJQ/CplWCxrAITweQiQYWiu8jZ3w4OunjEgnzeCtscIw
         9+6CJxVTMopMOzEyovkSCl7D7TRhsty4FWyAhdO3htpTauHpSdS2xNJYG0WgBqFaGJ4X
         Tz0bvSvQTOVlXhemsVXA1hsyKyG2NmTfplMn6AWrNLsgt/CNfZcu0fThXQ051HmMYkJj
         QtVQ==
X-Gm-Message-State: AOAM533Cxt3ntDeLP2DK2LoZ8GEqoA0/4xtAUNJ/NSbBxl7H+yDurM2Z
        bDf9kI2vxKMWl1sPvsR1TKnRX0KEc+2dcZ8AHtY=
X-Google-Smtp-Source: ABdhPJxJs7CjX3vzQq4fwm46ZTzG5HJ9oYGcb02FW6eIoE2VtGxgiQ6jHAgG+NKiJD5eiy2VkBGZYzjktmLVzpEwS1A=
X-Received: by 2002:a92:bad5:: with SMTP id t82mr3521374ill.22.1597118250579;
 Mon, 10 Aug 2020 20:57:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200810220703.796718-1-yepeilin.cs@gmail.com>
In-Reply-To: <20200810220703.796718-1-yepeilin.cs@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 10 Aug 2020 20:57:19 -0700
Message-ID: <CAM_iQpWsQubVJ-AYaLHujHwz68+nsHBcbgbf8XPMEPD=Vu+zaA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 3:10 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
>
> do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
> zero. Fix it.

Which exact 'cmd' is it here?

I _guess_ it is one of those uninitialized in set_arglen[], which is 0.
But if that is the case, should it be initialized to
sizeof(struct ip_vs_service_user) instead because ip_vs_copy_usvc_compat()
is called anyway. Or, maybe we should just ban len==0 case.

In either case, it does not look like you fix it correctly.

Thanks.

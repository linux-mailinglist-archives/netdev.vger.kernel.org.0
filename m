Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF72D39AEEB
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhFCX6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFCX6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 19:58:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE4C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 16:56:16 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id k5so4602835pjj.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 16:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7X9FKrqLzt1i2t0Ku1xI3R3zrhpNkeGMlR6bn3lhGns=;
        b=f05RDYdtRIMxeJA/R8WKQMZQxuuvO9GXTnJk+sCy/ZLaV0zUgu+PwPLZ0GwZ5Y8SpZ
         GNn/bMTzGveNl+YZFFUsqTlVUG935cmt5Dr3YDbWKU2igLPyomWF0tRM8jth/akW4a+3
         gYr8Kd62u3DMQH3D8jeeZ1bgkaqFQphXKA+ageq6pSbnVRLRGBNbXz2WXCSBAEgxzu4b
         fc61ecdlpNJdhvnWzXHJRPfjvYaZc7sxsLN5OTKMcqWfiXWPtG5UyYrbAHkgr1lgoGAE
         0kkBsBB82hIfC7nt6+OPWM/e2lgA6aqJMydGfBCTPNODW8vmRbgnKTMFn03Wc6DXJ+dC
         p+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7X9FKrqLzt1i2t0Ku1xI3R3zrhpNkeGMlR6bn3lhGns=;
        b=CFWvfIVNJ+Jbfs4lv56K9xd+nJ/6wIcnKgXeNiKLlC3SrFfLeZxIU6V2rn+19NiS2b
         CBps+asU1p1c16KLinUQ4e6z8wWUQ7b7ruSvXDVHaOaXri7L52l6BL7VxxaK95vAIG36
         o9bdB14LEU+SO1tgob8Ur+Vs43ys2nqJ6SYC3ymTnx4/UD963tV3pH0ZWN7MTP64aiFb
         ryxJrImG8lrJCe9xX+svmiegg+V9G6f2O0iXinjEmGtaovADkfdcEVflHCtJT371fp99
         gGBtej99y/KCEtSFzvV1g5fxQFGYSj4zaWQ5qS3maWNhqosnml+c2+3ODa3W/SVHE5j4
         Tq3g==
X-Gm-Message-State: AOAM530Rfj0BQ586MTNbMTha91ljuPX+fIdddvMriwu0Mcc+mXhYYjN3
        ululZ5/viExUmeyEh9TPXTo=
X-Google-Smtp-Source: ABdhPJxpfcQmjPGEudc06ohYmEKlv2AWBNeC5ewntry/Xo7dZhoLafvyk+mEJB4zm6PcSmrAVImK7w==
X-Received: by 2002:a17:902:728e:b029:101:c3b7:a47f with SMTP id d14-20020a170902728eb0290101c3b7a47fmr1635436pll.21.1622764576133;
        Thu, 03 Jun 2021 16:56:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:82fb])
        by smtp.gmail.com with ESMTPSA id r9sm150844pfq.158.2021.06.03.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 16:56:15 -0700 (PDT)
Date:   Thu, 3 Jun 2021 16:56:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3 2/3] virtio_net: add optional flow dissection
 in virtio_net_hdr_to_skb
Message-ID: <20210603235612.kwoirxd2tixk7do4@ast-mbp.dhcp.thefacebook.com>
References: <20210601221841.1251830-1-tannerlove.kernel@gmail.com>
 <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601221841.1251830-3-tannerlove.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 06:18:39PM -0400, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> Syzkaller bugs have resulted from loose specification of
> virtio_net_hdr[1]. Enable execution of a BPF flow dissector program
> in virtio_net_hdr_to_skb to validate the vnet header and drop bad
> input.
> 
> The existing behavior of accepting these vnet headers is part of the
> ABI. 

So ?
It's ok to fix ABI when it's broken.
The whole feature is a way to workaround broken ABI with additional
BPF based validation.
It's certainly a novel idea.
I've never seen BPF being used to fix the kernel bugs.
But I think the better way forward is to admit that vnet ABI is broken
and fix it in the kernel with proper validation.
BPF-based validation is a band-aid. The out of the box kernel will
stay broken and syzbot will continue to crash it.

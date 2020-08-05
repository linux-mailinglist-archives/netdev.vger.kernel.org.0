Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE3123C368
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 04:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgHECUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 22:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgHECUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 22:20:41 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD38C06174A;
        Tue,  4 Aug 2020 19:20:41 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id r4so13786904pls.2;
        Tue, 04 Aug 2020 19:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g8eUQla4V3zNZzC+L9iZCFLLZwaiqDieY5utNjnYvAs=;
        b=mZdoJl85HT4OrfTGDlTMz0L5y82FQ9JQViVW7bxrhVWu26orZO4kfs1AvjuQNIxHnw
         ZCqCTQzgyWEmHBw7V5alRDkaxGIlwwpn6JAJkrrB5APqNDlTYwujplFM9QNmVg+ER9y5
         xdrhPqXljGRphnMppEKkDGe49xOEPhczi12XkypEZB+OnMLXfCF1RrqNgFmal5d937JB
         U41dJS1nSc62dSerofptL/c0Q/+OOEmc4UWoPbf+ak/K5nDmiDI9aSPI5aWs7lHisAfk
         y1FVmW5oEB3NGTTWX7R5lbALA1/YM8njU1/CpgfZJaG5P9MtoWDVdG+nnoWtERSNPX22
         r0CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g8eUQla4V3zNZzC+L9iZCFLLZwaiqDieY5utNjnYvAs=;
        b=fWBV1hdne9/B+lJ99XOQ2w/nH8HHDMkWIPC9Z3/Wvkef3oHbiqxGp076TnNlBhTsdd
         CHbj/gxr26xh4GwZB9r4JPm1lt4A8lZ9ALI0oG8ApUoaH3kmxl7do+U6t2O2/LntV7N0
         hOTYzPwg5Q+jvHov0t6Abne1Gsz1RXiX2l8cerPLtXI2uOjR1LJjpgBUCs5jApW7zZhQ
         3Be6T0/hXa/MphOASWfv9xSylmdeqp5mVc/1AU9Q4LT4q1gRQMk7JiHkS9lNItepiwcB
         hx5KL8Otd2eceZ1TDg2W0REW9Geq/RsZ6ZmBQPo2iXSBsfj4xjYh2cQVpj1XFgb+ydg6
         dO3Q==
X-Gm-Message-State: AOAM5338VTV7azQ7CzPDjp3RY07xIwiPz+sjf51jW6rbbYiSBgdXM7NB
        gMzuAXtFVOpUsmuW45FGxGg=
X-Google-Smtp-Source: ABdhPJyZhHFt0TWFlppILOWrF+qqnC5oX2XJS58aLf352JieE6ua3tIzEhNefjrQ6ly0izoY/nJ74Q==
X-Received: by 2002:a17:902:30d:: with SMTP id 13mr965711pld.251.1596594040773;
        Tue, 04 Aug 2020 19:20:40 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h24sm608317pgi.85.2020.08.04.19.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 19:20:40 -0700 (PDT)
Date:   Wed, 5 Aug 2020 10:20:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, gnault@redhat.com, pmachata@gmail.com,
        roopa@cumulusnetworks.com, dsahern@kernel.org, akaris@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCHv2 net 2/2] vxlan: fix getting tos value from DSCP field
Message-ID: <20200805022029.GM2531@dhcp-12-153.nay.redhat.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200804014312.549760-1-liuhangbin@gmail.com>
 <20200804014312.549760-3-liuhangbin@gmail.com>
 <20200804.124756.115062893076378926.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804.124756.115062893076378926.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 12:47:56PM -0700, David Miller wrote:
> From: Hangbin Liu <liuhangbin@gmail.com>
> Date: Tue,  4 Aug 2020 09:43:12 +0800
> 
> > In commit 71130f29979c ("vxlan: fix tos value before xmit") we strict
> > the vxlan tos value before xmit. But as IP tos field has been obsoleted
> > by RFC2474, and updated by RFC3168 later. We should use new DSCP field,
> > or we will lost the first 3 bits value when xmit.
> > 
> > Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Looking at the Fixes: tag commit more closely, it doesn't make much
> sense at all to me and I think the fix is that the Fixes: commit
> should be reverted.

Hi David,

Both this patch and the Fixes: commit are not aim to fix the ECN bits.
ECN bits are handled by ip_tunnel_ecn_encap() correctly.

The Fixes: commit and this patch are aim to fix the TOS/DSCP field, just
as the commit subject said.

In my first patch "net: add IP_DSCP_MASK", as I said, the current
RT_TOS()/IPTOS_TOS_MASK will ignore the first 3 bits in IP header
based on RFC1349.

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |   PRECEDENCE    |          TOS          | MBZ |
    +-----+-----+-----+-----+-----+-----+-----+-----+

While in RFC3168 we defined DSCP field like

       0     1     2     3     4     5     6     7
    +-----+-----+-----+-----+-----+-----+-----+-----+
    |          DS FIELD, DSCP           | ECN FIELD |
    +-----+-----+-----+-----+-----+-----+-----+-----+

So if a user defined the IP DSCP/TOS field like 1111 1100, with
RT_TOS(tos) we will got tos 0001 1100, but based on RFC3168, we
should send the header with DSCP 1111 1100. That's why I add
RT_DSCP() in my first patch.

> 
> If you pass the raw TOS into ip_tunnel_ecn_encap(), then that has the
> same exact effect as your patch series here.  The ECN encap routines
> will clear the ECN bits before potentially incorporating the ECN value
> from the inner header etc.  The clearing of the ECN bits done by your
> RT_DSCP() helper is completely unnecessary, the ECN helpers do the
> right thing.  So effectively the RT_DSCP() isn't changing the tos
> value at all.

Yes, you are right. RT_DSCP() doesn't change the tos value in this case.
I will revert the Fixes: commit.

While RT_DSCP() is still needed in other place, I will re-post a new patch
set for that issue.

> 
> I also think that your commit messages are lacking, as you fail
> (especially in the Fixes: commit) to show exactly where things go
> wrong.  It's always good to give example code paths and show what
> happens to the TOS and/or ECN values in these places, what part of
> that transformation you feel is incorrect, and what exactly you
> believe the correct transformation to be.

Thanks, I will try add more info in later patches.

Hangbin

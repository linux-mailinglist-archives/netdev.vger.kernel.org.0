Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986CA1A37D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfEJTrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 15:47:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34282 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfEJTrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 15:47:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id h1so216669qtp.1
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 12:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0JPiIkmtXEvLAlwiZsHHxw0pHdfvTgZ9CAyfI7bW8n4=;
        b=SIluc+X2+TM3fMvorL1I2b3Empnk6WMpFtpPnRlo+RvlUlE+/vRv5luPme0tdGwwi1
         MJho3sphoyr3YWIFsaTUEaa8EeNcafwWJe7IfWQgIGHPAuoMZ+yGEILCBIgJ3zq8djFC
         w/AIuokIRG+dazoaudR3iRFC65VjHEx0q7Na+edKS8JzbpoXynIf65kxVd9r3vhHu6SF
         n8vEdFlsGg377ggtXqrV2MAY6MtimBWEDRsXOEQm4Wv8wceB9CWWinGYsarr0LqpHEjR
         OGjJAFf/3rT1bb5PKkjmHMHJFfwxZyzLNdQNPrBRvnjdTOJ0XydtOephneVR+IMD8qcq
         HhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0JPiIkmtXEvLAlwiZsHHxw0pHdfvTgZ9CAyfI7bW8n4=;
        b=kjsteMMFRC/+rcP37tlEW8a0+kWeiizIf+4YpB/rduaXTBwUwoPKnyKgaZj4uGjEiM
         BiDNuAWcoPMudbo9DXIJe2X2uDti6w3SFfE5SDki0lSQVLXj171dYBclVU3RRbiAYcMY
         Z78GqOEXl4VrlnPEtQEyQ5OcDzyrTrdu26rnuCLHfIDefmPDS1UGEs5pJhSjJTJc3brp
         WUfvhpKcr/jtccE/XxnE1V1Nreq8aV7TsBOMaM3NQ/Zl5CyNK/xYknz97Y0yOgYv6WQD
         U5C5z2EXVXkK2g/iWuU+e9RDkBsmRYnq0B6dVC90Rp+lrOga6JDPGY+q8/NUPBtuOEH1
         tFlw==
X-Gm-Message-State: APjAAAUsksj2XP9HvJwLOM+t/WqqTTZJT7RASqSj+YrOkbvvDNF8m40d
        6vCeULPh2DDdkcONmZDyTjjNiA==
X-Google-Smtp-Source: APXvYqwystaffayOLYopgUbhuSlfnJbAyat3bX1UCpAfe7u89BLoi1pxNMSrIZR+6V/L7OFPGE+GjQ==
X-Received: by 2002:aed:3787:: with SMTP id j7mr11622398qtb.6.1557517674711;
        Fri, 10 May 2019 12:47:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id k65sm3581235qkc.79.2019.05.10.12.47.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 12:47:54 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hPBUn-0004Ca-OW; Fri, 10 May 2019 16:47:53 -0300
Date:   Fri, 10 May 2019 16:47:53 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510194753.GI13038@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190510125431.GA15434@ziepe.ca>
 <8b00b41c-bbc5-7584-e5cf-519b0d9100c5@oracle.com>
 <20190510175538.GB13038@ziepe.ca>
 <9b0e6760-b684-c1ce-6bf5-738eff325240@oracle.com>
 <20190510180719.GD13038@ziepe.ca>
 <d25910f3-51f1-9214-3479-150b1d320e43@oracle.com>
 <20190510192046.GH13038@ziepe.ca>
 <2c16b35d-c20c-e51d-5d4e-0904c740a4ec@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c16b35d-c20c-e51d-5d4e-0904c740a4ec@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 12:38:31PM -0700, Santosh Shilimkar wrote:
> On 5/10/2019 12:20 PM, Jason Gunthorpe wrote:
> > On Fri, May 10, 2019 at 11:58:42AM -0700, santosh.shilimkar@oracle.com wrote:
> > > On 5/10/19 11:07 AM, Jason Gunthorpe wrote:
> > > > On Fri, May 10, 2019 at 11:02:35AM -0700, santosh.shilimkar@oracle.com wrote:
> 
> [...]
> 
> > > > Why would you need to detect FS DAX memory? GUP users are not supposed
> > > > to care.
> > > > 
> > > > GUP is supposed to work just 'fine' - other than the usual bugs we
> > > > have with GUP and any FS backed memory.
> > > > 
> > > Am not saying there is any issue with GUP. Let me try to explain the
> > > issue first. You are aware of various discussions about doing DMA
> > > or RDMA on FS DAX memory. e.g [1] [2] [3]
> > > 
> > > One of the proposal to do safely RDMA on FS DAX memory is/was ODP
> > 
> > It is not about safety. ODP is required in all places that would have
> > used gup_longterm because ODP avoids th gup_longterm entirely.
> > 
> > > Currently RDS doesn't have support for ODP MR registration
> > > and hence we don't want user application to do RDMA using
> > > fastreg/fmr on FS DAX memory which isn't safe.
> > 
> > No, it is safe.
> > 
> > The only issue is you need to determine if this use of GUP is longterm
> > or short term. Longterm means userspace is in control of how long the
> > GUP lasts, short term means the kernel is in control.
> > 
> > ie posting a fastreg, sending the data, then un-GUP'ing on completion
> > is a short term GUP and it is fine on any type of memory.
> > 
> > So if it is a long term pin then it needs to be corrected and the only
> > thing the comment needs to explain is that it is a long term pin.
> > 
> Thanks for clarification. At least the distinction is clear to me now. Yes
> the key can be valid for long term till the remote RDMA IO is issued and
> finished. After that user can issue an invalidate/free key or
> upfront specify a flag to free/invalidate the key on remote IO
> completion.

Again, the test is if *userspace* controls this. So if userspace is
the thing that does the invalidate/free then it is long term. Sounds
like if it specifies the free/invalidate flag then it short term.

At this point you'd probably be better to keep both options.

> Will update the commit message accordingly. Can you please also
> comment on question on 2/2 ?

I have no advice on how to do compatability knobs in netdev - only
that sysctl does not seem appropriate.
 
Jason

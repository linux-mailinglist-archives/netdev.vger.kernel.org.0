Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522CF26560A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 02:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgIKAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 20:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgIKAbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 20:31:45 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69478C061573;
        Thu, 10 Sep 2020 17:31:45 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id cr8so4321990qvb.10;
        Thu, 10 Sep 2020 17:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Gw9EI8PIsj4K4PQPxpv3GeZ8+OtSe8DLVQFJoM0qSk=;
        b=lETZdGhxXnxwmeXafnd3fOgbV/mH4yUJY2NcDnwqxexZW9wBVscMchFr2IjsYeawFp
         07xx7zTNGnHYZZWL+LmLIGzD4xkEOsg2A+K9c0KkdHUFdTkeNX1JB8GfwSksrQwaXTPb
         0JgKVgtpeVEkoo3vLap1Yn0fm7ZUE31tEjgZzGkSKhp+emIvgoDU4OFtShfY5B6+2D8P
         PqtJY2cKTEr+AzVHyKAhYfZr3EpQRL/iPnlqdgINQgOH1XAL1K8pA73iy1Tu7LoxGfvm
         FbCVl74E969J1Z2rQZsXud0eHY/fz9qo3hWxAeS/Mlws22NPfhn0Vd0wDlyc/YLNzr/g
         i9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Gw9EI8PIsj4K4PQPxpv3GeZ8+OtSe8DLVQFJoM0qSk=;
        b=Q5vNeJuPaJfSG57n8A8+d/vLTqN4uDpjBzN7MuyKkEd2wZYvYlGoXdT9KbxBPf9H3B
         4ySC6ubjIH6RGLTdrNlT6A8FDGNktzrLAXC1Q3B7gC9wIcIZIGOrJn0TEWlnu+sJvwm4
         792IeRvEou/ltGW8pq+GyLzIUlksMZhhS0kHPzg/zyh8TZMJ0dHAPR1+hzZl+u1ofVDb
         MAPNzw6zfQZ/q21QcvsZLu5MsfGQ8oPKh/uDRFjyoFWawnHpN07LryZj1wOXjJP/m6ZG
         uk74dy/qJ8D0tJL+bpT7+3qyNSLhHkP3K9Vp4LSoMIlsyYTNiEW/8R+ZLHnAugIALApk
         aMdA==
X-Gm-Message-State: AOAM532lF7/QzMrzjfCE2qp4RIx8hi8VMSkqXteTWOsWz8PCrOSAHZF6
        nYgbeFKMlT2/0CGD+yX0nPc=
X-Google-Smtp-Source: ABdhPJyBN4o6O0GTwjLg+fXcrrSDtsx15F/L1uwHSfTqGGpo8Fb+3+sKk1WGNH2YP2wqNmok9pWu7w==
X-Received: by 2002:a0c:8e4c:: with SMTP id w12mr11600652qvb.3.1599784304531;
        Thu, 10 Sep 2020 17:31:44 -0700 (PDT)
Received: from ubuntu-n2-xlarge-x86 ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id v42sm527471qth.35.2020.09.10.17.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 17:31:43 -0700 (PDT)
Date:   Thu, 10 Sep 2020 17:31:42 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: mvpp2: Initialize link in
 mvpp2_isr_handle_{xlg,gmac_internal}
Message-ID: <20200911003142.GA2469103@ubuntu-n2-xlarge-x86>
References: <20200910174826.511423-1-natechancellor@gmail.com>
 <20200910.152811.210183159970625640.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910.152811.210183159970625640.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 03:28:11PM -0700, David Miller wrote:
> From: Nathan Chancellor <natechancellor@gmail.com>
> Date: Thu, 10 Sep 2020 10:48:27 -0700
> 
> > Clang warns (trimmed for brevity):
> > 
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3073:7: warning:
> > variable 'link' is used uninitialized whenever 'if' condition is false
> > [-Wsometimes-uninitialized]
> >                 if (val & MVPP22_XLG_STATUS_LINK_UP)
> >                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3075:31: note:
> > uninitialized use occurs here
> >                 mvpp2_isr_handle_link(port, link);
> >                                             ^~~~
> > ...
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3090:8: warning:
> > variable 'link' is used uninitialized whenever 'if' condition is false
> > [-Wsometimes-uninitialized]
> >                         if (val & MVPP2_GMAC_STATUS0_LINK_UP)
> >                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:3092:32: note:
> > uninitialized use occurs here
> >                         mvpp2_isr_handle_link(port, link);
> >                                                     ^~~~
> > 
> > Initialize link to false like it was before the refactoring that
> > happened around link status so that a valid valid is always passed into
> > mvpp2_isr_handle_link.
> > 
> > Fixes: 36cfd3a6e52b ("net: mvpp2: restructure "link status" interrupt handling")
> > Link: https://github.com/ClangBuiltLinux/linux/issues/1151
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> This got fixed via another change, a much mode simply one in fact,
> changing the existing assignments to be unconditional and of the
> form "link = (bits & MASK);"

Ah great, that is indeed cleaner, thank you for letting me know!

Cheers,
Nathan

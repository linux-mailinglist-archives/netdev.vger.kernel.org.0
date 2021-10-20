Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3B43547C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 22:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhJTUWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 16:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhJTUWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 16:22:35 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE145C06161C;
        Wed, 20 Oct 2021 13:20:20 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i22so8972796ual.10;
        Wed, 20 Oct 2021 13:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=llHgAnEBBihqnLqsfxJZ95+VA1vbnQXxbNgD4n9tUPo=;
        b=qpnhmVWSXEyIkwoADcN5lC8AhKEX9g/WADTw+bjSV1eD4KzF3oWVWXiG7SMAnDseXd
         +KqzZ6ruPBiadC3lqCrPus+jxgPqHFzXsxL1JiBvXtIfiTpCIVSgOU5UIxOpdwh5q9wx
         xkmf4nBHPTXxDhrELJZL9UY/NQtAQGqbanSkJZJ2Enkys/kHQUHvMPVMWe6qIXR9pwiK
         KDkEkX63UitsZTPFRhn9cJpEVSFPLDdeGcFxqf97u399yTBsrbptYAfNXC8VJgHpilIo
         jonKFgPXCBh5dQ6quZKtOH3Cxk762+4IuOmF31aLb+mvqOgeeCMFvBpNmtcxM8/bQl5Y
         Xy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=llHgAnEBBihqnLqsfxJZ95+VA1vbnQXxbNgD4n9tUPo=;
        b=zpjP445V6LM/jq+V2d/LE08mn41wIlpegyJURJwG/xbFtAGJJfKSN/PEHKBMfpJNN6
         pdLvE00l0d6ezFgoi/fd64v7JmFa6WCoeSl3lVABaSlJyVRXwGeQ12mfI/EJfpGKh4ry
         IhgJfW7PtKPkWITG2LIgbQ388Gyg0cDL/FJbpi9ONjqGaMfnd+YclO3BIx2+oMkWO0aR
         qf0CP3FsUoAoRQZ8WzEQGE2OZqVeVyB9DSKXWQxwZoaE2I/V4QkGMnxGTlx0G8WxJp6x
         yNs9+Te60t4T3KxhDdD37lWY9wz1G4Fxi+WSjliZC595/ChnfOR+6UvAG2IeqgM7ZMWw
         cYdQ==
X-Gm-Message-State: AOAM530d6WWAMNBI2+cTUj94AjzydVSgB6/FbwjQE1EHuyR2qwyRw6HG
        drfXOTCwYb2cKtRnNOtaqb8=
X-Google-Smtp-Source: ABdhPJwcPtU1ZKGiElJ9EZX/eo+DHMBEfpKWNbn7c9EY1tc5FZrxErIe+jlnWys1Sn2f9TgWQwkaRw==
X-Received: by 2002:a67:cb0a:: with SMTP id b10mr2327321vsl.9.1634761219749;
        Wed, 20 Oct 2021 13:20:19 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id h21sm1860289vsl.14.2021.10.20.13.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 13:20:19 -0700 (PDT)
Date:   Wed, 20 Oct 2021 17:20:13 -0300
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "tbecker@redhat.com" <tbecker@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
Subject: Re: [PATCH] sunrpc: bug on rpc_task_set_client when no client is
 present.
Message-ID: <YXB5/TnA0qnGB+YA@nyarly.rlyeh.local>
References: <20211018123812.71482-1-trbecker@gmail.com>
 <f16b2dc1c2fa50cb557b39a9ef83bf83ea6279b5.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f16b2dc1c2fa50cb557b39a9ef83bf83ea6279b5.camel@hammerspace.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 07:04:35PM +0000, Trond Myklebust wrote:
Hello,

> I'm not seeing the point of this BUG_ON(). Why not just change this
> code to not check for clnt == NULL, and let the thing Oops when it
> tries to dereference clnt?

This was changed in 58f9612c6ea85, prior to that, this was not tested. I'm
not sure why this test exists, the only reason I can imagine is to keep
the previous task's rpc_client in case the new client is NULL. Decided
to go conservative on this, and BUG_ON() when no client is available.

Inside the linux source, I don't see how this may happen unless the code
has a bug, so I think it's possible to remove this test.

-- Thiago
 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 

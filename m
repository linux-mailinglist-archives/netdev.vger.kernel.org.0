Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB13534BA
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 18:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhDCQdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 12:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDCQda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 12:33:30 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA911C0613E6;
        Sat,  3 Apr 2021 09:33:27 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id o16so8506499ljp.3;
        Sat, 03 Apr 2021 09:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GM6DBaeG+OLBXg3SeHdBc39md8Ic7y70PJaj4aCWnkw=;
        b=skzHdNOTxaMrgEUADT04r72dJcsjl3B8ZT3pavEd4VgbuHZ2+1wTUASXKNgF3/FbEq
         wyZjO9zfwXZOZPWSdsuZJmAcSHmGfGaz7WdXsmkqMVOYGsQ1OYtx2cEP6rP1qxBrWQha
         TVlooz+bG/sbv29SfNCbVQgv6g0XWk5p7c4xFSwRO7Bv+h0gW7Tc7TqCZBTnIyGdpriv
         8ne7jypkGlic3nolpDv9Of3YdFi+lrZHQ4h5qFSbeBDsYDZ5WiKtBxWrxQp3Wr39kyGX
         rn3xMBNngAsbwgM9bBsmpaBzKU0/kfKGWhprzcSBWCXFdzclp354Av8LrZcx4HpI2CcU
         igQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GM6DBaeG+OLBXg3SeHdBc39md8Ic7y70PJaj4aCWnkw=;
        b=hb0FE4Luf+RkIvusKh5T3Xc25F6PjrNIcx3hMiilJIMubjHFvYyndiU9hMKBFWFSg2
         f4ZJ69PsL2CV8db9xdTHyiPfK0jUCuXhmb+FQXFJMNV4EPocIxkosgp2vlcCEAp9iHH9
         Sad4ndi0xeZxXlC10L98kUre7bsQ8SRsGlrIoLMa55eSQdsFz7cfd4G9mT5iAHjRWep5
         7SjVz3FIdrSCB1LOPhWM041HGc/USzx7DRY0YAuxEXv0r7rr7l8mfoXVhZXbjt52yBrC
         cZryzEihBZKlfLd8zTtnDKdOzGnmVCSvECi/Gj4g4vclSVItGIc/T4UKQa5LWYAiqnVy
         4KyA==
X-Gm-Message-State: AOAM531jC1OXIM4VBuEEHeyNIUOx3hMerYIS+U7hSnsMmMYfFFcICP1N
        C3HRR9FTQ9PXaqM08v2AbPBMApjr+R4Sp7L3y+g=
X-Google-Smtp-Source: ABdhPJwxasRl9NRsMQLvnJ7dwRxjkeG2rKWFFCkxQ0O2Zdy/fNfFPtyHcBIc/tT4z88MksFM4CDLNg==
X-Received: by 2002:a2e:8e87:: with SMTP id z7mr11692549ljk.142.1617467606057;
        Sat, 03 Apr 2021 09:33:26 -0700 (PDT)
Received: from [192.168.1.11] ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id z6sm1188052lfr.34.2021.04.03.09.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 09:33:25 -0700 (PDT)
Message-ID: <1308b92b9592f6a3331b199658e306714c8c9cac.camel@gmail.com>
Subject: Re: [PATCH] net: netlink: fix error check in
 genl_family_rcv_msg_doit
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sat, 03 Apr 2021 19:33:24 +0300
In-Reply-To: <b8a83042f83af92e87550085175da5c1d95cc4b0.camel@sipsolutions.net>
References: <20210403151312.31796-1-paskripkin@gmail.com>
         <b8a83042f83af92e87550085175da5c1d95cc4b0.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sat, 2021-04-03 at 18:26 +0200, Johannes Berg wrote:
> On Sat, 2021-04-03 at 15:13 +0000, Pavel Skripkin wrote:
> > genl_family_rcv_msg_attrs_parse() can return NULL
> > pointer:
> > 
> >         if (!ops->maxattr)
> >                 return NULL;
> > 
> > But this condition doesn't cause an error in
> > genl_family_rcv_msg_doit
> 
> And I'm almost certain that in fact it shouldn't cause an error!
> 
> If the family doesn't set maxattr then it doesn't want to have
> generic
> netlink doing the parsing, but still it should be possible to call
> the
> ops. Look at fs/dlm/netlink.c for example, it doesn't even have
> attributes. You're breaking it with this patch.
> 
> Also, the (NULL) pointer is not actually _used_ anywhere, so why
> would
> it matter?
> 

Oh, I see now. I thought, it could cause a NULL ptr deference in some
cases, because some ->doit() functions accessing info.attrs directly.
Now I understand the point, sorry for my misunderstanding the
situation.

> johannes
> 

With regards,
Pavel Skripkin



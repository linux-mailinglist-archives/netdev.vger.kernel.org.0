Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4685025E0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350765AbiDOGxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiDOGxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:53:13 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6FFB3DC0;
        Thu, 14 Apr 2022 23:50:46 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s25so8500403edi.13;
        Thu, 14 Apr 2022 23:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FuI2l9kDOo4LiYnP+oGo08tHGCFvEiqQxGIgY3zlKIA=;
        b=Dz7hxGHDeM5WnsAFMqIITeeKULRipD+St4//j1pf82am51Ed9InFiST07WqtKVMdOm
         uBSITb/oa9bo8SGPYJEJnMK6fkDCaXrvBd933+oAb9Tyb3KearAu9DcInWJznOW442r0
         7TZrMqJOexp8wXZLWvdqy4xZSzPfd/24xu/HiCMClXJGA0hbkjP2hoiFNoai4rYkkmP/
         MBFXGVFB69N1yno5X6W5VJlt3zZUZ4ucvS4hbMdJ80eXVelJYVhtWnuZGgCAB3yuEaKC
         U7ONGlWpwMlLAfI8QbVwYBpkMLLEp6PeEwAJxqIXhrDX/KIYCrOVC8sq9xuzqYYJj2Fi
         rMlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FuI2l9kDOo4LiYnP+oGo08tHGCFvEiqQxGIgY3zlKIA=;
        b=GlnE7m09xQRa+jvbausuOC2XjqtGSqMAazIylwCtpXT6kDz0TCmj6Wh6MaIJfT4IWR
         CkVbkgN9iT50+n4W8t75zDl3Emn8E2VnNmQwF3Zg4AYTm9NGX9sJj62SlO2kJjGh3Sg1
         2WHaIeccOH9FJRpKA97QuyXJK97w0n8eIriJ+aXj4Jr5cwnzSWoO5N+RVNydKfm771iw
         0ZYp+joLRP78L9n0el9wT5x5CSNi7k6BAJs5mV7ju8On1w9O5J5vFVkG0EQo+yo0pG38
         bsY8SI+C8aWWM1u6ek3qfjTSdpAgrakFDnnKU4qMkENud9q/1IhJByffYAaAmgPaGTyf
         9shA==
X-Gm-Message-State: AOAM533PNCskqw0vUAkntTX8jsDaD1xT5ezidm2vxmwtUWZmom+YuixG
        jC+rQMdUVJeMnREP+2hAerIClz1zQXH3hE9x
X-Google-Smtp-Source: ABdhPJyvG6erOo3dT0Ozq8rJ75PwgZ+s/hBNzb+6RwjUN21kmuAXGLK65+mJnqz24BCHAYJpl28FlA==
X-Received: by 2002:a05:6402:1912:b0:41d:975b:9496 with SMTP id e18-20020a056402191200b0041d975b9496mr6930321edz.222.1650005445000;
        Thu, 14 Apr 2022 23:50:45 -0700 (PDT)
Received: from anparri (host-79-52-64-69.retail.telecomitalia.it. [79.52.64.69])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906724d00b006cedd6d7e24sm1371176ejk.119.2022.04.14.23.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 23:50:44 -0700 (PDT)
Date:   Fri, 15 Apr 2022 08:50:41 +0200
From:   Andrea Parri <parri.andrea@gmail.com>
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/6] hv_sock: Initialize send_buf in
 hvs_stream_enqueue()
Message-ID: <20220415065041.GC2961@anparri>
References: <20220413204742.5539-1-parri.andrea@gmail.com>
 <20220413204742.5539-5-parri.andrea@gmail.com>
 <PH0PR21MB3025F58A2536209ED3785F24D7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR21MB3025F58A2536209ED3785F24D7EE9@PH0PR21MB3025.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -655,7 +655,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk,
> > struct msghdr *msg,
> > 
> >  	BUILD_BUG_ON(sizeof(*send_buf) != HV_HYP_PAGE_SIZE);
> > 
> > -	send_buf = kmalloc(sizeof(*send_buf), GFP_KERNEL);
> > +	send_buf = kzalloc(sizeof(*send_buf), GFP_KERNEL);
> 
> Is this change really needed?

The idea was...


> All fields are explicitly initialized, and in the data
> array, only the populated bytes are copied to the ring buffer.  There should not
> be any uninitialized values sent to the host.   Zeroing the memory ahead of
> time certainly provides an extra protection (particularly against padding bytes,
> but there can't be any since the layout of the data is part of the protocol with
> Hyper-V).

Rather than keeping checking that...


> It is expensive protection to zero out 16K+ bytes every time we send
> out a small message.

Do this.  ;-)

Will drop the patch.

Thanks,
  Andrea

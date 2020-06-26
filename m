Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D1220B0E1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgFZLuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:50:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39127 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgFZLuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:50:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id s14so4191378plq.6;
        Fri, 26 Jun 2020 04:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m6IlfQ2e8V9TPNspezYLF8SplDOhvC9AL7TcXaCoLTk=;
        b=OQZxqT3mZBVUFtAHYWFqkOtO3QCJKc7upfuQZW2bxqPD+cPkiLUJxE7P/dxwjx6VbR
         YDDJHHAQrLVNHloqBHOIGMh0OKaYBLB+BaYYKPgjKC4hbDtXMiM3oJRLGs4mXNrGKpsl
         f0p4yVh487Mn24jw2PO51M3Ifws+/eLdrS2dgUAvdP86+KOA5rp87DNMrKyC7bDKjeRd
         P8Y3ChhutOUXuuWWrVXiiYKDFDVEFscrIM05e82dWfGYSp6k2lebN/kzm7bkZLmCBVFu
         6ygkwEhpaKcCOX6vpII5PAHGhisivsqUY/WbgZ62z36yQR2pnbiE+EpgJwvcDui8+Pr+
         d8zA==
X-Gm-Message-State: AOAM5315s1Zh7GAvbf/+hiwuXqDytkwvwwFaFjegKn2kJN5GvDP7b/l0
        iufu1Ya9FWmZdN6hVmcaGpw=
X-Google-Smtp-Source: ABdhPJw+vfjYwkjyjOXkCMgArijGLXv7vSz+rOJhbL995GWA76AlNmn2PvrbvK5DZHp9UnPtP91fyw==
X-Received: by 2002:a17:902:7896:: with SMTP id q22mr2327903pll.237.1593172243027;
        Fri, 26 Jun 2020 04:50:43 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id m136sm11584572pfd.218.2020.06.26.04.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 04:50:41 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id BD85E40B24; Fri, 26 Jun 2020 11:50:40 +0000 (UTC)
Date:   Fri, 26 Jun 2020 11:50:40 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200626115040.GN13911@42.do-not-panic.com>
References: <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
 <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <feb6a8c4-2b94-3f95-6637-679e089a71ca@de.ibm.com>
 <20200626090001.GA30103@infradead.org>
 <20200626114008.GK4332@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626114008.GK4332@42.do-not-panic.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 11:40:08AM +0000, Luis Chamberlain wrote:
> Andrew, can you please revert these two for now:
> 
> selftests: simplify kmod failure value
> umh: fix processed error when UMH_WAIT_PROC is used
> 
> Later, we'll add Christoph's simplier kernel wait, and make the change
> directly there to catpure the right error. That still won't fix this reported
> issue, but it will be cleaner and will go tested by Christian Borntraeger
> before.

However, note that the only consideration to make here against this
approach of the fix later going in with the simpler kernel wait is
if this actually is fixing a real issue, and if we'd want this going to
stable.

We should for sure revert though, so Andrew please do proceed to revert
or drop those two patches alone for now.

It was unclear to me if this should go to stable given I was not sure
how severe that NFS case mentioned on the commit log was, and no one on
the NFS side has replied about that yet, however there may be other
areas where code inspection of callsites was not sufficient to find the
real critical areas.

I'm now very curious what this issue that Christian with bridge on s390
found will be.

  Luis

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2562620786F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404675AbgFXQJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:09:57 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33302 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404531AbgFXQJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:09:56 -0400
Received: by mail-pf1-f196.google.com with SMTP id f9so1371668pfn.0;
        Wed, 24 Jun 2020 09:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DXTGnqae9YKhKIamwag0tCEqKTyhK0PYwMd2k+8bi0o=;
        b=N0DHoN5nwmmrjTQSrMQ4BuTxEHoelQhjxKyevYv5cNXK+yEYDiHIT2T7Wr1duuXtkn
         XvMYYC8UDsizZ9tQj16XMEy4GFS2Oidih7dXKLawEYXQpbFb8LO6JpkGqkzfIU2vR96c
         pA3e6oLZr/JBCaEjiQOMp/Pmf/bA1PNXTBuQEiSu1iThAK7Nzwx9Cbax0jdoTcZddmtq
         NHcmlK5yruUvCglHiBcFmiq0aKJBODgofP8uYAaEbCFpsuq5RRfP5JYfqmdNfQLj7NDx
         RsdodkiDwc4C/Gr6q8z/RyR40/NFQ/Sddr6Bf2iqRG3oCMDvbs7vcjFkA+2eb8xUfEWU
         GKkQ==
X-Gm-Message-State: AOAM531s/2y96JbeaRwGvvWFd6gzBm7/PZeEh4q3O7XjO04I3Kl2GhhI
        UWmrswJg6hDU9rzfUI4LoRU=
X-Google-Smtp-Source: ABdhPJz7KuHyVq6mrCHaNrsdJ4rdxo9vvtDFtAlwtCcIngaCRJg5DVLieAPvLLlWDXOb7tRXxvQHXg==
X-Received: by 2002:a62:7c49:: with SMTP id x70mr28351238pfc.66.1593014995813;
        Wed, 24 Jun 2020 09:09:55 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id q129sm19485373pfc.60.2020.06.24.09.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:09:54 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 64A8A40430; Wed, 24 Jun 2020 16:09:53 +0000 (UTC)
Date:   Wed, 24 Jun 2020 16:09:53 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>, ast@kernel.org,
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
Message-ID: <20200624160953.GH4332@42.do-not-panic.com>
References: <20200610154923.27510-5-mcgrof@kernel.org>
 <20200623141157.5409-1-borntraeger@de.ibm.com>
 <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
 <20200624144311.GA5839@infradead.org>
 <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 05:54:46PM +0200, Christian Borntraeger wrote:
> 
> 
> On 24.06.20 16:43, Christoph Hellwig wrote:
> > On Wed, Jun 24, 2020 at 01:11:54PM +0200, Christian Borntraeger wrote:
> >> Does anyone have an idea why "umh: fix processed error when UMH_WAIT_PROC is used" breaks the
> >> linux-bridge on s390?
> > 
> > Are we even sure this is s390 specific and doesn't happen on other
> > architectures with the same bridge setup?
> 
> Fair point. AFAIK nobody has tested this yet on x86.

Regardless, can you enable dynamic debug prints, to see if the kernel
reveals anything on the bridge code which may be relevant:

echo "file net/bridge/* +p" > /sys/kernel/debug/dynamic_debug/control

  Luis

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E93420787E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404757AbgFXQNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:13:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36854 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404235AbgFXQNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:13:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so1644502pgh.3;
        Wed, 24 Jun 2020 09:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K5HA5pFN0d7RWrFcMOeZ4eZsZOCwgkaKOKIyoGUunJA=;
        b=bdoNe4HE152P67bqB4iz1TVFpSLKd5OLRNA8ZPD4Nx764LgDhIOQkoCOwpgshVPUlC
         xmAg1IjdbKAPc58tpiZ8kPqndDxtcQp+nCYHryf0E8MEDiKgH67xMVcz0VOB2dfV7Sm6
         SSZylCQCalt5a0mIATsr/DE7qglta/VKXnlUTkoqBpLAaMN00mnqQvEluSEBNwbz+CJ3
         1fOqyTjFmJ7xWRUx0ARAvF9C/YqItCR2X3K96qaqvoIBmg7cw8LJauxlCcvMMIC+vcXl
         GueZuSNQT2PqCZ+Vnlfd+9GaY6WO0xQeVlIrUK+jiz34ZIOzPCztqXShzjbigNDuaHva
         EhKg==
X-Gm-Message-State: AOAM531BWTz6jecWjjEW9ugvC/+O+rhqZas0ZaHsC7I6Ld8MngXestOd
        7YAHw2WExEfmE7ca6pnvb0M=
X-Google-Smtp-Source: ABdhPJxE1ygpkPiPc7c+3/yQpwGQm5PBcnPHrRJMZIslGuNTvYjGLTfGT0VAXd0ojktX0RNgdf5uBw==
X-Received: by 2002:a63:7f5a:: with SMTP id p26mr15162576pgn.117.1593015201848;
        Wed, 24 Jun 2020 09:13:21 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 23sm20626008pfy.199.2020.06.24.09.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:13:20 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B918940430; Wed, 24 Jun 2020 16:13:19 +0000 (UTC)
Date:   Wed, 24 Jun 2020 16:13:19 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Doucha <mdoucha@suse.cz>, hch@infradead.org
Cc:     ast@kernel.org, axboe@kernel.dk, bfields@fieldses.org,
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
Message-ID: <20200624161319.GM13911@42.do-not-panic.com>
References: <20200610154923.27510-5-mcgrof@kernel.org>
 <20200623141157.5409-1-borntraeger@de.ibm.com>
 <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
 <20200624120546.GC4332@42.do-not-panic.com>
 <20200624131725.GL13911@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624131725.GL13911@42.do-not-panic.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 01:17:25PM +0000, Luis Chamberlain wrote:
> I found however an LTP bug indicating the need to test for
> s390 wait macros [0] in light of a recent bug in glibc for s390.
> I am asking for references to that issue given I cannot find
> any mention of this on glibc yet.
> 
> [0] https://github.com/linux-test-project/ltp/issues/605

I looked into this and the bug associated was:

https://sourceware.org/bugzilla/show_bug.cgi?id=19613

The commit in question was upstream glibc commit
b49ab5f4503f36dcbf43f821f817da66b2931fe6 ("Remove union wait [BZ
#19613]"), and while I don't see anything s390 mentioned there,
the issue there was due to the caller of the wait using a long
instead of an int for the return value.

In other words, that'd not the droid we are looking for.

So the issue is something else.

  Luis

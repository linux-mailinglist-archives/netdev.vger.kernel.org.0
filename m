Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0349323F699
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 07:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgHHFpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 01:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgHHFpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 01:45:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 672DF2177B;
        Sat,  8 Aug 2020 05:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596865507;
        bh=A3HzZFYqgjH52azA3Qx3vH1BMJlp4qELJhyhFaQEuJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WbXFGB1tTYMahSa3GxVVjpnLnbAVER98ZqskFruFs8rsn7cohv0dNwmYwNMM3azBj
         9Uh18P2sgXi24Xg89o/swb3Gd5lyBU4G3P7TdSlJ7kVAL5jsQkNqIgxpB6P8ijSzdw
         afULkJcKHPxOkaoSkfAsjN5/cHf59ELpyt0ezBoQ=
Date:   Sat, 8 Aug 2020 07:45:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathan Adams <jwadams@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 3/7] core/metricfs: metric for kernel warnings
Message-ID: <20200808054504.GD1037591@kroah.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-4-jwadams@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807212916.2883031-4-jwadams@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 02:29:12PM -0700, Jonathan Adams wrote:
> Count kernel warnings by function name of the caller.
> 
> Each time WARN() is called, which includes WARN_ON(), increment a counter
> in a 256-entry hash table. The table key is the entry point of the calling
> function, which is found using kallsyms.

Why is this needed?

As systems seem to like to reboot when WARN() is called, will this only
ever show 1?  :)

> 
> We store the name of the function in the table (because it may be a
> module address); reporting the metric just walks the table and prints
> the values.
> 
> The "warnings" metric is cumulative.

If you are creating specific files in a specific location that people
can rely on, shouldn't they show up in Documentation/ABI/ as well?

But again, is this feature something that anyone really needs/wants?
What can the number of warnings show you?

thanks,

greg k-h

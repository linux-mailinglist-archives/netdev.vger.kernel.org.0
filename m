Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE7B29CC87
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 00:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832653AbgJ0XDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 19:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797710AbgJ0XDc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:03:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4234A21707;
        Tue, 27 Oct 2020 23:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603839812;
        bh=VzjPIQGg3mdPytMHbFS/k3SibSi0qEiKyAZGOxyxAUA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mcNDGTHFSVdKw6gWFQRbj9TKIhPLdZj8DvNo/cPpH9lM84fJSZQkZVcb7jAgh6qhW
         hNcYEXxgR/jTooFltUW3g7IoHsocZCdwKzBipvNEJDyz4Sw9j2EHZadOvtNaJvRCJ/
         jQYN8Row2hOvh1HeLpJKYEZzqCmqPC7bhRkUy69Y=
Date:   Tue, 27 Oct 2020 16:03:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: checkpatch.pl broke in net-next
Message-ID: <20201027160331.05677f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e8ea2204-b74a-3b75-c257-0f8acbb916a6@intel.com>
References: <e8ea2204-b74a-3b75-c257-0f8acbb916a6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 15:56:35 -0700 Jacob Keller wrote:
> Hi Jakub,
> 
> It looks like net-next just pulled in a change to checkpatch.pl which
> causes it to break:
> 
> $ ./scripts/checkpatch.pl
> Global symbol "$gitroot" requires explicit package name (did you forget
> to declare "my $gitroot"?) at ./scripts/checkpatch.pl line 980.
> Execution of ./scripts/checkpatch.pl aborted due to compilation errors.
> ERROR: checkpatch.pl failed: 255
> 
> It is caused by commit f5f613259f3f ("checkpatch: allow not using -f
> with files that are in git"), which appears to make use of "$gitroot".
> 
> This variable doesn't exist, so of course the perl script breaks.
> 
> This commit appears in Linus' tree, and must have been picked up when we
> merged with his tree.
> 
> This issue is fixed by 0f7f635b0648 ("checkpatch: enable GIT_DIR
> environment use to set git repository location") which is the commit
> that actually introduces $gitroot.
> 
> Any chance we can get this merged into net-next? It has broken our
> automation that runs checkpatch.pl

That and kvm broke the 32 bit x86 build :/

I will submit net to Linus on Thu, and pull back from him to net and
net-next. That'll fix it.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF4D23D300
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHEU2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:28:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:32890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbgHEU17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Aug 2020 16:27:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5B102ABF1;
        Wed,  5 Aug 2020 20:28:14 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4D6366075E; Wed,  5 Aug 2020 22:27:57 +0200 (CEST)
Date:   Wed, 5 Aug 2020 22:27:57 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Lars Wendler <polynomial-c@gentoo.org>
Cc:     netdev@vger.kernel.org
Subject: Re: ethtool-5.8: test-driver uses bashisms
Message-ID: <20200805202757.qs2kvtwkh5x4j52w@lion.mk-sys.cz>
References: <20200805084606.0593491a@abudhabi.paradoxon.rec>
 <20200805110330.hb2lgm6vxdwlxnlw@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805110330.hb2lgm6vxdwlxnlw@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 01:03:30PM +0200, Michal Kubecek wrote:
> On Wed, Aug 05, 2020 at 08:46:06AM +0200, Lars Wendler wrote:
> > Hi Michal,
> > 
> > I hope you are the right person to reach out for this matter.
> > 
> > Running the test-driver script from ethtool-5.8 release with /bin/dash
> > results in an endless loop that constantly emits the following two
> > lines:
> > 
> >   ./test-driver: 62: [: --test-name: unexpected operator
> >   ./test-driver: 78: [[: not found
> > 
> > This is because the script contains two bashisms which make the while
> > loop to never exit when the script is not being run with a shell that
> > knows about these bash extensions.
> > 
> > The attached patch fixes this.
> 
> This is really unfortunate. The problem is that this script is not part
> of ethtool codebase, it is copied from automake installation instead.
> In this case, the script using [[...]] comes from automake 1.15 (which
> I have on my development system).
> 
> AFAICS automake 1.16 has a newer version of test-driver script and the
> main difference is the use of [...] tests instead of [[...]]. I'll
> update automake on my development machine and open a bug to backport the
> change to openSUSE Leap 15.2 package to prevent repeating this problem.

Correction: upstream automake has a version of the script which does not
use bash specific constructions ("==" and "[[ ... ]]"). These come from
a distribution patch introduced in openSUSE Leap 15.1 and 15.2 package
to fix command line argument handling. openSUSE Tumbleweed has fixed
version of the script which uses universal "=" and "[ ... ]".

Michal

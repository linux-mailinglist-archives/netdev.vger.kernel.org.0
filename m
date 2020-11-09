Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF82AC341
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729904AbgKISJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729247AbgKISJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:09:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D92DF20678;
        Mon,  9 Nov 2020 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604945353;
        bh=JU34YanRQ67wdNLNcG1HyaIGvC4Hvn9BN1r19BodjUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fmQaKGHZHjq7wNC0q47GooBDjXBM7yHd2ivf4TMaq4JvcqepRbx15j+7TSpVuGEiQ
         x1fUsJrk0KtHo/jd4cbztN7OOvfkx0+AxXIE16Ig4rIYaeNm3Kz6yHJlyUz1VZ68VL
         XyMnngEleioqfNRjZLG2RihZx0kEn+d1ZNibDNVA=
Date:   Mon, 9 Nov 2020 10:09:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 2/2] selftests: pmtu.sh: improve the test result
 processing
Message-ID: <20201109100911.28afc390@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMy_GT-Hsj7GmHKBb9Ztvsisrujud1C=E+sKE1TfHDsszwpMXA@mail.gmail.com>
References: <20201105105051.64258-1-po-hsu.lin@canonical.com>
        <20201105105051.64258-3-po-hsu.lin@canonical.com>
        <20201107150200.509523e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMy_GT-Hsj7GmHKBb9Ztvsisrujud1C=E+sKE1TfHDsszwpMXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:42:33 +0800 Po-Hsu Lin wrote:
> On Sun, Nov 8, 2020 at 7:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu,  5 Nov 2020 18:50:51 +0800 Po-Hsu Lin wrote:  
> > > This test will treat all non-zero return codes as failures, it will
> > > make the pmtu.sh test script being marked as FAILED when some
> > > sub-test got skipped.
> > >
> > > Improve the result processing by
> > >   * Only mark the whole test script as SKIP when all of the
> > >     sub-tests were skipped
> > >   * If the sub-tests were either passed or skipped, the overall
> > >     result will be PASS
> > >   * If any of them has failed, the overall result will be FAIL
> > >   * Treat other return codes (e.g. 127 for command not found) as FAIL
> > >
> > > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>  
> >
> > Patch 1 looks like a cleanup while patch 2 is more of a fix, can we
> > separate the two and apply the former to -next and latter to 5.10?
> > They shouldn't conflict, right?
> >  
> 
> Hello Jakub,
> 
> Yes the first patch is just changing return code to $ksft_skip, the
> real fix is the second one. However the second patch was based on the
> first one, if we want to apply them separately we might need to change
> this $ksft_skip handling part in the second patch.

Ah, I misread the situation, ksft_skip is 4, not 2, so the patch is
more than just refactoring.

> What should I do to deal with this?
> Resend the former for -next and rebase + resend the latter (plus the
> fix to remove case 1) for 5.10 without the former patch?

Let's apply both of the patches to net-next if that's fine with you.
Indeed detangling them is may be more effort that it's worth.

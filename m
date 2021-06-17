Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927F93ABDEA
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhFQVYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:24:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbhFQVYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 17:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D22846135C;
        Thu, 17 Jun 2021 21:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623964955;
        bh=1Fym0fyr0D3LMEgt/63WVQ2P9C0SYHdU94AtWdhAqI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IaCohyAg47/bBnePQ7x2PkrwTXlNfSCoFRvJPhg4gnM2Ds9bKdaY+EB5x/1ExYoWn
         NYTQPWWoirOM99KBEzALrRJlCai6cTH0Po5z20FtFjW4yeSr2EqxUTLEl3WFaKawR/
         AAUMve0hRj4erCP5I0I3y4PRP5WNP119Fefsk88OcA2cDusrflLtTD0Xyr2vjJKYAn
         o2yY3KTU1AZd26mot4MTxIsdhITKtAIeC3qq1bo1kp5swJoC0ZwC5gYpYmkH3kvbNo
         q8uNjjiG9LEsO+E1cYBazo01/zDvvx6ZXGPjX6W7yaAJ+AnCAbMdbocgp8gBBoImdv
         gZBZ2G/Tx2H0Q==
Date:   Thu, 17 Jun 2021 14:22:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     Pooja Trivedi <pooja.trivedi@stackpath.com>,
        Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>,
        Josh Tway <josh.tway@stackpath.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: Hangs during tls multi_chunk_sendfile selftest
Message-ID: <20210617142234.272cc686@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YMumgy19CXCk5rZD@ubuntu-x1>
References: <YMumgy19CXCk5rZD@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021 14:46:11 -0500 Seth Forshee wrote:
> I've observed that the tls multi_chunk_sendfile selftest hangs during
> recv() and ultimately times out, and it seems to have done so even when
> the test was first introduced. 

It hangs yet it passes? I lost track of this issue because the test
does pass on my system:

# PASSED: 183 / 183 tests passed.
# Totals: pass:183 fail:0 xfail:0 xpass:0 skip:0 error:0

$ uname -r
5.12.9-300.fc34.x86_64

> Reading through the commit message when
> it was added (0e6fbe39bdf7 "net/tls(TLS_SW): Add selftest for 'chunked'
> sendfile test") I get the impression that the test is meant to
> demonstrate a problem with ktls, but there's no indication that the
> problem has been fixed.

Yeah, the fix was discussed here:

https://lore.kernel.org/netdev/1591392508-14592-1-git-send-email-pooja.trivedi@stackpath.com/

IDK why it stalled to be honest :S

> Am I right that the expectation is that this test will fail? If that's
> the case, shouldn't this test be removed until the problem is fixed?


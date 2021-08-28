Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDFA13FA276
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 02:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbhH1Aj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 20:39:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232503AbhH1Aj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 20:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A88A60ED5;
        Sat, 28 Aug 2021 00:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630111147;
        bh=hUyKc9PjsOxHbH/8M6ZTuunVCFg2yyTx+KxHb0zOhRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hPMJm9Z5asUgL8RcxmiLgcWqs7pHFajABK0IRvvyvx+hV6JaEdwcGx1QrwDEMFnXF
         45V+wa6VsBOoartgtpDgAqpEh29xPPi01SmKy0jfStZp9i0eYY3E0Gca5EJID0qaKi
         G8l3ZIffnd+ORlLUmnYWJTOoSQySQNMtSiZGZMjtB6tLLwBN2LVX9hya9zQGoVdGFn
         9r6w8HZz2MeajOYMmX75JlcdvUtinkvXV5ybXQjr2p+e9AtK0wwkwGrRiuo4hXC0wm
         OiISbqDOeYVmOOrt1vaPnJUh8y7CaoJb1SCYFUrNPwj3xo+ce/AUNCqmRrWrJ1d9Sv
         kJTNTXT5/+hew==
Date:   Fri, 27 Aug 2021 17:39:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jtoppins@redhat.com
Subject: Re: [PATCH net-next 4/6] ionic: add queue lock around open and stop
Message-ID: <20210827173906.1aa14274@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210827185512.50206-5-snelson@pensando.io>
References: <20210827185512.50206-1-snelson@pensando.io>
        <20210827185512.50206-5-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 11:55:10 -0700 Shannon Nelson wrote:
> Add the queue configuration lock to ionic_open() and
> ionic_stop() so that they don't collide with other in parallel
> queue configuration actions such as MTU changes as can be
> demonstrated with a tight loop of ifup/change-mtu/ifdown.

Say more? how are up/down/change mtu not under rtnl_lock?

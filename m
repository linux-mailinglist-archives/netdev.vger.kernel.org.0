Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A216731027E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 02:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhBEB5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 20:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhBEB5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 20:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D19C264DC4;
        Fri,  5 Feb 2021 01:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612490190;
        bh=ZlbTbixiZ/VEvhe2cB1BDy9leTlPGZZcyvIJqx6f2UI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tu6SJbXUsHBFLZamGifs83f3CijLyOjFBee5L2c4iFeuoBlcqfKvKIhvZc3L22Z+R
         tj4OtzBNvXCd1gkay1lHs/nd57rPGEKXSgmcitvQJXpqPVESKx7TaT9aWCvHxfyh2C
         OyTPEq5RzCUwfuqgsZjB9f7ng3IutikF/4Ce+tym0NfiWfuPmmdETry1Hco4C8u2kN
         1Z+wjDtqiMrg0kz/fDOSsnZ/MxzHEO6WHMBtOinAwVe5DoAXBo6xc6PbgQAIbqFkGv
         VhYGfuPZusMTknZUlZiZpuAFqgJZPFbNt3gXaqN1e+SUFquG0GafJv6BIFuRLsnot2
         BkL2UbiwyKmNQ==
Date:   Thu, 4 Feb 2021 17:56:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Druzhinin <igor.druzhinin@citrix.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/netback: avoid race in
 xenvif_rx_ring_slots_available()
Message-ID: <20210204175628.7904d1da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f6fa1533-0646-e8b1-b7f8-51ad70691cae@suse.com>
References: <20210202070938.7863-1-jgross@suse.com>
        <20210203154800.4c6959d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f6fa1533-0646-e8b1-b7f8-51ad70691cae@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Feb 2021 06:32:32 +0100 J=C3=BCrgen Gro=C3=9F wrote:
> On 04.02.21 00:48, Jakub Kicinski wrote:
> > On Tue,  2 Feb 2021 08:09:38 +0100 Juergen Gross wrote: =20
> >> Since commit 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> >> xenvif_rx_ring_slots_available() is no longer called only from the rx
> >> queue kernel thread, so it needs to access the rx queue with the
> >> associated queue held.
> >>
> >> Reported-by: Igor Druzhinin <igor.druzhinin@citrix.com>
> >> Fixes: 23025393dbeb3b8b3 ("xen/netback: use lateeoi irq binding")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Juergen Gross <jgross@suse.com> =20
> >=20
> > Should we route this change via networking trees? I see the bug did not
> > go through networking :)
>=20
> I'm fine with either networking or the Xen tree. It should be included
> in 5.11, though. So if you are willing to take it, please do so.

All right, applied to net, it'll most likely hit Linus's tree on Tue.

Thanks!

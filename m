Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42F9C372052
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 21:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhECTXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 15:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhECTXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 15:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C22F6115C;
        Mon,  3 May 2021 19:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620069763;
        bh=LsVduj1udqV2S4PEgaMy9OmXq3kay7NOBWsuekpxuiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V8Jhvent53avomW+oinAIPJFHvsfHMoeSletWOrCj/2BA2L8Z2rHadu9HMvoj/s5D
         c47VyRtJXJ51gHBVDot6L/bS8VNzrnPa4e4ymVYfyB/waZz/WmUqN7ORup6D6REB67
         3xUb4OqNEDs5dHNDknQpoqgk5abTH/sThSkPWDYRSIiSFpkIM0xPsglzNmb3AqVY1L
         65xofu8wAIny3GRvmMeXpXlt3ymRgf7oW8geBOKkGzSPrZtM6mkqb4BBk9/WG+RFHO
         HSMDzgYan1pzPIukwbxiIoiZLiLHxGSBA9Vw2V/l5QQiL+nx+LXtqlI1w1KdBxq2yu
         nKLBKdbRKCIlA==
Date:   Mon, 3 May 2021 12:22:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when
 printing stats
Message-ID: <20210503122242.6ae77bde@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <be91d0cd-6233-3c8d-e310-a1b7fc842b48@gmail.com>
References: <20210501031059.529906-1-kuba@kernel.org>
        <20210503075739.46654252@hermes.local>
        <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <be91d0cd-6233-3c8d-e310-a1b7fc842b48@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 May 2021 11:16:41 -0600 David Ahern wrote:
> On 5/3/21 10:00 AM, Jakub Kicinski wrote:
> > On Mon, 3 May 2021 07:57:39 -0700 Stephen Hemminger wrote: =20
> >> Maybe good time to refactor the code to make it table driven rather
> >> than individual statistic items. =20
> >=20
> > =F0=9F=A4=94 should be doable.
> >=20
> > Can I do it on top or before making the change to the columns?
> >  =20
>=20
> I think it can be a follow on change. This one is clearly an improvement
> for large numbers.

Fun little discrepancy b/w JSON and plain on what's printed with -s=20
vs -s -s: JSON output prints rx_over_errors where plain would print
rx_missed_errors. I will change plain to follow JSON, since presumably
we should worry more about breaking machine-readable format.

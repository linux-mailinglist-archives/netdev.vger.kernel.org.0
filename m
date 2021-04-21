Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0485F367300
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbhDUTAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:00:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239751AbhDUTA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AE7B613C2;
        Wed, 21 Apr 2021 18:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619031596;
        bh=gQunZs/Jd08QKnCkcqATmO3SDLCGeHBESlrKBcpXRMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c2C8eK7qcG2gd+O/gg5HMasqXmgS4LEbXdS7pWF8L0AAJt/L9fDuaQk0tgvwsNj4k
         MDdFceIxq6s1Ol1hhrdkfLpGhlIY0aXQze3Q7CcQC1arlcXgZxNUSz8aWIbmmh1iWy
         kao524K5xbdhnXcScTq2PJSQEpVlxr0SBlTstw6plxlRSt/3Z1WKV3l5Qn1MxVEMWk
         pp+zU++A9TtkKw98v+Gp7A0z/9sBoV6lg1r4vqtsx4eZOneSXW2QscAsXpaETPrs92
         0jv1vvsoiyjOmGkpgVvImgs9RJPCgkFTWYE/Yz0N2RbHjCTPyYQ20qkbuhyv27h3Zf
         F7q8stkuzpnKQ==
Date:   Wed, 21 Apr 2021 11:59:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Linkin <dlinkin@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>
Subject: Re: [PATCH net-next 00/18] devlink: rate objects API
Message-ID: <20210421115955.5c7fee82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <97442589-c504-d997-52fb-edc0bdf1cbe5@nvidia.com>
References: <1618918434-25520-1-git-send-email-dlinkin@nvidia.com>
        <20210420133529.4904f08b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <97442589-c504-d997-52fb-edc0bdf1cbe5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 15:08:07 +0300 Dmytro Linkin wrote:
> On 4/20/21 11:35 PM, Jakub Kicinski wrote:
> > On Tue, 20 Apr 2021 14:33:36 +0300 dlinkin@nvidia.com wrote:  
> >> From: Dmytro Linkin <dlinkin@nvidia.com>
> >>
> >> Currently kernel provides a way to change tx rate of single VF in
> >> switchdev mode via tc-police action. When lots of VFs are configured
> >> management of theirs rates becomes non-trivial task and some grouping
> >> mechanism is required. Implementing such grouping in tc-police will bring
> >> flow related limitations and unwanted complications, like:
> >> - flows requires net device to be placed on  
> > 
> > Meaning they are only usable in "switchdev mode"?  
> 
> Meaning, "groups" wouldn't have corresponding net devices and needs
> somehow to deal with that. I'll rephrase this line.

But you can share a police action across netdevs. A deeper analysis of
the capabilities of the current subsystem would be appreciated before
we commit to this (less expressive) implementation.

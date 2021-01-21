Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984AA2FF219
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbhAURhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbhAURgr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:36:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57BCA2054F;
        Thu, 21 Jan 2021 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611250566;
        bh=SUbWJDdhLU+zgtx+i13XPDuCNeODLoi77HPQQbQIw88=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hKkYQgi1CgxRQUDimf1IvLf9etZnXlzqVJpbk5gaWg9WYkq2deS4zy+VA9/0Gmlt7
         hJtl1Qop9Oy8h+zDcmLbFbH/uUzryaDBs1uDi01WAfPc2f+sXJte7UzHnTDojIHgO2
         IPzWgPrv4S6MZoPBnQCKDKIlpWZYQINzQE6MlvJ2rtGLRusxEodGhBdNkbNaW+6SPq
         o4tS2ECBH2rtA65CfmDwe/w4U4/YpdegXQLesMcjorUaZ1Ba8ps0dHCRUSj2l+rriN
         8/LDsbOIW9UgQUVSGKT0hDsEPekC2Xq8Yz3J/NUm4QMQNSxwkLutEqv9HGMPXm7LL9
         X2o7P/Cq2yHTg==
Date:   Thu, 21 Jan 2021 09:36:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210121093605.49ba26ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121122152.GA2647590@shredder.lan>
References: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
        <20210121122152.GA2647590@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:
> On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:
> > Add new trap action HARD_DROP, which can be used by the
> > drivers to register traps, where it's impossible to get
> > packet reported to the devlink subsystem by the device
> > driver, because it's impossible to retrieve dropped packet
> > from the device itself.
> > In order to use this action, driver must also register
> > additional devlink operation - callback that is used
> > to retrieve number of packets that have been dropped by
> > the device.  
> 
> Are these global statistics about number of packets the hardware dropped
> for a specific reason or are these per-port statistics?
> 
> It's a creative use of devlink-trap interface, but I think it makes
> sense. Better to re-use an existing interface than creating yet another
> one.

Not sure if I agree, if we can't trap why is it a trap?
It's just a counter.

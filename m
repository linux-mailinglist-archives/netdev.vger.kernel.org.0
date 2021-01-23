Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D0A301812
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 20:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbhAWT4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 14:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAWT4J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 14:56:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3D622D2B;
        Sat, 23 Jan 2021 19:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611431728;
        bh=F2M5rbHYFfwQJlr07rGv5hzc3Gc6J+rEZwivsuEg9U0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GcDvmRWB92tQu40Xl1JlETaYj/I/RhPtpmn6QQ4wH4aC9WrW5trbrtuwFZGHFh/OC
         Hbe0+lyvjzMltF3EGHJnv9o6AEwRqlJrPCDCH9IS0OAZVPngNLmO2n3Ivftj2HVaG+
         q8jDrstID/MzAUut9WzXcgO1rYoeVZ+Xwfl1gS4Vj9mZG6Qz6ZFnxKEEvVKwqIbchI
         97Ut4tdeqsYTrD9J+lhs67qpU0n2GQ/Jefg51h8QP4+6yMWMmmjL+vkSjPOPZeLOsT
         rLA7zd20LjZYicmIl1Tpzs7d6pbGd1Fi24KKLMyYAEaZ0WcQJ2LeWVnudycc4VAqk8
         D4+5GhLkIRtDg==
Date:   Sat, 23 Jan 2021 11:55:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlxsw: Add support for RED qevent "mark"
Message-ID: <20210123115527.58d0f04c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123152802.GA2799851@shredder.lan>
References: <20210117080223.2107288-1-idosch@idosch.org>
        <20210119142255.1caca7fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210120091437.GA2591869@shredder.lan>
        <20210120164508.6009dbbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210121102318.GA2637214@shredder.lan>
        <20210121091940.5101388a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123152802.GA2799851@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 17:28:02 +0200 Ido Schimmel wrote:
> > Thanks for the explanation. I feel more and more convinced now that
> > we should have TC_ACT_TRAP_MIRROR and the devlink trap should only 
> > be on/off :S Current model of "if ACT_TRAP consult devlink for trap
> > configuration" is impossible to model in SW since it doesn't have a
> > equivalent of devlink traps. Or we need that equivalent..  
> 
> Wait, the current model is not "if ACT_TRAP consult devlink for trap
> configuration". 'ecn_mark' action is always 'trap' ('mirror' in v2) and
> can't be changed. Such packets can always be sent to the CPU, but the
> decision of whether to send them or not is based on the presence of tc
> filters attached to RED's 'mark' qevent with TC_ACT_TRAP
> (TC_ACT_TRAP_MIRROR in v2).

I see, missed that, but I think my point conceptually stands, right?
Part of forwarding behavior was (in v1) only expressed in control 
plane (devlink) not dataplane (tc).
 
> I believe that with the proposed changes in v2 it should be perfectly
> clear that ECN marked packets are forwarded in hardware and a copy is
> sent to the CPU.

Yup, sounds good.

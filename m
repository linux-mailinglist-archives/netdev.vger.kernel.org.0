Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F47528EDF5
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 09:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgJOHzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 03:55:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35864 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgJOHzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 03:55:20 -0400
Date:   Thu, 15 Oct 2020 09:55:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602748518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zvhqtU3ayUDQYTeu5jF8llz2q9mrVN3EW1LSPsnC2Rg=;
        b=kMqfcvPEu2jo1yWHbVz3u9CS3bOY62LtJO15umwZjtBHyCCnE/31kOjXWcAdb6GQcoR3fY
        FaGFOk8CBpdWZBj+rPk06ome3/7mzQOixWuAJhCjr3s5eZPvA6zccLAg81zaynn1N9k2eM
        JybNnSEHpvIAxtxivnFeqZ3H0ShVdOmIq9yY+fWJd2rPBfx7XjOLh3PAryew1pFmipfBf2
        4vKG+NJzwqNhAlnIBY77ZlO664DjXtGicaYPlLh1btcnK6M2hj40q5WogtYAOofPMfNxfF
        XDJ+EtdamYoK7heB7ckU2DH7k4/FT+omIIntQzha3WeHZrUfqnaYsQgCPBOrPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602748518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zvhqtU3ayUDQYTeu5jF8llz2q9mrVN3EW1LSPsnC2Rg=;
        b=soIAEHtiduEyw01FBMH40GVYweHIwGwt++Zbmw62OFertOiAIc2F8gx3/olt0MqihMq2gL
        Fc94oOPNECLjgXDA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        kuba@kernel.org, pabeni@redhat.com, pshelar@ovn.org,
        jlelli@redhat.com
Subject: Re: [PATCH net-next] net: openvswitch: fix to make sure
 flow_lookup() is not preempted
Message-ID: <20201015075517.gjsebwhqznj6ypm3@linutronix.de>
References: <160259304349.181017.7492443293310262978.stgit@ebuild>
 <20201013125307.ugz4nvjvyxrfhi6n@linutronix.de>
 <3D834ADB-09E7-4E28-B62F-CB6281987E41@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3D834ADB-09E7-4E28-B62F-CB6281987E41@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-14 12:44:23 [+0200], Eelco Chaudron wrote:
> Let me know your thoughts.

better. If your seccount is per-CPU then you get away without explicit
writer locking if you rely on global per-CPU locking. You can't do
preempt_disable() because this section can be interrupt by softirq. You
need something stronger :)

Side note: Adding a fixes tag and net-next looks like "stable material
starting next merge window".

> Thanks,
> 
> Eelco

Sebastian

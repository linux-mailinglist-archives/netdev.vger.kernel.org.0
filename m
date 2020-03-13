Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B41183FFE
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 05:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCMEQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 00:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgCMEQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 00:16:13 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E4572072F;
        Fri, 13 Mar 2020 04:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584072972;
        bh=0rKhpWXnndfRsPWbZv5df9IRif+c//lNMSnPbfg8XNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ukDwq0k0g1jiqeRgJ5KrIuwf87w80m7uhxwQ5JEJJZWHgPr3tCYdBukncSKhEXB1g
         +q5oVJkr/UEw4nmJEM581MP7Kh+2RO0ZA6WrI3ZEg6Q8LOUeb1EiRn9+mdbwcp8VL3
         4ie2dZE4dQ8tTsEpqShug83CGt5fCJtTcTvoMKq4=
Date:   Thu, 12 Mar 2020 21:16:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v4 2/6] net: sched: Allow extending set of
 supported RED flags
Message-ID: <20200312211610.27883dfc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200312231100.37180-3-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
        <20200312231100.37180-3-petrm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 01:10:56 +0200 Petr Machata wrote:
> The qdiscs RED, GRED, SFQ and CHOKE use different subsets of the same pool
> of global RED flags. These are passed in tc_red_qopt.flags. However none of
> these qdiscs validate the flag field, and just copy it over wholesale to
> internal structures, and later dump it back. (An exception is GRED, which
> does validate for VQs -- however not for the main setup.)
> 
> A broken userspace can therefore configure a qdisc with arbitrary
> unsupported flags, and later expect to see the flags on qdisc dump. The
> current ABI therefore allows storage of several bits of custom data to
> qdisc instances of the types mentioned above. How many bits, depends on
> which flags are meaningful for the qdisc in question. E.g. SFQ recognizes
> flags ECN and HARDDROP, and the rest is not interpreted.
> 
> If SFQ ever needs to support ADAPTATIVE, it needs another way of doing it,
> and at the same time it needs to retain the possibility to store 6 bits of
> uninterpreted data. Likewise RED, which adds a new flag later in this
> patchset.
> 
> To that end, this patch adds a new function, red_get_flags(), to split the
> passed flags of RED-like qdiscs to flags and user bits, and
> red_validate_flags() to validate the resulting configuration. It further
> adds a new attribute, TCA_RED_FLAGS, to pass arbitrary flags.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

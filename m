Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99926CE93
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 00:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgIPWT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 18:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgIPWTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 18:19:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C3EC061221
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 15:19:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 843C413608519;
        Wed, 16 Sep 2020 15:03:07 -0700 (PDT)
Date:   Wed, 16 Sep 2020 15:19:53 -0700 (PDT)
Message-Id: <20200916.151953.971004880688415778.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 00/15] mlxsw: Refactor headroom management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916063528.116624-1-idosch@idosch.org>
References: <20200916063528.116624-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 15:03:07 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 16 Sep 2020 09:35:13 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> On Spectrum, port buffers, also called port headroom, is where packets are
> stored while they are parsed and the forwarding decision is being made. For
> lossless traffic flows, in case shared buffer admission is not allowed,
> headroom is also where to put the extra traffic received before the sent
> PAUSE takes effect. Another aspect of the port headroom is the so called
> internal buffer, which is used for egress mirroring.
> 
> Linux supports two DCB interfaces related to the headroom: dcbnl_setbuffer
> for configuration, and dcbnl_getbuffer for inspection. In order to make it
> possible to implement these interfaces, it is first necessary to clean up
> headroom handling, which is currently strewn in several places in the
> driver.
> 
> The end goal is an architecture whereby it is possible to take a copy of
> the current configuration, adjust parameters, and then hand the proposed
> configuration over to the system to implement it. When everything works,
> the proposed configuration is accepted and saved. First, this centralizes
> the reconfiguration handling to one function, which takes care of
> coordinating buffer size changes and priority map changes to avoid
> introducing drops. Second, the fact that the configuration is all in one
> place makes it easy to keep a backup and handle error path rollbacks, which
> were previously hard to understand.
 ...

Series applied, thank you.

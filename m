Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8212F1EE
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 00:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgABXvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 18:51:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgABXvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 18:51:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E9BD61570ADEF;
        Thu,  2 Jan 2020 15:51:48 -0800 (PST)
Date:   Thu, 02 Jan 2020 15:51:48 -0800 (PST)
Message-Id: <20200102.155148.1732235071668848764.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, roopa@cumulusnetworks.com,
        sharpd@cumulusnetworks.com, dsahern@gmail.com
Subject: Re: [PATCH net-next 0/9] tcp: Add support for L3 domains to MD5
 auth
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191230221433.2717-1-dsahern@kernel.org>
References: <20191230221433.2717-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 02 Jan 2020 15:51:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 30 Dec 2019 14:14:24 -0800

> With VRF, the scope of network addresses is limited to the L3 domain
> the device is associated. MD5 keys are based on addresses, so proper
> VRF support requires an L3 domain to be considered for the lookups.
> 
> Leverage the new TCP_MD5SIG_EXT option to add support for a device index
> to MD5 keys. The __tcpm_pad entry in tcp_md5sig is renamed to tcpm_ifindex
> and a new flag, TCP_MD5SIG_FLAG_IFINDEX, in tcpm_flags determines if the
> entry is examined. This follows what was done for MD5 and prefixes with
> commits
>    8917a777be3b ("tcp: md5: add TCP_MD5SIG_EXT socket option to set a key address prefix")
>    6797318e623d ("tcp: md5: add an address prefix for key lookup")
> 
> Handling both a device AND L3 domain is much more complicated for the
> response paths. This set focuses only on L3 support - requiring the
> device index to be an l3mdev (ie, VRF). Support for slave devices can
> be added later if desired, much like the progression of support for
> sockets bound to a VRF and then bound to a device in a VRF. Kernel
> code is setup to explicitly call out that current lookup is for an L3
> index, while the uapi just references a device index allowing its
> meaning to include other devices in the future.

Really nice work David, series applied to net-next.

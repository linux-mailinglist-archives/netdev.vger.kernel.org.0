Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7674A22FEA9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG1A6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgG1A6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 20:58:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D88920809;
        Tue, 28 Jul 2020 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595897884;
        bh=XItDeRD/VOW0c0vh0gxeveqgJidWpf1z1F08rUsRr68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q55qY5hjfzZsvbLN/ssXqZAh3kShL5ptHB9qO5ASSnpIKkVFcshi6+1XNovoXyEWa
         y/BYih70ZzEd+GLlAGHC9I6cRxXz+ru6FpKJLC7T22a8Id9Oz8UIo6H9fpw5IV7ZTJ
         hRUs4I1367VD5/Yu8gDfT6dsmBpypJ8gPC9RYq7E=
Date:   Mon, 27 Jul 2020 17:58:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1595847753-2234-2-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jul 2020 14:02:21 +0300 Moshe Shemesh wrote:
> Add devlink reload level to allow the user to request a specific reload
> level. The level parameter is optional, if not specified then driver's
> default reload level is used (backward compatible).

Please don't leave space for driver-specific behavior. The OS is
supposed to abstract device differences away.

Previously the purpose of reload was to activate new devlink params
(with driverinit cmode), now you want the ability to activate new
firmware. Let users specify their intent and their constraints.

> Reload levels supported are:
> driver: driver entities re-instantiation only.
> fw_reset: firmware reset and driver entities re-instantiation.
> fw_live_patch: firmware live patching only.

I'm concerned live_patch is not first - it's the lowest impact (since
it's live). Please make sure you clearly specify the expected behavior
for the new API.

The notion of multi-host is key for live patching, so it has to be
mentioned.

> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

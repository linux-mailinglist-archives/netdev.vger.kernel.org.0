Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35AC251C9C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHYPuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:50:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHYPuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 11:50:02 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 510962067C;
        Tue, 25 Aug 2020 15:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598370601;
        bh=UBQkGDNOfaRVuEktXkbev8DMv/HonOZAncNi/Su6pb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bwXPXqtqKUNdKaX3QuBXGMUOb9qVZmtIjvkM/U/1G6x8gKzjJFldWZstbSQlQwGj2
         gIIe78E2g33L59zkaYfxjrdvyBWtZJNeSZ570wFBVVzlHVGt9VDIJr5Q6kaA/As0wa
         va7uHCyCZd3eg7d3mQMEj3znyRqfZhKiEaSCM6Fo=
Date:   Tue, 25 Aug 2020 08:49:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        netdev@vger.kernel.org, maciej.fijalkowski@intel.com,
        piotr.raczynski@intel.com, maciej.machnikowski@intel.com,
        lirongqing@baidu.com
Subject: Re: [PATCH net v2 3/3] ice: avoid premature Rx buffer reuse
Message-ID: <20200825084959.69e0bb0d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200825121323.20239-4-bjorn.topel@gmail.com>
References: <20200825121323.20239-1-bjorn.topel@gmail.com>
        <20200825121323.20239-4-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 14:13:23 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> The page recycle code, incorrectly, relied on that a page fragment
> could not be freed inside xdp_do_redirect(). This assumption leads to
> that page fragments that are used by the stack/XDP redirect can be
> reused and overwritten.
>=20
> To avoid this, store the page count prior invoking xdp_do_redirect().
>=20
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Gotta adjust the kdoc:

drivers/net/ethernet/intel/ice/ice_txrx.c:773: warning: Function parameter =
or member 'rx_buf_pgcnt' not described in 'ice_can_reuse_rx_page'
drivers/net/ethernet/intel/ice/ice_txrx.c:885: warning: Function parameter =
or member 'rx_buf_pgcnt' not described in 'ice_get_rx_buf'
drivers/net/ethernet/intel/ice/ice_txrx.c:1033: warning: Function parameter=
 or member 'rx_buf_pgcnt' not described in 'ice_put_rx_buf'

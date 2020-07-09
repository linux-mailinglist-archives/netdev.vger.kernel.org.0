Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12FC21A95D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgGIUwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgGIUwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 16:52:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2784220672;
        Thu,  9 Jul 2020 20:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594327920;
        bh=pypqqmtfXxmTAb4faWeQqNr+f2ItwATRuhxt47pyXOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VosFc0W0TeXemwpxHtlihH1qz99e3CHFkp7+8rdrEl944xh0U3lKsc+ulJWrbJk+Q
         +QMZ0e9+Cpl19AuMK/bRLpA8TJGQJHRtag3hK1RwKoE8kwQuxA7OSXEjbA8dUhGbjF
         2eAzkc+tSI6CM8bYdy4mdNpjir+AmAj+4cJZjTH8=
Date:   Thu, 9 Jul 2020 13:51:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, edwin.peer@broadcom.com,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 00/10] udp_tunnel: add NIC RX port offload
 infrastructure
Message-ID: <20200709135158.5567f476@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709.112346.2015479962285681249.davem@davemloft.net>
References: <20200709011814.4003186-1-kuba@kernel.org>
        <20200709.112346.2015479962285681249.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Jul 2020 11:23:46 -0700 (PDT) David Miller wrote:
> Looks like we get a build failure if IPV4=n and ETHTOOL_NL=y because
> the code unconditionally references the udp tunnel ops from the
> ethtool tunnel stuff.

I see :S 

I think I'll cut out the entire ETHTOOL_MSG_TUNNEL_INFO_GET support if
IPv4=n, theoretically there could be an non-IP tunnel info we want to
report, but we can deal with that (unlikely) case later.

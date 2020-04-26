Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B221B8AF6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 04:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgDZCIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 22:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726087AbgDZCIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 22:08:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C37CC061A0C
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 19:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=PB8a/c7q01gY2pCBrQz2bwdWS13WIgtrv57ehO0yiy4=; b=YFEjbxqi0xZAlSTtFoUvoGzhZA
        hzsWhskxGlUItu0intuYagrCtXX3yJyDYqbkZ7i/k22sEqBvIbj7EHeUervZJ8C8wj2KJHIEC43h7
        QkkviS6t8ZLE4sJUAze3Ybvs6TJ53W/+osEYLQMEq21v24TpT1c0XCzgbmunNBi1i6S5HU4P4aG5K
        8OsSO52SNUNM2DW5MIlq9gnaBFvDVGUmocxYVSZYIRAH86gpy35bMZ1cMXvOGhbidenUZZKD0iVxw
        7UojuEWrM2YQuJU0CdCImwHLu8PBiOJDxZwPcAz4wy4B0jS8rvRk8kPDrOqOgJjmTnjvJ4VblBEVq
        oUVc1drQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSWim-0007lo-ER; Sun, 26 Apr 2020 02:08:40 +0000
Subject: Re: [PATCH net-next v2 2/3] ipv4: add sysctl for nexthop api
 compatibility mode
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, dsahern@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        bpoirier@cumulusnetworks.com
References: <1587862128-24319-1-git-send-email-roopa@cumulusnetworks.com>
 <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <33d13007-1b31-7d2b-dc85-c28d73e0985b@infradead.org>
Date:   Sat, 25 Apr 2020 19:08:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587862128-24319-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/20 5:48 PM, Roopa Prabhu wrote:
> From: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Current route nexthop API maintains user space compatibility
> with old route API by default. Dumps and netlink notifications
> support both new and old API format. In systems which have
> moved to the new API, this compatibility mode cancels some
> of the performance benefits provided by the new nexthop API.
> 
> This patch adds new sysctl nexthop_compat_mode which is on
> by default but provides the ability to turn off compatibility
> mode allowing systems to run entirely with the new routing
> API. Old route API behaviour and support is not modified by this
> sysctl.
> 
> Uses a single sysctl to cover both ipv4 and ipv6 following
> other sysctls. Covers dumps and delete notifications as
> suggested by David Ahern.
> 
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  include/net/netns/ipv4.h   | 2 ++
>  net/ipv4/af_inet.c         | 1 +
>  net/ipv4/fib_semantics.c   | 3 +++
>  net/ipv4/nexthop.c         | 5 +++--
>  net/ipv4/sysctl_net_ipv4.c | 7 +++++++
>  net/ipv6/route.c           | 3 ++-
>  6 files changed, 18 insertions(+), 3 deletions(-)

Hi,

Are net sysctls supposed to be documented, e.g. in
Documentation/admin-guide/sysctl/net.rst?

thanks.
-- 
~Randy


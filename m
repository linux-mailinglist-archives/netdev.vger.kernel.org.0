Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595A03D09B5
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 09:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhGUGs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 02:48:56 -0400
Received: from verein.lst.de ([213.95.11.211]:57680 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhGUGsM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 02:48:12 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 67DB067373; Wed, 21 Jul 2021 09:28:47 +0200 (CEST)
Date:   Wed, 21 Jul 2021 09:28:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 2/4] net: socket: rework SIOC?IFMAP ioctls
Message-ID: <20210721072847.GB11257@lst.de>
References: <20210720142436.2096733-1-arnd@kernel.org> <20210720142436.2096733-3-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720142436.2096733-3-arnd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int dev_getifmap(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct ifmap *ifmap = &ifr->ifr_map;
> +	struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
> +
> +	if (in_compat_syscall()) {

Any reason that the cifmap declaration is outside this conditional?

> +static int dev_setifmap(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct compat_ifmap *cifmap = (struct compat_ifmap *)&ifr->ifr_map;
> +
> +	if (!dev->netdev_ops->ndo_set_config)
> +		return -EOPNOTSUPP;
> +
> +	if (in_compat_syscall()) {

Same here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

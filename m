Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50AF1E6A29
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406206AbgE1TMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406147AbgE1TMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 15:12:19 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8762F207BC;
        Thu, 28 May 2020 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590693138;
        bh=kbMoApekVxOio8dw+Uo882XdjiDnevDypOVqQR29HH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pxIepPpn3ghCqOGDgMBZHwDzTPC31IGDU+g4dKxpiU9YAqRaCpVUehkffHZ8ors05
         G0HjPxp/ths4YkK9kfKuqKIL2J8fD8osiUNnPCfk0sRIzXhnp9WGOE6RmfIAf5aX/r
         yk5NTDevg068q2xlHmZ6lV1BkHQEWJHSijpZ1yp4=
Date:   Thu, 28 May 2020 12:12:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net v2] cxgb4/chcr: Enable ktls settings at run time
Message-ID: <20200528121216.16b8ec77@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <475fb577-a8cc-d1dc-e522-13333c7975a2@chelsio.com>
References: <20200526140634.21043-1-rohitm@chelsio.com>
        <20200526154241.24447b41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <00b63ada-06d0-5298-e676-1c02e8676d61@chelsio.com>
        <20200527140406.420ed7fd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <475fb577-a8cc-d1dc-e522-13333c7975a2@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 09:36:43 +0530 rohit maheshwari wrote:
> CHCR driver is a ULD driver, and if user requests to remove chcr alone,
> this cleanup will be done. This is why I am taking module refcount until
> tls offload flag is set, or any single tls offload connection exists.=C2=
=A0=20
> So, now,
> when this cleanup will be triggered, TLS offload won't be enabled, and
> this crash situation can never occur.

You expect that if there is no TLS connection and feature flag was
cleared nobody will call tlsdev_ops again. I've shown you in the
previous email that the callers of those ops are not synchronized
against flag changes.

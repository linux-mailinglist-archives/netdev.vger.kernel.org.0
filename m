Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC9C38DB78
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEWOro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:47:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231776AbhEWOrn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 10:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ect182xosKMp40my+SbKIak0EebPY4jC7+FdnqtirHU=; b=JTvNm6CARYHsNy8bPBRw0dBI36
        ue13IgvEkns2qiBROEn0Qhwxk/FtPqLyJP+r7ExHOP2bDTMStd7PobEs+8Uk8sZVuVkHHwMBPbh+D
        b1wGZuy3GPTq6EU8mdl43SownMjNrCGQ6zMGip7AY0Oz9cv11nx/+VTrlx5Z2RK8y8M8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lkpMq-005nDd-Mv; Sun, 23 May 2021 16:46:12 +0200
Date:   Sun, 23 May 2021 16:46:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX
 bandwidth fluctuations
Message-ID: <YKpqtK7YBVFnqRSw@lunn.ch>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
 <20210523102019.29440-3-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210523102019.29440-3-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 23, 2021 at 06:20:19PM +0800, Joakim Zhang wrote:
> From: Fugang Duan <fugang.duan@nxp.com>
> 
> As we know that AVB is enabled by default, and the ENET IP design is
> queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of
> queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
> tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

How is the driver currently scheduling between these queues? Given the
802.1q priorities, i think we want queue 2 with the highest priority
for scheduling. Then queue 0 and lastly queue 1.

    Andrew

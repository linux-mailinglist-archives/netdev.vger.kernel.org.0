Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1203CF86D
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhGTKOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237989AbhGTKKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 06:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F866108B;
        Tue, 20 Jul 2021 10:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626778242;
        bh=jAUMwGq/k28WICBve6hHau+/pQMtwrpjEuoUr6MINC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cfWj2qBFCeFqrhQWh0V2CSRCACi9sMydlXETz+4z3mHjF3WP+xQAAma5+yYOxoEk8
         5Pk8erEdsuJ0qBFxnhZIsIJjcS+mah7aiFE2vwj+sgatVXjUpHcB3C8S+eZAlCz87v
         biePOld91NPWEJ9qrqpk3vucLzv4p4ozS6eKnv3Oc/KaSk00VK8GimU+P+kgpuYrO2
         HwX7v5TqzpcMmgh5BsLLAVbx+TYWvw7Vym/f2atATTPZuS2EH954cMlyidxOdATDOs
         IFpZlIE05CepRw3r09RO3falzHLuUWKpn6spGqTe9j5eL26aNXuDd7POkxY3uqQyqP
         5ns4ETKVBQCbQ==
Date:   Tue, 20 Jul 2021 12:50:36 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        timo.voelker@fh-muenster.de
Subject: Re: [PATCH net 2/2] sctp: send pmtu probe only if packet loss in
 Search Complete state
Message-ID: <20210720125036.29ed23ba@cakuba>
In-Reply-To: <b27420c3db63969d3faf00a2e866126dae3b870c.1626713549.git.lucien.xin@gmail.com>
References: <cover.1626713549.git.lucien.xin@gmail.com>
        <b27420c3db63969d3faf00a2e866126dae3b870c.1626713549.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Jul 2021 12:53:23 -0400, Xin Long wrote:
> This patch is to introduce last_rtx_chunks into sctp_transport to detect
> if there's any packet retransmission/loss happened by checking against
> asoc's rtx_data_chunks in sctp_transport_pl_send().
> 
> If there is, namely, transport->last_rtx_chunks != asoc->rtx_data_chunks,
> the pmtu probe will be sent out. Otherwise, increment the pl.raise_count
> and return when it's in Search Complete state.
> 
> With this patch, if in Search Complete state, which is a long period, it
> doesn't need to keep probing the current pmtu unless there's data packet
> loss. This will save quite some traffic.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Can we get a Fixes tag, please?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDE12B0895
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbgKLPk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgKLPk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 10:40:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1916920A8B;
        Thu, 12 Nov 2020 15:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605195627;
        bh=3D8TQhzFx9PXf0zCMIIPsXRK/iP5EIAsbriL2JAon4M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zdzOaeMxsXT2pMf/VnBgXAkUq9Z8ZMjTGiGFRJsVYf1YBKZKFsNMaw/Vv3Aml2F5U
         BX+HhzB4NJym9r+rd4oIheXLtZoqXPS00D4E0z5G5H1zKH7NQRM9FXO0oKLx5rkZG1
         qLudEocgckQkA3oINrg1uuRGyOTn6y7clG6I5it4=
Date:   Thu, 12 Nov 2020 07:40:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        mptcp@lists.01.org
Subject: Re: [PATCH net-next 00/13] mptcp: improve multiple xmit streams
 support
Message-ID: <20201112074025.5b932eaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 11:47:58 +0100 Paolo Abeni wrote:
> This series improves MPTCP handling of multiple concurrent
> xmit streams.
> 
> The to-be-transmitted data is enqueued to a subflow only when
> the send window is open, keeping the subflows xmit queue shorter
> and allowing for faster switch-over.
> 
> The above requires a more accurate msk socket state tracking
> and some additional infrastructure to allow pushing the data
> pending in the msk xmit queue as soon as the MPTCP's send window
> opens (patches 6-10).
> 
> As a side effect, the MPTCP socket could enqueue data to subflows
> after close() time - to completely spooling the data sitting in the 
> msk xmit queue. Dealing with the requires some infrastructure and 
> core TCP changes (patches 1-5)
> 
> Finally, patches 11-12 introduce a more accurate tracking of the other
> end's receive window.
> 
> Overall this refactor the MPTCP xmit path, without introducing
> new features - the new code is covered by the existing self-tests.

Hi Paolo!

Would you mind resending? Looks like patchwork got confused about patch
6 not belonging to the series.

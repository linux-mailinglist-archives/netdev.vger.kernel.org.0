Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F8326064A
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgIGVh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726926AbgIGVh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:37:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A2F2145D;
        Mon,  7 Sep 2020 21:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599514645;
        bh=TR+8L/cHJoS6y7E0fwzurPqD73BfY8NTbsmQRCOlZZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iaEyZwIpZ8UE2Dm7sJzx3v42L1YgU+cx8oPJ0hcbDBNMPKXa8oD0Md5pDBIBDtM/A
         mYddB7Kfo8BBEpRxfErLg3GS0c7pALP5V0SlGLB9Q5YOlhSGtir9fECHVxipD5SwZQ
         xIzZIhiwcOU+9Wy50V7HSSsjxMrxLpoOctvcW1nA=
Date:   Mon, 7 Sep 2020 14:37:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gnault@redhat.com
Subject: Re: [PATCH net v2] Revert "netns: don't disable BHs when locking
 "nsid_lock""
Message-ID: <20200907143724.6564fd4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907155441.5938-1-ap420073@gmail.com>
References: <20200907155441.5938-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 15:54:41 +0000 Taehee Yoo wrote:
> This reverts commit 8d7e5dee972f1cde2ba96c621f1541fa36e7d4f4.
> 
> To protect netns id, the nsid_lock is used when netns id is being
> allocated and removed by peernet2id_alloc() and unhash_nsid().
> The nsid_lock can be used in BH context but only spin_lock() is used
> in this code.
> Using spin_lock() instead of spin_lock_bh() can result in a deadlock in
> the following scenario reported by the lockdep.
> In order to avoid a deadlock, the spin_lock_bh() should be used instead
> of spin_lock() to acquire nsid_lock.

Applied, thank you!

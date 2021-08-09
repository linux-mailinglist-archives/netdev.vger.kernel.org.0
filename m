Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA6C3E4F9A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhHIW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhHIW7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 18:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DC0960E9B;
        Mon,  9 Aug 2021 22:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628549919;
        bh=wj0mPdn0GIo/g8Zu8XIQJ/XKciICms4eZ7rE/6Znb1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUkwDSyL5kn/0HTmOR8aV0y0pabkpB+bvgUuxczdhjpVRjlxwH5XYP37fjjhKpJrx
         8LzXH7hjjlNbMYT7IgwwSAqCARCgzQeLuCpJyzZ+UmTZyRiAjA2bJkDn1jC2L1GsCR
         4KW0lXAcEeOCopcZ75psdwu9+8uqb7VFBixYSNJ6sDwYT13vMvIhfb//O4TIl22je7
         YwlPkwBbKZtjxPQi92L8HI+bey03eWMVi4JO6FndkIEKtMLVrMGfqJl+pTxH9W4LgS
         oX0WPuSf3dgXMQcBgyjr3qW/ZtZU2NY1zQuqqVfRRN0+XYVgGOzJ/Wq8A1ccld8K5Z
         Aw/XXzEMucXHw==
Date:   Mon, 9 Aug 2021 15:58:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 2/4] ice: Stop processing VF messages during
 teardown
Message-ID: <20210809155838.208796aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809171402.17838-3-anthony.l.nguyen@intel.com>
References: <20210809171402.17838-1-anthony.l.nguyen@intel.com>
        <20210809171402.17838-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Aug 2021 10:14:00 -0700 Tony Nguyen wrote:
> When VFs are setup and torn down in quick succession, it is possible
> that a VF is torn down by the PF while the VF's virtchnl requests are
> still in the PF's mailbox ring. Processing the VF's virtchnl request
> when the VF itself doesn't exist results in undefined behavior. Fix
> this by adding a check to stop processing virtchnl requests when VF
> teardown is in progress.

What is "undefined behavior" in this context? Please improve the commit
message. It should describe misbehavior visible to the user, failing
that what will happen from kernel/device perspective. Or state that it's
just a "fix" to align with some internal driver <> firmware spec...

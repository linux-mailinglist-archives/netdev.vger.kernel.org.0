Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D448820EA44
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgF3AeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:34:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgF3AeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 20:34:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20561206A5;
        Tue, 30 Jun 2020 00:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593477253;
        bh=3b0CchttCHk7S9cUv8SQ7oES4by+SHi6lhcJZMgV3t8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fv+fN1gBcXHLghttleF2LQSQFpYjJPSnclLFp5oTYtVLcHBbjCJLebWVy+W+MAgib
         35TGEC0o/WeXhnvf/AGJae8sth8xDcFxRaTTXhcfbmrq7e93ZhszwWXuYZJKwi3viu
         5XrMqmnlXS7CjaKOwKFo5gMYcOIj/Ytv4l/+tXXM=
Date:   Mon, 29 Jun 2020 17:34:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v2 1/3] cxgb4: add mirror action to TC-MATCHALL
 offload
Message-ID: <20200629173411.01ec967c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e02bf5f7ba6b6088a7844d9dec55e98af00c2cfc.1593469163.git.rahul.lakkireddy@chelsio.com>
References: <cover.1593469163.git.rahul.lakkireddy@chelsio.com>
        <e02bf5f7ba6b6088a7844d9dec55e98af00c2cfc.1593469163.git.rahul.lakkireddy@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 04:19:51 +0530 Rahul Lakkireddy wrote:
> +	if (refcount_read(&pi->vi_mirror_refcnt) > 1) {
> +		refcount_dec(&pi->vi_mirror_refcnt);
> +		goto out_unlock;
> +	}

Please remove the use of refcount_t if you're doing this, otherwise a
person looking at this code will waste time trying to validate if this
clearly bogus use of refcount_t is harmless or not.

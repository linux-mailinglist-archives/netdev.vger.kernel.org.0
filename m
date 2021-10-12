Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D345429A53
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 02:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhJLARO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 20:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232758AbhJLARO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 20:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EF7060F11;
        Tue, 12 Oct 2021 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633997713;
        bh=4Vx0u1HbO6ywxvaS1oJK/a2xiZSiIH3yuwIxgrTnwQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XuA6X9qnAzcHjdTuxTtzBwN/HihLhL/d+7uS8zD26Z9tG62FBQBs4WRTGaWPCFifF
         OlgPuUhMjd4AqR9eiqlJrxR5XjZWR9T0zdGSrynhvrrhditp6PHDRYyIdDulwgwsOR
         jB1rHqwwph6U7TeTlokPz+/uzdvWSYjV7rm/D4pMuzNDmhq6jcOotJkSrnVhnK4lNq
         y9sol7RPyfzgVhXlUbm3dNKI56Zjfq+rdTVVHYPQSNTwIidIiMhB0/XSlZbT6Fq0ur
         JC611l5qfPSP5M2k+7Wrk2O5On0Gopo0GyBGk4hRjlww6RUmG2hLZH6jAUvS6Ah9tb
         t2HaXxB3v7Pdw==
Date:   Mon, 11 Oct 2021 17:15:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     louis.peens@corigine.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@corigine.com, simon.horman@corigine.com,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH] nfp: flow_offload: move flow_indr_dev_register from app
 init to app start
Message-ID: <20211011171512.71ed15ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011153200.16744-1-louis.peens@corigine.com>
References: <20211011153200.16744-1-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 17:32:00 +0200 louis.peens@corigine.com wrote:
> @@ -942,6 +938,10 @@ static int nfp_flower_start(struct nfp_app *app)
>  			return err;
>  	}
>  
> +	err = flow_indr_dev_register(nfp_flower_indr_setup_tc_cb, app);
> +	if (err)
> +		return err;
> +
>  	return nfp_tunnel_config_start(app);

You need to add an error path if nfp_tunnel_config_start() fails, now.

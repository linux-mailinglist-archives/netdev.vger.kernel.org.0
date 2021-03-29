Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F13934DCA9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhC2XyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhC2Xxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:53:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C063E6191F;
        Mon, 29 Mar 2021 23:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617062031;
        bh=O7CZUUst1KTUXea/ImcMyTTrMtLZde4Lis24HYpx6Sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E5lJZqBTYgDkDNrBmZV2N596JOK7b6csKY7cw486lsvRqDDlcioGJLOIcsjt+mnqJ
         +USRTsn/5fUz5CcQk6Q0tZRaP4S72V2ucI3MaYkI9YbmiUugCg2yDoxO2LdjsQE1va
         IONLcMyEV2H+HJUQK2qLfERFCwyCdDRw3LqmTvGsQCnzhVDloY9Zjum2/1aH03c4sU
         WwuhubQfFIzp/n0zRfgGUFzCKniKk7elmyRnR3tPRFKWAOB9OYnbqq8gNWgIBG9q/Q
         8ko7I+7wjL5wa9Gl7VZnW04NzMOfqa4Q8IHUl/S8wEIDdUq0z9JPVv/997iP8jo4iT
         Rl5nj3U2ynBag==
Date:   Mon, 29 Mar 2021 16:53:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     simon.horman@netronome.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        oss-drivers@netronome.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethernet/netronome/nfp: Fix a use after free in
 nfp_bpf_ctrl_msg_rx
Message-ID: <20210329165349.7b2e942f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210329115002.8557-1-lyl2019@mail.ustc.edu.cn>
References: <20210329115002.8557-1-lyl2019@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 04:50:02 -0700 Lv Yunlong wrote:
> In nfp_bpf_ctrl_msg_rx, if
> nfp_ccm_get_type(skb) == NFP_CCM_TYPE_BPF_BPF_EVENT is true, the skb
> will be freed. But the skb is still used by nfp_ccm_rx(&bpf->ccm, skb).
> 
> My patch adds a return when the skb was freed.
> 
> Fixes: bcf0cafab44fd ("nfp: split out common control message handling code")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

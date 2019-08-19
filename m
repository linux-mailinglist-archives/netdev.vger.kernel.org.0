Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12A694EF8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 22:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfHSU2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 16:28:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40992 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728395AbfHSU2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 16:28:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id i4so3405145qtj.8
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 13:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pJvcVeGyUeIVDpO5RArvDs7NS7qFRcy6zBiCjIhFyCU=;
        b=kjpnuPoNhgCzQoP6p/RTLE23OKutNFwh0RaCBaUpPKFCL/a9OlcZdO9kjDsTBb2lBN
         qvirKyldJzmUhiECW5COmsf4jBRys0ZQ7p/od9SWMCl0pcokhQDetq3HoOy/PoPsPnTj
         mHX+vTPjJBwoAcaZpXQnYN6G393UKNRfTj184M1E8o+tAuyDjBkMcdM+lPNoMS2jXcso
         Odl57Wm9bO72RjCeQQIfzG1bz2n+T3ni70uv3D4NxyI7FD8d/fvRuJmiex1KH+kUJXQH
         YJbNhAQKTab0U21jVJchUfWoGtyqkehVeG3fcX8/e+Hid9d8rWJWD7GLFC+xxrueF5yY
         Gzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pJvcVeGyUeIVDpO5RArvDs7NS7qFRcy6zBiCjIhFyCU=;
        b=lt3UwsMCrRBKoo0NZt8ETHxZXZjXSClKXCMjbxbPl7gcXATA3UcDe1GlCMnhQG1MN6
         vYjcMo/DpdPD/Kxp9YmCLtjiq3BC3FosEz19tdMyzVpXCGe6ErombImhTh9YO+e/F/bG
         sZ2a3BedTuyLrmNWvX/Wv0Wc/HgpNPoTBbROChilpbqvGw7Y2pPm1dzA6/SePsrN2kSd
         66AnXEdYdIloo787k/iLzjMv7O6oGA03XOAwi7Uew4AtBpeAmNdnqzV6CC39oP32IEEk
         D3ZZ847wRZ4DZAz8Na/bPTY4uPej1rxM11BcDdGKAHwNCQ3tRnoDcIGazfG3/vt0D83/
         zb9Q==
X-Gm-Message-State: APjAAAXaMTDWSQobZs/fEUzvg+wawMBd+ojcD7iZ8IQ3stQygvXGG5ep
        EpyaRx9aW8zP1i2xc1vbpBNkPadvaCY=
X-Google-Smtp-Source: APXvYqztOLbRTFoVwU3R0+mvN+1PxMzx6yaEI7zKkrws343fdleTwrioRPo5ZqAbVsnLmOxVIg0OSQ==
X-Received: by 2002:ac8:7b97:: with SMTP id p23mr23070680qtu.357.1566246486693;
        Mon, 19 Aug 2019 13:28:06 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y23sm7379429qki.118.2019.08.19.13.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 13:28:06 -0700 (PDT)
Date:   Mon, 19 Aug 2019 13:27:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     wenxu <wenxu@ucloud.cn>, David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v7 5/6] flow_offload: support get
 multi-subsystem block
Message-ID: <20190819132757.0d00d34d@cakuba.netronome.com>
In-Reply-To: <vbftvady5tg.fsf@mellanox.com>
References: <1565140434-8109-1-git-send-email-wenxu@ucloud.cn>
        <1565140434-8109-6-git-send-email-wenxu@ucloud.cn>
        <vbfimr2o4ly.fsf@mellanox.com>
        <f28ddefe-a7d8-e5ad-e03e-08cfee4db147@ucloud.cn>
        <vbfpnl55eyg.fsf@mellanox.com>
        <20190816105627.57c1c2aa@cakuba.netronome.com>
        <vbftvady5tg.fsf@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 07:26:07 +0000, Vlad Buslov wrote:
> On Fri 16 Aug 2019 at 20:56, Jakub Kicinski <jakub.kicinski@netronome.com> wrote:
> > Hi Vlad!
> >
> > While looking into this, would you mind also add the missing
> > flow_block_cb_is_busy() calls in the indirect handlers in the drivers?
> >
> > LMK if you're too busy, I don't want this to get forgotten :)  
> 
> Hi Jakub,
> 
> I've checked the code and it looks like only nfp driver is affected:
> 
> - I added check in nfp to lookup cb_priv with
>   nfp_flower_indr_block_cb_priv_lookup() and call
>   flow_block_cb_is_busy() if cb_priv exists.
> 
> - In mlx5 en_rep.c there is already a check that indr_priv exists, so
>   trying to lookup block_cb->cb_indent==indr_priv is redundant.
> 
> - Switch drivers (mlxsw and ocelot) take reference to block_cb on
>   FLOW_BLOCK_BIND, so they should not require any modifications.
> 
> Tell me if I missed anything. Sending the patch for nfp.

Ah, that sounds plausible, I've only checked the nfp driver.

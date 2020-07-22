Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96641229FB4
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgGVS4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGVS4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:56:05 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DF5C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:56:04 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id j187so3002750qke.11
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WNY2CxXZhFyfG36mcsmoWBP8jQf9E5iWxL+7JoT3QM=;
        b=AKN3YODj3oyzXTuDCkjFiRx0ubFOmPCQyRU7fSCndkoxtuG4njAUVt86VxdbEmeZWH
         nQUV6h5cPqeK7nkdDMlMAjFK6gbzsIvnHpks8GHXexeutGJsMkxN9hgnekcV3UpiFHUV
         qHlGyLUtb7QLXv1Fhih+NZHslV0yIvhUjuh24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WNY2CxXZhFyfG36mcsmoWBP8jQf9E5iWxL+7JoT3QM=;
        b=mPnCfr5U+I/ppOyLPBrpY1EbXAgLxdmIIXD8PfN2DdPNXRvPlqVzj3IU48A4RAyl98
         ZIh/s7eMztjxNsbdhyJ2XUUmSV9l8hXuQFreQ6HZdVZCK/OQIIq1Te2NJBIq66Ys5pxr
         ukboVr6fr4bzLICjm8V248uMtK1FnNENCmCl4shp1nFDnNBIXa7du8t6c0xQ9+B+2Upa
         f/A2wUerzojMKENe/Lw5ybAWEFBhNOr0hkWMd4GvZyBBtEOmnqxuxaJAb6JG+TBhCNTR
         EMSBSE49UuH0Kii/O4hTOOxx1D9kf4fM1figA+tNOIsImG67ucDf+Aer1j3mWyurMK/C
         M+kg==
X-Gm-Message-State: AOAM5311kVU0powRKPWXIzVKlh4fJWT3C5So8h0Mtu0VAs0f1JbxGzKT
        4B4bdJ/K2/4l4N7vFSyS67EeHnfer9HEZoXzyto9lA==
X-Google-Smtp-Source: ABdhPJwb65YS/eaVNn6Kf/wrD2aPtRHefUwDZ/rAHS4qc8uKXBuMDd+ibHTV4AgX/xTWLNRhJrW7AUkQcQer7DxWZ6g=
X-Received: by 2002:ae9:e641:: with SMTP id x1mr1422408qkl.424.1595444163106;
 Wed, 22 Jul 2020 11:56:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200722184358.GA15694@embeddedor>
In-Reply-To: <20200722184358.GA15694@embeddedor>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 22 Jul 2020 11:55:51 -0700
Message-ID: <CACKFLik4j4w-EHfJQt0-PA6O0FUp_Np8W4KaDwosQGL2niNP2A@mail.gmail.com>
Subject: Re: [PATCH][next] tg3: Avoid the use of one-element array
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:38 AM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> One-element arrays are being deprecated[1]. Replace the one-element
> array with a simple value type 'u32 reserved2'[2], once it seems
> this is just a placeholder for alignment.
>
> [1] https://github.com/KSPP/linux/issues/79
> [2] https://github.com/KSPP/linux/issues/86
>
> Tested-by: kernel test robot <lkp@intel.com>
> Link: https://github.com/GustavoARSilva/linux-hardening/blob/master/cii/0-day/tg3-20200718.md
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

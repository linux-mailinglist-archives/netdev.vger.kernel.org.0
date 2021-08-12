Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE203EA733
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhHLPMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhHLPMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 11:12:45 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11ED5C061756
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:12:20 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id b1so5521157qtx.0
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 08:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DEWfPbUIJGpyz4+I2yCOQFq4vrznoJGDH99U2K5e3eM=;
        b=htg6ixd6JsqqCLc4PSil+GGw22+YNqubHOq70e/8l3m6WiP1gJrFvME9vIH14Zl+af
         +HlHi+SeZfDAZ6yyP5bFlFxUU2Ge/dCQuDMK3XYEbLNEUX1FTkzWL/gwrEYeqHzPPyKa
         pu4sYji5B+ffCP2ByRTevhfONJQFZ1Eq08RZajWhR3w5jACBNAHIrmyJ1g5bzuEQUVM5
         ivxvExGXxSUN++DodzgPLBdcT+2gP/wygVdcqukWEWX4c+akP4t+/TpanQb/gG1GXbii
         ckwD4EnPP5L9nLhPfrvcfqcHUklm8QqqJ0txD1tFmGd0QWQsJnejUR1i9EXy7MeBHSvU
         HP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DEWfPbUIJGpyz4+I2yCOQFq4vrznoJGDH99U2K5e3eM=;
        b=I3Pip4/wjjypfiuA4M2TMtdehTx9wGBl+W1Az/r1PjobwPrYNyrwbpIQ3vwxCa154K
         OcbQtjXYtX5fRclFG+u/8pX6TVqLaqHZO4tULXPteguGTd4/21/+nqtWsGcQsd48hhA+
         DXhljyzqtNgW7MyF0bCWY+d/s+7bPaMAzqyEhMKO5QyEMh8Q9FQ1VS7qkY4xXj73enX5
         385PqQQTwyM2o/8dDOn6onoiitREl+A+Epo1NABb5911vQbzMeaXfmuI+74TEjEcZdjP
         ONpNVJEVAbPMmcoXHiLxTYPaVcgh/4b3hcThcP4yEdFeNt3UZut3ahaNQXsefAFlWGdj
         VL4A==
X-Gm-Message-State: AOAM533vdF+cUY7haV78b2pgxrDoLVzrLex+diXYG1i7b2lty1BhtR55
        g3DIGfJnNUxnW63IU317Rnk6o8HYsNjxqZAHjg==
X-Google-Smtp-Source: ABdhPJwooqouUhUQQq44pS1uMZQyneVye36A4W/NyV58qt3XmJTdKPKrixLZPLEuptxzNFmLdOM7qktmnCqtPNCWOoA=
X-Received: by 2002:aed:2163:: with SMTP id 90mr4377886qtc.186.1628781139100;
 Thu, 12 Aug 2021 08:12:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210812145241.12449-1-joamaki@gmail.com> <d741b3f0-2c42-274a-21af-5bb55a1d9a1b@nvidia.com>
In-Reply-To: <d741b3f0-2c42-274a-21af-5bb55a1d9a1b@nvidia.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Thu, 12 Aug 2021 17:12:08 +0200
Message-ID: <CAHn8xckhVO9NSAOghLbx9uu6MNdMGRJJ6HobZv_OV02FEB4_cw@mail.gmail.com>
Subject: Re: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 5:01 PM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> Hi Jussi,
> Could you please share the null ptr deref trace?
> I'm curious how we can get a null skb at that point.

Hi Nik, this was reported by Jonathan here:
https://lore.kernel.org/bpf/20210728234350.28796-1-joamaki@gmail.com/T/#m07a73b1886a9213feb7112ce2a0d6dfde84fd27a.
I didn't reproduce the null ptr deref as it was fairly obvious how it
can happen, e.g. by having a bond with xmit_policy=vlan+srcmac. The
hashing functions were refactored to be used for both xdp_buff and
skbuff uses and the skb pointer became optional (was meant to be used
when packet was non-linear), but I missed fixing the vlan hashing
function. Partially the reason leading to this was that the
xmit_policy is very new and the bpf vmtest infra still uses an older
iproute2 version which didn't support it, so this was untested. What
is not tested is broken as usual.

> Also how are the xdp and null ptr deref changes related ?

They're related in that looking into the null ptr deref here I
realized that vlan+srcmac didn't make sense with XDP since we have no
guarantee that the vlan id is in the ethernet header. So this patch
both fixes the deref by checking the skb pointer for NULL and it
disallows the whole xmit policy for XDP for the aforementioned reason.

Hope this makes sense.

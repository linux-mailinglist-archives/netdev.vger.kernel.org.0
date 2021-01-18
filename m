Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF752F9A8C
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 08:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbhARHcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 02:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732105AbhARHcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 02:32:14 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA55C061757;
        Sun, 17 Jan 2021 23:31:34 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id f63so1881265pfa.13;
        Sun, 17 Jan 2021 23:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uMxNPxAc5Cn9KFySg+fY1OeEicAZhM0J6k8NTwRGK+A=;
        b=iaZzS8C3aXT2rIpu9BDwTtgQwNYsgOCzOvQDRtzptqNJcQ1WjV8yNGStDuo1Ak4rcL
         ywzDfzx/r6vY6f3V/q4yAmYqEFoVUK4cS4vN06qjRFknPyaksz78sYIr9SW4ZN/aWn0x
         iBoQ8JC8o3eSC3Tvjpi6T7COqH1Khrh88rGCAcUKtLntkWBdTg0ZqrzR4nIClItEL62e
         bEbvoToX7ZZvP0+xCVgDBmGYiQnHZfyuv7PNhfWrsqZ4NXIj1qXllhrKPX3O+/5Mx3dz
         NVWVesGTz5MdNRQV5ajQJEp1t03XT1JAjNeWNQ8zdj63XXJfWK29GBtH86YAbdW2HbRA
         4vzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uMxNPxAc5Cn9KFySg+fY1OeEicAZhM0J6k8NTwRGK+A=;
        b=AUIOiS6BzDojk4wjeatcKvAACih3Sh1QNSkZSGtuNXDqWCQjacXlMNXUZAMLXrZI75
         58/w9U6iIDAfLrL7xuFYKuzmUgr57crxr50VHgRWJSZ1FoKArQxW/bV+PLPPOVLrCn2k
         TqicskouiCME+0i8Qz/LHoVnZVEGAfLDjhPdBFXKufuH5XHaAe/8S/jzq1A3gJqBQXob
         eNKzApf/ASmoobzqX0yp0ammNbgMO3Aupmk722wW4CPWoLpJmyffVYiTGGJz1oI5ntkP
         /WhDo9m96APF2ujvjWcbu+y3cZWDn2Z66GlEns6BdTJ+l9pisFrP/Ca/AIG5Hd1sL5J8
         Ge1Q==
X-Gm-Message-State: AOAM531aXxs36DqjEzzHRqzqF08IvsJEeg92qrjF/TPElou7chf0F8eo
        ny+z/p4xvdwUbPB70dBBbhQGDlKtQJX6St0CFsI=
X-Google-Smtp-Source: ABdhPJxEtJGajVP4thclN6C/pO5f+COjssAshj2axTP4UepwJmqqj22e5d0d5dcx9ef2uoL6nqyNdqO6muZfhKhx51c=
X-Received: by 2002:a62:2e86:0:b029:1a6:5f94:2cb with SMTP id
 u128-20020a622e860000b02901a65f9402cbmr25225451pfu.19.1610955093909; Sun, 17
 Jan 2021 23:31:33 -0800 (PST)
MIME-Version: 1.0
References: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
In-Reply-To: <20210114143318.2171-1-cristian.dumitrescu@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 18 Jan 2021 08:31:23 +0100
Message-ID: <CAJ8uoz3YSuPj6F+GHkk6yXHryUEOUhVSg2pDVEVrFA6b8Hgu6g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] i40e: small improvements on XDP path
To:     Cristian Dumitrescu <cristian.dumitrescu@intel.com>
Cc:     intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        edwin.verplanke@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 3:34 PM Cristian Dumitrescu
<cristian.dumitrescu@intel.com> wrote:
>
> This patchset introduces some small and straightforward improvements
> to the Intel i40e driver XDP path. Each improvement is fully described
> in its associated patch.
>
> Cristian Dumitrescu (4):
>   i40e: remove unnecessary memory writes of the next to clean pointer
>   i40e: remove unnecessary cleaned_count updates
>   i40e: remove the redundant buffer info updates
>   i40: consolidate handling of XDP program actions
>
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c | 149 +++++++++++----------
>  1 file changed, 79 insertions(+), 70 deletions(-)
>
> --
> 2.25.1
>

Thank you for these clean ups Cristian!

For the series:

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

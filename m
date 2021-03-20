Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA1342ADB
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 06:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCTFYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 01:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhCTFYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 01:24:13 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8DC061762
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 22:24:12 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id l13so4622221vst.8
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 22:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uIXFNI8eCWn/KjYa7Yq0/6RhG7UEP8hAaDuZHnaFceA=;
        b=JVK7NpPxQ3hP3odQsbvgvMCWSbzJUriujWqmLeH5M8+ISEx9xE3kpmtdjam/lEZIbF
         a5FHcMPWGH08tp003qTZP2boc5+qukmhzbAOKRQbM2DmzlCtAW2/KkLflxD/LLRxClNW
         GJe7V5AcZIHLgy9QobSxkXiSYo8JTklVTBnaQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uIXFNI8eCWn/KjYa7Yq0/6RhG7UEP8hAaDuZHnaFceA=;
        b=ClXVECO+gQq1EIpo751KKg3KL7IV/3uJv0VCbpHoZLtm7XCtZinafSYrn1v4J1uv6r
         GcLURuAoD0k3uQ0Gm4s8JS6GRbAWuH6D0PHKVWZd2rvZiO3Ci92pC9i0Y4lrhsuvgVFJ
         XDJUYBjfG9E88dDGMaqaGnj/B6GZxKLBo2wVPvYlvZ5uggh1dr4n3E1Z0cOxPR+Ex5WZ
         Sin6evyYsPmtul2HifdQbscJtQzgIWXgQ/NJbH+J1ZFDmhSDej1OJIQ7lXt+K01NCxYb
         efXc330e9trWGD3y7Rvc4sKT8hJxmUdXTh17ZVYJHwOsuOQzfmav92D3qm75YMYW9URg
         WXlw==
X-Gm-Message-State: AOAM533t9JWk7fLxw4qxGfCq0U2owboI1FGxh87OBpQob1/WEu1cMxiE
        HV0YQSTVVAu+f07UCLQ7YSDAW4+XQ4ELUia684Wrl/XP4y8=
X-Google-Smtp-Source: ABdhPJxOCC4MVXL87iSbXXfmTDVDhv2RiTP9ZI6F5hOJKrLuxaGUts12nU7bior6JuQ8W4fC/xD0LMD2bo1y9f4HxNc=
X-Received: by 2002:a05:6102:208:: with SMTP id z8mr5303710vsp.2.1616217851800;
 Fri, 19 Mar 2021 22:24:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210218102038.2996-1-oneukum@suse.com> <20210218102038.2996-4-oneukum@suse.com>
 <CANEJEGvsYPmnxx2sV89aLPJzK_SgWEW8FPhgo2zNk2d5zijK2Q@mail.gmail.com> <8cd8ba7cfd3d2db647c48224063122fb865574bb.camel@suse.com>
In-Reply-To: <8cd8ba7cfd3d2db647c48224063122fb865574bb.camel@suse.com>
From:   Grant Grundler <grundler@chromium.org>
Date:   Sat, 20 Mar 2021 05:24:00 +0000
Message-ID: <CANEJEGsT4b2D6QEd1afUzB3aifCTHAcQRO14W0AiqaKattUT7A@mail.gmail.com>
Subject: Re: [PATCHv3 3/3] CDC-NCM: record speed in status method
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Grant Grundler <grundler@chromium.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roland Dreier <roland@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 10:14 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> Am Freitag, den 19.02.2021, 07:30 +0000 schrieb Grant Grundler:
> > On Thu, Feb 18, 2021 at 10:21 AM Oliver Neukum <oneukum@suse.com> wrote:
>
> Hi,
>
> > Since this patch is missing the hunks that landed in the previous
> > patch and needs a v4, I'll offer my version of the commit message in
>
> That is bad. I will have to search for that.
>
> > case you like it better:
>
> Something written by a native speaker with knowledge in the field is
> always better. I will take it, wait two weeks and then resubmit.

3 weeks are up. Oliver, did you want to post V4?

cheers,
grant

>
>         Regards
>                 Oliver
>
>

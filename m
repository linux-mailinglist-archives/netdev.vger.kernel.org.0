Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D5B3D37E9
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGWJEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhGWJD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:03:58 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA0AC061575;
        Fri, 23 Jul 2021 02:44:31 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id hp25so2651707ejc.11;
        Fri, 23 Jul 2021 02:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oAM1lPNMA+DFw4p7BBzVOKB5jQsces3J/Pr+N+LyGeg=;
        b=CYqV0zfZCndWTC02JCx5aK/OylW4KuxsCPJdkwUREzKMPzH7/R4HoDxrQUmMug8j+4
         wy3EQlajwwON0WuEe+UkfMbBLveglqyMTWECor2uQVT7j57hPXp0dOVn0jXBxRzHgYuT
         FstaVsCHA0VqdmWw/tjmC/ObcjtD91gIwm32ae3JV41r0RU1VTecyLbqpHnmhTddulvc
         4KASqSxLtoBe3cz3lHzZ7BMp67FWEe16KK+qlcPcGnIN0PEP1xcHqIXEnfGn3ec/2jCr
         30OP1iQvrbl7RC2y8smL3PhSFrVy9Pc5Pcq/Ejfc+S9p1RB2Eqt9aurNqnVESWp6HqOc
         Nk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oAM1lPNMA+DFw4p7BBzVOKB5jQsces3J/Pr+N+LyGeg=;
        b=sBvfm1Mt9cgVkj2He98Mh/XDeAFsvqrYHcBaJV77UUPQBy9TQSx272mibVbX/JYa80
         I1vDd8RSalYh0f9d+Z8iMPiipJS7lOdrozF2n6rBXTpc02kp8Bq3TPGcWGnnNAvlBuUF
         TP73IVrdpCGYo66y8jEsayBk8f23KIUvPk2zXZDlPE2Q2SCCeqBNWflozxvQJULKVFVz
         FpTYCXF7K8WTFfUrOClDbkgau5KBEU6/dryQAlqV69qI1FL0Wt+f/r1kmXm/GPQThRTF
         dETupJYRgLw/iRk3hJkz6H/YA1RVeAb7vNEY+M2IMPDun5I49kIt1pA1jkF8eETZXr+B
         m/GA==
X-Gm-Message-State: AOAM530Te8FShVBptk+93R+CcInJnaRR+jLUSanibWPHNXuiK9ZVhyyR
        ixFWqtI7uH7rMI7Znll8W0gBc+QKYtpfTzaWqSc=
X-Google-Smtp-Source: ABdhPJz7+WsGlMw1zvCrS5q1cL9ef0ZYaCywy/k2ySJmHBA19cbaymZ8+4KA2MmrttCNpbAldppZ4DxP0H5fuQxpm+M=
X-Received: by 2002:a17:906:eda7:: with SMTP id sa7mr3879937ejb.135.1627033469906;
 Fri, 23 Jul 2021 02:44:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
 <6fa2aecc-ab64-894d-77c2-0a19b524cc03@gmail.com> <CAD-N9QXO4bX6SzMNir0fin0wVAZYhsS8-triiWPjY+Rz2WCy1w@mail.gmail.com>
 <2e9e6fa7-a405-088d-3b4c-da62b85f3fc6@gmail.com>
In-Reply-To: <2e9e6fa7-a405-088d-3b4c-da62b85f3fc6@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 17:44:03 +0800
Message-ID: <CAD-N9QXdv2me8wSm0D9nN72j3oP8mc5vsLJ+ffbH2fbCS6_F_A@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     xiaoqiang zhao <zhaoxiaoqiang007@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 5:36 PM xiaoqiang zhao
<zhaoxiaoqiang007@gmail.com> wrote:
>
>
>
> =E5=9C=A8 2021/7/23 17:25, Dongliang Mu =E5=86=99=E9=81=93:
> > Can you point out the concrete code releasing regd? Maybe the link to e=
lixir.
> >
> >>>       ieee80211_unregister_hw(data->hw);
> >>>       device_release_driver(data->dev);
> >>>       device_unregister(data->dev);
> >>>
>
> call graph seems like this:
>
> ieee80211_unregister_hw
> (https://elixir.bootlin.com/linux/v5.14-rc2/source/net/mac80211/main.c#L1=
368)
>         wiphy_unregister
> (https://elixir.bootlin.com/linux/v5.14-rc2/source/net/wireless/core.c#L1=
011)
>                 wiphy_regulatory_deregister
> (https://elixir.bootlin.com/linux/v5.14-rc2/source/net/wireless/reg.c#L40=
57)
>                         rcu_free_regdom

Thanks very much. This is really helpful.

>

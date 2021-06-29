Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36853B750E
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 17:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbhF2PWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 11:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234627AbhF2PWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 11:22:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E1C061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:19:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so2667879pjo.3
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 08:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hw8nByojrmg2vfnsUeumhHWobkp1CkPhkhbbqHp/hwg=;
        b=lp+X+ZGewhmW1kMshQhcxhnGJR6tcqg2jSkmmRLbEtwQbc9G2LBq1AE487x4ODiGW7
         BIx+mMpGscMIFdQLUZ2DfziVVQJOyy4prnuonvCQJwuNOJzfFGgSCpSQTgqFHydgNKot
         lywJJ+L4hfV6GIUK2fbGjST5nhYaPHg2fIJXHtrLLBItzP1kDTmWoLoIYSJLZh1I8Grp
         Mto+U5RonJPsJI/v1pVZzLoynR7yNzDgo4fSQtntz+A6EMh/YSRLgNLJ7/m67p2j7GIQ
         2en0BCiHZejJV4QiuZ6m70KRao/QNgxDgj+KdvX2a020pOZOcxPBWuMl+6gGfdelqWOx
         Ls+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hw8nByojrmg2vfnsUeumhHWobkp1CkPhkhbbqHp/hwg=;
        b=CB+wwQ9OMF2fbVzAKTzjbFKN1xo6G9izngg3THl5s8SeNJ/Kbvu+50FQZ3hSN4YXFa
         xDiL7d7W2WqAYWyvlN5uafNZLzmVLVI9eQ9xO4DrDG3nZTSw8hCc4RQOPluT1CGWzD44
         dmWXNx4U387iJGZGU7TbhECNdUPdVEEWn37X+NV/HQEH0DBh23TCPX0c9ywb5xbeVvsR
         yoUjOsjv9lXkuA+FPuu+mL/H8Tp1MdikAekvpk3Mg2ZL/Fs97cWZ+5wovMvCR/47NZVH
         XMCb7vL2v7Rr8cKK/rVkKlQwCIGXxmqH4EgJxYa/Og2nq5g2ZIvVRZeNYE9LPHFiCFTK
         VnAg==
X-Gm-Message-State: AOAM5327weCgR25+HyFDWnccPTL4bvMdy3A92zBOEWJU0pawFyGwORnn
        Jfg69iJtLs2XuE19U7CVS0mz+Ah4CyIdcnlL4BWOlA==
X-Google-Smtp-Source: ABdhPJwrJEONmiDbwUWoeB0quZizpBWc1ckEPLjWrbm1WzogQSGWN2jJUSBYE9baLiZMQmMDlwRw3vMvueJlkbEkAEI=
X-Received: by 2002:a17:90a:ee95:: with SMTP id i21mr14109411pjz.231.1624979986431;
 Tue, 29 Jun 2021 08:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-7-ryazanov.s.a@gmail.com>
 <CAHNKnsR5X8Axttk_YX=fpi5h6iV191fLJ6MZqrLvhZvPe==mXA@mail.gmail.com>
 <1d31c18cebf74ff29b5e388c4cd26361@intel.com> <CAMZdPi9bqTB8+=xAsx3C6yAJdf3CHx9Z0AUxZpFQ-FFU5q84cQ@mail.gmail.com>
 <e241d0d4-563d-e111-974e-9e47228f5178@intel.com>
In-Reply-To: <e241d0d4-563d-e111-974e-9e47228f5178@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Tue, 29 Jun 2021 17:29:10 +0200
Message-ID: <CAMZdPi_vV1GfY7WUvYJ7F5b6SrkxwtC331NK-JF1tdmPjprx7g@mail.gmail.com>
Subject: Re: [PATCH net-next 06/10] net: iosm: drop custom netdev(s) removing
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Tue, 29 Jun 2021 at 16:56, Kumar, M Chetan <m.chetan.kumar@intel.com> wrote:
>
> Hi Loic,
>
> On 6/29/2021 7:44 PM, Loic Poulain wrote:
>
> >>> BTW, if IOSM modems have a default data channel, I can add a separate
> >>> patch to the series to create a default network interface for IOSM if you tell
> >>> me which link id is used for the default data channel.
> >>
> >> Link id 1 is always associated as default data channel.
> >
> > Quick question, Isn't your driver use MBIM session IDs? with
> > session-ID 0 as the default one?
>
> Link Id from 1 to 8 are treated as valid link ids. These ids are
> decremented by 1 to match session id.
>
> In this case link id 1 would be mapped to session id 0. So have
> requested link id 1 to be set as default data channel.

Oh ok, but why? it seems quite confusing, that means a user creating a
MBIM session 0 has to create a link with ID 1?
It seems to be quite specific to your driver, can't you simply handle
ID 0 from user? to keep aligned with other drivers.

Regards,
Loic

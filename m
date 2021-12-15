Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67246476388
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 21:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbhLOUk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 15:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbhLOUk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 15:40:27 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD14C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:40:27 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id y16so32121480ioc.8
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 12:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s+zwdoTMjPI5NAYhZ6198/6SU7TePjrNisDlk5tldk8=;
        b=Y0ppZWjmij6JqCxAoL412JJrJO9yPxn6x6apBqdkfiKcKwL90ExwiwqRuIM/F142sf
         izj6atcm4XaCV6YJ1jKEN3lIWB5DVcP1YJaiB8fdWpINo9zfIkdtAvMlkwG0IG+/MxKB
         PQ8+lZQWzmMysgjzdOHK4xSXHstkoynfYwFDRripTcBQ9blVvuP+O9ff9l93WuOu8rJQ
         HZlHTr0e1upGspVSHTOdubeCz9ro8e+W/ZmtqHknfX02I8mqSKiLNcAycElOXjX4SmfM
         IX7jooRXzdmOlmi+vkuPh5s/BhRiywK7luadSxzRI6SZStl6AyOvcyUeJWfC44abQJZT
         gigQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s+zwdoTMjPI5NAYhZ6198/6SU7TePjrNisDlk5tldk8=;
        b=g2eTO+jk0wQO/C3JD19mMmo3yLgGS8BUIuw162SrXGzOmGki4I2+BwdXh5FMUF5H6l
         B0E0skJpt1qG2UEWbmDDG4P8UBwM7DmSacwHV3AZ87AuG1MLHU7oWY9OOnCie01yYJ2f
         S0vxmROnE/8rAnzaJjvmG965UxWqRmHj7tTaain7ocmypevOjEK7ehNjlg8b+Hkuu9QU
         GHEYT+4P/eUGPSgaPGrNUI+RZeMQvXEftJ5aQanrNhDtMbakYVO6lfDID2YPJnlrET01
         3dWqd6yEdObEPcYKBB5KM/fdxyyZfWpglvPO9tRpIEEFTwkUlX+BI5OHu1PhPhpS6iab
         AUXw==
X-Gm-Message-State: AOAM532wRjezO4YMZxY4QXCphVnn7GW+oCi5S8LBd/MEQqFTY8dpVBe3
        Q9u7Z9A2ZMvLiFGP4e/PZ1vKCTZRHQdbIbTMb1U=
X-Google-Smtp-Source: ABdhPJzu/cRgMbzFHiu93xb4pevApM3L5Ha5QBY7WgYD6Un+1uk3QtHyqeD24qFamFaAWiUuOZSjCFlC+1m+4VzumtY=
X-Received: by 2002:a05:6638:d08:: with SMTP id q8mr7039939jaj.38.1639600826924;
 Wed, 15 Dec 2021 12:40:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1638814614.git.gnault@redhat.com> <87k0g8yr9w.fsf@toke.dk> <20211215164826.GA3426@pc-1.home>
In-Reply-To: <20211215164826.GA3426@pc-1.home>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 15 Dec 2021 12:40:13 -0800
Message-ID: <CAA93jw4w7KVn5y=LU2i5ujj9F3YA00T4UmdbU+cTR5-=9o4QSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
To:     Guillaume Nault <gnault@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Russell Strong <russell@strong.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I look forward to a final toss of TOS.

Cheered-on-by: Dave Taht <dave.taht@gmail.com>

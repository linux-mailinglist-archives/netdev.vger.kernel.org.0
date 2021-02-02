Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2093F30B709
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 06:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhBBF1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 00:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhBBF12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 00:27:28 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F0EC0613ED
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 21:26:48 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id nm1so1544465pjb.3
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 21:26:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2aSi1076ZMYi9QwDLav0uYMAtOvOzjR2/EgZOx2UTGo=;
        b=hcNoInRBN39PFvCzw9hBmZ5GVgTwApbquN2ltBCt15sgiP7yDQB0ckxeaE+XJ7QWmk
         gEqbnbnr4pzTcovQncYCBdhgd9AXkzQEnaerXyCU1nXWbTnY2H+BD2+kPHuSG9yke9L0
         xMfagm8/spfY/mIoscA5+/N7+GU9DR7QFIvCgSCGK9dNCzlEoIxklqD9JhailUtjAi5d
         QgGjXU598SJkuhU0VnxUbziPfL7lkH2pRGNAR9iGKkvn/ttzXoeH6iEG0kn+IOsNtDAL
         ickIgGCSLLK5wb+DrHe91G3AywVgvd2b3bvuS3fqomejgQk7Y3TWES/tYLCwYUaBg88P
         WyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2aSi1076ZMYi9QwDLav0uYMAtOvOzjR2/EgZOx2UTGo=;
        b=DToP8/KscpX4HD6Ric1KoWwgW1qvr4kzzu7vV+iEaA6cTTHLcRG5jabupervyKD7XC
         ui91v+MLOOZDI/V8DrJoogHMSzhGEr65zTz49opm2dR/kCkZqDut9hdpLungKx2JAXAX
         YTGfWqYKFzkQ3QOnUlD1mGuCoiAjh1Csuwjw0rbu4/9M+vAtZVqCWrrxOwau2q0aBiVc
         EFuDDcDRndq6K4rwwA7q4rakSq95oX8uj/hKFc1OWMe1cH8kIX+8O5JWTtipaYmJfGi/
         DmuwZxAc/rk2KnAEqg23InhuRAIOSbCc41pYrNhLuKsPkj5dtZsb/h+/6aCslZ4sPGHN
         QmBQ==
X-Gm-Message-State: AOAM533k5NaVESDEBdCEYL5i1oGWjSjxzEeAwqtmNIMhIdHL960vgDsS
        siLGrGSOuMITwJK+2exv0ikMnoYak8GLL9vvDes=
X-Google-Smtp-Source: ABdhPJygM6SDJvGFqZCNMN9MvFbeUktgly5Ttg1K1aRM/JeW8vecJjKf5PTxiZqLer4I2NEGgBCH3MU2gcjee6G68C4=
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr2523055pjh.52.1612243608062;
 Mon, 01 Feb 2021 21:26:48 -0800 (PST)
MIME-Version: 1.0
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com> <20210201130242.GC25935@netronome.com>
In-Reply-To: <20210201130242.GC25935@netronome.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 1 Feb 2021 21:26:37 -0800
Message-ID: <CAM_iQpU9FkMeMitC7nhw2P5bExEW3PuPkAe2aQY3Bg4XUfoXrQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 5:02 AM Simon Horman <simon.horman@netronome.com> wrote:
> Would something like this incremental change your concerns?

Yes of course.

Thanks!

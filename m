Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E0E2E7CEA
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 23:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgL3WBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 17:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgL3WBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 17:01:39 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA679C061573;
        Wed, 30 Dec 2020 14:00:58 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id y23so5917332wmi.1;
        Wed, 30 Dec 2020 14:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5S7hiS0D1Nz3L10rmwrKZxQbbBpU1CmnpvlYUU/6LEU=;
        b=Ru2Ww/WhliK61JsKemTEPiZMM1R5SNt/H3Soe5qqYF8/m/wlNro6WCA2lIECbrOFEf
         NGDoDylsZZlZSqsYRzWLAK1Y4Y+FVGJAY8O2tpiMBTtZx72k4VX10jphaMpw2nMEVRQ1
         P5TdqwLoDRdFrxurvPJBYXY29RPJwDl5P2RwDqaxayHIeCuRKl94O6PyVnpO/YaOUDoe
         jCNilYYk6J9IV/HFHp9dk1vvuiAqnYKycJDasRi8wTQm/6jGp6qJxtYiC/vrhoeYEfLb
         wSdhObcKgqW7yLVW8N/nic92TXIjLu6VHhDOuQEj+D5BQO0IZ0fLW5o7JXgqh6K04oMX
         vxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5S7hiS0D1Nz3L10rmwrKZxQbbBpU1CmnpvlYUU/6LEU=;
        b=p5N0/BX+/0TUd+5A62kP8v0kIOGj1TBumRLz1nH3SU6FNb0Zl+cEn692X0Y6Gg6X/C
         bk3YdTDoyR81oCGqzFAEAwxvj6vx8/syTaPXeDO5spcdK22KrSrHYAJAd5nx7xujKehj
         hs6/2klBbeUa+dLcYE7whs6gQ4b7Zz4m2CrqhtaJPz/wgZ92qPsgran/2+p9j3eNMkUj
         573plqmra3qYUhGbU4Dis/9qcAoKACDaU46O2Z0Guko3mk+uVrhFflLdr/CWqETqE9l2
         1UKyo7MW53ZD/f17iSswDk2MjFiTNfWAtSm0zpazJGwHVyvZgKX/aSHgXp1DUTVKr8pc
         7zBA==
X-Gm-Message-State: AOAM533UB6+lG82vBkEMf4zpkvtG6zzWaGI9cfLwcGy2/0khecAZ+zSl
        kTmeazIAeFjlxTfrEfJJlDzNkmJmw2PFvzosercFyLxQOGYm/w==
X-Google-Smtp-Source: ABdhPJxrO8bxLi/LAgoYnCE/bMU6bLerAGt+vc416K51PT7VCLFUUMgtmrVv0KmUcTUaO6NjCMm22d74MXLpliAaaYY=
X-Received: by 2002:a7b:c389:: with SMTP id s9mr8968721wmj.159.1609365657658;
 Wed, 30 Dec 2020 14:00:57 -0800 (PST)
MIME-Version: 1.0
References: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 30 Dec 2020 16:00:47 -0600
Message-ID: <CAOhMmr4QaJY6Mr=TByXaR5OHh-LxaV2w77dXtopdsHFAOZuuHg@mail.gmail.com>
Subject: Re: [PATCH] ibmvnic: fix: NULL pointer dereference.
To:     YANG LI <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        drt@linux.ibm.com, Lijun Pan <ljp@linux.ibm.com>,
        sukadev@linux.ibm.com, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 1:25 AM YANG LI <abaci-bugfix@linux.alibaba.com> wrote:
>
> The error is due to dereference a null pointer in function
> reset_one_sub_crq_queue():
>
> if (!scrq) {
>     netdev_dbg(adapter->netdev,
>                "Invalid scrq reset. irq (%d) or msgs(%p).\n",
>                 scrq->irq, scrq->msgs);
>                 return -EINVAL;
> }
>
> If the expression is true, scrq must be a null pointer and cannot
> dereference.
>
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---

Acked-by: Lijun Pan <ljp@linux.ibm.com>

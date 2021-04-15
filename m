Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B7436092B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 14:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhDOMSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 08:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbhDOMSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 08:18:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0DFC061574;
        Thu, 15 Apr 2021 05:17:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c15so14152322wro.13;
        Thu, 15 Apr 2021 05:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ibC8KmM3ZCO6n5K5dqW3bxYX4QNUATI5N281R+s5qAA=;
        b=oNZK03HGj+ZvH1b/HNRxfIgjoyumUjD/K+rzUToos9eqKxjiVCTL4ox6tqHYMeG4t5
         GvPWIddjAOZDrLCdTLPmf0zNk6D3Vra4zTI246kiHjwmHYvlwsjf/tzp9tCut2jX0aN6
         Xe2pqcjyKTP76rxzAlXfl5ic6pB0WduwKfxGSK8xq2Ywe2TOA30JEvq6iEjOCcQU4cFg
         IdVewnWBRRg0Z7cI8l/gs+Rw/2rPe83QQJ1Z7CWKrL+K0TyhgPjdcysILnFI2ry2MwPS
         fjTkLFEwJJ46LSm1dcQYl/J8LrwNICYt41o6jmpCQWbmP50zuHrA5dlb1uCCfMVacaFa
         PftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibC8KmM3ZCO6n5K5dqW3bxYX4QNUATI5N281R+s5qAA=;
        b=MU/ILdKEiXggz6/7XwHznoIHdrX6SUvtRSDTqmyF3kEehoWEJXwhqVgRhXYdFSazbu
         9c1yjcabEV9HRV9hiY5W4UqMa7WYz8VujOZ0TqisyQ9rZoPI8CQ+7sqt1+pWy1OHY5Pq
         kP1HEwGm5Csg4V+nDJK0B2qiRs37UyHBC80WFj0fKaWfHz+WeSiXoWqqfZHDbUIp9BAu
         PzG+4AGsFgMrCFRMNhgtzWzwh0ZJrfS1VtzEeZKSeb4Nvr/0oxc2PBPqISzwDQJ5YjAl
         i9N1kVxQ7brgG9s+ZUbhqDj8vkaIBrGfYn+n9YF6u7M6gXjIdT8AS75MibB5s1BPboPv
         qHUQ==
X-Gm-Message-State: AOAM532D39xnO0DqRnT+/ky8YDMjPRMQF2q0mMnjYiG2sahAoFThar0K
        lzj9g3DY398ztNkzwQ2kaxOVqVBpQsbjq0yfBeI=
X-Google-Smtp-Source: ABdhPJyL0i/v8U/mac9Wzdumse0AzYWVK9JOeMiZT0OMypDSStqaiyCKYH1gvPXzdNEV/Wmn/JQyWRObKpCee9Hu9Ak=
X-Received: by 2002:a5d:6a08:: with SMTP id m8mr3192107wru.57.1618489060038;
 Thu, 15 Apr 2021 05:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210415092145.27322-1-kurt@linutronix.de> <20210415140438.60221f21@carbon>
In-Reply-To: <20210415140438.60221f21@carbon>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Thu, 15 Apr 2021 13:17:24 +0100
Message-ID: <CADSoG1ssygE8XgkSoWW_WKf3Q43M6JGBN0fbUrrDfLsLyEy0=w@mail.gmail.com>
Subject: Re: [PATCH net] igb: Fix XDP with PTP enabled
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Doesn't the i210 card use the igc driver?
> This change is for igb driver.

The igb driver is used for the i210/i211, not igc.

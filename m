Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F100F44FE0C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 06:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhKOFIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 00:08:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhKOFI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 00:08:28 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BEDC061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 21:05:32 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id i194so10050140yba.6
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 21:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J0qLIAiCCeQaeMne00+YGcYkspJR1Ag1MB1rrFJNF80=;
        b=o1xuXN82UJoYSADlX1DazqLxiZ+H1Pdhwn9+y0JehesTjPw6U72amjfidFI6P6/QLH
         +vwhZqFWDVNtBBdu2SdNj1d5wcQ64Qc+uUjuK2eGLU7E6pCqaBVsMm6zKQ3tmSYulOHT
         mIWNVY4QgPa47Wdig2QY3K0XloIimuFSZa5A7WKrCB5Ji8AKk9g0Qd+8fi1XnvGNzXbx
         48Dt7BV1n3/QMWsvcrk72NKP1aV143enfcAJW87h1viGEsRcSLoAMqGDIlFVF1d7Z9PJ
         0LcfE4sdRzCcUDDHi4NL4bN7Jcx5P195tHJyFRzCtiEkZqDRAydNsoKLgeGXHUpJ67BG
         2sXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J0qLIAiCCeQaeMne00+YGcYkspJR1Ag1MB1rrFJNF80=;
        b=fyJ6u/VUV9HTlDVpsTUF7eYci1W9NrsjhuYWbWEKUdBx+kVJOUkgqnl9tyElkF0d6N
         bs6Siz4D9CP2fqFc6iJFH5pnqXLAoNz7WtpHIq1q9+YqrAbyVrikyoyhLeXjzd1piKQU
         2to7e9F9aFTpV9TolATiboMinp3gHRxh5skW4YS+hQkCdxgokWMHBoifhQW4Bxl/xX1g
         yw0ouY0ho8Bf3KER7XgddqDrZxRMS84zIHHB+hVRADTtY2YHowxKoVx+e0fxM2k74m2B
         aR4R4BW47zYurtWm3wf4lkfUqkrcPOoRdb9onajPUwcAPAA183YKYmL+6yuk/qfd3PiB
         eXWQ==
X-Gm-Message-State: AOAM530ZEzykZYr6vZxChOFA3YGotIe7qFNduZ9y585p9U3myBvnfonr
        6EgxvKHW0Ndyrb8btKkl7Q61Xr68GadIWHYz602Vx0BZHwY=
X-Google-Smtp-Source: ABdhPJxOuI/ubvUORY1Jq+Si7mwoo19fPCuIIofcmS3Y128YM5v21bn4kz6kmkQTF4iu6miZQYNQ5UGIvUFq0k6agUI=
X-Received: by 2002:a25:287:: with SMTP id 129mr40301904ybc.524.1636952731738;
 Sun, 14 Nov 2021 21:05:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1636734751.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1636734751.git.lucien.xin@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 14 Nov 2021 21:05:20 -0800
Message-ID: <CAM_iQpV7gf3QgWoFD=cyRtO0XT6Pu7=n5V5zCCuotWEtzihQLA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] net: fix the mirred packet drop due to the
 incorrect dst
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 8:33 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This issue was found when using OVS HWOL on OVN-k8s. These packets
> dropped on rx path were seen with output dst, which should've been
> dropped from the skbs when redirecting them.
>
> The 1st patch is to the fix and the 2nd is a selftest to reproduce
> and verify it.

Acked-by: Cong Wang <cong.wang@bytedance.com>

Thanks.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA5223B8BB
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgHDK0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHDK00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 06:26:26 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E866C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 03:26:25 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id j10so12044904qvo.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 03:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AsBjKkqZImxHPo+B+dow81uCwpXWkSPMIy018GV6yeg=;
        b=sWZNBURSbAWOt9b+trkAmKpabVCXpTXLRM1jDPi/a/wUdj82IC3iLxiIBeyIM4KWmo
         2CZ0/FI35QVs+J8dUax8yROemv4pin/LW5rWGfbhZDeu1v4CvucQKca/hEQQuHyv7wJA
         k1ZJS7soxJvzdVJrF8M4B+dPDOanzeVb+IpuUrQJvzLkwSXrYfuGs5w7VJIlYOF1Bn3n
         vdF5zDLqIwfXLT4MCdH5YwEFZdygdJ2OD5wRVLALubN9/eYrtkDv/YSUvjaHO4DPN3hc
         7b2mkiXQmwirsiMuTnqM+1ln2OWQjAiIsxq48iy+NMTacKXr27nku3d0p4MpYp6r9BQw
         v9gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AsBjKkqZImxHPo+B+dow81uCwpXWkSPMIy018GV6yeg=;
        b=gcLgVqZ+VzW6H52Hh4SOtwXpzp1fLAkol+TfV0ybYTryVUeWx1aO1kSsKBsuO1ZKM6
         zcjvKEK/NMD3qIGxdzItWFLWuhvitLIzUoQCPDA5/bNy6A0hKhkmoTJWolxicHJRrVIW
         Q/49BxPbFU58+zPVemk+LBP6pMo0I0ygEH8m+QViRTvolpHrJTwk274WMIzKr42kJopE
         qzlAr6lhiTjAySy8DJKCXctz2NStWX5mtxJkAH/lVk2W6caJu6dbwo9VZK9XoHHr5W7o
         XOQFtaLT+3gbVgVe/JlxaDZwiZ8y8EJucqo4kxqBKBgFD/NTTgEVyx4nnxwLxBccecPn
         ZYTg==
X-Gm-Message-State: AOAM5334TVcaeF333f3mCFh3+vy9MOwNaxMUNz8sFPZv2ItNmqgfhygt
        igDRxQFAR9hMc2wnTNiaJWgfAzAAtD+3CMravgE=
X-Google-Smtp-Source: ABdhPJw8Qn2tYpD0q/JTUMmrXWx6e9wnRpXOULQjP5fJ0cJHAshsWVjqAPiwkHW9v7C3vtoa0IUo2u6umS0P9KA/YAE=
X-Received: by 2002:a0c:9b96:: with SMTP id o22mr12505132qve.213.1596536784780;
 Tue, 04 Aug 2020 03:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200731084725.7804-1-popadrian1996@gmail.com> <20200804101456.4cfv4agv6etufi7a@lion.mk-sys.cz>
In-Reply-To: <20200804101456.4cfv4agv6etufi7a@lion.mk-sys.cz>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Tue, 4 Aug 2020 11:25:48 +0100
Message-ID: <CAL_jBfRyKxaFqU5m7oXNyfvC3_T_TVAjaF+04NV7rZksCqmszg@mail.gmail.com>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> AFAICS the kernel counterpart is going to reach mainline in 5.9-rc1
> merge window. Please base your patch on "next" branch or wait until next
> is merged into master after 5.8 release (which should be later today or
> tomorrow).

I will wait until tomorrow and rebase my patch onto master then.

>
> Do not mix unrelated changes like whitespace cleanups with your
> functional changes, it makes it harder to see what the patch is doing.
> Please split the cleanups (there are some more in qsfp.c) into
> a separate patch.

I'll create separate patches for functional changes/cleanups. Thanks
for letting me know.

Adrian

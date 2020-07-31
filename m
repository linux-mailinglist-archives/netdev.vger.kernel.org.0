Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC876233D0A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 03:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbgGaB5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 21:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730904AbgGaB5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 21:57:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53FDC061574;
        Thu, 30 Jul 2020 18:57:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ha11so6313318pjb.1;
        Thu, 30 Jul 2020 18:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=zBXnYdUEX8Q8zEVSbgNanWh7jg7JO//MtEogCqZsZmY=;
        b=MjahxHhbMzQjsWTnZdkXtSEoDZrYhLo5Nc61KX9bAO5krHkNG45tCqZ6JTcFnb9ONc
         4iFXKEQX+yRki/80NiECemtSeBdgNp6nRhPaXi7yLjo0iy5S7Fx1MWalGZ7DRVBUZjRH
         VX0SI5Sck/gFD0fvn2IPZd6u43kprzkNX8P82eByuIdiGhT9gMBxzHBYu9KNWbf4SsoK
         1hGPIzDCSV2YUa73IJm6ENTlhmB4FxvoXV9Qf0VdtYy+tFp7ih+Wvev3kzX4fIddPPDB
         hwrcd6o/K6fUp8AdykaOguYbnVlGUCgAPksI90kP33UfGwGJZRzRFwks3VuUJ3lngo42
         ywMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=zBXnYdUEX8Q8zEVSbgNanWh7jg7JO//MtEogCqZsZmY=;
        b=BCNX4+WOykM5QxB16aTd/RqENnRTW/BcSHHfGwcR3pXFeHpBx/DQn9O/OmorH4IAzF
         5g/7JMABxK39zzeSM00xL8CHlBOKrnqweL9Ne0m7BMf04A/jmzp5/z90g29c4NND5IuM
         34bYBSzWAvcRintXoD+jmX18zmWVDJJCjeJkfnz5ueqFggkRA+EkEN6v+0TcoqLzVlMk
         zyO+Ko1lANFz47cliHMjTwEahOqtvguGQH/o0Qf/tzy0r7wG/ThD2bbkMUBsc3ByBPBd
         9K+0ScVkOhg6MxRbpN7fZ0qCEsgsdtNv1yW+AbPyIyff2Isbn4o5RP+qSpAF0ejMrTPz
         Sg2A==
X-Gm-Message-State: AOAM5323l7IUX2ip6Y7oakiAf3jvO59vwbq0M1djegRtPXKYVPgxd1H1
        +8CEEQMxLqtM2cYOsmaxuokGvRTjh15XuXZQU5k=
X-Google-Smtp-Source: ABdhPJz/8rWvFfL3RYNGkSXt0XG/jGm0AD9t9sH61dYo2UYba4OvtdsmGt97JrhBIu5Py0mJDtGGRGqShBlFvE6XSOg=
X-Received: by 2002:a65:6707:: with SMTP id u7mr1512855pgf.233.1596160673490;
 Thu, 30 Jul 2020 18:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com>
In-Reply-To: <20200730073702.16887-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 30 Jul 2020 18:57:42 -0700
Message-ID: <CAJht_EM0SdezzQUJsdCxPjLk9Wz0SWnFkqxiFWUEEpQ-WO9JdA@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris has approved this patch with "Reviewed-by" in the v1
email thread. I really appreciate his review. It's very hard for me to
find reviewers for X.25 code so I'm grateful for anyone who could
help. Thanks to everyone.

Reviewed-by: Brian Norris <briannorris@chromium.org>

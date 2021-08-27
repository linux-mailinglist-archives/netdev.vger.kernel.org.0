Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A22B3F9F65
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 21:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhH0TBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 15:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhH0TBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 15:01:33 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B055FC061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 12:00:44 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id k65so14339551yba.13
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 12:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G7MtkrJRHcBHnSGKCalw+iRCRuvoTpW6oS4gWD+q6r8=;
        b=BFDOVNWRvg9W8omxPFraG7sMWCYX05+zVq2wRqTaZJCBbXtpRQptfYbiMDc4FiTlTP
         e/Q8MPW3HeQPN0ORwCSFci9AQDwo8xFYBYfDXnBHysTM3tFl9re8bDVVfXELgzEyNaN7
         gpf9ZJ8poseL5VTFg28WFgd9hB8MMUQAjZwbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G7MtkrJRHcBHnSGKCalw+iRCRuvoTpW6oS4gWD+q6r8=;
        b=R2bD6Se7ZAJFIf+l9cQFFjobghSV/B5lFpL6P+jF0+6DcoVECtuvH1csvQw2/UGBUJ
         tWbpqvV0gAybFutUlb/7DEEC9QGNiFRXXrJEyjKN5hLJ9/ihVT8PBiFe0UbQouP+CyD7
         WIsDnL0PHjocbRzHfgiDBSwsEeIzw6EIQfZFnz95xFzpszr0gyhaLXdWBhFE32+CUIma
         DgMbCafwLCFMtNKOtYu3uzqVRAAl6fy2WkScARIJtAL8DxiHiBOCJaS3/9v1XXbh86NL
         xSJGSyvcyCSS87wJ2aXiFEky7wk4XVwKRNCC5UboYlYE29UtwldhCapI3MAW+jyD5w3L
         Kf4w==
X-Gm-Message-State: AOAM531J/UTdvdWxiwcUiewlkM0Fd6jRFIZFBArCEWqe7HH3twRWet74
        Z+1q1ytENMEMZtLh5JXm1nWj9lEOhWyot3adpfazFvvlTUQMow==
X-Google-Smtp-Source: ABdhPJxVeiH9dphnhfNFuk729GEYUeReyazuKIXg3Lb1d8QzcW+LvuiSg6/GchudYwTKbRRcQzke3u/rIEB2HBigMOY=
X-Received: by 2002:a25:2542:: with SMTP id l63mr6753696ybl.272.1630090843848;
 Fri, 27 Aug 2021 12:00:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210827152745.68812-1-kuba@kernel.org>
In-Reply-To: <20210827152745.68812-1-kuba@kernel.org>
From:   Edwin Peer <edwin.peer@broadcom.com>
Date:   Fri, 27 Aug 2021 12:00:08 -0700
Message-ID: <CAKOOJTwChWKbSyjvRrtx-itGrDsZqoEfFYs6bpvSBk_Vfr7X9A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/2] bnxt: add rx discards stats for oom and netpool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>

Regards,
Edwin Peer


On Fri, Aug 27, 2021 at 8:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Drivers should avoid silently dropping frames. This set adds two
> stats for previously unaccounted events to bnxt - packets dropped
> due to allocation failures and packets dropped during emergency
> ring polling.
>
> v4: drop patch 1, not needed after simplifications
>
> Jakub Kicinski (2):
>   bnxt: count packets discarded because of netpoll
>   bnxt: count discards due to memory allocation errors
>
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c      | 18 +++++++++++++++++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h      |  2 ++
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  4 ++++
>  3 files changed, 23 insertions(+), 1 deletion(-)
>
> --
> 2.31.1
>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3848230CB27
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 20:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbhBBTOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 14:14:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbhBBTMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 14:12:21 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFE5C0617A9;
        Tue,  2 Feb 2021 11:11:40 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id j84so8312997ybg.1;
        Tue, 02 Feb 2021 11:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KGOLlL3VmlklLSLtTOQCOorpz7skAhQrAaYiiIt3mXc=;
        b=AGbpY123SzwXAhZmh+7h1fPD9QYPo7FRBr6njLYsJWiQgV451qY7UJ1T+1Tu2786T7
         NaaVBJk+z6RTBQPCBWtf421r9c8EpbU4ncC8gEkc0DG99Lp9QHWSXn9SQP+ykdgwxyKA
         uNPcsdPCi4OB6XwBNkArPFKsuakbVTlxGTP39JneEx+NCMWzIrd+SJjiJsGxkx9k4Drq
         ocaCvqiuDvxSn4jQA05d+H5WECheGlWQ7Mzmdx7uPupegRhyFXxvtbsaJB+I3aDe37XN
         ZVfX7wVW5TW40a86PavftNzt7jRrYC+oaLdOnJ8DuAhP/FdXyGxaG4NoAssk6hZt+JMl
         TQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KGOLlL3VmlklLSLtTOQCOorpz7skAhQrAaYiiIt3mXc=;
        b=Gc8KE4ir7Ou8x/oEF0g3klN/MqDy1QCAbCu2m0CXBIwR96kI/fXnnI9dOwD1zueVgn
         Mq/FWlalu5dv52invA9tXIN3fthbawUcCO39Kkb8Y5cMxbsTXkQsDn70XgvIDO4fOI9c
         T8cvdZx9bPFlLDK6kh3fpNvz2WzAM21N8BKDGWUYJ+h9hiAK9iUsA67aIabqi8rJHxgl
         YJWoeBkMXpBaPjfyXFo0dDxPLSldXjFKZS6ZvudpiP3DhdfB25xZ5qlCYdp6hBqH+CrC
         yU8PdLV4h/pz1suvIMNTKNtecSGJVjFOudpNYioXk2E7mrAcq93iUqpvC7+4ke5F+LwM
         USCw==
X-Gm-Message-State: AOAM531x/QfJ6zDY8R1AfWOavf9Fgi3Yji2zpcqy2uzex/JK1xRaoOgx
        SXKX1jF93lQ9QIT2cco5aJiK8N7tHl/7gLiqSsY=
X-Google-Smtp-Source: ABdhPJzmLPH+wJJ5EfcKW2fQztuoli3JW9JCYfkRC/VJJ/OCuD+DRu3DZMN+6ee45h1Zip0cbPbWZqebCuoIRDm/wRc=
X-Received: by 2002:a25:c5c1:: with SMTP id v184mr13084878ybe.56.1612293099895;
 Tue, 02 Feb 2021 11:11:39 -0800 (PST)
MIME-Version: 1.0
References: <20210202080614.37903-1-yishaih@nvidia.com> <20210202080614.37903-3-yishaih@nvidia.com>
In-Reply-To: <20210202080614.37903-3-yishaih@nvidia.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 2 Feb 2021 21:11:28 +0200
Message-ID: <CAJ3xEMid_wMdJ_bArXvzO1BCFJNU4s5_+555ywD3iW1DvdYztA@mail.gmail.com>
Subject: Re: [PATCH net-next RESEND 2/2] net/mlx5: E-Switch, Implement devlink
 port function cmds to control roce
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 10:08 AM Yishai Hadas <yishaih@nvidia.com> wrote:
> Implement devlink port function commands to enable / disable roce.
> This is used to control the roce device capabilities.

[..]

> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -122,8 +122,9 @@ struct mlx5_vport_info {
>         int                     link_state;
>         u32                     min_rate;
>         u32                     max_rate;
> -       bool                    spoofchk;
> -       bool                    trusted;
> +       u8                      spoofchk: 1;
> +       u8                      trusted: 1;
> +       u8                      roce_enabled: 1;
>  };

This struct has attributes which have e-switch vport affiliation where
roce enable/disable
is a property of the vhca function-over-the-e-wire -- it's that we do
something specific
in the e-switching to enforce  - sounds like a problematic location to
land the bit..

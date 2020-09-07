Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14460260618
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgIGVQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIGVQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 17:16:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE6C061573;
        Mon,  7 Sep 2020 14:16:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id u3so3703540pjr.3;
        Mon, 07 Sep 2020 14:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jEv+l13bPkBP4OOO6HkaA4yQbFTE9py5vEtLN31aW4g=;
        b=BzcxqGHVOYdkZE/nnHA8ZpbvIRerru6/9TGkmI3ESjmBTfOm89nzydtUlOeSYkUKgb
         22SVAiF0JGw3QvBkuEE7NswtB3pObFVfj80mQa7C2hCckc/FzGJCpF6iH3FC1GGpd+sB
         a0hvdEYF0l53MrbmdAXoZVnKiSNlU4vFEkb/x//x8qe28CZ6zLFk5T8XpGhKWpsaTfFA
         ewvUcgkEBAx9PDVIfHUML4YIS5Az/CkWApYyVQ2oRDMRM23R+CUgoYjSD4ghZzVfU1be
         Nil64Kbv7StYr1vXCOFmTFRrSIvZoUc0xouSOBZNqukDa+E4UNO1fQmAc2IDz5vsxtzU
         QlIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jEv+l13bPkBP4OOO6HkaA4yQbFTE9py5vEtLN31aW4g=;
        b=qg98Ejzoxgl13q/GaVgDrn9npDxoajXXqDgEqF4ofSN2sf4J+4w4bLlSqooEYKhu76
         UxnPqN+oI+yQljP30VtvWpSX0ewtekQoIYokSA1164Kh2eIa5JU0Es0IA2h5YpCndNNJ
         e4m/8pC27Y/KUMkc4AdXN9OrS1oRrMH+Db+E2vn4KMZq5hNzqPgJbko4CJifnHEGwkO+
         HghPDV2b2ezDudlh1lrb6EOmW5i9O8pnmHZMXXScE6ZVYSZShm7V2qV98X0bT8epUCzf
         g6tbP0BKQhCKa2qpaHV9qlmO5ss0sHWGMLJGOLVDWlPSp3lQKQpYez4g+ZABTWn16Qjx
         ZErg==
X-Gm-Message-State: AOAM530KOeDvWaghbkIuzd2F8pydAaS6n1VXfYGBm7m3LFCmYVjYdGOL
        yhaaPe2HxUkfUi8o5zTmsfDOmpsT/gZpeBnxDwQ=
X-Google-Smtp-Source: ABdhPJyrV4Rxe5S7NUnqsFSZFn7WjWk7sv6Vc2yz+aHCKxi5JmemKN84LlgOsNHpoHIOLCu8rwya5UeQ8wz8IycelD8=
X-Received: by 2002:a17:90a:bd02:: with SMTP id y2mr1024403pjr.66.1599513407260;
 Mon, 07 Sep 2020 14:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com> <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
In-Reply-To: <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 7 Sep 2020 14:16:36 -0700
Message-ID: <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 2:06 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> The CAP_SYS_RAWIO exception indeed was requested to be able to
> purposely test devices against bad inputs. The gmane link
> unfortunately no longer works, but this was the discussion thread:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg99920.html
>
> It zeroes the packet up max_header_len to ensure that an unintentional
> short packet will at least not result in reading undefined data. Now
> that the dust has settled around the min_header_len/max_header_len
> changes, maybe now is a good time to revisit removing that
> CAP_SYS_RAWIO loophole.

Thank you for your explanation! I can now understand the logic of
dev_hard_header. Thanks!

Do you mean we can now consider removing the ability to bypass the
header_ops->validate check? That is what I am thinking about, too!

I looked at the link you gave me. I see that Alan Cox wanted to keep
the ability of intentionally feeding corrupt frames to drivers, to
test whether drivers are able to handle incomplete headers. However, I
think after we added the header validation in af_packet.c, drivers no
longer need to ensure they can handle incomplete headers correctly
(because this is already handled by us). So there's no point in
keeping the ability to test this, either.

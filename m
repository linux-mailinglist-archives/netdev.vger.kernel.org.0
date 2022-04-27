Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4BD5123E1
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 22:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiD0UbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 16:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiD0UbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 16:31:07 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA522939EA
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:27:54 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id z2so3251340oic.6
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gp/F1d/4pAenz5mNMTTask9wErh38GRFBpgSf17aNWY=;
        b=Y0AbeCNkAgs0mjiUiyGZ/engX4b8WVlc02Y2wUD0hDGZhyPfy6Xt5PelzXLROAIYMY
         eVpRZE834J9mmhPAjJ299MhHB3z/7Wuo1ma5GxgdRNqWE05oroUNUajPWkOIKCBk3FO8
         JUCvvnkFoHNwWAF74dhzq6T0KmyitBNxK07d8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gp/F1d/4pAenz5mNMTTask9wErh38GRFBpgSf17aNWY=;
        b=ZB/V5HqoTewF9nMnL7qK6oiemsAM8Rd55LpMVTIyIINQgBQhBEj+DQb7uL8d3UY2Wk
         2DpqaHpiUtZIv0lfup4aSv5jFfoU/OrtEeSZbIQzWA6G5LqWfhHNnJUYzqB7zYHRZxv4
         yoVdKJXjmdaiUkxtIRK5oCeCtUQM2lFOqxbrbzT0qt3fRmsdVItAk8XlWeDd9g5ZBeRW
         VoGq2NUEzzY0ZuGWa1CXppbj/l3PCtfMuvk0K1kTUgYrB3HxsyXgUoSYscRkbA53nbrH
         HpLg0n1DG/0vJrgTUG3ZPrQcmI6vdQz6MDlVZbzvBrtWMriaGSMyRL9IsD15E7eljkmI
         1jZw==
X-Gm-Message-State: AOAM533yxIsFOUlMT7f0Qlrvb7xjvfJHxoLciBcTESvIwkTrOIdTDrcx
        6ZP3sOj98qUn3H5y4JdbBr/tX/qC0iMbrQ==
X-Google-Smtp-Source: ABdhPJwIKpt7ZwMRCOiUTKG5veLov2bRSUtS+geu/ifpmWrl9ji0FGo/apEAhIiHqfcunL+5caig1A==
X-Received: by 2002:a05:6808:13d4:b0:324:f835:d2e4 with SMTP id d20-20020a05680813d400b00324f835d2e4mr12010064oiw.262.1651091273502;
        Wed, 27 Apr 2022 13:27:53 -0700 (PDT)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id y26-20020a544d9a000000b00322656e2988sm6139467oix.39.2022.04.27.13.27.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 13:27:52 -0700 (PDT)
Received: by mail-ot1-f54.google.com with SMTP id w23-20020a056830111700b00603c6d1ce73so1838034otq.9
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 13:27:52 -0700 (PDT)
X-Received: by 2002:a9d:58c3:0:b0:605:9fa7:f5b6 with SMTP id
 s3-20020a9d58c3000000b006059fa7f5b6mr7777249oth.230.1651091272112; Wed, 27
 Apr 2022 13:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220426221859.v2.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
 <CA+ASDXPNFwvYVBMHjbTNQ-uTnQrs5TvPAH2jXgPKuFLUw2GbZA@mail.gmail.com> <CACTWRwtXSHnhxTEZ+pWWNpfd-BANtHuNUDimmwxJ=COL6HJQTA@mail.gmail.com>
In-Reply-To: <CACTWRwtXSHnhxTEZ+pWWNpfd-BANtHuNUDimmwxJ=COL6HJQTA@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 27 Apr 2022 13:27:40 -0700
X-Gmail-Original-Message-ID: <CA+ASDXNLnb4OEZtFVb4D64QNkK=sGYUUVuZPwO1-zOOD0hfqyg@mail.gmail.com>
Message-ID: <CA+ASDXNLnb4OEZtFVb4D64QNkK=sGYUUVuZPwO1-zOOD0hfqyg@mail.gmail.com>
Subject: Re: [PATCH v2] ath10k: skip ath10k_halt during suspend for driver
 state RESTARTING
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     kvalo@kernel.org, quic_wgong@quicinc.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 10:20 PM Abhishek Kumar <kuabhs@chromium.org> wrote:
> On Tue, Apr 26, 2022 at 3:34 PM Brian Norris <briannorris@chromium.org> wrote:
> > You could have retained my:
> >
> > Reviewed-by: Brian Norris <briannorris@chromium.org>
> >
> > but no worries; it's just a few characters ;)
> Oh! sorry about that, I was under the impression that if the next
> iteration is posted, then I cannot just add the Reviewed-by tag
> provided in the previous iteration by myself.

You certainly *can* add it, but it's a judgment call on whether you
should. In this case, you were only making cosmetic changes (commit
message and comments, requested by reviewers) between versions, so IMO
that's totally fine. If there are more substantial changes between
versions, it may be better to skip it, and let the reviewer re-review.
Sometimes a reviewer might even explicitly say, "with changes X and Y,
consider this Reviewed-by: foo <foo@bar.tld>", which is a pretty
strong indication you can add it.

Anyway, it's probably better to omit a review line that should have
been included, rather than include one that should not have been
(e.g., because undesirable changes were made). So again, no worries
from me!

Brian

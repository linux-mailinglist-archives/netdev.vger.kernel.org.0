Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6652DCF4D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 11:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgLQKMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 05:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgLQKMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 05:12:30 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A56EC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 02:11:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id o6so13840882iob.10
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 02:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gLrbAFFAHJHjywS2rIo87q673wSDZMq9mFk9GjN+IYQ=;
        b=HUT763XOfXW02iu34onRqKffReyQ0zGX5rUfgdq0NT10Ul7eqYY0AJss/gNHabrDTf
         So6cN+Wr80ip1aFLYOKiIowo0SA8SbNOtrjbe8fUCIo2eVSDlsEpjgXvhmCVAUC/72LE
         n3/RcWhczaF90y521tNRMghEhux7UDjrPuypkykXPtpgKsOXg/6SIBNNX8kYFJG9Xc0X
         UPbUerMAOc+P1zMTXqVOzRvvYLKWMmn7fNuMWVih8U68UXglchq+Bg9s1DfaQDfcpTZM
         WGeC9tugyfVlTkpjJJyB07VGBH9+VYV5rmrsdge9lUKe76Nl5jZlWQslQeP5c+8rrcT+
         MPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gLrbAFFAHJHjywS2rIo87q673wSDZMq9mFk9GjN+IYQ=;
        b=CHQrVfJIyYGjCC0ZLbG3tVwHbIdAPccJ1X9QzEGOhnZQcVoz7/ozfSVJ683dvGf91j
         fSBHxmgB73M3569Y9XOVYeqTiC8h1Ag8QeraUcm40raENeLXxu2J7pM5ylOKjmiD4UGe
         Y2tCys/l3Y6t8goDqIFzrra8M0siQQn8kHT7D5zNy4jTyVWldJkkvqFarIqZRXWXNuC0
         neJdJlEQUKvG54WloHvIceJrLLpP71KNLzM+t5dRXK3GqbxVB01wplrvrJH2/MSUVdw3
         60tE4FxcTlbnEExgeo4IJAcuKQYEof8QZjUG4PUndH22XzfbOkcDOvIbha4tTHmZLbiZ
         0J/w==
X-Gm-Message-State: AOAM533/n+9BIb+goytDXlxMIYlMlxzypYR2SQ4E29goJ0ihWwuWsSpb
        jd4TP3VVrOEVoh/GIiE6IK89ebnGBbXYbLxBNoj79g==
X-Google-Smtp-Source: ABdhPJykGuxIpKwhh2nNJ482nmV9/tZXMnsizi6baqpn+wI86ySnEfOuwsnR7pHqPx5oERNE91g9GTWtpWzQMCkbszs=
X-Received: by 2002:a6b:928b:: with SMTP id u133mr45530897iod.145.1608199909474;
 Thu, 17 Dec 2020 02:11:49 -0800 (PST)
MIME-Version: 1.0
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com> <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
In-Reply-To: <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 17 Dec 2020 11:11:37 +0100
Message-ID: <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200 upload
To:     Ben Greear <greearb@candelatech.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 12:59 AM Ben Greear <greearb@candelatech.com> wrote:
>
> On 12/16/20 3:09 PM, Ben Greear wrote:
> > Hello Eric,
> >
> > The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
> > when using ax200 to upload tcp traffic.
> >
> > When I disable TSO, performance goes back up to around 700Mbps.
>
> As a followup, when I revert the patch, upload speed goes to ~900Mbps,
> so even better than just disabling TSO (I left TSO enabled after reverting the patch).
>
> Thanks,
> Ben
>

Thanks for the report !

It seems drivers/net/wireless/intel/iwlwifi/pcie/tx.c:iwl_fill_data_tbs_amsdu()
calls tso_build_hdr() with extra bytes (SNAP header),
it is not yet clear to me what is broken :/

Can you confirm which driver is used for ax200 ?

I see tso_build_hdr() also being used from
drivers/net/wireless/intel/iwlwifi/queue/tx.c

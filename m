Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA412D3F18
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgLIJsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgLIJsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:48:07 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22BCC0613D6;
        Wed,  9 Dec 2020 01:47:27 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id t6so657993plq.1;
        Wed, 09 Dec 2020 01:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b4A649US2RSjSG56Wpb3xGYDuFzhFS6kVon+ebN8Xnw=;
        b=dr6evVSuCSSujnXd69aFKGCFoZKyB8grToLAabFTKI8pxrk9OaRujwctoy0rv8fcAF
         c8WuOKZYh7EqArO07lXp49Aj3qPrs+biAo8YEwxD3sA8Gb5q1/b4jCkvv7zcRkAb2vyW
         xZtLOmst5oUXbx3cPMBTAFH9My6uH8LSjaZWmLT2LvrG35Zz7gPKtCnx3WT+ZsblI/ly
         v8SIetipSMLRStjoOGjT3uZJjj0QErxtzrhWWQ16ZJ1ulqeQpUvXvtquxenSzjjKWUPw
         I8+K0rwOPHvPE6h2eYdNaWlEUdo2rC7L7qMUWW0NwOsosrQeBofKPaM30rHEvZZc/qjm
         HVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b4A649US2RSjSG56Wpb3xGYDuFzhFS6kVon+ebN8Xnw=;
        b=R2T+YRLaykfXTFGd8Bq2P2mY8c7ETniLFqWz/dW41jMMfnjBEETF+8wI2Bld85lYXg
         DUIjw+cMDcppFgDoDzHaFxV0Hts8gxdjmtJpgSmVYHuggXyoBMXzwvrxwrmtdBXZhUB9
         88ifsFIoQBJUctUmvjKpi8nuVUnu7ahYgapc6Z7zfDXqXT7xbRT5CInDA9+Umy3TgYSK
         MRMXYu1bVWA/f9FQJ7jxkqtmIi8RXo1wqzkfHMEDp3sGoa6YBt0zT2v6ywplJKMkeblw
         nKyDo/XX1uPNTHlFaOMhccCdSdB3wmi0SpbWKJv7/AFKI0lf5RvERyrDGdzIDEYIiAz5
         b0WQ==
X-Gm-Message-State: AOAM530hcpmifnoMBWIDR2hIdOuxl1ddcUWveKUdHr5HfIDOHWH0buG1
        FaMNVzyRyEQsJhoSQDGPTZK27XL9ucBhhCi0OjA=
X-Google-Smtp-Source: ABdhPJyOnGX5jcPCCCm50Oz3Ae5/LQ4R8o6L2HZgYTu2pH+jeczjkvYYioVg4w9Dd2gZudE0zGW6ivi+aXcEHJMgVBA=
X-Received: by 2002:a17:902:6b45:b029:d6:c43e:ad13 with SMTP id
 g5-20020a1709026b45b02900d6c43ead13mr1440385plt.77.1607507247288; Wed, 09 Dec
 2020 01:47:27 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
 <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com> <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de>
In-Reply-To: <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 01:47:16 -0800
Message-ID: <CAJht_ENOhnS7A6997CAP5qhn10NMYSVD3xOxcbPGQFLGb8z_Sg@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm handling
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 1:41 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> Right.
> By the way: A "Restart Collision" is in practice a very common event to
> establish the Layer 3.

Oh, I see. Thanks!

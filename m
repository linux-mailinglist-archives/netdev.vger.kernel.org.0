Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CCF2D3E61
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgLIJST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgLIJSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:18:15 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33917C0617A6;
        Wed,  9 Dec 2020 01:17:35 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id f14so540804pju.4;
        Wed, 09 Dec 2020 01:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i2g8fi2sxo+IYXz2d5FDftsnAsDKdKjxlec5gNvekGY=;
        b=V6/jPHRRgiTymHfuMZyb/AiGMPLMq+CJU0v27LXBnECGFfDkcLWpUWzuJXZptEj92B
         kLleVEeTmpKMCxuM8yxikC5Eb6kxkos7EbpTdLM/aMHiWnydV1WdV3H9pj2LdkMNY5Ma
         OhwXxVniM2lO1tXypIYpCRMTpX7L2uan0DOdds81TrHybMVcOePo1PmZ42e3zjiDM2Oq
         cNjinS5DydvEKhlN03NSvTQ4qFMLilhKTMyuRsjSPY2CvhWqiX5qfOl72dVtMBNpmknx
         CK19ZEaD7LOaGhSoPouHVLzwmbEBJYCrFXA8VXeNfU7dbWsoxEYxYIA+zEFa5DC5LF+Z
         HzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i2g8fi2sxo+IYXz2d5FDftsnAsDKdKjxlec5gNvekGY=;
        b=IyCLI5q779av7zWaEe4IX8obSWm5FHpClYHEfPSixWHLxMGh9s1lR6gTGORgTNMNPp
         w97eJM0Qwf67HGod8m/LFN3WHGNKtbJTuQ6G5Ekx0QrV1AB7eg+QurazYSEQKP4LwlK8
         XGEMwt7+GskHPf0czzG/SgaA4g458NuqzlAVKixvCF6gRYdZbjDo8r5IQpnRJA+zYvqN
         qOz7PeMZtdsBgCSAjX5tOcpiGvLnvFFzZTgKF5ltaeFtwx62atep8Mge3KQmQ1GBdp9/
         5QwpBh/8o9sSyG/8asDxbYgHb8aPVrqpiz+EZEL/0cBVCXVbso+6kzvGtH2JerdIoDGJ
         MHtQ==
X-Gm-Message-State: AOAM5309bp7roXWpNzXhB98iFcsnpu048twjivyvDM55kINC63ZMpyQN
        QqlhMk8kzIzepReU37Wu+jTCwW+TJJFof+nD6Bk=
X-Google-Smtp-Source: ABdhPJydnttj2HP+zryV972A1lZBqSE8aPXL4ogf/X4ErYcEWyz7giGIZGF0j9NUg92kj7u4adoUYYJFL22VLxjqDcQ=
X-Received: by 2002:a17:90a:6ac5:: with SMTP id b5mr1380925pjm.210.1607505454793;
 Wed, 09 Dec 2020 01:17:34 -0800 (PST)
MIME-Version: 1.0
References: <20201126063557.1283-1-ms@dev.tdt.de> <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
In-Reply-To: <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 01:17:23 -0800
Message-ID: <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
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

On Wed, Dec 9, 2020 at 1:01 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Nov 25, 2020 at 10:36 PM Martin Schiller <ms@dev.tdt.de> wrote:
> >
> >         switch (nb->state) {
> >         case X25_LINK_STATE_0:
> > -               nb->state = X25_LINK_STATE_2;
> > -               break;
> >         case X25_LINK_STATE_1:
> >                 x25_transmit_restart_request(nb);
> >                 nb->state = X25_LINK_STATE_2;
>
> What is the reason for this change? Originally only the connecting
> side will transmit a Restart Request; the connected side will not and
> will only wait for the Restart Request to come. Now both sides will
> transmit Restart Requests at the same time. I think we should better
> avoid collision situations like this.

Oh. I see. Because in other patches we are giving L2 the ability to
connect by itself, both sides can now appear here to be the
"connected" side. So we can't make the "connected" side wait as we did
before.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA18F2A18A9
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 17:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgJaQBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 12:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgJaQBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 12:01:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A24EC0617A6;
        Sat, 31 Oct 2020 09:01:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 62so144645pgg.12;
        Sat, 31 Oct 2020 09:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SG3f5svjXf2f1EgY9DXxkKCpMFLRF1AuO1lwwb5s+kw=;
        b=sQiODmct9TJt4xS5epEvZKocPwnb2J4c55DvShDrLdcTClhwWVBDhJrnvPbTC739h0
         /iJ1/x0C3lONcD2INDTqIxxB33/fqfq+nuMRXR4R4cchOk77k/ccvD6E7hLYBnlLGPPL
         GHhfMN4ynhZGI4tc4BIqTVeeXrVFZfMHezWDao6BPuV3Fjn4S8TBVR/5QYmenuWowTBj
         AsZChX6cRmfLQWWok36EZB4iXtO//WiNA1xlvgTROTMM8nC20QM0Np1A+YUKGDlLBxnI
         7e+11tbCRP5Jf8tOaWzWlazZPbZ7Ti7h1NXbbONlK/zrAYwARA3F+xTfT2K/x17jHOV2
         NpLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SG3f5svjXf2f1EgY9DXxkKCpMFLRF1AuO1lwwb5s+kw=;
        b=ofImOQxU4UUFSThdez9plpiaQmllgRvvKzX0b8qM7pR7XWsV/OQtKdCfK1l7TZKOZf
         1/ZG9J2EhER7g5OvX5wONPWmxohRr0JECKxDpulpl23ZyAhW3LIbZsuAmM9NK6YCGbGy
         vs+wrASwxti0mvwa1aBadu0o6/qrYGtP71kb1NZ6pRtsVNGkWUxVXwhXv2OPWYV1wyMd
         kd0bsLJ4+v5qhF9G0Y4U84VPxN8D/g4q7Rye88bAjnsjb/aYERytXRBgp9kEPWCXDc/l
         4R6qPVtIbdT3iXpH6AeAVU20DLSVvphDz9Gz/sR46ebqhULG8/x1EaWZropAzB87tpZq
         fh9Q==
X-Gm-Message-State: AOAM5319b0lm/ilgdQp/ZrvvaUuynMxMlIc4rVKjeldfsyo0WRC8/X7M
        GBBJEcIEZ9ytqB9oSB5AI7J3XVqO4oWWUdUw1X8=
X-Google-Smtp-Source: ABdhPJx9N+jqcWaKf+vw7uJGoA0ca7HVfyPiyp3dow8y22Tc0teTIP3txTjR/TTIfhkslB+02Qv9pBMbMVS7QftICrY=
X-Received: by 2002:a62:3004:0:b029:156:47d1:4072 with SMTP id
 w4-20020a6230040000b029015647d14072mr14370826pfw.63.1604160101823; Sat, 31
 Oct 2020 09:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201031004918.463475-1-xie.he.0141@gmail.com>
 <20201031004918.463475-2-xie.he.0141@gmail.com> <CA+FuTSfKzKZ02st-enPfsgaQwTunPrmyK2x2jobZrWGb16KN0w@mail.gmail.com>
 <CAJht_EOhnrBG3R8vJS559nugtB0rHVNBdM_ypJWiAN_kywevrg@mail.gmail.com>
In-Reply-To: <CAJht_EOhnrBG3R8vJS559nugtB0rHVNBdM_ypJWiAN_kywevrg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sat, 31 Oct 2020 09:01:30 -0700
Message-ID: <CAJht_EMgt4RF_Y1fV7_6VdzbMu0Fn8o+yW8C2RfnSsLjqsm_cg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 1/5] net: hdlc_fr: Simpify fr_rx by using
 "goto rx_drop" to drop frames
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 31, 2020 at 8:18 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> > Especially without that, I'm not sure this and the follow-on patch add
> > much value. Minor code cleanups complicate backports of fixes.
>
> To me this is necessary, because I feel hard to do any development on
> un-cleaned-up code. I really don't know how to add my code without
> these clean-ups, and even if I managed to do that, I would not be
> happy with my code.

And always keeping the user interface and even the code unchanged
contradicts my motivation of contributing to the Linux kernel. All my
contributions are motivated by the hope to clean things up. I'm not an
actual user of any of the code I contribute. If we adhere to the
philosophy of not doing any clean-ups, my contributions would be
meaningless.

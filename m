Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30562A46ED
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 14:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgKCNwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 08:52:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729453AbgKCNvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 08:51:31 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EA0C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 05:51:29 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id y1so4973251uac.13
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 05:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyUYOcjllfFZt74DfN+Csqx5pBnDAf0Ujg4JJ2J6DWI=;
        b=D3+1Gx4Mvug++MFnpMZ6W6WrP9GjI4Nnkl04l9thXx4ygrWTuubcyof9vR8jiJby3Q
         8g51nnx6Z9IPk4/2BH1aQdup5vDm0qu/uuhQhgRnM5oVyBYq3wiAw+REqhgxxCeGyYwP
         z+h907vWorEpf/kGXyXGcojoQyJwo9OBt+1e5uC7LbwaYPzvvl7CSS5MNUrUbAJIRqsX
         cGWoX59Obqcs4W9Y/so6Sruw6/PsRm3GJjoS6sN7PRfX20Si9tI9ZDxlRRg3m870wzZE
         f6NwnAASZuQk1Zx6KWiX/DAi+OEiSFgClfXkiN4I9ktJl05cJ88JYY4urWZGkgASmgSC
         UWLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyUYOcjllfFZt74DfN+Csqx5pBnDAf0Ujg4JJ2J6DWI=;
        b=IcuC6STyxhvV3yFS5LFM5sB9LumkQrkswYuFZ5exC7y/7HQceNhnEvlyAt5dpi46aj
         7DyCjfcomjLI6svMxeN1kmieYCz/mPFVLn5pDscMvEDbTnhyxwIaQ0vmfn57hok7Kq5J
         kEpPDYDoXePvpF8Qsg1ZIAUg6YzP4w/iIGZMnWxVlFrzcrH9wB9W9zAM3rGysHOmM7eM
         QqaYP2bIFpAPUEjgAU1vYHQoqCuQOcZ2ViFJwmw3davqyhAiDLNwC0/j/0A444mJc348
         pP5a+6cK7IqCVnyDEPRakKdbO830YYwA+Y9ywYLM5Imk6K7p+728PmuPbE5zvuJzOmNR
         mYYg==
X-Gm-Message-State: AOAM532qeY8V8bqMmDDnePyXwUGJuT4RJfH/JzxPNgMmU8tfKvgIBMBD
        1Wzr6E2L3FKgRDDyuzqNo0NnHJ3z3jQ=
X-Google-Smtp-Source: ABdhPJwGm6/yBXgP6NgcorR9hp4D/hG7QyQTpUVHNlv8XSrpYYFMJ6unQCxwS6Xt5Evm2lcljrCBSw==
X-Received: by 2002:ab0:2397:: with SMTP id b23mr10011440uan.61.1604411487291;
        Tue, 03 Nov 2020 05:51:27 -0800 (PST)
Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com. [209.85.217.52])
        by smtp.gmail.com with ESMTPSA id l16sm558353vke.27.2020.11.03.05.51.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 05:51:23 -0800 (PST)
Received: by mail-vs1-f52.google.com with SMTP id b129so9488622vsb.1
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 05:51:22 -0800 (PST)
X-Received: by 2002:a05:6102:240f:: with SMTP id j15mr8193952vsi.22.1604411481813;
 Tue, 03 Nov 2020 05:51:21 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR18MB26799492A423DDB096B05F45C5110@BYAPR18MB2679.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB26799492A423DDB096B05F45C5110@BYAPR18MB2679.namprd18.prod.outlook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Nov 2020 08:50:44 -0500
X-Gmail-Original-Message-ID: <CA+FuTScjywqryEsqtj6EcRcZWbUqYZ+CBQRGtcm_EXuTOT8j0A@mail.gmail.com>
Message-ID: <CA+FuTScjywqryEsqtj6EcRcZWbUqYZ+CBQRGtcm_EXuTOT8j0A@mail.gmail.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: Add devlink health reporters
 for NPA
To:     George Cherian <gcherian@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >  static int rvu_devlink_info_get(struct devlink *devlink, struct
> > devlink_info_req *req,
> > >                                 struct netlink_ext_ack *extack)  { @@
> > > -53,7 +483,8 @@ int rvu_register_dl(struct rvu *rvu)
> > >         rvu_dl->dl = dl;
> > >         rvu_dl->rvu = rvu;
> > >         rvu->rvu_dl = rvu_dl;
> > > -       return 0;
> > > +
> > > +       return rvu_health_reporters_create(rvu);
> >
> > when would this be called with rvu->rvu_dl == NULL?
>
> During initialization.

This is the only caller, and it is only reached if rvu_dl is non-zero.

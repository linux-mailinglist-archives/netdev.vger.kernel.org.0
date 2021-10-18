Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE64329E9
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 00:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhJRW4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 18:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRW4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 18:56:41 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BBFC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 15:54:29 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id o26so2533145ljj.2
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 15:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8vVcrdU/tUfwMi/BTjOJQv7MSKsG0vXan0R3OIx3tww=;
        b=DxugQxfEEMbgXTkFOSCLBJqTnUougZHvk4WxPSK0zKyI3NhGaBu/vTaqYKe4w7IkV+
         oKfezYZdBnwy3HhqVWvDvpYsKEP74YEgVTkYL6HaRCIkYi3qvep/PdtUiqKPLtFtXQPu
         wDcBNg6410BoVuALY/xW+aGgDLN4GnwTLioornGq08T3SQfpOTFn2h5YLGS+e0fkMs4Z
         YzF4LxyadRO+XWJrjkAWubmsYKTNaRny8ql7A2WacQfDxz5l8iEwRzpgdGzfbpnxwniq
         XEDf/jEPNFmv5M+edIJ34cPwMWxhpLXiPJt1cmwsHiFuzo+cs0sjLYWKS5wN0u/qDySk
         o1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8vVcrdU/tUfwMi/BTjOJQv7MSKsG0vXan0R3OIx3tww=;
        b=4qU+SV60/XG41yV+QoOChDHwSNyBuSNNN2Ct695tpYUMczLwgNG3ElPooxreBx3u2S
         X1mZbnZaTVblwu9iLYmf7NRQw8G5gUewboyyK66FCKz7zXBdqeXPSjq4O1QGSndiJFx4
         Bg9DK49zBSOZfPouucIzuWHZ8wllV59jGL2qIoSDr3qhWPh8w3LQmhb38WECBq7BJF+S
         i9LwSqaOJI6YZu9FACEOISMlNdfRiD1hGP85jJH73u0xNGEQNhoMTdtiZYDHMOB090xu
         GWLk7V/fjMpK5bE/h1H8/HS2lSQz0AVpD86oAJxeyzinQr8lZgSV2Utj8Gm1a5Do8WBS
         pcJQ==
X-Gm-Message-State: AOAM531tPqz+C3Gil6pPKLgUX//e6XlMKFBvZ4rCkFxSw7i2R4mYJn38
        lcUkvLbonfCTNHlVjM+n8sLDTxBWkjIswf9FqLrBN5n8
X-Google-Smtp-Source: ABdhPJzNTUlq1f3BFBYsHKt+lzqG9RzN4cmd1xpe4g65jmOK/qGL2kuuC2DfSWwxzX+Sme0ap9ENQhYItxVMpjmkHsg=
X-Received: by 2002:a2e:5c8:: with SMTP id 191mr2782999ljf.107.1634597667788;
 Mon, 18 Oct 2021 15:54:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211017145646.56-1-ansuelsmth@gmail.com> <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ansuel Smith <ansuelsmth@gmail.com>
Date:   Tue, 19 Oct 2021 00:54:17 +0200
Message-ID: <CA+_ehUzHm1+7MNNHg7CDmMpW5nZhzsyvG_pKm8drmSa6Mx5tNQ@mail.gmail.com>
Subject: Re: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in
 setup and add cpu port check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Sun, 17 Oct 2021 16:56:45 +0200 Ansuel Smith wrote:
> > Tidy and organize qca8k setup function from multiple for loop.
> > Change for loop in bridge leave/join to scan all port and skip cpu port.
> > No functional change intended.
> >
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
>
> There's some confusion in patchwork. I think previous posting got
> applied, but patch 1 of this series git marked as applied.. while
> it was patch 2 that corresponds to previous posting..?
>
> Please make sure you mark new postings as v2 v3 etc. It's not a problem
> to post a vN+1 and say "no changes" in the change log, while it may be
> a problem if patchwork bot gets confused and doesn't mark series as
> superseded appropriately.
>
> I'm dropping the remainder of this series from patchwork, please rebase
> and resend what's missing in net-next.
>
> Thanks!

Sorry for the mess. I think I got confused.
I resent these 2 patch (in one go) as i didn't add the net-next tag
and i thought they got ignored as the target was wrong.
I didn't receive any review or ack so i thought it was a good idea to
resend them in one go with the correct tag.
Hope it's not a stupid question but can you point me where should
i check to prevent this kind of error?
So anyway i both send these 2 patch as a dedicated patch with the
absent tag.

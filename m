Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BCB251C92
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgHYPq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHYPqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:46:47 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5B5C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:46:47 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p18so10798554ilm.7
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 08:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yo7vuJuNGYATOvAooQWHDcRL+YJigP5a4VJPvRdRuoI=;
        b=SdFEsqPOehoS3GwUylBuBuG5cz3gjeHbhkhBLWbhWRzWCga0nGWLMfz74r8qDP4m3A
         iHMaifknPMe9YIvc65DfDF11E+LeduD+HEH9yycx4cHDuTruDdlxRYYuO7G7v31E/vNr
         SAQnuRdJGvNhEj0DSpEuYIzOmvbdXw4MpANjhSbhDimBh+c+3zzHQbMHhDsIP8iDfkfy
         oqO5b9Te6iunb/ASbGcgXT1rnqkKxUKiXjQmGNNPLvt+U1U1tqUes1hnbFjrfuPMp5nn
         49GxLR81Oq28gpceLhNCPu1IQ1DQuHE/tQ3yGYu0k2nnuzU9SJ6+ez/0jYNQloHlvdM+
         DURg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yo7vuJuNGYATOvAooQWHDcRL+YJigP5a4VJPvRdRuoI=;
        b=BkjT7zvPFObQSBPghMTLveWglm5TWqdwtMJo4SgoXci0SefoHJbTRQ2VGOmJS6zvkm
         azXtjCzgebOyKI3+B+nnNtPNNNNh3x4lA+Q5eHyMLF46iNDdSZGZU93/X8xr/qsk28QL
         d52PF2VGnR5ssGE9rAhixi8wCXlBfBpePBaTqtLNXrXui3TZjBCiaLOKt6ryIlyK1TUZ
         xMcUnMWvtQfD4PuVH2gpABtMBtVo2ghHJ1NLXVrLAAtZ5GUtqcx4dOslxxGVRRhwr5kq
         Q8Z9grPCpLsjnJ2FKVUeiplE5yLQT34XFj5yVd6nXonj6f9mnQ2rJsayEidngikKhYbN
         2XCQ==
X-Gm-Message-State: AOAM5323GuTUNjO4PikMBxyWBTugzPgdoAKYE8tLtH6WtcUpl7VsJy/R
        XdibmrfAfx+wUzHq/aZj+0jIZrDlWRPDqm8t4WnTzg==
X-Google-Smtp-Source: ABdhPJyjwIqtPtmxA8xYOlTCHac7patEKln3XmfT2mgqexZkRnbO3H6dp4Pt3Uhzmyh0UbLk0CBeLDQg+itRzkmSvFI=
X-Received: by 2002:a92:505:: with SMTP id q5mr8886842ile.15.1598370406290;
 Tue, 25 Aug 2020 08:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
 <20200818194417.2003932-8-awogbemila@google.com> <20200818203629.02b62914@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200818203629.02b62914@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Tue, 25 Aug 2020 08:46:35 -0700
Message-ID: <CAL9ddJcwy9QoJ5=N_A+9PK5aU4HVTxLxyZVjy+7niHcoQMZ-Yg@mail.gmail.com>
Subject: Re: [PATCH net-next 07/18] gve: Use link status register to report
 link status
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Patricio Noyola <patricion@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 8:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 18 Aug 2020 12:44:06 -0700 David Awogbemila wrote:
> > +     if (link_status) {
> > +             netif_carrier_on(priv->dev);
> > +     } else {
> > +             dev_info(&priv->pdev->dev, "Device link is down.\n");
>
> Down message but no Up message?
>
> > +             netif_carrier_off(priv->dev);

Thanks Jakub. I'll add an Up message to make it more uniform.

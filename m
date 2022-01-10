Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1466489004
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiAJGIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232910AbiAJGH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:07:57 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B3CC061751;
        Sun,  9 Jan 2022 22:07:56 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id d7so2245358ybo.5;
        Sun, 09 Jan 2022 22:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ApmvpejRXpHVyHVDcTHhYixhKcbtDbVxNdD1J4DMsYQ=;
        b=KSeRxba9oWjGobstF9EB9RqubnnCU0F26pEjljGZTrSgHQ5Mc3JFolgpDM2GcKxnsx
         shjc/o1jIR6RBeH4XDWs2Ir1MMYSR9nHDgqzvm5JmzkQ7qj2Sk1mgeMHvN6xpn2MXGp2
         RFIvZgWS++ctKQKPZUsM3nz1ujRPhbDEDInjNcM4CLLrHN0Nkx7kaeq5D0YlVr7EpFFL
         4cNh2TWUBkImRoe2exorNhu42sr3WEQxhmxqZjKtfN9bZKDTlMqysjp92QBI/BDh0q7U
         J8XyfkMzMPgVf8FWPJFAVWggynyLERTKl/jCEhSZWwtmPBinxrRkZVtLz6qYMn70S7cl
         HIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ApmvpejRXpHVyHVDcTHhYixhKcbtDbVxNdD1J4DMsYQ=;
        b=34S4ENWqsSveMqLW+DbjCV1Y0yEihNuzaDdeXCq5Mb80mNB+2RFby+RoEHam16nXMQ
         C8thWJ7CEEHzhua8eCGBdSCMh1asmSil7IenYniuT0LI4E/xM8BPxduemzx0ZolHgde4
         nriMY82gTRZ53dJ5Z4GheCRCvcX6qM+y+7N+6VL1hTGzrC6KURMfhERWv9nSO9ibPJe+
         V5GVr7nMZUYQLcIhcOBrL0C9hElSj8H8/HOAtGzAhwNPDcN8NjtOsZdlSD0Gj6VBdBn/
         hmRgxbstuhFU/RWVnA5DrOObPfF76Leg4Hx4ZpU4r4HXaTwv17FxfWpAjlTKu+/LIW+j
         PAww==
X-Gm-Message-State: AOAM533v+C0rivhvizqqRdriWoPhlR3xTxvNuqZLeQaHqlF6F/47xtvD
        9eFMORhIctdY25mTHKVHl86p0XFBOgN6Hlhcgz4=
X-Google-Smtp-Source: ABdhPJyoaK+YKsH9yrQIXs1v+CWIJAFxfh0cGLn/kVuIhoa1ZtVtY3TqlQiFh+eB+cxnoRo9DIm7vFp1dNWE003eQQg=
X-Received: by 2002:a25:ae4d:: with SMTP id g13mr5483259ybe.293.1641794876063;
 Sun, 09 Jan 2022 22:07:56 -0800 (PST)
MIME-Version: 1.0
References: <20220107210942.3750887-1-luiz.dentz@gmail.com>
 <20220107182712.7549a8eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <6FFD2498-E81C-49DA-9B3E-4833241382EE@holtmann.org> <20220109141853.75c14667@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CABBYNZJ3LRwt=CmnR4U1Kqk5Ggr8snN_2X_uTex+YUX9GJCkuw@mail.gmail.com>
 <20220109185654.69cbca57@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CABBYNZKpYuW6+iZJomaykGLT6gF2NBjTxjw-27vBZRY89P3xgw@mail.gmail.com> <20220109215302.2d8367c5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109215302.2d8367c5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Sun, 9 Jan 2022 22:07:45 -0800
Message-ID: <CABBYNZLyfoMep6d6oo=x7L+0sOrhyHvgtEh-b7WY9q__aUQ3Lg@mail.gmail.com>
Subject: Re: pull request: bluetooth 2022-01-07
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Tedd Ho-Jeong An <hj.tedd.an@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Sun, Jan 9, 2022 at 9:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 9 Jan 2022 19:57:20 -0800 Luiz Augusto von Dentz wrote:
> > On Sun, Jan 9, 2022 at 6:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > Im planning to send a new pull request later today, that should
> > > > address the warning and also takes cares of sort hash since that has
> > > > been fixup in place.
> > >
> > > But I already pulled..
> >
> > Nevermind then, shall I send the warning fix directly to net-next
> > then?
>
> Maybe send it in a week or so with other fixes which accumulate
> up to that point?
>
> > Or you actually pulled the head of bluetooth-next not tag?
>
> I pulled the tag.

Fair enough, if you would like to merge the warning fix here is the commit:

https://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git/commit/?id=219de95995fb6526b96687c5001f61fe41bed41e

-- 
Luiz Augusto von Dentz

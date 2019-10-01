Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C4FC398D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389780AbfJAPww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:52:52 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35152 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbfJAPww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:52:52 -0400
Received: by mail-yb1-f196.google.com with SMTP id f4so2486067ybm.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V4V5jIWn5TMskOGj1VKmy8D65TjwneLbv47G5q3wYlA=;
        b=gDD8pfoNze5RsniU9r11QB8zd/KUJlt0Q+RcWfdBo50CKMkpUeIlky7lpimlrREF4j
         h8jKpoTXPR5irMaFgCYtW5rWlfQwAOoS9bkbOFaTs4Lx0Rkwpj2Oep5l2PSXB/C/5NRH
         i3cHdHfPVZMSfsqbnUyb/FOymgIjlgWjcp7GWMEs/ifqfdu9ESH1L8mLktPyum3291H5
         zYv0sk+cLhwKhvLP7ufvg9R+y4PSwdkt7kve0IE3xzk+UUMyHhiI6oe6C1HBV/sQiifl
         HnSM4bFQfz3SkOGT7GX1YhBE+rx2F34YtzTGl8kHKIgkceOW2Px12vaKKuh5cTkJR3N8
         Xujw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V4V5jIWn5TMskOGj1VKmy8D65TjwneLbv47G5q3wYlA=;
        b=dtgjO5Yk1JrlgItbIMTwJBC02kDF2G8DJ7MwvpDwIap+cfjoNRVzDfvUY/w19s2cex
         x3XAsmEUCRk9Oz/5Km+sd+ycU1QT4M6bukleyp4yOUFTwan7bqi2yNWiLL/9EUB9XDXo
         j8+JC0jFG66ZJl6CMxRcnNuzfV4KcF0c3SLI0vbK/ZknrOFizLHjvKzMm20c6OPkyBM9
         Ko4p67yX7BWUYwwvWya0rIuJ9U/NW55tijUfYMExxAT1lnw8Fhuwvp61FBExWBHOtUD0
         ZcTakjiVrKyTImOPIau1chliiZRp+vhC5Tna6dlpBq7xahobI5FTvGror792ZBX+PxTd
         WoaA==
X-Gm-Message-State: APjAAAUh6tekJ3IA8kO8ojT4AykNk5JpgIO0xih98cCrAXKvETY+Wq+y
        6XFWmvA1dJR1lEeX7wtLLsUIu4IN
X-Google-Smtp-Source: APXvYqxetlkAkuFHR4dPu0eD3bzDp1CxDY4wKFX/MPoqWLOL2wCGIyNrBfIUoee0JhnVVXC1odnaYQ==
X-Received: by 2002:a25:34d3:: with SMTP id b202mr18569758yba.165.1569945169862;
        Tue, 01 Oct 2019 08:52:49 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id f127sm3226619ywe.89.2019.10.01.08.52.48
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 08:52:48 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id r134so5002042ywg.2
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:52:48 -0700 (PDT)
X-Received: by 2002:a81:9bd7:: with SMTP id s206mr18834302ywg.193.1569945168004;
 Tue, 01 Oct 2019 08:52:48 -0700 (PDT)
MIME-Version: 1.0
References: <1569646705-10585-1-git-send-email-srirakr2@cisco.com>
 <CA+FuTSfN5=xkYUKiafM3uKF37kV6mg0Cn5WGv2QF887Pyw5A5g@mail.gmail.com> <20191001084427.73f130c0@hermes.lan>
In-Reply-To: <20191001084427.73f130c0@hermes.lan>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 1 Oct 2019 11:52:11 -0400
X-Gmail-Original-Message-ID: <CA+FuTScbrrjBucQ0YvncyAFaO5DAoDywgjn8LFt2p0NVusOErg@mail.gmail.com>
Message-ID: <CA+FuTScbrrjBucQ0YvncyAFaO5DAoDywgjn8LFt2p0NVusOErg@mail.gmail.com>
Subject: Re: [PATCH] AF_PACKET doesnt strip VLAN information
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Sriram Krishnan <srirakr2@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        xe-linux-external@cisco.com,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 11:44 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 30 Sep 2019 11:16:14 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > On Mon, Sep 30, 2019 at 1:24 AM Sriram Krishnan <srirakr2@cisco.com> wrote:
> > >
> > > When an application sends with AF_PACKET and places a vlan header on
> > > the raw packet; then the AF_PACKET needs to move the tag into the skb
> > > so that it gets processed normally through the rest of the transmit
> > > path.
> > >
> > > This is particularly a problem on Hyper-V where the host only allows
> > > vlan in the offload info.
> >
> > This sounds like behavior that needs to be addressed in the driver, instead?
>
> This was what we did first, but the problem was more general.
> For example, many filtering functions assume that vlan tag is in
> skb meta data, not the packet data itself.

Out of curiosity, can you share an example?

> Therefore AF_PACKET would
> get around any filter rules.

Packet sockets are not the only way to inject packets into the kernel.
This probably also affects tap.

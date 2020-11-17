Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026872B6D5A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbgKQS2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbgKQS2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:28:22 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308E2C0613CF;
        Tue, 17 Nov 2020 10:28:22 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id k7so10711852plk.3;
        Tue, 17 Nov 2020 10:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WJ3TelP5n774DABmEp0rl+zb95lOF3fu98sIHKylYts=;
        b=Vs8fao0qgNhlR1JCBnv9y0ahocSWCQFEAo6yWqP/pGfBAlLQAgxOVsnLBNdEJ7DZ9M
         DMwVBKh5x6y5dy0lPV0RFC/i/wjk2j/g1mv+6K9FfUZ8VUq89/Id3YDvGsLsYWYwbvSj
         YF8JCdb3ILqO30epC2HnRiQzYPGOym25Cja5OIw5xclJs+fxE0t+o+rpZ03CPiwNjTel
         G1APIkjW7pHdoKw8Z6nHWqzqP8iEt+JoYOREamVWLduyzXzksvgZOrtZAVggkr0am/ah
         uRjJiM8KOrKoimmtd0SACzduc5NrSqH61IQM2VEQ1NloS1rIHbly0XHfqkco91Rqd3iQ
         jrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WJ3TelP5n774DABmEp0rl+zb95lOF3fu98sIHKylYts=;
        b=tGQ4ze6TfEXcLnu+Fvbk+aiad8it+ziRTGFFknKGohydjsiOp5geUcTEUL/+OazEQT
         im7TdFDiFs5F5v6NqVt1hdlR7aAmJQfMwylADba71rjoNOAQoeDvJc+GCwpkDjwjGTOM
         yrU669iUBYqQcQNqWVWHE4LMOaNsXMRAIkUBhWqXQzLuR9MXzja1x7tjWhD9FftXuXDs
         xa3156wjLcL1ZGQTjYGaZgeR8t+MuZ+Q4kiWcYRdPC8ZbgTs+zP9tEdAB5fqXPSKEcus
         RQyzRiTd1T+bKpFl8YWICxfzOro+32rCFDof2ZFONVdB4G/iHBAOpXxpbcUxgD5c+vbz
         dq1Q==
X-Gm-Message-State: AOAM531qx/yOA1vR/rtiPxEXGRQr1BwoEZ8vDrZPC53HtAV8LCGk8Sbi
        ejvyaLSatraeRADXYdksH/ulS3CaRA5KADqax8E1t1Jg
X-Google-Smtp-Source: ABdhPJx+sJJt8qQoPsMT91X8H5myPqZ6vLt654FtcczZW+DrRL76cwl2H6ssROocyatjNRk0IwRefZxMNEAP1Q71RWY=
X-Received: by 2002:a17:90a:11:: with SMTP id 17mr385506pja.66.1605637701651;
 Tue, 17 Nov 2020 10:28:21 -0800 (PST)
MIME-Version: 1.0
References: <20201116135522.21791-1-ms@dev.tdt.de> <20201116135522.21791-6-ms@dev.tdt.de>
 <CAJht_EM-ic4-jtN7e9F6zcJgG3OTw_ePXiiH1i54M+Sc8zq6bg@mail.gmail.com>
 <f3ab8d522b2bcd96506352656a1ef513@dev.tdt.de> <CAJht_EPN=hXsGLsCSxj1bB8yTYNOe=yUzwtrtnMzSybiWhL-9Q@mail.gmail.com>
 <c0c2cedad399b12d152d2610748985fc@dev.tdt.de>
In-Reply-To: <c0c2cedad399b12d152d2610748985fc@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 17 Nov 2020 10:28:10 -0800
Message-ID: <CAJht_EO=G94_xoCupr_7Tt_-kjYxZVfs2n4CTa14mXtu7oYMjg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] net/lapb: support netdev events
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

On Tue, Nov 17, 2020 at 5:26 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2020-11-17 12:32, Xie He wrote:
> >
> > I think for a DCE, it doesn't need to initiate the L2
> > connection on device-up. It just needs to wait for a connection to
> > come. But L3 seems to be still instructing it to initiate the L2
> > connection. This seems to be a problem.
>
> The "ITU-T Recommendation X.25 (10/96) aka "Blue Book" [1] says under
> point 2.4.4.1:
> "Either the DTE or the DCE may initiate data link set-up."
>
> Experience shows that there are also DTEs that do not establish a
> connection themselves.
>
> That is also the reason why I've added this patch:
> https://patchwork.kernel.org/project/netdevbpf/patch/20201116135522.21791-7-ms@dev.tdt.de/

Yes, I understand that either the DTE or the DCE *may* initiate the L2
connection. This is also the way the current code (before this patch
set) works. But I see both the DTE and the DCE will try to initiate
the L2 connection after device-up, because according to your 1st
patch, L3 will always instruct L2 to do this on device-up. However,
looking at your 6th patch (in the link you gave), you seem to want the
DCE to wait for a while before initiating the connection by itself. So
I'm unclear which way you want to go. Making DCE initiate the L2
connection on device-up, or making DCE wait for a while before
initiating the L2 connection? I think the second way is more
reasonable.

> > It feels unclean to me that the L2 connection will sometimes be
> > initiated by L3 and sometimes by L2 itself. Can we make L2 connections
> > always be initiated by L2 itself? If L3 needs to do something after L2
> > links up, L2 will notify it anyway.
>
> My original goal was to change as little as possible of the original
> code. And in the original code the NETDEV_UP/NETDEV_DOWN events were/are
> handled in L3. But it is of course conceivable to shift this to L2.

I suggested moving L2 connection handling to L2 because I think having
both L2 and L3 to handle this makes the logic of the code too complex.
For example, after a device-up event, L3 will instruct L2 to initiate
the L2 connection. But L2 code has its own way of initiating
connections. For a DCE, L2 wants to wait a while before initiating the
connection. So currently L2 and L3 want to do things differently and
they are doing things at the same time.

> But you have to keep in mind that the X.25 L3 stack can also be used
> with tap interfaces (e.g. for XOT), where you do not have a L2 at all.

Can we treat XOT the same as LAPB? I think XOT should be considered a
L2 in this case. So maybe XOT can establish the TCP connection by
itself without being instructed by L3. I'm not sure if this is
feasible in practice but it'd be good if it is.

This also simplifies the L3 code.

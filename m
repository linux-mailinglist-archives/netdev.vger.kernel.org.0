Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B071411DD34
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 05:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfLMEmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 23:42:18 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:34141 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731677AbfLMEmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 23:42:17 -0500
Received: by mail-io1-f43.google.com with SMTP id z193so1094810iof.1;
        Thu, 12 Dec 2019 20:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QthJDPFS7nC/yW0U0bf8QlKUYmsIKhyJY5u98hEJawE=;
        b=H0QFgUExbKoezQOgWpIhAlmuOqeakyKGbYvy4ZrJ2gkih+zO1HShIaX9hTtS71m13N
         dJHwQR7lmjEaYwQRSbSonOeCyWI3voVQjG7O4Iw3XWm9WAWXkkyIYu5M0R7c2kT4z268
         OtgzsLaBb/YwxJq0KYPIuq3wXHxvIHn7mAJlSHyatjvjDRX7xTC2ksat+g5mwK62fnRO
         EpjKPCYKkZIqVq7y1ZoMuSH3yZKeyPs3uAbTywiCucg12Ntxq6qaUhszvdVU+NkkyU1q
         MQT7Z6I+jyebIJCIu0aBJN+hfAXFH+RTyGXduNAdLiwveJL1diAFORpkIY5sDIgJNaZQ
         8AAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QthJDPFS7nC/yW0U0bf8QlKUYmsIKhyJY5u98hEJawE=;
        b=WkEC78a4LOVCDnTAwdj6pSxuLmf7nh1wUiGXS4Tkg6BcsodbX4SmGLNtOlnjo3F8XP
         V+0eHsUuNl/T0fullLTnmD7jOkngfekVTElrvjXd2U4ATZPMzdhAFlUJORrJzBZ5yGpA
         V51xvb/cJe0/M4Lf9/g94P1pFkKC62VFlZcb1CRhvfUX3S++611Ponc43f+LV8WR8r+h
         DsifEftB/IQvxl29woocFatf0Unls7Phk8BcA/WD3JH7B8zCFPoE52mmXe74PjBuHsib
         wviCkGpcI/KtsF8mBybXNPkAlX/h0fYcNoZ4KTrk8jGU8C+lgFhRzSjaf9zHf3n/o8Hu
         JkxA==
X-Gm-Message-State: APjAAAWzt/wNSewhlmJUStJhvSpodxDqmSLlOmJ+/Pw3UoKpQalB/Hbf
        pxILIz6BMtkqmn0bl+P1r49jKpPAn4ev2h3CuaI=
X-Google-Smtp-Source: APXvYqzkCBPiplJckv2NvxY8N2or3/hpIB4LnKp13BL3tLkcHJukuTXjaf6kspE/nJV6QdTjfUgCLbAr9kpXuUAC3Ic=
X-Received: by 2002:a02:6515:: with SMTP id u21mr10699337jab.82.1576212137023;
 Thu, 12 Dec 2019 20:42:17 -0800 (PST)
MIME-Version: 1.0
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
 <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
 <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
 <99748db5-7898-534b-d407-ed819f07f939@gmail.com> <ff6b35ad589d7cf0710cb9fca4c799538da2e653.camel@sipsolutions.net>
 <CAA93jw6b6n0jm_BC6DbccEU3uN9zXcfjqnZMNm=vFjLVqYKyNA@mail.gmail.com>
 <22B5F072-630A-44BE-A0E5-BF814A6CB9B0@superduper.net> <34a05f62-8dd0-9ea0-2192-1da5bfe6d843@gmail.com>
In-Reply-To: <34a05f62-8dd0-9ea0-2192-1da5bfe6d843@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 12 Dec 2019 20:42:04 -0800
Message-ID: <CAA93jw7N34xs6HxutbArLABz4DWBy9kAWV-sxT8VqMkVSCne1w@mail.gmail.com>
Subject: Re: [Make-wifi-fast] debugging TCP stalls on high-speed wifi
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Simon Barber <simon@superduper.net>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 5:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote=
:
>
>
>
> On 12/12/19 4:59 PM, Simon Barber wrote:
> > I=E2=80=99m currently adding ACK thinning to Linux=E2=80=99s GRO code. =
Quite a simple addition given the way that code works.
> >
> > Simon
> >
> >
>
> Please don't.
>
> 1) It will not help since many NIC  do not use GRO.
>
> 2) This does not help if you receive one ACK per NIC interrupt, which is =
quite common.

Packets accumulate in the wifi device and driver, if that's the bottleneck.

>
> 3) This breaks GRO transparency.
>
> 4) TCP can implement this in a more effective/controlled way,
>    since the peer know a lot more flow characteristics.
>
> Middle-box should not try to make TCP better, they usually break things.

I generally have more hope for open source attempts at this than other
means. And there isn't much left
in TCP that will change in the future; it is an ossified protocol.

802.11n, at least, has a problem fitting many packets into an
aggregate. Sending less packets is a win
in multiple ways:

A) Improves bi-directional throughput
B) Reduces the size of the receivers txop (and retries) - the client
is also often running at a lower rate than
the ap.
C) Delivers the most current ack, sooner

When further transiting an aqm that uses random numbers, it hits the
right packet sooner, also.

I welcome experimentation in this area.



--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729

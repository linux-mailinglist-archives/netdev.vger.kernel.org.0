Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626DAF37B6
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 20:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfKGTAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 14:00:01 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34262 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfKGTAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 14:00:01 -0500
Received: by mail-ed1-f66.google.com with SMTP id b72so2835935edf.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 11:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSQIUHB/JfidJPt+ubIzLruJRIoxMPouzZO3fKnU+GA=;
        b=nxAZeMcHfbOBMPY09AzqAvPpN9/IsieMCrPHtsStolgENRrYI+TMiFOUywCt4GYJz+
         viCMqSU3JyXNdEWl4jMdnPp3nAFypwv/ljzihS1WJMHKSGSJtL3LYk6pjKBVA0IcptXs
         3TggNUtNVpkp+Rsd9ZZUwNXxE+FUFiyQVkd9eKd7JqhuwJg1TUEH4bDiN+UcFu/dqFDK
         PyO2gQ31yAkztrK30a1skAKTLHKkE8E6ioxQDF62N5EgAE3K3xRx1QknfQj3uJYTpwAF
         AkflaEWQhTWnKa0I0Bzqr4IJzSeSlpg+KdNjEMn19AqFPDbjcR8Y1SdBwAZlP7+vhRAe
         NSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSQIUHB/JfidJPt+ubIzLruJRIoxMPouzZO3fKnU+GA=;
        b=pBU8ThtSNHHEDtWhQ8UtfSkjhvFjJv7IpCQjwMPR1Xvp0bfB3OUUCEBpQedUgYB2XO
         E7SHbROAO0dAmMnXF4kX4pWgtTpF1yFgBNXd4++XbPjM8KKOH0704FNBiMgjMYtrOPHo
         R33ek5V4L1UkHbv/U+eyLZNkgJfkcNRe1qtHvLkl5D923tl+7Fx6KagQE6pCqjs82uVN
         1kDPx1ZCZQ1NHtpR10L21iADDEw1d0/vn+R2A+zTcH6zgPhdSbgmVrLEGjUmptuwj8Yj
         WBCtePH+EA4qGbgb/sSBBgK+yfocoSRZD+IbA8fH5v2Nt3AylQMGANBt9kMuCk5NbdYp
         KQeQ==
X-Gm-Message-State: APjAAAWOcUUWB4J7rKWkcJGHjMPQD0WHCa1G8V9CFESrsH+ztBJqc/3D
        xSQyT4ZljPTJlyvOrYmiVChzZ4GbilYPfZfmTOA=
X-Google-Smtp-Source: APXvYqyKqS3ricm+Lu69XzT9cb0DHGzSmVNZ7cmZPI29J8hfVkeOnloQGB28OuXwLY2aQ5V4UpQAihG3loKKyfWHDCU=
X-Received: by 2002:a05:6402:602:: with SMTP id n2mr5504725edv.23.1573153199590;
 Thu, 07 Nov 2019 10:59:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191017132029.GA9982@martin-VirtualBox> <CA+FuTScS+fm_scnm5qkU4wtV+FAW8XkC4OfwCbLOxuPz1YipNw@mail.gmail.com>
 <20191018082029.GA11876@martin-VirtualBox> <CA+FuTSf2u2yN1KL3vDLv-j9UQGsGo1dwXNVW8w=NCrdt7n8crg@mail.gmail.com>
 <20191107133819.GA10201@martin-VirtualBox> <CAF=yD-JX=juqj2yrpZ6MjksLDqF8JVjTsruu2yVh5aXL6rou5g@mail.gmail.com>
 <20191107161238.GA10727@martin-VirtualBox> <CAF=yD-JeCV-AW2HO9inJt-yePUrBGQ9=M58fYr8f2CDHdNNpaA@mail.gmail.com>
 <20191107183136.466013d1@redhat.com>
In-Reply-To: <20191107183136.466013d1@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 7 Nov 2019 13:59:23 -0500
Message-ID: <CAF=yD-K9TjhuATs2ERNsgbnDitXTBuV3yirGnwYZ26dOvo0hFA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 12:31 PM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Thu, 7 Nov 2019 11:35:07 -0500, Willem de Bruijn wrote:
> > If the bareudp device binds to a specific port on all local addresses,
> > which I think it's doing judging from what it passes to udp_sock_create
> > (but I may very well be missing something), then in6addr_any alone will
> > suffice to receive both v6 and v4 packets.
>
> This will not work when IPv6 is disabled, either by the kernel config
> or administratively. We do need to have two sockets.

This still needs only one socket, right? Just fall back to inet if
ipv6 is disabled.

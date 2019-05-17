Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAC1621EFD
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfEQUTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:19:40 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:47677 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbfEQUTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 16:19:38 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4e655bfc
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=9xioJq60hFkxFle/QJZQWb03L3M=; b=gwDnMJ
        CbGND5KrQDu5/L++8zUH5TZK6/T1gWaCn7dRB7tAQqVonq2AOhuFaT4/udCujYbF
        liDO434eVJvC8lnZBe6AxmQv+gwRePZ82XlxuDG1BB/TdNAmAwtrU8NHnBdZTT0+
        v5p+q4JfRHxrqz7wQ0OFm9v4a3qQl4LXuPFRMkzBOTlb3Pdn2Vwpr2rSVwCekcTc
        D0ugER64in6qB4MikB82NgjodOl3oyIlCGko69/GmyRvPHu8Y5DMyNclFdcWgVot
        8Hg2dZVGujRLwYhq5MNApti4zvk8zUusLrDYdbLnooCsu2M1zN3B1ORo5Twu5a5v
        zqsi+twINc5LPdIA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7edf6390 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 17 May 2019 19:50:38 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id w144so6034540oie.12
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:19:36 -0700 (PDT)
X-Gm-Message-State: APjAAAVNMyu63Uz3qIDEXQuU3bymmBxlKk03KHHh7FtZskx6iz8l0SFh
        ZJyfvls3CgPqzcFVYLhKMXfyxAfYs08rqrMyYg0=
X-Google-Smtp-Source: APXvYqwnbWbIwdBrKSzbLS0Q2QnjOl68xkojwUuJNj+6VnTE4BB963yKHERogMPqF3mwpEo5z90p1L9PibSDubQRVpc=
X-Received: by 2002:aca:eb50:: with SMTP id j77mr15484339oih.52.1558124374909;
 Fri, 17 May 2019 13:19:34 -0700 (PDT)
MIME-Version: 1.0
References: <LaeckvP--3-1@tutanota.com> <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
 <2e6749cb-3a7a-242a-bd60-5fa7a8e724db@gmail.com> <20190517103543.149e9c6c@hermes.lan>
 <5c899e85-ab00-f13b-7651-e157d9837505@gmail.com>
In-Reply-To: <5c899e85-ab00-f13b-7651-e157d9837505@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 17 May 2019 22:19:23 +0200
X-Gmail-Original-Message-ID: <CAHmME9qHfDywJHhwjqqJ-8vDDdaqpGYHWDG7LTvQZ+f5b2UVng@mail.gmail.com>
Message-ID: <CAHmME9qHfDywJHhwjqqJ-8vDDdaqpGYHWDG7LTvQZ+f5b2UVng@mail.gmail.com>
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        emersonbernier@tutanota.com, Netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 7:39 PM David Ahern <dsahern@gmail.com> wrote:
> Not sure why Jason is not seeing that. Really odd that he hits the error
> AND does not get a message back since it requires an updated ip command
> to set the strict checking flag and that command understands extack.
> Perhaps no libmnl?

Right, no libmnl. This is coming out of the iproute2 compiled for the
tests at https://www.wireguard.com/build-status/ which are pretty
minimal. Extact support would be kind of useful for diagnostics, and
wg(8) already uses it, so I can probably put that in my build system.

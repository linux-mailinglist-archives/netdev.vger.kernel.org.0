Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620EC301E5
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE3S1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:27:37 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:47058 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfE3S1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:27:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id m15so6993704ljg.13
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EEHz21XETiuiVTjoePDFc0tMtf7Vnmx//EklXVOUNgs=;
        b=K2JqD/tU3oIqI/jC1lrG4pZySkkCw7dTdxlYO0f/Zbag8EoamijxG0fF1YsZ+7hAUq
         bD2Rg/4aJKrgynPA/BOsVz2nYwLc4TKRcsAwtbbb1nrAknqDGdBOs5J1CzecxfNc7ZCq
         sOpcYe4Fszf5Af12QUrDdB5aUgoa3WWuyTqri6l/0FW2BG2qVyBdKTUcSKT6OUKuLaEk
         49Cz6fi93BBEUbJtpcqw+O93uYudLvLTe47CdpSdspKRfQC6L6aa5nG5Vv7i8fFC3Jot
         w2Un59rz8k9IWxoogB/+rGWEWkssIf2xFXE0feSABksbHqjhwW+/Sy8ln0XD+RhE39Z+
         x5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EEHz21XETiuiVTjoePDFc0tMtf7Vnmx//EklXVOUNgs=;
        b=uHDo+zhtjFpY93DdmXZYq13lOc844yWRm/XAfmTwr6zdebpQQnu4HCwiVDaqlhAZjC
         oh543vL6GHtqRQjsOqk9aBI+dqG09VUEW2I1YIu/30n1wPqL9vPSkVa/3x0L5z9Sahkd
         WUHmC1xEzGnl4raAh9JPZSq6SpdI9EvPqBH/v/p4ZAPmXZyP3pmWDBxfWQJe46Lvdi2k
         wtHeJqRG/hjlsBpNt0KiCnCNi8/Ykp9uotqa9i9ejT8GngBPH+Qp8CrKQrq2NUmIgNLa
         pr+/IELN9+4JrsZirBT0e/vzQdtty4SJXneObPX05TqZa/mAVHTS81I8gQovzIjKmsTd
         8jXw==
X-Gm-Message-State: APjAAAVbnBhmktYCsn1BAEBQDVXDDw9evQxjrfU5m00N3iGtC41t7fU8
        Disph7nJm0N/Hv6hmYyKO56s1G6rK0+hspXYqqQ=
X-Google-Smtp-Source: APXvYqw6AJAvFetnAshsHg0o/KyDaxQupLEUopvHXG6BorfdwvrCh29Dqaa85GN/mGCkSEBIQ2mky+t5bOJfPTdjOds=
X-Received: by 2002:a2e:96d7:: with SMTP id d23mr3090962ljj.206.1559240854674;
 Thu, 30 May 2019 11:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
 <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com> <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
 <20190530.110149.956896317988019526.davem@davemloft.net>
In-Reply-To: <20190530.110149.956896317988019526.davem@davemloft.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 May 2019 11:27:23 -0700
Message-ID: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Miller <davem@davemloft.net>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 11:01 AM David Miller <davem@davemloft.net> wrote:
>
> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Date: Thu, 30 May 2019 08:18:10 -0700
>
> > On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
> >> > Huge number of core changes and zero tests.
> >>
> >> As mentioned in a past response, there are a number of tests under
> >> selftests that exercise the code paths affected by this change.
> >
> > I see zero new tests added.
>
> If the existing tests give sufficient coverage, your objections are not
> reasonable Alexei.

I completely disagree. Existing tests are not sufficient.
It is a new feature for the kernel with corresponding iproute2 new features,
yet there are zero tests.

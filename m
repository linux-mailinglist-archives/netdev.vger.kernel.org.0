Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B808DF4AC
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfJUSCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:02:42 -0400
Received: from mail-vs1-f54.google.com ([209.85.217.54]:45587 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:02:41 -0400
Received: by mail-vs1-f54.google.com with SMTP id y1so687447vsg.12
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PVloobMBm1zvuL0NOQUhOrxaQln28y3uLhYR+rnHGoE=;
        b=bXxMQ9uoy0H19o9YSlbYV97JqCWra+agESekCQnI0Jxdsmjb9haKRFeUvDibZ2bxlV
         y7X+FJANStuY4tLGEKLKc8fiXDCWNIa1DvHC36C2nMeYIWxL2EZAA8IRJ9FDUdt/gmuC
         CLl6X7mY/4tA93mCzjz2oYB8ekVo91g0ZruB4a1D7EIYSdMfHun1GwSePxmVpMsNhzpv
         y+aQ8pcEahz4K8w4cstat9tQ9HijI5VG+yRLdANgL61E1yArU1+n5bHqe2tA/NFLz3sv
         no2C/WMmPgIpZH2Bde6vsAQUfJH+zjGdMy/SfqfW1y8mG8bm2I4jtHeBACE7Z3BuZETs
         M05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PVloobMBm1zvuL0NOQUhOrxaQln28y3uLhYR+rnHGoE=;
        b=W+7snOtQ7BsmFx7iKLN0fYWZk28v9l/M4zUJOUNYn9TDpszpUFreeini49PKUooy1l
         r8Xh/JUX9/3tbk6IbZUsKbBEg1Y4K4ECfwc352exBv6+qAstQf7YuptG+VIg+BQdH361
         j+1MDsfzVINMC+R68d5orkJKA8WLt03m8VmSSUGyBrBNBlYgoUyRTF11YYFMvBAGHbad
         Mf7dOTVCDHgjJQLYnvEs/U+S9k3MC8iMtdg0ZrY0IHUmxC7Nd+Qs9UozA3a8/GQdxnyh
         KIAjsRvEGVEozTKfvtyPOJDGHT2ZI+d+ioGhSucx8gfuOXcHwN6JHNAv9rKOgzlA3RkO
         Olig==
X-Gm-Message-State: APjAAAUytu8X9ImLYBwzVR4HUkR7p7YeNRAkcxlAz/M9U+aY03ccHv2j
        n2SSpBWjGa5Xdl0LiteDz7DnPgEi8biidMWqf8rpZQ==
X-Google-Smtp-Source: APXvYqz6GUIkYZ0HzW+fowUU8A2Fgj/873k0LN1VzvNjTu1dgpeXdbOUx6Rx3hhfKzQSBBafNUFVnOMAaubFv2KIjLo=
X-Received: by 2002:a05:6102:2323:: with SMTP id b3mr1121300vsa.184.1571680960042;
 Mon, 21 Oct 2019 11:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <1571425340-7082-1-git-send-email-jbaron@akamai.com> <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
In-Reply-To: <CADVnQymUMStN=oReEXGFT24NTUfMdZq_khcjZBTaV5=qW0x8_Q@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 21 Oct 2019 11:02:03 -0700
Message-ID: <CAK6E8=et_dMeie07-PHSdVO1i44bVLHcOVh+AMmWQqDpqsuGXQ@mail.gmail.com>
Subject: Re: [net-next] tcp: add TCP_INFO status for failed client TFO
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jason Baron <jbaron@akamai.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Netdev <netdev@vger.kernel.org>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch. Detailed comments below

On Fri, Oct 18, 2019 at 4:58 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Oct 18, 2019 at 3:03 PM Jason Baron <jbaron@akamai.com> wrote:
> >
> > The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
> > or not data-in-SYN was ack'd on both the client and server side. We'd like
> > to gather more information on the client-side in the failure case in order
> > to indicate the reason for the failure. This can be useful for not only
> > debugging TFO, but also for creating TFO socket policies. For example, if
> > a middle box removes the TFO option or drops a data-in-SYN, we can
> > can detect this case, and turn off TFO for these connections saving the
> > extra retransmits.
> >
> > The newly added tcpi_fastopen_client_fail status is 2 bits and has 4
> > states:
> >
> > 1) TFO_STATUS_UNSPEC
> >
> > catch-all.
> >
> > 2) TFO_NO_COOKIE_SENT
> >
> > If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
> > was sent because we don't have one yet, its not in cache or black-holing
> > may be enabled (already indicated by the global
> > LINUX_MIB_TCPFASTOPENBLACKHOLE).

It'd be useful to separate the two that cookie is available but is
prohibited to use due to BH checking. We've seen users internally get
confused due to lack of this info (after seeing cookies from ip
metrics).

> >
> > 3) TFO_NO_SYN_DATA
> >
> > Data was sent with SYN, we received a SYN/ACK but it did not cover the data
> > portion. Cookie is not accepted by server because the cookie may be invalid
> > or the server may be overloaded.
> >
> >
> > 4) TFO_NO_SYN_DATA_TIMEOUT
> >
> > Data was sent with SYN, we received a SYN/ACK which did not cover the data
> > after at least 1 additional SYN was sent (without data). It may be the case
> > that a middle-box is dropping data-in-SYN packets. Thus, it would be more
> > efficient to not use TFO on this connection to avoid extra retransmits
> > during connection establishment.
> >
> > These new fields certainly not cover all the cases where TFO may fail, but
> > other failures, such as SYN/ACK + data being dropped, will result in the
> > connection not becoming established. And a connection blackhole after
> > session establishment shows up as a stalled connection.
> >
> > Signed-off-by: Jason Baron <jbaron@akamai.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Cc: Christoph Paasch <cpaasch@apple.com>
> > ---
>
> Thanks for adding this!
>
> It would be good to reset tp->fastopen_client_fail to 0 in tcp_disconnect().
>
> > +/* why fastopen failed from client perspective */
> > +enum tcp_fastopen_client_fail {
> > +       TFO_STATUS_UNSPEC, /* catch-all */
> > +       TFO_NO_COOKIE_SENT, /* if not in TFO_CLIENT_NO_COOKIE mode */
> > +       TFO_NO_SYN_DATA, /* SYN-ACK did not ack SYN data */
>
> I found the "TFO_NO_SYN_DATA" name a little unintuitive; it sounded to
> me like this means the client didn't send a SYN+DATA. What about
> "TFO_DATA_NOT_ACKED", or something like that?
>
> If you don't mind, it would be great to cc: Yuchung on the next rev.
TFO_DATA_NOT_ACKED is already available from the inverse of TCPI_OPT_SYN_DATA
#define TCPI_OPT_SYN_DATA       32 /* SYN-ACK acked data in SYN sent or rcvd */

It occurs (3)(4) are already available indirectly from
TCPI_OPT_SYN_DATA and tcpi_total_retrans together, but the socket must
query tcpi_total_retrans right after connect/sendto returns which may
not be preferred.

How about an alternative proposal to the types to catch more TFO issues:

TFO_STATUS_UNSPEC
TFO_DISABLED_BLACKHOLE_DETECTED
TFO_COOKIE_UNAVAILABLE
TFO_SYN_RETRANSMITTED  // use in conjunction w/ TCPI_OPT_SYN_DATA for (3)(4)

>
> thanks,
> neal

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6477A607
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfG3K2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:28:32 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:34334 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfG3K2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:28:32 -0400
Received: by mail-oi1-f196.google.com with SMTP id l12so47552844oil.1
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 03:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qd5SoZkLsKgVSjnNtDjbZKzLdvDNvkBuGiPASCmrSKA=;
        b=KKlOBLq08Nw+fbqtijHleJSV3gtVnE9pRZJogXcTDjPloC4u617LscJanzvDKY2k8z
         +fIdoYBKmCO7G7bRczE6fSflLrjLeqq9ge/lzAYF9AfbpDxrZ+RXot9YoOAlOJEzYHCQ
         mAKzlmoxy0+jtLGx2HEbbrG0H9cdEHCYTECFDmbS7jusFIvh0w6/hK+ikfEUDxycz2r0
         gJ1oDVTMc9QJVsBa++XtmA479oUd8JyfK3Z/vFDUxdD/v8ArZ92kARS9l+i2TbdMEPEv
         ZLzZIuyRQsdwdKwOgAvn3PhsM9y7wM2ejiL9J23QFAi/qtTUAP+ivlIG/stLUHzHrMnI
         1q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qd5SoZkLsKgVSjnNtDjbZKzLdvDNvkBuGiPASCmrSKA=;
        b=Y7jmEZoJ4awmZgiKCu2u6bLKQUrmZw4lbhYgra/Wb21/eDgc7dNqHiqfSD+U8lIkoP
         pkmt5Uivr4GetpqrPR+PwyfGly5XOgOIdFAWpixuTMx4NSNr4fEpxE3QURmoCM7BPJh9
         1oGKjxecKJk887YfVdnjfpjaTmd4BXJ3Xx38SDxUslOrECX06qcIMbRwinaqjmDba0UO
         H0Kl8PU7cDdStnzblirzoipw5vEJn1qP3cv3NAE5k7CIbJbpJtk+Mhb7hxmHdqd7OAoG
         o4bQs5qwARoDDIwu4yCn6QZWGhcFqMNw6AoCq9XDDzIDrla8znQu7Dfx3vYbzQZcTmP+
         5rtw==
X-Gm-Message-State: APjAAAVV7pAN4s3W8SKlu73/LCEd3OBayLiCI9Y6WniZa/fm3vwHElx3
        JSVNNZvBeN25RhDb7Bqu5nzka9Hju4QTuUhHbIw=
X-Google-Smtp-Source: APXvYqwYR2n80uBDxNoTtS3kd/hCTiHSM6dDARkj8NJ7znuwoQpd3FxiYYp8Mc6tl0VWrAueKLaFaQePQTpT4C7VuZE=
X-Received: by 2002:aca:c584:: with SMTP id v126mr624917oif.60.1564482511375;
 Tue, 30 Jul 2019 03:28:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
 <93c401b9-bf8b-4d49-9c3b-72d09073444e@cn.fujitsu.com>
In-Reply-To: <93c401b9-bf8b-4d49-9c3b-72d09073444e@cn.fujitsu.com>
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Tue, 30 Jul 2019 20:28:04 +1000
Message-ID: <CAO42Z2x163LCaYrB2ZEm9i-A=Pw1xcudbGSua5TxxEHdc4=O2g@mail.gmail.com>
Subject: Re: net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a
 global address
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Su,

On Tue, 30 Jul 2019 at 19:41, Su Yanjun <suyj.fnst@cn.fujitsu.com> wrote:
>
>
> =E5=9C=A8 2019/7/30 16:15, Mark Smith =E5=86=99=E9=81=93:
> > Hi,
> >
> > I'm not subscribed to the Linux netdev mailing list, so I can't
> > directly reply to the patch email.
> >
> > This patch is not the correct solution to this issue.
> >

<snip>

> In linux implementation, one interface may have no link local address if
> kernel config
>
> *addr_gen_mode* is set to IN6_ADDR_GEN_MODE_NONE. My patch is to fix
> this problem.
>

So this "IN6_ADDR_GEN_MODE_NONE" behaviour doesn't comply with RFC 4291.

As RFC 4291 says,

"All interfaces are *required* to have *at least one* Link-Local
unicast address."

That's not an ambiguous requirement.

This specific, explicit requirement goes as back as far as RFC 2373
from 1998, the ancestor of RFC 4291. It is also heavily implied in RFC
1884s, 2.7 A Node's Required Addresses.

> And what you say is related to the lo interface.  I'm not sure whether
> the lo interface needs a ll adreess.
>

It is an IPv6 enabled interface, so it requires a link-local address,
per RFC 4291. RFC 4291 doesn't exclude any interfaces types from the
LL address requirement.

Even special NBMA links/interfaces are not excluded from this
requirement, as Link-Local addresses are formed and used in the NBMA
operation, per RFC 2491.

> IMO the ll address is used to get l2 address by sending ND ns. The lo is
> very special.
>

From an IPv6 perspective, the virtual loopback interface isn't all that spe=
cial.

A general theme of IPv6 is to try to treat things as similarly as
possible, compared to the IPv4 where a lot of things were treated as
special cases (e.g. ND runs over ICMPv4, in comparison to ARP running
directly and only over Ethernet/802.3. RFC 4861 treats point-to-point
links as multicast capable links, emulating multicast if necessary.
RAs and DHCPv6 are used over PPP links to carry parameters, rather
than using IPv6CP, compared to using IPv4 IPCP to carry e.g. DNS
addresses)

The main place the loopback behaviour causes issues is with IPv6 ND
Duplicate Address Detection. Appendix A of RFC 4861, and RFC 7527,
"Enhanced Duplicate Address Detection" discuss how to deal with that.
Some physical interfaces can be in loopback mode too, so IPv6 DAD has
to deal with that temporary situation.

LL addresses are and can be used for lots of things, including by
end-user applications as a preference when there is a choice between a
set of LL addr(s), GUA and ULA addresses.

Here is an Internet Draft that describes the general characteristics
of Link-Local addresses with references, as well as the benefits of
and how to use them in applications.

"How to use IPv6 Link-Local Addresses in Applications"
https://tools.ietf.org/html/draft-smith-ipv6-link-locals-apps-00


Regards,
Mark.

> Thanks
>
> Su
>
> >
> > "2.1. Addressing Model"
> >
> > ...
> >
> > "All interfaces are required to have at least one Link-Local unicast
> >     address (see Section 2.8 for additional required addresses)."
> >
> > I have submitted a more specific bug regarding no Link-Local
> > address/prefix on the Linux kernel loopback interface through RedHat
> > bugzilla as I use Fedora 30, however it doesn't seem to have been
> > looked at yet.
> >
> > "Loopback network interface does not have a Link Local address,
> > contrary to RFC 4291"
> > https://bugzilla.redhat.com/show_bug.cgi?id=3D1706709
> >
> >
> > Thanks very much,
> > Mark.
> >
> >
>
>

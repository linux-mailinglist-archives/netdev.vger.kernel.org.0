Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D9C131CA0
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 01:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgAGAGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 19:06:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41822 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgAGAGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 19:06:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id bd4so22452870plb.8
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 16:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hXeyVMFmGmToxPkSIcISzKFgdbx9YHPrVDzmQfN3CR8=;
        b=PZaJ3IFwOmtXXQ4vm1o66XMiXioajbDA/XY7U7Y9ZSUaj9zyOKp6jQoDICJdRy9DJV
         iJEMvU3Vwa+EfPhE5B0pCv2j9sWQ6sVGJuQ6JxcbeATp0XkPE5iDk4RUxeHIADElafXv
         vX3TnOA7/xobsFUqTaOX7Vb3b4tajnDGNjx/LVuidshVfwEf3NVLWBYfjbmnlx8fOz5G
         Z00ObOs87u5y9cKvORJve1E8RJFBs4RxcvAgPu3ED5sF46tWfzoOOP0oHAy+QhqtAKCV
         wTp/2WZS3uQMArv92oKNQmiQQgkuIoyLQJrH4zRC36KbidT3lLdv3rI+VL8OjRjNTdCF
         S3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hXeyVMFmGmToxPkSIcISzKFgdbx9YHPrVDzmQfN3CR8=;
        b=LKYlkoA17dp4ZBVr6wuPIGU5xoBJV3CEXUJvKosxXMuZI6kZSbF8AkBl/icq0sf0Jo
         Wn3sD/ghFFHXcVGdv9g6P6mESiop8+8k7EKNE0njuk22cUOS503bbXCbhr7DhbtXLQY8
         eVyHhbHGk85mR+nNv4bEKssgemAZzISUNaBORve1rtIoqd6Ao4+Tp+srQ5RtqIZ53Rgo
         WOE3wOyTvd50GCVJXLtEArcVFBTM8SJGLICWboRAvLjlFIOh6uNT52EY//xxHyptL8at
         ktmQswGBvZ1tHv15FesCKSIIFU3P7VOFimjdDPpVtflpVbczUWv86b/2OEWNCig2y9Dv
         bldA==
X-Gm-Message-State: APjAAAVGxipJTiU4FN7xWHUO5Zm8NAqv9bRFH9XLOIuRJwiUHUKr6Klt
        dLONhnn4Df1/TEnDzLfo/vrGog==
X-Google-Smtp-Source: APXvYqwWJDDGU55CFH5Kg+5I0sQou/OOR3fPXtKcOaqKe9/viEUVuPIQzH1yUY8b9uAPQcZeJ+VjxA==
X-Received: by 2002:a17:902:b908:: with SMTP id bf8mr80141322plb.293.1578355603544;
        Mon, 06 Jan 2020 16:06:43 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id b17sm68647128pfb.146.2020.01.06.16.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 16:06:43 -0800 (PST)
Date:   Mon, 6 Jan 2020 16:06:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Ttttabcd <ttttabcd@protonmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH] fragment: Improved handling of incorrect IP fragments
Message-ID: <20200106160635.2550c92f@hermes.lan>
In-Reply-To: <BRNuMFiJpql6kgRrEdMdQfo3cypcBpqGRtfWvbW8QFsv2MSUj_fUV-s8Fx-xopJ8kvR3ZMJM0tck6FYxm8S0EcpZngEzrfFg5w22Qo8asEQ=@protonmail.com>
References: <u0QFePiYSfxBeUsNVFRhPjsGViwg-pXLIApJaVLdUICuvLTQg5y5-rdNhh9lPcDsyO24c7wXxy5m6b6dK0aB6kqR0ypk8X9ekiLe3NQ3ICY=@protonmail.com>
        <20200102112731.299b5fe4@hermes.lan>
        <BRNuMFiJpql6kgRrEdMdQfo3cypcBpqGRtfWvbW8QFsv2MSUj_fUV-s8Fx-xopJ8kvR3ZMJM0tck6FYxm8S0EcpZngEzrfFg5w22Qo8asEQ=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Jan 2020 00:44:30 +0000
Ttttabcd <ttttabcd@protonmail.com> wrote:

> > You can not safely drop this check.
> > With recursive fragmentation it is possible that the initial payload en=
ds
> > up exceeding the maximum packet length. =20
>=20
> Can you give an example? What is "recursive fragmentation"?
>=20
> In my previous tests, all fragment packets with a payload length exceedin=
g 65535 will be in the ip6_frag_queue
>=20
> if ((unsigned int) end> IPV6_MAXPLEN)
>=20
> Was discarded.
>=20
>=20

I get wary of any changes to fragmentation code. It has a long history
of bugs and is complex. See recent FragSmack for some backstory.

You need to split IPv4 and IPv6 parts into two different patches.
In the IPv4 part, you dropped the test for oversize IPv4 packet.

With raw packet tools it is possible to generate a packet that reassembles =
into
a packet larger than 64K.  An example is:

$ tshark -r oversize-ipv4.pcap=20
    1   0.000000    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D0, ID=3D9b39)
    2   0.001615    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D1440, ID=3D9b39)
    3   0.004115    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D2920, ID=3D9b39)
    4   0.006502    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D4400, ID=3D9b39)
    5   0.008819    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D5880, ID=3D9b39)
    6   0.011178    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D7360, ID=3D9b39)
    7   0.013465    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D8840, ID=3D9b39)
    8   0.016040    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D10320, ID=3D9b39)
    9   0.018369    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D11800, ID=3D9b39)
   10   0.020679    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D13280, ID=3D9b39)
   11   0.022965    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D14760, ID=3D9b39)
   12   0.025186    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D16240, ID=3D9b39)
   13   0.027277    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D17720, ID=3D9b39)
   14   0.028917    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D19200, ID=3D9b39)
   15   0.030832    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D20680, ID=3D9b39)
   16   0.032232    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D22160, ID=3D9b39)
   17   0.033742    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D23640, ID=3D9b39)
   18   0.035106    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D25120, ID=3D9b39)
   19   0.036736    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D26600, ID=3D9b39)
   20   0.037728    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D28080, ID=3D9b39)
   21   0.038983    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D29560, ID=3D9b39)
   22   0.040007    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D31040, ID=3D9b39)
   23   0.041459    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D32520, ID=3D9b39)
   24   0.042833    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D34000, ID=3D9b39)
   25   0.044030    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D35480, ID=3D9b39)
   26   0.044909    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D36960, ID=3D9b39)
   27   0.045921    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D38440, ID=3D9b39)
   28   0.046767    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D39920, ID=3D9b39)
   29   0.047581    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D41400, ID=3D9b39)
   30   0.048610    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D42880, ID=3D9b39)
   31   0.049323    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D44360, ID=3D9b39)
   32   0.050102    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D45840, ID=3D9b39)
   33   0.051014    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D47320, ID=3D9b39)
   34   0.051787    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D48800, ID=3D9b39)
   35   0.052576    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D50280, ID=3D9b39)
   36   0.053448    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D51760, ID=3D9b39)
   37   0.054260    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D53240, ID=3D9b39)
   38   0.055036    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D54720, ID=3D9b39)
   39   0.055823    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D56200, ID=3D9b39)
   40   0.056614    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D57680, ID=3D9b39)
   41   0.057512    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D59160, ID=3D9b39)
   42   0.058313    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D60640, ID=3D9b39)
   43   0.059073    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D62120, ID=3D9b39)
   44   0.059945    127.0.0.1 =E2=86=92 127.0.0.1    IPv4 1514 Fragmented I=
P protocol (proto=3DTCP 6, off=3D63600, ID=3D9b39)
   45   0.060705    127.0.0.1 =E2=86=92 127.0.0.1    TCP 469 16705 =E2=86=
=92 16705 [FIN, ECN, NS] Seq=3D1 Win=3D16705, bogus TCP header length (16, =
must be at least 20)

With current (correct) Linux kernel code this gets reassembled and dropped.
As seen in dmesg log and statistics.

With your Ipv4 patch the oversize packet gets passed on up the stack.

Testing this stuff is hard, it requires packet hacker tools.


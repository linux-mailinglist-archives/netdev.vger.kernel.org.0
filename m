Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E536E326586
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhBZQ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 11:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBZQ0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 11:26:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE43C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:26:07 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id b3so9139313wrj.5
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 08:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MCHAPcJe1qcCe9PqtI4xWPb7Njdj/4OwtFhb21MfPXY=;
        b=PMhLznuFVbZ9vLfWMfQKxKh4RpG7LzwUe2lr0hC+Rmf6WrYl6/nGOjmcT9V2PUEVb9
         Ch4ZLQ7HazvrGoQZ2xRikcE5uAP7He71efSyea3n8SjayALBFLiDPubOm1vzamT4fC5B
         BHZE/n/Yhq4d3ybT3ACugY+hd6ZQF6cTpEC+EMeIFOTSSp8o3yoeOvIUTd4oD82CnYKY
         9HokrVd+Eu8dXERIewiN/kn7symHA8jQMuLc61FFSNz4Pba8Puik76ER6un/6qVwHGbS
         RLTqq9Pv7yElvrJijU04Mrx53TbchbdwkPcSydqsnS2/qmBcSNg7UsXD2OVHsxdC2EBj
         1Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=MCHAPcJe1qcCe9PqtI4xWPb7Njdj/4OwtFhb21MfPXY=;
        b=Y4WwA8KegzKIfpDu2WWLPqPezjarT9tOcCGHXolirn8tKIrxuT/Gv19yJAJfNRhxKb
         QcL9dSu/WbRBOOBfEpg/hsdRbjO+U33WGmOrRaOSgfMDUynkp/aEGOgI0w6V2Svs2FbB
         KW4GZleWVpEMpQXk4+RilE0a8tXnaaxs1kd0DeMG/4AwFrhAPOiR0VQG1EU2LipMCm/7
         cmonOvkbKVio/rKiD5N5hJT/sTWLbiylFWZZXkvG4vnu8vj/f2Ecam0GMY8NLNri/Yuh
         4a4dgB5CoqJsZlNvhElZVGciPbAHiR7xtd/0+clC9mHRd3+mLravG26Rd9Bwqf4G11h7
         38Gw==
X-Gm-Message-State: AOAM532X7SGdfD0Gji/OaxmvoorjVzl3O3uvqr8TcGqptxXI2rTkZp2j
        Z5UCLp01+lNsmLYVKdCz7UI=
X-Google-Smtp-Source: ABdhPJywnW7UT3jMnUFQQGi4AOg7mByO4mWUqEcJS8spgKGaijZfjs3LY42zQCtELIEgZVQjYO0ojg==
X-Received: by 2002:adf:fe01:: with SMTP id n1mr4043051wrr.341.1614356765950;
        Fri, 26 Feb 2021 08:26:05 -0800 (PST)
Received: from silmaril.home ([188.120.85.11])
        by smtp.gmail.com with ESMTPSA id h2sm16051284wrq.81.2021.02.26.08.26.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Feb 2021 08:26:05 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: TCP stall issue
From:   Gil Pedersen <kanongil@gmail.com>
In-Reply-To: <d5b6a39496db4a4aa5ceb770485dd47c@AcuMS.aculab.com>
Date:   Fri, 26 Feb 2021 17:26:03 +0100
Cc:     Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <32E2B684-5D8C-41E3-B17A-938A5F784461@gmail.com>
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
 <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
 <C5332AE4-DFAF-4127-91D1-A9108877507A@gmail.com>
 <CADVnQynP40vvvTV3VY0fvYwEcSGQ=Y=F53FU8sEc-Bc=mzij5g@mail.gmail.com>
 <93A31D2F-1CDE-4042-9D00-A7E1E49A99A9@gmail.com>
 <CADVnQyn5jrkPC7HJAkMOFN-FBZjwtCw8ns-3Yx7q=-S57PdC6w@mail.gmail.com>
 <d5b6a39496db4a4aa5ceb770485dd47c@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 26 Feb 2021, at 15.39, David Laight <David.Laight@ACULAB.COM> =
wrote:
>=20
> Some thoughts...
>=20
> Does a non-android linux system behave correctly through the same NAT =
gateways?
> Particularly with a similar kernel version.
>=20
> If you have a USB OTG cable and USB ethernet dongle you may be able to =
get
> android to use a wired ethernet connection - excluding any WiFi =
issues.
> (OTG usually works for keyboard and mouse, dunno if ethernet support =
is there.)
>=20
> Does you android device work on any other networks?

I have done some further tests. I managed to find another Android device =
(kernel 4.9.113), which thankfully does _not_ send the weird D-SACKs and =
quickly recovers, so the problem appears to be on the original device.

Additionally, I have managed to do a trace on the WLAN AP, where I can =
confirm that all packets seem to be transferred without unnecessary =
modifications or re-ordering. Ie. all segments sent from the server make =
it to the device and any loss will be device local. As such this points =
to a driver-level issue?

I don't have an ethernet dongle ready. I tried to connect using cellular =
and was unable to replicate the issue, so this further points at a =
driver-level issue.

Given that it now seems relevant, the device is an Android P20 Lite, =
running a variant of Android 9.1 with an update from this year (kernel =
was built jan. 05 2021).

/Gil=

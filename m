Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DE3E91BE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 22:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfJ2VUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 17:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbfJ2VUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 17:20:17 -0400
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196C0217D9;
        Tue, 29 Oct 2019 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572384016;
        bh=1cSmeppgFeQ41PWqhrysIRfV32I5Tuezb8ETTB3waIs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cgHBazylfqJiOPQ8J2yV5aYXE7cULEusjmlNvmu96X9V/m8/+98SHixXF2BM/P7kA
         brAqMXL2bawG8+MtyfVChWZeM0u/P1G2FbDSKmcpJYWvLH+LenKCrrQ1edO2oa9jmK
         EoEF4yOdz52r1AEwicJnZoPAsTmoG2BlKN6cRs0Y=
Received: by mail-qt1-f180.google.com with SMTP id g50so235116qtb.4;
        Tue, 29 Oct 2019 14:20:16 -0700 (PDT)
X-Gm-Message-State: APjAAAV4E56GkRVIHwbAgXOqiLv751VdiiuFOBN7LnJFZC+EGzkgnu4B
        6KJlc9Ls0v7KqLV7aYKsSSq9vCq7aQDxVTFZ6g==
X-Google-Smtp-Source: APXvYqxOyhW4aE2ukPOMjPhdhNwfvk/LqhVFIPDp5yx+5MMKJKv5g2TOBKhjK2mHaSs648ZW3z5dvtJy5n5XLrkjmsk=
X-Received: by 2002:ac8:48c5:: with SMTP id l5mr918718qtr.110.1572384015207;
 Tue, 29 Oct 2019 14:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
 <20191025193228.GA31398@bogus> <20191029145953.GA29825@renesas.com>
In-Reply-To: <20191029145953.GA29825@renesas.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 29 Oct 2019 16:20:03 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLteAdjk+4KQ2hd5m16irT9_70EAxNWdTDLFHCZkex2Bg@mail.gmail.com>
Message-ID: <CAL_JsqLteAdjk+4KQ2hd5m16irT9_70EAxNWdTDLFHCZkex2Bg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
To:     Vincent Cheng <vincent.cheng.xh@renesas.com>
Cc:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 10:00 AM Vincent Cheng
<vincent.cheng.xh@renesas.com> wrote:
>
> On Fri, Oct 25, 2019 at 03:32:28PM EDT, Rob Herring wrote:
> >On Mon, Oct 21, 2019 at 03:57:47PM -0400, vincent.cheng.xh@renesas.com wrote:
> >> From: Vincent Cheng <vincent.cheng.xh@renesas.com>
> >>
> >> Add device tree binding doc for the IDT ClockMatrix PTP clock.
> >>
> >> +
> >> +examples:
> >> +  - |
> >> +    phc@5b {
> >
> >ptp@5b
> >
> >Examples are built now and this fails:
> >
> >Documentation/devicetree/bindings/ptp/ptp-idtcm.example.dts:19.15-28:
> >Warning (reg_format): /example-0/phc@5b:reg: property has invalid length (4 bytes) (#address-cells == 1, #size-cells == 1)
> >
> >The problem is i2c devices need to be shown under an i2c bus node.
> >
> >> +          compatible = "idt,8a34000";
> >> +          reg = <0x5b>;
> >> +    };
>
> I am trying to replicate the problem locally to confirm the fix prior to re-submission.
>
> I have tried the following:
>
> ./tools/dt-doc-validate ~/projects/linux/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml
> ./tools/dt-extract-example ~/projects/linux/Documentation/devicetree/bindings/ptp/ptp-idtcm.yaml > example.dts
>
> How to validate the example.dts file against the schema in ptp-idtcm.yaml?

'make -k dt_binding_check' in the kernel tree.

Rob

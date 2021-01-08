Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713BC2EF3DD
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbhAHOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:24:56 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:44232 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbhAHOYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:24:55 -0500
Received: by mail-ot1-f54.google.com with SMTP id r9so9725988otk.11;
        Fri, 08 Jan 2021 06:24:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KFwxo3qan4g6V4pQIK/kieZfz/hWqfOwQh2ghP5HzG4=;
        b=RXHNwUlePxFPFEMSloIqi/vSTB3yKqZkNwYj09ZUDPKhiCdErCOmUVxMVY3YXgAKXX
         oTCWkZ/V1xHndaELfrI+DYgJ4DKCp39nBV6lCeh/3UXtz1os6YGiqy1LxVI2/kj43Eik
         4ZB2R0ZhCtz2KqchFa2qSaOcIS0tQrt/Sxo3LmexMEA9wUmUjIKPAP7AmaT0QSeyWdm3
         Y+t3GdLOBZ+tH5JNJem/2NKhmg9zSvXz7hGaU9D1s3ymYnmW6dDWwbqjejMybII02s8e
         AXEKWUh4F7fVwKbGyWVyjTtQEpVtso7qcoM1QCTO/6XMcXMzDwxJZVWHoZgTVO+UrnfL
         9J0Q==
X-Gm-Message-State: AOAM530Be+MYj2YmSWnztjG8fWERhVd+WFFTp6MsVfWSb4jQ7JUaSd+k
        hbtCh7qFQX/2eHiw/do/gYmfeBczhRzPIc46IDc=
X-Google-Smtp-Source: ABdhPJwADa70JQAXCy4lsWLORoYMqTTRclDjqMkPdMkC6riwZYTLFGBF9gF2TN2RjJx3Auu+cM59swiYqANmjFH1W20=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr2750225otc.145.1610115854549;
 Fri, 08 Jan 2021 06:24:14 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <CAMuHMdWE7FS-BLjT0sXupPX+V7XOTjN8ZKnRmShNEOx0i9DCGQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWE7FS-BLjT0sXupPX+V7XOTjN8ZKnRmShNEOx0i9DCGQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Jan 2021 15:24:03 +0100
Message-ID: <CAMuHMdUbkYy5chXfvyzC6L0HzDRbyzAKx2gzTMcCz=N-rdLoAg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: net: renesas,etheravb: Add additional clocks
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Fri, Jan 8, 2021 at 3:11 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> > The AVB driver assumes there is an external clock, but it could
> > be driven by an external clock.  In order to enable a programmable
> > clock, it needs to be added to the clocks list and enabled in the
> > driver.  Since there currently only one clock, there is no
> > clock-names list either.
> >
> > Update bindings to add the additional optional clock, and explicitly
> > name both of them.
> >
> > Signed-off-by: Adam Ford <aford173@gmail.com>
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Upon second look...

>> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
>> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
>> @@ -49,7 +49,16 @@ properties:
>>    interrupt-names: true
>>
>>    clocks:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 2
>> +    items:
>> +      - description: AVB functional clock
>> +      - description: Optional TXC reference clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: fck
>> +      - const: txc_refclk

On R-Car Gen3 and RZ/G2, RGMII is used, and this clock is called
"txcrefclk", i.e. without underscore.
On R-Car Gen2, GMII is used, and this clock is called "gtxrefclk".

Perhaps it should just be called "refclk"?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

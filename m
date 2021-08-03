Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7173DF457
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238666AbhHCSGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhHCSGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 14:06:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD39261040;
        Tue,  3 Aug 2021 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628013959;
        bh=nImXjFjmZySUkXDy9Ooj86Djc2RxWje23XUkfT8r3po=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KKd/tsUSKDmf8sXTqRHrVD9NiZXVCo75akt97l5dcmZR2T+jOSgtn93B8M70QF2xJ
         DGi9tRq6uTCrQxOBqzWvYJ061vQ1ubXoonSMEZLNouJmrY36Lkh0BLcVhHX2OqOjt5
         DV1L+iq2eYNx7UwrAT4ijmCXMp3JE0M8clYN503JPQA2pqTUwXLv+MxuZjPjEkjklH
         XaYhG3WCnMo5Yx6t+Yj0kEl3jyaATBE1r9eT3fH3Lq5UEuZT6REkOkeZ/jfHIND/fc
         de7rwSRM3LtN/ttZWitnQw9sB9XqN2xztvVYdRDPHAS0bDF2z7CymM4rS9WRF39i8S
         TLiXABr+ityRQ==
Received: by mail-ej1-f50.google.com with SMTP id x11so36752405ejj.8;
        Tue, 03 Aug 2021 11:05:59 -0700 (PDT)
X-Gm-Message-State: AOAM532Mj2K2Suv/R/rawQ4WDLy41QpJSgsdFWICmvEswgoFQm2wpuOr
        alL+ZpK5ivVuK3kmYpF6sUsaeuSg2j+OGHOwsw==
X-Google-Smtp-Source: ABdhPJwjq88bR2zmVlk3HJb6xfJ8Seax75u7h8pWDU+kRV1wURkwmZHJ89lbcdPDqPgt8YFMiRgtjsawJb2AnZn01qM=
X-Received: by 2002:a17:906:95ce:: with SMTP id n14mr20561560ejy.130.1628013958294;
 Tue, 03 Aug 2021 11:05:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210719212456.3176086-1-elder@linaro.org> <20210719212456.3176086-2-elder@linaro.org>
 <20210723205252.GA2550230@robh.at.kernel.org> <6c1779aa-c90c-2160-f8b9-497fb8c32dc5@ieee.org>
 <CAL_JsqKTdUxro-tgCQBzhudaUFQ5GejJL2EMuX2ArcP0JTiG3g@mail.gmail.com> <8e75f8b0-5677-42b0-54fe-06e7c69f6669@ieee.org>
In-Reply-To: <8e75f8b0-5677-42b0-54fe-06e7c69f6669@ieee.org>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 3 Aug 2021 12:05:46 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+fzCJ-S3vkwSYJ_7rmRqO2SdQcf0c-_aUyUNYKA1CwPQ@mail.gmail.com>
Message-ID: <CAL_Jsq+fzCJ-S3vkwSYJ_7rmRqO2SdQcf0c-_aUyUNYKA1CwPQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: qcom,ipa: make imem
 interconnect optional
To:     Alex Elder <elder@ieee.org>
Cc:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "Gross, Andy" <agross@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Evan Green <evgreen@chromium.org>, cpratapa@codeaurora.org,
        subashab@codeaurora.org, Alex Elder <elder@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 6:24 AM Alex Elder <elder@ieee.org> wrote:
>
> On 7/28/21 10:33 AM, Rob Herring wrote:
> > On Mon, Jul 26, 2021 at 9:59 AM Alex Elder <elder@ieee.org> wrote:
> >>
> >> On 7/23/21 3:52 PM, Rob Herring wrote:
> >>> On Mon, Jul 19, 2021 at 04:24:54PM -0500, Alex Elder wrote:
> >>>> On some newer SoCs, the interconnect between IPA and SoC internal
> >>>> memory (imem) is not used.  Reflect this in the binding by moving
> >>>> the definition of the "imem" interconnect to the end and defining
> >>>> minItems to be 2 for both the interconnects and interconnect-names
> >>>> properties.
> >>>>
> >>>> Signed-off-by: Alex Elder <elder@linaro.org>
> >>>> ---
> >>>>    .../devicetree/bindings/net/qcom,ipa.yaml      | 18 ++++++++++--------
> >>>>    1 file changed, 10 insertions(+), 8 deletions(-)
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >>>> index ed88ba4b94df5..4853ab7017bd9 100644
> >>>> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >>>> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >>>> @@ -87,16 +87,18 @@ properties:
> >>>>          - const: ipa-setup-ready
> >>>>
> >>>>      interconnects:
> >>>> +    minItems: 2
> >>>>        items:
> >>>> -      - description: Interconnect path between IPA and main memory
> >>>> -      - description: Interconnect path between IPA and internal memory
> >>>> -      - description: Interconnect path between IPA and the AP subsystem
> >>>> +      - description: Path leading to system memory
> >>>> +      - description: Path between the AP and IPA config space
> >>>> +      - description: Path leading to internal memory
> >>>>
> >>>>      interconnect-names:
> >>>> +    minItems: 2
> >>>>        items:
> >>>>          - const: memory
> >>>> -      - const: imem
> >>>>          - const: config
> >>>> +      - const: imem
> >>>
> >>> What about existing users? This will generate warnings. Doing this for
> >>> the 2nd item would avoid the need for .dts updates:
> >>>
> >>> - enum: [ imem, config ]
>
> In other words:
>
>    interconnect-names:
>      minItems: 2
>      items:
>        - const: memory
>        - enum: [ imem, config ]
>        - const: imem
>
> What do I do with the "interconnects" descriptions in that case?
> How do I make the "interconnect-names" specified this way align
> with the described interconnect values?  Is that necessary?

The schema will only ever check or care that there are 2 or 3 entries.
You can put whatever you want for the description. Or use 'oneOf' to
have the 2 entry and 3 entry cases.

> >> If I understand correctly, the effect of this would be that
> >> the second item can either be "imem" or "config", and the third
> >> (if present) could only be "imem"?
> >
> > Yes for the 2nd, but the 3rd item could only be 'config'.
>
> Sorry, yes, that's what I meant.  I might have misread the
> diff output.
>
> >> And you're saying that otherwise, existing users (the only
> >> one it applies to at the moment is "sdm845.dtsi") would
> >> produce warnings, because the interconnects are listed
> >> in an order different from what the binding specifies.
> >>
> >> Is that correct?
> >
> > Yes.
> >
> >> If so, what you propose suggests "imem" could be listed twice.
> >> It doesn't make sense, and maybe it's precluded in other ways
> >> so that's OK.
> >
> > Good observation. There are generic checks that the strings are unique.
>
> I think I don't like that quite as much, because that
> "no duplicates" rule is implied.  It also avoids any
> confusion in the "respectively" relationship between
> interconnects and interconnect-names.

We could be verbose about it using the 'uniqueItems' keyword, but I
try to make the bindings follow the common case (for DT) rather than
the default for json-schema. If you think about the purpose of
'*-names', non-unique entries would never make sense as the purpose is
to identify what each entry is.

> I understand what you're suggesting though, and I would
> be happy to update the binding in the way you suggest.
> I'd like to hear what you say about my questions above
> before doing so.
>
> >>   But I'd be happy to update "sdm845.dtsi" to
> >> address your concern.  (Maybe that's something you would rather
> >> avoid?)
> >
> > Better to not change DT if you don't have to. You're probably okay if
> > all clients (consumers of the dtb) used names and didn't care about
>
> In the IPA driver, wherever names are specified for things in DT,
> names (only) are used to look them up.  So I'm "probably okay."

Yes, probably so. It's ultimately up to you and the Qcom maintainers
what to do. I'm just providing how you could avoid the change.

Rob

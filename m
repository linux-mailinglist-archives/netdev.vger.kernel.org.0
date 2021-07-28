Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBBA3D9215
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 17:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbhG1Pdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 11:33:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhG1Pdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 11:33:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7330F60FE7;
        Wed, 28 Jul 2021 15:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627486433;
        bh=gXRvKj/jTXShHTI3Z2KiQV2JwSAuffLFbU956dQZa0o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UOoTLTlLbSaltUBPTRmse1nFfSKsz1rMvbo8AAOqruXPOcJo93Agciu83TFYqS9h+
         SI3eTJ91UYapkq3hCC/B1vVRUcM+BQQX8dBY6O/qonVAX54NRPd7P7t9PAwBArKa/q
         zm3sDmOMr69aTfHI7LNF9t1zgmVDjsVqwbohee9Ltwt/+03RDOM+5rg23a9gNCBhtL
         kWvZZdICDSaFV9gKCdV3DOKDypOtSAUkOlQweVfL7wXgjGrapNG+pn9+VfXG1C8D7i
         LCyzFxToEPYoNKqe9Y9gI95wgzKTwbAFYu7PBdeSlwyG1jSQfc0SQphANKzM9NvMEn
         oYk2gmuOysK5Q==
Received: by mail-ed1-f44.google.com with SMTP id f13so3749642edq.13;
        Wed, 28 Jul 2021 08:33:53 -0700 (PDT)
X-Gm-Message-State: AOAM5322sYs7D9ZOKZGa6FsUlBT+D86sfwRxt9yZ4CzjyntxDrw17VV2
        DVnWfzOILCtnqLM1FAH0nUwmMbkEoQ2CcdFFcg==
X-Google-Smtp-Source: ABdhPJzr+OOKQnEGhCp40Qp8isRJj+KNO+AYVQNwWLTcIczd67+YlzldV0glqwoOCUky671peYvE7CwlQmC2L2XQEJM=
X-Received: by 2002:aa7:c603:: with SMTP id h3mr456690edq.165.1627486431954;
 Wed, 28 Jul 2021 08:33:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210719212456.3176086-1-elder@linaro.org> <20210719212456.3176086-2-elder@linaro.org>
 <20210723205252.GA2550230@robh.at.kernel.org> <6c1779aa-c90c-2160-f8b9-497fb8c32dc5@ieee.org>
In-Reply-To: <6c1779aa-c90c-2160-f8b9-497fb8c32dc5@ieee.org>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 28 Jul 2021 09:33:40 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKTdUxro-tgCQBzhudaUFQ5GejJL2EMuX2ArcP0JTiG3g@mail.gmail.com>
Message-ID: <CAL_JsqKTdUxro-tgCQBzhudaUFQ5GejJL2EMuX2ArcP0JTiG3g@mail.gmail.com>
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

On Mon, Jul 26, 2021 at 9:59 AM Alex Elder <elder@ieee.org> wrote:
>
> On 7/23/21 3:52 PM, Rob Herring wrote:
> > On Mon, Jul 19, 2021 at 04:24:54PM -0500, Alex Elder wrote:
> >> On some newer SoCs, the interconnect between IPA and SoC internal
> >> memory (imem) is not used.  Reflect this in the binding by moving
> >> the definition of the "imem" interconnect to the end and defining
> >> minItems to be 2 for both the interconnects and interconnect-names
> >> properties.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> >> ---
> >>   .../devicetree/bindings/net/qcom,ipa.yaml      | 18 ++++++++++--------
> >>   1 file changed, 10 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >> index ed88ba4b94df5..4853ab7017bd9 100644
> >> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> >> @@ -87,16 +87,18 @@ properties:
> >>         - const: ipa-setup-ready
> >>
> >>     interconnects:
> >> +    minItems: 2
> >>       items:
> >> -      - description: Interconnect path between IPA and main memory
> >> -      - description: Interconnect path between IPA and internal memory
> >> -      - description: Interconnect path between IPA and the AP subsystem
> >> +      - description: Path leading to system memory
> >> +      - description: Path between the AP and IPA config space
> >> +      - description: Path leading to internal memory
> >>
> >>     interconnect-names:
> >> +    minItems: 2
> >>       items:
> >>         - const: memory
> >> -      - const: imem
> >>         - const: config
> >> +      - const: imem
> >
> > What about existing users? This will generate warnings. Doing this for
> > the 2nd item would avoid the need for .dts updates:
> >
> > - enum: [ imem, config ]
>
> If I understand correctly, the effect of this would be that
> the second item can either be "imem" or "config", and the third
> (if present) could only be "imem"?

Yes for the 2nd, but the 3rd item could only be 'config'.

>
> And you're saying that otherwise, existing users (the only
> one it applies to at the moment is "sdm845.dtsi") would
> produce warnings, because the interconnects are listed
> in an order different from what the binding specifies.
>
> Is that correct?

Yes.

> If so, what you propose suggests "imem" could be listed twice.
> It doesn't make sense, and maybe it's precluded in other ways
> so that's OK.

Good observation. There are generic checks that the strings are unique.

>  But I'd be happy to update "sdm845.dtsi" to
> address your concern.  (Maybe that's something you would rather
> avoid?)

Better to not change DT if you don't have to. You're probably okay if
all clients (consumers of the dtb) used names and didn't care about
the order. And I have no idea if all users of SDM845 are okay with a
DTB change being required. That's up to QCom maintainers. I only care
that ABI breakages are documented as such.

> Also, I need to make a separate update to "sm8350.dtsi" because
> that was defined before I understood what I do now about the
> interconnects.  It uses the wrong names, and should combine
> its first two interconnects into just one.

If the interconnects was ignored in that case, then the change doesn't matter.

Rob

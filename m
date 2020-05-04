Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B673C1C466C
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgEDSwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgEDSwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 14:52:30 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 100102073E;
        Mon,  4 May 2020 18:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588618349;
        bh=3Ha52XgoS8/4Yl319juPJCrmPW0Ttr1geD7MdSO8LIE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XLSwU/Qf0ogTE0CtscTX5f6VBjWOx2GHPz/nrM/uaXYsnFyVNJw0uS9yz3IMupLFL
         eXG7oip5dn0LiQh4mKbZWQqMuMvlaVGB+BOoanqiAbtmBln2dKsPuUJf3EqcfBAurl
         tiXyeUeav9GizHRf/XhQXTUC5s7YkFuEPh0UKaa8=
Received: by mail-oi1-f181.google.com with SMTP id o7so7617825oif.2;
        Mon, 04 May 2020 11:52:29 -0700 (PDT)
X-Gm-Message-State: AGi0PuZEKizU2SRSTj+8FXU9CcQa5dPWfEwSHt0h3RvfgkuogELP45As
        cmqaIqVIJAQmx60ss9F3zBvNTfn8rVY9bmnt/w==
X-Google-Smtp-Source: APiQypLERbCjXmAD9kScXWp+0jLyUa/wK6ffbmYWXz4/VHjupVQvQVBEQSBvA5Wg6mUwQJ+1TlFFTO/AGTkgyn+G/pE=
X-Received: by 2002:aca:1904:: with SMTP id l4mr10035883oii.106.1588618348223;
 Mon, 04 May 2020 11:52:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200504175859.22606-1-elder@linaro.org> <20200504175859.22606-2-elder@linaro.org>
In-Reply-To: <20200504175859.22606-2-elder@linaro.org>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 4 May 2020 13:52:15 -0500
X-Gmail-Original-Message-ID: <CAL_JsqLY2iuJHXEEx41eEVPgkwmHbngOB53sFgF1e079uLOOqQ@mail.gmail.com>
Message-ID: <CAL_JsqLY2iuJHXEEx41eEVPgkwmHbngOB53sFgF1e079uLOOqQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] dt-bindings: net: add IPA iommus property
To:     Alex Elder <elder@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Evan Green <evgreen@chromium.org>, subashab@codeaurora.org,
        cpratapa@codeaurora.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, devicetree@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 12:59 PM Alex Elder <elder@linaro.org> wrote:
>
> The IPA accesses "IMEM" and main system memory through an SMMU, so
> its DT node requires an iommus property to define range of stream IDs
> it uses.
>
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 140f15245654..7b749fc04c32 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -20,7 +20,10 @@ description:
>    The GSI is an integral part of the IPA, but it is logically isolated
>    and has a distinct interrupt and a separately-defined address space.
>
> -  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.
> +  See also soc/qcom/qcom,smp2p.txt and interconnect/interconnect.txt.  See
> +  iommu/iommu.txt and iommu/arm,smmu.yaml for more information about SMMU
> +  bindings.

I'd drop this. We don't need every binding to reference back to common
bindings. And in theory, this binding is unrelated to the Arm SMMU.
Any IOMMU could be used.

With that,

Reviewed-by: Rob Herring <robh@kernel.org>

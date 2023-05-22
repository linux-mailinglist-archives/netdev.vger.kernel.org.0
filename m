Return-Path: <netdev+bounces-4390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2602E70C525
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:27:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5FCF2810D2
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F055168A8;
	Mon, 22 May 2023 18:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03695168A7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:27:14 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E366DB7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:27:12 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f60444238cso15280505e9.3
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google; t=1684780031; x=1687372031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dde97R89Md6V2pF7Jo7GpR1OiPPYejdIL3uT2QHQik8=;
        b=PlSJAoHfBEl5jgtH2ajA5/RPOKBr6SWbVwyY33Ofq+2dix5Xbn1+G3fUhDAkQjJY7B
         NPf6s+tS5cKZyjn4MtChpInwyLvL1/73oMQQKQVaqlVaDPwmR1Z2J0B9L0PSpa3nY9K/
         0we1yo8L6/teOeoIraoaq0+6wV2jSoWZOORDFtjiGFmjsJIOukZsz3YDRJWLotL1QPIN
         Bd0ivnggzwl883J9bAigYwI3Dz/hnBuSBKuKuC0JF9ctZxGWadSR5KZ0e/PgVlwJnW4X
         XzxTfmgYVQuyucIHj9cu1DzyYdxkYi0IL7vzjn1fSAYYZi472WmSAhOMnmkBQJi+L6R+
         rvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684780031; x=1687372031;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dde97R89Md6V2pF7Jo7GpR1OiPPYejdIL3uT2QHQik8=;
        b=AxkY+NnMDnDRVRtMzP1cJql8W4C16MGX2UJSS1VFxrBwtPsDwNYQpQabueCnpSSPlM
         61AXP47/gPRkV8wsmmbvNQ1Ko2EULpAZpZfWtCQnj+TYuhEL/i+kkC5/imkyQVp2uSIl
         U0oxshuP4CcFXJSZl7xKqTsy8+1M19qw4OJDjBIe1z38J9ezNBDazdeRvpAuHYE4+hdn
         /JbHv5EHyskJgfZ9Xrkfk18YOzlH4BPpDZT9zJTwxOfVe3ojxstYghYlwcRX3Ok5sK57
         rSHU5SW8y/Z8yTW74b1JZO1x6dvDDCOryPG/woisUkGvXurlgAVF7n4mucVagxVeX51B
         aL1g==
X-Gm-Message-State: AC+VfDwcucPTnhoE6ompgatY+9CrMZ130Zl7t3FADZFfMmgP+D9bBDJT
	GrzYd06PKQainmlGkn2VLc74Pg==
X-Google-Smtp-Source: ACHHUZ6kWFfckNngKg+tH40+Yss9WOVsPO4kAvHw/TA+yOcWG6pouHhkoTCnCXnIaluKbsSv8gGSCg==
X-Received: by 2002:a1c:7c01:0:b0:3f5:db0f:4a74 with SMTP id x1-20020a1c7c01000000b003f5db0f4a74mr8447054wmc.21.1684780031389;
        Mon, 22 May 2023 11:27:11 -0700 (PDT)
Received: from [192.168.2.9] ([51.37.135.152])
        by smtp.gmail.com with ESMTPSA id o9-20020adfeac9000000b0030633152664sm8573132wrn.87.2023.05.22.11.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 11:27:10 -0700 (PDT)
Message-ID: <d56f205c-dae8-a191-f2af-fed6bea060ad@conchuod.ie>
Date: Mon, 22 May 2023 19:27:09 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Content-Language: en-US
To: Justin Chen <justin.chen@broadcom.com>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 bcm-kernel-feedback-list@broadcom.com
Cc: justinpopo6@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
 florian.fainelli@broadcom.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
 opendmb@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
 linux@armlinux.org.uk, richardcochran@gmail.com, sumit.semwal@linaro.org,
 christian.koenig@amd.com
References: <1684531184-14009-1-git-send-email-justin.chen@broadcom.com>
 <1684531184-14009-3-git-send-email-justin.chen@broadcom.com>
From: Conor Dooley <mail@conchuod.ie>
In-Reply-To: <1684531184-14009-3-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:19:40PM -0700, Justin Chen wrote:
 > From: Florian Fainelli <florian.fainelli@broadcom.com>
 >
 > Add a binding document for the Broadcom ASP 2.0 Ethernet controller.
 >
 > Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
 > Signed-off-by: Justin Chen <justin.chen@broadcom.com>
 > ---

Same deal here, usual mailer is refusing to reply cos of:
Problem signature from: 
1.2.840.113549.1.9.1=#6A757374696E2E6368656E4062726F6164636F6D2E636F6D,CN=Justin 
Chen,O=Broadcom Inc.,L=Bangalore,ST=Karnataka,C=IN
                    aka: <justin.chen@broadcom.com>
                created: Fri 19 May 2023 10:19:57 PM IST
                expires: Wed 10 Sep 2025 01:39:50 PM IST

 > v3
 >         - Minor formatting issues
 >         - Change channel prop to brcm,channel for vendor specific format
 >         - Removed redundant v2.0 from compat string
 >         - Fix ranges field
 >
 > v2
 >         - Minor formatting issues
 >
 >  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 145 
+++++++++++++++++++++
 >  1 file changed, 145 insertions(+)
 >  create mode 100644 
Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 >
 > diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml 
b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 > new file mode 100644
 > index 000000000000..a9fed957e1d6
 > --- /dev/null
 > +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
 > @@ -0,0 +1,145 @@
 > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 > +%YAML 1.2
 > +---
 > +$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
 > +$schema: http://devicetree.org/meta-schemas/core.yaml#
 > +
 > +title: Broadcom ASP 2.0 Ethernet controller
 > +
 > +maintainers:
 > +  - Justin Chen <justin.chen@broadcom.com>
 > +  - Florian Fainelli <florian.fainelli@broadcom.com>
 > +
 > +description: Broadcom Ethernet controller first introduced with 72165
 > +
 > +properties:
 > +  '#address-cells':
 > +    const: 1
 > +  '#size-cells':
 > +    const: 1
 > +
 > +  compatible:
 > +    enum:
 > +      - brcm,asp-v2.0
 > +      - brcm,bcm72165-asp
 > +      - brcm,asp-v2.1
 > +      - brcm,bcm74165-asp

One of Rob's questions on V(N-1) that seems to have been ignored/only
partly implemented:
 > You have 1 SoC per version, so what's the point of versions? If you have
 > more coming, then fine, but I'd expect it to be something like this:
 >
 > compatible = "brcm,bcm74165-asp-v2.1", "brcm,asp-v2.1";

You did drop the -v2.1 that he requested from the SoC compatible, but I
amn't sure why the above was not implemented (at least there's no
explanation in the previous thread's version, nor in the changelog
here...)

Cheers,
Conor


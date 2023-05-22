Return-Path: <netdev+bounces-4386-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6867E70C505
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ABF12810A6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBB201643A;
	Mon, 22 May 2023 18:17:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C0B16435
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:17:59 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D484AF1
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:17:57 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f423521b10so42021755e9.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=conchuod.ie; s=google; t=1684779476; x=1687371476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q7P+DBBi+Cpf56qPunfuWd9Z9zfzbOV/OEECAbDuPS8=;
        b=Ee4VTVCP4jy7R9WxX+j5tVAlpJhGMDBcv3CT1skxCdyzrPx62chpLscHjIMwYGAJB3
         wrwqvGxMJxaiPopuXUboolfovc0wzwa9hIbBATh/w0XiFbWT80cyGwNdtz6kHMUgwrB3
         UCxYnUsrsMHDDh7w2nU0SViJ6AqMwoDptIpKL4tlqOt7dFHCT91TMgbe9pVqmWWbAnkR
         zPxUf05MRoTgoiuF29tk1G25LCaUWGTqIDPoqCNywD9HjyvnJGwxzczqodsYkEx9iETM
         NZXvj0d+vAjDz+Uun5iNHtViO4mQimTebuoca2g+rr+7YXdIm3nkCKke7or0VHuxRgxx
         7JfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684779476; x=1687371476;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7P+DBBi+Cpf56qPunfuWd9Z9zfzbOV/OEECAbDuPS8=;
        b=iGkGAFQcJQ5DiSIBSXiGx2KNFkOPzinxMnDDZt/D4POmhfiM5gbs6S8SayHQKwTZeO
         hI6Q+F12aamkzgGyvxo7bU/3ZY0rD1NwzAY/u9C9HJ1uvsCC42iX7e5nITUyffeHiU5M
         zSy891Oh87Sax4398TOlMtSU7bzOj34NqAJBPguQDBRgedlkODe8DxB6mmZVRuC4N8tk
         K5CY7unoWUsM4k72gFUH8feUBHHNzPAd1qgPviLYkmJApwfPfKqwMG8ALLpZRDptpezt
         Ek+mP63I0eJCiLo9gYeVLfnSHo+MSDYxVlNfnOtorNCkVlH10YiotSFwoRHCBLGJMOm3
         +bVA==
X-Gm-Message-State: AC+VfDz2sf8Vok0Nh3x5O0bass9dDOVNbW+34KrlcZKsvqagW/NULkFM
	WhNbkzFwJSUn6vYhd03UxOAM4GPNZP3aeUqhmCQ=
X-Google-Smtp-Source: ACHHUZ5b3fcaOykV0SCUoXoLnAw7b7jZX2zv8R6gkhGbukcjSahYAvAxwwOdzoAPXg6RYwfEJecFKw==
X-Received: by 2002:adf:e409:0:b0:2d5:39d:514f with SMTP id g9-20020adfe409000000b002d5039d514fmr9646442wrm.65.1684779476291;
        Mon, 22 May 2023 11:17:56 -0700 (PDT)
Received: from [192.168.2.9] ([51.37.135.152])
        by smtp.gmail.com with ESMTPSA id j18-20020adff012000000b00304adbeeabbsm8470252wro.99.2023.05.22.11.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 11:17:55 -0700 (PDT)
Message-ID: <2be2af5e-d117-fa2c-f960-e7f0c3ca3d0b@conchuod.ie>
Date: Mon, 22 May 2023 19:17:54 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3 1/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
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
 <1684531184-14009-2-git-send-email-justin.chen@broadcom.com>
From: Conor Dooley <mail@conchuod.ie>
In-Reply-To: <1684531184-14009-2-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 02:19:39PM -0700, Justin Chen wrote:
 > The ASP 2.0 Ethernet controller uses a brcm unimac.
 >
 > Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
 > Signed-off-by: Justin Chen <justin.chen@broadcom.com>
 > ---
 >  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
 >  1 file changed, 2 insertions(+)
 >
 > diff --git 
a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml 
b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
 > index 0be426ee1e44..6684810fcbf0 100644
 > --- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
 > +++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
 > @@ -22,6 +22,8 @@ properties:
 >        - brcm,genet-mdio-v3
 >        - brcm,genet-mdio-v4
 >        - brcm,genet-mdio-v5
 > +      - brcm,asp-v2.0-mdio
 > +      - brcm,asp-v2.1-mdio
 >        - brcm,unimac-mdio


 From V(N-1), there was some discussion between Rob & Florian:
 > > How many SoCs does each of these correspond to? SoC specific 
compatibles
 > > are preferred to version numbers (because few vendors are disciplined
 > > at versioning and also not changing versions with every Soc).
 >
 > So far there is a 1:1 mapping between the number of versions and the
 > number of SoCs, and the older SoC uses v2.0, while the newer one uses 
v2.1.

Rob's not around right now, but I don't really get why if there is a 1:1
mapping you don't just name these things after the SoCs?

Also, my mailer **refused** to let me reply to you because of something
to do with a garbage S/MIME signature? Dunno wtf is happening there.

Cheers,
Conor.


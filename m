Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75513428394
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 22:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhJJUxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 16:53:32 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:49110
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231383AbhJJUxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 16:53:31 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 22CE740018
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 20:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633899091;
        bh=v9Hlca2h1Hh9i8XXavu//vSEpOtNM2PYGAkdRD7X2go=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=eSiOCR08VSndoL3MoLZo6293d9n946NmCqk3ZqiG7v49AlXr4vaXrK/zlb5AFLpeS
         MBvJQjlwIRoR71iyKPM9W2Efaa5f68N1Y7omf2N+RA3z+Bt/JM3KeWprtlyhiQ2Mz3
         zW3BEtW5OjzwmRZ+XbF/Mcmw/+lId5b67Ymcn7lNUTO9fgWff0yl+Xa7XNw5OL7H1v
         l8OqnOvYTJDVHvvPduI524UMRUAhiUGcTOU68F1lqFxvVB7Y4oHUJDqtozHWM0Kv8g
         H1UPP1Y3FAoMaLKq9Wi+qUmvVxJgHniB/XJSJu+Tce/irTTiTbso21L3zX4YcHgd6g
         E7zuqhS7a+qAQ==
Received: by mail-ed1-f69.google.com with SMTP id d3-20020a056402516300b003db863a248eso1921830ede.16
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 13:51:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v9Hlca2h1Hh9i8XXavu//vSEpOtNM2PYGAkdRD7X2go=;
        b=mRPhMQi0Sz7wJu1quZBTZqr5u+LsqOdZAYB0Pnsw4vzlJFxlju3dKo7tJaE8WTM8Cn
         ZpUwGQDOauPzyM/gxiI5iX7adwR/e/0hoawOU9onaeejH+ZkOijKoUNWWUgFHGoRKHM4
         GdyPApRtibeK1OKFPZ/reDAK9N+n3/7CdCljPcjGYpNi7sibk6NHGCbaFVxYji41eH0H
         XOS9vLbogRudEIYz5GaxDRSL36yeZ0YVJxUs1/7z1z8EY+ekY8ZruEoMC3ZI5jsMQvXh
         hvnSE8bmyKPNwHlQ7DPD1ltakCm1peLLrolWYPrbIFtwEhCd7xCq+t66w0DMTqoRYtNu
         6QbQ==
X-Gm-Message-State: AOAM533e7LbfUFM7zuZZvC+O8j0D/DqkpimS1uAQOVRnI1Eg2ooehn7K
        ThK1Kznbdc3g0K+7bbhVX/YejDv6uLKUu9QPpFSOmd+hOgHFSLm1gLyZZ5OTOoYrMV4ZIEMtOP2
        mpC5hOhqWirgPBzh+/F/xD3tJntY/d8SR4w==
X-Received: by 2002:a17:906:3192:: with SMTP id 18mr21236979ejy.246.1633899090339;
        Sun, 10 Oct 2021 13:51:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjRNid0wZoUMAIiXI0MXbANDRhB9LTg/OYg47esYCah+m3e1tvb/+lQTYbtBYkGvBFAh3XVw==
X-Received: by 2002:a17:906:3192:: with SMTP id 18mr21236965ejy.246.1633899090203;
        Sun, 10 Oct 2021 13:51:30 -0700 (PDT)
Received: from [192.168.0.20] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id m9sm3032908edl.66.2021.10.10.13.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 13:51:29 -0700 (PDT)
Subject: Re: [PATCH 6/7] dt-bindings: nfc: ti,trf7970a: convert to dtschema
To:     Rob Herring <robh@kernel.org>
Cc:     linux-nfc@lists.01.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20211010142317.168259-1-krzysztof.kozlowski@canonical.com>
 <20211010142317.168259-6-krzysztof.kozlowski@canonical.com>
 <1633894316.452946.3158671.nullmailer@robh.at.kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <a16d9765-a5d1-c8bc-729d-1c807b24e393@canonical.com>
Date:   Sun, 10 Oct 2021 22:51:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1633894316.452946.3158671.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2021 21:31, Rob Herring wrote:
> On Sun, 10 Oct 2021 16:23:16 +0200, Krzysztof Kozlowski wrote:
>> Convert the TI TRF7970A NFC to DT schema format.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>  .../bindings/net/nfc/ti,trf7970a.yaml         | 98 +++++++++++++++++++
>>  .../devicetree/bindings/net/nfc/trf7970a.txt  | 43 --------
>>  MAINTAINERS                                   |  2 +-
>>  3 files changed, 99 insertions(+), 44 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
>>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>>
> 
> Running 'make dtbs_check' with the schema in this patch gives the
> following warnings. Consider if they are expected or the schema is
> incorrect. These may not be new warnings.
> 
> Note that it is not yet a requirement to have 0 warnings for dtbs_check.
> This will change in the future.
> 
> Full log is available here: https://patchwork.ozlabs.org/patch/1539014
> 
> 
> nfc@0: 't5t-rmb-extra-byte-quirk', 'vin-voltage-override' do not match any of the regexes: 'pinctrl-[0-9]+'
> 	arch/arm/boot/dts/imx6dl-prtrvt.dt.yaml

I already sent a patch for this one.


Best regards,
Krzysztof

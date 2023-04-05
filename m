Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035DA6D7C61
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbjDEMYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237913AbjDEMYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:24:20 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B5F59EC;
        Wed,  5 Apr 2023 05:24:17 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f22so30122449plr.0;
        Wed, 05 Apr 2023 05:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680697457; x=1683289457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cSHldcD6x6OkSukH2A4+KIAmOt/vTFH0n3uNEfZheM=;
        b=KZ+2oKQQj/BQzqlPS+ODxOsvqDAIFLxK2XmLg5UV5miE0bD6qg28SvVIro3RNJ6Qdn
         1PBvI/6fpSL4FfI97sr6yCxL7DCOvbCR2BVHKNGKhuJfRiBIILaonNBtACJQhwR45H5h
         AN7U9lCE4/lCEwMrLdYnCW3cWBt1QTVXr744f85IWvY9PMdeWxNsjKSR77xvH1ClGkKy
         PhERKeXh1uHi2CmY/NlxsUhNCHI1tMPzk1S98KdmFSCvNXGJlE35BrwQ+ji+qLLunPDQ
         Gmt8ELu5AtTOc7b80RvAofn4VhwZPLgJmki/9zXeKtq0OqyhiSUZOKFO8A6CIsohpECb
         1DGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680697457; x=1683289457;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cSHldcD6x6OkSukH2A4+KIAmOt/vTFH0n3uNEfZheM=;
        b=gb0XZUX5F6NORMzjEDjBjkElpHVD5mAHROtfX9EgSG2nRqgVJoCzhraaEhtAOmtag2
         gQj/GCjxoCKMTiH8OT2ZYoPefKccXmALojKLKN9IjZvWPy2JrBOJGJYxGqvtQxKYEyvI
         alyz5GE6dMb9Z7gUbo5fSKs9qKO4q/+XvGm78/HcgASL+7gRDjCVF5vbgcT6kJMBAo3N
         lxvhQSMWanpqUckK8XwckGvLBbqfOsRSi77ZAdaHdsr+LOwdCL5i2XTl8wDtgk8ScB9t
         UVt7IXa4SXC4pDbR7KfeKMc/yxjqMHgQpetiSV7hMuDbToyY3ydYvcWneT14ZHsKorVC
         Nhng==
X-Gm-Message-State: AAQBX9fDbq5IlwfkB9brqfYqPuy4O5RpVh03WUxJVmw6M/r+MAzO9HfG
        XSPhleu1QI+b8lJd/UdQjyw=
X-Google-Smtp-Source: AKy350b1tEshoc0gv7xw6Q4usjBSMvRbEndbgUprSAo9ed8eZkoBrGkqq5NNPCclGWpaIVa9IBmvKA==
X-Received: by 2002:a05:6a20:1aa2:b0:d9:b0b5:fdaf with SMTP id ci34-20020a056a201aa200b000d9b0b5fdafmr5236961pzb.48.1680697456622;
        Wed, 05 Apr 2023 05:24:16 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d17-20020aa78e51000000b006089fb79f1esm10909015pfr.96.2023.04.05.05.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 05:24:15 -0700 (PDT)
Message-ID: <cca77857-4a1a-6b56-5dfa-0eda752d371f@gmail.com>
Date:   Wed, 5 Apr 2023 05:24:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] dt-bindings: net: dsa: brcm,sf2: Drop unneeded
 "#address-cells/#size-cells"
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230404204152.635400-1-robh@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230404204152.635400-1-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/4/2023 1:41 PM, Rob Herring wrote:
> There's no need for "#address-cells/#size-cells" in the brcm,sf2 node as
> no immediate child nodes have an address. What was probably intended was
> to put them in the 'ports' node, but that's not necessary as that is
> covered by ethernet-switch.yaml via dsa.yaml.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

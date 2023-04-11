Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA706DE857
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDKX54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKX5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:57:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59593C17;
        Tue, 11 Apr 2023 16:57:54 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb34so24753378ejc.12;
        Tue, 11 Apr 2023 16:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681257473; x=1683849473;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lM8PNDHiM8fHyWmRYtIDydQ9V3GrA9VGsex5qRTzOK4=;
        b=eIimPGklDS8LURKBDS2oanZNRLBmME8ZzTAyhDb7U7X/mKlEFlsAivozD9YvJ+out+
         osKPpSFXBuETkjVObB+TzXxUz+tafduR0qySwSMipaBvelJPYhnmDLhOXQEPQW92ncqV
         qJONHY4lrMhx3SFYoXGrkImtNjBj9QfxSr182uctUJSx114X7bhkagiGPtuvRoBRFtqi
         LQBDT87AXdpyFbBusi03zhADvt0kiVBeBWHu9tme64+6eFK0+38lqgVIJmO0ZQridH0q
         4R82q9lYcGXtbzTsq3xnYsR3Qm/NBU50E6vpHx+kl8VzGbtmJKCLAsBmmfk1t8aY16qA
         YTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681257473; x=1683849473;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lM8PNDHiM8fHyWmRYtIDydQ9V3GrA9VGsex5qRTzOK4=;
        b=FsdAPS+NbQIeQ47wUmP5A6DNrSEb2KnHU61uciSzy4xyPNcjE1qdgjBuNMEs91wMlZ
         HsZhGsGWaEo8+lXmDFW8eKo9tq2sa5ZXh+WL7ytlVd0t27h6CIcxN6FSLr6AKK7Huoty
         cTKjw39RnikTavNH4q4/aDO/lPODpGWg0HY+n24Nyu/XqFmDtJFsXF6AaymnDZU7fUoX
         AsANWUZxobp4PCI/2W6katxPpjuKxpCbfigHuNDRSbH934pCEYLCpnfe/gsdcFobX9eY
         FNxh5QqQnzaSlPCuaIKpKT/oQHpl3to7oghSXlKCBWE/gtz6CWDvvyVML0wMuDltJtNw
         5TMw==
X-Gm-Message-State: AAQBX9cvTOScsxEVGgN+SkVxMdFair26UDOuLszoeUFYl0Dk5svL2YSd
        CXRx8KKgLuWi7Q+NwAW1FbE=
X-Google-Smtp-Source: AKy350YkQiw3MsY7AfwW21RPuFGBlZIrGU9UF9vXpvE2F4eHtuRwpDdUQ0Y4YJYHguhABSgCzP86og==
X-Received: by 2002:a17:906:4346:b0:947:7b89:6779 with SMTP id z6-20020a170906434600b009477b896779mr10506148ejm.46.1681257473007;
        Tue, 11 Apr 2023 16:57:53 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090617cb00b008c16025b318sm6595878eje.155.2023.04.11.16.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 16:57:52 -0700 (PDT)
Date:   Wed, 12 Apr 2023 02:57:49 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     arinc9.unal@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2 1/7] dt-bindings: net: dsa: mediatek,mt7530: correct
 brand name
Message-ID: <20230411235749.xbghzt7w77swvhnz@skbuf>
References: <20230407125008.42474-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230407125008.42474-1-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arınç,

On Fri, Apr 07, 2023 at 03:50:03PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The brand name is MediaTek, change it to that.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---

It is good practice for series larger than 2 patches to create a cover
letter, which gives the overview for the changes. Its contents gets used
as the merge commit description when the series is accepted.

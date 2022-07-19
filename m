Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFAB57A04D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiGSOE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiGSOEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:04:16 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41897709BC;
        Tue, 19 Jul 2022 06:16:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ez10so27062503ejc.13;
        Tue, 19 Jul 2022 06:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=27WXKLo8OzZyJO+cy0BM2+gz2HmgsgcFDHxddHeXL3w=;
        b=NiHOwhCjpanxhD6MQCA9vzkSMd4TD3gdOy2cErIXQmTFBVYyaFECUAe7K+1jUmo3cE
         ER2Rmk3skg9oUAXZ6Ms7UdNcatQkp99Z99eBX7DDIVRUtvlFpS+ACvPuVBnGQRrmGB7/
         G+m8DWacJ1uSAPZyCB4rlzT+ib1HzWVRLZCY0GE2mzfg/iiPMjEb3/NiBOLjxn+6eQul
         uebaKRDOrpoyjdrwftAJiBTo+3zq7GnhwXEqV0CwJCtTQrairVwK94UDjlmGe9mkB9Xi
         0R+7FD2EXrWbGuxYTQY+8B73+bsqtddyzwh/2BHJySTlAI6LhlYbPw6Z5glvEd9COV2S
         ZA2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=27WXKLo8OzZyJO+cy0BM2+gz2HmgsgcFDHxddHeXL3w=;
        b=DTrmEJXMO/Xa/vrgA5hzEs2g+/pdsrdWrwfuryI1w5Opa0MjkLzb4u759Dz3cJ1ggB
         fJBU6xyWiDhOkKdbXoc88nePq4OSlgaHTU9sFkqIQVUvZgtYUyC60/bmt26YwPNgfRGN
         keAtX3tTwonFHN7z8OTcNCyaJqcWQ4dEaUa5d2Sx4BDs0hBsxG4QGMhedRP8osRggL+E
         xKOYIvIauH3UQ3XLrYPoZCQPRiZjsmTbWMpEB0BpIunobAWnf/H4PTGF2Y8EfoTRU1ao
         4ipJw1+J0LdffjYVDFwdmV1aRctv39ogijt2VaRDEFl69QZur0LnEcCEdHBWxdBSb7ML
         pNKQ==
X-Gm-Message-State: AJIora+OnUtEF64sA27s/QEzLH8KIYNI1tkMEg1xb16aELOZzSRvOp4T
        EiuHev5DR+R3ZKFKVw+v/aU=
X-Google-Smtp-Source: AGRyM1uIBLIZhVnPev8B2o44mFFcZp81AhhFo5G4RF057/JHv7xadn+al0Bl31FW5cW725dFIIHXyQ==
X-Received: by 2002:a17:907:94d1:b0:72f:10c:bb3c with SMTP id dn17-20020a17090794d100b0072f010cbb3cmr19195386ejc.532.1658236572651;
        Tue, 19 Jul 2022 06:16:12 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906329200b0072b2eab813fsm6456536ejw.75.2022.07.19.06.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:16:11 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:16:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 07/15] net: dsa: qca8k: move bridge functions
 to common code
Message-ID: <20220719131609.gfzkkrvvssw2h75p@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-9-ansuelsmth@gmail.com>
 <20220719005726.8739-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-9-ansuelsmth@gmail.com>
 <20220719005726.8739-9-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:18AM +0200, Christian Marangi wrote:
> The same bridge functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

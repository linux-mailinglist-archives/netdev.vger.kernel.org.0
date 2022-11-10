Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407A56242E2
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 14:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiKJNIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 08:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiKJNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 08:08:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC1457B77
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668085624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zMAudJpmdEKZtCKUy+05rwV5mHOrkDZJoA0XJ15CQ4=;
        b=TRNF16fIQg+6rv+ss24naYjUwi8Ge9/bk1EP0EyBLmbMXJPVyKWUaEZBjJ6mw+6GFweXJy
        Vo50vZSIY+LTYSXnLOWMeJamBmEcH3mod/u0eBh8eoqjeuxb3CA3RQfw7Xy5U/wnJTHyw1
        KkYBDxPyKpzZXxksetqQIT95nmmHNLY=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-MWPmRF_3N0W2hYTQYwhxCg-1; Thu, 10 Nov 2022 08:07:03 -0500
X-MC-Unique: MWPmRF_3N0W2hYTQYwhxCg-1
Received: by mail-pf1-f197.google.com with SMTP id e8-20020a056a00162800b0056e953c5088so1025121pfc.2
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 05:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8zMAudJpmdEKZtCKUy+05rwV5mHOrkDZJoA0XJ15CQ4=;
        b=sjg3oMXWETYI1LZNleOR+LUCILhm5rOzVJQ7KfVIjrZr6Ri48RJQzauRARy5aKeHlD
         9VudRFyuIIItYYa/yEnluZx5UD79Px/SXfZTmnHsDRyV1MpkATokrY3gHZkocjzu0uvc
         Oy43CVFkJFlSHuOJ4XayVWn4IlkWdzlqU+hhuC/+mBouZN86JyYuBSvtqbrWpT2ZITY1
         fGJTMe0h4F7USbNDVdZgfgcqqRoSrL/6x+pfUJrAwCMMfxw7KWo4RUX3+tMLjsVj2YMm
         /ePTgPcYE/VIg50TAcdGtP4+mYexlSaCuiSlRYcsICx9iEm0JYdqKjggxRskIi/vTxoY
         ayGg==
X-Gm-Message-State: ACrzQf1hT2I+aEYp1REmwriOxmMOauk427MBvLz8BJiI4Er0LIV9kDLh
        eV3UeYKeszlNukZpojxPwBjKx3vPSWIdJPhD79VO8YcQsAwZI2flrvvcZ33WwEuugiUTGhZnh3q
        iCgCIctt+6m0DxqyO
X-Received: by 2002:a63:155b:0:b0:470:1a0b:ce3d with SMTP id 27-20020a63155b000000b004701a0bce3dmr34429933pgv.597.1668085621961;
        Thu, 10 Nov 2022 05:07:01 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4/ry76eNdJLG8wkw95+ZE+UZX4fN3mjnXvdaEyH+JPEN9B5VVng2ZratTCNQe1UctwEEQHtQ==
X-Received: by 2002:a63:155b:0:b0:470:1a0b:ce3d with SMTP id 27-20020a63155b000000b004701a0bce3dmr34429912pgv.597.1668085621657;
        Thu, 10 Nov 2022 05:07:01 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id lw5-20020a17090b180500b0020af2bab83fsm3081270pjb.23.2022.11.10.05.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 05:07:01 -0800 (PST)
Message-ID: <d5f0dea1b9ce5f8d2187875adb1d73e747e21916.camel@redhat.com>
Subject: Re: [PATCH net-next v5 3/3] net: ethernet: ti: am65-cpsw: Add
 support for SERDES configuration
From:   Paolo Abeni <pabeni@redhat.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, vigneshr@ti.com,
        nsekhar@ti.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
Date:   Thu, 10 Nov 2022 14:06:47 +0100
In-Reply-To: <20221109042203.375042-4-s-vadapalli@ti.com>
References: <20221109042203.375042-1-s-vadapalli@ti.com>
         <20221109042203.375042-4-s-vadapalli@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Wed, 2022-11-09 at 09:52 +0530, Siddharth Vadapalli wrote:
[...]

> +static void am65_cpsw_disable_serdes_phy(struct am65_cpsw_common *common)
> +{
> +	struct device_node *node, *port_np;
> +	struct device *dev = common->dev;
> +	const char *name = "serdes-phy";
> +	struct phy *phy;
> +
> +	node = of_get_child_by_name(dev->of_node, "ethernet-ports");
> +
> +	for_each_child_of_node(node, port_np) {
> +		phy = devm_of_phy_get(dev, port_np, name);

The above will try to allocate some memory and can fail. Even if the
the following code will handle a NULL ptr, the phy will not be
disabled.

I think it's better if you cache the serdes phy ptr in
am65_cpsw_init_serdes_phy() and you use such reference here, without
resorting to devm_of_phy_get().

Cheers,

Paolo


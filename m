Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9B9501414
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346979AbiDNO0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348432AbiDNORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:17:37 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20DE643C;
        Thu, 14 Apr 2022 07:09:31 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id lc2so10238015ejb.12;
        Thu, 14 Apr 2022 07:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2rkXhqhY7efsoNHeKBNjLWLTlehipPL06cKEYrELDoE=;
        b=oPdb6JdCw9IROlIzMRiYvvz2TRgW/BxWVCTViSQmffZKBYt7tKf0QUZxJJZZ//oGlH
         sljcWr/8dqrxBTqwehzh/2DdgVuDTUXLafbuBKSvNLm92yhE7VhdTky2atxs7bh5CMn2
         8iFO5a77ZQ7ANOxWhdhT8VjyBIsk4WXGDmFg72r3ERAqy5KOaqkxzgQSIsGcWN/IyXnZ
         CXsdxlBacFCJpUDpN6OvI3hp5MOS+PnZZI6d9FsVjWiTfKqZTsAeod4FKaxyINLjaGrP
         8qZZOOMxVnlVJaW9DW3IyC3DtjGgtmwKXujK+U204FK5IIr2v1/7ZhDMGjBjYZogsuzH
         Zwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2rkXhqhY7efsoNHeKBNjLWLTlehipPL06cKEYrELDoE=;
        b=PFMEeDttYOZJdNsZbMGboFwZoqTV0N7z2CgrpfTpTz9VNnoPvL6AsrEiG5BI72OpjC
         T6db6Tr4RaoHw9ycFpFvvi+hLFCYvD9wT7rs2dKOUugOhEOrXqwS53sOEiHun8b7jwtd
         cL1AQor6v0ew9nf7WbemzOU/4ORlFIYfSKCgMWzrsGBGSBP2+ybGdDoNEH5I6ClMiIB6
         /5zwG8jfmnU1nDB4EILk/jOMqV4Iu6U9zc25/ANXciJJNxepnR0Rp/NnGesS16OtP21d
         GAXbdSY2LIl3ZmY+dd0GeT+Jz9rUjpdu/BiojiUZ6yfJxJ/rRnT/MPzrIDcltAsJ6i5o
         pdpQ==
X-Gm-Message-State: AOAM531XKqi+UR677Y9dEHS2QRTt224HDUHlz8sG9OvNr3c7v1CUjLgg
        4GUaph7eErvUMq4lp9L9cD0=
X-Google-Smtp-Source: ABdhPJwXy6TRdwJjRxVXoqn1xOpWvZYKuFRBJ4c3rG85mqVm8BuhiXE863afkfeQpj2DM6qjJ58gWA==
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr2479410ejc.168.1649945370519;
        Thu, 14 Apr 2022 07:09:30 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id cy5-20020a0564021c8500b0041fec3310desm1082701edb.68.2022.04.14.07.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:09:30 -0700 (PDT)
Date:   Thu, 14 Apr 2022 17:09:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 4/4] drivers: net: dsa: qca8k: drop
 dsa_switch_ops from qca8k_priv
Message-ID: <20220414140928.dcpsxfa6shjzslrq@skbuf>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
 <20220412173019.4189-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412173019.4189-5-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 07:30:19PM +0200, Ansuel Smith wrote:
> Now that dsa_switch_ops is not switch specific anymore, we can drop it
> from qca8k_priv and use the static ops directly for the dsa_switch
> pointer.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

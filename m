Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ADA6BA2C0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 23:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCNWy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 18:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbjCNWyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 18:54:53 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA1D3D93F;
        Tue, 14 Mar 2023 15:54:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r11so16823362edd.5;
        Tue, 14 Mar 2023 15:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678834479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=maSYtAupB9pGA9BbMf1FFCoQ9AwFyYvIGdi4zGVyIRQ=;
        b=GS8uou+NN5ZDw4pSmDPuGE1rXQDIHcVPU2GXePNUVnMkvBkTl2c0cfJmhPjUYHrEC6
         09KZP+C7/icM2we1BzKTz3AHjP8ZxoflNlRwwf46zHj1dNsDIUfn9x6ZDkQpQaAOZwSM
         Td/q5BkCQ+B7WRPk5+lHYLJwdHWz2Sqa6kRs1wwkBnDa4IwCM74NdO/JXKX6LKrVXZoa
         RON19SsRgIrM213iTpadrCbq4ZPKSTBy0UA3fYqXUtnbvJimINzdyV+cZNXV9qQEfeIU
         hRvZ7I778pMSDBGBggWXDErnlzfuNq6zkv098rdOyiekkUMNEzPHYQAIS/jka/61FrsJ
         GgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678834479;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=maSYtAupB9pGA9BbMf1FFCoQ9AwFyYvIGdi4zGVyIRQ=;
        b=XrKRhTe4ceZSLTYi1Cw/XM7JA7i2XoaUJ3V/TNWUiFu/FcOEOElw4rry8eyXCqFSWB
         ksA2k+/dIgsVVi1Hk6bfgUQFa8utImtCtk9Fre1J82JVkLy73OA6AdaBNvcMDf816zDE
         6AVoS6G/gt4RgQB6z6whPq6UKlHYAaIviCXJSAe5FELF7QSWPOU8ZHLMdRJ/g9YQdmQq
         ioZ8UC0BXZtT0ZndV6PUC2Pd+BQBx73DjNHguttksPUBJf7lP9d15ZMtX79e0nJqJ8OG
         5Wia6x2aDMK8MEQ9N7i5RdEUstgtiJ7LxG/73m3HBJfqCoIgu/V99KzDvk8UNl+J8gv0
         m+Xg==
X-Gm-Message-State: AO0yUKWL+SgpAXumysIQMBCjU2RABSNqf4NgcNV7IQ00a8CLKK0C/JrQ
        qySDsniVM4gSbGbITD8PiCY=
X-Google-Smtp-Source: AK7set/AyE9xRmthWf3MIL9RRlbaRG7FfValX8Oi9E+/ktaTfqrYZBl7Ut/CsSn/i0wcA07N++CNkA==
X-Received: by 2002:a05:6402:53:b0:4fa:4b1c:6979 with SMTP id f19-20020a056402005300b004fa4b1c6979mr625043edu.28.1678834478987;
        Tue, 14 Mar 2023 15:54:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id co2-20020a0564020c0200b004fce9ff4830sm1594082edb.88.2023.03.14.15.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 15:54:38 -0700 (PDT)
Date:   Wed, 15 Mar 2023 00:54:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND net-next v4 1/3] net: dsa: rzn1-a5psw: use
 a5psw_reg_rmw() to modify flooding resolution
Message-ID: <20230314225436.rrynwmdkbwsrqp3y@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-2-clement.leger@bootlin.com>
 <20230314163651.242259-2-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230314163651.242259-2-clement.leger@bootlin.com>
 <20230314163651.242259-2-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:36:49PM +0100, Clément Léger wrote:
> .port_bridge_flags will be added and allows to modify the flood mask
> independently for each port. Keeping the existing bridged_ports write
> in a5psw_flooding_set_resolution() would potentially messed up this.
> Use a read-modify-write to set that value and move bridged_ports
> handling in bridge_port_join/leave.
> 
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

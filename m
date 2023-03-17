Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51C46BED03
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjCQPc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbjCQPc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:32:58 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FC0C562B;
        Fri, 17 Mar 2023 08:32:31 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id h8so21902903ede.8;
        Fri, 17 Mar 2023 08:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679067148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fz3g4Aod9bmJ3HBMSgvke0u9GgoHtGnV6HoFm2p4NIY=;
        b=UBK5ZGnhUTVySAlSeWWRvtUmebOBDMPaB/T5WzK1rtNTiFechhVgn+HY9rXq6OBi+S
         7aU3xrZ/MsPhtWgoEM/BHrZ6dsSUpHycNoTc6hNtiEhAWEIrchneqHkJUnniooOnF1IP
         ncMuLb91bvEnhsnzfyNzVCyEbSLxa30b+CZk0kJw2g0sRERQ7UmRj9lIUypa0hjqoXV5
         e8b1QcoLf1uLf2A008WJl2IJlznGxfGbLvZW1JmQPo8xr6e8iYwSPy+JkixQRbDab3ra
         umvmnx3Tl3WdCMHIqedop5l6MCRpJB6Ub5Hq1svk7bD+ibv9QaBEQc65N9AlmBk0HcAy
         7TUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz3g4Aod9bmJ3HBMSgvke0u9GgoHtGnV6HoFm2p4NIY=;
        b=bC3DKCevV4/h3wuUrs1Mgbp03uzIbWfo2w5ZKY5EgayTlokpkXkfEVFDfeQesKiZmG
         jOK0lqpPkX/vZAF/zJhRdKdwOUfDoqI3dEyjj1FOEFobGDTcCGlO+ayvsJgdFQYLA70v
         OLAnQ4p+zsnvhGBYWMeJBoz3CVDvtUwmT22nrhGP3GniqW+mV7bDQVsnFcBTbOByvV7f
         Tlp5bek9QCP1lxLLkJeoYH0u+QRTnvpfDU9Wk4FCpZl8n/aiLljhKaox9FxhHsc8a9Dy
         xEagI64hJoHLpAO886K6JmFhu629sK+tCnkDLiJv4FEcUY6KBm3RvM7Qq1AiOsOCu7bQ
         wF2w==
X-Gm-Message-State: AO0yUKWy2FOnFKZPG2lsVuLwoNV8cQOkyn3dibzGMzMRNcMGsa83Uv7j
        YT3DjkBZbw5CjL1cr/EIzEi29PZOpslCeQ==
X-Google-Smtp-Source: AK7set9ntTu11gFjQOMeWlfRdjAwHCnqr1H3eXRD/Zs79L1cpbpLI7TgQtxDGXJtIkYHNx3NdNwzSA==
X-Received: by 2002:a17:906:e24c:b0:930:af80:5b9b with SMTP id gq12-20020a170906e24c00b00930af805b9bmr6401960ejb.1.1679067148408;
        Fri, 17 Mar 2023 08:32:28 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id 23-20020a508757000000b004af71e8cc3dsm1206797edv.60.2023.03.17.08.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 08:32:28 -0700 (PDT)
Date:   Fri, 17 Mar 2023 17:32:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/4] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <20230317153226.k6cq4lqwnxpzt3gq@skbuf>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
 <20230315163846.3114-4-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315163846.3114-4-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 05:38:45PM +0100, Klaus Kudielka wrote:
> Call the rather expensive mv88e6xxx_mdios_register() at the beginning of
> mv88e6xxx_setup(). This avoids the double call via mv88e6xxx_probe()
> during boot.
> 
> For symmetry, call mv88e6xxx_mdios_unregister() at the end of
> mv88e6xxx_teardown().
> 
> Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>

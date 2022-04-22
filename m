Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171B050BFB8
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiDVSXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiDVSXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:23:33 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989281102A0
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:20:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h5so7961733pgc.7
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AcwyL+VzOQ65vJV+fsz8Rk3YFL7NLc4igMwKsxYEcXo=;
        b=f5Xg1N4G2k/OC883Em8K1hnxg++yPa1xZ66t6YM3tugTPRxEoSd6Xg5tUe1dmtUPfK
         pvrtx5Ipxdzq3hX8DgAZoHmkvnZIFWE7W3G/lIq/B6N6qnxe4Td4M5AhopjVfxPNjZWS
         kWYlBx1upQjfRCccCF1mvBWDOpLnPNTgxiR8AGUMdWmI9APU93X4J3nez4k2N+VCzKNe
         0V9t/lOPoP92vqyO1PWQwd73HoRTkOVNAg3Uele7L6tscpMCnrBGwizonLppXYC9ABj5
         IlrZms9ba0N+X83y5zqGCWQfwoMdkNmyq/pB7187sQEVpwUJacBVTNeX3sLImNiAgfkP
         pRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AcwyL+VzOQ65vJV+fsz8Rk3YFL7NLc4igMwKsxYEcXo=;
        b=aAM5FX+I5uuPCWWINkuxwOAuzFRNoAtRWHAnaUevi0fKtEnKERY95XtnhGThTBr8KS
         5Sk2SYDqyImXLMFAcE7s8amt3aj6DLLIzXwsFhQaGlHR0yqIpS64w/35XBro1yO7B6a+
         eVqFe2YR/Q7E8GNN4/h2YdZlYMomlwsqwYdHCU7ORTw0qGX0YlZ/buwXz/lsBHChEHHY
         YdUgb75ZoUXR+xCZF+5YCMjx2vYtuov6zGsPHjsj91VGXFYh8X3xasc4NNS2qqli/3EF
         pZR4PEGrTWm6817cD+6KfaJUOI44Bh/bFrv7otBbYIjNXnxdngyuYRf0V7MQcdSMXg3m
         1eBA==
X-Gm-Message-State: AOAM532U/s7+s42uKpRkXUNfjfwWHDHosmR51DAiqmI9eBfXEH1X9J4K
        PaAih7dqOLedea68kix0dNI=
X-Google-Smtp-Source: ABdhPJwNgzZ3se1oDqWaUa1fz3WwHqk9RsPU54+uDg+4CWrYyDvRqIA3rprQE/V8v77Q9QNcNtaEnQ==
X-Received: by 2002:a05:6a00:a8b:b0:4cd:6030:4df3 with SMTP id b11-20020a056a000a8b00b004cd60304df3mr6292864pfl.40.1650651611521;
        Fri, 22 Apr 2022 11:20:11 -0700 (PDT)
Received: from [100.127.84.93] ([2620:10d:c090:400::5:f83e])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a00198800b004fab740dbe6sm3435619pfl.15.2022.04.22.11.20.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 11:20:10 -0700 (PDT)
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Lasse Johnsen <lasse@timebeat.app>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2] net: phy: broadcom: 1588 support on bcm54210pe
Date:   Fri, 22 Apr 2022 11:20:07 -0700
X-Mailer: MailMate (1.14r5852)
Message-ID: <FCDBE44F-57EB-420E-844B-29BBB37EA2C6@gmail.com>
In-Reply-To: <567C8D9F-BF2B-4DE6-8991-DB86A845C49C@timebeat.app>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <20220421144825.GA11810@hoboy.vegasvil.org>
 <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
 <20220422152209.cwofghzr2wyxopek@bsd-mbp.local>
 <567C8D9F-BF2B-4DE6-8991-DB86A845C49C@timebeat.app>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22 Apr 2022, at 11:11, Lasse Johnsen wrote:

> Hi Jonathan,
>
> I suspect you make the conflation I also made when I started working on=
 this PHY driver. Broadcom has a number of different, nearly identical ch=
ips. The BCM54210, the BCM54210E, the BCM54210PE, the BCM54210S and the B=
CM54210SE.
>
> It=E2=80=99s hard to imagine, but only the BCM54210PE is a first genera=
tion PHY and the BCM54210 (and others) are second generation. I have to b=
e mighty careful not to breach my NDA, but I can furnish you with these q=
uotes directly from the Broadcom engineers I worked with during the devel=
opment:
>
> 24 March:
>
> "The BCM54210PE is the first-gen 40-nm GPHY, but the BCM54210 is the se=
cond-gen 40-nm GPHY.=E2=80=9D
>
> "The 1588 Inband function only applied to BCM54210 or later PHYs. It do=
esn't be supported in the BCM54210PE=E2=80=9D
>
> So, I quite agree with you that in-band would be preferable (subject to=
 the issue with hawking the reserved field used in 1588-2019 I described =
in my note to Richard), but I am convinced that it is not supported in th=
e BCM54210PE. Indeed if you are looking at a document describing features=
 based on the RDB register access method it is not supported by the BCM54=
210PE.

Uhm, I have inbound timestamps working for RX on an RPI CM4.
=E2=80=94
Jonathan

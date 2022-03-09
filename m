Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE584D3AA5
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiCITx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiCITxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:53:55 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687CE2DA9C;
        Wed,  9 Mar 2022 11:52:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 27so2837702pgk.10;
        Wed, 09 Mar 2022 11:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4kzbkgNqNKwxaQ1m2ZzrSKiAe8W8mjE96YFj6SfEfFk=;
        b=ihcMSR9gCKhJ2z9rtKUM8BRPM2EFdtUhUzaFWRP8xZyf++yKYw/ycnjqBtIiE93WOV
         qGqwBKEFZsETV8+lsNBNd8IySWpnqsMlKu/CsdjcfQHF98HFbFj/mzCu5Ak76uvqD7ad
         GK6gciq5jTGlhg5v3D60M4Wg9GfgR17c4zFJ26TMsJkjhn7gGyylMYo5hPKCvsCGwqoq
         AmpeyagDUFYoKR31OjwyZx2eAkyVg5doUF8eL8B6x0XKT2CGlwFmiX4eyOBlDoxA33w6
         J9XgRCOsxhh+e5KRHu2VVSHC7p+0zU6QYiwcGEw4oWMZ/Fdtwp37gSzCt8R8YzhC8raE
         jQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4kzbkgNqNKwxaQ1m2ZzrSKiAe8W8mjE96YFj6SfEfFk=;
        b=A/Wh+RILJuPSGBMYi6ONpFkQK64Kv5MtnS6w/6UYTraKq/qCo9vK8RXJbbxMLOP2B5
         xiQUA4e1CA6tOSP6Nw2f4f7oXn5Xniuwvp8EQUF9xFuIg1xKwEuOUbBsmIyroutpzCBN
         4xDKn5FlCBweeRm14W97HJzUTpSjDCqvyx7lsttpl6n6iKK40zvDuCol5VtQWYOzBLUX
         CgkNm0FxaqmuErsRqSAuWkLqg7F8joDc0Goyydr+GQh8aFYWhE+d1Kt7V7IK5ZCtt3pH
         zj3tsX7+brSizdOh9XIcxHynewKZKalkOUUjYb/KCUCvDcdTdJgQTUOsmYKFO0CbTdM8
         qXsw==
X-Gm-Message-State: AOAM533MzSTCqZd4UOSxtJQNT7kN20KxnFbQJ6R6U4M8WblTosbBW2Jw
        HNc5FR+fvCgdxBo5Kjww3w0=
X-Google-Smtp-Source: ABdhPJycavjqvk7iSGIpqlLCFGwromFF7uFbGc4aCe0AX7vBzyo88P9e9iX0IgsfjSigm+SyXlb7nA==
X-Received: by 2002:a05:6a00:a92:b0:4e0:57a7:2d5d with SMTP id b18-20020a056a000a9200b004e057a72d5dmr1323197pfl.81.1646855575930;
        Wed, 09 Mar 2022 11:52:55 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h5-20020a056a001a4500b004f731e23491sm4280510pfv.7.2022.03.09.11.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:52:55 -0800 (PST)
Date:   Wed, 9 Mar 2022 11:52:52 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220309195252.GB9663@hoboy.vegasvil.org>
References: <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YiYD2kAFq5EZhU+q@lunn.ch>
 <CO1PR11MB4771F7C1819E033EC613E262E2099@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 02:55:49PM +0000, Russell King (Oracle) wrote:

> I think we understand this, and compensating for the delay in the PHY
> is quite reasonable, which surely will be a fixed amount irrespective
> of the board.

The PHY delays are not fixed.  They can be variable, even packet to packet.

https://www.researchgate.net/publication/260434179_Measurement_of_egress_and_ingress_delays_of_PTP_clocks

https://www.researchgate.net/publication/265731050_Experimental_verification_of_the_egress_and_ingress_latency_correction_in_PTP_clocks

Some PHYs are well behaved.  Some are not.

In any case, the linuxptp user space stack supports the standardized
method of correcting a system's delay asymmetry.  IMO it makes no
sense to even try to let kernel device drivers correct these delays.
Driver authors will get it wrong, and indeed they have already tried
and failed.  And when the magic numbers change from one kernel release
to another, it only makes the end user's job harder, because they will
have to update their scripts to correct the bogus numbers.

Thanks,
Richard


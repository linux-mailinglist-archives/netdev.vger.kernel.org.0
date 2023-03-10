Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A67A6B4B4B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjCJPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjCJPic (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:38:32 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17904135950;
        Fri, 10 Mar 2023 07:26:02 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id bw19so5368093wrb.13;
        Fri, 10 Mar 2023 07:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678461960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6GV/gylHYVI13fJkyc5BAOc8p+h0IBmqpHIDca4Ez7c=;
        b=ArJ6uyvTkgVs/7TAji2awY6O+AzXTsdWPCpoy1Qlh9zgyPpET9MYbb7a1cn9O+IX/v
         S3Myh+/Cr+rBnvcegAu/Bee/ArW4Y3A/py3ZW1p8lJ5NmgwHvTN8j0HqmCwVlkq6xnpZ
         DB/v0gAn1s3ya4XVVDzqmiVNYmloLIs2FAeXUdwsuGVc32w/NglvDCuj5BYEoxpapha5
         7Vs0yBtkZU/E6azYPB81/EVRp614dFk5uou0q9SdS1OKwStEAgK0mCsNoAVmewBuAtby
         izyae+YxnCOQFIDtXPHtAO4ULW36sNBpaFjXaWGcR0xHzqJwowLdbbwSB9Byo7t6Mcpo
         Dq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678461960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GV/gylHYVI13fJkyc5BAOc8p+h0IBmqpHIDca4Ez7c=;
        b=EDuZS0+oSqe2EmbhQfqkEJDYNFYF3P8YvFfcQtl4LRdBKP1zSKbWQ19K+ynZTDOIHz
         rnLA6D9/7Yui433uLkP+BAENkq0p7+u2JBcBoJghb90AMnvtzwB0R8WhFufHTAGmi0iz
         3VUB+nZDcg+ZF4Gym6GPdCdbe2ezEvU9thcuJ7ZVtLxq8sGstyx7ecg/YhDomby3Phht
         qStXT2awjGcJkgD70xDzhe6BRLoKRvjDXHsVIbdZAtcjIvCRXJ674TIQ5sO9Xj2be7nj
         uqmrCcxbCMVtvMtO36G9dMGJMK7V+3T+bnAb7FjGfwXogjDLNxVX+Y2nlc/aS0BgbXTn
         3fEQ==
X-Gm-Message-State: AO0yUKWL28W5BJbap3Tu3ctiInWUkgqvsYreFyufzAb/nR2z0sZGlxOC
        BFprEY0NELFwiYAbEZFDjhI=
X-Google-Smtp-Source: AK7set+uqpvQldBIfsszCgo1G8PEymwpyEh6TgffWX1n06qcSb8B19GzouOB+SomwvN1vD5fjk1Kpw==
X-Received: by 2002:a5d:5490:0:b0:2ca:57c1:9abd with SMTP id h16-20020a5d5490000000b002ca57c19abdmr14362117wrv.36.1678461960448;
        Fri, 10 Mar 2023 07:26:00 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id r10-20020adfce8a000000b002c53f6c7599sm86907wrn.29.2023.03.10.07.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:26:00 -0800 (PST)
Date:   Fri, 10 Mar 2023 17:25:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Lukasz Majewski <lukma@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <20230310152558.3ko7ufns4jexdkx7@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-7-lukma@denx.de>
 <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
 <20230309154350.0bdc54c8@wsk>
 <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
 <20230310125346.13f93f78@wsk>
 <ZAsdN3j8IrL0Pn0J@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAsdN3j8IrL0Pn0J@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 12:06:15PM +0000, Russell King (Oracle) wrote:
> It may be worth doing:
> 
> static int mv88e6xxx_g1_modify(struct mv88e6xxx_chip *chip, int reg,
> 			       u16 mask, u16 val)
> {
> 	int addr = chip->info->global1_addr;
> 	int err;
> 	u16 v;
> 
> 	err = mv88e6xxx_read(chip, addr, reg, &v);
> 	if (err < 0)
> 		return err;
> 
> 	v = (v & ~mask) | val;
> 
> 	return mv88e6xxx_write(chip, addr, reg, v);
> }
> 
> Then, mv88e6185_g1_set_max_frame_size() becomes:
> 
> int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int mtu)
> {
> 	u16 val = 0;
> 
> 	if (mtu + ETH_HLEN + ETH_FCS_LEN > 1518)
> 		val = MV88E6185_G1_CTL1_MAX_FRAME_1632;
> 
> 	return mv88e6xxx_g1_modify(chip, MV88E6XXX_G1_CTL1,
> 				   MV88E6185_G1_CTL1_MAX_FRAME_1632, val);
> }
> 
> The 6250 variant becomes similar.

+1, sounds good to have separate mv88e6185_g1_set_max_frame_size() and
mv88e6250_g1_set_max_frame_size() with a common implementation. It is a
lot less confusing than the two driving a bit named in the same way but
meaning different things.

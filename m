Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7550C6EE3A4
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 16:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjDYOJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 10:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDYOJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 10:09:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79F94;
        Tue, 25 Apr 2023 07:09:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5862B62C5F;
        Tue, 25 Apr 2023 14:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBAC433D2;
        Tue, 25 Apr 2023 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682431742;
        bh=fvvrNTvmLPE4kfM8oogNXYPkYCfJHOTIjTjRRZsi/2Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QspwbRS4E1kN31lCQcrUzbEOfU92qSlkdHsxoqm0jNM3X2vZWMBV2RicQI73WespG
         IbFvzP7EDNZ/wVLUtcAdUYCxRJLFn68Si1JZ8AcuA7xHNH3pIFq9sCa93TQNOhl27O
         ak0labPCIOnJgX4I14hRrAyy8cy3DwLnp4FMaHy9r1tuec5ZleVJSC9GQj6ln1pKMi
         JwKyk2QItCN7cOCR50NhI/H2CMqNNzXFvq4X4WiaqFdep/zWz8FjVMfkq8r/+w0U5w
         ybqS50sr7GUNQ+BeU9NQnxbtBbjIeFjWzwrf7/GhAreulOEG5ZEXNOfwS3rUxNEAvp
         WBiWNehdYuJbg==
Date:   Tue, 25 Apr 2023 16:08:59 +0200
From:   Andi Shyti <andi.shyti@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        hkallweit1@gmail.com, linux-i2c@vger.kernel.org,
        linux-gpio@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v4 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <20230425140859.q23mhtsk5zoc2t3d@intel.intel>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
 <20230422045621.360918-3-jiawenwu@trustnetic.com>
 <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEQKlSIIZi9941Bh@smile.fi.intel.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

[...]

> >  #define MODEL_MSCC_OCELOT			BIT(8)
> >  #define MODEL_BAIKAL_BT1			BIT(9)
> >  #define MODEL_AMD_NAVI_GPU			BIT(10)
> > +#define MODEL_WANGXUN_SP			BIT(11)
> >  #define MODEL_MASK				GENMASK(11, 8)
> 
> Yeah, maybe next one will need to transform this from bitfield to plain number.

You mean this?

-#define ACCESS_INTR_MASK                       BIT(0)
-#define ACCESS_NO_IRQ_SUSPEND                  BIT(1)
-#define ARBITRATION_SEMAPHORE                  BIT(2)
-
-#define MODEL_MSCC_OCELOT                      BIT(8)
-#define MODEL_BAIKAL_BT1                       BIT(9)
-#define MODEL_AMD_NAVI_GPU                     BIT(10)
-#define MODEL_MASK                             GENMASK(11, 8)
+#define ACCESS_INTR_MASK                       0x00
+#define ACCESS_NO_IRQ_SUSPEND                  0x01
+#define ARBITRATION_SEMAPHORE                  0x02
+
+#define MODEL_MSCC_OCELOT                      0x08
+#define MODEL_BAIKAL_BT1                       0x09
+#define MODEL_AMD_NAVI_GPU                     0x0a
+#define MODEL_MASK                             0x78

I actually like more bitfield to plain numbers.

Andi

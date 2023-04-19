Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C1F6E82EB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 22:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjDSU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 16:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjDSU6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 16:58:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80764C19;
        Wed, 19 Apr 2023 13:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A7yujFR+jknPp2NmD7+Ix77oCWwZ6CSPDZxyWX4VKbE=; b=YJgBdA0Fcl4DWowVaPEQFjfp3D
        lCGlvW7wq3Y2/8ERRJzLWiX4BHhMEi+hSDEdgb5fZ8+YVVK336r1nGtWbObgR+P66mISkX1DrAjak
        SonIM9PKyPc/5mvyrS3cgGs5vA5YihrJz0hZKoMx43o6MR//0gboZ1DFXzl54gceXV1g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ppEsN-00AjAa-Eo; Wed, 19 Apr 2023 22:58:03 +0200
Date:   Wed, 19 Apr 2023 22:58:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
Message-ID: <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419082739.295180-3-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:27:33PM +0800, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Add platform data to pass IOMEM base address, board flag and other
> parameters, since resource address was mapped on ethernet driver.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - I2C cannot read continuously, only one byte can at a time.

Are you really sure about that?

It is a major limitation for SFP devices. It means you cannot access
the diagnostics, since you need to perform an atomic 2 byte read.

Or maybe i'm understanding you wrong.

   Andrew

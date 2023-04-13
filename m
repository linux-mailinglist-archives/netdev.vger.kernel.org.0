Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8EE6E1243
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjDMQ20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDMQ2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:28:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C004200;
        Thu, 13 Apr 2023 09:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mQvf+gRN7NYGHjf5csoi4SeW125LupLTIXxqIoYrrgs=; b=zwe2YuJgrTHFZEI4liZQtIK7xT
        4mTne0+SJQi1/5OIRNgMEx5flvZQ+nKgKy8KH9osXXCL1MQGo2u1ycpws0FX8NIbCsdQ29R26mchN
        yATjVScszopc0hAG8LiKTlnDzjBm1s4zgxXR9wRBbejZqKZWhxaUndUk4DlJ4Jz5NlUc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmzo3-00ACuj-4M; Thu, 13 Apr 2023 18:28:19 +0200
Date:   Thu, 13 Apr 2023 18:28:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 1/3] staging: octeon: don't panic
Message-ID: <fdbe6034-0c03-40ff-a0dc-e36a3b44d00b@lunn.ch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgN8/IcFc3ZXkeC@lenoch>
 <c69572ba-5ecf-477e-9dbe-8b6bd5dd98e8@lunn.ch>
 <ZDgqUP0yWYHE7McL@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgqUP0yWYHE7McL@lenoch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Problem with this code is that it registers netdevices in for loop,
> so the only device available here is parent device to all that
> netdevices (which weren't registered).

You always have pdev->dev, which you can use until you have a
registered netdev. That is a common pattern.

	   Andrew

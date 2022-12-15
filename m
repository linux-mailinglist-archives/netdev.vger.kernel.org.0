Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E84564E19C
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiLOTOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOTON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:14:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339932C65F
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C46C861E5D
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 19:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D76C433D2;
        Thu, 15 Dec 2022 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671131652;
        bh=nLkozOCY7uHDNlEiOSkjXvED+JCfHNBECthJh51gKys=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jc8kb6iSCcz1BUHlx+YtpLHlvn7On4splRGjPFgnjpsIjnInfJa1wyL/xzQx87pf0
         e5S0boPOjNQIPsX2QnYO7SrVAs8xI8ecTfiojCCGqoqm39yp5MC+bzGh2SI64yXg3Q
         TV5U/niNmU21BxwhF155bESML+4k56pab0m4wHAH2Ismc5YKAdsnuWE7ctCc4f4iy8
         rKsBpU794ghIV8/uVVkzomTVCSuHZxKCt90as7ttHwALyth41zMkFa9BV94kUnWik0
         ZNIo5yZe8zcAAtGeal+4IhIIaDTGF7g4oqWdgU5srAfq2g3dHimWHQju1Ivld1shrK
         aWJ5IMUGSHSfQ==
Date:   Thu, 15 Dec 2022 11:14:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <leon@kernel.org>
Subject: Re: [RFC net-next 03/15] devlink: split out netlink code
Message-ID: <20221215111411.5b6d3f5e@kernel.org>
In-Reply-To: <e350733f-d732-4ba6-a744-d77a37a237eb@intel.com>
References: <20221215020155.1619839-1-kuba@kernel.org>
        <20221215020155.1619839-4-kuba@kernel.org>
        <e350733f-d732-4ba6-a744-d77a37a237eb@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Dec 2022 10:45:48 -0800 Jacob Keller wrote:
> On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> > Move out the netlink glue into a separate file.
> > Leave the ops in the old file because we'd have to export a ton
> > of functions. Going forward we should switch to split ops which
> > will let us to put the new ops in the netlink.c file.
> >   
> Moving to split ops will also be a requirement for per-op policy right?

We can mix within one family, tho, IIRC.
So new ops can have their own families and the old ones can stick to
the family policy (unless someone takes the risk of converting them).

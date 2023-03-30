Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCDF6CFC23
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjC3HCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjC3HCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:02:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6A42D4F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 00:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A067BB8261C
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 07:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC805C433D2;
        Thu, 30 Mar 2023 07:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680159761;
        bh=zMK15lJwrXTnwcOFWILjYmTp8o2yADbTpgB032nljJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NcMNPpl3Xky0x7fJ62T7QaiwNg/YM+gI/gxt2fsFf4QnadlM6LU4mDxdKOtSNXOKo
         IkXI25wESkVxzRrIYoC9gPD0qn9kg0bjMAcdEmCc6uKpTwOBEM1WzQirgqDlzR2oH/
         qf3obJnG3vFGdTCm5a4YYWkYClt6+r239hJFSaVurvh4CjxsVjo7EysFUtQmdf2DoV
         0BS9l/AD1Jkupk58kOwwwSWQ2c0U8v2DhamwEr4rPxn1eGyzlcg2X3DxfRCVfpFtDL
         25aQv3gr5NCM1GakyThLibBtElYWqogFYg2/Nirt2JJDr8i0jxrYjrStwMlTRvxcdv
         WU4h+Urfw9hRg==
Date:   Thu, 30 Mar 2023 10:02:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v6 net-next 01/14] pds_core: initial framework for
 pds_core PF driver
Message-ID: <20230330070237.GQ831478@unreal>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
 <20230324190243.27722-2-shannon.nelson@amd.com>
 <20230325163952.0eb18d3b@kernel.org>
 <0e4411a3-a25c-4369-3528-5757b42108e1@amd.com>
 <20230327174347.0246ff3d@kernel.org>
 <822ec781-ce1e-35ef-d448-a3078f68c04f@amd.com>
 <20230328151700.526ea042@kernel.org>
 <45c28c76-688c-5f49-4a30-f6cb6eab0dce@amd.com>
 <20230329192733.7473953c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230329192733.7473953c@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 07:27:33PM -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 13:53:23 -0700 Shannon Nelson wrote:
> > The devlink alloc and registration are obviously a part of the probe and 
> > thus device control setup, so I’m not sure why this is an issue.
> > 
> > As is suggested in coding style, the smaller functions make for easier 
> > reading, and keeps the related locking in a nice little package.  Having 
> > the devlink registration code gathered in one place in the devlink.c 
> > file seems to follow most conventions, which then allows the helper 
> > functions to be static to that file.  This seems to be what about half 
> > the drivers that use devlink have chosen to do.
> 
> It is precisely the painful experience of dealing with those drivers
> when refactoring devlink code which makes me ask you to do it right.

It will be great if such pushback would be expressed for all types of obfuscations
and not devlink only.

Thanks

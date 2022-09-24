Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F03F5E86C1
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 02:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiIXAYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 20:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIXAYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 20:24:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C1DB9E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 17:24:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EB74B82085
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 00:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90396C433C1;
        Sat, 24 Sep 2022 00:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663979051;
        bh=lWB2qAwBPPJi245WvYbDqNlAB/x/DcQV4kpdTuI8zcU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tsr0EEh+St1Q47pL8KH5tzfvE5A7T2ioFR40NN89Nl8ufjalJxg6i5QCXSDkaYRBJ
         b7kk0iOY0QeV029b11ewpgKUXzFu27k+Ce3DxCeiKRmmU8NuCwJx/J+LGDIrlEVju1
         dXoXGZgCaQUx/YX9kmeuGQRkNZq1sAqOYGWW6HgvouHRu/AG7jnWzKf6mb3vhEOnIo
         0oKQ8O2085KnqFz0CjtJDAd0mQWX2LTqiSx97Wuhxe1Wh6sWJgWImVbn6vLCpjWiwt
         v0YSo/YQXb0ZuPwOsn9im131OWBNJBbBN8R3o1jCA/Cp2H2+hJQuutbo9LosUdekiV
         CsrPqHnvbLk+g==
Date:   Fri, 23 Sep 2022 17:24:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220923172410.5af0cc9f@kernel.org>
In-Reply-To: <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
        <20220922180040.50dd1af0@kernel.org>
        <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20220923062114.7db02bce@kernel.org>
        <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
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

On Fri, 23 Sep 2022 23:41:57 +0800 Yinjun Zhang wrote:
> > Why is the sp_indif thing configured at the nfp_main layer, before 
> > the eth table is read? Doing this inside nfp_net_main seems like 
> > the wrong layering to me.  
> 
> Because the value of sp_indiff depends on the loaded application
> firmware, please ref to previous commit:
> 2b88354d37ca ("nfp: check if application firmware is indifferent to port speed")

AFAICT you check if it's flower, you can check that in the main code,
the app id is just a symbol, right?

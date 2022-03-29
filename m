Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E404EB2FE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240382AbiC2R6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiC2R6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:58:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E588996B6;
        Tue, 29 Mar 2022 10:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2B0C61557;
        Tue, 29 Mar 2022 17:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C2FC2BBE4;
        Tue, 29 Mar 2022 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648576591;
        bh=H0LwGNjF+fncMC3pMuHEzhVFrySyJ4TPUs9JrCr50lc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FopnajjWpx3ug+GN57LzyvD25iA7dlOt+0wwhhiYV1SIif8IUEJ5Fb07KkGojnqmI
         RzHK+9JUtJaqwNPSY3cpfsYn4X2ebC3xKF07IcgSnLrI14ZP8VlOcazakjUHGMneS9
         gt2UwXgKkC2flN7ms0wlCjTkyra/yj5uVTpXUKFKH//WxeuxSATZWezf7qNRtdLS8E
         felXowUEQVfWn4cheuHc+XgdHYyP+S4bWgd2UpVlFNqvk26gFNVV9NO9I8dcPcExc/
         6PS524l4YW6zxu+tPxM70W6qoezYuz+NhWJ54ntMsLg7KAmNHrIF6dHgyoSqBTkld0
         AYoGCirwBl8EA==
Date:   Tue, 29 Mar 2022 10:56:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK <linux-kselftest@vger.kernel.org>, 
        open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
        Netdev" <netdev@vger.kernel.org>
Subject: Re: kselftest: net: tls: hangs
Message-ID: <20220329105629.731ef7d6@kernel.org>
In-Reply-To: <CA+G9fYvC3b9YwXjeAUBKbgWCgip7KioBRxH=GGNPSpyPqDy2dQ@mail.gmail.com>
References: <CA+G9fYsntwPrwk39VfsAjRwoSNnb3nX8kCEUa=Gxit7_pfD6bg@mail.gmail.com>
        <8c81e8ad-6741-b5ed-cf0a-5a302d51d40a@linuxfoundation.org>
        <20220325161203.7000698c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <08c5c6f3-e340-eaee-b725-9ec1a4988b84@linuxfoundation.org>
        <CA+G9fYsjP2+20YLbKTFU-4_v+VLq6MfaagjERL9PWETs+sX8Zg@mail.gmail.com>
        <20220329102649.507bbf2a@kernel.org>
        <CA+G9fYvC3b9YwXjeAUBKbgWCgip7KioBRxH=GGNPSpyPqDy2dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 23:16:25 +0530 Naresh Kamboju wrote:
> > I only see build logs here, are there logs for the run?  
> 
> Yes. Those are only build logs.
> The test log is here but not very useful.
>  https://lkft.validation.linaro.org/scheduler/job/4770773#L2700

Thanks, interesting. We have the timeout set to 30 sec so if there's no
progress for 30 sec the test should just fail. But the test setup says
no progress for 900 sec, so something must have gotten hard stuck :S

Looking forward to the update tomorrow, something to consider long term
for the test setup would be enabling CONFIG_*LOCKUP_DETECTOR and
CONFIG_DETECT_HUNG_TASK.

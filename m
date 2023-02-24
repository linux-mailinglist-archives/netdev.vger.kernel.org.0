Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3F66A204E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBXRLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXRLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:11:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFAA6A9D0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:10:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44866B81CA3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 17:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F82C433EF;
        Fri, 24 Feb 2023 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677258656;
        bh=RUkSOUeFLYvWSinCKbH2nFJXBUjWhrF0hh3OFm3D11A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NPLhEfySc2F+0o220S2AsOy24Zi9wmQkpU1VUDpgV6GsF1ZK/dNmX5oUMLaaPhhWi
         2lpID47dCBufkpRkWESrOsqJh9PW2pkDp5lhlZhPjsNc3bHGRRJzQJrdIcpAkEm/Cd
         nm6uwecEgOYJr31mMFYjoUPl9ddZwZqpp6mq3Bia10MhQMn+BuxraG10xZ6BMQbGV0
         Gm0a0QoRiF5khfz6WNPDZhhODUV2JYMnpSG65uwAv5thu3bhYUzLPi7l3BDQuewthI
         ln4cuqFGjnUwT+W41y7teyKDe2qIndoPIVaxGNV/11HsTFRsb1FI5m48f9hJteIYuB
         JPfEYpfoy7DfQ==
Date:   Fri, 24 Feb 2023 09:10:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224091055.1a63e08e@kernel.org>
In-Reply-To: <CAM0EoMm9NyE7nJZ4ktntNMUsCQkyEuVyR5f_E7TgiKNCo15a3A@mail.gmail.com>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223175708.51e593f0@kernel.org>
        <0ae995dd47329e1422cb0e99b7960615c58d37fe.camel@sipsolutions.net>
        <CAM0EoMnfDhAXsZKY7UqwCxgeXGH1Q-pQdqSycMHw+MSRZSABVA@mail.gmail.com>
        <CAM0EoMm9NyE7nJZ4ktntNMUsCQkyEuVyR5f_E7TgiKNCo15a3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 10:22:56 -0500 Jamal Hadi Salim wrote:
> After a couple of sips of some unknown drink: I think we can get rid
> of ctrl_v altogether as a param to the printers and we should be good
> (it would work for events as well).

Do you mean to always interpret the flags? FWIW I think that should 
be fine, old kernels just don't set those flags so I'm not sure why
we're gating interpreting them with the version.

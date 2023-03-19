Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAFE6BFEDF
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 02:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCSBoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 21:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCSBoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 21:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB90D1449A
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 18:44:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597AA60F01
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 01:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7819DC433D2;
        Sun, 19 Mar 2023 01:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679190261;
        bh=gliGSg81054e9zhz2Nrnk5IRFy6J6uaROxjA9vrFo9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sgjlsJroM4PjZJlOzDH9bYZPVaFqjJMEMxRQDmzP9np/0bb2DsupE9JRpurqWbFMK
         vHr6tv1iJVDZZ4d1p1Yn1Yye05WJoEqBgd5tStIGaAyETL4tV5Y8DFuQGr/L+RF/FA
         NBYnWZtmeR84tYXcGw2Tbea+3I2x31gc/URpHySBN0m5AIA+Ok+fwkQTyIhzHoLcJR
         6cepzo3OwCxL6p/6hLHwfru3l4fToVt/2CnhqNXqqM59/lmVR9WrJNwbeT8MMtjbPD
         M+ddiBRKfDaVir5mhti1+RoVMQ9gtQXET6wcWHeQQ5w0pfavIcSxGA9gZg2s30DamG
         fYaSMto+5ifcw==
Date:   Sat, 18 Mar 2023 18:44:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@redhat.com>
Cc:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 2/2] netlink: specs: add partial
 specification for openvswitch
Message-ID: <20230318184420.4046574c@kernel.org>
In-Reply-To: <CAAf2ycne3nQ4Y_-tNihgMMtmDiNtQ7o7bGMjojrEUBJR_JsHMA@mail.gmail.com>
References: <20230316120142.94268-1-donald.hunter@gmail.com>
        <20230316120142.94268-3-donald.hunter@gmail.com>
        <20230317215228.68ad300a@kernel.org>
        <CAAf2ycne3nQ4Y_-tNihgMMtmDiNtQ7o7bGMjojrEUBJR_JsHMA@mail.gmail.com>
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

On Sat, 18 Mar 2023 16:54:35 +0000 Donald Hunter wrote:
> > On Thu, 16 Mar 2023 12:01:42 +0000 Donald Hunter wrote:  
> > > +user-header: ovs_header  
> >
> > Let's place this attr inside 'operations'?  
> 
> Ah, good point - can it vary per operation and should it be a property
> of each command?

We should allow both. Have tools/net/ynl/lib/nlspec.py expose it as 
a property of an operation, but let the spec writers only specify 
it once if each command uses the same format.

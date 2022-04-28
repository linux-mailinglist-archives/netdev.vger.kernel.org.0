Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD72E513EAA
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 00:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353017AbiD1WuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 18:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242342AbiD1WuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 18:50:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3474368FAB
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 15:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 41521CE2F63
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 22:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2515BC385AD;
        Thu, 28 Apr 2022 22:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651186008;
        bh=0HFD3bTx66b1xGXZP2Fy5AArx/b0sHvp0f6LbX68ynM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Tesawlek0qgj57nI4zxOoljmXKzlIAyLD4IRdMZ8uT6d/UfsslzZAl7zEkQE1u3Xo
         Xf0jGFVSyniZvtaBU/BA+xC1tcNuDGl7IdQEuNY5got+aE6StZkVaX8L4mwHiWCpI3
         3q6jDXdB10kMT0d7bjwvZ9m8zr9fZPhDzVPXulWXoiFEqsVBt0z//ihI5nW/W4Y8py
         /xdQ7WTIjJOcQ/IDNj0gpVLCU1lLUd9DRCKmUv+O6gn4X2iNmapyD/uaTW8Lj0oQqg
         R0PfA20+IfQ0fq0jAEeynTx0BgZIER0zmF4Sps27qaq8B6KJ/4bwXY8xWTG9Rvf6Vt
         vlt8KvKdjZbJA==
Date:   Thu, 28 Apr 2022 15:46:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next] nfp: flower: utilize the tuple iifidx in
 offloading ct flows
Message-ID: <20220428154646.7b9d85cf@kernel.org>
In-Reply-To: <20220428105856.96944-1-simon.horman@corigine.com>
References: <20220428105856.96944-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 12:58:56 +0200 Simon Horman wrote:
> +static inline struct net_device *get_netdev_from_rule(struct flow_rule *rule)

No static inlines in C sources, please, there is only one caller 
so compiler will DDRT.

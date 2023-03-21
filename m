Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310F16C2914
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCUEUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCUEUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:20:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78E66E95;
        Mon, 20 Mar 2023 21:20:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E78E618D2;
        Tue, 21 Mar 2023 04:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF14C433D2;
        Tue, 21 Mar 2023 04:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679372402;
        bh=PT/CiT0BEhsjPkLcZdtBOfXFvi9IAgN+QsC5PQz8EQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jvXFofMQWAE5gTYRDV1rzQVYlRhmNw3SljGu6jzGVGKSbZrERJcoeA4t8LqDfUEFF
         umAjV32Ocokg5xJtP1BVoXTLAZFNvVB3prYNsI80iXxN99TLoxX2EsXJwfcPfabZ3v
         NsebbOyl+AQ3rihrggmYpvVQoQ80/aBgIX3P8hKL7Cf3AW7mPGHXd9wPB7G3H8wTxD
         +YGKX1vgyn7pgDGOKcGRuOqDhveEoeym16IoZqyONtTZTWymXkVhs3X8WLbbh1+vgm
         aSHAyPmytVk3xZcz3qy/e2k9n56DGVoUx5sBwG+4gWx0KcNpwqA4+NbREnhnqkOvyX
         6ZTATnKOMgNIA==
Date:   Mon, 20 Mar 2023 21:20:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 1/6] dpll: spec: Add Netlink spec in YAML
Message-ID: <20230320212001.46fd0200@kernel.org>
In-Reply-To: <20230320211354.4d0f8654@kernel.org>
References: <20230312022807.278528-1-vadfed@meta.com>
        <20230312022807.278528-2-vadfed@meta.com>
        <ZBCIPg1u8UFugEFj@nanopsycho>
        <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
        <20230320210549.081da89b@kernel.org>
        <20230320211354.4d0f8654@kernel.org>
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

On Mon, 20 Mar 2023 21:13:54 -0700 Jakub Kicinski wrote:
> If one has to carry a link to the other you should create a subset
> so there is no circular dependency. That's the only potentially tricky
> thing I can think of...

Another option is to take a page from ethtool's book and factor out
identifiers to a nested attr from the start.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A46C2902
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjCUEK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjCUEKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC71023DBE;
        Mon, 20 Mar 2023 21:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FBA96194E;
        Tue, 21 Mar 2023 04:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6966CC433EF;
        Tue, 21 Mar 2023 04:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679371550;
        bh=dkNXtuPKzvH8px3D6BZTKCZ/f6/0QU05iqQDcuooA8g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pzADmA5bysShRhtC8zU+1CY1moObQ/KOtgBsTkrjYieCcDGfLyEgUG/1v2S9ntb3a
         zgqgQzl5SDJS0Z/JBGwt+WHwnnj8Sa71i3YON3MD6IMcpd4T8CZeSM5NY3xLfS4HTX
         Ahq9CvkwOW19c7h+0DlTiM5XxR2NqauCICZs1aa6nJRqgwnsVKT5vCTP94xpwqqNJP
         gHk7vARzojEZN4ItrwppFssYWCkdCcpWRblOGtvvB3Bn9Os1B9zZqcfM7uvC69daRs
         sXqnnY2hwRgfvGuW22kY/U6I8+K6MdAh/Gm/pe7ZbC6e5+3OOtiqRMaQmGUE1geXMF
         in6r6hTOXHKZA==
Date:   Mon, 20 Mar 2023 21:05:49 -0700
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
Message-ID: <20230320210549.081da89b@kernel.org>
In-Reply-To: <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230312022807.278528-1-vadfed@meta.com>
        <20230312022807.278528-2-vadfed@meta.com>
        <ZBCIPg1u8UFugEFj@nanopsycho>
        <DM6PR11MB4657F423D2B3B4F0799B0F019BBC9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Mar 2023 13:15:59 +0000 Kubalewski, Arkadiusz wrote:
> >Value 23? What's this?
> >You have it specified for some attrs all over the place.
> >What is the reason for it?
> >  
> 
> Actually this particular one is not needed (also value: 12 on pin above),
> I will remove those.
> But the others you are refering to (the ones in nested attribute list),
> are required because of cli.py parser issue, maybe Kuba knows a better way to
> prevent the issue?
> Basically, without those values, cli.py brakes on parsing responses, after
> every "jump" to nested attribute list it is assigning first attribute there
> with value=0, thus there is a need to assign a proper value, same as it is on
> 'main' attribute list.

Are you saying the parser gets confused after returning from nested
parsing? Can you still repro this problem? I don't see any global
state in _decode()..

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B29C5441E9
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 05:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237604AbiFID3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 23:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236504AbiFID3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 23:29:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273AA1E226D;
        Wed,  8 Jun 2022 20:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F154AB82B94;
        Thu,  9 Jun 2022 03:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB32C34116;
        Thu,  9 Jun 2022 03:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654745376;
        bh=xoMdLg4homzX7FWVt3xib9e6tyLXTnBCuXHzsxIdiYU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SHTS45FZ1e4NdsSWYZaoPM01p8VvTFdnfmSUye57UgA/nGXzngjzNW5OJKi9+bzdM
         ZLMVnGAjbJ0MJovWKA6sdWs43dW9D3xJ1N7BKP+3KHhaDhGQsIHU/yEA/Ebw0HA6xH
         CjK+CajEOkREWLliuvGmu0pLv10rr4kQjGAPn8SqqX8yTpKEHtkmHzueLCgocozA1c
         Xu9141RD4pF85Sb56qROkM5WSUzdibeFV6UCKgQA87edE8NPNX3imSUDKbfSEleUqX
         9Rm6dfZR3qO/Me8hvV+wMhVXs8okdyoJCdlYUhy9utNGqKj1d2If2fbqsDsVvXUEBL
         hCkr/Khg1eYlQ==
Date:   Wed, 8 Jun 2022 20:29:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, kgraul@linux.ibm.com, ivecera@redhat.com,
        jmaloy@redhat.com, ying.xue@windriver.com, lucien.xin@gmail.com,
        arnd@arndb.de, yajun.deng@linux.dev, atenart@kernel.org,
        richardsonnick@google.com, hkallweit1@gmail.com,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
Message-ID: <20220608202934.6412b843@kernel.org>
In-Reply-To: <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
References: <20220608043955.919359-1-kuba@kernel.org>
        <YqBdY0NzK9XJG7HC@nanopsycho>
        <20220608075827.2af7a35f@kernel.org>
        <f263209c-509c-5f6b-865c-cd5d38d29549@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022 16:58:08 -0600 David Ahern wrote:
> On 6/8/22 8:58 AM, Jakub Kicinski wrote:
> > IMO to encourage use of the track-capable API we could keep their names
> > short and call the legacy functions __netdev_hold() as I mentioned or
> > maybe netdev_hold_notrack().  
> 
> I like that option. Similar to the old nla_parse functions that were
> renamed with _deprecated - makes it easier to catch new uses.

Well, not really a perfect parallel because _deprecated nla has to stay
forever, given it behaves differently, while _notrack would hopefully
die either thru conversion or someone rightly taking an axe to the
cobwebbed code.

Either way, I hope nobody is against merging the current patch.

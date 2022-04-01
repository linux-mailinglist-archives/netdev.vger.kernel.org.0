Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94DD34EF8ED
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350061AbiDAR1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 13:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350014AbiDAR1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 13:27:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1071DDFEC
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 10:25:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B524B82580
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 17:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B083FC2BBE4;
        Fri,  1 Apr 2022 17:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648833950;
        bh=dSPv0fqgphVXCzmTHDzcq9F20jbSIoGQ3mZ1f1H4Wmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cU5eD8xGL7QcD96KDZ908W8pLXuUOLP7Scz45qNnyNGP5N4KIJmnYJRbr8Py4SZ5w
         dHdLmHVHY6uekTEsvtb6RoP+5N2Dj92KdIc3geq2rwQqjvprKYg+h07mFToYvUAJ5V
         XOptzVE32g/FM1yvC2BTpxx2gnurBKjv9pOvPbOkpK/eLu4mOjrdzTpaGM3PQGJotk
         /qUJ9G/TLlW9b+kmA2Gzk01yGpRRj6ZZ//PFdal4YK9rf8J9tiXAhof0aOptJvsm9C
         +nzsVJrt19y4Pvv4JJ/2dSuqvpGujFGDoXs9UI1wWiJSHa52REmxzxV8VNu+ck2O8p
         jpStMT5WpBesg==
Date:   Fri, 1 Apr 2022 10:25:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net-next] rtnetlink: return ENODEV when ifname does not
 exist and group is given
Message-ID: <20220401102549.059ba70a@kernel.org>
In-Reply-To: <ba682166-956f-1eb7-1180-04b903234752@wifirst.fr>
References: <20220331123502.6472-1-florent.fourcot@wifirst.fr>
        <20220331203637.004709d4@kernel.org>
        <ba682166-956f-1eb7-1180-04b903234752@wifirst.fr>
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

On Fri, 1 Apr 2022 15:57:52 +0200 Florent Fourcot wrote:
> > Would it be slightly cleaner to have a similar check in
> > validate_linkmsg()? Something like:
> > 
> > 	if (!dev && !ifm->ifi_index && tb[IFLA_GROUP] &&
> > 	    (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]))  
> 
> 
> That will add some complexity in validate_linkmsg, since we will need to 
> check NLM_F_CREATE flag before (it's probably not an error when 
> NLM_F_CREATE is set), and to give ifm as argument to check ifi_index.
> 
> I do not have a strong opinion on this topic, and if you think your idea 
> is a better solution I can give a try in a v2.

Okay, fair. Please repost on Monday, tho, net-next is currently closed
(contrary to some status pages may be telling you...)

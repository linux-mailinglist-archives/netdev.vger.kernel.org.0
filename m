Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD066A1557
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBXD1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:27:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXD1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:27:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6B24FAA2
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 19:27:44 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id x34so11707352pjj.0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 19:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=78xvw2mV+Li1HNzYL871rsu+Xu/pShY+j0cxaOir8js=;
        b=UjqqDGecet/euzZVWZOmDxI3yG2QSJmZ1ZwNfLRB/wwOE2wkq9tbRbiRBk+4+VKZ//
         /Kng2Uj0uFNpMuK/ogrkv16REVOtiXYy0AY98JViC9kIskkHkhq4hPwOLWqF/Uz1ZLkg
         wEK5dXVzh+ZAu9WRn54aIlwLMgOl22OehqVuAxegAi4B5BbloYZKewPjiss/uiWlBSdT
         L+g8l3Dok/qJ48877LD7rI39qzZ6jeXV+Wy/uHo+Orx1NykvpFZYfDojK2kADmDlL5wO
         dS0LrWdodfbVFmbdBCLnN68j2hy0uJxZ47KMckrcWDp4Y9G/aOsm26uzoz28po/Ymsl/
         4h1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=78xvw2mV+Li1HNzYL871rsu+Xu/pShY+j0cxaOir8js=;
        b=MfMz0ONpb2esZJ0osmojQFJXX0WJ6tfvs13AiVd1JWgrpkvsARwYb1yGtS9EdtxyQb
         gGYdqkpGtRKKsQlRyZY87ZrmgzAR5hFSM7EwMVgcjsMkF6UJrjtex2pzM0G7hh82lYjS
         mRW1p1cV91IIa8+o/2HYjBCorIl637Ebclat/JJ5BWf6yIl9doXomoOuJk068KehUqgV
         eDkmTSmzheAwbFxC2XAXQvM0LrAtska8jnV6TbYH4st23sNx2EObp/AJMwk9IX9st1PZ
         HWJsavyHrIbDNIswSpJ5XJBV8TR6T4Efb6JwCMv8SoPujex4a/cQmPnwiNY/QNL2F12x
         Zo0A==
X-Gm-Message-State: AO0yUKXjE1iJIsVHl3bzVbeVzNeX+yEffAyJGnHVqJxOKptiLHuUnlCF
        juT6QOTEglf/ZzAjG38nLH0ARAMC+NeFFadtj4s=
X-Google-Smtp-Source: AK7set+gLgnAl2dFwGmYsUUeyy+GaaWVsIOdf/tHcp+svvqas6mbUtMGiaJWGIlCZ7nCgQsuOLGmGw==
X-Received: by 2002:a17:90b:1d82:b0:233:f3c2:a86d with SMTP id pf2-20020a17090b1d8200b00233f3c2a86dmr17180461pjb.47.1677209263926;
        Thu, 23 Feb 2023 19:27:43 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u20-20020a17090adb5400b002371e290565sm448524pjx.12.2023.02.23.19.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 19:27:43 -0800 (PST)
Date:   Thu, 23 Feb 2023 19:27:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230223192742.36fd977a@hermes.local>
In-Reply-To: <20230224015234.1626025-1-kuba@kernel.org>
References: <20230224015234.1626025-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 17:52:34 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> Back in 2006 kernel commit 334c29a64507 ("[GENETLINK]: Move
> command capabilities to flags.") removed some attributes and
> moved the capabilities to flags. Corresponding iproute2
> commit 26328fc3933f ("Add controller support for new features
> exposed") added the ability to print those caps.
> 
> Printing is gated on version of the family, but we're checking
> the version of each individual family rather than the control
> family. The format of attributes in the control family
> is dictated by the version of the control family alone.
> 
> Families can't use flags for random things, anyway,
> because kernel core has a fixed interpretation.
> 
> Thanks to this change caps will be shown for all families
> (assuming kernel newer than 2.6.19), not just those which
> by coincidence have their local version >= 2.
> 
> For instance devlink, before:
> 
>   $ genl ctrl get name devlink
>   Name: devlink
> 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> 	commands supported:
> 		#1:  ID-0x1
> 		#2:  ID-0x5
> 		#3:  ID-0x6
> 		...
> 
> after:
> 
>   $ genl ctrl get name devlink
>   Name: devlink
> 	ID: 0x15  Version: 0x1  header size: 0  max attribs: 179
> 	commands supported:
> 		#1:  ID-0x1
> 		Capabilities (0xe):
>  		  can doit; can dumpit; has policy
> 
> 		#2:  ID-0x5
> 		Capabilities (0xe):
>  		  can doit; can dumpit; has policy
> 
> 		#3:  ID-0x6
> 		Capabilities (0xb):
>  		  requires admin permission; can doit; has policy
> 
> Leave ctrl_v as 0 if we fail to read the version. Old code used 1
> as the default, but 0 or 1 - does not matter, checks are for >= 2.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

What about JSON support. Is genl not json ready yet?

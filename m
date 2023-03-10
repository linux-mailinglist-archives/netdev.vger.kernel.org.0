Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FBC6B3DEE
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCJLfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjCJLfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:35:24 -0500
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Mar 2023 03:35:21 PST
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B9712CD1;
        Fri, 10 Mar 2023 03:35:20 -0800 (PST)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 32ABSr52424694;
        Fri, 10 Mar 2023 12:28:53 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 32ABSr52424694
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1678447733;
        bh=90o32Qv6NnuhTo4OjwWNquT/pJ6Tc+LiKhCofZRYWOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EFBV/thqXzCJz+qcs19ouzp0t54MWWK7kArA50cxfUj6If+RqhXXdfm8vo1Kd+HbK
         lWhtx6vm49C0CauexgxzFWfwMv6IfuAca8GAXy1bF6+6JRz4Z7dGRSiFAFDC+QMcEh
         YEVZ3MBSX1hcZ6xEt2pCTtUITqrlySYoSA0aoY9Q=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 32ABSp2M424693;
        Fri, 10 Mar 2023 12:28:51 +0100
Date:   Fri, 10 Mar 2023 12:28:50 +0100
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Gencen Gan <u202011061@gmail.com>
Cc:     Chas Williams <3chas3@gmail.com>, Dongliang Mu <dzm91@hust.edu.cn>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: he: fix potential ioremap leak of membase in he_dev
Message-ID: <20230310112850.GA424646@electric-eye.fr.zoreil.com>
References: <20230310102256.1130846-1-u202011061@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310102256.1130846-1-u202011061@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=3.2 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gencen Gan <u202011061@gmail.com> :
> In the function he_start() in drivers/atm/he.c, there
> is no unmapping of he_dev->membase in the branch that
> exits due to an error like reset failure, which may
> cause a memory leak.

Why would he_dev->membase not be unmapped in he_stop() ?

he_stop() is paired with he_start() as soon a he_start() returns
anything different from 0 in he_init_one(). I see no other place
where he_start() is used.

The atm_dev/he_dev pointers also seem correctly set.

-- 
Ueimor

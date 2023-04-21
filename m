Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDCE46EAB2E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjDUNDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjDUNDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:03:51 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72D11729
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 06:03:49 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1802C24000A;
        Fri, 21 Apr 2023 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1682082228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JMxUvDabaxqKpxgzMux6sosbLxFNr84Qq1ir7sgivyk=;
        b=CvkoWeMZZyFHbcmbAoHGct1SsTZ8cNuC5HEuQsF5lvTYcpJ6/F2U2ouztn33qkx8gT+GPX
        8+uqR6crGWqR776lfKXXKnr7RgydeIUph9Q3ihQpIupCkmVE+rhZ9icNqGEdRnWeJYSyS1
        24xpebwXZzP3j0Ape8w5iE3uqVqWRnfikDXDQv+hb6qwIgxNUS/VRkqL5ouATceIjGUF23
        B+xumtVhBZgLlYpqxh/WLiJehNPMdvOaQ4l5Q0dX+9CXVMul/T07Vqugm2Q5brfeeOTWSe
        wNkJDyqMEoVhgUzQlLO7YyNxrXaz+9eiKb2AQwISgs1zkvL2ST4rHU3tQb2BQA==
Date:   Fri, 21 Apr 2023 15:03:44 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Max Georgiev <glipus@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, kuba@kernel.org,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 1/5] Add NDOs for hardware timestamp get/set
Message-ID: <20230421150344.278bece3@kmaincent-XPS-13-7390>
In-Reply-To: <CAP5jrPFytnMku6TQNFQGBh4-=mL0z3XVq7ofY1z3LPYMP7_G0Q@mail.gmail.com>
References: <20230405063144.36231-1-glipus@gmail.com>
        <20230405123130.5wjeiienp5m6odhr@skbuf>
        <CAP5jrPH__dJpGepM6Vs45PH+Pppx6KOVnUDS5f44DGeyseghfQ@mail.gmail.com>
        <20230420161609.2b65a1ed@kmaincent-XPS-13-7390>
        <CAP5jrPFytnMku6TQNFQGBh4-=mL0z3XVq7ofY1z3LPYMP7_G0Q@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 12:04:06 -0600
Max Georgiev <glipus@gmail.com> wrote:

> I've updated the patches in the stack based on the feedback you folks
> kindly shared
> for v3. I'm currently testing the combination of the changes in
> dev_ioctl.c and netdevsim
> driver changes - almost done with that. Let me finish this testing,
> then update the patch
> descriptions, and I'll be ready to send it out for review.
> 
> Regarding e1000e conversion patch: I don't have access to any NICs
> with hw timestamping
> support. I was going to drop the e1000e patch from v4 unless someone
> volunteered to test it on real hardware. But that will have to wait till the
> rest of the stack is reviewed and
> at least preliminary accepted, right?

Great, thanks for the status.
Indeed, if no one raise its hand to test the e1000e conversion you can drop it.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3B86C884E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjCXW1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjCXW1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:27:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C808F15148;
        Fri, 24 Mar 2023 15:27:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81D9DB8263B;
        Fri, 24 Mar 2023 22:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21A3C433D2;
        Fri, 24 Mar 2023 22:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679696856;
        bh=XHjxbosZn+j7wGljSl4bxw6luplVWMdt0qCtSaiDRJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qZfRdcRdFg4thtCH7gR8ms/yI/dB3X4hTJO8DgEhclWpEiJVv12dK+ifSlijSot30
         /ZOewsL8w/Ud+HJ9SOQrl5H6Aq19nM99KSJjFHlj2iS1kX2zfhz0+HaMmjoAHbwBM8
         UASgM3GOARfdJfFiNlhGPMuTWPJQAZm8L6k734P7DXqfQyNCZ9pb1DNMQewqPN9Siv
         bz8pmOFD0iG9i4wgwzYn4hzMxbO9p8AHr0tMm14puz48xvcA3i1pfVx/im0ShAZDqD
         mlkvqnZ8hsrK9q1aF9VjCZ9zzUbdoyUYOpHxS2YL11MQlCIpO1IyFgIy5SRqMEtHwG
         CREYm3U25F3wQ==
Date:   Fri, 24 Mar 2023 15:27:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Dulov <D.Dulov@aladdin.ru>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-patches@linuxtesting.org" <lvc-patches@linuxtesting.org>
Subject: Re: [PATCH] media: dib7000p: Fix potential division by zero
Message-ID: <20230324152734.1a2f0e90@kernel.org>
In-Reply-To: <2953a53dd08247ca8b762cc9d3782c81@aladdin.ru>
References: <20230324131209.651475-1-d.dulov@aladdin.ru>
        <20230324131445.g42kvq5wzj2z3qil@skbuf>
        <2953a53dd08247ca8b762cc9d3782c81@aladdin.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 13:26:13 +0000 Daniil Dulov wrote:
> Sorry, I used a script with a wrong module, my fault.

Always run the script on the patch itself, not on a file path.

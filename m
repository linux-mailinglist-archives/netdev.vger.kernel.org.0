Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFF56ED7DE
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbjDXW02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbjDXW00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:26:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B47A5F7
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CABB6267C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 22:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5077C433EF;
        Mon, 24 Apr 2023 22:25:55 +0000 (UTC)
Date:   Mon, 24 Apr 2023 18:25:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/2] DSA trace events
Message-ID: <20230424182554.642bc0fc@rorschach.local.home>
In-Reply-To: <20230421124708.tznoutsymiirqja2@skbuf>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
        <d1e4a839-6365-44ef-b9ca-157a4c2d2180@lunn.ch>
        <20230412095534.dh2iitmi3j5i74sv@skbuf>
        <20230421213850.5ca0b347e99831e534b79fe7@kernel.org>
        <20230421124708.tznoutsymiirqja2@skbuf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 15:47:08 +0300
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Fri, Apr 21, 2023 at 09:38:50PM +0900, Masami Hiramatsu wrote:
> > If the subsystem maintainers are OK for including this, it is OK.
> > But basically, since the event is exposed to userland and you may keep
> > these events maintained, you should carefully add the events.
> > If those are only for debugging (after debug, it will not be used
> > frequently), can you consider to use kprobe events?
> > 'perf probe' command will also help you to trace local variables and
> > structure members as like gdb does.  
> 
> Thanks for taking a look. I haven't looked at kprobe events. I also
> wasn't planning on maintaining these assuming stable UABI terms, just
> for debugging. What are some user space consumers that expect the UABI
> to be stable, and what is it about the trace events that can/can't change?

Ideally, tooling will use the libtraceevent library[1] to parse the
events. In that case, if an event is used by tooling, you'll need to
keep around the fields that are used by the tooling.

-- Steve

[1] https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/

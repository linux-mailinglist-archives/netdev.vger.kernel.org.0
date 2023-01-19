Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73754673FC5
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjASRU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjASRUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBC8558B
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D589461CE6
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 17:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1975BC433D2;
        Thu, 19 Jan 2023 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674148823;
        bh=JJt4uhOpfmTA+Xwubgq2HIIkhYTeSr/APkIytddUZHc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3Vh0MmGnmWidQs4neXWdhPnuvnwSa/aS5Xcnu+BILoNmDgmnhCFn5TVeYiD7Huk9
         lfITTW631UcCNC4xOHhb8svwHvtR6LbkE7QAcKqysP14bkWSGoeVUcek9ztUf71VWf
         jG1siiuOY6OJnhO4bc4c5T92A/qRky2t5sKMBTzU5cFbmZs5+eWQ9zfokfA6EuV7ju
         T2k4eBEVLUrMy3aJfgX3G09dDa3zbu40CYAsI70fAxlM02305CSLuDIISPIE/hznU7
         SA0y56oyMDvz8+MNt7nYY5yDqCvrM7br/KmqErj5QGlPqIpkP0a0Y+XvaRPeEEPOU1
         ubHqrvNtwl+rA==
Date:   Thu, 19 Jan 2023 09:20:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeremy Harris <jeharris@redhat.com>
Cc:     netdev@vger.kernel.org, jgh@redhat.com
Subject: Re: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
Message-ID: <20230119092022.09c6f179@kernel.org>
In-Reply-To: <ee84e51b-e41d-9613-fac7-42fa58a1f7ac@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
        <20230111104618.74022e83@kernel.org>
        <2ff79a56-bf32-731b-a6ab-94654b8a3b31@redhat.com>
        <20230112160900.5fdb5b20@kernel.org>
        <ee84e51b-e41d-9613-fac7-42fa58a1f7ac@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 17:05:55 +0000 Jeremy Harris wrote:
> > I experimented last year with implementing CoDel on the input queues,
> > worked pretty well (scroll down ~half way):
> > 
> > https://developers.facebook.com/blog/post/2022/04/25/investigating-tcp-self-throttling-triggered-overload/  
> 
> That looks nice.  Are there any plans to get that upstream?

The use of XDP is more of a temporary hack. I hope BBRv2 or some other
congestion control protocol accounting for host-level congestion will
soon come out of Google or Meta :(

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136C56DC407
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 09:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjDJHxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 03:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDJHxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 03:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C56AE9;
        Mon, 10 Apr 2023 00:53:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26C2D61172;
        Mon, 10 Apr 2023 07:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E496C433D2;
        Mon, 10 Apr 2023 07:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681113217;
        bh=hZP1LEVAHrrf65hDXBAJdvxdejUUBgJCmxgpdFyWaPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rzx1y8wsNaNVEydnhItIOizIuZZI/icVygRId5pRveImMTYDQjM5wNF4jaSoOfzOx
         GpAh0G9ljR0TJrRddc5svN/Ugpw/cifBJZ/b2EEUOoJ0g4crclnL/yAcVgZKsqZnox
         tqgF3YP35oGESWEU13u6FeKsuw1uSLxfqRjA+n15CreY6NvhK5p6qv3t6JR82WEoFP
         fCX2PqaEYwoZ9l+g4xtlHlxULVCLN21Cc7WZ/BpFnTxYQiSPk1/xXZYkn8mdLbNev2
         /kD01U4APggmCqpftXwX0ULE1laLRbsO3j+I5xpN9z/ODIJR/0i7XwgK6M8brf5uL+
         bwmhUiAiLyTJA==
Date:   Mon, 10 Apr 2023 10:53:33 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gautam Dawar <gdawar@amd.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
Message-ID: <20230410075333.GM182481@unreal>
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230409091325.GF14869@unreal>
 <CACGkMEur1xkFPxaiVVhnZqHzUdyyqw6a0vw=GHpYKJM7U3cj7Q@mail.gmail.com>
 <ba8c6139-66c3-a04b-143d-546f9cbccb70@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba8c6139-66c3-a04b-143d-546f9cbccb70@amd.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 12:03:25PM +0530, Gautam Dawar wrote:
> 
> On 4/10/23 07:09, Jason Wang wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Sun, Apr 9, 2023 at 5:13 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > On Fri, Apr 07, 2023 at 01:40:01PM +0530, Gautam Dawar wrote:
> > > > Hi All,
> > > > 
> > > > This series adds the vdpa support for EF100 devices.
> > > > For now, only a network class of vdpa device is supported and
> > > > they can be created only on a VF. Each EF100 VF can have one
> > > > of the three function personalities (EF100, vDPA & None) at
> > > > any time with EF100 being the default. A VF's function personality
> > > > is changed to vDPA while creating the vdpa device using vdpa tool.
> > > Jakub,
> > > 
> > > I wonder if it is not different approach to something that other drivers
> > > already do with devlink enable knobs (DEVLINK_PARAM_GENERIC_ID_ENABLE_*)
> > > and auxiliary bus.
> > I think the auxiliary bus fits here, and I've proposed to use that in
> > V2 of this series.
> 
> Yeah, right and you mentioned that are fine with it if this is done sometime
> in future to which Martin responded saying the auxbus approach will be
> considered when re-designing sfc driver for the upcoming projects on the
> roadmap.

Adding new subsystem access (vDPA) is the right time to move to auxbus.
This is exactly why it was added to the kernel.

We asked to change drivers for Intel, Pensando, Mellanox and Broadcom
and they did it. There are no reasons to do it differently for AMD.

Thanks

> 
> Gautam
> 
> > 
> > Thanks
> > 
> > > Thanks
> > > 

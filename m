Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42DD151E7C6
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 16:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446538AbiEGO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385469AbiEGO0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 10:26:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FC545AEF;
        Sat,  7 May 2022 07:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4DKiZOR0d8gLevCXFlmwVusn6daMOTUf4ijErpfvJ34=; b=rsVi+Suue0O1GTak3ZsMm4pHDR
        a8ln2A+a4+MyYT4xuAf8ZkCaAUBBnkilIAEqymUyyEc7NDUSsJwVQuGPqeLgVl2oe0yIo2DHHpGj6
        hyAJqMeR76ukQEKrFhdQXaDfjdValCyFWHC4mmoH25wAUYYmL8SaLACozqA4bWGuxA0M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnLJv-001fOc-CB; Sat, 07 May 2022 16:22:07 +0200
Date:   Sat, 7 May 2022 16:22:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jason Xing <xingwanli@kuaishou.com>
Subject: Re: [PATCH net-next] net: use the %px format to display sock
Message-ID: <YnaAj1FoaBVnVzgt@lunn.ch>
References: <20220505130826.40914-1-kerneljasonxing@gmail.com>
 <20220506185641.GA2289@bytedance>
 <CAL+tcoBwQ2tijfzwOO6zb2MobCL27PcyN3foRcAw91MpyWg_VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoBwQ2tijfzwOO6zb2MobCL27PcyN3foRcAw91MpyWg_VA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 07, 2022 at 09:26:07AM +0800, Jason Xing wrote:
> On Sat, May 7, 2022 at 2:56 AM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > Hi Jason,
> >
> > On Thu, May 05, 2022 at 09:08:26PM +0800, kerneljasonxing@gmail.com wrote:
> > > -             pr_err("Attempt to release TCP socket in state %d %p\n",
> > > +             pr_err("Attempt to release TCP socket in state %d %px\n",
> >
> > I think we cannot use %px here for security reasons?  checkpatch is also
> > warning about it:
> >
> 
> I noticed this warning before submitting. Since the %p format doesn't
> print the real address, printing the address here will be helpless and
> we cannot trace what exactly the bad socket is.
> 
> What do you suggest?

How is a socket identified in places like /proc/<PID>/net/tcp ?
Could you print the local and remote port to identify the socket?

How does the address of the structure actually help you? Do you see
this address somewhere else?

     Andrew

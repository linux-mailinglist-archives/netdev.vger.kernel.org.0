Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BDA501C5E
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243381AbiDNUL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiDNULZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:11:25 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47223E72BD;
        Thu, 14 Apr 2022 13:08:59 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id e128so2859444qkd.7;
        Thu, 14 Apr 2022 13:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q4kreATfvq0PCaErDqGIK51qsHXx4Hc2V23ylLftIFw=;
        b=S2p8PHRmvbHylIwf9EywH65p/YVOMq5tltG2DuWda+hJlblQT/P1SMnQp2tGUzNuvm
         Gv/FQgW8wFml5y6o1zrKALK3f02vG55M9QvKUR2SxskMpptmKDABXJ41/sgmZxyaq2eh
         SQw2bTObHrIIvXIOTw+SMrk41IYc0WdNwpR/oNYu+HfGLJfI0WF7St2kGTVmRxcJcNgn
         /BFcyPTOHQay1afj1FBn6RfMUu15WZcO51MnwSKRxI0fjlTsWv165PsZ18SGoU/DD27f
         cduV/vxpiPGoeNWQAtAGWc0bvlD0k4EMEYgyWWMIEf2OMn/2n9IcwxpT0IrPb/gWAazm
         oVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q4kreATfvq0PCaErDqGIK51qsHXx4Hc2V23ylLftIFw=;
        b=g8zezIlydSgMHUfejlD9Uw1Z9rRf1xHm8/veHWtRicMP+OojGtfpODgpF1L2T7aZUr
         r/q/XkwvxHVsg+gma6ZCB7ysPx/Jt06+pjWmoUPMaH7GpByovzRjc+2HZjVPD7mFHKz3
         sXuQIpfhciE7jQkS1zzKPCzXt+zCfqsItUBWtMjyySRSwcnf0MmIflUTLD73pcsHcqzW
         z6/fpy2Q01OkauqzvhN42ekP+qEuW3RURmwrun3qFs3ZpGdiayG7qY47MlBgeyevJZNX
         7QWhNrSqZCRK4/D3Vyk7fXeBEtjp5moa2KXJ35EPsD0yHK/k2z3Y2xQuUXJnflzawmtA
         eWYA==
X-Gm-Message-State: AOAM5312Kckuccq6CdHmlR0DjhSXuxlvxEOmZ9dfZLoIrLCmEBl5tVr6
        Ah3KUpvCvEKY9yqB01I15Q==
X-Google-Smtp-Source: ABdhPJyqV76gySzIL0/xph1+Z6yrRbCplKzU6+1U5ggnhq15OLcGE2TkXRm/iyBYA0JmDcSnoCe6Eg==
X-Received: by 2002:a37:4c3:0:b0:69c:84ca:5923 with SMTP id 186-20020a3704c3000000b0069c84ca5923mr1983372qke.503.1649966938325;
        Thu, 14 Apr 2022 13:08:58 -0700 (PDT)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id q17-20020a05622a031100b002f1d478c218sm1939035qtw.62.2022.04.14.13.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:08:57 -0700 (PDT)
Date:   Thu, 14 Apr 2022 13:08:54 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220414200854.GA2729@bytedance>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
 <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
 <20220414131424.744aa842@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414131424.744aa842@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Apr 14, 2022 at 01:14:24PM +0200, Jakub Kicinski wrote:
> On Mon, 11 Apr 2022 15:33:00 -0700 Peilin Ye wrote:
> > I couldn't find a proper Fixes: tag for this fix; please comment if you
> > have any sugguestions.  Thanks!
> 
> What's wrong with
> 
> Fixes: 6712abc168eb ("ip6_gre: add ip6 gre and gretap collect_md mode")
> 
> ?

Thanks!  I will add this in v2 soon.

> > diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
> > index b43a46449130..976236736146 100644
> > --- a/net/ipv6/ip6_gre.c
> > +++ b/net/ipv6/ip6_gre.c
> > @@ -733,9 +733,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
> >  	else
> >  		fl6->daddr = tunnel->parms.raddr;
> >  
> > -	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
> > -		return -ENOMEM;
> > -
> >  	/* Push GRE header. */
> >  	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
> >  
> > @@ -763,6 +760,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
> >  			(TUNNEL_CSUM | TUNNEL_KEY | TUNNEL_SEQ);
> 
> We should also reject using SEQ with collect_md, but that's a separate
> issue.

Could you explain this a bit more?  It seems that commit 77a5196a804e
("gre: add sequence number for collect md mode.") added this
intentionally.

Thanks,
Peilin Ye


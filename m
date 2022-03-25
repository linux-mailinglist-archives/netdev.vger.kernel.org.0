Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817D44E6B7A
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357041AbiCYAKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 20:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357019AbiCYAKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 20:10:02 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763FA72E00
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:08:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y6so3883511plg.2
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZlGtkDD5efFwbsPMaGSPJ4dbuKuFuJEoRIhg3Juna+k=;
        b=TXEtnsy9ve2xQVsSmJizhCiTcGp3hZFiDx7mLxNvqn/VP+6S6Ovq1n0Rg4VyUrABQD
         DmI8q+CSphzz9x1VV6D5GvCH1Rvoc40S1Siqzwa2KfbtXTj7WSvUIv2dLnwJp8N1Eh9q
         WOVKtwY8vpsuQrOyC5JU1dPJh+o5wowAO0iJuo7IbCSpE93RSRdfhtunvZpLDaIYsbCe
         SrJuaxvU52rbnmn/49QM0J4TbDMZPWjpLJMfZGJnwliArnBXiuE4RW4xMyMUrSMqghQr
         8cochNLF58hZB5K9nC6CjExvaUH3dhD/lexTOVUVC2JlQvDqrUr7CSV2NY25SBkCqRPJ
         N3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZlGtkDD5efFwbsPMaGSPJ4dbuKuFuJEoRIhg3Juna+k=;
        b=gby44b1sJ+u3dxe8GzhFqYkJoz+rt+A+wkpKU6BJE8JT+71w7xoihvoXmLj6SXe+61
         O6KN2VMYY2b8VNg6i0kbB64N5oaYE7zM5zq0gpfEaK97QmT3I5fIRxzzLn7xoTjU3YKE
         PvqyTwvUEpW8MlzP0O30He4Y8/R8Hlvb+Bq8GVT8bHpWrGUsqo8OpWLINl5H5jXvJWKg
         3/bfAj8J59JovgxjJj5nJ3AYBuNQi5kqQE1orhIA0HLcSJtz3h7o84hIsdq8uxYOKo4P
         +dt3Gxhwm1wyNzAF2OR/z/ToxKW5zzo0KeAfl0d8oSK1+vLb0AI4t1I/uM9aMMalf7a/
         jHag==
X-Gm-Message-State: AOAM531vVe5+2pif8eQqKcFKCOpchumel4Dc2EPeraXC//FuzXoPhYgw
        3vflSNA9+p3r9wbkRiCwFPU=
X-Google-Smtp-Source: ABdhPJy1cQ445n0XXzjuYLjc8T+qJqtUHbCqcOli7wkz8HSRVZqLeVCVB8+GYTXQC/VVwzG9dliS7g==
X-Received: by 2002:a17:90b:17c3:b0:1c6:b0ff:abf with SMTP id me3-20020a17090b17c300b001c6b0ff0abfmr9264277pjb.24.1648166909070;
        Thu, 24 Mar 2022 17:08:29 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r1-20020a63b101000000b00380989bcb1bsm3468204pgf.5.2022.03.24.17.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 17:08:28 -0700 (PDT)
Date:   Thu, 24 Mar 2022 17:08:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mlichvar@redhat.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v1 5/6] ptp: Support late timestamp determination
Message-ID: <20220325000826.GB18007@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-6-gerhard@engleder-embedded.com>
 <20220324140117.GE27824@hoboy.vegasvil.org>
 <CANr-f5zW9J+1Z+Oe270xRpye4qtD2r97QAdoCrykOrk1SOuVag@mail.gmail.com>
 <20220325000432.GA18007@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325000432.GA18007@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 05:04:32PM -0700, Richard Cochran wrote:
> On Thu, Mar 24, 2022 at 08:52:18PM +0100, Gerhard Engleder wrote:
> 
> > I thought that PTP packages are rare and that bloating the socket is
> > not welcome.
> 
> Some PTP profiles use insanely high frame rates.  like G.8275.1 with
> Sync and Delay Req at 16/sec each.  times the number of clients.

times the number of vclocks/Domains.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0FB6EAC8B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjDUONi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjDUONg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:13:36 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE01259E;
        Fri, 21 Apr 2023 07:13:23 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a682eee3baso18401875ad.0;
        Fri, 21 Apr 2023 07:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682086403; x=1684678403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5+jgzP3dq3fUDfYNj91FhL7qj234hVV03mQxJ2iISsI=;
        b=fDjix5406dKjbv9ovC1t+fYyBqwFWxgC+xUGq43FD/sT9K/ngIvHfhDgrF2YIpN/x1
         Kwx/p9T6RzcebvmZkZ/VajQ+G0ML6+Qyi3c3WRYvAmkvJUJzDRgBRQHXuKbQx1cAeQ1Z
         iDGIui7+DjGFtREP4TcCTtsOkrIxWw/olJGfMvQMit8lJZk6FUA6thpubO2uK5MHvjj5
         V+dbpkf/EarQBIQoZqJ81wbozeoIqhtgO3H5T1s86ivY5ti0nrmo2rx2aHgKjH1DoYd7
         EQQ0EegzAGtgcLGE9kAcMBKxRuSMkIOkEkz0f/o5hgcMgSWtI516PBXsIu/1Mpj30KvF
         RfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682086403; x=1684678403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+jgzP3dq3fUDfYNj91FhL7qj234hVV03mQxJ2iISsI=;
        b=Q/KkcOIc37ottR02v6IJSSlRvzu6gAtv2GFSKYkr87f9wtNWyZqmvCESra9b1Jgkd7
         KJwRrIn00ph4P7f0k0BK6elnvX+ILLM99wS2xPtxQ74triz4ZmVQ8V+HOqP6NEEdM5as
         IglhuDH/kJjhh/WFI0lh0lSouhaCvksF48lEjiVfizOcGrCpF9ZM2g+MgbK4dyOT+GW+
         ZsSgQjD0m9g4ejstingc2ivL4Vfmt1Z/nRzWY09q/A83h5kvoZdV7SZZcD3Rm7DWr80j
         /1LLXDh6vJ57g2dJOKjeP83c8YS8OPpQvVBHn95+zN5xIBDU6yw8U8yfVXaM4WhZ3VoW
         JAeQ==
X-Gm-Message-State: AAQBX9e5YQe5bDO8ymFxXNwDATALA4psY5BgNuTIYXcsL+Mo8j42xKSv
        GclgSS176D8+tALuUOPPaGo=
X-Google-Smtp-Source: AKy350b6PRfEIRSgozraHtoQrPwGPmdUXmordCng/KQmnPHv1L7tGNiEK19j0rvAWqg98++Y4nw63g==
X-Received: by 2002:a17:903:1247:b0:1a1:bfd6:f890 with SMTP id u7-20020a170903124700b001a1bfd6f890mr6117965plh.9.1682086402479;
        Fri, 21 Apr 2023 07:13:22 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ee9100b001a6cb827fafsm2823344pld.278.2023.04.21.07.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:13:22 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 21 Apr 2023 04:13:20 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jiangshanlai@gmail.com, linux-kernel@vger.kernel.org,
        kernel-team@meta.com, Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 06/22] net: thunderx: Use alloc_ordered_workqueue() to
 create ordered workqueues
Message-ID: <ZEKaABXSb-KppyMO@slm.duckdns.org>
References: <20230421025046.4008499-1-tj@kernel.org>
 <20230421025046.4008499-7-tj@kernel.org>
 <20230421070108.638cce01@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421070108.638cce01@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 07:01:08AM -0700, Jakub Kicinski wrote:
> On Thu, 20 Apr 2023 16:50:30 -1000 Tejun Heo wrote:
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Sunil Goutham <sgoutham@marvell.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: netdev@vger.kernel.org
> 
> You take this via your tree directly to Linus T?

Yeah, that'd be my preference unless someone is really against it.

Thanks.

-- 
tejun

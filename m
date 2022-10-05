Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CA65F4CF4
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 02:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiJEAOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 20:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJEAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:14:11 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D68B43E53;
        Tue,  4 Oct 2022 17:14:11 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d15so1851720qtw.8;
        Tue, 04 Oct 2022 17:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=VocuonG16Jwu6PMp07f1e9z3vXfekLkXYDhvCBP9/rQ=;
        b=N200ISG0LQ677OWfHxNWBt2SE0T0ZxqacB4wUtjKijWtbV2Ph0ySUpLd4g6rYdq1pO
         7vDrqct0n6avry/V/Wtzvj7tDg4mnG8k6W24wtrZllm9shyzntuIGzoMt0IUCywQNuqD
         GCLKeMz1Cb42DWymmlkJjlJGphrb/yI2EW31qa1R0+oUC+KujPnhuagVaySMRX4bJxnZ
         ss7hd4prMO9LHe2FgHuNOtWtrwjR0rx5BLvdrLvt5yUOdtUZOVWWfwZ3CIOM0ck9nljt
         kIywthXqHnvny3ZWx13+vzQy0C92XYPwpuMrOMyqEMjQx3Yel3XVXQ8FEGYtWB+/oC27
         iYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=VocuonG16Jwu6PMp07f1e9z3vXfekLkXYDhvCBP9/rQ=;
        b=W9cfhIJKteka/wKZuDqUT61laQhsYP1uUGo0fggDSMd4qJH8N7DOubDAaX5kGOKdxN
         L9eQU2O0tSjPA6uAdD3uFxBdDFYmj4SxnxzXhjKX3yHiYwUW5sT3FN7f8/dmau/0wGuK
         +sqyoCLVPTdbU8qRuGIVctJJhJIB4UP7Ry4qrFppHaqdNOt++0BQyF/2eAqto7YrpmhD
         PM0AsimCXlMgwfQPaP04IpsO5poV9B/Vqyuvf8iBZvh2bFDvat22ascnG4aXVqSFIsBm
         p36Hg8UrVzKFiPQvS+KQlIaaOMyt7cxeVwykmj7ehxK2RRuoWteLFgDpxtgV3yAtr7mR
         0nCQ==
X-Gm-Message-State: ACrzQf30UuiasiixDshbOVyxsA7D8r2Thy+AQR7Fp6Ocqa3fv3vb/NsM
        dq/ii6TWI8CqX/06JxggMg==
X-Google-Smtp-Source: AMsMyM5MDEzcRrJp9qCXwQNskWUpDQJG4DFpGy2RX/Ya6enUO0sUMBguIthoo4NRq0oA7fugu8Zk1g==
X-Received: by 2002:a05:622a:3c6:b0:35d:4335:f060 with SMTP id k6-20020a05622a03c600b0035d4335f060mr21720947qtx.326.1664928850158;
        Tue, 04 Oct 2022 17:14:10 -0700 (PDT)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id u7-20020a05620a454700b006b640efe6dasm15982493qkp.132.2022.10.04.17.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 17:14:09 -0700 (PDT)
Date:   Tue, 4 Oct 2022 17:14:06 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/sock: Introduce trace_sk_data_ready()
Message-ID: <20221005001406.GA2291@bytedance>
References: <20220928221514.27350-1-yepeilin.cs@gmail.com>
 <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKJpWK9hWLPhfCYNcVUPucpgTf7s_aYv4uiQ=xocmE5WA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 09:19:34AM -0700, Eric Dumazet wrote:
> I would rather split this in two parts.
> 
> First patch adding and using a common helper.
> 
> static inline void sock_data_ready(struct sock *sk)
> {
>      sk->sk_data_ready(sk);
> }
> 
> s/sk->sk_data_ready(sk)/sock_data_ready(sk)/
> 
> 
> Second patch adding the tracing point once in the helper ?
> 
> Alternatively, why not add the tracepoint directly in the called
> functions (we have few of them),
> instead of all call points ?

Thanks for the suggestions.  I will move this tracepoint into callees in
v2.

Thanks,
Peilin Ye


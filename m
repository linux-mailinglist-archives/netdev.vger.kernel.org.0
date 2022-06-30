Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391D3561879
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234898AbiF3Kjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiF3KjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55BFBA196
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656585492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yGl6MUQ24ti5cfjlSOHRNrXBx6rhiFzn8XK6WULhaRw=;
        b=ZKSQ+j0InlssRGOfxmvm9AgL9PJGI2G0kq1ff4801HP5fnpAQIEnk63EMttdOJqzDfYDbA
        LcmIIqhia7wILFlTyG/G4w3qYl8z9kaye/WMLPt5/pAQf3PWPkwOtTmBhwoS52vFmkQBOn
        uhF0bO2T/W/3S7P1RSKVFL+RAm7z+vA=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-VKsAbNlkN1aNqJHCFEAGYA-1; Thu, 30 Jun 2022 06:38:11 -0400
X-MC-Unique: VKsAbNlkN1aNqJHCFEAGYA-1
Received: by mail-qv1-f70.google.com with SMTP id f6-20020a0cbec6000000b004728234508bso8505562qvj.8
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:38:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=yGl6MUQ24ti5cfjlSOHRNrXBx6rhiFzn8XK6WULhaRw=;
        b=jwM3kOGthIQPS3ZTUrL93/R34O8FWglpspnOwhrK6AK9cUvBroeSKry75gwBmQEnki
         WHaIcmoQPApffZBTGuJ1ok+zus+YicILnhhK0D5KPnvB2hBjvATmzaG+tn2F6CxxISll
         m7jyrtBC9fsATh8Ij0TfNfEGzADElbboA6Ty5kVPN4zGKRR+X7Fp4weIQzhfgYCX0i4x
         10/Ye+ewGF4hwjpiCLlhUW/Bmiu7JuEXswHwdb58j4lsAvbQkQ1soN6fwZQZK0Yzx5CI
         Q5j64b9LIvj3Xf+IBXaHaELjhvuaJ1PWqoIwp1R43Arjst2JlEI1LS69+TumLjAWY11o
         j8hQ==
X-Gm-Message-State: AJIora8p9lYkMSK2yoJ2eWAuFaKx7s0xkKGmRrU2322s22tmdXo6kGaS
        cAOQtU6rsfuo/sV9H1WHXps7OIYMp45SRKEWzJRDOPCn7vBULq4H65pcYumdDqoo/Ax8cWGjKl3
        B6BNsbXFRq/BsmgPN
X-Received: by 2002:ac8:4707:0:b0:2ed:b56:5531 with SMTP id f7-20020ac84707000000b002ed0b565531mr6699343qtp.148.1656585490627;
        Thu, 30 Jun 2022 03:38:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tSbvakF3KGQJlbD0PZISb+ptjP7QeINr/DLGrn1TOlNMF4Yu/ygfSzgfHBU+L3NwagosVlnQ==
X-Received: by 2002:ac8:4707:0:b0:2ed:b56:5531 with SMTP id f7-20020ac84707000000b002ed0b565531mr6699324qtp.148.1656585490359;
        Thu, 30 Jun 2022 03:38:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id bj16-20020a05620a191000b006a6ad90a117sm14963555qkb.105.2022.06.30.03.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 03:38:09 -0700 (PDT)
Message-ID: <bd69267ef785ac17f62bd856cb9bb5d7dae8138a.camel@redhat.com>
Subject: Re: [PATCH] cxgb4: clip_tbl: Fix spelling mistake
From:   Paolo Abeni <pabeni@redhat.com>
To:     Zhang Jiaming <jiaming@nfschina.com>, rajur@chelsio.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, renyu@nfschina.com
Date:   Thu, 30 Jun 2022 12:38:06 +0200
In-Reply-To: <20220629075516.28896-1-jiaming@nfschina.com>
References: <20220629075516.28896-1-jiaming@nfschina.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-29 at 15:55 +0800, Zhang Jiaming wrote:
> Change 'wont' to 'won't'.
> 
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>

Please read the guidance from Jackub on this kind of changes:

https://lore.kernel.org/all/20220623092208.1abbd9dc@kernel.org/

Thanks,

Paolo


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15ED4561A2C
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 14:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbiF3MRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 08:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiF3MRC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 08:17:02 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EEC120BCD
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 05:17:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x3so33442288lfd.2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 05:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cvHubHn8nkMyaR7AQ/Z72Z9Fv4k8mQv5JsVhUdwkgQo=;
        b=AvFYt8B/XqGGauvECbTb9nD1XSuFkBav5fYXARGexIQw5DNshsr+Y03COGqszbkg2v
         +BKqjsMpe4U9Ialh6RWzsglPiJFZGLaH0SVk/rQDO9uGxu87mW2HEv2PAgv/WBQcF1Wq
         UdG0A6Hvf66Hr0uRYzo9Ch1wkW/tE81hnXfssQD8b2GaPhjEdvlkQuy126WYy7muJniP
         xgZrle/l3SsJXGk1w0GyVKMsXLxirViQCaYYTrOy3Fxd/c7/7Gbn70wVJR/w1M8uY/J6
         96y6H2WgK13xVCv5j9ufh8LJ0SvEyj++0dwNKMcswJ7yd7NLCftoVXtDncqM4WKHEDC6
         83Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cvHubHn8nkMyaR7AQ/Z72Z9Fv4k8mQv5JsVhUdwkgQo=;
        b=v+revoUJ9NSj6HfSXZomEaOJsQwBw/ew5ItbH8JNugFnNMSxfK//XlfIJvRethN1Pb
         NNuT9jXI7IY+3RJq2FnOom/ec7PfSGNiy5rO6QXU3BKHLpgDKIuvVoVTs7+xv/8xsNyj
         jFlxLd7R64bdlVBsxQ3hLp/Ddn6j5IakRcB039Ld+Du9Wxd4ccI/Mt40vsoX7a0PPbXR
         UVnNibMoE8KSIQjb01IRkFQgvXuofUtQqzcCx1ENxdjNfFLDfFODnXO1M+CHqdRWiq4Y
         NZZGeGQ8A2AirQAzo0m+nGZqIvwn5cZpqMHcT7aYAJJt2qhH62inqsocprej2lXBfoxu
         0htA==
X-Gm-Message-State: AJIora/wms06qr5C7/cPeXB1RVDCgsELWiPwp3EsJwQiwQJSHjh9buGR
        SFwsSD6eLxPIrAWi/W/CUYU=
X-Google-Smtp-Source: AGRyM1voZwl7NCMC5C63oAX29+QKQb7ibUu6y2VTUJp2NHg4BS/MWgRSCl3F+G2qdbqXjMBE1ankVw==
X-Received: by 2002:a05:6512:1151:b0:481:1988:d8e9 with SMTP id m17-20020a056512115100b004811988d8e9mr5492295lfg.338.1656591419333;
        Thu, 30 Jun 2022 05:16:59 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e3-20020a056512090300b00477c0365b20sm3069134lft.188.2022.06.30.05.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 05:16:58 -0700 (PDT)
Date:   Thu, 30 Jun 2022 14:16:57 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sparx5: mdb add/del handle non-sparx5
 devices
Message-ID: <20220630121657.oc5ygvtjzhxvzaxt@wse-c0155>
References: <20220628075546.3560083-1-casper.casan@gmail.com>
 <195d9aeee538692a3a630bfe7ce5c040396c507b.camel@microchip.com>
 <20220629202246.3a9d8705@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629202246.3a9d8705@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, yes. This is supposed to go to net, not net-next. I will resubmit
with a fixes tag.

Best Regards,
Casper

On 2022-06-29 20:22, Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 14:55:22 +0200 Steen Hegelund wrote:
> > On Tue, 2022-06-28 at 09:55 +0200, Casper Andersson wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > 
> > > When adding/deleting mdb entries on other net_devices, eg., tap
> > > interfaces, it should not crash.
> > > 
> > > Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> >
> > Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
> 
> We need a Fixes tag here, when did it start crashing?

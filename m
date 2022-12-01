Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B557D63EF3D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 12:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiLALRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 06:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLALRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 06:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61329591
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 03:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669893057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gkDP7EfapFUdGfqeDXTLY7qM/L4cTlWRaNGwDCfBrY4=;
        b=DJnb9dupqRWteLe9jwZPrEM2tYW2xSxYsthgQppWw8Yv9rXAYfwLOENTQxbpBslZmbLRkv
        0OWMtOz4iC69m2M9TGyI4gge73yp34WODEWTZxfsh6q45Yt1GaLiL66vnzyVL3vIKUMmJ1
        HUB+3obtNrDT4bVhDdIvgU5dtEthBc4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-w2_iWfgnPmOCq4h0MvftMA-1; Thu, 01 Dec 2022 06:10:56 -0500
X-MC-Unique: w2_iWfgnPmOCq4h0MvftMA-1
Received: by mail-wm1-f69.google.com with SMTP id 8-20020a05600c228800b003d0376e42deso556188wmf.4
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 03:10:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkDP7EfapFUdGfqeDXTLY7qM/L4cTlWRaNGwDCfBrY4=;
        b=NY+Ki3b5iCI4AomEEci8YFfwsttxuFsHA2ZVRt9cH3N3tmaUnULPbiiw/uNt24MJ5x
         1uGNTd1Vx/pDo2J5bI9gL+K5pTDAA93e5sOudGscaszzMjgOSXxnh/334Rey85Q7DDse
         btla5XRlEwx6JCNLVVcpEsfdixiTxhcNbqtxP1zuHVZ1tk6uk34w+xFdQkejV/OgJMPi
         GT7cfgUAoI3DJrV8V4HzwduM+hPadvM24Zz/GvaSiNbT+f3DDHGEtrtpUzi9X8A6Ganj
         CEp99fnrso93RioTB33BF+0zy1xVMt8aCiWBcYZz5iPXzotSLMW5ISJCOUz20BHpo1JX
         y6xg==
X-Gm-Message-State: ANoB5pmds6ufp+KzYK6qJ/6kUunHjRlRFKk2M/11jsecyfvKOCdXJTJR
        1KbB0xlWtUmnh+WbI3s80ixofpZlHG4mHEFYZQI0QM+o+H7a/UnMWt9PaorcOtO1bI4LKqnozEA
        b3FcpOl+qZCNd3Aav
X-Received: by 2002:adf:db81:0:b0:236:5144:f8ce with SMTP id u1-20020adfdb81000000b002365144f8cemr34355508wri.657.1669893055023;
        Thu, 01 Dec 2022 03:10:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7hTt/gJ9QF5CKhEkQZGXR0DgGW2WwedN4+HWoVXCjsimIJot6rutseO/1aBVJn4JC0YnxVJQ==
X-Received: by 2002:adf:db81:0:b0:236:5144:f8ce with SMTP id u1-20020adfdb81000000b002365144f8cemr34355489wri.657.1669893054801;
        Thu, 01 Dec 2022 03:10:54 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id bu9-20020a056000078900b0022e6178bd84sm4246351wrb.8.2022.12.01.03.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:10:54 -0800 (PST)
Message-ID: <46dd07115a4708dea649437ba04e7076e7721b9b.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuniyu@amazon.com, Pedro Tammela <pctammela@mojatatu.com>
Date:   Thu, 01 Dec 2022 12:10:53 +0100
In-Reply-To: <20221128154456.689326-2-pctammela@mojatatu.com>
References: <20221128154456.689326-1-pctammela@mojatatu.com>
         <20221128154456.689326-2-pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-28 at 12:44 -0300, Pedro Tammela wrote:
> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
> optimize actions and filters that are compiled as built-ins into a direct call.
> The calls are ordered alphabetically, but new ones should be ideally
> added last.
> 
> On subsequent patches we expose the classifiers and actions functions
> and wire up the wrapper into tc.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

There is a mismatch between the submitter and the SoB tag. You either
need to add a 

From: Pedro Tammela <pctammela@mojatatu.com>

tag at the beginning of each patch or your mojatatu account to send the
patches (assuming you prefer to retain the mojatatu SoB)

Thanks!

Paolo


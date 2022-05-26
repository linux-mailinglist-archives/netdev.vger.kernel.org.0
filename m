Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3979534AEC
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 09:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346530AbiEZHkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 03:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346478AbiEZHkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 03:40:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AE259CF6A
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653550821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h87lEcHWW9NSvSXQ8moSWArV+B37Hn/AuWysA9c+PK0=;
        b=ZE9Fy1qIu25acxEtmsGRjq/0vtPQo91AEEjbO8H+rqSw+nA9u2cMg7eRkulGZycc3GBtQm
        doCagEtzi0v4o1stU1MbznRauKQZbMtkdzQymMbhew29C2N5BxhNgcJ1I6OmXcbQ5j1HbP
        vGBdxfd6xkBZflSELGbm8PTy+eWro/I=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-594-Che3X3FsMIK8Gwgcq5-kAw-1; Thu, 26 May 2022 03:40:20 -0400
X-MC-Unique: Che3X3FsMIK8Gwgcq5-kAw-1
Received: by mail-qk1-f199.google.com with SMTP id x9-20020a05620a14a900b006a32ca95a72so749485qkj.22
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 00:40:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=h87lEcHWW9NSvSXQ8moSWArV+B37Hn/AuWysA9c+PK0=;
        b=OncqT4Oh2XXip+1AvkfsBydFFacmPNOBDOBBpbKnzkdNh/lGKAUZn8pZFWvACIxkS+
         n6kkovKVO777LkbOKfwIWMawY61xn3+m0S1mlGwZRxuG+kcnpewStGdIFLj5xyyYVCKZ
         IB0Mkk1+7J5LIGB/rgr+XSecolOveV8TTR+5t7ZY4N2iV5Cti/uoOMaFrM9vpWSOQ2lo
         ueiSO7Vxsxfp81nhTh3StTo6/zERdx8PxuKBgtei3BfQ7oEM/vOZP0Z8zP3100wpsChT
         veypbWa5dqPsINwFvJfSHRnUym+a4ZNGSHx7hMpnMpb4fPnh2Ubwmstsuw3bwcKtqo0u
         ZOiQ==
X-Gm-Message-State: AOAM532Udp1g0Z34GKMtEW8Go9V+UlMrnutD++JcTQwVDnllmDgGhSZQ
        1tyuS8FeUi+PkYTN1QYo+6WMLFxAnZQPOZT2/FdrgK3La8HMwNQM3WkYpKMTdPYuAR9/Xvuza+l
        JSZ/2xwx+Nu9mXX4H
X-Received: by 2002:a05:620a:1662:b0:6a3:5692:636 with SMTP id d2-20020a05620a166200b006a356920636mr18117749qko.311.1653550819603;
        Thu, 26 May 2022 00:40:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGZmitJKJqP0PNn4UMzLOXwHO4RgNOhYxUL06AUoEgZozxAhU6wiPgJMr6U+VIT3QBvaxigA==
X-Received: by 2002:a05:620a:1662:b0:6a3:5692:636 with SMTP id d2-20020a05620a166200b006a356920636mr18117739qko.311.1653550819282;
        Thu, 26 May 2022 00:40:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id k202-20020a37a1d3000000b0069fc13ce1d5sm830924qke.6.2022.05.26.00.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 00:40:18 -0700 (PDT)
Message-ID: <5497d8af4630264418ad91513e7eafeb016e6971.camel@redhat.com>
Subject: Re: [PATCH] ipv6/addrconf: fix timing bug in tempaddr regen
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sam Edwards <cfsworks@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Date:   Thu, 26 May 2022 09:40:14 +0200
In-Reply-To: <CAH5Ym4gm49mkMUKzyPqKT8vt3M67NZB-zoep3bu+VB3FbuVzCQ@mail.gmail.com>
References: <20220523202543.9019-1-CFSworks@gmail.com>
         <76f1d70068523c173670819fc9a688a1368bfa12.camel@redhat.com>
         <CAH5Ym4gm49mkMUKzyPqKT8vt3M67NZB-zoep3bu+VB3FbuVzCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-25 at 14:07 -0600, Sam Edwards wrote:
> Bah, I've had to resend this since it went out as HTML yesterday.
> Sorry about the double mailing everyone!
> 
> On Tue, May 24, 2022 at 3:24 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > I looks like with this change the tmp addresses will never hit the
> > DEPRECATED branch ?!?
> 
> The DEPRECATED branch becomes reachable again once this line is hit:
> ifp->regen_count++;
> ...because it causes this condition in the elseif to evaluate false:
> !ifp->regen_count

That condition looks problematic:


	unsigned long regen_advance = ifp->idev->cnf.regen_max_retry *
                                        ifp->idev->cnf.dad_transmits *
                                        max(NEIGH_VAR(ifp->idev->nd_parms, RETRANS_TIME), HZ/100) / HZ;

	if (age >= ifp->prefered_lft - regen_advance) {

'age', 'ifp->prefered_lft' and 'regen_advance' are unsigned, and it
looks like 'regen_advance' is not constrained to be less then 'ifp-
>prefered_lft'. If that happens the condition will (allways) evaluate
to false, there will be no temporary address regenaration,
'regen_count' will be untouched and the temporary address will never
expire...

... unless I missed something relevant, which is totally possible ;)

Otherwise I think we need to explicitly handle the 'regen_advance >
ifp->prefered_lft' condition possibly with something alike:

	unsigned long regen_advance = ifp->idev->cnf.regen_max_retry * //...
	
	regen_adavance = min(regen_advance, ifp->prefered_lft);
	if (age >= ifp->prefered_lft - regen_advance) { //...

Thanks,

Paolo


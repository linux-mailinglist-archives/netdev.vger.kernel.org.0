Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E711F6B6D2C
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 02:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCMBpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 21:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjCMBpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 21:45:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718028E60
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 18:45:18 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id k2so3395992pll.8
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 18:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678671918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l/teKmbpmy22WNMm+OqWLJZWRohd3TxS0uZa160A0cY=;
        b=F+VCdwhem3AtLBGzk6Okrf6Zy6oL5Z6C+/7vgBadUKPTsNDsA30SMYruShSlAlwNHX
         II5jNHy5803U9Hwse0+vAegpTgX8DkW90Qp94KLsRKfZ5XemKCtlaTDMTtuuYgEmmXrj
         jlHnS8xkoD8JTp99rpazvXhacH6Hq1mcpmvAtxLSuL1hfSV+fVcFpTg2bsPbdpPTeh81
         BNinyb+s9hISlBlWTDXgbR384gbC4ssBl+yibawAtnLcKxafdNZU1g4sOaJREK71hMpB
         pycx1wTz6Wy71WbPxkFNTMi4dHslDFMC9Fj9bUNtW/7fi4k3LBO4BPV6Ns+D+W8XQ5rs
         Kdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678671918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l/teKmbpmy22WNMm+OqWLJZWRohd3TxS0uZa160A0cY=;
        b=hQPrXnSoSke8sd0IT5qcPWTgADuWfJaeAh1fL7A9+mQic05Cvot4SbV7QYZTLZg33x
         E+mfSnlpkTwNc2O3qjErL14/1hmCzhDRyr4IuojTj2LhSWFrEnBPbvsZchnMQpxDLLKM
         72KD/4VlF0Vav/JtgCsf0oLnWQ4VQsDzFyWcD6YUtIlNMyMf/uDp7KgKklolNFQMDXQ4
         YOItyWxgTSfAnJepWnLmpVWF3Jhhqz77msF2LugaLiN89LD1p42At4Oz44P4RMJdltMi
         ZXZqJgrdtbYnIqOgILERyS0bvxKyK+ND3RY98VB7yD2fpkpGaoO6rXzFM1+5RViW4Du1
         KzEg==
X-Gm-Message-State: AO0yUKUS2RS2iFVMz+YILuMm1j24d//g7m8HANggofQ5Fr7ND7DJz/YH
        49uNea/tuzuDlm4+SVGwEBRMzQ==
X-Google-Smtp-Source: AK7set+q+08krZRAjcByYifACSLOl0MDeD5DF4BnW5+oOrRRvHA/IvtTJfkqgZPG9Y8jBiiQwO74SQ==
X-Received: by 2002:a17:903:485:b0:19e:898f:8815 with SMTP id jj5-20020a170903048500b0019e898f8815mr28089043plb.9.1678671917861;
        Sun, 12 Mar 2023 18:45:17 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f59-20020a17090a704100b0023b3a9fa603sm2750089pjk.55.2023.03.12.18.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 18:45:17 -0700 (PDT)
Date:   Sun, 12 Mar 2023 18:45:15 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        alexanderduyck@fb.com, roman.gushchin@linux.dev
Subject: Re: [RFC net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <20230312184515.5eabc8df@hermes.local>
In-Reply-To: <640e7e633acec_24c5ed2088c@willemb.c.googlers.com.notmuch>
References: <20230311050130.115138-1-kuba@kernel.org>
        <20230311082826.3d2050c9@hermes.local>
        <640e7e633acec_24c5ed2088c@willemb.c.googlers.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Mar 2023 21:37:39 -0400
Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:

> Stephen Hemminger wrote:
> > On Fri, 10 Mar 2023 21:01:28 -0800
> > Jakub Kicinski <kuba@kernel.org> wrote:
> >   
> > > A lot of drivers follow the same scheme to stop / start queues
> > > without introducing locks between xmit and NAPI tx completions.
> > > I'm guessing they all copy'n'paste each other's code.
> > > 
> > > Smaller drivers shy away from the scheme and introduce a lock
> > > which may cause deadlocks in netpoll.
> > > 
> > > Provide macros which encapsulate the necessary logic.  
> > 
> > Could any of these be inline functions instead for type safety?  
> 
> I suppose not because of the condition that is evaluated.

It is more that the condition needs to evaluated after some other
pre-conditions.

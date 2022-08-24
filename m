Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1945259F309
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbiHXFSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiHXFSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:18:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B97C757;
        Tue, 23 Aug 2022 22:18:10 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id c2so14717624plo.3;
        Tue, 23 Aug 2022 22:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc;
        bh=ZH78XGO0J8HWmCKamBQmSBalWkL1E63hN+valcwD+5g=;
        b=EEt9Iy6UDSrMZ9hJkDx6qdWc61/Y//XINQqWu/J9xilyWBTZZXZsd8/j/ju6UEHor6
         1u6XlfNsBTc8oAzyFQvHf3mMQK8b6V66zSsP+OkY+4D7u+duoQqiPJDXSK5ZqhC6VPPM
         ixh4SA6WQFdquJaKEg2uPaJuUhqAHkzzCXMAL4OlcEYOU0qxp56WKyLrZ0T26blBnCTr
         fNFfLRFK0n2r7+ZHpBTd+Z4hM/pfgNHTe87utJg0A9Rko/jsDy+SnZzvGWaFrN7yKlIT
         k2JNUrYW2K/q2xn0IYOBhQnUvbGiDNsPdTQdqHAd63a2zaQkdLwV7pa+wnfaRrg9mqkQ
         B/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc;
        bh=ZH78XGO0J8HWmCKamBQmSBalWkL1E63hN+valcwD+5g=;
        b=olOLL65BAoOZ+55sp8XiXZPZ0nMBnWWstzg5mZY+GOxr2THObxG/JYlE4cPD0aqC2p
         0ven95JDCIer7fn1DIwFLGwcdRDKJOYctHt6j8h5Wc1MBm9fr3dI06K/KwRBA22akQdS
         XjnuLB114STBGs1W1hQCxhXebtemZAQ7PARN4AZXUMME7KlSPFlalHlQAGXqBvPfcL90
         avvaBIRCrXR1mJLkEaEgD4IzMps9licz/nv2ZrR1A2pFEh7vPm2o/6jTessd3TfDUk0T
         gKFWbGst05qS0mH/wFf3mODL71chuz6qJb8ty+8zFqA7Gwx0V61visVl56O2IdbxXysF
         6ERw==
X-Gm-Message-State: ACgBeo17pv+DQSLI17L81pi5UYQTtplOxxeUaxwJc9reo3na6EXPk0n3
        LxQUy0q8863LiacMslUAEVU=
X-Google-Smtp-Source: AA6agR7/NcaT8gLe8FGl9t7Lw3Wj0RvMgDMQWTrv9F02AwxfhmqfF8R2Ng1UFkZaOpgH4VYG333z6g==
X-Received: by 2002:a17:90a:604e:b0:1fa:c865:eabb with SMTP id h14-20020a17090a604e00b001fac865eabbmr6686245pjm.46.1661318289950;
        Tue, 23 Aug 2022 22:18:09 -0700 (PDT)
Received: from localhost ([98.97.33.232])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b001725d542190sm11617763plg.181.2022.08.23.22.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 22:18:09 -0700 (PDT)
Date:   Tue, 23 Aug 2022 22:18:06 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>
Cc:     "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "alexandr.lobakin@intel.com" <alexandr.lobakin@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "ast@kernel.org" <ast@kernel.org>
Message-ID: <6305b48ebc40b_6d4fc2083@john.notmuch>
In-Reply-To: <ff1bb9e386d1231b5b44d645b8f9a02af8abdd79.camel@nvidia.com>
References: <20220413153015.453864-1-maciej.fijalkowski@intel.com>
 <f1eea2e9ca337e0c4e072bdd94a89859a4539c09.camel@nvidia.com>
 <93b8740b39267bc550a8f6e0077fb4772535c65e.camel@nvidia.com>
 <YwS41lA+mz0uUZVP@boxer>
 <ff1bb9e386d1231b5b44d645b8f9a02af8abdd79.camel@nvidia.com>
Subject: Re: [PATCH v2 bpf-next 00/14] xsk: stop NAPI Rx processing on full
 XSK RQ
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> On Tue, 2022-08-23 at 13:24 +0200, Maciej Fijalkowski wrote:
> > On Tue, Aug 23, 2022 at 09:49:43AM +0000, Maxim Mikityanskiy wrote:
> > > Anyone from Intel? Maciej, Bj=C3=B6rn, Magnus?
> > =

> > Hey Maxim,
> > =

> > how about keeping it simple and going with option 1? This behavior wa=
s
> > even proposed in the v1 submission of the patch set we're talking abo=
ut.
> =

> Yeah, I know it was the behavior in v1. It was me who suggested not
> dropping that packet, and I didn't realize back then that it had this
> undesired side effect - sorry for that!

Just want to reiterate what was said originally, you'll definately confus=
e
our XDP programs if they ever saw the same pkt twice. It would confuse
metrics and any "tap" and so on.

> =

> Option 1 sounds good to me as the first remedy, we can start with that.=

> =

> However, it's not perfect: when NAPI and the application are pinned to
> the same core, if the fill ring is bigger than the RX ring (which makes=

> sense in case of multiple sockets on the same UMEM), the driver will
> constantly get into this condition, drop one packet, yield to
> userspace, the application will of course clean up the RX ring, but
> then the process will repeat.

Maybe dumb question haven't followed the entire thread or at least
don't recall it. Could you yield when you hit a high water mark at
some point before pkt drop?

> =

> That means, we'll always have a small percentage of packets dropped,
> which may trigger the congestion control algorithms on the other side,
> slowing down the TX to unacceptable speeds (because packet drops won't
> disappear after slowing down just a little).
> =

> Given the above, we may need a more complex solution for the long term.=

> What do you think?
> =

> Also, if the application uses poll(), this whole logic (either v1 or
> v2) seems not needed, because poll() returns to the application when
> something becomes available in the RX ring, but I guess the reason for
> adding it was that fantastic 78% performance improvement mentioned in
> the cover letter?
> =

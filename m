Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61BF6C4EE7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCVPFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbjCVPF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:05:29 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB8F637D3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:05:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id c4so11320064pfl.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1679497523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKWnR/HYvhGXd4ARena2GQjXIMMF0q42EJebfbikBt8=;
        b=3r8cOlBJE+KQpMXYMpfdCMWTWmC8sbDRkZ8gfWSa4npwrbxomLyXVEziJBEvsJndSC
         75gpdfzmxqoyGw61FRSkWe5tdhsNe4DwhqAt1cLqn38Y0sd4mAN5NGkswFYWWxQ9gHiO
         PiMjaZFhNxxET0pSq5r5+b/Ss45gWAjV1C4JtNOqqTWzVNuXpykBpTGlnGHemNjf59yT
         nPQggXKqnxk5WSYMcHYDY2ctiezBv6iJukmLRDdNhs6DNG/VBiSPEnRPJThBrs/AnhiW
         PaWWP7lGOARANtuz/j3PIi3RLPkAjaW7WKaL3sb7ourvWCo2Wcivl0OJHIymSD7C/DOA
         OvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679497523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKWnR/HYvhGXd4ARena2GQjXIMMF0q42EJebfbikBt8=;
        b=NRruh0zihQNicO6pE7pNStN2H4yq32LYc67XQpSmiFFWhvEae5Z2X8nY2bweTIkCpK
         H+5Uz2UEGIilGj6twGbmHCiN4UhlmNIRehdpaJ7nOMVbwmS/TXJ/ClTZ2P27u4MbR0B2
         TEPT4C19U1yMGdIpmnUaC9dDt9EpPZ9ALoLl+PZCJY1/MpyFxRMpH78wcQwTl9Mq9tLO
         hqMvG33bz10ZHkCr4OzCR8z3vfpKZ9owBvOG/XSdVmIlxsXU6d9+QJRj1DwUyxe7sf+p
         8hqZt0LqG9P6I3ty10NIcUEpyZj+og+6wSDpzh4AQVzGe2eF3OCSCceqG2OkSo6trMwr
         Tnsw==
X-Gm-Message-State: AO0yUKWp9ObAx3ZdbkRqPI1yUzVm+W2YG3tORuVv1vffl5uvlmUs3Saj
        hbUyYJ0TcHdE0nfxnPxed453TA==
X-Google-Smtp-Source: AK7set+S/ZKnS/aGxrCY8QDMG7mtuK0JbeJ9JfUmj0qzbTHeeQXhZFxIyqZcOTfnP4Hmpcf9E72ujw==
X-Received: by 2002:aa7:9f5a:0:b0:627:f0e5:6ea5 with SMTP id h26-20020aa79f5a000000b00627f0e56ea5mr3415990pfr.7.1679497522788;
        Wed, 22 Mar 2023 08:05:22 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id g11-20020aa7818b000000b005892ea4f092sm10506824pfi.95.2023.03.22.08.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 08:05:22 -0700 (PDT)
Date:   Wed, 22 Mar 2023 08:05:21 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, romieu@fr.zoreil.com
Subject: Re: [PATCH net-next v3] docs: networking: document NAPI
Message-ID: <20230322080521.0a4e152e@hermes.local>
In-Reply-To: <20230322053848.198452-1-kuba@kernel.org>
References: <20230322053848.198452-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 22:38:48 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Add basic documentation about NAPI. We can stop linking to the ancient
> doc on the LF wiki.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Link: https://lore.kernel.org/all/20230315223044.471002-1-kuba@kernel.org/
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Acked-by: Pavel Pisa <pisa@cmp.felk.cvut.cz> # for ctucanfd-driver.rst
> Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Will add more about interrupt triggering in later patch.

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>

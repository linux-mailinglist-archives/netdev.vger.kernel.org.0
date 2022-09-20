Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717AD5BE2B5
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbiITKKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiITKJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:09:39 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F835F12;
        Tue, 20 Sep 2022 03:09:33 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id e187so2608790ybh.10;
        Tue, 20 Sep 2022 03:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PCpH7XaOYZZ5Juyccnl2JBqJJq74rbofAcRfa5pnMW4=;
        b=F4XYTJfQTTCYoo4OMhB4Z/sqJL21Ik7naXfWjfZE+1h6DzFB/TwjLGDVcUsUzxJYda
         cvpra7dueS1+C9mRHZONpsH4XVQye02M/ra+Aaj99Q35PD9bkU8TW8TCmXb4dupck9Hf
         ochtIMPQmgu8BdMdXurxEfWPlCzve9N3mwYQZn8LfwkNpLcp0OKXwmWYxlXF+flA75z7
         OmzqElNNpVU1RNo3wBv1iWGHBcKcDb8EvtIQC99bTkFC8dtt0Miy51KNgQecOcrdgbiM
         /z695TTWwrQSfMsyvznICWZKW6T6209NBmftinqMOs5qkUaWMcKHm1uAj0xEeAQoXBs4
         Ap1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PCpH7XaOYZZ5Juyccnl2JBqJJq74rbofAcRfa5pnMW4=;
        b=aPLhlJpHP5wpwH2FaKsmTpHUxoge205KM1cdzhriioTpRRj+AeFN5Zi5afjzIoqx88
         pi8E/Zq+kOOHMXMEcuvdefR64cwqJO83kOlcRayyM3lEPtj0zoR1qaHqxwjZAczLkiqW
         nIYeIXGjKKtVxMA8hHy53sYbGzyOWze7twVd0zVKOA4qM+dQ7vicojK+cM93PHg0gHRj
         PdGQd17XgOYRNoJkVP3mfksdaDJ51ITnUuYbeGR9wuD5yMmT70J5xvgFweolbEmeelXC
         HALujvDvPs2l+Utc04P8RNL5oMWsqS0JeQodPCnwzQu3s2BvjCvv1cTa0CQsaMrNZFec
         GfSQ==
X-Gm-Message-State: ACrzQf3GH2sbeF15N5b2KZSAdQoE/NIk8wgFhCi0goXVQOoCN1G/5JrC
        y0LgxgcNJLvJhcHdd5vRD6lkNa1R7apYrDohdw==
X-Google-Smtp-Source: AMsMyM50NtaDEz5A0D4M1vNFW6JxYypfuV5AAHr+jWRcREN+1lqUX7N4PHDhd9mW8WHpIo5dJVZczYYVLyHeACCci3I=
X-Received: by 2002:a25:d0c7:0:b0:6af:218:1751 with SMTP id
 h190-20020a25d0c7000000b006af02181751mr5911218ybg.508.1663668572279; Tue, 20
 Sep 2022 03:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1663628505.git.jtoppins@redhat.com> <3cd65bdf26ba7b64c8ade801820562c426b90109.1663628505.git.jtoppins@redhat.com>
In-Reply-To: <3cd65bdf26ba7b64c8ade801820562c426b90109.1663628505.git.jtoppins@redhat.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Tue, 20 Sep 2022 12:08:56 +0200
Message-ID: <CAHn8xcnRXq95WB9YQW1JLgZtQ0ey0LedLKT=DYr025iyqjvhxw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bonding: fix NULL deref in bond_rr_gen_slave_id
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 1:09 AM Jonathan Toppins <jtoppins@redhat.com> wrote:
>
> Fix a NULL dereference of the struct bonding.rr_tx_counter member because
> if a bond is initially created with an initial mode != zero (Round Robin)
> the memory required for the counter is never created and when the mode is
> changed there is never any attempt to verify the memory is allocated upon
> switching modes.

Thanks for the fix and sorry for missing the mode change path in the
original patch.

Acked-by: Jussi Maki <joamaki@gmail.com>

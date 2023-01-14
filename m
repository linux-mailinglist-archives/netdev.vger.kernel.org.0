Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0B66ACDB
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjANRDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjANRDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:03:15 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8483A5EE
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:03:14 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so3528900pjg.4
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 09:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jAyU/yP68iqzJ2kud5jWM3/r3xGFbJxy3E5zhpASiXk=;
        b=1bYzDuSwEF8sC6arKe0YqrbMA6J3EfEW/C04T0UWsa8d0L4XdvHDVZ+qPOjUYt12HI
         62fR8CYVxwmNygVtvXtUkqLX8XVYLbUcSCfl8lwogQmT5jCN5/FcRGeeU+tXaV4t1ZOS
         tXARbY31A6jDA9bR2BW4xBXuwA8iZX2wakGP6xIq/Ny574J7h9MhV29xpM5T8rRKQtwj
         YXzzxOBnpJ9+kunGPi2xKNphqSlf8jwCWQx5VwgHEIBIKQz0vJ6Ng5lVttz0iyOP3dIL
         ETzK24z3U1/kBSFdwSEUKT9cBt6q9QIXAuJ1Ru1lYhegv2u35jt/07SK1wSLSCRNcSfJ
         JW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jAyU/yP68iqzJ2kud5jWM3/r3xGFbJxy3E5zhpASiXk=;
        b=0n9EPAh0U/a1bXsDI1h1RdHrb4izxYr2R0TKF6YTFm3TpcU3Of9AXdp82abSWf79sS
         N/tHrSP2/m1Y7xsLBQCO9Ccc9cgquMGK7WVMOlR0L4pIN2keEpWllG+1SP3VNjetCyz5
         t7U8ICd+OJtRFZcpo1kzmMTQSfv+fti/cSgeLGbEXhUf30XH5PMHllg3TlnPLnB23WKU
         5qGw35/2f2D23mRyBxRL4/ltJb5hKPZ64PU5tl+yJMmM6dPpaVHQMvY15Q/FRPhIL3Wo
         yANaOxlnDqT57/DLPilQ8m5zJ5ew3LloUGjV/mOY0aKdLNHzbNjEpegGtCWzF7Jnjfu+
         nDAw==
X-Gm-Message-State: AFqh2koAqZu1zcdFm7H9FySgO08z5/45cLNpjVMfk9DcQzT5PhI0QlsD
        gskVHkRUlG3zvtragBWMPtNaVg==
X-Google-Smtp-Source: AMrXdXu8cGMR28sq4pslDOt4lAwltyvm3apC7Hfe3MMnCIl1Y48kaQz/dBuc0vXaLVv+5Womauu9Dw==
X-Received: by 2002:a05:6a20:7d9c:b0:ad:2abb:5a5e with SMTP id v28-20020a056a207d9c00b000ad2abb5a5emr20047538pzj.61.1673715794358;
        Sat, 14 Jan 2023 09:03:14 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id m12-20020a634c4c000000b0047063eb4098sm12951484pgl.37.2023.01.14.09.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 09:03:14 -0800 (PST)
Date:   Sat, 14 Jan 2023 09:03:11 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
Message-ID: <20230114090311.1adf0176@hermes.local>
In-Reply-To: <CAM0EoMmw+uQuXkVZprspDbqtoQLGHEM0An0ogzD5bFdOJEqWXg@mail.gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
        <20230113034617.2767057-1-liuhangbin@gmail.com>
        <20230113034617.2767057-2-liuhangbin@gmail.com>
        <20230112203019.738d9744@hermes.local>
        <CAM0EoMmw+uQuXkVZprspDbqtoQLGHEM0An0ogzD5bFdOJEqWXg@mail.gmail.com>
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

On Sat, 14 Jan 2023 07:59:39 -0500
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> This is not really an error IMO (and therefore doesnt belong in
> stderr). If i send a request to add an
> entry and ask that it is installed both in the kernel as well as
> offloaded into h/w and half of that
> worked (example hardware rejected it for some reason) then the event
> generated (as observed by
> f.e. tc mon) will appear in TCA_EXT_WARN_MSG and the consumer of that
> event needs to see it
> if they are using the json format.
> 

Ok, but use lower case for JSON tag following existing conventions.

Note: json support in monitor mode is incomplete for many of the
commands bridge, ip, tc, devlink. It doesn't always generate valid JSON
yet.

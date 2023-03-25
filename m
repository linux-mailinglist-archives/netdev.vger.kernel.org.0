Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A996C90B2
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 21:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCYU1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 16:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCYU1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 16:27:16 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DEDD309;
        Sat, 25 Mar 2023 13:27:15 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-54184571389so98969267b3.4;
        Sat, 25 Mar 2023 13:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679776034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yaARY077DGnjU3AMHe5fgCo5++amI4FQb8ZE5IDsYAc=;
        b=h5ckjLzM/gsOYMB2o1KVFl+U62j30yLjyRzWHk1sd0MEce0kHq7gfxL1yRq53b5K6Q
         +WRxveJEzVme0KwaVCeSRrn9Zc/RzsFQjaWCVUqRDF7u9+Skt8bHEff7/Ar61RlAZjRE
         L0DcFL35miBoQyHakueOq0FaJUvTDXzlD5VIoarYRSqJQGudPqDhf+fOwAN4/tPK+Y3D
         Bf9LgGd4EsAnazRskSxcRr0LKkFkb8y7nKX+C9gJoT7by5RqWbIN4HTj2g6X06ggBfRS
         62S4GvTlsnYHcvHtGclgYtMKLAarmPyOzayC37S/4cKyKsIpOA4zKnb+/csKsIbfnEYv
         iA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679776034;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yaARY077DGnjU3AMHe5fgCo5++amI4FQb8ZE5IDsYAc=;
        b=QlJbJncYcaDR2wE8uzY3O7zXbj167gTubRGMJzZjIbCKR/Zj1vl1yyq5KDe9Dhy1v9
         yeCr+7PnKWh0d49XlV3BK6CzhnpemUgpbGK7bpbxLrG67wtoD4PYBYtGbBLQ+VfxC8/R
         4AQF5uQX3GS+9V2+9mMHqqO1RwCs+GD5Gf731PPk9aR3r/3nRtuq+3/F8OH4utzN+0EE
         gCrJUPEQFbXdLx79ugIvqR37DJBbr8RuF5Lb3vpnO1FkFy61Y6U2j9RjMZJs6Syv/BU1
         1IugOPBcTyZpBkmYljITu89hPvR/F6KtkwurLd6WVu12C84v0mPiCGPJNbDuVZ0SnXux
         KK2A==
X-Gm-Message-State: AAQBX9fIYTocIEX30Hkqk1NaXifHGHXK+lZGYasyp6JZnwFAqnRKGqB0
        WUsg5uh21FS9MNkxbmDxru1Aj2TeniQ=
X-Google-Smtp-Source: AKy350bGOOL5VNz6k930qO3lFsXus7958cH5hstezy5khSnFiQsScpsKMVYdaFzs2DlEupKcR7Gahg==
X-Received: by 2002:a81:590:0:b0:538:4364:ae9e with SMTP id 138-20020a810590000000b005384364ae9emr9966440ywf.15.1679776034339;
        Sat, 25 Mar 2023 13:27:14 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:8df5:425c:8318:af19])
        by smtp.gmail.com with ESMTPSA id i79-20020a816d52000000b00545a08184desm1141327ywc.110.2023.03.25.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Mar 2023 13:27:13 -0700 (PDT)
Date:   Sat, 25 Mar 2023 13:27:12 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net-next v3] sock_map: dump socket map id via diag
Message-ID: <ZB9ZIG9fgWKKHL17@pop-os.localdomain>
References: <20230319191913.61236-1-xiyou.wangcong@gmail.com>
 <CAKH8qBtoYREbbRaedAfv=cEv2a5gBEYLSLy2eqcMYvsN7sqE=Q@mail.gmail.com>
 <2b3b7e9c-8ed6-71b5-8002-beb5520334cc@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b3b7e9c-8ed6-71b5-8002-beb5520334cc@linux.dev>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 01:29:39PM -0700, Martin KaFai Lau wrote:
> On 3/20/23 11:13 AM, Stanislav Fomichev wrote:
> > One thing I still don't understand here: what is missing from the
> > socket iterators to implement this? Is it all the sk_psock_get magic?
> > I remember you dismissed Yonghong's suggestion on v1, but have you
> > actually tried it?
> would be useful to know what is missing to print the bpf map id without
> adding kernel code. There is new bpf_rdonly_cast() which will be useful here
> also.

So you don't consider eBPF code as kernel code, right? Interestingly
enough, eBPF code runs in kernel... and you still need to write eBPF
code. So what is the point of "without adding kernel code" here?

What is even more interesting is that even your own code does not agree
with you here, for example, you introduced INET_DIAG_SK_BPF_STORAGES, so
what was missing to print sk bpf storage without adding kernel code?

Thanks.

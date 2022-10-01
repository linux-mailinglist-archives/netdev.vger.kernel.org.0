Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D635F1EA4
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 20:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJASjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 14:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJASjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 14:39:11 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA53642CF
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 11:39:10 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id m130so7860200oif.6
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 11:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rA+fghK3k+PLpzDVyL9Ny4VliJzAu4+IWFvo9GmJ6xw=;
        b=d7o+vyJ7X1ju4WaROS9x/Dk9+LD70k3DYQoC/pwM5GhiBjq358Z165nCwqHsoy6n9+
         aL/hTEvBmHmKaZ6MlKGfEdPcP15C//lgxgMk5O4MO6bq7PPceZCiMgwm66LA3Q2b8KYX
         QhTc6IanLaIAkGd6kyXqMhtn03tt1y+RMnMiIRAOg4QssHOq2VcAcjhyx6vwBLRqnNLA
         KacwJJq/gBFNZwBcT8wvvgpdrV3fwfNnzGUXE17pVM6flxBgT+tnLxYLapBJIk3C99XJ
         Cg9bVQAfXki1U1hyJGZZCXDnJzBjFllws6V5QSiduGJ8K+bQvGSWGEWbXeTpNqq52fk0
         jPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rA+fghK3k+PLpzDVyL9Ny4VliJzAu4+IWFvo9GmJ6xw=;
        b=f/eXIk0WhqGZrkCzkN1kewZQo8PZDxaVw01TJ+3X0UA4dO4LftH202O4nbmSjYyDrc
         zb5FVkGjThoGdGaG9fP+9jbUIDKRPuUo6D3X3BSih9+a9XlBiHdv3a0eGvWCVQv8T5b5
         VGraTd9S1wpUfTAhvbImjCPytg+Hnq2cGJZooAs/iUQI6Ts0G1oFDu9UJPJ8D7igSdl+
         zmrbrMepRkHv1wLTjkesprGD/EuhVBILaV9dadX9YxYUJwI7t3Yyr0JyyowsVwIqTiKU
         MgvNg3iYFbGlVrl4jD50tRXvIT2NE1D1Tg1cfYzCVX3GXZexmL98O1lHGTkM4LJBhzIj
         el1w==
X-Gm-Message-State: ACrzQf2APbAdmPVoZsLTJhVt3/xAlTmbD0fAMt3kTChpgDxIhqbYhcAt
        VuK6XJKwi/QNtDT/xX6MCB4=
X-Google-Smtp-Source: AMsMyM4avtL4diOjtIEr4eire5ybCJeSj3k3H/OZIyg+9pmavKOHCFHpJ5bbai4wzq9QdntIMG2Veg==
X-Received: by 2002:a05:6808:1642:b0:351:62cc:1f67 with SMTP id az2-20020a056808164200b0035162cc1f67mr1565929oib.20.1664649549795;
        Sat, 01 Oct 2022 11:39:09 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:f611:6b35:aef:b96a])
        by smtp.gmail.com with ESMTPSA id by6-20020a056830608600b0065c477a9db9sm1337197otb.1.2022.10.01.11.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 11:39:09 -0700 (PDT)
Date:   Sat, 1 Oct 2022 11:39:07 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH (repost) net-next] sched: add extack for tfilter_notify
Message-ID: <YziJS3gQopAInPXw@pop-os.localdomain>
References: <20220929033505.457172-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929033505.457172-1-liuhangbin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:35:05AM +0800, Hangbin Liu wrote:
> In commit 81c7288b170a ("sched: cls: enable verbose logging") Marcelo
> made cls could log verbose info for offloading failures, which helps
> improving Open vSwitch debuggability when using flower offloading.
> 
> It would also be helpful if "tc monitor" could log this message, as it
> doesn't require vswitchd log level adjusment. Let's add the extack message
> in tfilter_notify so the monitor program could receive the failures.
> e.g.
> 

I don't think tc monitor is supposed to carry any error messages, it
only serves the purpose for monitoring control path events.

Thanks.

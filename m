Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27B5A5F51F0
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 11:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiJEJpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 05:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiJEJpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 05:45:51 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338916D559;
        Wed,  5 Oct 2022 02:45:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j7so19742925wrr.3;
        Wed, 05 Oct 2022 02:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xqiOncpo4EmYHnPvTon8bj9CJqRmv/YCx9Oryac7/2o=;
        b=a493L+ZZ6XTA9laUUE8+LH5OPTvOoNNgSIUKSn55IIrE/5jfM4v63cP1830W/hisSq
         t3Wf6A9xXjXIZJRtW5ydnJLt5UUQJmkhekJE1m/oBvLwNtcwLXQI6Y73UJ2B/WG1SHOW
         ce2mZa+9ZzRdB+wuNvHSoSp/3lHApucBcxkAyOT+TawkyjDkJ34Pq/mX2dxWDyhwntjr
         79j6AXjC7UAdAvy+umVPR6LvPdWqM8tbSQKfZDh250L3Fu6GrBy6rCWYjWRma3krvPHh
         EJPVqzcPI0UofumNGjvBkZRn1WH0SCdRRn0Pri9ZtH0lWQ/8OlNfaO1bGKv0UzbFSCRV
         eZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqiOncpo4EmYHnPvTon8bj9CJqRmv/YCx9Oryac7/2o=;
        b=FkDlbA3RyDcWgZF4viYCBz/Bapk8vwxPry1Fa5oBEQcWrJBmVhN9dmP6HE69umBI45
         UrPk3aOyx+z2A63OqHYLhANS5Dfmo+RJJEh47srmWmHMd26P8epqth4UlOVjt3xYirVy
         u+cayKfRG0jIIecq00le2FCao8AYisUU0O/QQElBO6rb4ljTqF+lCmIv9s65EKMabJoT
         CEDFJolTP2SjCusQCaZHDLZyXjqKXno2tJLsFYTf4z6AT4NkS7XjByBvnkra+SvTdbCW
         s5NeWAtTTtwUGpWitLfBomc2dtV+MpVqq9KJBkjjOLcrBXVPOKasul8a1hHBgtVhHvVv
         6t3A==
X-Gm-Message-State: ACrzQf38gL60tuz9NOBgMfrSdkG9vYWsP/PPBtDBhtKezIRFBtvtICfU
        eRmhLJxRyLWw0f9uckx6Sjk=
X-Google-Smtp-Source: AMsMyM7DBli1QgJd6MpqsWZ4TQHSX1VGeU+HHdyrVZsAS7NSZyWIaHbTqumWe8zUClGvIU5e0d0bBA==
X-Received: by 2002:a05:6000:2ce:b0:22a:f2dc:1531 with SMTP id o14-20020a05600002ce00b0022af2dc1531mr19598189wry.370.1664963148587;
        Wed, 05 Oct 2022 02:45:48 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id j2-20020adfd202000000b002285f73f11dsm18702667wrh.81.2022.10.05.02.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 02:45:48 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 5 Oct 2022 11:45:46 +0200
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>, Daniel Xu <dxu@dxuuu.xyz>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: WARN: multiple IDs found for 'nf_conn': 92168, 117897 - using
 92168
Message-ID: <Yz1SSlzZQhVtl1oS@krava>
References: <20221003190545.6b7c7aba@kernel.org>
 <20221003214941.6f6ea10d@kernel.org>
 <YzvV0CFSi9KvXVlG@krava>
 <20221004072522.319cd826@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004072522.319cd826@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 07:25:22AM -0700, Jakub Kicinski wrote:
> On Tue, 4 Oct 2022 08:42:24 +0200 Jiri Olsa wrote:
> > I did not see that before, could you please share your config?
> 
> allmodconfig

I compiled linux-next with that and can't see that,
any other hint (apart the old gcc) about your setup?

jirka

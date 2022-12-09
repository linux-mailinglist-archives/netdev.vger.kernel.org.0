Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92695647FCB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbiLIJCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiLIJCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:02:30 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC1FF6176C
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:02:25 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so9994759ejc.4
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 01:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5euuVHPAvLnarckzHixOo1NpKesk/61tSgokTP8w0Fw=;
        b=QffKJ/27mBhR5CqOXbTSgciNc6psPAALeUVvZStejt/ZBsxKTcbQFlJphOk72K4H63
         48x10739t8+9hjXybN4d2vIXkBvmWtG32aLf62rVQAF2kcuDIWAFOehFSudTo15/FPRl
         kPHQPTwSRePcVKw58h/Rid1AXyQU1FT8/Ct5K95RGOXgyDc82Aaq8HRvoz1UJiKqLEYb
         veGwvFU4D40p76+Hd8MBZaM/d13V1h23/BXIUalR1l2Ql/9G3tueNK/ddXeeKMgdmA28
         M/Ak6o2SHkGJkc63FLli/qsvqQksmco6doIH53w+9lo8jHPZq5DnuhD2LMh6cfeuwdYY
         SFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5euuVHPAvLnarckzHixOo1NpKesk/61tSgokTP8w0Fw=;
        b=VE/8y4PcI8AfxeX9af49o2Cp/hPwWYbDdoHz3fJmhVu+ci8fg3dH2W+IfCR5nt480M
         Hn4Ooxyt0Vc5giyxKDXhn/t26kDmyNRwd2/bBW+yQ/kPLJCNoFgdvPmb2abWk7UA6lZQ
         yHLh6EVbDNxQLGk15cPpnfqDUbVTldHWZiibYGLBF9+SCIi3k6MQR/p1CCuYFg7QZEAN
         6YAIHZrtugwePMq29wNUmZk0WVvSjGItgFZ5c9PkTOw0L0pzCC/toh6qQ6cRTSxVE4UV
         ree6pIaQVOYpFO17FH152uOekOKkqM+g9Lt90ynodQLCeEwC+mZrZGgiha3c6dZv0TWM
         rbCA==
X-Gm-Message-State: ANoB5plBZudWgRHsDgXbbCS9z6/il5Ua5+3Iy15mWX9dUVVnjZVvzYuS
        vdDXHS2fArQvQ5EVNiq7W4CvHA==
X-Google-Smtp-Source: AA0mqf6GOTFv5IV0/42dgZBn3kGK8rll3sGJHUbjVm0CyU97gvRNbV8p78NYX8FE0+2S+bGQgAcO4A==
X-Received: by 2002:a17:906:8c9:b0:7c1:ad6:638a with SMTP id o9-20020a17090608c900b007c10ad6638amr4047663eje.17.1670576544391;
        Fri, 09 Dec 2022 01:02:24 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j6-20020a170906830600b007c10fe64c5dsm318089ejx.86.2022.12.09.01.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 01:02:23 -0800 (PST)
Date:   Fri, 9 Dec 2022 10:02:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     yang.yang29@zte.com.cn
Cc:     christopher.lee@cspi.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xu.panda@zte.com.cn
Subject: Re: [PATCH net-next v2] myri10ge: use strscpy() to instead of
 strncpy()
Message-ID: <Y5L5nlf+dXVYgUTt@nanopsycho>
References: <202212091537298224990@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202212091537298224990@zte.com.cn>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 08:37:29AM CET, yang.yang29@zte.com.cn wrote:
>From: Xu Panda <xu.panda@zte.com.cn>
>
>The implementation of strscpy() is more robust and safer.
>That's now the recommended way to copy NUL terminated strings.
>
>Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
>Signed-off-by: Yang Yang <yang.yang29@zte.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D9C51886B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiECPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiECPZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:25:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D14ED13CC8
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 08:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651591338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p/leNrelgl/HZAWXeORX5HQyPeyTuqazjrfynX0fQ1U=;
        b=Sm9hOV9KvjxrJEkxrrhKaMJEaYaUcukeSgpLYWS98C2ByeETqh+sdYKRqCFaINZvWSedEz
        FCYXUVqDMdaOA0vAEoG/oRtrp+ATt2sgF9BbIiS0VDYcTwOhXtOzhgvcqc9p18bHhVNolj
        IZYC0wC95s0ejgMyjU03NEKd/0hL3v8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-QW7Sy5TNNLmTWfFbGi6yIQ-1; Tue, 03 May 2022 11:22:03 -0400
X-MC-Unique: QW7Sy5TNNLmTWfFbGi6yIQ-1
Received: by mail-lf1-f72.google.com with SMTP id br16-20020a056512401000b004739cf51722so2906859lfb.6
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 08:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=p/leNrelgl/HZAWXeORX5HQyPeyTuqazjrfynX0fQ1U=;
        b=bniNM6wWwzbdT+cggz5BQZuZ0wTvXWVixZgAMtYq2O/baTkLEjn6FGTLcxBbKF0nkB
         KsbcRtG7hlse5u618ZN28reKwXFx/N27ZQXYBrmN+Qwq3qkwJUFp4M+gHYicwCdxuvFi
         VIDwuTSxKYShI95Vb1CQduie1m4IzUu+HwoEMieT8zISNPCif1YkiXmedCVE5QLrJ5qx
         ML1U98gicFUzrPMtI2PwBaAy8ebmwiKGQK9rYWdkY/CBijBeG5pNjrFmkSto6ObrhU/1
         Rl3ujwzk9i11+amvwCoTMGqSE2M8jU9FCBjBkARMAtM0dP3KqBQx0b/yr+njcu/m/Fua
         dfaQ==
X-Gm-Message-State: AOAM532FmO/CiA7nSewRAMPY9XUolr5pSsU//CLVeL1ta833yumhreCw
        jhJK/rRv6ZWCTqIwe/Z87AYx4hSlz7KyIk1if28Gl+CE38c2UNqekBYWlZubcdJkX+VLye6NV2+
        9r8gDD780nDQ07OND
X-Received: by 2002:a5d:598e:0:b0:20c:57ef:6083 with SMTP id n14-20020a5d598e000000b0020c57ef6083mr10651673wri.457.1651578178808;
        Tue, 03 May 2022 04:42:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFCTj/hW6a3/q2+UxX6KyNmoEgzZ1BzSWF1KPdBOLjK9gFp9tyUKQVn/9tXOms/YvMyC236A==
X-Received: by 2002:a5d:598e:0:b0:20c:57ef:6083 with SMTP id n14-20020a5d598e000000b0020c57ef6083mr10651656wri.457.1651578178588;
        Tue, 03 May 2022 04:42:58 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id e11-20020a05600c4e4b00b003942a244f36sm1554831wmq.15.2022.05.03.04.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 04:42:58 -0700 (PDT)
Message-ID: <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
From:   Paolo Abeni <pabeni@redhat.com>
To:     Carlos Fernansez <carlos.escuin@gmail.com>
Cc:     carlos.fernandez@technica-enineering.de,
        Carlos Fernandez <carlos.fernandez@technica-engineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 03 May 2022 13:42:56 +0200
In-Reply-To: <20220502121837.22794-1-carlos.escuin@gmail.com>
References: <XPN copy to MACSec context>
         <20220502121837.22794-1-carlos.escuin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-02 at 14:18 +0200, Carlos Fernansez wrote:
> From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> 
> Salt and KeyId copied to offloading context.
> 
> If not, offloaded phys cannot work with XPN
> 
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

This looks like a bugfix, could you please provide a relevant 'Fixes'
tag? (in a v2).

Additionally could you please expand the commit message a bit?

Thanks!

Paolo



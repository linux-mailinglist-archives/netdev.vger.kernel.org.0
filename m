Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340D26DF6CB
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDLNRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 09:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjDLNR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 09:17:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894BD7AA2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:17:02 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 41be03b00d2f7-517c5c2336eso517686a12.2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 06:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681305386; x=1683897386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCy4hx48/4HLWENErS4QKbI0MRaB5YL7EWKm3hJQFU0=;
        b=XRQVI60iNFz9i7N6p4V36IIy2HY41i87pENcobMczh4LDAFpMVcJy8hfgNFgcpCMlQ
         YqdeA9/VeOCjNfpT4txceyA0aNniX1nY6pLaNw3WPi9ri+C1qJyK+eTtyw/cVo57W/ux
         uJJ1ZevVL87HSK2ybapgjef9ImhAYJXd1OB+OlE/Unj+MipigQaCqc8CbxMpIglWr76i
         9X+azpe6oP0RlumITv0lC14GOFU8GHTcvRuRB93zW34PjB3J1dpt8Pn4g063U9znD+7K
         URR2Lqc5JgDmzfP4Asqg++Vk8j4jyCoYasIWWj7+pvPifHDmDebmwq2Is0CAjP7VroZa
         HbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681305386; x=1683897386;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCy4hx48/4HLWENErS4QKbI0MRaB5YL7EWKm3hJQFU0=;
        b=leOIDx74Sy7DFTu6kxs7cjCoulqeC9LYVolj4GFnvYQiPCBuM0ghy7SxToqxP+mzmG
         kQe++5iexefCeyWwhSZXP8f9moWH+RfrOg+eY4Nl3qWRWtjIshSRUAkkmpaE2QJfOd2H
         fmxrm3zVGk+Ep2pd+hPHOAy15Swhovdz6rQ/TFetLTBWprQdWnPbKbF5bsd09mnjkoCP
         Yr9dUArcAiq+0YYBQ4/UnBfdK+4ZcQ55onl1hvqlzKjxRR9m2ye/U8NTh7FmozIrs9eb
         7N8+X2UgV09gqx5v67SxZX39GftwFGh0MhIeOYbF7KdgSZzuoTItyFfpLoRbE0xaJ7dG
         NxJw==
X-Gm-Message-State: AAQBX9c456zd/rVa+lhKdNxXIbbpiUEhgEuHR64VZ0wqY14KEH6t0Jix
        +AiJCENz8w6comjjdLH5nyY=
X-Google-Smtp-Source: AKy350bxYdp2EVHOb/7V76AfxxuW5vZHeLZOgSkltRRNgOFy0rdj8G3JaV3DgnTFPInSJ0CnwuKIew==
X-Received: by 2002:aa7:9529:0:b0:639:28de:a91e with SMTP id c9-20020aa79529000000b0063928dea91emr9381291pfp.17.1681305386146;
        Wed, 12 Apr 2023 06:16:26 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7826:7100:99c4:7575:f7e2:a105])
        by smtp.gmail.com with ESMTPSA id g15-20020aa7818f000000b0062d7c0dc4f2sm11719611pfi.79.2023.04.12.06.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:16:24 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:16:20 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Martin Willi <martin@strongswan.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDavJCLutKC/+oHZ@Laptop-X1>
References: <20230411074319.24133-1-martin@strongswan.org>
 <ZDUtwwNBLfDuo9dq@Laptop-X1>
 <ec3a6209cdb2bc42e3af457fcee92de92eae9e6d.camel@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec3a6209cdb2bc42e3af457fcee92de92eae9e6d.camel@strongswan.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 11:21:33AM +0200, Martin Willi wrote:
> Hi,
> 
> > > Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> > > Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> > > Signed-off-by: Martin Willi <martin@strongswan.org>
> > 
> > Not sure if the Fixes tag should be
> > 1d997f101307 ("rtnetlink: pass netlink message header and portid to rtnl_configure_link()")
> 
> While this one adds the infrastructure, the discussed issue manifests

Yes

> only with the two commits above. Anyway, I'm fine with either, let me
> know if I shall change it.

In my understanding the above 2 commits only pass netlink header to
rtnl_configure_link. The question code in 1d997f101307 didn't check if
NLM_F_ECHO is honoured, as your commit pointed.

Thanks
Hangbin

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042D054C06A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352335AbiFODyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354844AbiFODxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:53:45 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F0B532DA
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:53:02 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id y196so10297012pfb.6
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 20:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fJvfW3+fdLdU0zNbOByoXUGZxcz1O50skA4yxYWws5g=;
        b=oA5oAG0HZ0YdPfiPshglgX94ik3nFrMVFM/uRvFs5+2CjpXjyRhafXkBf7Kc2TxRGD
         TPoVGyREugq2NFnV9c7NNP9ulwNe+Ck46dvmbI2X9jTqnBX+HKeDAUUY1GF+lQELi/vb
         YmQQ3YmZ43UdjkE3P+1hY4Q1L2dRvKtzuh5rpug2fo0q+6085Uyh1cm+AW4PJFau0fFM
         Ac2GVsh5FxdGDv6TJdQ/0WKTBG4bZZwh3pLvoDMZ0LFPBHtgSWC2z928N8DIGp7Mb+ui
         cTEsUmSodtX/tQC4Xob/vYNSxW9vVL15gLJWdiLlHn55+m0w1wgLIm3j3VkEQ4F/BD2q
         PdhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fJvfW3+fdLdU0zNbOByoXUGZxcz1O50skA4yxYWws5g=;
        b=BFzAadCYbBd/IR3WYDXm6CU84HIvfq/hLcyL0tj0S/PMvK8whilrAg4PeW4z1J95uU
         WtZrEXPivnSF5YW8YdUf3KkH4R+DvwGskDjjkdZGkYJExXi5ehDmnSyyxicOUdBYw6rg
         Ee406d2PZr3EmNJwrkdpx7iEVWJjOWC6FWTTMKhpZg+jBRUsCrGSu/gIPp0sVpehalcg
         QxmrmOX6yTp7yVM1u19Wzg9OkdW4rdkOmfmGNf6rSt3VmPsuzFjxO/wpPcNmvR562+aX
         KUKqNmzCU10BxoSdXQVHDz+0p2Or7fIiyxMTldoP749wbVQRuiot4rc5c+U/YwvWfnWX
         i9rw==
X-Gm-Message-State: AOAM532c1uNlwxa6HYGqLWYCXk0MznquNJj8I9lcygOUmCYU+xnwvNtH
        Osj4hBy6we8HsNlyJDp2v9u3YA==
X-Google-Smtp-Source: ABdhPJwHkiTBcNVMttUoTnXTjP0mSMbs76s5cP4sTjaAEpQT/GrCk1cg0f82rAcFw7pWl6lrtbe3tQ==
X-Received: by 2002:a05:6a00:1690:b0:517:cc9e:3e2d with SMTP id k16-20020a056a00169000b00517cc9e3e2dmr7889419pfc.0.1655265182190;
        Tue, 14 Jun 2022 20:53:02 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y17-20020a170902d65100b00166496ba268sm8034482plh.285.2022.06.14.20.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 20:53:01 -0700 (PDT)
Date:   Tue, 14 Jun 2022 20:52:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Message-ID: <20220614205258.500bade8@hermes.local>
In-Reply-To: <20220615032934.2057120-1-liuhangbin@gmail.com>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Jun 2022 11:29:34 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
> index 5a6f44455b95..41b3244747fa 100644
> --- a/drivers/net/bonding/bond_netlink.c
> +++ b/drivers/net/bonding/bond_netlink.c
> @@ -27,6 +27,7 @@ static size_t bond_get_slave_size(const struct net_device *bond_dev,
>  		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_AGGREGATOR_ID */
>  		nla_total_size(sizeof(u8)) +	/* IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE */
>  		nla_total_size(sizeof(u16)) +	/* IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE */
> +		nla_total_size(sizeof(s32)) +	/* IFLA_BOND_SLAVE_PRIO */
>  		0;
>  }

Why the choice to make it signed? It would be clearer as unsigned value.
Also, using full 32 bits seems like overkill.

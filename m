Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E32D57F7AA
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 01:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiGXXSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 19:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiGXXSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 19:18:48 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14A5260A;
        Sun, 24 Jul 2022 16:18:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id i13so2815588edj.11;
        Sun, 24 Jul 2022 16:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xoLvqz4wndADrX4G7bqgitF9BUiRD07x3kH2BZou3m0=;
        b=SqxGpXV0Xduj/3Hc0JkwpjdzSv2booKmQw8OZmqflUT/dkQkIzK6Hs/soHPk/Tv0eD
         BAx/ss3m+yqBseCbRdd0XxIalE/fnfAZVdYg1crf73aAd5hctrqKCNyV9qbMZv6CumQK
         iz27l60GIcInQb5QjTXhobU3zAkf0GsYlrp2hVyzCN/qztafCY978ISz4muGL7fY/zUT
         XTOOlX/frG3DW9VGCJWMWzCjRN3lggFYtYSmCANFBHfjJVhit04L2APj4GikfS+0YQSf
         w8fONa1kNG6doiCOR42jPsSyK6nicUKHXIuJXURIuP9khx1NhvNky0FPGBlzsuml7eFK
         cIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xoLvqz4wndADrX4G7bqgitF9BUiRD07x3kH2BZou3m0=;
        b=KGzLaobfBnvBSq7VpVkI4NbqUBJjeNT1ryCVonZBIQvEIMJOqt1KvDDz1YXedf06ZI
         NAW8BmHTwuukd5/t7w5QfV1IP93N3oFHc0sxaWlsx9rYviwUyZJS1AhLeAn5i4c1A/zj
         KduiIdCy6oi3VK8UrSvuxZFJTCuXs37GJI1z8IIROcFNnjvmHT7UJwE1vNbFe0V11weK
         tT0PYoHCx5R3MDpiCfZtRkeEKH4HuvK+3s7iMHIz77bPXY1JqJ7NahdkDh//yKaL+ZeI
         tM0Q+5WVFYa7qzHuF1w+KW3bill22dciOohI5ZcB9T8BdwopeppYm4a1fw8HP70Xirsc
         Le3g==
X-Gm-Message-State: AJIora9W0zYxPg/6weha+MYrtVvArCUsh8lNq+ypiqf3GxYqacfvWF+v
        FILVbbXkxQHFmWaKtc0FjU8=
X-Google-Smtp-Source: AGRyM1sufXVHukNAOeXxXT2VRRz2yVx0+1a3gwufLZRpLnS1O4d/eQ3/AOH4gHcuoqgY2tGxsUXuig==
X-Received: by 2002:a05:6402:444c:b0:43b:d375:e932 with SMTP id o12-20020a056402444c00b0043bd375e932mr10544815edb.399.1658704726466;
        Sun, 24 Jul 2022 16:18:46 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id i12-20020a170906090c00b0072af56103casm4617690ejd.220.2022.07.24.16.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 16:18:45 -0700 (PDT)
Date:   Mon, 25 Jul 2022 02:18:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH v3 01/14] net: dsa: qca8k: cache match data to
 speed up access
Message-ID: <20220724231843.kokvexqptpj4eaao@skbuf>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-1-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220723141845.10570-2-ansuelsmth@gmail.com>
 <20220724223031.2ceczkbov6bcgrtq@skbuf>
 <62ddce96.1c69fb81.fdc52.a203@mx.google.com>
 <20220724230626.rzynvd2pxdcd2z3r@skbuf>
 <62ddd221.1c69fb81.95457.a4ee@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ddd221.1c69fb81.95457.a4ee@mx.google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 10:42:20PM +0200, Christian Marangi wrote:
> Sure, it was just a stupid idea to set everything not strictly neeeded
> only after verifying that we have a correct switch... But it doesn't
> make sense as qca8k_priv is freed anyway if that's the case.

I don't understand what you're saying. With your proposed logic,
of_device_get_match_data() will be called anyway in qca8k_read_switch_id(),
and if the switch id is valid, it will be called once more in qca8k_sw_probe().
With my proposed logic, of_device_get_match_data() will be called exactly
once, to populate priv->info *before* the first instance of when it's
going to be needed.

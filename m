Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8517C57A605
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiGSSDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239796AbiGSSDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:03:44 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4AD57227;
        Tue, 19 Jul 2022 11:03:44 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id h145so12461596iof.9;
        Tue, 19 Jul 2022 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fPFFe5wctLeTDhb0gLdCJgELQgOsbugIuLTUZPTp1bA=;
        b=p+MaZnvhMqpzyLmpxQ2pmhFgNvd+cPnc/JFkL6mPhyxR2vi4jPsQH1dypW+VHqTpF+
         fgCdq+5mmHjOpOVH8ZrNpOGCoNwd1rWwsNjiSpUHtqcdpZlj8Mu4ooYhePzYicS38QGV
         olTp4c6PpPngYKzh1EWEOOmDptInqR9vs5A25kEZu+wVJdMQsMnQ1URnXPjp/0LGMUz2
         FNRRjWeMuCx6UjIuCeVpXYGFsaL3mhCvE6G2EYxLAuVgLLl+GkbGd85W7RSTqFYBzeij
         WA9T0J/bvfu6HcPM+RWZRXfPlP6Q18fpxgKBVt9l/322kv39NSojfeFuIHGG0EK9GDSg
         SMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fPFFe5wctLeTDhb0gLdCJgELQgOsbugIuLTUZPTp1bA=;
        b=UVaU4MS1vDlD13MF1oMf9Me7ur6fm4h88jk3KWAhZ95kMn2LA0N31bytP8mgOYHrQP
         +WySxH2pNxusS39Cc3hGx0vFCcak/7azhExDN46lKUWYRdp0hDjG1etdKNGLw5TnytkD
         hnjfh2flWtHj8ihg0Esq5ZxEWN69ZbX5dBF9rF3IAUtbD9QH8VjyiVMHABAYsTSzxoBn
         tqPOLmrda76w+1Df1sdMmUGrUR+rBKGMFuOx1ZAC1ybtJ8xIo+k8Kb07zzMvAmu0zWuU
         6suBGrACNqMhgAmQPNp9yHUUIlnpm5Eksxd1VX+gYujZaAXVu6xI2MayHQyn3hybLDp9
         DCKQ==
X-Gm-Message-State: AJIora8OZ5VYHjS2Ut/XfN9El70z1EEgQCA3rj6wn2vzWOtzFvH+CJUl
        wr6R918m61REdcXbDMv6Cw0=
X-Google-Smtp-Source: AGRyM1s88nd19RIkPv+KH3rbuBZREMEKj+2iuX6YpFnTzr8fsECStsYXQUt4+cy12Ja+AdXFF72i5A==
X-Received: by 2002:a02:ad12:0:b0:33f:4663:e784 with SMTP id s18-20020a02ad12000000b0033f4663e784mr18211597jan.29.1658253823519;
        Tue, 19 Jul 2022 11:03:43 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a884:659b:a795:3b16? ([2601:282:800:dc80:a884:659b:a795:3b16])
        by smtp.googlemail.com with ESMTPSA id n2-20020a056e0208e200b002dcdbb4f7b7sm3616146ilt.24.2022.07.19.11.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:03:43 -0700 (PDT)
Message-ID: <c66afab7-732c-c68e-cc53-7425d92df42b@gmail.com>
Date:   Tue, 19 Jul 2022 12:03:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net] mlxsw: spectrum_router: Fix IPv4 nexthop gateway
 indication
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        nicolas.dichtel@6wind.com, mlxsw@nvidia.com, stable@vger.kernel.org
References: <20220719122626.2276880-1-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220719122626.2276880-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/22 6:26 AM, Ido Schimmel wrote:
> mlxsw needs to distinguish nexthops with a gateway from connected
> nexthops in order to write the former to the adjacency table of the
> device. The check used to rely on the fact that nexthops with a gateway
> have a 'link' scope whereas connected nexthops have a 'host' scope. This
> is no longer correct after commit 747c14307214 ("ip: fix dflt addr
> selection for connected nexthop").
> 
> Fix that by instead checking the address family of the gateway IP. This
> is a more direct way and also consistent with the IPv6 counterpart in
> mlxsw_sp_rt6_is_gateway().
> 
> Cc: stable@vger.kernel.org
> Fixes: 747c14307214 ("ip: fix dflt addr selection for connected nexthop")
> Fixes: 597cfe4fc339 ("nexthop: Add support for IPv4 nexthops")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>
> ---
> Copied stable since Nicolas' patch has stable copied and I don't want
> stable trees to have his patch, but not mine. To make it clear how far
> this patch needs to be backported, I have included the same Fixes tag as
> him.
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



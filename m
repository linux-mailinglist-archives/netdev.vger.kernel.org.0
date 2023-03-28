Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA66CB553
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjC1EJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjC1EJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:09:37 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7C0118
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:09:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id l27so10758382wrb.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 21:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679976575;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DH0iGx5moWKFh056/Hl5xR0TW5IqMBgz/n6dxgYD6nE=;
        b=orbz5AeK7pzwYIt6+aIeVu3RJxNeVvCC2QHKUx60mqCff/CleEjWPfj3J3pL29JHkT
         7FrvsgfT1MpcmgC+x3Fg3PiloXrvzDeu1UXq4hkMteGMUjQ9HiwNg/T8GNeQ+unGBzPV
         p3lWIe0gN5XHMrLBzWaPWpTajfgJq0o6fmnxdZvthuuoykY5LVUvpJDMFGsmt+gV9kXS
         RrmR7lD9nD4VaxD3VmxVILiQcpq3OWazH/R6gRomyWlbt8sEwW9Y7tRgiILoSIwBvZjL
         W7ne0ajF71oLxAGzrR4NsUnZQZB9sZO1T3dZP1YOafnpq07/JiS177vC9es52DR5JhW5
         v2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679976575;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DH0iGx5moWKFh056/Hl5xR0TW5IqMBgz/n6dxgYD6nE=;
        b=SaRkGLgOhap16XNkIrgFFM1GzOtkpnxqS6LySS8pkUnKVfGHS+GEwfZ3jIsFVyEfzD
         0myxchMHv6u3UhNBybLakJQ8mwNfxN84Sqw/1gqBUDDnXZaf2ppeFPHdGGoZmh+E9Dem
         nd7jxwCKiHvU3jE/Pc3Fwfpum5ScnKTC2D2M0hXCFleIhPYGED/3aaoCW9JRE7Ai2CjZ
         X/Ec61OLuyyIoezG5XtKvz9FPwtf4lK1PUHDACWyXk7WNCizkqt9PDShw6REvJnPDJzc
         1IFf9uXtKN4AhEbh/ap2dU+PXnrbf4TQ/Ur0NSzng99zudtkZOR+Bg/3ojeBDlIhqneY
         Sm7Q==
X-Gm-Message-State: AAQBX9c1t+ENTzy/HujXBDlChQAeMoFSecrDO44qOqo67gll1VzJ7VaZ
        lfffF72UigXrW3zm156GEcM=
X-Google-Smtp-Source: AKy350ay2zjh1vt4kie0ZXl6rt24pIPTCOZSylUh6pzkQt5FpBzsDRqmR1u+u4r+Vn575TjLu9RCVQ==
X-Received: by 2002:a5d:53c8:0:b0:2dd:2a04:b73f with SMTP id a8-20020a5d53c8000000b002dd2a04b73fmr9329119wrw.49.1679976575361;
        Mon, 27 Mar 2023 21:09:35 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id l12-20020adfe9cc000000b002cea8e3bd54sm26499494wrn.53.2023.03.27.21.09.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 21:09:35 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 2/4] sfc: allow insertion of filters for
 unicast PTP
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Yalin Li <yalli@redhat.com>
References: <20230327105755.13949-1-ihuguet@redhat.com>
 <20230327105755.13949-3-ihuguet@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1b5f09c6-13e5-318f-0764-83dceaf52442@gmail.com>
Date:   Tue, 28 Mar 2023 05:09:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230327105755.13949-3-ihuguet@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 11:57, Íñigo Huguet wrote:
> Add a second list for unicast filters and generalize the
> efx_ptp_insert/remove_filters functions to allow acting in any of the 2
> lists.
> 
> No filters for unicast are inserted yet. That will be done in the next
> patch.
> 
> The reason to use 2 different lists instead of a single one is that, in
> next patches, we will want to check if unicast filters are already added
> and if they're expired. We don't need that for multicast filters.
> 
> Reported-by: Yalin Li <yalli@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

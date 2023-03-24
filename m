Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE886C853D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjCXShU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjCXShR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:37:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E161BD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:37:16 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p12-20020a05600c468c00b003ef5e6c39cdso560348wmo.3
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679683035;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+a3Hh679tGu1C1YnxbuSVPiRKUn6OIbVnoUNA/SjqA=;
        b=a5qQJQcdggQCOPLdIhC01pK7wYoQiRKjLuDg0ZLXdrB2EbyQL2G3nFGu2/z8Z+ATKy
         m0/bii78T5IoDBuTfD+MqiByzW1IIJnVp7JOI0T547EbCnK/IUAyuq9Xctoohmi1Cqgf
         jiD/rOgKH9Vq/24GPrY4ecJ9jP36tBh6RPUxHHzS8RPdkPYEY/ZPKyA95FBvPfb5h9an
         9kTkJxROdoq60mayJU7x6MvubQI5NbQdzx64TlM+m2mheODyXIqNLsGF5PwZMNlYpi89
         gkVzLfwQwy07efwRDOYLZNC8x1xWmPEYQY8PyD/smoBTKQCzSkFyQiF67tXhDwslCF6H
         OeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679683035;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+a3Hh679tGu1C1YnxbuSVPiRKUn6OIbVnoUNA/SjqA=;
        b=adtN1buVK+kFQ9r5hJl/27sCJmpfdmxrjN3YI+iAzf9h7HbxJog06ZX5d3BejdsKB+
         QNSgKgl4e5AmQ4393+qf7L0EtOKFy6XePi/i+WP8QG5adDuqUdaRQ9M5grThrwlAeRta
         mOOdEAW/+0lLFGsDn+LJpVzj+8bnLMxGa4t8NitWdeQmSEXKbda9bFg0+ERDMuMm5hnW
         7Xe2/+wsfLZjAZ7rdNMWSTX+yaLzWDyO1GoSoP6ZDJDX1af7agsw8ork0STRuLbhJ7rI
         Gz0Fim3WzuoLfAn+IGZQQXr6I+exzVbP9tPqJl/+uLhHi47gGeGcR0yJKrg5/s6pvMQn
         j09w==
X-Gm-Message-State: AO0yUKVG7MeCD8eH41N8j9o1qrb0kg4iKIe1sv35lSIbt77BcCqbzW82
        /q8Jm9Kvj6em+6z7I8nNHPI=
X-Google-Smtp-Source: AK7set8ivagcS4oYABfskDtTCXzkxt5vN/+7EgytoBJIlb0WNe4yKhIMyOVDOdzGRAQR+Ua/GIHHsg==
X-Received: by 2002:a7b:cbd2:0:b0:3ed:2619:6485 with SMTP id n18-20020a7bcbd2000000b003ed26196485mr3445266wmi.3.1679683035050;
        Fri, 24 Mar 2023 11:37:15 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id h5-20020a05600c350500b003ee9c8cc631sm549432wmq.23.2023.03.24.11.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:37:14 -0700 (PDT)
Subject: Re: [PATCH net-next v2 5/6] sfc: add code to register and unregister
 encap matches
To:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
 <20230323220530.0d979b62@kernel.org> <ZB1pEVNGn1fKTGDG@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4a19d213-7687-c9bf-739a-a2b783aa3e87@gmail.com>
Date:   Fri, 24 Mar 2023 18:37:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZB1pEVNGn1fKTGDG@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2023 09:10, Martin Habets wrote:
> On Thu, Mar 23, 2023 at 10:05:30PM -0700, Jakub Kicinski wrote:
>> clang sayeth 
>>
>> drivers/net/ethernet/sfc/tc.c:414:43: warning: variable 'ipv6' is uninitialized when used here [-Wuninitialized]
>>         rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
> 
> If CONFIG_IPV6 is unset it is never used, to is needs a __maybe_unused
> as well.

efx_mae_check_encap_match_caps() uses it regardless of the CONFIG,
 as does the extack setting just below it.
So it just needs initialising to `false`, will fix in v3.
(No idea why gcc doesn't warn about it, not even on W=1.)

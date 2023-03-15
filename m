Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7926BB804
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjCOPgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbjCOPgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:36:54 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730EC65474;
        Wed, 15 Mar 2023 08:36:29 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id y10so16652816qtj.2;
        Wed, 15 Mar 2023 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678894586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u7B79q5XzmIhwSEssat0gkxT+yZ3PWxvIGwk0QStaLY=;
        b=hrPUdwXNzNrTWF81fr9l0YT9NO6JsZJI7DLogoNM99lsegt8gooJ7EO431R/fVR3HN
         IShw/h/Tw1i1ltljp1GbEq4VJFlDBr5qGfEbsAvkZSwY3i5N2p/N/739r6sglpLrj9BY
         tgAaIb1PiSU/Luw4xoMAU91XudTC51NcGvPQjRSJIRfo6B33I6dM4B5dHqnQfmDfuaZ4
         ydp0PXBx//FloDfulxofW1TluMC7wViZru4OuVJg19Oj37ZC6eyAsKqRVgCFl3jFnYDC
         ju1sWCMrE2lxDePm3yjugigJBY3Qw2jvpfTPhsoUKF2St6VGAOE8XoYwWGXDYiYchro0
         Ya8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7B79q5XzmIhwSEssat0gkxT+yZ3PWxvIGwk0QStaLY=;
        b=uZOB2JGsf9TLWhiPKAjKYMykxI7g81j+ZUZ4Kf34Zrb7nP9Y9eIK1a6//2QSmmmPAu
         rPFiL3JFyTT5+rbIQui6P5N3mioqh7D865O0WtFDUK7dzGaWymjII0rsDHiKvQoOlGRv
         T5Jigm62iVN1XVUADe1HEhOTQ07Vsi1h1MlL7P9oFtIxXhQhek5XBB5WaB1geoueS5Eb
         Pj1ZdmYcfn/9JpnbDGA9ZJfEnJEakgUp3mItglsZyMVpDF7zDomFnN87cF7W4FRgOXjj
         y5V/wOExYSslTY6pGsEoBfnsqE6vbstejFs/8fU/wJY5Le+/Jn9OLMvsv27b5FVeHGLy
         PKlA==
X-Gm-Message-State: AO0yUKVxza6g0IphR/x2NGKIAeM+cNKVX8lxxLPFN/HDYV4Th69AEHuw
        zUKEHazfTOJNDOS+CUQCag0=
X-Google-Smtp-Source: AK7set9PvdK/lK7rQ6a6B6OzQUFglSOufyiN79iiVFrD7JQZuFJ/JJRo2TYRsC5VPlhT9Hw+XtxMqg==
X-Received: by 2002:ac8:7d0a:0:b0:3b9:bc8c:c20f with SMTP id g10-20020ac87d0a000000b003b9bc8cc20fmr506448qtb.26.1678894586614;
        Wed, 15 Mar 2023 08:36:26 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id c1-20020ae9ed01000000b007461fe6d6e3sm2577qkg.49.2023.03.15.08.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:36:26 -0700 (PDT)
Message-ID: <8ea1c66e-e4c2-b30d-b8d0-9740ecb8bd6e@gmail.com>
Date:   Wed, 15 Mar 2023 11:36:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 8/9] net: sunhme: Inline error returns
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
 <20230314003613.3874089-9-seanga2@gmail.com>
 <20230315005149.6e06c2bb@kernel.org>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <20230315005149.6e06c2bb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/23 03:51, Jakub Kicinski wrote:
> On Mon, 13 Mar 2023 20:36:12 -0400 Sean Anderson wrote:
>> Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")
> 
> No such	commit in our trees :(

Ah, looks like I forgot this was bad when copying the other commit. It should be acb3f35f920b.

--Sean

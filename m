Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58D76C5979
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 23:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCVWfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 18:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCVWft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 18:35:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14C18E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:35:47 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so63409wms.1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679524546;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rR3fuvrC+FOjt4OcNATPVeisOUvCaTLcSxjAeVnvdjE=;
        b=H9hosocOXushe8xp+xY7tLfConHZ3Tr5KxVGAnhfMBZIuA71altgeZDkn1CitINeWM
         88rE758qh3aoRAG9mJC/4gbiQptbGosUFpzWpBwSH094Dd+oMpsyB+ew0cYzHxwat4zz
         I0sbM/PH8CD4Pz2kXdmFhkQkM8aX1RI63bQWRvGHHEuJ5bkzTul8bMw01U/Yn4dRj470
         W27QYQyMnxKqjmY5ILKKajcukUa2LoUTudXqL+ylBShYewI7MukSLXe7qCubqzzr2LCL
         uEfSpvCp5jBMHz++2mQpmSFRbo0zU82cUdIGsq39rbW7lN0HIems5TJyGh70dEhMp22h
         I7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679524546;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:references:cc:to:from:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rR3fuvrC+FOjt4OcNATPVeisOUvCaTLcSxjAeVnvdjE=;
        b=uWNTsu7DyDUeOuYQo9MobgrppHQ4FLDCXE1qQwZC67Tv4TXvD28AI2y07hAGYFxiIR
         dgdfGgdVY0DTZj907Jc4CCRDYVmQ+bL5ucxfBJrmDSQgXOQiEPHUsBgiIh3PioWuTws8
         zVjBN2U/IKzDiS+kx06fHLn1exB3q4H7VNKSZn2bgHcHTS6RTFEpcKi7i5CVWDHx12Xr
         4nJSD3D2XUvpZWpVy1Fn8BQmmw144oEAZPA3XSMZOqle3VeZaovIx9c67OWDYmiwdOov
         6fMb/yAXx/hSxFXm90AiIQ3K3MtVfsnCvTo0eshd1xbfHxJKyjEains+SZNoP47wRtTX
         MZHQ==
X-Gm-Message-State: AO0yUKVsAHUvYwbox5I3Hss895ZSbcGnQ7zqocF+DbQfQKFvkbS6DPp7
        FbEmCZT8paZ8Sr8nJj0aRwc=
X-Google-Smtp-Source: AK7set+zBoJa6hKoHoW7fmrl2dXqhQmclnV85aL+sepZhGGGpHmHurs0d1XDAIFU/a5R1Wg+D1RqiA==
X-Received: by 2002:a05:600c:2304:b0:3ed:2949:985b with SMTP id 4-20020a05600c230400b003ed2949985bmr777092wmo.23.1679524546295;
        Wed, 22 Mar 2023 15:35:46 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p20-20020a7bcc94000000b003edd1c44b57sm89940wma.27.2023.03.22.15.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 15:35:45 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap)
 rules
From:   Edward Cree <ecree.xilinx@gmail.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
 <ZBGZvr/tDZYaUAht@localhost.localdomain>
 <4553b684-56ec-fe81-1692-b11e10914941@gmail.com>
Message-ID: <b3ec1f69-eeb0-9c5c-7fdc-e520bd63385f@gmail.com>
Date:   Wed, 22 Mar 2023 22:35:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4553b684-56ec-fe81-1692-b11e10914941@gmail.com>
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

On 15/03/2023 14:43, Edward Cree wrote:
> On 15/03/2023 10:11, Michal Swiatkowski wrote:
>> On Tue, Mar 14, 2023 at 05:35:25PM +0000, edward.cree@amd.com wrote:
>>> +enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
>>> +{
>>> +	if (netif_is_vxlan(net_dev))
>>> +		return EFX_ENCAP_TYPE_VXLAN;
>>> +	if (netif_is_geneve(net_dev))
>>> +		return EFX_ENCAP_TYPE_GENEVE;
>> netif_is_gretap or NVGRE isn't supported?
> 
> It should be supported, the hardware can handle it.
> I'll add it in v2, and test to make sure it actually works ;)

Fun discovery: while the hardware supports NVGRE, it can *only*
 match on the VSID field, not the whole GRE Key.
TC flower, meanwhile, neither knows nor cares about NVGRE; gretap
 decap rules expect to match on the full 32-bit Key field, and you
 can't even mask them (there's no TCA_FLOWER_KEY_ENC_KEY_ID_MASK
 in the uAPI), meaning the driver can't just require the FlowID is
 masked out and shift the rest.

So enabling this support is nontrivial; I've decided to leave it
 out of the series and just remove all mention of NVGRE for now.

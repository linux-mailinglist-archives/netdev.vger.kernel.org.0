Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716404EE005
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiCaSBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232987AbiCaSBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:01:23 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C0815758C
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 10:59:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bg10so955074ejb.4
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 10:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5natSrQ4syaBCZ53FFtHP8L6uO1sUxA+JJKhnFriDzw=;
        b=qN0yTDit8eZwOogAqCdMi/U9dhe7PM4Zphb8LuZEpoA41zpuebl/UlX7Bddm4xQtdb
         TVvK4SKbX7vQLC0fo4P5De8wob/byqsDfDQ0UE7i5RS7lk0oeG5NEQr2fi6jgYcDaJTS
         TEYB6vi4flUIeoU4tCAyn7Q6Jfrq8aJF4iUisuqmgxGj7b+JQDX6aI4AEgXpLdVfSA3i
         MdGkF47nZrHHuafylGneU/OWk3JLMXtbqjb/JO3lm9xMFP+2LfbUlnVLorSrcFvScUVC
         +kzfLLM1BZ/8oxvbOyug/cokG1IqUZIyMt44Zrgrm1q0Z3HIm8eShp90Rl5r+vLDIHXu
         9/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5natSrQ4syaBCZ53FFtHP8L6uO1sUxA+JJKhnFriDzw=;
        b=O1Axi6CheT+jJfbnjeDDY0SjrupVm+30FwGU80BoyxdCCYeyOU6JNBA9Cu2BXy7Cy2
         DQgBkpcNFSiWKl5vg6b7djVFrOdHcM+rx0A2L5gA+nTR31dnhYmanY05M2uV6KRCb7Pr
         gN5Sjyr2HPwf6n0Mv4AoGIymJkIHROZklqdDi4wWZUgYwylkCZJbobiPHblEvxnVNFDx
         +ndiY7bN+k5qB7vpmvt6Y5CV/ZpnZOLKUvpMk5eshqjtUYMI+b1vqW+QJ8S9J8WoPNjZ
         Cv5PsjJw0EWmP0dMLVU5WlFR4G/xD+HsRIFsmKPdsQ2TrDX9vaxd7PoehsfVQMc76WKa
         oVig==
X-Gm-Message-State: AOAM530NuMyKnVTUN9qkV1TLkA7/UEhRmyQykeGYbJ2Plc2GpcryJmeG
        8weO6q4rJ9wRCdh0wHyX8sU=
X-Google-Smtp-Source: ABdhPJwwrEZmzI+q8R3sde73ClXYq2vf/5kqruQNQUpMKckmJeBw03a63L7CzYiqEBuo7dg6KvfpVA==
X-Received: by 2002:a17:906:7315:b0:6df:6a3f:d61a with SMTP id di21-20020a170906731500b006df6a3fd61amr5975963ejc.405.1648749574330;
        Thu, 31 Mar 2022 10:59:34 -0700 (PDT)
Received: from ?IPV6:2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98? (ptr-dtfv0pmq82wc9dcpm6w.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:7bf1:a0f8:a9aa:ac98])
        by smtp.gmail.com with ESMTPSA id i11-20020a05640242cb00b0041922d3ce3bsm56439edc.26.2022.03.31.10.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 10:59:33 -0700 (PDT)
Message-ID: <cadf48bb-6fc4-d979-4c00-9f52b8ce43e2@gmail.com>
Date:   Thu, 31 Mar 2022 19:59:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] tipc: use a write lock for keepalive_intv instead of
 a read lock
Content-Language: en-US
To:     Jon Maloy <jmaloy@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
        tipc-discussion@lists.sourceforge.net
Cc:     netdev@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hoang Le <hoang.h.le@dektech.com.au>
References: <20220329161213.93576-1-dossche.niels@gmail.com>
 <c80aa031a57d1d4a98dc3fbc98863d35e5fc9b58.camel@redhat.com>
 <ff3f66ae-6dad-f56f-149f-3587c7181d35@redhat.com>
From:   Niels Dossche <dossche.niels@gmail.com>
In-Reply-To: <ff3f66ae-6dad-f56f-149f-3587c7181d35@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/03/2022 18:54, Jon Maloy wrote:
> Hoang's and Paolo's conclusion is correct.
> The patch is not needed.
> ///jon
> 

Thank you everyone for commenting on this.

Kind regards
Niels

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673A0539314
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 16:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241224AbiEaOWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 10:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbiEaOWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 10:22:35 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7EA59B88
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:22:33 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u140so15163106oie.3
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 07:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y2m5alUjguyLfI65umstCawLGcApuJAbCLQ3v+GfmOY=;
        b=GrDEo8nkWh+s4VCX2kjkno7+Jm4TlY+Md6qwGpIOtxoIf0SrqZgkogBhmi1pdgLyIO
         qOKWTO8rCnEvxT54JNdVIQY8AT7Bvj7ZxKwFuMJB8aap87he1zDcilWd4zAdkg46+GNB
         C1SfoGIU7Ij8sl20aCudoVYri8gb9mX1ZSNZAu7KlFNhIj/ASLtEmmrMOpuah/4zNAZw
         Pxx1mao4IWn2ExGPCIBSIEfDFDcnGXruyVLhyimoZE9k9wCAT/n9gOy7lBUVR93BRhHO
         +7GWBWsq7xjwlLjgw8+MTG+Xn/WMQuF0qFnZMRH54OGQLFXA8LSnwZRnicHkc+Atmhcz
         aIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y2m5alUjguyLfI65umstCawLGcApuJAbCLQ3v+GfmOY=;
        b=xcy7K/GZsbZ1mgdH6CFZ1Qj+1X2G5M/WyWsGD/9ZYLfmRkQc4V6qzsYkcWSFLFGlVO
         U8cfMioA8dKWzD3zk/fLPhhSkAWGgvF2Ii5zwhvy+qi8gfWWizY9MtLBDJ9Hkjn/snrj
         y9C5iY9/40+WyCAJ7wUt5j/t32kjug0AYTIgSrO7382LkC1NaUv3kvuQMSqsTbwLIiLS
         rgTd/c81SVGgY+8USj48/edmWmdFOL6JLkvSBlcIwAD6ZV3GaicECokU88mo2KpYRL3Y
         Smx0mTZJLdjWVZopvz/DjX/D2kkxdaNnPGhrX8gJ5pZir33Jb+ohb2vc5bC2sx+pCmv+
         faFg==
X-Gm-Message-State: AOAM530391+ikb/aC2oXtOn4z3yqbl+5nTHd6xaCeHaJw80p2OWa+kfF
        c9plwkKuoQvFYuLQ5GhoAFT4MDpynXk=
X-Google-Smtp-Source: ABdhPJzqKfKjMtAM/10HdEkry+PluvUhheMBfyr/WjYCPJrRgrtTUgHFeuSg/nMqfKoPspPeUgxM8g==
X-Received: by 2002:a05:6808:188c:b0:32b:b9a8:e6cf with SMTP id bi12-20020a056808188c00b0032bb9a8e6cfmr12068548oib.174.1654006952904;
        Tue, 31 May 2022 07:22:32 -0700 (PDT)
Received: from [172.16.0.2] ([104.28.192.252])
        by smtp.googlemail.com with ESMTPSA id z25-20020a9d71d9000000b0060b0b638583sm6192184otj.13.2022.05.31.07.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 07:22:32 -0700 (PDT)
Message-ID: <5bb06a88-ff87-2bcf-b467-a30a5566dc7b@gmail.com>
Date:   Tue, 31 May 2022 08:22:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Content-Language: en-US
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
 <20220530092445.5e2e79d6@hermes.local>
 <f549f350-5d29-88af-f551-08aab261ec38@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <f549f350-5d29-88af-f551-08aab261ec38@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/22 1:00 AM, Maxim Mikityanskiy wrote:
> On 2022-05-30 19:24, Stephen Hemminger wrote:
>> On Mon, 30 May 2022 17:14:38 +0300
>> Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>>
>>> +static void tcp_tls_zc_sendfile(struct rtattr *attr)
>>> +{
>>> +    out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
>>> +}
>>
>> I would prefer a shorter output just adding "zc_sendfile" if present
>> and nothing
>> if not present. That is how other optns like ecn, ecnseen, etc work.
> 
> I see David merged the patch as is to net-next, despite the comments.
> Should I still make the requested change? If yes, should I submit it as
> a v2 or as a next patch on top of this one?
> 

The patch was merged before the comments. Given that you should be
sending a patch against -next branch that addresses the comments.

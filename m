Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310216DE95A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 04:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDLCNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 22:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDLCNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 22:13:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA8E11D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 19:13:12 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id f2so1444206pjs.3
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 19:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681265592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+pLH2Zo+WFBsdeRJp61NbMEo1KEbaoce9/gjaVMIa8=;
        b=Cu7zPDvVU5g8AedFZwu+6b2ysN9hYKYS8G2bnbWIGTeezlSaU9wUkoDeJHNCxvt8mE
         l3ztOyL1yUsYtfphqjoB6ooCzQBmrwoXKqPg16ihYVvHRTdDQ/zp7Mo8X0RI9CXqUZzc
         HlpmvKukYugzNdIJ9XiPdk1DMGM25uR6vNJhXvpnV4a73H+QBehIS/tbVhAaakMc9MXj
         2iV3c81ziJ8jdsO5FAPTjD0B1afvxUIS2AA/uihjAhEyON6tr0lBTjC7emjBMv7eNo20
         YghAQNTMUUUWvWjAY4ICO5s3m+6jqdso/z9UintR1TsVb4qpFEjjlzyTS9HMU6vrFNDi
         /8+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681265592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+pLH2Zo+WFBsdeRJp61NbMEo1KEbaoce9/gjaVMIa8=;
        b=p2jOx/NhkXX9qbsf+l+fjRj9O8D9E4Cp1398/jJmeOvp0rAR+nsl7nQGwP0Gzl1OSZ
         ZMUBKT9qSdxnOD6n9QuoAID9VqaSNTjFdojLG/fspe/9LXxinQlBzQIa7Ncj+o1niH7m
         /GjiueWPQSrUt+5NSqxBjS3U1jXlxQDIszXtlAmtMXYJ9NBeLRka9ESxeJQGXcMf0Odk
         Igy32Kb9BbONcSgKfW3QPWXn1r/8BfyN6guUJdKy9wACeZnjQE3vE8Isq5vngaW/njD1
         Rxz+7GWXHpGQUU5LRM4yQS0f8gcPYY0uwkyJ2KrqMwwM7/CDhKjBZsBFN7T2hWLZiiWm
         PyKA==
X-Gm-Message-State: AAQBX9ekdYhe2TqRbURdDA6KY6afGD/RC3SU7wSFjd6BVhi6Xp1O4aJE
        Q6dlvUK4yTSJCnwJuY6qtKY=
X-Google-Smtp-Source: AKy350aRvE74Ic0qR2LPZD/yk1EJqgSItxHd0x3aYBAZFSOXan2RCVp82pQe5vI//kWAYk7gcosRqw==
X-Received: by 2002:a17:902:7441:b0:1a2:6f9f:de16 with SMTP id e1-20020a170902744100b001a26f9fde16mr1184812plt.11.1681265592083;
        Tue, 11 Apr 2023 19:13:12 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-60.three.co.id. [116.206.28.60])
        by smtp.gmail.com with ESMTPSA id y5-20020a170902700500b001a4ee6ec809sm10339773plk.46.2023.04.11.19.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 19:13:11 -0700 (PDT)
Message-ID: <fd33a405-e5bb-1085-b1fe-c8e9f04d4526@gmail.com>
Date:   Wed, 12 Apr 2023 09:13:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: netdev email issues?
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <365242745.7238033.1680940391036@mrd-tw.us-east-1.eo.internal>
 <CAM0EoMkuv=3C_jsn6NEsWoGBBzL2WDSNAOWxTfJ-Oh8xfJs1Fg@mail.gmail.com>
 <ZDKzhyCAYdAcu6H9@debian.me> <20230411-pavestone-unfitted-c1d28f@meerkat>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20230411-pavestone-unfitted-c1d28f@meerkat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/23 01:35, Konstantin Ryabitsev wrote:
> On Sun, Apr 09, 2023 at 07:45:59PM +0700, Bagas Sanjaya wrote:
>> Konstantin, would you like to have a look on this?
> 
> This appears to be related to vger, which isn't managed by our team at this
> time. You will need to reach out to postmaster@vger.kernel.org.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F2D54689D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 16:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349717AbiFJOnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 10:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349541AbiFJOnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 10:43:37 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BED71BE67B;
        Fri, 10 Jun 2022 07:43:36 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-fe32122311so3437541fac.7;
        Fri, 10 Jun 2022 07:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8+Y5Di+U9XVzQitvydQ5HzYggBUrE5OarWSXzwYaJBk=;
        b=XMRL6i5uYCIf15dFJeOa/PVQ6Sf1QnZC2EIEB1K/0Q9n2i0DxhH2QBnQWft7zUkA1R
         xYhAd3/zGOPNABbKIHcNDPwSaQwiGaFhlpWcc0VKKnpzHZ68zxJib6+y3Xxf5I3W8BGd
         1hEFCy0k4Mf53tJCQe//5kbuThF0M79VF4azr2FoWesSZwfsteKDVwQ8+esvrl25v2/Y
         HokE8y/JokGKdaMGzBz51JI19ffAp8YgsqyNoFwQiBs+rmp8Udv4JKqhytL1Ld2ByOiT
         oszBknWMr0OSbjY29znnzdPgsUyUlHK3/qJJa3nLl5iEH3PYLVfJROaYxbD1/CB/ORcx
         H26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8+Y5Di+U9XVzQitvydQ5HzYggBUrE5OarWSXzwYaJBk=;
        b=BI575mUaeydO1K27WJaj3lJBgl2M6hQSYPJ1RLbYJzHuI5GYqGTcyESNWSAil3CKYf
         4D9z/f5ZklsA4jY9G/TdS77w7WkDNfGQAZvBwteiWbdoXjigOOPSsCmlpZwe51kj6ERc
         5Y9+AGNddgCpuvWoBq+RKdFo3ss9znmgnEUKwpdqALUPc2wyrdWgXalPVmo408/7Hp46
         nSs+o9dOlJgrV0B947ABSboSEKhqFNki53NbEQ64zjnFFzvjA6L7ZqBle36bsbshCBLo
         QOddimsW3ZxBJIaCtYAz7cXAtHdgBds8JWE1miPbfh2f7tXdlCpK7CjiAYiWmRf4W/DG
         JaPg==
X-Gm-Message-State: AOAM531Wcr8cmmn0Gm+su/fNeaT2NdASE7EtY444dnMdXwucNkmFMl/i
        Rs+0eNGNpHAfdEOBXmgxpCHvaO0m8Og=
X-Google-Smtp-Source: ABdhPJwRcumbpaJ8pNuhLqGCdOY+ysMMcLzfakMSTt/SPNLApRvkmYe3oKiVH1wf7MBNOtk1rEzDyA==
X-Received: by 2002:a05:6870:89a5:b0:f3:3e2f:32da with SMTP id f37-20020a05687089a500b000f33e2f32damr54852oaq.145.1654872215413;
        Fri, 10 Jun 2022 07:43:35 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f016:870:543d:60bf:4aa3:a732])
        by smtp.gmail.com with ESMTPSA id a18-20020a0568300b9200b0060adcc87e37sm13501330otv.74.2022.06.10.07.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:43:34 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 38EAC2DFA6E; Fri, 10 Jun 2022 11:43:33 -0300 (-03)
Date:   Fri, 10 Jun 2022 11:43:33 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCHv2 net 0/3] Documentation: add description for a couple of
 sctp sysctl options
Message-ID: <YqNYldfDNeWdViKQ@t14s.localdomain>
References: <cover.1654787716.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1654787716.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 11:17:12AM -0400, Xin Long wrote:
> These are a couple of sysctl options I recently added, but missed adding
> documents for them. Especially for net.sctp.intl_enable, it's hard for
> users to setup stream interleaving, as it also needs to call some socket
> options.
> 
> This patchset is to add documents for them.
> 
> v1->v2:
>   - Improved the description on Patch 2/3, as Marcelo suggested.
> 
> Xin Long (3):
>   Documentation: add description for net.sctp.reconf_enable
>   Documentation: add description for net.sctp.intl_enable
>   Documentation: add description for net.sctp.ecn_enable

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

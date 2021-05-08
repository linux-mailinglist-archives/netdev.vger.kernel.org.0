Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DC23770C2
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhEHJBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 05:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhEHJBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 05:01:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C802C061574;
        Sat,  8 May 2021 02:00:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id s20so11660544ejr.9;
        Sat, 08 May 2021 02:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=RMX4BPG2KUBNIbhphUhVmoWtkoU2myP/uKL3l+wfeEI=;
        b=GQA/rjCr+UHIVop0ht6mimVrKOUAyIrtvebaM+cs7F5ZDJmVNFojTya80+W8j7u2ZD
         1hX4r3PAKj7H5tDTLDBLJfPM96+wVSySXySJBwUcGFemk+p9NuTpvAiz9DE6PRmJAm3k
         aVz1PGw6rRM0oJHFXRdjPdZrsLyb9dXx9YnXtGTYdE5Pi7qQNv0ZzQBbpT65c09hsA9I
         XtZP6rNjdlKBPGuDKWgMsazgiILlhKT040YerAFB4fc/y7rndi53TxJnuIKLr4Zpygid
         0Gx5U4d0KFDDlUUd33U0wI6c1sikW+EaFEhhssdm5VEAbTy2gFcwXjl52UIv7Xy+DxFZ
         JNJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=RMX4BPG2KUBNIbhphUhVmoWtkoU2myP/uKL3l+wfeEI=;
        b=LejjAwsUksBbEIN3OGLwlrVjiUwTw5c06GbTEzh7zbkWxNHQ1+z0Zw896APF401fTt
         UuVSEagpZf51CO+cotSqZ3zy1eMr+yrjeetR7cmWOEOBuW/vNR74NMENUms8e3Saf5o0
         PgxQjxMOPN+gRIuX6B5axjyybu68VE4Ixgl6YaLManMJCjY8bemcTe3HGxCBewBXUh7z
         zWwo3Hi88vXKArp7rmS4HCN6YwS9jsfrY4rcWCCfPcc2fzrwr8phPKfrUmHTNo3RVbyW
         iyTOBEUk1cyVxuizFBaT2G1bcI1+EcdxIz6szU1t3EZYN3UT4pHD637N6f7o6/+RcPrC
         hP7A==
X-Gm-Message-State: AOAM532GAeaaw97kBQwFYeMppC+6qEoLYLPOK2Zef8LvTn05rA+H3p18
        qttf7li76O2Mmt20ES9guC8=
X-Google-Smtp-Source: ABdhPJyNr/oLRd40LOWotMWopVKw8WMYsAw+H1OxAYCMwWcvsUa4XsqZ+D+OT9BMRsa27t2GKAcF5A==
X-Received: by 2002:a17:906:e08c:: with SMTP id gh12mr15259823ejb.115.1620464402294;
        Sat, 08 May 2021 02:00:02 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id e19sm5774349edv.10.2021.05.08.02.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 02:00:01 -0700 (PDT)
Date:   Sat, 8 May 2021 10:59:59 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        Dmitry Yakunin <zeil@yandex-team.ru>
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YJZTD6vG7GW7P3dP@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508064925.8045-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Thanks!

It should be ok, but I'll try to test it during the weekend.

Kind regards,
Petr

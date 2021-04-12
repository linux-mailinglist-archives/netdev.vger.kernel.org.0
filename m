Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14735CEDD
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245114AbhDLQvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245348AbhDLQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 12:42:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A7AC0611CB
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:33:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso9131653pji.3
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 09:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=TtR92kyJgTTT9P3PMJ+Rw3DFoXIsxndAJjUl76F0iNs=;
        b=Mv0HXI7izsrGpms77gHuuZsj6HWfRIw4oiD6ga8qIkGaoEOwhKpn0xFxnBbKxC8A5V
         ekz1xn/bcu6Yf+7PJ/0bfR5AVwxnJWN7WeMTZOuAs5TKyuOvlLY5Y+LAV4Wi0prbBVoI
         RhtGC0jYMXnSfr73CSqfvHTdVOxJ75bccwy/7Sm/7fHqXCj3wxn4T/ZRBawHQ5NJ88q6
         YSL+VyG5au5fhNz2NNFIinoClRCKCgT4yUKgYRk3suFWDHune5Hp+4LiQjQMDGWrkOBH
         /HDDMKgKTbRb1x8Y+8Ygmgegj68sETIctV7Dfdmo9XRZiAK5aVpsQZWNkP94geI0BfXO
         oinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TtR92kyJgTTT9P3PMJ+Rw3DFoXIsxndAJjUl76F0iNs=;
        b=qXS96AhaWG3NXLpb+1WG/YUsrlgmzHygoWwFbXnH2g3NhfoXS/Svh07f/0gD4VNpEr
         liNe8kg5JQDx9vbjDjwbyy6E7MxPOY5Ob2SckMeeQicO7UOmljk98Oor1XOJgNbDMm2L
         mCvC03l4CXfQ5mBifaWJQd3vn/ufRTbMcbIdcNScFboY6TFK7TGOTlrX91madmXqTun9
         lx6kyHkZh46ZCtnr2liZe9Ijhjdj097O0csSENDjrIRdFfogNmFJ2xp4JoDJIBwtwPud
         gGxb0KAOAlMU557h3khFJyMQjusPS2si3TtKhYCOOrJdOKsWzjEsLPksZAAiqYBHFVYH
         jPpg==
X-Gm-Message-State: AOAM5310/Jsis1xwU510ijYP96/tQqZH23RlW4+g7EmY4jJM9HLez8kr
        oVVDXevfu62p1EMz/m3Ey9Xu3KeUfJEthQ==
X-Google-Smtp-Source: ABdhPJzK4K39EQlJTgOGUL2iYzhLrLsT92+Nl2hcP15Y+i+cAyN0eQvMfy7NFRm6aaKjs/3pRCGTyg==
X-Received: by 2002:a17:902:bc4a:b029:e9:8ae7:4091 with SMTP id t10-20020a170902bc4ab02900e98ae74091mr22949724plz.20.1618245210775;
        Mon, 12 Apr 2021 09:33:30 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c21sm12309450pgl.71.2021.04.12.09.33.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 09:33:30 -0700 (PDT)
Subject: Re: [PATCH net-next 0/8] ionic: hwstamp tweaks
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
References: <20210407232001.16670-1-snelson@pensando.io>
 <20210411153808.GB5719@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5af0c4f1-82d6-a349-616d-0e92e10dd114@pensando.io>
Date:   Mon, 12 Apr 2021 09:33:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210411153808.GB5719@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/21 8:38 AM, Richard Cochran wrote:
> On Wed, Apr 07, 2021 at 04:19:53PM -0700, Shannon Nelson wrote:
>> A few little changes after review comments and
>> additional internal testing.
> This series is a delta against the previously posted one.  Please
> follow the process by re-basing your changes into the original series,
> putting a "v2" into the Subject line, and adding a brief change log
> into the cover letter.
>
> Thanks,
> Richard

If the original patches hadn't already been pulled into net-next, this 
is what I would have done.  My understanding is that once the patches 
have been pulled into the repo that we need to do delta patches, not new 
versions of the same patch, as folks don't normally like changing 
published tree history.

sln


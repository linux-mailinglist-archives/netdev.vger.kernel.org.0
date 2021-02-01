Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F163A30A84F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhBANIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBANId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:08:33 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0EFC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 05:07:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id sa23so7956767ejb.0
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 05:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rooP/GJW/1+QAotMX4S4zetYHn9fYomgwLs+Slrvsg8=;
        b=xmO8dlQ8C7JLhGvMpmANuaONLy+V94k0dDmvSQ602wlKkXlRjoRJNEbIezTcrvZd1x
         wYkKp6yUE+AhyGHoqPSTFTSpRdvlZjjE6UN1sIgMi6Bd6iCNVPC9vjqyTRyIyR9slmQf
         JurXqNXAf5sMvyMrwQHpODWXVeK1Qci0zCANQ+54AyIunmkAX9Ekug4wv51mU44Kun8C
         C/QZipQQQwia8mjOCm5X9ZnslVEdrRNR6i7JOj64m9I7dKMu23ZKb/WcEpWsgd+LZDXF
         9SIa4MjAvkE9ZgHlTTLIxU8CtOHAqoOSC2fKSz2BKRJDASj1AxiOmL5dyaZB4wsDy6nL
         6Fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rooP/GJW/1+QAotMX4S4zetYHn9fYomgwLs+Slrvsg8=;
        b=M94MYrwdI/ATIwal2ctomvM++OlX7f3VIVTPbIj1QTHpPuArmacbMKsD4otqqQHc6D
         CUDWl8Upm+cQdtdKw5vtJ+GnpBAU/jq7rJ8Qsoh9ntAQrM5Zcn7t/PiEyZqGisr9+v8+
         YpskHc/9FumTL/xTSnKjh4zIgztWU5HRgeMJpVZLSRpishmCKPYAWx7pJMBM+q8ujSJ2
         NLYg+s5GulShiJgPtulFGU1A8vTe+O9EcI/WXOHROoOZ4qOgh+lKi3nyIuAPbeiXGPwL
         hAX7sGIQqN7cgQ8OCOB6r86voJkK0+zHm9VUTAH/S/8P87sjTMOOZfeHDcwu34k7YJZT
         rcfg==
X-Gm-Message-State: AOAM5317yumjidTl+PMZ9q/qX5+afUAjiTfkdiKKr/eDhru1/H78Egni
        hZIDws6GzJajB/V1TUi5iKeLVw==
X-Google-Smtp-Source: ABdhPJx44AOeFxSy6H8Yad6nAtmmEPQbmVgty80WRJhEKl06knQnFXHTJ8XjHCF8O9E2k2SUrh4rTg==
X-Received: by 2002:a17:906:6b02:: with SMTP id q2mr18066232ejr.122.1612184871534;
        Mon, 01 Feb 2021 05:07:51 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id u17sm627304ejr.59.2021.02.01.05.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 05:07:50 -0800 (PST)
Date:   Mon, 1 Feb 2021 14:07:50 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201130749.GA31077@netronome.com>
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
 <20210130145738.GA3330615@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130145738.GA3330615@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 04:57:38PM +0200, Ido Schimmel wrote:
> On Fri, Jan 29, 2021 at 03:04:51PM -0800, Cong Wang wrote:
> > On Fri, Jan 29, 2021 at 2:29 AM Simon Horman <simon.horman@netronome.com> wrote:
> 
> I didn't get v2 (didn't made it to the list), but I did leave feedback
> on v1 [1]. Not sure if you got it or not given the recent issues.
> 
> [1] https://lore.kernel.org/netdev/20210128161933.GA3285394@shredder.lan/#t

Sorry, I had missed that.
I have now responded in-thread.

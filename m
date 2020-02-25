Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C095116BA35
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 08:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgBYHEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 02:04:35 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40107 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgBYHEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 02:04:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id t3so13310617wru.7
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 23:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sagIN/ryo7PlEvlORnd3Pn6MAecaRXpmIoRYimS18NE=;
        b=knR2bpKLrTaAPJdy+O4I+jZ3rkaELS9k0vnLVxihNH1bPwUc4SC/ZDFK3VeikWbtLX
         HZu9UxseC1aNwdDm3aEuW4Qu9fhq8OgO0TWCS33UIQcUL9bUU1/vPfWfNj6tIbczQok0
         5L/7eNzp87rQK3xMVdSvK4WIvwpzJxiXAhWgyWggaZfIY7LziRUQm8DI0wmU9F0tTEoV
         wNy3QTBo8CNprYd5moRqjWW6pU0Luar6ALcCgtkhjBodpOU/cpTX3UsiROGFHXq9dMfW
         zzoIR8/mf6/FTrtjDqr7ZyCW2HpQ4r0fNXezzUsSxJjFtPKV6pXQrmkmbBpeNyjbsnFv
         /ZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sagIN/ryo7PlEvlORnd3Pn6MAecaRXpmIoRYimS18NE=;
        b=UMpgukE1DBVzWSo9xz0+K9CBR0HrImZlJbjA4rtwTpIX2+91jJNDY3D7FXFX0TWul7
         vgGM1e66GhfAj1aIwqeNa96HNhF6rTQVw1vHgiA3oSyGEMBcWwoIJnJFMCIJqTBC2EPJ
         7GbrYz51ByuLevszGSTx+vpBdIGJiJZqpOmt0rXHIQUGEgwevW0HqeYrrBDxvZUu/4K8
         UdMF9TH/MAkxS3o5APQAyAEb4GxLBTn+cd1bS0CYJ56FWysBd8PPPBsC837nn4emNx6j
         KIH6qSNoehXVAyAnJjtRdnEjFG3x8/RqLa4kElgbf1vzeFyBBM03s0LmR9TvmiFHwPlq
         eUGQ==
X-Gm-Message-State: APjAAAWvYmDb+zGNtLTYFrKzzpWxcTAemg22TD3jq0zu4sM7hEndAM3L
        rdceedJEzd0Wv3Z5EOglXNIHqA==
X-Google-Smtp-Source: APXvYqwLaRoQSSKguJ+lV1GYg/yi7edHFJ/hzcXIHGnPaJq2tbD8/7NbJPp4wHvMyPYfN54jVn6ljQ==
X-Received: by 2002:adf:f406:: with SMTP id g6mr72208196wro.189.1582614273308;
        Mon, 24 Feb 2020 23:04:33 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id b10sm2729519wmj.48.2020.02.24.23.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 23:04:32 -0800 (PST)
Date:   Tue, 25 Feb 2020 08:04:31 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 03/10] drop_monitor: extend by passing cookie
 from driver
Message-ID: <20200225070431.GA17869@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
 <20200224210758.18481-4-jiri@resnulli.us>
 <20200224201910.281b80a5@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224201910.281b80a5@cakuba.hsd1.ca.comcast.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 25, 2020 at 05:19:10AM CET, kuba@kernel.org wrote:
>On Mon, 24 Feb 2020 22:07:51 +0100, Jiri Pirko wrote:
>> +		fa_cookie = kmemdup(hw_metadata->fa_cookie, cookie_size,
>> +				    GFP_ATOMIC | __GFP_ZERO);
>
>nit: kmemdup with GFP_ZERO seems like a strange combination

Okay, removed.

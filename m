Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E3135F67
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 18:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgAIReF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 12:34:05 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44348 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731982AbgAIReE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 12:34:04 -0500
Received: by mail-qt1-f196.google.com with SMTP id t3so6499413qtr.11
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 09:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLZ40X4AYSx/4IufI5neDGOXIt1DrkaYWqpJijj50lU=;
        b=YtRa8QvPTdA4j+IGrYzf5ipFgbr/DCJAJVWKc8q8BT+ICZP0hiqMU61CEmmNrt9Kor
         1IedsTdhwZO2biCYk5RspEZKHbssaZuGMTwt1u/nTHu5kT5nnZ8RqSpE8QD/CJybCbMQ
         60ASxWqybxd7rDSd1T7Q9LX9QjO3f0AB9nP/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLZ40X4AYSx/4IufI5neDGOXIt1DrkaYWqpJijj50lU=;
        b=ZUfzfnGtepQXYA5fhKQ1euC3zhNGkheHPfeWVTpCgWefUh1LAABprYhZjQN1w/USGa
         NtI53qe4uDZt0AiSgujXU5nzuXKi8tgO03hG1DM8kK0jZwPKF/hJsfvRSHdSfRO6cy7M
         wjqAd/65hGC4/EHXx5vsqBujr5QQn2DZAJVSl2T8lvPu6+vpp8swB9WQYU1X4D4F/MRU
         5ckqbr8/Y1ZZCYgHMK9kK1vIHOBSprYRTXlKT4u/HvMGcFlHn8ZMZAYy8OacAQHBWIw1
         6Hv4unrZIHQWccJCrLsGEDAKJe0XJ21uwsraayGvMzPzu+h1wSUlsIqCAi36kRCHx/RS
         nZvw==
X-Gm-Message-State: APjAAAXIs4NHw18gJrPkq+e1seNTdg6358UBeI+8eFhXhv3l8Em+UnxL
        Eum0M7+4K/om4tBgxmDi1fhWt5LqDOQ=
X-Google-Smtp-Source: APXvYqx+m6ywrvexj6HpvbuKYmUXEbFtAdq0ZdCVkJEOXGPn/gc8hkiGUs/sYupQ0ccv7SfzLFMhEg==
X-Received: by 2002:ac8:6ec5:: with SMTP id f5mr8989578qtv.137.1578591242115;
        Thu, 09 Jan 2020 09:34:02 -0800 (PST)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com. [209.85.222.171])
        by smtp.gmail.com with ESMTPSA id m27sm3657808qta.21.2020.01.09.09.34.00
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 09:34:01 -0800 (PST)
Received: by mail-qk1-f171.google.com with SMTP id c16so6735360qko.6
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 09:34:00 -0800 (PST)
X-Received: by 2002:ae9:e40d:: with SMTP id q13mr10878417qkc.2.1578591240318;
 Thu, 09 Jan 2020 09:34:00 -0800 (PST)
MIME-Version: 1.0
References: <20191227174055.4923-1-sashal@kernel.org> <20191227174055.4923-8-sashal@kernel.org>
 <CA+ASDXM6UvVCDYGq7gMEai_v3d79Pi_ZH=UFs1gfw_pL_BLMJg@mail.gmail.com> <20200109152925.GF1706@sasha-vm>
In-Reply-To: <20200109152925.GF1706@sasha-vm>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 9 Jan 2020 09:33:49 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPy+K2DGYAy+8pXbDQ3e87Vd+KazsS7JneCc5CHa_NaKA@mail.gmail.com>
Message-ID: <CA+ASDXPy+K2DGYAy+8pXbDQ3e87Vd+KazsS7JneCc5CHa_NaKA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow
 in mwifiex_process_country_ie()
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 7:29 AM Sasha Levin <sashal@kernel.org> wrote:
> On Mon, Jan 06, 2020 at 02:51:28PM -0800, Brian Norris wrote:
> >I'd recommend holding off until that gets landed somewhere. (Same for
> >the AUTOSEL patches sent to other kernel branches.)
>
> I'll drop it for now, just ping us when the fix is in and we'll get both
> patches queued back up.

I'll try to do that. The maintainer is seemingly busy (likely
vacation), but I'll try to keep this in mind when they get back to me.

Thanks,
Brian

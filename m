Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC2B41A520
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhI1CLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbhI1CLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:11:33 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B74C061575
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 19:09:55 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r43-20020a05683044ab00b0054716b40005so20176682otv.4
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 19:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aW3x0574RamzC7tu1Vg+zVXQEPqqWNxbY0l9i/w1tI8=;
        b=qjO4yn15GqkxMl1oywi5mtwyQQk4yXfYXNeaFnp2E9SKfsoMMLUrN80i59rZaS7BOR
         Vvxwl7NZsqXbOhmguWanwGVHT66lK388KAvIN7Fw1pylMUS472dslfxKzSzTuWFryZ0a
         g47DT7PM7ikF0wqMdHi0Ho3vn97y4t9Qr9dNEDM+CGWHeEmGYX1bCnWjZkfVQALE1VLL
         SGUQ8nmlMD48T9oxRe20csaM/CsE1YqTS1XjhN1kdd+OuQCPX0TvzGPrb5kh2moAwbdY
         wDLujxTd8QVE9A/L+/KpH8B2TatqQ3szgyV1ov9wfWOZsn5zYF2Q2L604eozsQdd9Lkw
         8vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aW3x0574RamzC7tu1Vg+zVXQEPqqWNxbY0l9i/w1tI8=;
        b=aEPb3C//Q41VD2hpd9/oOn3ZMEhQ3OCX9CN5Y1q7+AjZVYA+ALwxm12pJvnSHYcjIt
         FFD1ClMMbGG+emyp4WDS3e20650+yGGKG6EX2S2SH1H4833rB6wjHGgkRCXSaWzUPRAr
         YvXpdqXXGix+Kn37/Yb1nbkGHVUjL5tEf4GUUteZtzv7Ewu/SdpLGSy/GEpukGEp926z
         H4+P2+fiK3/Ldsusk1LgqgQjSBcxGStz1jKKJ+XlNZ8P5z02xlu5rUf4UbPQw5w0eW/i
         Jp/6h6apeTUxt1i2Sb5R06F+3zhKlKDwpE5instX2ifIgjNZKg0tmpMID/nX2he+gGwZ
         ybvQ==
X-Gm-Message-State: AOAM531/euQb7IyDQduZKbZueSfDZ0ZXDBB2hvwyLtV5GLfkkeRkBsmr
        gmDTUZhKd8gy5SshZ5EHdIyZioIdrsonOg==
X-Google-Smtp-Source: ABdhPJxDfhgLYGBewi6iG4VUnkx5mCWi7jDgI1gB8HcVOQuFVtXdsyDZUznV34EnfT56SfVWPX7R+Q==
X-Received: by 2002:a9d:135:: with SMTP id 50mr2810384otu.295.1632794994407;
        Mon, 27 Sep 2021 19:09:54 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id w7sm3557291oic.12.2021.09.27.19.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 19:09:53 -0700 (PDT)
Subject: Re: [PATCH v2] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Daniele Palmas <dnlplm@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20210924033351.2878153-1-bjorn.andersson@linaro.org>
 <e0da1be9-e3d4-f718-e2c6-e18cda5b3269@gmail.com>
 <eca394ee-04c3-2d33-2c82-1f3360211845@linaro.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9636a4bb-f62e-6e06-3cec-20b5de1515a3@gmail.com>
Date:   Mon, 27 Sep 2021 20:09:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <eca394ee-04c3-2d33-2c82-1f3360211845@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/21 4:44 PM, Alex Elder wrote:
> On 9/27/21 8:48 AM, David Ahern wrote:
>>>           } else if (matches(*argv, "help") == 0) {
>>>               explain();
>>>               return -1;
>> use strcmp for new options. Also, please use 'csum' instead of 'chksum'
>> in the names. csum is already widely used in ip commands.
> 
> On the csum remark, I agree completely.
> 
> On the other:  Are you saying to use strcmp() instead of
> matches()?
> 
> That seems strange to me because matches() is used *much*
> more often than strcmp(), and handles an empty *argv
> differently.

matches is way beyond its usefulness. Its use is now deprecated. It just
leads to confusing command lines and problems maintaining which option
hits the matches.

> 
> I don't disagree with your suggested change, but upon
> looking at the other code it surprises me a bit.  Can
> you provide a little more explanation?  If you mean
> something else, please clarify.  Thanks.
> 
>                     -Alex


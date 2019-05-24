Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED3429A2E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 16:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391640AbfEXOoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 10:44:22 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35624 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390885AbfEXOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 10:44:22 -0400
Received: by mail-yw1-f68.google.com with SMTP id k128so3733211ywf.2
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54p98Z8GsZnRbA2R7rZ6A2XoOyLtC3qU4Ve73ijST3A=;
        b=KLMe2lXlbHqDSy8q0bncZEF/LPl65ikuYxqywxuzlXCfDQ19TtmOkAKoAk9B8Q0nsK
         4gGAL9Xe8YLE5OZanz85jUcHIZCEFRbtWVck9m4/NMNSf32yudD/rPCcsJrVvWQn8K3c
         yuo+yFyH0L10V+Id42v8VlF4pd0skas31gUr5Gt88YuCjmjejZDlgRvE2Rf9Tkx2olKP
         qMF4IyCzXbhmTk0WcuGJnqQrV+KtahBwdiy+6L3K6HOM6KxwvJwmaZdqLbRJpLF8Ecwz
         3HlDPM6QibRYe43OwL6FOVnoGfbSlRmnt6jUl89hNS+YOBiVP6TfNlS8c6MGzmnTS6sd
         S0TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54p98Z8GsZnRbA2R7rZ6A2XoOyLtC3qU4Ve73ijST3A=;
        b=rCfAwE7bmMNq8mTuyGl7yjgaelEYzLB1Sr2viTeTDl85CSmM2w7Ax3Po2C9SpvNewv
         1MYMJiolRV6KhuWjV353xHSjMfW9zqDy9rGbC7iWVFcrSk2wK1+n7+h09x3gr1lrtX1k
         8ZlhpTBl83WeeZKnPrpZBcyhaBYuN7WxLQldsPq0aEbAyuITjizrcjhTC9/Uj46JwbdG
         zwGHHo7pDX2ZF1SR4+VVUpKCNzBp/oeC30uDj/qanwlP8ro1U3fg1qErZShmhH8K8jMV
         ciB+zqbyzDR94HfNMIXU8lWKw8fVU12r6bXUkWUBC77TfEhBuT0yKby7/j5JvGunensq
         cJxg==
X-Gm-Message-State: APjAAAUUA7ladCKtA0UC7ZlmgB5oO7jLDOi71uUuojFDnn8FlBMq6L2y
        GjpUgMyLfLv7zldwfsgv2TRnrw==
X-Google-Smtp-Source: APXvYqwAgvNeRIT5UBbVzKTxwojznVWQPrp51Ewv90swvHslVXx6DOisv/mYa9aTYozKJkv312mKSA==
X-Received: by 2002:a81:3097:: with SMTP id w145mr44868131yww.203.1558709061142;
        Fri, 24 May 2019 07:44:21 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id h190sm632830ywe.67.2019.05.24.07.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 07:44:19 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
 <20190522152001.436bed61@cakuba.netronome.com>
 <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
 <20190523091154.73ec6ccd@cakuba.netronome.com>
 <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
 <20190523102513.363c2557@cakuba.netronome.com>
 <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
 <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <93ee56f3-6e58-5c16-a20a-0aa6330741f7@mojatatu.com>
Date:   Fri, 24 May 2019 10:44:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-24 9:57 a.m., Edward Cree wrote:
> On 24/05/2019 14:09, Edward Cree wrote:
>> I'll put together an RFC patch, anyway
> Argh, there's a problem: an action doesn't have a (directly) associated
>   block, and all the TC offload machinery nowadays is built around blocks.
> Since this action might have been used in _any_ block (and afaik there's
>   no way, from the action, to find which) we'd have to make callbacks on
>   _every_ block in the system, which sounds like it'd perform even worse
>   than the rule-dumping approach.
> Any ideas?

If you have the hardware just send the stats periodically to the kernel
and manage to map each stat to an action type/index (which i think your
cookie seemed able to do) wouldnt this solve the problem?

cheers,
jamal


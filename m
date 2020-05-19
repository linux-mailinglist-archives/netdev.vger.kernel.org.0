Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705FC1DA44A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgESWJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 18:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESWJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 18:09:56 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8CFC061A0F
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:09:56 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f189so1577246qkd.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 15:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=OYamTGdOPhCVNI1QvW1e3g2+Fi4dcV776yPbpbLu8pw=;
        b=WIXmMO/PbE33x8nwzxIRp5yg7DND1PNW+0NrqgaXv7nzawsT6IhC2eCjvvh40mto7r
         SbLz78dwf6iEHEr4KYAH+cU2l4PBJ2PrrcDClxHMkw/kkgOQhtdmtWPXcg3ZURXayCr2
         wehkLzF5xNF6iBajUpaU+Ws/Ub+1mzK+4bViN0VclKtFMeGNTATrGWuQxqzfnPZf2SWO
         7Qpr0UGpRqLCkg/a/v4o8r+1ZwKlN7vTRPy5jd80gADil2evZOn/Js+FOeY/o+Iy4E+2
         y1n1rsM/Jx14MXrBgnETdN/XmAZLa+A/ZzsNF5opqItPPsetHWuNFqJ7bQdmvm5cDT01
         igCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=OYamTGdOPhCVNI1QvW1e3g2+Fi4dcV776yPbpbLu8pw=;
        b=W4Azn9otRGiwEW8/w6Qs5JdNAhEQ1BdUQ926ZJ5YH1Ey5zwLRkqvEQh0R2k4mSCKsM
         408iJ1wwcbUu7PB/biEEJ6ua6G7w0rD3qFtnGYnAdThCAitcrLJPEvpHBfkw/RliZff+
         GSKrj1G/182uv3/IsI3Q/CVNazc6TAxKUFoMmvLNghKhA3OdmzWdr8Q/DaG1XfPoTNOV
         RX2vGnQMnRIGDMHcrPrSuuy3cgYTaud8su2KieZo6jfXVGclWgT0isjphhuGcFedkgJo
         8dFsHYqXQ2njbPp8LBwxdVteDivQKaM/6+TQoE79DuMRsj0mWHv4uKYXPPZ5Yv6fZTDR
         PQxw==
X-Gm-Message-State: AOAM532wRxue5NMQuPoKt4sjK39zM1FqSbe+BvL7Hljhvptkm6f/Pk2J
        GhL1Qd05fTCEgGbNXQDm9KqekQ==
X-Google-Smtp-Source: ABdhPJz/kWlMCT7BckmPKCO+bE/Rv6NJIjYq2GjNu6FNQX7xlYSGd2IEAFANX3UM4fOtg/schkqnvA==
X-Received: by 2002:a37:3d7:: with SMTP id 206mr1813641qkd.202.1589926195711;
        Tue, 19 May 2020 15:09:55 -0700 (PDT)
Received: from sevai ([74.127.203.199])
        by smtp.gmail.com with ESMTPSA id i24sm858519qtm.85.2020.05.19.15.09.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 May 2020 15:09:54 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org, kernel@mojatatu.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2 1/1] tc: action: fix time values output in JSON format
References: <1589822958-30545-1-git-send-email-mrv@mojatatu.com>
        <20200519142925.282bf732@hermes.lan>
Date:   Tue, 19 May 2020 18:09:38 -0400
In-Reply-To: <20200519142925.282bf732@hermes.lan> (Stephen Hemminger's message
        of "Tue, 19 May 2020 14:29:25 -0700")
Message-ID: <85lflnmva5.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Hemminger <stephen@networkplumber.org> writes:

> On Mon, 18 May 2020 13:29:18 -0400
> Roman Mashak <mrv@mojatatu.com> wrote:
>
>> Report tcf_t values in seconds, not jiffies, in JSON format as it is now
>> for stdout.
>> 
>> Fixes: 2704bd625583 ("tc: jsonify actions core")
>> Cc: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>> ---
>>  tc/tc_util.c | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>> 
>> diff --git a/tc/tc_util.c b/tc/tc_util.c
>> index 12f865cc71bf..118e19da35bb 100644
>> --- a/tc/tc_util.c
>> +++ b/tc/tc_util.c
>> @@ -751,17 +751,20 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>>  	int hz = get_user_hz();
>>  
>>  	if (tm->install != 0) {
>> -		print_uint(PRINT_JSON, "installed", NULL, tm->install);
>> +		print_uint(PRINT_JSON, "installed", NULL,
>> +			   (unsigned int)(tm->install/hz));
>>  		print_uint(PRINT_FP, NULL, " installed %u sec",
>>  			   (unsigned int)(tm->install/hz));
>>  	}
>
> Please use PRINT_ANY, drop the useless casts and fix the style.
>

Thanks Stephen. I will send v2.

> diff --git a/tc/tc_util.c b/tc/tc_util.c
> index 12f865cc71bf..fd5fcb242b64 100644
> --- a/tc/tc_util.c
> +++ b/tc/tc_util.c
> @@ -750,21 +750,17 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>  {
>         int hz = get_user_hz();

[...]


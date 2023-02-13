Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14761694491
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjBMLcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBMLcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:32:06 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E74EE2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:32:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m14so11800194wrg.13
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 03:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y97MVJRyvqVyJSx1NT+LZjMnZrfJygBbCY0R+O5dB1E=;
        b=a6CxTZFniTRJfjEZSXuuLyYq2ZdBmWbcg/Q1A7bEEXQ4JW/qsuZxE/LLhplBbrRAS+
         46245ekfmTU3mzU4kCoilW0p5pKPYMEZKjdsnlxNjg1fR/ZAw66zuoO1kq9cUVmJSWSb
         TUwhb/+FVlzKui4bOkLZi8tGX/tHdPIopHUr0cQGX3YSnx1p+R7H+8oSIG1cOMjlX4GL
         c2F0FLgCLkqv8bLn8xyWvo50+FV3BXNE0vb2FJaV2BVnn0ZHy19qtCWE4MRmB7/78XyD
         gzg7DYs/ctf/1CBBPDaGyAJpqgM/3iFnTzD01GHLQDL5TUuW1KDmhUeEhBZ59FDQxMK1
         IW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y97MVJRyvqVyJSx1NT+LZjMnZrfJygBbCY0R+O5dB1E=;
        b=3qBbFhCU0or2+1kfjN+6sg2WCRESCIXqBDWjaeMOMwCpd9WOgEmSUTm25nZBpuzUmm
         xasKt/f61vixniNgYFi+iN1QUGkvqKpPW4ZT6zbvasIEFm07OSPQ304h59BBf1ZpeZtB
         UNYEasiveF7/l9Mh9ve3k2tinWGucgUomAtypREeHtuotn14zmI1q9uHR9wSVQb/37aF
         Z4GWJbVFUQIR1G2uWqVXU3PROV+H2QWkFF+OtyVj3WE7Y8HixQaLGo/5TVXZu/Se7Kp7
         vn+Up8H2xK30EYZ9BTn5sRszzQ0hewsxUB4q57gwfmKXg8/l5sAiUMFJhHJaPu7M3uaq
         Kvxw==
X-Gm-Message-State: AO0yUKV3Wuojuje0CvT6DY5F2CEoRcxkfLU36O+7etgfssMkO/W5ZKpl
        zQKbq9V8uMWRXbXjzrrSqBShqg==
X-Google-Smtp-Source: AK7set8OpjlDUq4bs7CWpf7TdCTZQr9wCA3ILL39zeNME1tIGjFtopwpHKGb0mf2nlaWxc2QN1s/3g==
X-Received: by 2002:a5d:6149:0:b0:2c5:5bc0:e7bc with SMTP id y9-20020a5d6149000000b002c55bc0e7bcmr1616228wrt.4.1676287923098;
        Mon, 13 Feb 2023 03:32:03 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002c54d970fd8sm6193405wrq.36.2023.02.13.03.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:32:02 -0800 (PST)
Date:   Mon, 13 Feb 2023 12:32:01 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <Y+ofsQYO50oK6VaU@nanopsycho>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <20230210200329.604e485e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210200329.604e485e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 11, 2023 at 05:03:29AM CET, kuba@kernel.org wrote:
>On Fri, 10 Feb 2023 14:18:07 -0800 Saeed Mahameed wrote:
>> From: Roi Dayan <roid@nvidia.com>
>> 
>> Instead of activating multiport eswitch dynamically through
>> adding a TC rule and meeting certain conditions, allow the user
>> to activate it through devlink.
>> This will remove the forced requirement of using TC.
>> e.g. Bridge offload.
>> 
>> Example:
>>     $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
>>                   cmode runtime
>
>The PR message has way better description of what's going on here.
>
>> +   * - ``esw_multiport``
>> +     - Boolean
>> +     - runtime
>> +     - Set the E-Switch lag mode to multiport.
>
>This is just spelling out the name, not real documentation :(
>
>IIUC the new mode is how devices _should_ work in switchdev mode,

Yep, I feel exactly the same.


>so why not make this the default already? What's the cut-off point?

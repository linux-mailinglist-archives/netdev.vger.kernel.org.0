Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4435D5AACBB
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiIBKrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbiIBKrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:47:05 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C87459A2
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:47:04 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id c59so2112942edf.10
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 03:47:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0tuV4RBS11QoKO6jOV9UQflOCuBgQWFD3n339zIPtSA=;
        b=erj34yn4qmYxB+TtGQeiBoyeagD5Pg7TLuRIr8T3nrgHxu+/DbfOW4Fqck5C7mvMio
         /grl8ajxwCBPl4qLsT02k/D108DLNG3394QunDgS0F1vBnT3JL+rqasaKTNNT0r8jOYw
         wkYxyxXRUS+63+HNIzRxhD8pNNJqsngP8K/5ZuSbSX/shEsbTDC+52ewzcqoihYs/HRZ
         rMScG1XhrpwQ86JrUo4t0ARaX1g38g/M5LMxxCcd5YKfNYpo49ftF1iTtSZQIYmpJkiD
         VbvwmARoXkZMhgDXzfWBWy5RrWgwkt+bgQ6Nb3J73aPj5EX1kzaaT2c0xykhpdo4dQKe
         c7Aw==
X-Gm-Message-State: ACgBeo31Mj5KvJhFdW3gYvGWiVMmD9ERgSgkIYD1PZDxZ0dkeVHAmnD4
        erTiuNtpLcffpFZIr4b1L30=
X-Google-Smtp-Source: AA6agR78ugehk0x37vWFUEMqCWRgTLXh0NwF7gz7wtueSrrCzs3ld0jPUC+xnXQQ6Ul9G2RDwtA8QA==
X-Received: by 2002:a05:6402:1250:b0:447:dd0e:213a with SMTP id l16-20020a056402125000b00447dd0e213amr28624230edw.359.1662115623062;
        Fri, 02 Sep 2022 03:47:03 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id le6-20020a170907170600b0073306218484sm1059581ejc.26.2022.09.02.03.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 03:47:02 -0700 (PDT)
Message-ID: <b32ef683-e09c-522b-ffa7-ea09628e81db@kernel.org>
Date:   Fri, 2 Sep 2022 12:47:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Content-Language: en-US
From:   Jiri Slaby <jirislaby@kernel.org>
To:     Johan Hovold <johan@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
 <20220829220049.333434-4-anthony.l.nguyen@intel.com>
 <20220831145439.2f268c34@kernel.org> <YxBU5AV4jfqaExaW@hovoldconsulting.com>
 <6a426c91-5c03-a328-d341-ef98bc3d8115@kernel.org>
In-Reply-To: <6a426c91-5c03-a328-d341-ef98bc3d8115@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02. 09. 22, 9:42, Jiri Slaby wrote:
> On 01. 09. 22, 8:44, Johan Hovold wrote:
>> Looks like this was merged in 5.18 with 43113ff73453 ("ice: add TTY for
>> GNSS module for E810T device") without any input from people familiar
>> with tty either.
> 
> FWIW doesn't it crash in ice_gnss_tty_write() on parallel tty opens due to:
>           tty->driver_data = NULL;
> in ice_gnss_tty_open()?

Oh, the driver checks for tty->driver_data in every operation (gee). So 
at least that crash is mitigated. The userspace will "only" receive 
EFAULT from time to time.

> There are many "interesting" constructs in the driver...

The checks belong among this "interesting" constructs too.

> thanks,-- 
js
suse labs


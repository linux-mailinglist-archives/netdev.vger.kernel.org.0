Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E495AA903
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 09:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235284AbiIBHnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 03:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbiIBHm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 03:42:59 -0400
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EFEBAD9C
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 00:42:58 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id r4so1543675edi.8
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 00:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hYc1BgRQTqFp6kArhlEDUXpNgOxV8EtZ92C9F9zU1Jw=;
        b=WHxEuZo43hc+WdgiRGMpLXDVwTHYffew8+4paK3qP82MMDBVM4H387ZZaXLzor5HXO
         aZzyiyNAB/UqY6l2bS0uPyDx8jfGtVfUOdt6ujiNx0T+0gNUc+asZpXwJMVrsfpvBaau
         jd0WQd3O0BxXl3qT+KzgBn4y4gkqPc8xXIbwwx1nloiwjrWCDUIxpvjeFyk/6dWm4aOf
         qiUKsD6vJs4bthSGBud5fT1JFfikwNM3M+z+i29np/ycjuo/+7uyg32LfuuooGEjYEqN
         XOELGtYuKywUDGQTFQE4Yow7Zqf3WIWgFO2cdLe9/IaR/kwIOO6HR/nkUGk0gD9XLjju
         qkDQ==
X-Gm-Message-State: ACgBeo2Ppj6/V3nPoGAMMtgrezVkOoN8dHKgFEd+uXCJyKdzha9D+lYm
        sbhO0fEVVMI9Rhi0lN1EUaw=
X-Google-Smtp-Source: AA6agR6oQrqTJa9aMPYzkq30in5sWP+WGTdhDuVbY2Ky3xyVGqDI5n1H5Spj5BUl0Ljivflz2UTCAw==
X-Received: by 2002:a05:6402:4305:b0:448:5b80:757a with SMTP id m5-20020a056402430500b004485b80757amr21461469edc.198.1662104576276;
        Fri, 02 Sep 2022 00:42:56 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id lb14-20020a170907784e00b00741a0c3f4cdsm812049ejc.189.2022.09.02.00.42.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 00:42:55 -0700 (PDT)
Message-ID: <6a426c91-5c03-a328-d341-ef98bc3d8115@kernel.org>
Date:   Fri, 2 Sep 2022 09:42:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Content-Language: en-US
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
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <YxBU5AV4jfqaExaW@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 01. 09. 22, 8:44, Johan Hovold wrote:
> Looks like this was merged in 5.18 with 43113ff73453 ("ice: add TTY for
> GNSS module for E810T device") without any input from people familiar
> with tty either.

FWIW doesn't it crash in ice_gnss_tty_write() on parallel tty opens due to:
          tty->driver_data = NULL;
in ice_gnss_tty_open()?

There are many "interesting" constructs in the driver...

thanks,
-- 
js
suse labs


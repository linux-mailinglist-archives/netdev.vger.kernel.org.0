Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534096C71FD
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjCWU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWU6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:58:23 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93262311A;
        Thu, 23 Mar 2023 13:57:59 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 20so16757462lju.0;
        Thu, 23 Mar 2023 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679605075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QllIjtDRCuTkdGt8RZ/w1lWCVqloNvO62icgDypzWxg=;
        b=qyriCx0PBBRPf1+fQOkg8s+pbF04J3uTUMSIsu9eLbfXqhrSN4/HCghGBOot4Rjt2K
         asmRbQrmCCHtOfx8bgXD21aw2hcRT/n3mKJs9w2lztiAVO94wsuHscWD+zvq9aJcm0wq
         mY+n3kWv8peCQeAUQp0msLFKs/yM6KPOmeZ+/N9zuEBKf8+HxvuOPzdw7Z93QEspMCkn
         yE7gt41jBsZI4ZMUiWUVGMteqFp8+DvWI8A6WeFyjlRB0mAw/iWTeCLShCDJA7LHv4Sy
         ZnLq+T/MqFz2vSXo/VLqyhORuWIeAPHtXVhh4E9GHpCbIyHQJEhRct9s0yV4ibeR5/YC
         WGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679605075;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QllIjtDRCuTkdGt8RZ/w1lWCVqloNvO62icgDypzWxg=;
        b=ojyuDK+MDpPuaYuKTaZ145oHCX1hgJgbDlafGdKTmwS2AGfOzsLHw9UW0znox2i88A
         eyxpamblv287Eeesoo/ib7QFf4d87ZFZoQ8Jii4/dFU9A/uDZHEkuFH2fjVM0Id+vn/A
         2BfwsCOgQTMCh3SKSixlfZPdVhpCPSOniMluCMN0pWFEoO27GK+L5VVl+rYK8tZkZgfL
         B5FKIrGudDvfZsSHjSQTvsHlf1LZAYsKfRc9i6wCrn6NW98oLN9GbXEXf+9fjfg1MUGk
         OfgnYYDn5VkxXosleoYdMd18S7oENNQhqGeSL75Tcxciyi7ffje9N8ohZhM7u0NVS0Os
         6kjQ==
X-Gm-Message-State: AAQBX9fD6KvnRhxFxbadGtc00aZbanZuoF8lLIvPWWtbaP83q3xd/E2P
        Cu7sVMa0JfcqM573jPb1I38=
X-Google-Smtp-Source: AKy350Z7haypN7p3yGB0EsrKpQnNdZdrOKH7hLWK6nxyC8dEQVyQ9Ab8bedfHPJYX5QnZIGQ5Eg1YQ==
X-Received: by 2002:a2e:88c9:0:b0:29b:d5a6:579c with SMTP id a9-20020a2e88c9000000b0029bd5a6579cmr158791ljk.27.1679605074437;
        Thu, 23 Mar 2023 13:57:54 -0700 (PDT)
Received: from [192.168.50.20] (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.gmail.com with ESMTPSA id l2-20020a2e3e02000000b0029e5448e752sm1638273lja.131.2023.03.23.13.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 13:57:53 -0700 (PDT)
Message-ID: <6813a7ce-93f1-3a63-0641-f6a77aa7c343@gmail.com>
Date:   Thu, 23 Mar 2023 21:57:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
References: <202303180031.EsiDo4qY-lkp@intel.com>
 <20230317173606.91426-1-szymon.heidrich@gmail.com>
 <ZBx+eGTSjRM8fvsf@kroah.com>
Content-Language: en-US
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
In-Reply-To: <ZBx+eGTSjRM8fvsf@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2023 17:29, Greg KH wrote:
> On Fri, Mar 17, 2023 at 06:36:06PM +0100, Szymon Heidrich wrote:
>> Packet length retrieved from descriptor may be larger than
>> the actual socket buffer length. In such case the cloned
>> skb passed up the network stack will leak kernel memory contents.
>>
>> Additionally prevent integer underflow when size is less than
>> ETH_FCS_LEN.
>>
>> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
>> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
>> Reported-by: kernel test robot <lkp@intel.com>
> 
> the test robot did not report the fact that the packet length needed to
> be limited :(
> 

Yes, I removed the Reported-by tag in V3 as suggested by Jakub.


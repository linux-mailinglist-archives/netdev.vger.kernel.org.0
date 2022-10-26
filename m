Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD4F60DD1A
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiJZIe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiJZIe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:34:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5E5C50A5
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:34:24 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so995870wmq.4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uv9yqVm5NXQSuzusrmz612bIy0TcIeMeyyaRL6Xw/y0=;
        b=HNm1NpYG3Djdd7JS66RszSUo9j0zQKI422Ck8XN0biLSSnRpgdj/UPK9ZXAgRd8UeD
         qCOefWooSQlXTWTF4Ybo+GnPwSRAUyDKM6ICfrxmcA5HYRrjrePrEx820sf6sSBerEGM
         MRr9YVhmL+jHO1KCnN6ECBCSF+HdyaltTthI5v9l9bUGpX551KcU8fZob3u+WHKJXv9K
         BoV9cC/ibNVhQmmkmWQQyWqcnMD9qpxvHuyGqmFae95Pd2Je+n+239dS0x75Jo81Wa+G
         JrNtLjUIWMsPPi/sLPBgulUKgXKtdQS5JatpOyXUm3R9NZBOzkpcfnlfJP1k/zB6SqPe
         KBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :to:content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uv9yqVm5NXQSuzusrmz612bIy0TcIeMeyyaRL6Xw/y0=;
        b=gB1QPPBEEqKhxVi7J7nF3VPxrZ1mTSMAVvifm1IytD1OZS/sCDM4CvsSQ7TaWzR8i4
         r/Uqelr8xZVVVDXugZGIW37nmFASCq6KtwT72ROL80kUxScAfy1bjtHujTySVRMpnLJs
         tyU4bl8IHCzuucRCFUgC8OC41BdQhY8prXrYQGRkLDq2o581TNGL+H443/cd8RS+Togg
         mXbUsIF5uf5idK8K6aBggC/H3A0q4LqCijWbxLn9LFi1QNpE0QgS/asj1JCw2m36HTG8
         ROBrzdf2Bw7GAXF770a/WLWkA+KHx+rMw/FkS9UISQA3+TC1JusVb7BzX8mC/18iL5oV
         7XCg==
X-Gm-Message-State: ACrzQf1Mgz1k9NY+86i6FfIKfxrnkVnubaWwaijVyOx0ZL5Ap1dUCI/N
        CT4djzJPjBbT4WG1jTufa2YZMA==
X-Google-Smtp-Source: AMsMyM4UN1YD5fugSmBySkcvzgBQzsTfBDyb8diINgSLcv94ZJFodWshYtp2W8JAf2smyx2Nwv1ulw==
X-Received: by 2002:a7b:cb81:0:b0:3c0:f8fc:ea23 with SMTP id m1-20020a7bcb81000000b003c0f8fcea23mr1572977wmi.31.1666773262387;
        Wed, 26 Oct 2022 01:34:22 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e8f9:50eb:973f:3244? ([2a01:e0a:b41:c160:e8f9:50eb:973f:3244])
        by smtp.gmail.com with ESMTPSA id q16-20020a05600c46d000b003c6f426467fsm1183214wmo.40.2022.10.26.01.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 01:34:21 -0700 (PDT)
Message-ID: <037d30a7-15e3-34c7-8fdd-2cf356430355@6wind.com>
Date:   Wed, 26 Oct 2022 10:34:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: Bug in netlink monitor
Content-Language: en-US
To:     George Shuklin <george.shuklin@gmail.com>, netdev@vger.kernel.org
References: <2528510b-3463-8a8b-25c2-9402a8a78fcd@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <2528510b-3463-8a8b-25c2-9402a8a78fcd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 25/10/2022 à 13:18, George Shuklin a écrit :
> I found that if veth interface is created in a namespace using netns option for
> ip, no events are logged in `ip monitor all-nsid`.
> 
> Steps to reproduce:
> 
> 
> (console1)
> 
> ip monitor all-nsid
> 
> 
> (console 2)
> 
> ip net add foobar
> 
> ip link add netns foobar type veth
> 
> 
> Expected results:
> 
> Output in `ip monitor`. Actual result: no output, (but there are two new veth
> interaces in foobar namespace).
> 
> Additional observation: namespace 'foobar' does not have id in output of `ip net`:
This is why.
https://man7.org/linux/man-pages/man8/ip-monitor.8.html

"       If the all-nsid option is set, the program listens to all network
       namespaces that have a nsid assigned into the network namespace
       were the program is running"

You can assign one with:
ip netns set foobar auto

Regards,
Nicolas

> 
> # ip net
> foobar
> test (id: 0)
> test2 (id: 1)
> 

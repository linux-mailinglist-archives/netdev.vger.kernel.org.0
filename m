Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2550760FC20
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbiJ0PiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiJ0PiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:38:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37544190478
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:38:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso6879084pjc.0
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/WV8nQflZoCZ/xz241twHN3sZwDyBQuzGyE5xelXyc=;
        b=qW1f1rZAiJ4O71tkXN5YdMNc8AF6b8rOdNBcj/LzVZEp7SOUefDQyxgG3Wnmvpd3b7
         WX7fJoH6NA/o2VI7wacOauB7NmZrc8nGfc+F5JMeuS0rjOFQwPOTU5PjfHZB6/e4zx3T
         BdQDJ8olhQQS7q8f+trKQqQi5jMfRM02X8mk6H+P/ZFIQu1hrXw8/wKdeYbz/t/VBqqR
         vRvfeEfaFIRfMY4uI4SGOCvkMbQ4jiqB/1R5E0NmJ55uvKQHD3Hly/fa0vuffBt3U/JQ
         QhNM2sV54c0KvhgCi3NXZgG3Y/bibZwgIF8lO/H/mQaidmVBqsyVkv6/dQQMEVlsdHD1
         YLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/WV8nQflZoCZ/xz241twHN3sZwDyBQuzGyE5xelXyc=;
        b=JYfGANBeCTu3K1vGLQ90lxGg43lm0dRqBsXxJaxkLtWsBMM8X8Q3pZ55ZpWysW38fk
         5JqlU2tmfYjHPn/Jw6gkRi/nZuvCrdNP5E3Pl4sxHfUw4WK3nfkx83SyagDvNflPt3K6
         WIwO3byV8+Owtbg8s3K2+L0cyy/ijlLSw7F3IJmcoa260dMJQEgEzefCWraB8VYgMs33
         tTlP1/9/Ef99FLiqN25UuZC3DhhtorRMJv/CtnGy3M/A4KwjwcTfZ8ACsGZZG5Yv9yZ5
         FyfAL5wWGkUd6ZRQ2kQXfns3ha0c9kkJ77h3eA0ZU1aJET6n5PR/PqTM7fBTI+9ddN6Q
         wOlw==
X-Gm-Message-State: ACrzQf1WIsTnOX/kxEdO7zFdEv/lkyPjfROajlp2pYcO3T5Uc1IHR3KH
        THPcwNvsVlml3tQylHNh4vlCXvUnOx4auw==
X-Google-Smtp-Source: AMsMyM6F3kD15GD8DJ0Zj93D3kYGErhZLbMlSYgIit+aTlF1zrxiJoXE8kdy5Y0u3M53hSu3QL2QQw==
X-Received: by 2002:a17:90a:a415:b0:20a:f813:83a3 with SMTP id y21-20020a17090aa41500b0020af81383a3mr10912817pjp.238.1666885089703;
        Thu, 27 Oct 2022 08:38:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090a34c300b0020de216d0f7sm1174821pjf.18.2022.10.27.08.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 08:38:09 -0700 (PDT)
Date:   Thu, 27 Oct 2022 08:38:08 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     mrpre <mrpre@163.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2]fix missing eBPF name
Message-ID: <20221027083808.3304abd6@hermes.local>
In-Reply-To: <4079d76a.5b33.184195d2368.Coremail.mrpre@163.com>
References: <4079d76a.5b33.184195d2368.Coremail.mrpre@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 20:14:05 +0800 (CST)
mrpre <mrpre@163.com> wrote:

> Signed-off-by: mrpre <mrpre@163.com>
> 
> 
> 
> 
> missing map name when creating a eBPF map
> 
> ---

Makes sense, but this patch is not formatted properly and is missing
a valid Signed-off-by line.

Please follow same style and contribution rules for iproute2
(see kernel documentation on writing patches).

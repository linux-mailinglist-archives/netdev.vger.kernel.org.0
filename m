Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C5250D452
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 20:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiDXTBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 15:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiDXTBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 15:01:07 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C80E1CDC;
        Sun, 24 Apr 2022 11:58:06 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so11241766wml.2;
        Sun, 24 Apr 2022 11:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=iCtOCQWHiX/xlFjoQZZm7zNHXsIsvlDq5ZCs3vcgGY4=;
        b=kpU5P7Ba5gtT7izJKdb4Ez/MbAISOW3TQU48DD0z0s3GsUFeXcZuzCbP0Mh9UXgri4
         0wgacxqTprgvCoiLE9GPbFwhZSZI6QbId3HOdoqqK9eljTUhq9PeQ5tL98ZStDRCKzfx
         nCNnP6Eb5tjgMiPuVTnOjmpLmn6+D+uHKEWNYOQLnIKhQgpSki4dw0zcIfm/XWKwAp4S
         +cCttd8qkP2cETHSWQvl8ka5TAyP4EdCG9gz+2AYu/hA1jMhHJgWxRUMsQxyDo+AX5D1
         P9LWAZqomPSY2gmg9Txurk9RN9xHR5vgxeF02eYDs5o1BDPB6y6j/JMyoifbOiLSzo7V
         QLKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=iCtOCQWHiX/xlFjoQZZm7zNHXsIsvlDq5ZCs3vcgGY4=;
        b=CRwlQi0zb6NquCE/105VlLlxgoQPd6pepU1a3TqpwhI47D0Gwi829FsKgpCXVZaIXx
         9LEeaT92B4Dc/n2FHS5ORq5EsJYSwFYgoI+FBSWsdm3XQdNln2rlYAZV9szIzeJTTXYY
         Qw/+jrb0PO2c24lbGkkheMK1a5NM1CzO/EUJOG8G8/as7njx7mMEOG+h/q+C+zDAqyfE
         i9I99iG4chVgj2LwTmCFBQ6WPySYYUtHNtUwVF7brvfag2taxyL8SBzjc2PsCQEzIdKt
         /GtPmWuGkTSNJs5Q31du+eCGHe6Bw4IDtsng9PY9SAdhNLdwg5bFAa+oLYrEMwgsu/HZ
         8JpQ==
X-Gm-Message-State: AOAM5338DxCgbJorE5zhMK3cPgyFVSF4GiOa3ULLiDYAxy8XwdbXgXZ2
        sxOnnQuZUQiOXZfu8JEATGN8Wi5F6fDnpg==
X-Google-Smtp-Source: ABdhPJwJ8+eLp0eW7cJG+P9j/K3Q9gQltgkpghqKdjzQ9dgaFzWIYfaTBYtLvnSdN2sRYo9n7icTbw==
X-Received: by 2002:a1c:38c6:0:b0:392:a4f2:20b1 with SMTP id f189-20020a1c38c6000000b00392a4f220b1mr13533323wma.7.1650826684632;
        Sun, 24 Apr 2022 11:58:04 -0700 (PDT)
Received: from [192.168.0.209] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id d17-20020adfa351000000b0020adbfb586fsm862622wrb.117.2022.04.24.11.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 11:58:04 -0700 (PDT)
Message-ID: <ae612043-0252-e8c3-0773-912f116421c1@gmail.com>
Date:   Sun, 24 Apr 2022 19:58:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   "Colin King (gmail)" <colin.i.king@gmail.com>
Subject: re: ctcm: rename READ/WRITE defines to avoid redefinitions
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

static analysis with cppcheck detected a potential null pointer 
deference with the following commit:

commit 3c09e2647b5e1f1f9fd383971468823c2505e1b0
Author: Ursula Braun <ursula.braun@de.ibm.com>
Date:   Thu Aug 12 01:58:28 2010 +0000

     ctcm: rename READ/WRITE defines to avoid redefinitions


The analysis is as follows:

drivers/s390/net/ctcm_sysfs.c:43:8: note: Assuming that condition 'priv' 
is not redundant
  if (!(priv && priv->channel[CTCM_READ] && ndev)) {
        ^
drivers/s390/net/ctcm_sysfs.c:42:9: note: Null pointer dereference
  ndev = priv->channel[CTCM_READ]->netdev;

The code in question is as follows:

         ndev = priv->channel[CTCM_READ]->netdev;

         ^^ priv may be null, as per check below but it is being 
dereferenced when assigning ndev

         if (!(priv && priv->channel[CTCM_READ] && ndev)) {
                 CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
                 return -ENODEV;
         }

Colin

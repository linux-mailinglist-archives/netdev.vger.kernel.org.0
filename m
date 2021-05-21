Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581B938D19A
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhEUWf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:35:59 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:41645 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhEUWf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:35:58 -0400
Received: by mail-wm1-f44.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so5283124wmq.0
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 15:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kUMI2+VJBvrfyxF0TnZrFPg59JKRi9yHzzdOTmyJIwU=;
        b=RGlJ1ziJ09kmU+INK1WBNOkJxS1pmj1KoaCwEMR/2V+Fl1Olzu/t3/pE6u4+r25g6/
         bBwahR7kXawYymHhQ7JFeKNGqEZCTsuWRug0Ycm92m+sGJ2edk3P6h/k4o7KWoCQFGDG
         UVgVLNtqtreSus9em/IJsulINX7ZjDn7peFnfbAe/3mJHh1XEDk3DSIapsNjhDjJo1Ix
         fQWqGCrYA4bV57Cc2gdPtEfblIuEi0gVCjis1hzfd59HZ9OD/wOlgCxOBKVaEIBGPo27
         5tsoc3rcEfo3TODI5vm9OK+/0K9I1G+I+ruNN7aRqGLqAnDawTdQLR6FpcjzrKwxt/OB
         Nleg==
X-Gm-Message-State: AOAM530duRF08EgM1m/u14eGC0Rcrzf2B4Hiw0pe9c/tVUOYTZRJQiWa
        57dlbDBN9ZoRQwRPUWQtWeY=
X-Google-Smtp-Source: ABdhPJxPwE80Mrjced/fQhx+HqdZxh/zPfQGLdEHSgAltgc+RgEotDdkl7lO2158LySvsdlmQT5rZQ==
X-Received: by 2002:a05:600c:3510:: with SMTP id h16mr10257627wmq.38.1621636472746;
        Fri, 21 May 2021 15:34:32 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:66b2:1988:438b:4253? ([2601:647:4802:9070:66b2:1988:438b:4253])
        by smtp.gmail.com with ESMTPSA id t7sm3323970wrs.87.2021.05.21.15.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 15:34:32 -0700 (PDT)
Subject: Re: [RFC PATCH v5 05/27] nvme-tcp-offload: Add controller level error
 recovery implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Arie Gershberg <agershberg@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-6-smalin@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8343236b-91d6-a3d7-4abb-c74b993763d2@grimberg.me>
Date:   Fri, 21 May 2021 15:34:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519111340.20613-6-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> In this patch, we implement controller level error handling and recovery.
> Upon an error discovered by the ULP or reset controller initiated by the
> nvme-core (using reset_ctrl workqueue), the ULP will initiate a controller
> recovery which includes teardown and re-connect of all queues.

It's becoming an eye-soar how much our transports duplicate code...

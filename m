Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E30C9460
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 00:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfJBWdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 18:33:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44908 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfJBWdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 18:33:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so507639pll.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 15:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=seWAXIAs1FPFz6oCMNngh3BtQDrVTkWAqQbHDBoR96c=;
        b=lTBWj6dwLcb0HK2zVyaTrAGIUis/gVaD8gZvIWeXrVFw2tT6EmwLNMOvMgidEHQoiX
         O4jxrJffEzzEUkoLnbZJ8F1PQ9HDP/qGvqEM8Yx7CGFNBqPOV4/W8IcF4+8swDcpgZKX
         oT0xZ/j1rf54N8a6UcxVQPfbLe+6ZBRCaqiPUWswM3eX0RYDA9ucjc+7VqBpybCGeUHM
         IShh/KSNUm73ghgcSetkqM6aNePsajGXLPX2MMWSO7fUeG4XaHUxBYiFznU/a6xSyeYG
         M3ohhZGtewp37CFAcjCkbuuwfRY/+5uepJ1iTlTrhDchMCqidaTy7RVsKa7GnuakM91V
         Rv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=seWAXIAs1FPFz6oCMNngh3BtQDrVTkWAqQbHDBoR96c=;
        b=M45kky30wHM6a+cKMbLMnclNRYX4pVnc8yCRxzrPE+DpgcBFHjjBaHoTDumdPo6qq7
         wNIzk8QtSYCIDHx0noXBRVX3nh+ghVJUfzVnfYVSN2hC6yBVUuJy5EkmBRRw9mkhCn56
         CfCUcMpYyuliIfCDGaJaDNWJSC1UmSDQfOc+UckYLmvow4EPhXMxVIhM4CEIj1o+DumL
         YJ7sbu+oZz/gny3DhvYQLBMTPlTRzFcLoKm/+LU2UKTPc9xZTS9com2r0/7EEQ0p8YXf
         GVNimiaTv0mKIJdRO+0dY2ILetL5qTvB/nUd+3Lb7XfpUB5KjX9BUH6wOFeCxa6Ye4ef
         9lEQ==
X-Gm-Message-State: APjAAAXJ9eTZo621Hw8eJEHNe2FhCl+aeutGkX/Z2cBJTdHqsZ+Ed7hm
        +tTUsqsUNzIqFEKsl55zup0=
X-Google-Smtp-Source: APXvYqyi65331fmthBWrYgaZq5iymY4CrbOIYQwTtu4DXqDnd7I541P0wVjB4PKcDz+jR6lyUx5v4A==
X-Received: by 2002:a17:902:bcc4:: with SMTP id o4mr6017957pls.142.1570055618425;
        Wed, 02 Oct 2019 15:33:38 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r2sm491785pfq.60.2019.10.02.15.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 15:33:37 -0700 (PDT)
Subject: Re: [PATCH] tcp: add tsval and tsecr to TCP_INFO
To:     William Dauchy <wdauchy@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net
References: <20191002221017.2085-1-wdauchy@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <025bcf1e-b7d4-5fa2-ec68-074c62b9d63c@gmail.com>
Date:   Wed, 2 Oct 2019 15:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002221017.2085-1-wdauchy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 3:10 PM, William Dauchy wrote:
> tsval and tsecr are useful in some cases to diagnose TCP issues from the
> sender point of view where unexplained RTT values are seen. Getting the
> the timestamps from both ends will help understand those issues more
> easily.
> 

Reporting the last recorded values is really not good,
a packet capture will give you all this information in a non
racy way.


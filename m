Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8BE1438E9
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgAUJB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:01:56 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:43684 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgAUJBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:01:55 -0500
Received: by mail-lj1-f180.google.com with SMTP id a13so1870825ljm.10
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=afnx+B71cegV5q+X/wf5E0hqEyBS8gYxOHw2pHAP4kA=;
        b=gUtEqbH3wrzEHS6VY12SMMG7F1oEFdMbmxOnSmV4lxTFUJt2d5TlLqYNoOFecZufw3
         a477lxgVbqZX5rkopOK4Zc9Ce8D9w3bbijX36LD91VxAT/0/dMhB1THRgNYBGW/EqNma
         lCggK0dE6zrfQIfexStSjXp3gfgrJFHEzM+qXfoBqL5X8m25H9NeNOa0wk+O+nN0/DQO
         2OGq5nkoX+gGJIWoFhx+A6nmMLnmzVt4VcGSsSe2QV+OyUnSyeIISP09DKZYczpHLnFX
         Pmw/PVCQjRHpOakl2TWxyYhuXsY42mHETBVkoL+b/F7TIC5iBcaR0QNGIAIEc3zDEpAR
         jtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=afnx+B71cegV5q+X/wf5E0hqEyBS8gYxOHw2pHAP4kA=;
        b=Zb2OB/QzCRb9Wzmut1Vbc7pVjRR9RM4xIYC0PSCs5Lv7xQgN7BvZeh9KUD57alzM2M
         BokgbyTa/iDygJWpnZnROCi9T7eQNBjOs0C9jdl430wLA+esJBcXZtU+q14+XKxUsMi+
         VjPOx8FrK7NttfeSDltwbVSKi1zZ2M37l8KX/iT0LtQeKeAmjeqiCfBwy0SW+9ya3q4P
         6VxrEI/s0FBeBq5ToUN3hbTRZcYXbFuXnIyOYBGQRv8erdatFD81fJkk5cLoqEnzUofU
         LsbKDWNhsEz4MCbyH6pd3ynKZeLlDIDNo32P8QB3+i/2nuY59YtA+QgengQbQeMJDmMo
         HVtg==
X-Gm-Message-State: APjAAAWxR+mAieGbxcl4mgAw/wwSN/UIVWMT6e0PYBIp6rvjsfqtmJzm
        PyjlLbxeDneAmQddQASkSOPHkQ==
X-Google-Smtp-Source: APXvYqyMnIQZDBbTNeeLyMo1ILlAA3ZNKrbHRjmpJy1YuY8TagG3jH62uv3BdLWZpWLfJOp8iVr43g==
X-Received: by 2002:a2e:916:: with SMTP id 22mr15885841ljj.60.1579597312835;
        Tue, 21 Jan 2020 01:01:52 -0800 (PST)
Received: from ?IPv6:2a00:1fa0:4257:4d38:8de3:4197:be8e:7729? ([2a00:1fa0:4257:4d38:8de3:4197:be8e:7729])
        by smtp.gmail.com with ESMTPSA id 195sm18030740ljj.55.2020.01.21.01.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 01:01:51 -0800 (PST)
Subject: Re: [PATCH -next] drivers: net: declance: fix comparing pointer to 0
To:     Chen Zhou <chenzhou10@huawei.com>, davem@davemloft.net,
        mhabets@solarflare.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200121013553.15252-1-chenzhou10@huawei.com>
 <40eb3815-f677-c2fd-3e67-4b39bb332f48@cogentembedded.com>
 <86f4d4a0-627d-84aa-c785-4dac426b7cc6@huawei.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c223c347-4c19-176f-4626-b096c12c0558@cogentembedded.com>
Date:   Tue, 21 Jan 2020 12:01:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <86f4d4a0-627d-84aa-c785-4dac426b7cc6@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.01.2020 11:54, Chen Zhou wrote:

>>> Fixes coccicheck warning:
>>>
>>> ./drivers/net/ethernet/amd/declance.c:611:14-15:
>>>      WARNING comparing pointer to 0
>>>
>>> Compare pointer-typed values to NULL rather than 0.
>>
>>     I don't see NULL in the patch -- you used ! instead.
> 
> Yeah, i used ! here.

    Make the patch description match the diff, please.

> Thanks,
> Chen Zhou

MBR, Sergei

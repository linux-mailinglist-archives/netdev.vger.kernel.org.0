Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12249332F5B
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhCITyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhCITxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:53:40 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F3CC06174A;
        Tue,  9 Mar 2021 11:53:40 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id y131so13419258oia.8;
        Tue, 09 Mar 2021 11:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xlm3NXLS5y/y/m14R+0UIQSq3jLijWbnK89X832gUiw=;
        b=UfM72oRmW3ndgJT2HO0oPS5J3WGJDysd2sT8n0uYHd5JnkWZ8iQ8LwlkLfiSMFDO5j
         BOXEtIshEk1wLYWJRukYRIcEpzGhipSql9Bf4EDkQ3o2HKzuCzJM9iJD9sJxl3KjcSWH
         CUQfGysXPIM/8GSSNM815MYb8MhosjbbeiLCni7M1mGj5b4xXx87SjYPUw7vzA2dawS1
         +BeYci5UnvJ0vPFIzdGZx0ig7gBmGBy8ZGkYhHYj+zywq2PP6YivLJ1tJdZB0YqvAP5F
         B1BorM+eQsG0LZWuC8X8/ROm10ttR+hYf2MqSb6g6hymUWnWybjC5psydCdsT3UkYJ42
         ArkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlm3NXLS5y/y/m14R+0UIQSq3jLijWbnK89X832gUiw=;
        b=L7V06MKDSoLQN/9Oqr9R1lGO0HA2Cji+diZOb6PV2Y4BCY9e19f6EHmUGnIhOtm6Yq
         SthWb5xpB3cCkOStS+lMSixofXDqT7xyRQDHsPtrwQ1ZfjqwQGyno66s0DIo50ChZS4m
         mudLyyN9ond5244n1/1L3OWqh2XQdDxaECyzDnbjXuG7QHDXd5M+D3ykQDTY91qPhcDp
         f0bHqA0MKie1y/uoHTX9p3zL/3zQ1asyLvhA7vl3A29sBH29bALLWprQjCHj2jUCJL8g
         9cfYVF7qp/cEnDZe99cJnQxI0TcO4c/J1NgXIJDyjTlBAVt3XnJfF4j/oFZ2XGlIYA+z
         SD/w==
X-Gm-Message-State: AOAM531VCMx0eRdF6Ey2ZbL1HlHIfwh71Gn8ZB3GuC6aybo2+KhFc0KT
        A9hte+02UWEy+QyXoNCk20epMGqNCW4=
X-Google-Smtp-Source: ABdhPJz4YNH7lhuHvJWo2XLQk4wBGRpx2GYdQuivjeczEVB14ZW4re3KcqXw/4BXIkV8QewGIVcNDQ==
X-Received: by 2002:aca:4486:: with SMTP id r128mr4082901oia.171.1615319619686;
        Tue, 09 Mar 2021 11:53:39 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id p67sm3288625oih.21.2021.03.09.11.53.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 11:53:39 -0800 (PST)
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     Steven Rostedt <rostedt@goodmis.org>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     davem@davemloft.net, mingo@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
Date:   Tue, 9 Mar 2021 12:53:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309124011.709c6cd3@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/21 10:40 AM, Steven Rostedt wrote:
> The order of the fields is important. Don't worry about breaking API by
> fixing it. The parsing code uses this output to find where the binary data
> is.

Changing the order of the fields will impact any bpf programs expecting
the existing format.

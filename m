Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39CB21DC55
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgGMQb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729933AbgGMQb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:31:58 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8456C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:31:58 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m22so6239896pgv.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4QwZoNHRkfKA0ubGi9cAcFp3Rkw4x6gY2IANWQN2yVs=;
        b=RwDrX9BPquxZHYIhyhDTmN5LQTD8zYWm31TBW5fzNHawEV7jofYlG3gvpkmUzgfnvW
         uofdlWif2TM0IX9r+DA9QH/L/QBv7fn+BL0zIHVpb+ovqMsC7i5sHbb0++bGefF8/cfI
         P5chzSUA0MZOiDPOeirc75EHcRvSI6x5z5CBwPnKmOnecFhuHQ82RaUNU0jVPWjUn/99
         VPqyr56bPEhHlvnxSC07fJ4V1Ql+6irFNAUW0J4Pbz7JRVgds6gbNp245UyyK2hJE3eL
         24IfzibbQhGV/ucj61Oy0Lpux44+vkpMZiSU0Sk+xpRunqvJSYV49K619IxbhbMp4Zr1
         N8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4QwZoNHRkfKA0ubGi9cAcFp3Rkw4x6gY2IANWQN2yVs=;
        b=kXseTz6M/+sw9bgd/0jhHeDJr0Ae+oH0VMG0g5G3dwO4KgC1Q2O5w7Le4VWGe1Pp8M
         Grv2Nmy8gvIBKorztyy/ZLT0D8Wz7QcdfYj+cOIPvtbu0WYLeTFqqRHTxUxsoAsdc2LP
         Zt6ydD0YsGESjjJ2cRGAnO7UvrXM4IUAjfGqEgnnSCMyPBc/dnn/D/RyrcYZea6/k1he
         ojBT5f6ukCOnrzBDwjl/DKfhheH4S5yo/FnCCYTK+IBeb54C6FBn4c92qJsLes5t2L4N
         i5tfmX8mX3wFtGUlazxoMt8mQrj1+TDGNC5CsMzAztzYab/+CuaS+ZhJ192UDHRY8L6b
         Sb3Q==
X-Gm-Message-State: AOAM530XBfBpw3olM8+DU2xjZK3UcTDrJUw3pKvWb0kpQJ6pjXJnPNmf
        sK4ef3T0EvHzZYvWWTWzwBLcHAUu
X-Google-Smtp-Source: ABdhPJwE0l6SRydoEonT/M8Usr35m096h9tZtwnsL80r6kJ6yZwPDLjt/h9BsOnjvxpaa5U1uIMCOQ==
X-Received: by 2002:a05:6a00:f:: with SMTP id h15mr602144pfk.193.1594657917977;
        Mon, 13 Jul 2020 09:31:57 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o4sm91896pjo.16.2020.07.13.09.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 09:31:56 -0700 (PDT)
Subject: Re: [PATCH] ip6_gre: fix null-ptr-deref in ip6gre_init_net()
To:     Wei Yongjun <weiyongjun1@huawei.com>, hulkci@huawei.com,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20200713155950.71793-1-weiyongjun1@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <214b051c-c669-61c4-cd3e-5794334c7522@gmail.com>
Date:   Mon, 13 Jul 2020 09:31:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713155950.71793-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/20 8:59 AM, Wei Yongjun wrote:
> KASAN report null-ptr-deref error when register_netdev() failed:
> 
>
> 
> ip6gre_tunnel_uninit() has set 'ign->fb_tunnel_dev' to NULL, later
> access to ign->fb_tunnel_dev cause null-ptr-deref. Fix it by saving
> 'ign->fb_tunnel_dev' to local variable ndev.
> 
> Fixes: dafabb6590cb ("ip6_gre: fix use-after-free in ip6gre_tunnel_lookup()")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

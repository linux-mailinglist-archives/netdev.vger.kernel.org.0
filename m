Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EFA278AE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 11:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfEWJCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 05:02:14 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41094 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEWJCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 05:02:14 -0400
Received: by mail-lj1-f196.google.com with SMTP id q16so4711493ljj.8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 02:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gj20cOvCKG7FD6jjJZtVF7qSWx9DiKga9phOOUa5uL0=;
        b=EuoySJLXx37Ig1+YyIG4I/3BaQIryrpMyTLOmPHVFfrljh21Kk/gfRyCqL2KRfePZs
         WMzxC70vK9qld+zfU5f87R+8E9i4CYMZYPzyqzZRD/I9tcQY5MN/Nmk05X5MxxxBzUZI
         N8IoXckh1XX1bkvlY5310s2DxqypJ6QtFwxaB31LjPLSgfVzeArJHigGqXal7Rukzyns
         ldmV27ywrVB7Yv7BYzWKGNhgLyVnl985TWcjIFHPdzY0jttTUE0ayLB7GWjxhqexGnRi
         HBT2d1E7Fquudb/RFmE9vTA4z5/6tKQMY+IV6321ZPnZFZdyh2PeruJZdKvJhVs2vQQZ
         1mQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Gj20cOvCKG7FD6jjJZtVF7qSWx9DiKga9phOOUa5uL0=;
        b=S5g8NfA/c2z7ynpvHxjKYsFjGcfOr2Bg1VYF+2UZCBrSc03yFktsx1or7ufBIprOey
         WLU4AyBOJLc20Il0GsXaM1DO0aj2maX2DhRNNkC2iMAbcbm5ZqZ921vzec3un9tLi/Nq
         TISwwSgi9twrYqQqeYamMbgx01BddXTselnWEc/ZIKg1ByS8CE8vh8XNylzG6qy+R83N
         Y1qZjdGt8013IfDq04u5pbQ/eXQ7/pndmKmFRUkRDip8L18bBgKQ8k1v0b6JRzsGnDbv
         meJahwwBpSgDdUmt2rSBld+qF6cOD20Jszb4w7jGN0xjzNpGq8cLGvxp9VGZnpYGmMwS
         XkWQ==
X-Gm-Message-State: APjAAAVG7qJ7lYEpCYDBwHD23lVdaORdbcjuQZbI9XC75/DyShEumunT
        c+t5EgcYlJE70kaVsZ0WUpmKIA==
X-Google-Smtp-Source: APXvYqxPaMVeCackWtR3g29FOBmPiAoKz56PxWB50NRD/oRvnQhsmUP70kx+ZRAOaYMkgO0PT7HeFQ==
X-Received: by 2002:a2e:8516:: with SMTP id j22mr18222831lji.119.1558602131959;
        Thu, 23 May 2019 02:02:11 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.169])
        by smtp.gmail.com with ESMTPSA id p78sm5847549lja.95.2019.05.23.02.02.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 02:02:11 -0700 (PDT)
Subject: Re: [PATCH V3] hsr: fix don't prune the master node from the node_db
To:     Andreas Oetken <andreas.oetken@siemens.com>
Cc:     andreas@oetken.name, m-karicheri2@ti.com, a-kramer@ti.com,
        Arvid Brodin <arvid.brodin@alten.se>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190523070238.17560-1-andreas.oetken@siemens.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <1ce497cb-f121-7f73-e39f-a0474a33bc90@cogentembedded.com>
Date:   Thu, 23 May 2019 12:02:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523070238.17560-1-andreas.oetken@siemens.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 23.05.2019 10:02, Andreas Oetken wrote:

> Don't prune master node in the hsr_prune_nodes function.
> Neither time_in[HSR_PT_SLAVE_A], nor time_in[HSR_PT_SLAVE_B],
> will ever be updated by hsr_register_frame_in for the master port.
> Thus the master node will be repeatedly pruned leading to
> repeated packet loss.
> This bug never appeared because the hsr_prune_nodes function
> was only called once. Since commit 5150b45fd355
> ("net: hsr: Fix node prune function for forget time expiry") this issue
> is fixed unvealing the issue described above.
            ^^^^^^^^^
    My spellchecker trips on this word. I think it should be either 
"unveiling" or "revealing"...

>  Fixes: 5150b45fd355 ("net: hsr: Fix node prune function for forget time expiry")
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens.com>
> Tested-by: Murali Karicheri <m-karicheri2@ti.com>
[...]

MBR, Sergei

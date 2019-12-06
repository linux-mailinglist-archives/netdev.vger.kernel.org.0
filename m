Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C09115715
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfLFSU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:20:27 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45658 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726298AbfLFSU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:20:27 -0500
Received: by mail-lf1-f66.google.com with SMTP id 203so5924712lfa.12
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 10:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NWA7Hm1QCINXEdmEGTShA6DEHthN8DWdmaUCREKAGzs=;
        b=i1ucLhfVARra0gv/V9NArvgGqFWH0KxmGAJgpo9f1R9pmrgtUsVlSQkuh2Yu3mrBR7
         chpKnqclRfeq9+yUAIQzjlKj0WS5OWUERwaP/18n+k2qvn2/oBsUIBEBqZsLTDoKYAtz
         kThR/iIt0bwoydldyuuaxFQxI4U0Vz7hqN6nWlfwR8EpcWbZwHq2mRus4mAXhtf7xQUa
         PFRnb/BIuOkhQ4h2LmSOe8pSg8NBs2HZ4gg6+FIaqgWChKB9JTAdUmCIZ5xGgj+aGXBu
         7dsF0HHrByhvZ7qeqcwDrIY0RL75QlN5qofknw1OpMAu2iDzQtVSoeWvBFD5CVxnzE/9
         qjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NWA7Hm1QCINXEdmEGTShA6DEHthN8DWdmaUCREKAGzs=;
        b=dwKN4tTiOpdByBgsjt2/YJLcmBopZrmaSuG/sEUMXBEuuv5tl5/8aEHpbFr8d6sLph
         fcpKmGcZfeltLgbn4WHvTqs4fRZGx5uolPc9l4IIh+NZwMT/SRMkGERrlZw0eezTRJpf
         99n4ujZ+xOv+6VAcN3eorVui9Wywy1ly9/LGjlQ9hqR75TqEB3pryXsBKmZt684zQZAk
         rC5U60Vw5q/dyhejPNZvGXjYg2Kde6KsDGHrAPNc1IZj3fP2lzwcTsnymaEBMaMvRdnI
         fACuvHl2fzH+pQZuwe2K+ihrBBx5IqgD8fyOEsUx0l+4V+jUbvGS09vNz6wlqM9cNTY9
         t0HQ==
X-Gm-Message-State: APjAAAV+DFIQrdrZ3uoxoJ6gYh1ISJvkd/Foisis2ckwW9kcma6FQW5B
        +cT1kseWbJaW5BOHeVvIhKwKdwC79cY=
X-Google-Smtp-Source: APXvYqzYkVyqcTZ0NIjD2ipMsRXWnliOt9ETaM/AMtM0RLbpqN42IfDXo9jC/roCjckmAKczvP6Isw==
X-Received: by 2002:ac2:599c:: with SMTP id w28mr8831541lfn.78.1575656424879;
        Fri, 06 Dec 2019 10:20:24 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:4291:257c:a228:1c89:88a1:5b3b])
        by smtp.gmail.com with ESMTPSA id a21sm6948315ljn.76.2019.12.06.10.20.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 10:20:24 -0800 (PST)
Subject: Re: [PATCH net] net: netlink: Fix uninit-value in netlink_recvmsg()
To:     =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20191206134923.2771651-1-haakon.bugge@oracle.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <13b4ccb1-2dec-fc4d-b9da-0957240f7fd7@cogentembedded.com>
Date:   Fri, 6 Dec 2019 21:20:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20191206134923.2771651-1-haakon.bugge@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 12/06/2019 04:49 PM, Håkon Bugge wrote:

> If skb_recv_datagram() returns NULL, netlink_recvmsg() will return an
> arbitrarily value.

   Arbitrary?

> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> ---
>  net/netlink/af_netlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 90b2ab9dd449..bb7276f9c9f8 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1936,6 +1936,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>  		return -EOPNOTSUPP;
>  
>  	copied = 0;
> +	err = 0;
>  
>  	skb = skb_recv_datagram(sk, flags, noblock, &err);
>  	if (skb == NULL)

MBR, Sergei

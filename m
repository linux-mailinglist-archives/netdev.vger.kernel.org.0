Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4A7FCFB7
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 21:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfKNUfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 15:35:15 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46422 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKNUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 15:35:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id r18so4494920pgu.13;
        Thu, 14 Nov 2019 12:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7eIuVEfDEJJlU6LExU42oMv+qcMlmPd5kzdWLOnhcns=;
        b=BHdkng2AKGa70jl9ATGv/uVXkG9XQyEAAGPiFImo6N57XhDbrS4cFj8NFaEXJcT1sh
         mG/GlKLiL9PLmMcogYx+PZ5BsuD/0qQe7wJWTpHnhR+o2SZ9ssWJQcwnseiGB3LDxdj8
         GrLQLcq5uFjvEE8EdJhG4jWb9KhhRYg5shlzHI2olcJDl7DXjNRk8GVoN+I4XQZ+1nU3
         910vXgRA47XX23Lqk1bwMpfolFcob5hpyUU4p0AGMCRm38Ys/qS8Yiay5Wh6zk958h4j
         ycavw2IiXiT4zCKNFixIRg3xn1UBqy7rNjrPi/9S0N/ooKWvsxj+odT5yJMGwsKBqZZx
         S2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7eIuVEfDEJJlU6LExU42oMv+qcMlmPd5kzdWLOnhcns=;
        b=OcccaiH8pFXegOn/03l/MqW6saf9BQAHBrxcyB5Rwn8KY2ZrGrm9+CxoroE+PeB4H6
         pWvZSbQY/UU/WXx1vn6YUo9GRmlVR0SnCBhY7X8fNo4dVPpXNMlZPjtu8nATSA0fZW20
         JgEf2Q38eTS1qUIzIAmW5M6K9hVp8/HY/828bDqf8heJxbNCaW/T6+YXXvnRZUwKOUNp
         FaO1AhsQWlrqJ9p4V3p2c6KiSozg7bEfGra8BotXe9cJDUj1DwAuLP0EKnbjRcU3w1kR
         WcxPISeStenPxLgwC5LXfVccAGWSX/SjelkBVh24KR6KYjSNn4ASihih8un9OJ9j6cZk
         soEQ==
X-Gm-Message-State: APjAAAUVztuwiRaeGVYS+z/Eu2I9fIp+iizkirkGacGYN5zHMYcA56YU
        menxbHe6BqDxZR4VA7CltmE=
X-Google-Smtp-Source: APXvYqy8rkpc4eLtkYpuYbQRHMHY34UeOMRmcmk8Apqk4hI2/e3Lt4EDww+/WyOxqJZkxsea1LNhhA==
X-Received: by 2002:a63:a109:: with SMTP id b9mr10270430pgf.227.1573763713964;
        Thu, 14 Nov 2019 12:35:13 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:cda8:1a1b:b325:49cc])
        by smtp.googlemail.com with ESMTPSA id u24sm7326034pfh.48.2019.11.14.12.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2019 12:35:12 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip link: Add support to get SR-IOV VF node
 GUID and port GUID
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Danit Goldberg <danitg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20191114133126.238128-1-leon@kernel.org>
 <20191114133126.238128-2-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3cf565ce-6170-e632-a004-7ef03c40c6ea@gmail.com>
Date:   Thu, 14 Nov 2019 13:35:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191114133126.238128-2-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/19 6:31 AM, Leon Romanovsky wrote:
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index b72eb7a1..ed72d0bd 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -484,6 +484,29 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *ifi, struct rtattr *vfinfo)
>  				   vf_spoofchk->setting);
>  	}
>  
> +#define GUID_STR_LEN 24
> +	if (vf[IFLA_VF_IB_NODE_GUID]) {
> +		char buf[GUID_STR_LEN];

buf should be declared with SPRINT_BUF; see other users of ll_addr_n2a.
And, print_vfinfo already has b1 declared so you do not need a new one;
just change buf to b1.


> +		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_NODE_GUID]);
> +		uint64_t node_guid = ntohll(guid->guid);
> +
> +		print_string(PRINT_ANY, "node guid", ", NODE_GUID %s",
> +				ll_addr_n2a((const unsigned char *)&node_guid,
> +					 RTA_PAYLOAD(vf[IFLA_VF_IB_NODE_GUID]),
> +					 ARPHRD_INFINIBAND,
> +					 buf, sizeof(buf)));
> +	}
> +	if (vf[IFLA_VF_IB_PORT_GUID]) {
> +		char buf[GUID_STR_LEN];
> +		struct ifla_vf_guid *guid = RTA_DATA(vf[IFLA_VF_IB_PORT_GUID]);
> +		uint64_t port_guid = ntohll(guid->guid);
> +
> +		print_string(PRINT_ANY, "port guid", ", PORT_GUID %s",
> +				ll_addr_n2a((const unsigned char *)&port_guid,
> +					 RTA_PAYLOAD(vf[IFLA_VF_IB_PORT_GUID]),
> +					 ARPHRD_INFINIBAND,
> +					 buf, sizeof(buf)));
> +	}
>  	if (vf[IFLA_VF_LINK_STATE]) {
>  		struct ifla_vf_link_state *vf_linkstate =
>  			RTA_DATA(vf[IFLA_VF_LINK_STATE]);
> 


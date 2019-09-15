Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAAFB313D
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 19:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbfIORrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 13:47:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37366 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbfIORrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 13:47:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id c17so10360014pgg.4;
        Sun, 15 Sep 2019 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DymZOsRdSbzSVjkZKItxQtg0uUh/kzK5sLQpj6nXXUk=;
        b=dqYVOffcaDqIErTQxythwiDt53eFka0+DgGatxS4VIKK85+BuZuXSEH6h2NlTAlreT
         QVdtcNPfOQHf/vZ9cTN8gB1WOPEzFLyK/yT9pifbDI19EtrbOjLZUAWfMWannENr/0qC
         qdI1KSYua3OPKKMTDLjqxTazVi7VscCmAANw1eI4mKdZTb0NZ0ssm56yAYOEiP+AcZ7v
         7iR3h1QX0WqSlFPqGpb3A5ta/lmNzhezHw+7mQCZ7oFmndTqQFbJGP91AdbPzT12o01w
         IYaqrDg7Eg5KhN/Ul5GG2bqKtoWtAZ7lkBKZeNqyx+WFE0CRvYTlZ9M8DCbS+Cjqvy98
         /0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DymZOsRdSbzSVjkZKItxQtg0uUh/kzK5sLQpj6nXXUk=;
        b=NtcoI3pSCzDl/MOMOyJKLLHXg+ZqlmPYLeMsAYtFBSpYArDfACHN/AK4hXHqifj8h4
         qNMeYBpPLbfJ3LL1plka4F73cYbdJYBimtyvZcUrVQA8Yi6L4f/bHXXis3ysbSYZclMe
         zutSqFlcj6uz5n0VTVx9/uNqsNOSSDqANgoFOl5tjU6SrmQR99XzmooKbUPVpBzJgk9X
         cvi/BGQ62LoxJE/BMe5HINMumVzwN7aEWHRVSBLTAN6W7a81v5J4pn4w/xF284ZEo4Kt
         x4C4DPCMhPBt93r5hWrKrNB7ybbPr+QUMnSBpn0VStCsG81pjG08/NktUE3GAz+3GKuc
         lDoA==
X-Gm-Message-State: APjAAAWeV/B90f0WsPs8vLsYK8NyVmW38CUYJDsZdnjXn8bM/ePGlxLr
        19jx7nQ60tJZQkDElRz+USE=
X-Google-Smtp-Source: APXvYqxhuPwAFJ3/Nq3KF3A2u7qUvy64cF95DNt7CxCKVLgVtnM7qKcgEl6EfbB7LLWkDMjKdhr7aQ==
X-Received: by 2002:a62:168e:: with SMTP id 136mr67481911pfw.144.1568569641927;
        Sun, 15 Sep 2019 10:47:21 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id ep10sm9305667pjb.2.2019.09.15.10.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 10:47:21 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] rdma: Check comm string before print in
 print_comm()
To:     Leon Romanovsky <leon@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
References: <20190911081243.28917-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <241c3bdf-53bf-a828-c57a-034b16f4839a@gmail.com>
Date:   Sun, 15 Sep 2019 11:47:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190911081243.28917-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/11/19 2:12 AM, Leon Romanovsky wrote:
> From: Mark Zhang <markz@mellanox.com>
> 
> Broken kernels (not-upstream) can provide wrong empty "comm" field.
> It causes to segfault while printing in JSON format.
> 
> Fixes: 8ecac46a60ff ("rdma: Add QP resource tracking information")

that commit is from 2018, so this should go to master; re-assigned in
patchwork.

> Signed-off-by: Mark Zhang <markz@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  rdma/res.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index 97a7b964..6003006e 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -161,6 +161,9 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
>  {
>  	char tmp[18];
>  
> +	if (!str)
> +		return;
> +
>  	if (rd->json_output) {
>  		/* Don't beatify output in JSON format */
>  		jsonw_string_field(rd->jw, "comm", str);
> 


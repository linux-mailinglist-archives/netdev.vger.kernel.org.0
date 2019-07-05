Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3418360974
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfGEPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:37:57 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:43233 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEPh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:37:56 -0400
Received: by mail-io1-f68.google.com with SMTP id k20so19930120ios.10
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lOr9WynCRIVjZxMowKGtt+hDolLK7h0Dax9Syp7GuWg=;
        b=U+1qmkBflWYpk+qlwGgw1IOxZHTjTAWjgxlnxqIsZ+8nnz+PpfhF9Kn74s2q+uPUFZ
         /ptLH7q0gdrWYeFR5VCDMMsTRV26VXyZDYWaZeu/g5Xdz0ex55YTjNnjwL1XTU7kDijB
         ZsiTuTlJcQfeFP0VQ8Lvuif5ac/1nkS/vViTPFwkVwpl2QZfuWWHhWpAJzrlVG/7adSX
         OWSCpdpMjTCzH9LYvhxooPPQnY856FzTVaJbvaNuV5As+qEKqRpZG3wmU9ID9qySrzG1
         OBzP44DOxM7JSo7Oe0ZIYSQ6WhZySMgYf8m+SGiw5k+VOMgyZPpCZ3gvyiQvx806bSzE
         TPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lOr9WynCRIVjZxMowKGtt+hDolLK7h0Dax9Syp7GuWg=;
        b=q2hMUNRqANpc9KTRrlgBj5OklMGlbO87sGWq2qdJtcbggJ8D1CJkJfuRwA8qpRzHf5
         0ECX+CrT124S7HuZpIrecVZFbFo1YRh0YwN/bkIqg+I/qkjzO/l5A908Toy23c0j7It3
         1r1foLPxOLalVQeSl+zWgF8HS1MfF1WqJPSW7Srq4Eu8snnON6gNfLNwoWkwJVaM39Fc
         RKrgR3PEx+ff7gCSIB94FHPU0259PWcIoMDGDsUVoJCECXVEJkgSDRvuher+lcXwMrDM
         LWxpdXANhGtxhtlUL6BaulXvoHQnZzDlWuR/5VsqS61cxZmbRt8Vi38fcJ8eyaOFsXRy
         BT5Q==
X-Gm-Message-State: APjAAAVJQBTRHEgs+FU8tmjF6Dob35Aw84vqlZPQCgoul3AGU4br8Zi0
        SowxQwHkpaQwt50AOh3xew8=
X-Google-Smtp-Source: APXvYqzu9rRVthXkcrZec8g4KFY4Y2N+ENBOIBhtk5METk6tYq1CgLl6WFoFKa073YW6gU4KTT6RWg==
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr4878645ior.231.1562341075633;
        Fri, 05 Jul 2019 08:37:55 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:5078:a90d:5ed1:4862? ([2601:284:8200:5cfb:5078:a90d:5ed1:4862])
        by smtp.googlemail.com with ESMTPSA id h18sm6656445iob.80.2019.07.05.08.37.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:37:54 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: Fix NULL pointer dereference in
 ipv4_neigh_lookup()
To:     David Miller <davem@davemloft.net>, idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
References: <20190704162638.17913-1-idosch@idosch.org>
 <20190704.122449.742393341056317443.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dfb3bb3c-c077-7b8f-75e9-4185d997b024@gmail.com>
Date:   Fri, 5 Jul 2019 09:37:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190704.122449.742393341056317443.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/4/19 1:24 PM, David Miller wrote:
> From: Ido Schimmel <idosch@idosch.org>
> Date: Thu,  4 Jul 2019 19:26:38 +0300
> 
>> Both ip_neigh_gw4() and ip_neigh_gw6() can return either a valid pointer
>> or an error pointer, but the code currently checks that the pointer is
>> not NULL.
>  ...
>> @@ -447,7 +447,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
>>  		n = ip_neigh_gw4(dev, pkey);
>>  	}
>>  
>> -	if (n && !refcount_inc_not_zero(&n->refcnt))
>> +	if (!IS_ERR(n) && !refcount_inc_not_zero(&n->refcnt))
>>  		n = NULL;
>>  
>>  	rcu_read_unlock_bh();
> 
> Don't the callers expect only non-error pointers?
> 
> All of this stuff is so confusing and fragile...
> 

The intention was to fold the lookup and neigh_create calls into a
single helper.

The lookup can return NULL if an entry does not exist; the create can
return an ERR_PTR (variety of reasons in ___neigh_create). So the end
result is that the new helper (lookup + create) can return a valid neigh
entry or an ERR_PTR.

When I converted ipv4_neigh_lookup and folded in the refcount bump, I
missed updating the above check to account for ERR_PTR.

Ido's patch looks correct to me. Thanks, Ido.

Reviewed-by: David Ahern <dsahern@gmail.com>

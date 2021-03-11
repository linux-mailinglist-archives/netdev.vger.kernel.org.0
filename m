Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A283378B7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhCKQDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234436AbhCKQDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:03:39 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258D9C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:03:39 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id r24so1905764otq.13
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q6sHxGOeZdmiJF0yxH6kv84/GWb2q6Fo2+gEedENGvI=;
        b=YBxiu5CJhGRSHmTx6oYrKtCQ9i/un2ShRvs6pTKYjfg/W94RtLSwJiDc8i++9MzuC5
         YlqUfmKWkE1/C9ZVAYmLsOhf3SwC2x/ErSwh/w7AyA65et40NkkYweI3bkVbOjWs++G5
         Zd8Oqz9uBFhOSrKHguTqdeFaxV79363miRWKwAYv0hdg5d9H622xmCpykYQROcAqJYOz
         1uGe76jB8J9H9n2cC7m8TTcns7v2vNrYPbuozefyBP4AwZjDOqCNApELTeNgCRQpjUCi
         G0UHAcqATXmL/h3luyoJSqHzVpG6UNaWl0J42zEYMMDa+HF0H1PE/BLa9DXgxdqfGPBZ
         Chfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q6sHxGOeZdmiJF0yxH6kv84/GWb2q6Fo2+gEedENGvI=;
        b=c2OmYI3Ua5f90P6NWjl8KOPLcAcgQN4ZZadiKq8dqaHjtZ/crws0IR9OA/kFF/V4Ui
         kBgU9HxCItmb8+XitJLAYDQHhw3/ElB0q86a9XqyNKKvpZsHfQ+eq63EgQtL6DZRUz9X
         4IWTDkh4SgnRwe5NYpo2AUQ8HeBCRD1pyC8o+Xt2Yl8OuOySmvhgYVGLe3tiBih0A/2e
         HiD1IumNXWVUKmb3sHF+eFWNVjfRwtNdiue/3PySS5qRuaFte7DyyEojv6RNig2v3lm/
         VScWZqPd/PKb5eUYi5bFmzNkzqY5yByaRyWbnpXppylyJoim6amrSdJOGvdgF9HqjQ+W
         wjcA==
X-Gm-Message-State: AOAM5334yMKTzdIGm7HuGOvuftHirLKINktw2U9Ja7RUrufxYjAhqwc5
        jWOQlyNFH+MwVp2aKHEYJMEfT6xZt0M=
X-Google-Smtp-Source: ABdhPJxiMFlS+1mXLK0h2uWCI8DUle2m7rfLWDsZG+NGSmsAoxr4SCUmp8pQHeWCgjYKU6PJDDxJmg==
X-Received: by 2002:a9d:146:: with SMTP id 64mr7534552otu.346.1615478618486;
        Thu, 11 Mar 2021 08:03:38 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id r22sm719659otg.4.2021.03.11.08.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:03:38 -0800 (PST)
Subject: Re: [PATCH net-next 08/14] nexthop: Allow setting "offload" and
 "trap" indication of nexthop buckets
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <4cc22b59374344b666221f792a28bec597833047.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e84df797-6dda-27fb-82fd-c354c7a741fc@gmail.com>
Date:   Thu, 11 Mar 2021 09:03:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4cc22b59374344b666221f792a28bec597833047.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:02 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add a function that can be called by device drivers to set "offload" or
> "trap" indication on nexthop buckets following nexthop notifications and
> other changes such as a neighbour becoming invalid.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 
>  include/net/nexthop.h |  2 ++
>  net/ipv4/nexthop.c    | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



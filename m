Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3388C42DB72
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhJNO1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231822AbhJNO1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:27:44 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0484BC061755;
        Thu, 14 Oct 2021 07:25:40 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id d11so3677475ilc.8;
        Thu, 14 Oct 2021 07:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QJz9iKEYjLkvnohegmb7OhE4Q0yJM75wDXbwCysCHKg=;
        b=GPdq700XJHjt2qiWViNuqJqrk/DO/7SBzqRCqEPU6DJsnh3GWiTMGrlV6kiZ0fbgId
         0ZZd/MMeZARaRLlLyGCFM51rOzsRGjPEv5AqH3Padwmaq4MvctIGfABm5apZ/KaeDJ/H
         6DTlvH01d3QQOPP4RkT4B2GuM9qL6YtHMuTYTplGXSKOZ0Lu4Jvj5S+ZGSy13klnCstG
         mbxE7sUjT5oQKhnqhXQKs3imYQbxoGxISfpx/x0zFsxqquZpwwHVqMDBvPe2TobaJ6oI
         u0fDNbAt8DsqPHjsSeVkFNHEIwgFWi5Uk6XB5OIapm8E1/zyFFgLk4mtCiz5ii6Itj/C
         qyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJz9iKEYjLkvnohegmb7OhE4Q0yJM75wDXbwCysCHKg=;
        b=56xSDDs7+1BGr1g2HrWbxuwyBmLxFy3eeNGhGiM+AOg2c5aBfj2Wsv4Jfp9Qnr5siw
         xOsggIwtaj4gIuZ1lHVaCSRUUKpYmLJoCgoegxEGbz70x81xFNzO4cCmaJV6F6POjIIM
         K+BR5LtJ2b6VE1qEL9K8D0ZxNZN3d3wmBCwcNkr+qJajM+h+dOn7j/STlQNWT1kzDw0H
         guOKz0M21wj/G+ExCHzPU5j0dxCo25gjpyTYqsC69jMb8wswjVMf7WVCI41fqVIiobXc
         /4SS1jXN3C0CtAdP5nAmRRISp9i1huKiCd2w0zBCxZ8YhcyRD0gVW8JNTFxU4QXsJTg3
         MbGg==
X-Gm-Message-State: AOAM5331Nah3w7lyClq3XLR6g7PQHCG3zsnh2QGBySyuN1qKAOMCYfcH
        lD6ejf27EtRZzqta7caJ2h3QHynJNpI0fQ==
X-Google-Smtp-Source: ABdhPJxgq6n8iCh1QzlDPAihbw0Bj2jCddYElmLNwMhp/CvYVDZEXPedmg2KWfaKgiY50ZA4z5QzPg==
X-Received: by 2002:a05:6e02:14d3:: with SMTP id o19mr2701564ilk.257.1634221539309;
        Thu, 14 Oct 2021 07:25:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.34])
        by smtp.googlemail.com with ESMTPSA id l15sm1412926iln.78.2021.10.14.07.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:25:38 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] selftests: nettest: Add --{do,no}-bind-key-ifindex
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634107317.git.cdleonard@gmail.com>
 <122a68cd7fd28e9a5580f16f650826437f7397a1.1634107317.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <133b490a-29a2-aa40-37bf-aef582f2028f@gmail.com>
Date:   Thu, 14 Oct 2021 08:25:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <122a68cd7fd28e9a5580f16f650826437f7397a1.1634107317.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 12:50 AM, Leonard Crestez wrote:
> @@ -1856,10 +1870,14 @@ static void print_usage(char *prog)
>  	"    -n num        number of times to send message\n"
>  	"\n"
>  	"    -M password   use MD5 sum protection\n"
>  	"    -X password   MD5 password for client mode\n"
>  	"    -m prefix/len prefix and length to use for MD5 key\n"
> +	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
> +	"    --do-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
> +	"        (default: only if -I is passed)\n"

a nit:
just --bind-key-ifindex and --no-bind-key-ifindex

Reviewed-by: David Ahern <dsahern@kernel.org>

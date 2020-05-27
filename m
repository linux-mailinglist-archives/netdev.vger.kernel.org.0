Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A751E45D1
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbgE0O1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388138AbgE0O1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 10:27:40 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28FD5C08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:27:40 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b6so24431735qkh.11
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 07:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2UfzX4p4RxW/OjjKlUuQ3pMQwGefFgXA0tcEgztkUP8=;
        b=txFtu9Z//iIFXM6zKzKRNXEE0+H83vORvpvOITiU91bJDdVf0zrH5NT8Dxe1D66/ZT
         0wNfFcDysOatMRVJ8KnO8mwlZaoAan4hK6JfZZ0BzlYVQXQi6My+JWmdoKVyWfO6J0Ub
         5iMZjdaMvlMqFzfz+iB2PIf0syiAEt5KqXnIR2NdyMCc+vYAq0Bvfq8XAoxpspr0rjSM
         2Hph2wjVtBTCe64T+rY6bijXTWaWvESR/SKjpDFPjqLkzEteOU6jOV93zvS/D1Tcx3aD
         7407w1BpEIqe72/L4XbvjflAi3a5n6mnmcddG/u05/vrlX9EkD8Y8JBnGBpr1QNpF4d8
         k1VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2UfzX4p4RxW/OjjKlUuQ3pMQwGefFgXA0tcEgztkUP8=;
        b=R5gMX1inWlFYCT01UCce9yy8CPBb2nn0J2Qi23bsq9AssnYfNCdFFMp6U8R8i+fI+h
         DtPoS9iLXjLLgJ5pCNP8nnl9BKBKJGxgYTahqqW0Fla4e7rQKNWHKqxdxVcD9Ts6lW9X
         fdrZJrvAYKe9RyaaO2ilbMIaNQFySSogB0jtNeikmZP9DRB47LEhUssJ+NR3Pz6NhcrP
         0Ao4EB4Fcy9K40v/fTWuWVW07pv0XIdUej/OUpkRkPw6qgeL6DG17iCxe8YjJxinWiLC
         TOl7O5jZEVzfk2MQODYXZZjNF8/9ipCW+tHhWWDilR+XdNUfkVvHxocOJaMtiBm+5mkA
         EaGg==
X-Gm-Message-State: AOAM533Wornf+QwUhTEC40BH+AOpgGCFoub29klAruYgeyDUjB2z7RvT
        KUooNJ8aevrtiGjTo4xM1jk=
X-Google-Smtp-Source: ABdhPJwOfeH6WVpza1CeVg7+7f1J+jEFZifwTIGkMi1QLq6EfjSqknn/EJKQClDNDpJT1rQH/y/Lgw==
X-Received: by 2002:a37:b501:: with SMTP id e1mr1499813qkf.269.1590589659417;
        Wed, 27 May 2020 07:27:39 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id n35sm2624552qte.55.2020.05.27.07.27.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 07:27:38 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/5] bpf: Handle 8-byte values in DEVMAP and
 DEVMAP_HASH
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com
References: <20200527010905.48135-1-dsahern@kernel.org>
 <20200527010905.48135-2-dsahern@kernel.org> <20200527122612.579fbb25@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bb30af38-c74c-1c78-0b10-a00de39b434b@gmail.com>
Date:   Wed, 27 May 2020 08:27:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527122612.579fbb25@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/20 4:26 AM, Jesper Dangaard Brouer wrote:
> IMHO we really need to leverage BTF here, as I'm sure we need to do more
> extensions, and this size matching will get more and more unmaintainable.
> 
> With BTF in place, dumping the map via bpftool, will also make the
> fields "self-documenting".

furthermore, the kernel is changing the value - an fd is passed in and
an id is returned. I do not see how any of this fits into BTF.

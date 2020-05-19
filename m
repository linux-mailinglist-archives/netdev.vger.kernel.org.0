Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8371D8BF6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgESACH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgESACH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:02:07 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320D4C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:02:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i14so12499875qka.10
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9Gc2Hr//uUPTKEJR8pXWg6gw3K93zt8gfah73kVXVtU=;
        b=TYdsfORoU1pTjI1Cw0yEt/twl14T06Buros+rh2Knee1PF94Zue1+8FN9woX8Svkdh
         1ld9pDnxa6kEJX9a4J8+REK6C2oLwcVnE3ZduhyrUrXVKmZZiqrjnZcaS+TBprcQCkxE
         MyoP1gvzegu+KUesJfFp5mAaUSUbf6vHeV2eK9LGR/VA3dgjkZ6EZYD8czqsMSnVVewd
         efKsg9b/jnMW/xhU6yLPTwZQL1xO8myjuO9XrDW5jMQkI60qjqWj1S8VE/ISQmahy+QQ
         xIuLmSKQSxcFRd9+UkZBNL8UATpWVZVFvOUe2fFYBI5z+s11EtkJBhZ/hhnBVQJrwnIX
         RwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9Gc2Hr//uUPTKEJR8pXWg6gw3K93zt8gfah73kVXVtU=;
        b=kULoeky1kFrJ7uDzJD+XDXg262qepMiIVGACaI6H/Hdw7dNaFCkz9+hpvMbQ6qA0M3
         cJsNm5FvqVOV+ZSQd9E3kZr/oNT8H/3XaZslwn0+a/iq5bO9+7vfe3rXE32NvxrbKKbx
         S5Ww9124dZXXTJpqQXujJckyUois44C2qIE6sn9e2I+DG3ll1KQ3mlLY0y4Ikz5CXz9j
         gBua/b0LZSiGvnKxYt1I19c1MTH9DAeQmGYng7gt89fdW6EUqDicMjtvAhNj9VA4qVNd
         r1DNTbeWQCiDW1/K7T4zAq/g61Q9o8wasBakKp9xjCPLUezt713dTsiAyh7ovEjCsZWS
         n9fg==
X-Gm-Message-State: AOAM531lqOJs4d9bJnv1+fKYz7afIWU3p+CU05UV7/U6HQonx8a4dIUG
        EaT6QpbBRL/vXa3HSsE0jkY=
X-Google-Smtp-Source: ABdhPJyem938pH8um4n4/I5jUGbcxSbVC9t/dUlYlZxbpAruojLQcJfPQ+CddLQe1/DpAEuRDr7CMQ==
X-Received: by 2002:a37:e4c:: with SMTP id 73mr18959691qko.66.1589846526451;
        Mon, 18 May 2020 17:02:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id j3sm9183222qkf.9.2020.05.18.17.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 17:02:05 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk> <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d599bee-4fae-821d-b0df-5c162e81dd01@gmail.com>
Date:   Mon, 18 May 2020 18:02:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <dcdfe5ab-138f-bf10-4c69-9dee1c863cb8@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 3:06 PM, Daniel Borkmann wrote:
> So given we neither call this hook on the skb path, nor XDP_TX nor
> AF_XDP's TX
> path, I was wondering also wrt the discussion with John if it makes
> sense to
> make this hook a property of the devmap _itself_, for example, to have a
> default
> BPF prog upon devmap creation or a dev-specific override that is passed
> on map
> update along with the dev. At least this would make it very clear where
> this is
> logically tied to and triggered from, and if needed (?) would provide
> potentially
> more flexibility on specifiying BPF progs to be called while also
> solving your
> use-case.
> 

You lost me on the 'property of the devmap.' The programs need to be per
netdevice, and devmap is an array of devices. Can you elaborate?

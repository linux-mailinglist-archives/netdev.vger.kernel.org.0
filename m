Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796971AD37A
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 01:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgDPXzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 19:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725770AbgDPXzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 19:55:35 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3497DC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 16:55:35 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id i19so522492qtp.13
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 16:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gNYQHxi7UnMYONV+plmv5GAMeh9i2wErcpA9kIZGVfc=;
        b=ODUL7l8JccCqCFptTDoLc2KiwgTuaXePknC/XDbSdqjGkVZibG7DmT1oCKcDcAq28H
         yTjB25Y6lZFfMaJGpB8qf5xJy5WtTI375Jm+mtPTh3gSpqenySqFvnq4CDD45Yk8a+Q+
         jt6mxV+VBhBioYdgRFfqnboS8iCfdRpmof5RHl336LewSmmQmP1NFmlG6OocydoB0Do1
         TmCfxqq6ZAfw9RDFuT6ouoEeotNldIqfgu4rbVbWjOOcOYlH/y1dYu3o1RQ1d4NyGnd/
         IxKUJpb3NDPtfZM3ljgPFqadbGF0ZBpmtECdqJirMnZmHnR3AnJtin8wFuXX9od+Yezy
         ZKvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gNYQHxi7UnMYONV+plmv5GAMeh9i2wErcpA9kIZGVfc=;
        b=A4QoBcWsnDvdbff9MBvU0ykpXMa218wgtNOMlVEzSxCZ0QG7BM7WUDFOMtBBB70OqB
         qmmVw+3RVQvU60mQLgu2QFtVcVbu7U4TvIkaqrhTzolT42A/J+fgjmb3DLARb47JkoB5
         hpJs/HBpYF6lYMIy/LIuo1D6PKHDKmRDLJZPoBl7sIWc7/DGDVNb/0n8hiR+20oqa37J
         EPAk39Nls3uL74QQnN7I/fryhRSi8mHjZgA+baR115KbKhJYfhGzavow9yqSq8LBMj1K
         kn59fygw66Ehuo5cI9qzyvBH4H3+76slI+kFqWJOebYSo0TeIASL1ZwL2t2pF/Q96icl
         5SQw==
X-Gm-Message-State: AGi0PuYqJWB+RSpGy9iFJfn6E4Am1K6h1pAjQcJd63WG6X+M+2nxc4vR
        OEfJiuWGVGyZXxrAKOUhQx8=
X-Google-Smtp-Source: APiQypIu8oS14ljnDUH6ohP1a7NSvIHpmNqU/jmSOjGWx2SEHwYtY6H4DC+NuCNZWYKYW//rAEg6rw==
X-Received: by 2002:ac8:5057:: with SMTP id h23mr280887qtm.287.1587081334364;
        Thu, 16 Apr 2020 16:55:34 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d897:9718:2ec7:8952? ([2601:282:803:7700:d897:9718:2ec7:8952])
        by smtp.googlemail.com with ESMTPSA id h13sm15529407qkj.21.2020.04.16.16.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 16:55:33 -0700 (PDT)
Subject: Re: [PATCH RFC-v5 bpf-next 00/12] Add support for XDP in egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200413171801.54406-1-dsahern@kernel.org>
 <87pnc7lees.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8dc7e153-e455-ff6c-7013-edb7cb62b818@gmail.com>
Date:   Thu, 16 Apr 2020 17:55:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87pnc7lees.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/20 7:59 AM, Toke Høiland-Jørgensen wrote:
> 
> I like the choice of hook points. It is interesting that it implies that
> there will not be not a separate "XDP generic" hook on egress. And it's
> certainly a benefit to not have to change all the drivers. So that's
> good :)
> 
> I also think it'll be possible to get the information we want (such as
> TXQ fill level) at the places you put the hooks. For the skb case
> through struct netdev_queue and BQL, and for REDIRECT presumably with
> Magnus' queue abstraction once that lands. So overall I think we're
> getting there :)
> 
> I'll add a few more comments for each patch...
> 

thanks for reviewing.

FYI, somehow I left out a refactoring patch when generating patches to
send out. Basically moves existing tb[IFLA_XDP] handling to a helper
that can be reused for tb[IFLA_XDP_EGRESS]

https://github.com/dsahern/linux/commit/71011b5cf6f8c1bca28a6afe5a92be59152a8219

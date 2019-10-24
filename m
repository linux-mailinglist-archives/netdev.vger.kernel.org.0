Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4B6E39A2
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439984AbfJXRRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:17:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35777 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439972AbfJXRRE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:17:04 -0400
Received: by mail-io1-f68.google.com with SMTP id h9so2648228ioh.2
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xk35OIRZgG5X6bY5L2C8Cgvh/RkMCx5ztmO2WbT4NXQ=;
        b=DTf+dLTFxav94WxX6yhgdpYy/IQvWV2zfvGoCMkmU/8/HwwCvUN69ASmiBoukX/usV
         bThlqPFVEfKMVmvNqNLVsUoP+4wn+oSLoPovTJxfowQyMbSzOS/86Vxxwp16wlIoJTkp
         8c/vQyx2MkRKUR5uZLqPh4PTSOnQ5cYHd4bDRxFWG68EHyR1lAMjqAqTOWE883S18ItW
         EOUWWrQSDM8hhT++NKj8jmUVB1AYWt2wDUSfnmickY95qQZr80a67ToQOmIlWYDBqRtS
         D4Tmx1vkRf22qmk1+Dn8KLhn+Dr5r2peG8zeEyfLeirfwmvHqMn0BhF2dL+8nCIizlwe
         0UuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xk35OIRZgG5X6bY5L2C8Cgvh/RkMCx5ztmO2WbT4NXQ=;
        b=EcPqmsmSe1pB+iZUuOVL0HqzQnDHlW58Kt25jk5YpF6Rm2hmGZ+xpKBrG8eP2d9IfN
         Y3IsyjkqKcACQSkC626TZiOznl8s0C+1Jd7LkGfZcbWNvonL4uv9TzWUapqflJYgAVqr
         penSjxt8rLE2ueWTeH26I9YnRtl0Pptkae/osbfKhj76/kDOjLD3dPXJereBPN3VjGtR
         ff/kKe15xWlSs45Xb4+0ZlREyO9Hwl4i2oOY0vL04azPSYzAVtnXrTJxqMzBFFxopJB/
         opIessVtLh9kpAFUybz37tDxkxcchmIzGkzBNValJB0sD2HD4iI4nvXQ82pnQoDV34Ia
         xDwA==
X-Gm-Message-State: APjAAAVwuxPCVtpbDiGUpGbHcULUL1ywhv++Zb+0xVq5eNIXSnSFaKjH
        iVEpYMvvnxPrP4zbNDQDYqspYA==
X-Google-Smtp-Source: APXvYqxxmknicfMVGH+Z2m02iqW4923v2h94gLRe9KkGB2gNwBW0RHU4jv2mPkIgxQG/4TJBesVXqg==
X-Received: by 2002:a5d:9393:: with SMTP id c19mr7623084iol.37.1571937423226;
        Thu, 24 Oct 2019 10:17:03 -0700 (PDT)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id z19sm2432526ilj.49.2019.10.24.10.17.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 10:17:02 -0700 (PDT)
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation
 by netlink flag
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mleitner@redhat.com" <mleitner@redhat.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
 <78ec25e4-dea9-4f70-4196-b93fbc87208d@mojatatu.com>
 <vbf7e4vy5nq.fsf@mellanox.com>
 <dc00c7a4-a3a2-cf12-66e1-49ce41842181@mojatatu.com>
 <20191024073557.GB2233@nanopsycho.orion> <vbfwocuupyz.fsf@mellanox.com>
 <90c329f6-f2c6-240f-f9c1-70153edd639f@mojatatu.com>
 <vbfv9se6qkr.fsf@mellanox.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <200557cb-59a9-4dd7-b317-08d2dac8fa96@mojatatu.com>
Date:   Thu, 24 Oct 2019 13:17:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <vbfv9se6qkr.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On 2019-10-24 12:44 p.m., Vlad Buslov wrote:

> 
> Well, I like having it per-action better because of reasons I explained
> before (some actions don't use percpu allocator at all and some actions
> that are not hw offloaded don't need it), but I think both solutions
> have their benefits and drawbacks, so I'm fine with refactoring it.
>

I am happy you are doing all this great work already. I would be happier 
if you did it at the root level. It is something that we have been
meaning to deal with for a while now.

> Do you have any opinion regarding flag naming? Several people suggested
> to be more specific, but I strongly dislike the idea of hardcoding the
> name of a internal kernel data structure in UAPI constant that will
> potentially outlive the data structure by a long time.

Could you not just name the bit with a define to say what the bit
is for and still use the top level flag? Example we have
a bit called "TCA_FLAG_LARGE_DUMP_ON"

cheers,
jamal


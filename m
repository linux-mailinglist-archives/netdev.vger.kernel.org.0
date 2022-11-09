Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F144762301B
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbiKIQZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiKIQZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:25:18 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D21619286
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:25:17 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id q5so9278976ilt.13
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 08:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ziuvq5Y95DCcNTz94pEKFwOv2/BYS3eGvphQtS8Wfb4=;
        b=aNd2up8md3X+4q5bsGiT/LJvy0AJ1FCHHP1+y2geuc4FoIBv2z08B/GYRNmEFkqdBy
         aCAmSidrMXrkHwMOWyIB0oITMZNP2ZKuRA4zptVcUSxgi/EUoLGJqQn3ZYxeNvD51/99
         uofjhzKG9TKFmWhIZ9yBkRy3NaAoFh7iDbHJBzf6IS/Wm21BFIrfYwJ/2fpBcXrfGncy
         Eu+Z0vryXgG4hqki2NIthrx78yU8Uc5jVu2X4mksj68jttp58HvBIDDnJJTnsyKKBuQT
         IrV33RUSXrI4SqTqlwOf754eXzEYapzryOrk7urSk2mxrmk9tvur/EnERSnzsJeZHUpC
         Lu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ziuvq5Y95DCcNTz94pEKFwOv2/BYS3eGvphQtS8Wfb4=;
        b=OTszdgwG74ql0wmZVcTJTWonfvqijUzK8aGTqlZ3TtJPqQaK46VNs2LHlTMlZTcxrs
         ukcc/OLpQIYvAztTmtMpRGgi8OOlP7AIOmNvHw4v34nyhywqAzJNc6g1xgVjUydvUldk
         FyiXwQoiZ2gJP2iAvLiN/bOObDF01zOSAepuYfd3GVwBoL+Zt9XN/4HkK/uwPXVb24DM
         C15a+q2NOucNudOMl24c76uICCqA4v4KvAPKS0bU3KecX/ZvwzqfwFVwXNMKd2JvDnJl
         0R2v2cZfmmUT30soGD3vZIHjlh/8gw4bVH/y5sCCsMSDFhtGD+QMGxNIewPBrCnGpeRA
         O3mg==
X-Gm-Message-State: ACrzQf3GvoscX1nOsmkA8eYZQJJtXMyQkazcKTfbogW4TJ7Mr10a+Dgr
        BwqlMHNqZPDppBpG3wARSScXjOZZN4QYgw==
X-Google-Smtp-Source: AMsMyM4hepmVawM/YdFcVvBfTmWF923nKJN+C+LBFpdd0oXtYlZlmAlmO8O5LIHB8iHKeO6MsWQoIw==
X-Received: by 2002:a92:c6cb:0:b0:2f6:94b2:fba5 with SMTP id v11-20020a92c6cb000000b002f694b2fba5mr2020136ilm.78.1668011116918;
        Wed, 09 Nov 2022 08:25:16 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a10c:23e5:6dc3:8e07? ([2601:282:800:dc80:a10c:23e5:6dc3:8e07])
        by smtp.googlemail.com with ESMTPSA id r4-20020a02aa04000000b0036368623574sm4859910jam.169.2022.11.09.08.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 08:25:16 -0800 (PST)
Message-ID: <d47c3f41-2977-3ffb-5c99-953088727a4b@gmail.com>
Date:   Wed, 9 Nov 2022 09:25:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: ping (iputils) review (call for help)
Content-Language: en-US
To:     Petr Vorel <pvorel@suse.cz>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <Y2OmQDjtHmQCHE7x@pevik>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <Y2OmQDjtHmQCHE7x@pevik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 5:30 AM, Petr Vorel wrote:
> Hi,
> 
> I'm sorry to bother you about userspace. I'm preparing new iputils release and
> I'm not sure about these two patches.  As there has been many regressions,
> review from experts is more than welcome.
> 
> If you have time to review them, it does not matter if you post your
> comments/RBT in github or here (as long as you keep Cc me so that I don't
> overlook it).
> 
> BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since he was active.
> 
> * ping: Call connect() before sending/receiving
> https://github.com/iputils/iputils/pull/391
> => I did not even knew it's possible to connect to ping socket, but looks like
> it works on both raw socket and on ICMP datagram socket.

no strong opinion on this one. A command line option to use connect
might be better than always doing the connect.

> 
> * ping: revert "ping: do not bind to device when destination IP is on device
> https://github.com/iputils/iputils/pull/396
> => the problem has been fixed in mainline and stable/LTS kernels therefore I
> suppose we can revert cc44f4c as done in this PR. It's just a question if we
> should care about people who run new iputils on older (unfixed) kernels.
> 

I agree with this change. If a user opts for device binding, the command
should not try to guess if it is really needed.


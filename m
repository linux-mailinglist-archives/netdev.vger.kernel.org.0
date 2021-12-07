Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F11546C085
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234745AbhLGQR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbhLGQRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:17:55 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86136C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 08:14:25 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t23so28633533oiw.3
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 08:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=HVJjilZ/x6FnCT58giUKSbT4eOl01QTSRvBn6Vydf0o=;
        b=ENVn3VWRi0kbSd5x9hxBpMt/kUsiZFuVG4t8apm/TZagWhGviaIIUo8aHT/0R6gdnf
         J6TYBXp7gxe4SIKvvJZnZrjNka6I0lgWWYmqLTswalIRh0mHWmX5U1+szoEURJ/mffq6
         LNFexqi/qst83kbrCStsx/RbPWQixGEQbyZNvpFnComuhNiffBSdWguy8wxn9LyGoKl+
         7m7a9V83agMX6BXE4HIURgMu9izU1X/MzIYJxsYGsdISsgg60U7LOOEKzQRNLutBaZnU
         cRWzWRg/2ZoL8MHfp8MX1elk0n8pTLA3NL3FqE+lFK48wLODQ29JMlzgvdHADjhNZZrj
         TtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HVJjilZ/x6FnCT58giUKSbT4eOl01QTSRvBn6Vydf0o=;
        b=4g6XkyUEZ515hNFGtV+u+SSjZ+xCpAIPzGIXq+JNd0DO0nE+fAAmrDbrpgtnOrEdo+
         8hvpdQMQZ9/gYOM2YPYhkUE03w5Uo+Lr/LhZYlL6oD3qIBirtwlNsq3xC03Au7nGqvPX
         aRsVXH5NlUtjlyv0Y2k2Af/SBfy7+G40nt5nuSzn9WzAH2s8OsRCI7dB4p6T0HSj94xs
         sZ/dQximplv+BANV7SDTmZqAKvT3FMC6sPhcSRWdOvY8eDf9lpelZkgY7+g7B4BvAeOb
         MPty9ERrtrhSPk4g3p81aan/zlf50BW82eQjOheKs15WIaXcL1QKHxxb+CrkhTGULQVv
         x/cA==
X-Gm-Message-State: AOAM532A5TFtEepwuP9bL55gywxeJLseeIvwEBt/YLnURJdt6SQwW+gR
        qaYlDGsn0vGsGVJ1Maj4z2On3sesRhg=
X-Google-Smtp-Source: ABdhPJwarbgq1rJLnFdIdZ/LvTxFBqk3LdVUPzVqN5NSe1ik6tk39OJvpd27Kw7gmsWyZqT1tO26EQ==
X-Received: by 2002:a05:6808:699:: with SMTP id k25mr5999892oig.135.1638893664854;
        Tue, 07 Dec 2021 08:14:24 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id 586e51a60fabf-a8853e8759sm526fac.42.2021.12.07.08.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 08:14:24 -0800 (PST)
Message-ID: <74649aca-b760-2e8d-2a9c-6cdf937592a5@gmail.com>
Date:   Tue, 7 Dec 2021 09:14:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH iproute2-next] tc: Add support for ce_threshold_value/mask
 in fq_codel
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20211123201327.86219-1-toke@redhat.com>
 <765eb3d8-7dfa-2b28-e276-fac88453bc72@gmail.com> <87bl1u4sl9.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <87bl1u4sl9.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ vger seems to be having problems; just received this ]

On 12/5/21 3:03 PM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 11/23/21 1:13 PM, Toke Høiland-Jørgensen wrote:
>>> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset
>>> of traffic") added support in fq_codel for setting a value and mask that
>>> will be applied to the diffserv/ECN byte to turn on the ce_threshold
>>> feature for a subset of traffic.
>>>
>>> This adds support to tc for setting these values. The parameter is
>>> called ce_threshold_selector and takes a value followed by a
>>> slash-separated mask. Some examples:
>>>
>>>  # apply ce_threshold to ECT(1) traffic
>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3
>>>
>>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>> ---
>>>  tc/q_fq_codel.c | 40 ++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 40 insertions(+)
>>
>> please re-send with an update to
> 
> With an update to? :)
> 

... man page.

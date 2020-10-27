Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2763C29CB88
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374490AbgJ0Vvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:51:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38800 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730075AbgJ0Vvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:51:53 -0400
Received: by mail-io1-f65.google.com with SMTP id y20so3225761iod.5
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 14:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=d5A0gkFZNwvEFTvdEC1ddcO8QHMKkmk4cRdd3AaJF6o=;
        b=I0Lhd3WT3Be4jk2Th1xaWLjIYJzqcRssHMJO5QhsZ7dLmeOiF4pXBTcpx0xOJaojrK
         wPk7AfEks+QxQWFp0f/Mu1wdPK8FqY+MfTYHH5yexc9wdgNZn4QQeBEBw/AiGNIPwLDE
         8h/9UQ0mpyjDuAz0h5X2kfjq9Jmu+jKawz/SYLzJ1oEJmjqmUVxvJB1dsMcq1ZDXeovY
         eKO7qiqydRZMuHk89amF8txnMBa2YFDuMOfvX8zcMMnpBmCqejwYGRHlJ0Zyn/qpe/za
         sMe/2S3NjwToycSpJkcTGxCgbBOjszOaJIapF6K97wFsbeFU5fYkfFmSxDV4M6ASYAf5
         30cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d5A0gkFZNwvEFTvdEC1ddcO8QHMKkmk4cRdd3AaJF6o=;
        b=UPSrlq+QzLLzAX1Dg1JZJf60BYVRl5rx667FG3z3CYiNvwVjlinAhgonCYNbeobjhB
         eIT9JvOG5O2S2SpjwnX6BoCv0Dsvc13RnmQe3vNe+7nGGHGwXPMyDFSUqf0MvCdt2scU
         srwvd3plU1gk0tvJkbjrRMPb8ItNvJgnuD/7BlJ5v6mc7t1LRxgnc2DojVok6LaEcfhE
         7q6pwH7MbTNTsrRPP+zhkeAB3W1cb0Jthtt5GSKIzPwBkChPrQ7BXCNUJeu755a4rljl
         1k+3FpiogQP3sfcfLzG2Gwa4VoilibkYjhseTAnOYM5CWnr3KpMEtEFtxr3ySwXkXxYh
         sYQw==
X-Gm-Message-State: AOAM531vwF26EA87nHsnvEQZIHb61nhceNRizljc47ewE9PrntD/Ae5w
        2fwyRNuRPYXqcb2t99Dg+Yg=
X-Google-Smtp-Source: ABdhPJzVg+PCr16IE5QxWm3IpLlngdnejT8K2zSQPFXeINkYH5xIpaXceKolFtZ7JCutjLeal9U/pg==
X-Received: by 2002:a05:6638:2603:: with SMTP id m3mr4252680jat.43.1603835512062;
        Tue, 27 Oct 2020 14:51:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f994:8208:36cb:5fef])
        by smtp.googlemail.com with ESMTPSA id y17sm1508186ilj.7.2020.10.27.14.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 14:51:51 -0700 (PDT)
Subject: Re: [PATCH v2 net] net/sched: act_mpls: Add softdep on mpls_gso.ko
To:     Guillaume Nault <gnault@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Alexander Ovechkin <ovov@yandex-team.ru>
References: <1f6cab15bbd15666795061c55563aaf6a386e90e.1603708007.git.gnault@redhat.com>
 <CAM_iQpVBpdJyzfexy8Vnxqa7wH0MhcxkatzQhdOtrskg=dva+A@mail.gmail.com>
 <20201027213951.GA13892@pc-2.home>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6e8437c3-bea6-7988-af1a-d43128c95446@gmail.com>
Date:   Tue, 27 Oct 2020 15:51:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201027213951.GA13892@pc-2.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 3:39 PM, Guillaume Nault wrote:
> On Tue, Oct 27, 2020 at 10:28:29AM -0700, Cong Wang wrote:
>> On Mon, Oct 26, 2020 at 4:23 AM Guillaume Nault <gnault@redhat.com> wrote:
>>>
>>> TCA_MPLS_ACT_PUSH and TCA_MPLS_ACT_MAC_PUSH might be used on gso
>>> packets. Such packets will thus require mpls_gso.ko for segmentation.
>>
>> Any reason not to call request_module() at run time?
> 
> So that mpls_gso would be loaded only when initialising the
> TCA_MPLS_ACT_PUSH or TCA_MPLS_ACT_MAC_PUSH modes?
> 
> That could be done, but the dependency on mpls_gso wouldn't be visible
> anymore with modinfo. I don't really mind, I just felt that such
> information could be important for the end user.
> 

I think the explicit dependency via modinfo is better.

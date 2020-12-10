Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B14B2D5FC1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391528AbgLJPbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390741AbgLJPbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:31:24 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21D8C0613CF;
        Thu, 10 Dec 2020 07:30:43 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id a109so5215314otc.1;
        Thu, 10 Dec 2020 07:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1ZS8BvFesU0nu0mbqUrnRelgrjsauGCLLXcNS4r+2pw=;
        b=gNyiVR5UMSakuT65wXidT0LrxLPuDeSjAyngwUD07lf0al/RBUTySgD+jeTKmI0Mmz
         t+pg1fHc0lgPQCKOwxH3bWF2zxJajfJd0HY3iV2BPNh2c4BY6GXoJf7syH7aF3DrInjX
         AXQ7m2bIoP3R5IAvgv9IExTBMMKf1S5bjUcs9xL1/IWldDDVb5dDfQccneiT4PCqohyp
         NjLjIu2juvY172aOjefDtswLkxFF0ah+TgTAAW2vsgbrYWJrXysBudKCH0VZk6/o9S5W
         stMdY1NUPOCNQfi9zSb3fEgONE9mznG9PeoN7hbBgroN7fBHWaeJyTm9w0gacHXTD9Zh
         eJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ZS8BvFesU0nu0mbqUrnRelgrjsauGCLLXcNS4r+2pw=;
        b=QsCdIlEwCRVjofNzzh7IETgymhjuY/Xj8Nd5Z84ykwOOYGDRy/EEytWWuj3Khn0/5q
         Hm9m66T4G0bAgtnnTjm0fgrwcSHTaHzS73xgSHLIzmdAoUFrG3w/XJkGuK0hIYc3RBBg
         QCGYKUsGKy/13usmqUAeo2p2QddGdc30fngt/tAiwlhARrVwMgScTGqibFxii/KncKQf
         qLUy8IflaVXXqh4C6EJ9wUEU3fPLBbQqTrhaVorDtdAntVYsAPzvmtBRtHjnuAd2C9+c
         dmakRB/Daiy6B1W8N4imqYI0f47yrxw+RDWScTzCoUGDwZZ9w8Cnr3hKz/ir2/bBReQc
         DFWw==
X-Gm-Message-State: AOAM530dztcMkyEKFr7zf+2wqmgCcyUAvm2cq0ORrwA6PBDyeLdZfDX0
        SvWzvz4Q8CIFaFOse5UG8ks=
X-Google-Smtp-Source: ABdhPJx2p0KZlAN9MAgb/XqZTVkmhi03Pyai0QbZFWPRdUmo5UA4Oco3GVkGXE6HnVjCFqYoLIwtMg==
X-Received: by 2002:a9d:590c:: with SMTP id t12mr6121703oth.308.1607614243369;
        Thu, 10 Dec 2020 07:30:43 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:6139:6f39:a803:1a61])
        by smtp.googlemail.com with ESMTPSA id z12sm1204207oti.45.2020.12.10.07.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 07:30:41 -0800 (PST)
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
To:     Saeed Mahameed <saeed@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
 <20201209095454.GA36812@ranger.igk.intel.com>
 <20201209125223.49096d50@carbon>
 <e1573338-17c0-48f4-b4cd-28eeb7ce699a@gmail.com>
 <1e5e044c8382a68a8a547a1892b48fb21d53dbb9.camel@kernel.org>
 <cb6b6f50-7cf1-6519-a87a-6b0750c24029@gmail.com>
 <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d5be0627-6a11-9c1f-8507-cc1a1421dade@gmail.com>
Date:   Thu, 10 Dec 2020 08:30:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <f4eb614ac91ee7623d13ea77ff3c005f678c512b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 11:48 PM, Saeed Mahameed wrote:
> On Wed, 2020-12-09 at 20:34 -0700, David Ahern wrote:
>> On 12/9/20 10:15 AM, Saeed Mahameed wrote:
>>>> My personal experience with this one is mlx5/ConnectX4-LX with a
>>>> limit
>>>
>>> This limit was removed from mlx5
>>> https://patchwork.ozlabs.org/project/netdev/patch/20200107191335.12272-5-saeedm@mellanox.com/
>>> Note: you still need to use ehttool to increase from 64 to 128 or
>>> 96 in
>>> your case.
>>>
>>
>> I asked you about that commit back in May:
>>
> 
> :/, sorry i missed this email, must have been the mlnx nvidia email
> transition.
> 
>> https://lore.kernel.org/netdev/198081c2-cb0d-e1d5-901c-446b63c36706@gmail.com/
>>
>> As noted in the thread, it did not work for me.
> 
> Still relevant ? I might need to get you some tools to increase #msix
> in Firmware.
> 

not for me at the moment, but it would be good to document what a user
needs to do - especially if it involves vendor specific tools and steps.

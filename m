Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5DA2BB69F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbgKTUWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730151AbgKTUWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:22:22 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F2AC0613CF;
        Fri, 20 Nov 2020 12:22:21 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id z14so9633600ilp.11;
        Fri, 20 Nov 2020 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QIpctxQjzw6bGt2SeNweCEtk7v/MSKpYQ3UV/WqFTwI=;
        b=EOC8JgmzJPi7pcXSnxvfVK47qNX+hk2PrzsSQUe9ro9dG+jbHypNsrbLbzbIb004RA
         sGN89301ba9WKver9/4nDKMSPdUh0WSz3qFKBsOi8N4J2ADj5CxC0AF8c52hVhd4d3h1
         sSzHMUg0KgCfsgODv9eHXw1ns+yJZGDRLZO9A+tSn5bbWmLewi6U/64G2BHX2XSdCv0B
         phwDt5d/JDoNAW7C3JDqfbdrcVPoQ0DbLBFej9mscmyzdZqs+ZERvXtaFJJEMpokpmKz
         WecRlVWVy1uAh3VTJAVw/1Z2sAKE+H6NkrWVoReuccu+swUtlp/E3DfDdIJT7ylP8PBC
         cL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIpctxQjzw6bGt2SeNweCEtk7v/MSKpYQ3UV/WqFTwI=;
        b=hQuN53EwkVsGrrtCNuyUPigpdzEUbg/nF+7GB3VyxkNvE9MzyfTsk+JYTOmYuj+zA9
         XGJgiP/VJubJ0dLJg2C5EWq7zZTas8FN/N6oWgX1q39tLYaYi/WtkmDyKxzFZGsE67Xj
         fhh18bxSutdrHS9qQD7UJF67UwuQ0rquNFliEOgPyzkMT/GWPBRKMtkFROvAOVYGPK3p
         4gNsYbTQaUhn2/LEF2v0FRJOpjaK5bHtalvnQ6doIEJ+jUcyLH/yhqTr9DGl3auc53OW
         koJVSBRGcqaX8GUh3mMPHsIS68cYhd3SuymloNezTprlZphZpNK9wgUHVSw3n/8QdbS8
         RlTw==
X-Gm-Message-State: AOAM530GEclMl/wgjdlNBCTfia6cljkX7t1tWIHWKwkLY3OZqQqAeXod
        K87PySi1RMIbR+mxOjnWrmpW5dk3hXw=
X-Google-Smtp-Source: ABdhPJxEwSpIrtHDXqmHvD2SyWuYOth8+zoPhFV2r/D1FrdHmobpTlOOX8a60eI17zAM+P2AqzdE8g==
X-Received: by 2002:a05:6e02:deb:: with SMTP id m11mr26934482ilj.8.1605903741045;
        Fri, 20 Nov 2020 12:22:21 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:61e9:2b78:3570:a66])
        by smtp.googlemail.com with ESMTPSA id l8sm1993525ioc.19.2020.11.20.12.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 12:22:19 -0800 (PST)
Subject: Re: [PATCH v4 net-next 0/3] add support for sending RFC8335 PROBE
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1605659597.git.andreas.a.roeseler@gmail.com>
 <b4ce1651-4e45-52eb-7b2e-10075890e382@gmail.com>
 <8ac13fd8-69ac-723d-d84d-c16c4fa0a9ab@gmail.com>
 <b7b2f834e2ecdd0a973d65b0cbaf73ef2c68e899.camel@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1f23f3d6-d459-2cd7-5d33-ca72d7d5f645@gmail.com>
Date:   Fri, 20 Nov 2020 13:22:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <b7b2f834e2ecdd0a973d65b0cbaf73ef2c68e899.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 10:27 AM, Andreas Roeseler wrote:
> On Thu, 2020-11-19 at 21:01 -0700, David Ahern wrote:
>> On 11/19/20 8:51 PM, David Ahern wrote:
>>> On 11/17/20 5:46 PM, Andreas Roeseler wrote:
>>>> The popular utility ping has several severe limitations such as
>>>> the
>>>> inability to query specific  interfaces on a node and requiring
>>>> bidirectional connectivity between the probing and the probed
>>>> interfaces. RFC8335 attempts to solve these limitations by
>>>> creating the
>>>> new utility PROBE which is a specialized ICMP message that makes
>>>> use of
>>>> the ICMP Extension Structure outlined in RFC4884.
>>>>
>>>> This patchset adds definitions for the ICMP Extended Echo Request
>>>> and
>>>> Reply (PROBE) types for both IPv4 and IPv6. It also expands the
>>>> list of
>>>> supported ICMP messages to accommodate PROBEs.
>>>>
>>>
>>> You are updating the send, but what about the response side?
>>>
>>
>> you also are not setting 'ICMP Extension Structure'. From:
>> https://tools.ietf.org/html/rfc8335
>>
>>    o  ICMP Extension Structure: The ICMP Extension Structure
>> identifies
>>       the probed interface.
>>
>>    Section 7 of [RFC4884] defines the ICMP Extension Structure.  As
>> per
>>    RFC 4884, the Extension Structure contains exactly one Extension
>>    Header followed by one or more objects.  When applied to the ICMP
>>    Extended Echo Request message, the ICMP Extension Structure MUST
>>    contain exactly one instance of the Interface Identification
>> Object
>>    (see Section 2.1).
> 
> I am currently finishing testing and polishing the response side and
> hope to be sendding out v1 of the patch in the upcoming few weeks.

send the response side with the request side -- 1 set of patches for the
entire feature.

> 
> As for the 'ICMP Extension Structure', I have been working with the
> iputils package to add a command to send PROBE messages, and the
> changes included in this patchset are all that are necessary to be able
> to send PROBEs using the existing ping framework.
> 

right.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAE53C3DCC
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236237AbhGKQDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhGKQDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:03:32 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45893C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:00:45 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t143so1305394oie.8
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W1KS4AfQTralsSrWoTZ1m0Ap2HS80L4aumcL9Ks7Feo=;
        b=qlBFiitU9NdPx+BqG3t7tEII3VRag2zKRCeeoYFLYbac7LHPx40SMzOMU9/nZCwlrE
         k5Y1STIX4RqjtLq3VBXH4WuK21OpyJPgpVQDSFWcWNL12LG2L1Uy+GViFcq8vg7nW5iH
         PbcppytkY2/uUtp2jeCQgL4AorwKVJubx+dcliw/dHqLcFTPECv34QZlk5YiyzfazlVi
         5Fq/FikRxoQ/jBwbxOEJlQjSg567OBdX4EZazPnXQEX+uzYOTITdf8yc/aUvVwm5JbHh
         AGn4Vp4CtNFeSgQelmYrK4fFugqAZYViOvRrSCSqUkE3wuvzQ5280fgFGyeKDF1/imqs
         LUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W1KS4AfQTralsSrWoTZ1m0Ap2HS80L4aumcL9Ks7Feo=;
        b=cqODHL6oSRBtm+b4mPm2jypbu3VAvVJd2Kti68J9GfBL2RopovYRqGS+eR9TZ1NF8U
         jv94pYofp8DHQ8MaK8Qnh5SNEBBHfoti/7oTdNJvcbzQivdDWFzn6ugjVzGEVzuPY71B
         XJLCr2rJtPD/V7CcLSqP+IpGwFjDDwBWDZSufsAuEHI4HGsRArTUF686fHwJ7S4oYbpJ
         t5A8qHT9hfWY8LJsUF8TZ3xMtA1jfmwxVsrGKXDrBD84rQGUWbdIZ+vqXk7nQM5Fw3/X
         ySrAGEGLPas9Xq1dXsxq7Jz8j8KN2iksnzpsfLwHb+o9rS1Fu4NbmreEXF2JyD6jUDml
         5Wqg==
X-Gm-Message-State: AOAM532xHGg0fNLkBnhJ42Mzre24bYlU21RIK8Pd+huBohcxUni47p7R
        f79Y0lhVbdziGzl4/W+rxyE=
X-Google-Smtp-Source: ABdhPJxvZHWBA1LR/j9WSUNolaV5rOi7AZIa5zF66gxjjR3bpg6Fwuw6LHj82UxH+uTIIL0KNt8hyQ==
X-Received: by 2002:a05:6808:f8a:: with SMTP id o10mr4810305oiw.22.1626019244132;
        Sun, 11 Jul 2021 09:00:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id o25sm2147422ood.20.2021.07.11.09.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 09:00:43 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/1] police: Add support for json output
To:     Roi Dayan <roid@nvidia.com>, Hangbin Liu <liuhangbin@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
References: <20210607064408.1668142-1-roid@nvidia.com>
 <YOLh4U4JM7lcursX@fedora> <YOQT9lQuLAvLbaLn@dcaratti.users.ipa.redhat.com>
 <YOVPafYxzaNsQ1Qm@fedora> <d8a97f9b-7d6b-839f-873c-f5f5f9c46eca@nvidia.com>
 <ba39e6d0-c21f-428a-01b1-b923442ef73c@gmail.com>
 <37a0aae7-d32b-4dfd-9832-5b443d73abb6@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <db692da0-680f-a6a9-138b-752e262bf899@gmail.com>
Date:   Sun, 11 Jul 2021 10:00:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <37a0aae7-d32b-4dfd-9832-5b443d73abb6@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/11/21 4:24 AM, Roi Dayan wrote:
> 
> 
> On 2021-07-08 5:46 PM, David Ahern wrote:
>> On 7/8/21 12:57 AM, Roi Dayan wrote:
>>>
>>>
>>> On 2021-07-07 9:53 AM, Hangbin Liu wrote:
>>>> On Tue, Jul 06, 2021 at 10:27:34AM +0200, Davide Caratti wrote:
>>>>> my 2 cents:
>>>>>
>>>>> what about using PRINT_FP / PRINT_JSON, so we fix the JSON output
>>>>> only to show "index", and
>>>>> preserve the human-readable printout iproute and kselftests? besides
>>>>> avoiding failures because
>>>>> of mismatching kselftests / iproute, this would preserve
>>>>> functionality of scripts that
>>>>> configure / dump the "police" action. WDYT?
>>>>
>>>> +1
>>>>
>>>
>>>
>>> why not fix the kselftest to look for the correct output?
>>
>> That is but 1 user. The general rule is that you do not change the
>> output like you did.
>>
> 
> but the output was "broken" and not consistent with all actions.
> we are not fixing this kind of thing?

It has been in hex since 2004, and you can not decide in 2021 that it is
'broken' and change it.

> so to continue with the suggestion to use print_fp and keep police
> action output broken and print_json for the json output?
> just to be sure before submitting change back to old output for fp.
> 
> 
> ...
>         action order 1:  police 0x1 rate 1Mbit burst 20Kb mtu 2Kb action
> reclassify overhead 0b
> 
> 
> 
> 
> -       print_string(PRINT_ANY, "kind", "%s", "police");
> +       print_string(PRINT_JSON, "kind", "%s", "police");
> 
> -       print_uint(PRINT_ANY, "index", "\tindex %u ", p->index);
> +       print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
> +       print_uint(PRINT_JSON, "index", NULL, p->index);
> 
> 

Jamal: opinions?

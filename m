Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDC2F93C8
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 17:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbhAQQE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbhAQQEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 11:04:24 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9438BC061574
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 08:03:44 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id h4so16627665qkk.4
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 08:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KFlkMVDqoW72VL1ioHetfEb7AzY86ZGvVMCGmXmhUVk=;
        b=gEUflY9yyOU9V2h9h1oOq9wBHJCek+hHaud1YwLCoF2jx0oFck6dfHUD/+a2mjATj0
         iolwFvB/VPJQuXzWaTivEKu0c/bTwXQR3a0sC23kSoCHmpVp6UZ7iQuaWdzd0DObp8Kp
         xnrRRFYxMKXMxBTh26PGbnjf7f5JS7OmeCNJ6bruf0DMoRYiDfYRBNEpeJ9kQEKzqtVp
         fc0Vw0sIWVts3CTYlqeVwucqjzIgeFG1YNLfGBTdh2ZtbtBgfRlSFAnyDgHlS5YbYMQw
         uuWEXR1mJ8F1+rzHUZaSQz99+vOpb0Z14VIYOJ6akMg3pNzMbwhqEimzw60Yw03ACx6t
         a70g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KFlkMVDqoW72VL1ioHetfEb7AzY86ZGvVMCGmXmhUVk=;
        b=jd/uYnigadT7vFvp7f9kah/XuvIsrMVFez5mgu6o614cByFLHFCweoKmXI84KmeXZz
         QIkVkcCUNkBfYhDL5h9Ebu7CVBz3hjuenSu7DRtrQ75ZqkTiBHb9VZuS4It1plwdy6fK
         v613hG7ISTqmgvGAby9ye1PPS1A4ZYK9znIQbVdIYQS7au2ajCR70L+Dxx+YcjsFchEj
         s9G26V8xSSPw5knE8tAVfYefvndaPzpwSD23sICaeQTKfU11bNUKcdBGsmEK+tKPOcDR
         Xt6PwgmpU/eYSPzUOQM0dRaeA6dDNJOrqOZ7zXisM4mRkvr9MSJlPCpm50YZq4vUC+Lr
         FR6A==
X-Gm-Message-State: AOAM5334EaOOwu68Gy6wlfJdxRdZFECkj/xTyw54JcvPXd8yer7rTmfc
        3huTvyG8p1IjdFteUuP2AHXMejvswQNsQw==
X-Google-Smtp-Source: ABdhPJyCcbl8o0ZjS0QRGcOSBksYJvU3lYiZqMwqxsOJeDC6Nt38C+Mcbl5AfYJtF24vvxyZoJ/oVA==
X-Received: by 2002:a37:b94:: with SMTP id 142mr21125459qkl.318.1610899423272;
        Sun, 17 Jan 2021 08:03:43 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id g28sm8451351qtm.91.2021.01.17.08.03.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 08:03:42 -0800 (PST)
Subject: Re: [PATCH net-next 7/7] net: ipa: allow arbitrary number of
 interconnects
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210115125050.20555-1-elder@linaro.org>
 <20210115125050.20555-8-elder@linaro.org>
 <20210116191207.277a391a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <466069e3-2658-5ba7-7704-2cac3293f79a@linaro.org>
Date:   Sun, 17 Jan 2021 10:03:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210116191207.277a391a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/21 9:12 PM, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 06:50:50 -0600 Alex Elder wrote:
>> Currently we assume that the IPA hardware has exactly three
>> interconnects.  But that won't be guaranteed for all platforms,
>> so allow any number of interconnects to be specified in the
>> configuration data.
>>
>> For each platform, define an array of interconnect data entries
>> (still associated with the IPA clock structure), and record the
>> number of entries initialized in that array.
>>
>> Loop over all entries in this array when initializing, enabling,
>> disabling, or tearing down the set of interconnects.
>>
>> With this change we no longer need the ipa_interconnect_id
>> enumerated type, so get rid of it.
> 
> Okay, all the platforms supported as of the end of the series
> still have 3 interconnects, or there is no upstream user of
> this functionality, if you will. What's the story?

The short answer is that there is another version of IPA that
has four interconnects instead of three.  (A DTS file for it is
in "sdxprairie.dtsi" in the Qualcomm "downstream" code.)  I hope
to have that version supported this year, but it's not my top
priority right now.  Generalizing the interconnect definitions
as done in this series improves the driver, but you're right, it
is technically not required at this time.

And some more background:
The upstream IPA driver is derived from the Qualcomm downstream
code published at codeaurora.org.  The downstream driver is huge
(it's well over 100,000 lines of code) and it supports lots of
IPA versions and some features that are not present upstream.

In order to have any hope of getting upstream support for the
IPA hardware, the downstream driver functionality was reduced,
removing support for filtering, routing, and NAT.  I spent many
months refactoring and reworking that code to make it more
"upstreamable," and eventually posted the result for review.

Now that there is an upstream driver, a long term goal is to
add back functionality that got removed, matching the most
important features and hardware support found in the downstream
code.  So in cases like this, even though this feature is not
yet required, adding it now lays groundwork to make later work
easier.

Everything I do with the upstream IPA driver is aimed at in-tree
support for additional IPA features and hardware versions.  So
even if an improvement isn't required *now*, there is at least
a general plan to add support "soon" for something that will
need it.

Beyond even that, there are some things I intend to do that
will improve the driver, even if they aren't technically
required near-term.  For example, I'd like to dynamically
allocate endpoints based on what's needed, rather than
having the driver support any number of them up to a maximum
fixed at build time.

Probably a longer response than you needed, but I thought it
would help to provide more background.  Besides, you *did* ask
for "the story..."

					-Alex

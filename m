Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C7C2FA8CD
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393604AbhARS2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407573AbhARS2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:28:36 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03BBC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:27:55 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id n11so19259249lji.5
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c+JLoS/8k9gsz8+5J1k+3cdSHeY1ylEGEEzag/C3Y0A=;
        b=IeVW5Bc5Eg8YHTB/l+72vfEg5uJjLii5u3cxCMI2eaVTCXJLWOlXpzjQNCk81YmZ7T
         hc5ySnNaoBfiOrjSQ92M7Xv5Pnnns0l5Ihg8It55BC5tYR39P9WZFbto2fP4W99ZhEWP
         2VvfWDv9JhJLKGTlXR6nfxJh0ZPcymR0Vgd88bwhlLbwej+MVMKt82AI0fSVoTiOtOBt
         iT5CmTQpoP9lnpqhLHYc+o33512fwJLySCz3lPe2UldCP8NC3aP23vXz+UHlM3IfUHmv
         Rsq9KftEFBISyjXW9rHs95hO7WaXcSpI6Ug67TNqdfDQM1QGIzGYSytztnfXVylY6X4H
         mp7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c+JLoS/8k9gsz8+5J1k+3cdSHeY1ylEGEEzag/C3Y0A=;
        b=LVsb4b6CnZFeTgXn9hL0RMfWCY/M9EG8wK10q1j+XubSI0tFOF5PGsoQoIPoMRkZ++
         5Wlu5dUWj9ihSLSm2L/JTzcRMLLInJOCzc2WQ6W1fLPVxcUt/GCknLipLUu1YI3YWkm/
         4QFEbBbPqvttcz1JUpdeloVjg0TIyiIXx0UumL+/moSEo10ptzYsFh3VK1C7GExg272o
         vcWjYteYNSjPnfyynDHe3WVwGQwmLzrWjLROwelWoB4dz07OPMi+WxboHo4tR+L03bu/
         u6r982VArW/k6rxtLcrZ+VqhyIWS7hmjMjqc1CeuxrR8/G+mjSnjEK1h6vx+gShMSrec
         uofw==
X-Gm-Message-State: AOAM530MtesCEFEJFfSodY8EkKzgDfJ0SuQEv3bccJ2YtaPVmByl94tN
        7BuWc3362fAZ/985RuQASc/jhA==
X-Google-Smtp-Source: ABdhPJwEPNHpKusMFMEnk1D5PKXzZlrhH8sT4hP5kVX7FgIBdR6EqEbg8cZToJMf/rIyUjcaK6QONQ==
X-Received: by 2002:a2e:b5ce:: with SMTP id g14mr365252ljn.493.1610994474285;
        Mon, 18 Jan 2021 10:27:54 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id e9sm1980238lft.104.2021.01.18.10.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 10:27:53 -0800 (PST)
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org, laforge@gnumonks.org
References: <20210110070021.26822-1-pbshelar@fb.com>
 <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
 <20210118092722.52c9d890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <fea30896-e296-5eb3-4202-05a6bf2c1e8e@norrbonn.se>
Date:   Mon, 18 Jan 2021 19:27:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210118092722.52c9d890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 18/01/2021 18:27, Jakub Kicinski wrote:
> On Sun, 17 Jan 2021 14:23:52 +0100 Jonas Bonn wrote:
>> On 17/01/2021 01:46, Jakub Kicinski wrote:
>>> On Sat,  9 Jan 2021 23:00:21 -0800 Pravin B Shelar wrote:
>>>> Following patch add support for flow based tunneling API
>>>> to send and recv GTP tunnel packet over tunnel metadata API.
>>>> This would allow this device integration with OVS or eBPF using
>>>> flow based tunneling APIs.
>>>>
>>>> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
>>>
>>> Applied, thanks!
>>
>> This patch hasn't received any ACK's from either the maintainers or
>> anyone else providing review.
> 
> I made Pravin wait _over_ _a_ _month_ to merge this. He did not receive
> any feedback since v3, which was posted Dec 13th. That's very long.

Merge window, Christmas, New Year, 3 kings, kids out of school, holiday 
hangover... certain times of the year four weeks are not four weeks.

> 
> v5 itself was laying around on patchwork for almost a week, marked as
> "Needs Review/Ack".

When new series show up just hours after review, it's hard to take them 
seriously.  It takes a fair amount of time to go through an elephant 
like this and to make sense of it; the time spent in response to review 
commentary shouldn't be less.

> 
> Normally we try to merge patches within two days. If anything my
> lesson from this whole ordeal is in fact waiting longer makes
> absolutely no sense. The review didn't come in anyway, and we're
> just delaying whatever project Pravin needs this for :/

I think the expectation that everything gets review within two days is 
unrealistic.  Worse though, is the insinuation that anything unreviewed 
gets blindly merged...  No, the two day target should be for the merging 
of ACK:ed patches.

> 
> Do I disagree with you that the patch is "far from pretty"? Not at all,
> but I couldn't find any actual bug, and the experience of contributors
> matters to us, so we can't wait forever.
> 
>> The following issues remain unaddressed after review:
>>
>> i)  the patch contains several logically separate changes that would be
>> better served as smaller patches
>> ii) functionality like the handling of end markers has been introduced
>> without further explanation
>> iii) symmetry between the handling of GTPv0 and GTPv1 has been
>> unnecessarily broken
>> iv) there are no available userspace tools to allow for testing this
>> functionality
> 
> I don't understand these points couldn't be stated on any of the last
> 3 versions / in the last month.

I believe all of the above was stated in review of series v1 and v2.  v3 
was posted during the merge window so wasn't really relevant for review. 
  v4 didn't address the comments from v1 and v2.  v5 was posted 3 hours 
after receiving reverse christmas tree comments and addressed only 
those.  v5 received commentary within a week... hardly excessive for a 
lightly maintained module like this one.

> 
>> I have requested that this patch be reworked into a series of smaller
>> changes.  That would allow:
>>
>> i) reasonable review
>> ii) the possibility to explain _why_ things are being done in the patch
>> comment where this isn't obvious (like the handling of end markers)
>> iii) the chance to do a reasonable rebase of other ongoing work onto
>> this patch (series):  this one patch is invasive and difficult to rebase
>> onto
>>
>> I'm not sure what the hurry is to get this patch into mainline.  Large
>> and complicated patches like this take time to review; please revert
>> this and allow that process to happen.
> 
> You'd need to post a revert with the justification to the ML, so it can
> be reviewed on its merits. That said I think incremental changes may be
> a better direction.
> 

I guess I'll have to do so, but that seems like setting the bar higher 
than for even getting the patch in in the first place.

I don't think it's tenable for patches to sneak in because they are so 
convoluted that the maintainers just can't find the energy to review 
them.  I'd say that the maintainers silence on this particular patch 
speaks volumes in itself.

Sincerely frustrated because rebasing my IPv6 series on top of this mess 
will take days,
/Jonas

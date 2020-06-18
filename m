Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF96A1FFAFF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbgFRSZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgFRSZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:25:42 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A8CC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:25:41 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x6so7065597wrm.13
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 11:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wt87wWYyn5forNx54aLX2zmfFWn5oRXhU2aN0OQ5X04=;
        b=JWVGfiKKWYvniJ88F0cFA1SnHw31RdqtD0wY91rJoa4jB/ya8YFJCRIV0qpb6afYmM
         hhL/nDp3EKA2M6VMeA6ouNWBxH8oUt7fJWD7prnpUNNjIt+J3+zXMI5IR1tz9Qx6bBae
         n7usy8Dk6vFtcXO3vo9f6jlL547tJ0S26VfpK/KXwP2xWR5kY0GkL/VvBnm/zYnpm7c3
         RfFhmkXiunvIsprXZGemEC9z6KI/9oFZ/hXMp/CWtVP1ZU0G7AC8kBR1l4ILNrjtie4N
         TIcRs/T26809qKsWL4g0K1KQ+I3cL92fnf5dXq51YtiV4dJLI9CLZ9XsMwlGP/meVn+j
         Dkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wt87wWYyn5forNx54aLX2zmfFWn5oRXhU2aN0OQ5X04=;
        b=MNgx3gNsU8pdVU5EPwNs3ihognxorKJJRta2oSvWr/ryTyUrAB2cG4/qN0yb/QRZoC
         BlaOmmHRwFG4YIdwbi8JtpVkmF8PTRFDo4xF+2/0wVK/Enug5iBqrp3dYP452MXXSfA/
         Sl1e4/A3r5MOFaLXhyK13RdmqEwVsKvxq8XmqCVMWG1H1OYWk0ULUMfbGGir4IZVvXO2
         lh8DMxmzn1vMx8eEU9Dd9SJf7sDV9zUZ5w3LbHb/6Fs37o7+RX1eHQfhvnXg2YyZeWil
         nN06OeqzfhWv4yse8qTBfadMDVLNGGKpEfBFIHWLW2ccRhb1ISlZ7aYskO5fvwXNsRAV
         fzWg==
X-Gm-Message-State: AOAM533NfxNvuHqjpHlP7GACB3ywMKksf/tFlZd7iVckTN9+7qcMaFf1
        8pDJwTWuumQc65hzTRKpfK93eUdO
X-Google-Smtp-Source: ABdhPJwMeODqH9cMgx3PtVpGl99VIMtGj7ckciJhmDClfs+sM8Za4SlB8cVRjDksAI3EHLcnbFbOrw==
X-Received: by 2002:adf:eacc:: with SMTP id o12mr6184037wrn.139.1592504740277;
        Thu, 18 Jun 2020 11:25:40 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h203sm4137054wme.37.2020.06.18.11.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 11:25:39 -0700 (PDT)
Subject: Re: [PATCH] net: macb: reject unsupported rgmii delays
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>
References: <20200616074955.GA9092@laureti-dev>
 <20200617105518.GO1551@shell.armlinux.org.uk>
 <CA+h21hotpF58RrKsZsET9XT-vVD3EHPZ=kjQ2mKVT2ix5XAt=A@mail.gmail.com>
 <20200617113410.GP1551@shell.armlinux.org.uk>
 <CA+h21hqrDd6FLS7vhBW6GUdi8MvimiisyEbQLE0ZfasoQ1EQbw@mail.gmail.com>
 <20200617115725.GR1551@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <56bc9197-acb5-b537-13a9-6e0c3511bdef@gmail.com>
Date:   Thu, 18 Jun 2020 11:25:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617115725.GR1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/2020 4:57 AM, Russell King - ARM Linux admin wrote:
> On Wed, Jun 17, 2020 at 02:38:25PM +0300, Vladimir Oltean wrote:
>> On Wed, 17 Jun 2020 at 14:34, Russell King - ARM Linux admin
>> <linux@armlinux.org.uk> wrote:
>>>
>>
>>>
>>> Why are you so abrasive?
>>>
>>> Not responding to this until you start behaving more reasonably.
>>>
>>> --
>>> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>>> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
>>
>> Sorry.
>> What I meant to say is: the documentation is unclear. It has been
>> interpreted in conflicting ways, where the strict interpretations have
>> proven to have practical limitations, and the practical
>> interpretations have been accused of being incorrect. In my opinion
>> there is no way to fix it without introducing new bindings, which I am
>> not sure is really worth doing.
> 
> The documentation was added in 2016, many years after we have had users
> of this, in an attempt to clear up some of the confusion.  It is likely
> that it had to cater for existing users though - I'm sure if Florian
> cares, he can comment on that.

The need to clarify the 'phy-mode' property came in while reviewing the
aurora network driver and trying to make sense of what should be done
for a new driver in a way that would result in hopefully less confusion
moving forward.

> 
> It would be better if it made a definitive statement about it, but doing
> so would likely attract pedants to try to fix everything to conform,
> causing breakage in the process.

Exactly.

> 
> I've recently had a painful experience of this with the Atheros PHYs,
> where there are lots of platforms using "rgmii" when they should have
> been using "rgmii-id".  A patch changed this in the Atheros code breaking
> all these platforms, breakage which persisted over several kernel
> versions, needing fixes to DT files that then had to be back-ported.
> That's fine if you know what happened to break it, but if you don't, and
> you don't know what the fix is, you're mostly stuffed and stuck with non-
> working ethernet.  That really was not nice.
> 
> This is one of the reasons why I press for any new PHY interface mode
> to be documented in the phylib documentation right from the start, so
> that hopefully we can avoid this kind of thing in the future.
> 

It seems to be that this is a very RGMII specific problem and no other
electrical interface appears to have that problem, or it solves it
differently without requiring massive baby sitting from software (or
even more, just not for that particular problem maybe).
-- 
Florian

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77CE81500D8
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBCEE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:04:29 -0500
Received: from mail-il1-f175.google.com ([209.85.166.175]:43769 "EHLO
        mail-il1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgBCEE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:04:29 -0500
Received: by mail-il1-f175.google.com with SMTP id o13so11407436ilg.10
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 20:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=07+t3uQ7jxnLdAKsE1N4Bz4rBWPeYpwj/dbDxZ3VurE=;
        b=mn55pq00FsImJk7X1mq2uQuWnu6QpJqEIHjCnTMXaMNogJOdJlngytur23PDyXZ0Sg
         WZEJmBGUKTP/niNzqbDBZ1KNMaXDGk3q7rGZ4JhJse31lUCuRh7MWYgzQj2z1QQ3UWxo
         NblpkwTyKCDQTKFAN0dS4wuYw955rUJSIPgjRiHzt4IY6G1ej4zTdVnpSA3RkSmXAuJ9
         Hnej0t54a3VkDsdngXnRY5jMSs1+JhSfznK9rG5+NcYVPQe+YvGyqxFdt3c6bvNmsDm7
         Nox56UTKb4ZOBhKUeBuruV/RBiog2OFz+dvmEzHC9NLttr+yEXKLPcjy9CXmbBlzk0dY
         3ObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=07+t3uQ7jxnLdAKsE1N4Bz4rBWPeYpwj/dbDxZ3VurE=;
        b=XBsF4F5twPkmQ98tmX+lx2HY9PQLGic7htZzGe0C1Zmu1tdKS1SorJVRybfB0tJgab
         3ZN51UDN0w6Nvuxmk+A22OwUAictrdbdQiWyHs4F09z6wj7oNDwP1mEcmItvcLM76cNB
         1KhBMjYVPP1I+RQsc5Y4cHPC0XnzJgOJTlqEI/lYVvL4XmpWT2jn06bba2Df42Os56Jt
         HpMYlebQVFWvaPmdUhjluOOQD5Xbejok1P9L1nwpFRFx0MJ7Sosh6bTCRIViEUS1qQKR
         Qkb+EdBal353qCCK3EpqYcnGAIPwSuzN6JjfEkmUWp2l6Gxq6fIIM4a2bq1BG5JO1YLm
         ONlA==
X-Gm-Message-State: APjAAAWpy7ZVtvLmCG3hQRSwagXrprATZTAftBCfaCDogSjNDa1MT4aO
        IlfOW3VDS4M5FWSyD8Dp/R15puIS
X-Google-Smtp-Source: APXvYqzmhTDeN6wN/A9+koUEx6NIj7iR0Tw/QbsFcP0CMbmGbv4JbC80zZEVeTl/2eKae4CTfnbrYw==
X-Received: by 2002:a92:1d92:: with SMTP id g18mr13554528ile.23.1580702667105;
        Sun, 02 Feb 2020 20:04:27 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2529:5ed3:9969:3b0e? ([2601:282:803:7700:2529:5ed3:9969:3b0e])
        by smtp.googlemail.com with ESMTPSA id l17sm6636639ilc.49.2020.02.02.20.04.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Feb 2020 20:04:26 -0800 (PST)
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     Trev Larock <trev@larock.ca>
Cc:     Ben Greear <greearb@candelatech.com>, netdev@vger.kernel.org
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
 <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
 <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
 <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com>
 <fe7ec5d0-73ed-aa8b-3246-39894252fec7@gmail.com>
 <CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <523c649c-4857-0d17-104e-fb4dc4876cc1@gmail.com>
Date:   Sun, 2 Feb 2020 21:04:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/20 8:13 PM, Trev Larock wrote:
> On Mon, Jan 13, 2020 at 11:51 AM David Ahern <dsahern@gmail.com> wrote:
>> Trev's problem is looping due to the presence of the qdisc. The vrf
>> driver needs to detect that it has seen the packet and not redirect it
>> again.
> Yes note it was when specifying no dev on the xfrm policy/state.
> For the non-qdisc case the policy triggered from the __ip4_datagram_connect->
> xfrm_lookup and the vrf "direct" route sent it out without any xfrm_lookup call.
> It appears to work but it's not really a "xfrm vrf specific " policy.
> 
> For qdisc the policy matched again on the vrf->xfrm_lookup call.
> 

I understand the problem you are facing. It is limited to xfrm + 	qdisc
on VRF device. I have a proposal for how to fix it:

    https://github.com/dsahern/linux vrf-qdisc-xfrm

Right now I am stuck on debugging related xfrm cases - like xfrm
devices, vrf device in the selector, and vti device. I feel like I need
to get all of them working before sending patches, I just lack enough time.

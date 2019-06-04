Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6972935167
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFDUzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 16:55:20 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:38139 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfFDUzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 16:55:20 -0400
Received: by mail-wr1-f46.google.com with SMTP id d18so17256642wrs.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 13:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=blfnqOSDorl2cdNxWhI/xPE58WtmiUx318SuUhSD9Dk=;
        b=N87PDMWpbVZMn5fHMAPMRVKclR7q2XXhf8GzW8HDTUmVDvkVKAX7TAFSma0UM5RyPF
         qUF7X/0jtpsDSD2/BTmaashQrNYxiH0BvwY1OBhXq11gwoop4tFBrEeLsl/jrp+Iivb6
         gxltQkIanGx8cTTR7WW2CxtOHJdv2b0NqO3KC+b4aD2Iq3Qb3yZ7DgMfVDywRtzukHNV
         DK5j1gWG8fzbFibCGSrEGqsHspK82F624bR+tAxauJHbydeJLfBZYuOAIcS7nnb0hbeC
         HLMiIpHMJxdtAmKOJVTNIYrvDVAj/0HSRXbHHkhyMc6ED/dJnxB0eyOE6dVhVYDfBOrV
         y8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=blfnqOSDorl2cdNxWhI/xPE58WtmiUx318SuUhSD9Dk=;
        b=Jhyn5FZbevnkBDCd6Q2JpfLkoaNNcvmH7pxjazeGf/KEY5BLzkooxfmk85XcdsfFdB
         xFfbgGb0812UxKf6iT36Ou5Bka7TKcw2NghkGIiz7jFBsa0nVWZeD71v0OD4zSeUwnJ9
         40GtACGmAEK45hhz25a+d0SVzmS7VSGVUPjvI3VEm+nVKg+WzDmC8Lp0UjMjEuBOf8MG
         QFjcPkUk7NWZxb7fx3BN3SqMGjGMCJl9YKXsooMc6f33zm+O8XrMj6iC9/ti5I9pFWmg
         E1E6gQNMQMm4IiaR/CTP86HxwQkZK2ENUjQY0OKUdb9wHpXGzIGBrCQF7a6ZC+j7C8vK
         285A==
X-Gm-Message-State: APjAAAViJ9lTfaFvuNQJH8aIXGLvYiaXMVBqwK60pz6XPeMC0sPgFWj3
        Q9fGw0TOeGmEAIQ4UxayeJY=
X-Google-Smtp-Source: APXvYqwNoHNFDIH0sOqDSXF7ZmFNCMTz03eCvySpGuRj54J6e2RjOdKclhDgaW3BmQvHdkYlksWJlA==
X-Received: by 2002:a5d:6652:: with SMTP id f18mr7549836wrw.19.1559681718006;
        Tue, 04 Jun 2019 13:55:18 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2? (p200300EA8BF3BD00CD0DE1C0529B04E2.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:cd0d:e1c0:529b:4e2])
        by smtp.googlemail.com with ESMTPSA id y184sm12855349wmg.14.2019.06.04.13.55.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 13:55:16 -0700 (PDT)
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch>
 <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5b1c1578-bbf9-8f8c-6657-8f1cceb539d1@gmail.com>
Date:   Tue, 4 Jun 2019 22:55:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.06.2019 22:42, Vladimir Oltean wrote:
> On Tue, 4 Jun 2019 at 23:07, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Tue, Jun 04, 2019 at 10:58:41PM +0300, Vladimir Oltean wrote:
>>> Hi,
>>>
>>> I've been wondering what is the correct approach to cut the Ethernet link
>>> when the user requests it to be administratively down (aka ip link set dev
>>> eth0 down).
>>> Most of the Ethernet drivers simply call phy_stop or the phylink equivalent.
>>> This leaves an Ethernet link between the PHY and its link partner.
>>> The Freescale gianfar driver (authored by Andy Fleming who also authored the
>>> phylib) does a phy_disconnect here. It may seem a bit overkill, but of the
>>> extra things it does, it calls phy_suspend where most PHY drivers set the
>>> BMCR_PDOWN bit. Only this achieves the intended purpose of also cutting the
>>> link partner's link on 'ip link set dev eth0 down'.
>>
>> Hi Vladimir
>>
>> Heiner knows the state machine better than i. But when we transition
>> to PHY_HALTED, as part of phy_stop(), it should do a phy_suspend().
>>
>>    Andrew
> 
> Hi Andrew, Florian,
> 
> Thanks for giving me the PHY_HALTED hint!
> Indeed it looks like I conflated two things - the Ehernet port that
> uses phy_disconnect also happens to be connected to a PHY that has
> phy_suspend implemented. Whereas the one that only does phy_stop is
> connected to a PHY that doesn't have that... I thought that in absence
> of .suspend, the PHY library automatically calls genphy_suspend. Oh
> well, looks like it doesn't. So of course, phy_stop calls phy_suspend
> too.
> But now the second question: between a phy_connect and a phy_start,
> shouldn't the PHY be suspended too? Experimentally it looks like it
> still isn't.
> By the way, Florian, yes, PHY drivers that use WOL still set
> BMCR_ISOLATE, which cuts the MII-side, so that's ok. However that's
> not the case here - no WOL.
> 
Right, some PHY driver callbacks fall back to the generic functionality,
for the suspend/resume callbacks that's not the case.
phy_connect() eventually calls phy_attach_direct() that has a call to
phy_resume(). So your observation is correct, phy_connect() wakes the
PHY. I'm not 100% sure whether this is needed because also phy_start()
resumes the PHY.

BMCR_ISOLATE isn't set by any phylib function. We just have few
calls where BMCR_ISOLATE is cleared as part of the functionality.

> Regards,
> -Vladimir
> 
Heiner

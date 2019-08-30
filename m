Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4955A2F88
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 08:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfH3GNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 02:13:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54014 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfH3GNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 02:13:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id 10so5982839wmp.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 23:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mIaRAmZlXfrUjHkJ2pUtw5Qyx4E/Zd4jn5MOod/LYBs=;
        b=n7fov0x47sWP5sCMWoI5rq1YKFAt3fENNVa7hKIxjXLPyJnd8Ua2g7xj1VBit6kbd3
         0nqV2Wpe1JHoFm34DmXbVlz4YQnhNYhDVgcVou1/k5gnQVK8cEx2Fx4/jBSkORs+2TDh
         OeoAMJ2WlkuQxBBMXzmwFi4/GC9V5Mcqk9thteQP9ci50ZH8BnW4UMEWftep4dQ1uXbd
         JOUKUJq6uFY0O/97wiGWSrmElPY9Rg+FwGDE+TQmEk1HBIUKKCYgqhWvZqncBtegy3z1
         CgPE78jUNUJ8/K+E+LKDCvr52JKo+Fp2Pj9ZdvinnLBxzNvPZWj6udtxls+BcGqURCET
         VAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mIaRAmZlXfrUjHkJ2pUtw5Qyx4E/Zd4jn5MOod/LYBs=;
        b=UCQEOh3UxiDWrDAFKq+wyI/3kWzOdWjIzk5amLeovlVppm2lXYOrzUHRaVMBy2IPUB
         smm7tls/sQ/MyIQu6l5ExcYtfFprMn+dQVTQj/fpaJgPlS9XKTAw0EtraCF4eLcQGnHp
         /JWsvl9j/HleLKNh8SODOEKwSwAAA3powDgH2+jxxKx3ZoAuvD3PGLGy41yNUH69W7+T
         6a/mrg2WiYOF3uiAJN84zV+B1RCSAkaAIP+iZw72CfjgxfyIT8vVvx3uRj2aq2HaMWDv
         IDb6ddTolpozDbe8m8Ax24jvby7EXkqfeDcXolLg0ofUe0rgjEL0NL6U8vkXNxpmggb/
         Pl3g==
X-Gm-Message-State: APjAAAW1R0tRCsG8S4GaRdf3RtWyld4J74Fj8hVM6AVtg5vMSDEx2gLt
        8q/jB9GfRHL++WPROGVnaHf1CQ==
X-Google-Smtp-Source: APXvYqzgSjDY01QZirK6eSfj6ygsDQjdl74s3/VEjfgEpizF1MqSMoTDCtlSWInLYPaY73yFDtJ3WA==
X-Received: by 2002:a05:600c:2245:: with SMTP id a5mr8590411wmm.53.1567145608620;
        Thu, 29 Aug 2019 23:13:28 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id j9sm3826665wrx.66.2019.08.29.23.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 23:13:28 -0700 (PDT)
Date:   Fri, 30 Aug 2019 08:13:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, allan.nielsen@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190830061327.GM2312@nanopsycho>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829132611.GC6998@lunn.ch>
 <20190829134901.GJ2312@nanopsycho>
 <20190829143732.GB17864@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829143732.GB17864@lunn.ch>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Aug 29, 2019 at 04:37:32PM CEST, andrew@lunn.ch wrote:
>> Wait, I believe there has been some misundestanding. Promisc mode is NOT
>> about getting packets to the cpu. It's about setting hw filters in a way
>> that no rx packet is dropped.
>> 
>> If you want to get packets from the hw forwarding dataplane to cpu, you
>> should not use promisc mode for that. That would be incorrect.
>
>Hi Jiri
>
>I'm not sure a wireshark/tcpdump/pcap user would agree with you. They
>want to see packets on an interface, so they use these tools. The fact
>that the interface is a switch interface should not matter. The
>switchdev model is that we try to hide away the interface happens to
>be on a switch, you can just use it as normal. So why should promisc
>mode not work as normal?

It does, disables the rx filter. Why do you think it means the same
thing as "trap all to cpu"? Hw datapath was never considered by
wireshark.

In fact, I have usecase where I need to see only slow-path traffic by
wireshark, not all packets going through hw. So apparently, there is a
need of another wireshark option and perhaps another flag
IFF_HW_TRAPPING?.

tcpdump -i eth0
tcpdump -i eth0 --no-promiscuous-mode
tcpdump -i eth0 --hw-trapping-mode


> 
>> If you want to get packets from the hw forwarding dataplane to cpu, you
>> should use tc trap action. It is there exactly for this purpose.
>
>Do you really think a wireshark/tcpdump/pcap user should need to use
>tc trap for the special case the interface is a switch port? Doesn't that
>break the switchdev model?
>
>tc trap is more about fine grained selection of packets. Also, it
>seems like trapped packets are not forwarded, which is not what you
>would expect from wireshark/tcpdump/pcap.
>
>      Andrew

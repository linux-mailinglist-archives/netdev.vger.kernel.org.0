Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11827A5C5F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfIBSqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:46:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55924 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbfIBSqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:46:02 -0400
Received: by mail-wm1-f68.google.com with SMTP id g207so11575351wmg.5
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 11:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Gbv8DVb1rpLkpDqApLaTwYoA0SQ/zWkULUB+jO4dP28=;
        b=l6E1gl8FRLj/yEk6uV+en7+oI2klMala2wWtBXuyWlDL7Fs4KbdGIEvB/wiRwmP2l0
         bH2JcWM5ZJTw3Bu9kl+SYHXoC6It0ndDSXAZvrdYvtOimTR6DRK3fBI/Wx0usTgT/b03
         kWyHAPSyORfRWJ3VAa9ENKxMfzumeQEZMgsBJMJ0w2vSOLH52EAZnLKMqEk7dbRX+C/2
         k9amfuy7onIoXqAGGHQGEIZoEUl20VySD60l+c8OUSQo2mOrH5AQO3REXNfJidHPH7mI
         tqd1cQBH+7yoINuY7RoQjKWdb2tfEEwI/A3oyTtq7mvXalTcDRzBN6PeKa6ziHb6H9FW
         56ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Gbv8DVb1rpLkpDqApLaTwYoA0SQ/zWkULUB+jO4dP28=;
        b=fdiwiurBz/EvP+TQiNR5IIp6IrZvDFL2/siYj49CCYVC1VdXMtvBOiZ6GFnMAlQK/Z
         6ig3CTGvqOJ7y9++/SpDUjl46tRg0Ze8CJL9I9Idup5AHYA3FSscHshx/ArAfmqKP8AE
         xLyCAsLnUzjgSTSvrf2guCFlwRbpTsTFXo/1leerFKQQF4MzvPSRnoUBma0pba12c5iv
         stCpMrvYS+cVImAsf9Ftg8YL7m5nIAbJa21wHy3Ey8cM1uZgUyVnF7kDzZ3KUmYXhtZj
         hI2U6p+h/QrZj89WUxTQBKZET5EILmHkGM0coJdFUyZNHVglL8LyNaof3xX8pv6JiIbo
         MWTQ==
X-Gm-Message-State: APjAAAVgDcLkvjAohZG+yPwuTD49oCsFWzCjgI7N9QPjqY9BakshidHF
        gmVIJ0wER9Chb7PndZLorU3jl+z4E2A=
X-Google-Smtp-Source: APXvYqz/R1TcZT6kyCoqMKCXVcRH7hUURx8AEQ7PLdZRgdVZ0PM8TpaI1iN7Top+9ETPw9lUAgx85w==
X-Received: by 2002:a1c:9805:: with SMTP id a5mr605930wme.119.1567449959287;
        Mon, 02 Sep 2019 11:45:59 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id q192sm3602237wme.23.2019.09.02.11.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 11:45:58 -0700 (PDT)
Date:   Mon, 2 Sep 2019 20:45:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     David Miller <davem@davemloft.net>, idosch@idosch.org,
        andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivecera@redhat.com, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190902184557.GB2312@nanopsycho>
References: <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
 <20190830053940.GL2312@nanopsycho>
 <20190829.230233.287975311556641534.davem@davemloft.net>
 <20190830063624.GN2312@nanopsycho>
 <20190902174229.uur7r7duq4dvbnqq@lx-anielsen.microsemi.net>
 <20190902175124.GA2312@nanopsycho>
 <20190902180519.ytbs6x2dx5z23hys@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190902180519.ytbs6x2dx5z23hys@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 02, 2019 at 08:05:20PM CEST, allan.nielsen@microchip.com wrote:
>The 09/02/2019 19:51, Jiri Pirko wrote:
>> External E-Mail
>> 
>> 
>> Mon, Sep 02, 2019 at 07:42:31PM CEST, allan.nielsen@microchip.com wrote:
>> >Hi Jiri,
>> >
>> >Sorry for joining the discussion this late, but I have been without mail access
>> >for the last few days.
>> >
>> >
>> >The 08/30/2019 08:36, Jiri Pirko wrote:
>> >> Fri, Aug 30, 2019 at 08:02:33AM CEST, davem@davemloft.net wrote:
>> >> >From: Jiri Pirko <jiri@resnulli.us>
>> >> >Date: Fri, 30 Aug 2019 07:39:40 +0200
>> >> >
>> >> >> Because the "promisc mode" would gain another meaning. Now how the
>> >> >> driver should guess which meaning the user ment when he setted it?
>> >> >> filter or trap?
>> >> >> 
>> >> >> That is very confusing. If the flag is the way to do this, let's
>> >> >> introduce another flag, like IFF_TRAPPING indicating that user wants
>> >> >> exactly this.
>> >> >
>> >> >I don't understand how the meaning of promiscuous mode for a
>> >> >networking device has suddenly become ambiguous, when did this start
>> >> >happening?
>> >> 
>> >> The promiscuity is a way to setup the rx filter. So promics == rx filter
>> >> off. For normal nics, where there is no hw fwd datapath,
>> >> this coincidentally means all received packets go to cpu.
>> >> But if there is hw fwd datapath, rx filter is still off, all rxed packets
>> >> are processed. But that does not mean they should be trapped to cpu.
>> >> 
>> >> Simple example:
>> >> I need to see slowpath packets, for example arps/stp/bgp/... that
>> >> are going to cpu, I do:
>> >> tcpdump -i swp1
>> >
>> >How is this different from "tcpdump -p -i swp1"
>> >
>> >> I don't want to get all the traffic running over hw running this cmd.
>> >> This is a valid usecase.
>> >> 
>> >> To cope with hw fwd datapath devices, I believe that tcpdump has to have
>> >> notion of that. Something like:
>> >> 
>> >> tcpdump -i swp1 --hw-trapping-mode
>> >> 
>> >> The logic can be inverse:
>> >> tcpdump -i swp1
>> >> tcpdump -i swp1 --no-hw-trapping-mode
>> >> 
>> >> However, that would provide inconsistent behaviour between existing and
>> >> patched tcpdump/kernel.
>> >> 
>> >> All I'm trying to say, there are 2 flags
>> >> needed (if we don't use tc trap).
>> >
>> >I have been reading through this thread several times and I still do not get it.
>> >
>> >As far as I understand you are arguing that we need 3 modes:
>> >
>> >- tcpdump -i swp1
>> 
>> Depends on default. Promisc is on.
>> 
>> 
>> >- tcpdump -p -i swp1
>> 
>> All traffic that is trapped to the cpu by default, not promisc means
>> only mac of the interface (if bridge for example haven't set promisc
>> already) and special macs. So host traffic (ip of host), bgp, arp, nsnd,
>> etc.
>
>In the case where the interface is enslaved to a bridge, it is put into promisc
>mode, which means that "tcpdump -i swp1" and "tcpdump -p -i swp1" give the same
>result, right?
>
>Is this desirable?

Yes, that is correct and expected. It it might not be bridged, depends
on a usecase.


>
>> >- tcpdump -i swp1 --hw-trapping-mode
>> 
>> Promisc is on, all traffic received on the port and pushed to cpu. User
>> has to be careful because in case of mlxsw this can lead to couple
>> hundred gigabit traffic going over limited pci bandwidth (gigabits).
>> 
>> 
>> >
>> >Would you mind provide an example of the traffic you want to see in the 3 cases
>> >(or the traffic which you do not want to see).
>> >
>> >/Allan
>> >
>> 
>
>-- 
>/Allan

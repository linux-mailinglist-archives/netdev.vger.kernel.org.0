Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC6F2AF5
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 10:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387853AbfKGJmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 04:42:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51562 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfKGJmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 04:42:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id q70so1708616wme.1
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 01:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KORomhG7F/jEHIsrTrDRp4JZLHjo6vTjQ1xYtcCiJUE=;
        b=pzDIviL7EuQe57PU6i6GVnRr9P4S7jPKX0lZYL5rurkhrGSex4TvTsvbROePkGJeVG
         6ShGzmun6hjBTOCV+obt9WambGPBhSLy0kdPHxMEEsNnt4xLaHcQmQnkx36yiO8c/qFe
         ziw9HLTas1qMpVqt/UQET8cVliUr7HC66reZyh8rihNNSQnS9VTNYZ+YaNnoqXFm3L5B
         O8psIhOvai4ejrKMDfu8REnwhW40CSJX3MzqwDmHa1njdcCxni4Hwu1e02PsIzK3Q2lZ
         z+dYjF0d2Da5CbuVag8mJYchGsGKbGYpfQBFAUVSIVoM0U3LfW6JwjgeC3h7Jwk0tmbq
         9xGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KORomhG7F/jEHIsrTrDRp4JZLHjo6vTjQ1xYtcCiJUE=;
        b=l9aQji+NF3jMLTiU2oxETzK8+m6a8g1nWTWCfk9QfuySGnBc90dLM5706m+5HYOM4J
         bWxEKAhCqTC/TvERzP4oomDJ3N24VLEKhyo0HnmhSYyrEx35u9yaST+ea2ACQhux6SAY
         Amb2WLh9ygAFxza8Lkg2eAnBFz7+gQTo/l7yOkJuzwGURkWcg7f73lyE6DXJfKkn0aHK
         tncXXdtk5SsKKuf80x50FnkFcXlr+45/31zFXK60nPNRAiVDE6Rm4q5uNO8m97rFX5YT
         +kwtA5lOgf+C58EXhPOUbYrQOnH5h1KRu2VGHP8fxwNRaXJ2UZcHVMLQQG4TgUIkZot8
         KpTg==
X-Gm-Message-State: APjAAAX22o22okW/T+mN6tDF6dbcNu7zXLvtVRbXRvWvn26ExQU+r6qJ
        yxZA4Epk4P7QASwk+B7/5cenpw==
X-Google-Smtp-Source: APXvYqzs4X3YabB/VM7xCHeigMT/brYub0vCiI9JW0ryzAVn6g4QL+ADvnQaqTwHWKRMF9GEO7G8+w==
X-Received: by 2002:a05:600c:2919:: with SMTP id i25mr1882234wmd.158.1573119757824;
        Thu, 07 Nov 2019 01:42:37 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id j63sm1953644wmj.46.2019.11.07.01.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 01:42:37 -0800 (PST)
Date:   Thu, 7 Nov 2019 10:42:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/6] mlxsw: Add extended ACK for EMADs
Message-ID: <20191107094236.GA2200@nanopsycho>
References: <20191104210450.GA10713@splinter>
 <20191104144419.46e304a9@cakuba.netronome.com>
 <20191104232036.GA12725@splinter>
 <20191104153342.36891db7@cakuba.netronome.com>
 <20191105074650.GA14631@splinter>
 <20191105095448.1fbc25a5@cakuba.netronome.com>
 <20191105204826.GA15513@splinter>
 <20191105134858.5d0ffc14@cakuba.netronome.com>
 <20191106082039.GB2112@nanopsycho>
 <20191106092647.4de42312@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106092647.4de42312@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 06, 2019 at 06:26:47PM CET, jakub.kicinski@netronome.com wrote:
>On Wed, 6 Nov 2019 09:20:39 +0100, Jiri Pirko wrote:
>> Tue, Nov 05, 2019 at 10:48:58PM CET, jakub.kicinski@netronome.com wrote:
>> >On Tue, 5 Nov 2019 22:48:26 +0200, Ido Schimmel wrote:  
>> >> On Tue, Nov 05, 2019 at 09:54:48AM -0800, Jakub Kicinski wrote:  
>> >> > Hm, the firmware has no log that it keeps? Surely FW runs a lot of
>> >> > periodic jobs etc which may encounter some error conditions, how do 
>> >> > you deal with those?    
>> >> 
>> >> There are intrusive out-of-tree modules that can get this information.
>> >> It's currently not possible to retrieve this information from the
>> >> driver. We try to move away from such methods, but it can't happen
>> >> overnight. This set and the work done in the firmware team to add this
>> >> new TLV is one step towards that goal.
>> >>   
>> >> > Bottom line is I don't like when data from FW is just blindly passed
>> >> > to user space.    
>> >> 
>> >> The same information will be passed to user space regardless if you use
>> >> ethtool / devlink / printk.  
>> >
>> >Sure, but the additional hoop to jump through makes it clear that this
>> >is discouraged and it keeps clear separation between the Linux
>> >interfaces and proprietary custom FW.. "stuff".  
>> 
>> Hmm, let me try to understand. So you basically have problem with
>> passing random FW generated data and putting it to user (via dmesg,
>> extack). However, ethtool dump is fine. Devlink health reporter is also
>> fine.
>
>Yup.
>
>> That is completely sufficient for async events/errors.
>> However in this case, we have MSG sent to fw which generates an ERROR
>> and this error is sent from FW back, as a reaction to this particular
>> message.
>
>Well, outputting to dmesg is not more synchronous than putting it in
>some other device specific facility.

Well, not really. In dmesg, you see not only the fw msg, you see it along
with the tid (sequence number) and emad register name.


>
>> What do you suggest we should use in order to maintain the MSG-ERROR
>> pairing? Perhaps a separate devlink health reporter just for this?
>
>Again, to be clear - that's future work, right? Kernel logs as
>implemented here do not maintain MSG-ERROR pairing.

As I described above, they actually do.


>
>> What do you think?
>
>In all honesty it's hard to tell for sure, because we don't see the FW
>and what it needs. That's kind of the point, it's a black box.
>
>I prefer the driver to mediate all the information in a meaningful way.
>If you want to report an error regarding a parameter the FW could
>communicate some identification of the field and the reason and the
>driver can control the output, for example format a string to print to
>logs?

You are right, it is a blackbox. But the blackbox is sending texts about
what is went wrong with some particular operation. And these texts are
quite handy to figure out what is going on there. Either we ignore them,
or we show them somehow. It is very valuable to show them.

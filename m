Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4F52B2194
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgKMRKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:10:50 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:40191 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgKMRKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 12:10:50 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2020 12:10:48 EST
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0ADH2WGo025040;
        Fri, 13 Nov 2020 18:02:37 +0100
Received: from [192.168.1.89] (93-36-192-249.ip61.fastwebnet.it [93.36.192.249])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id F3BAA120056;
        Fri, 13 Nov 2020 18:02:26 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1605286947; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0XGT7HejRnapjvO3Gk30BS4PxlUZGNYjFQlC16LvtaA=;
        b=lzCXHcWpJeW+zG20mj+MaomUDpk5DEwWODbVyfOl3URySu4F5q0BA48a5OTlXk6Zp2CSDB
        h+foRmpSQjLmX5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1605286947; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0XGT7HejRnapjvO3Gk30BS4PxlUZGNYjFQlC16LvtaA=;
        b=AonEF9IP1O4jHQnw+F1LFjoKG/CKpdE6OnvlYUkF95B0iRl4RySQAQUacDVPg82cSYIpTW
        sJe14tnn+dWRBIoXC/i1biVamRrInX5r+6rLH6qhkhSgG1tq2/sALY+pqqr5Yg9/5msWdX
        1HsDdIirHF1ZWg2wfzERMHMw5VYxbZWyvWSpi2l+e/ff1h1/8DPf9zD8OTaYUE2ttTx8xb
        p4ngezVwiprzvkwBAvpI5IBRIHrRvhJVgMiBwMSYA/nfqaDA8rKnwYUXM8+5SaL64FXVxX
        M51xC74gwQyTB4+UapQyppQpDtRLaC54Jgmqj8QC1bVmw/a3tPMmLzRFvcra0Q==
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201107153139.3552-1-andrea.mayer@uniroma2.it>
 <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <20201110151255.3a86afcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201113022848.dd40aa66763316ac4f4ffd56@uniroma2.it>
 <34d9b96f-a378-4817-36e8-3d9287c5b76b@gmail.com>
 <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefano Salsano <stefano.salsano@uniroma2.it>
Message-ID: <bd3712b6-110b-acce-3761-457a6d2b4463@uniroma2.it>
Date:   Fri, 13 Nov 2020 18:02:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201113085547.68e04931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: it-IT
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il 2020-11-13 17:55, Jakub Kicinski ha scritto:
> On Thu, 12 Nov 2020 18:49:17 -0700 David Ahern wrote:
>> On 11/12/20 6:28 PM, Andrea Mayer wrote:
>>> The implementation of SRv6 End.DT4 differs from the the implementation of SRv6
>>> End.DT6 due to the different *route input* lookup functions. For IPv6 is it
>>> possible to force the routing lookup specifying a routing table through the
>>> ip6_pol_route() function (as it is done in the seg6_lookup_any_nexthop()).
>>
>> It is unfortunate that the IPv6 variant got in without the VRF piece.
> 
> Should we make it a requirement for this series to also extend the v6
> version to support the preferred VRF-based operation? Given VRF is
> better and we require v4 features to be implemented for v6?

I think it is better to separate the two aspects... adding a missing 
feature in IPv4 datapath should not depend on improving the quality of 
the implementation of the IPv6 datapath :-)

I think that Andrea is willing to work on improving the IPv6 
implementation, but this should be considered after this patchset...

my 2c

Stefano

-- 
*******************************************************************
Stefano Salsano
Professore Associato
Dipartimento Ingegneria Elettronica
Universita' di Roma Tor Vergata
Viale Politecnico, 1 - 00133 Roma - ITALY

http://netgroup.uniroma2.it/Stefano_Salsano/

E-mail  : stefano.salsano@uniroma2.it
Cell.   : +39 320 4307310
Office  : (Tel.) +39 06 72597770 (Fax.) +39 06 72597435
*******************************************************************


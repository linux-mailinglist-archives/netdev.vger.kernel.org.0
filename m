Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FFD842CE
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 05:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfHGDKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 23:10:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45268 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726797AbfHGDKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 23:10:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so42617613pfq.12
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 20:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MvCP2w13TKPjtfIvHJrF7al2q5zNEQ/KDWhxBDCYs0g=;
        b=UGUOAvvnEsZHGtEIuV0RbfiFRXfTMz4kyZKeUTrcersjrmv6td2UcDNZITLO3ApAyN
         H01PVV6BrpqPc67jZBq7CbMuRjceNosCdMZau6KYviKrJa6ZFJhwWep792vbyz7LNANb
         C8JlJq2PCDMEFh57gOxA/1Kgm4NQhF/VkhLlrYyzXRYHAQFZJ51ZKeQGeDzQYc9cYwdV
         yCMntYSd0oZBKuTxt10Tkgdy6zWXSCWvP81ip5a/GOa2gxVGCbkwnR9Upkllomb5xLXS
         DrVAgWY0wLw3ZdCUOSJaOpvu0JDwAf0GWD/9Yw+XAZJp918tS2Y7osDtji+WuILHWTVI
         PV1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MvCP2w13TKPjtfIvHJrF7al2q5zNEQ/KDWhxBDCYs0g=;
        b=F1XrCyzDwHLQL0c1HopkLqYEf75+KJTImRvc3+A1wqh15nVoI7jZtePRCDsxfzpMiV
         IXFd97mlk0l/DIcudX2mJhBaMR5FxglvAjbg/bH3ABJFjdwRt2ZEH4hifAU7UR54hlQe
         i/vn7nSCc5hYTFqab5tG3owfaIK5XincwKvDlaL3tkETuVv2ZUmqJ7yG7/48gW5geeY4
         to05Fj2xBhLZKuJ9xfrHrhWeXoBP8qh42QMzi/9VNI7SDmnJE7EJ9RO/mg7EHuwUbv1L
         zosLO5kvPWGk0ylDDffh9/TuBYI+II2kTGZybynK+ZivPMztgUgY3jrfwGhb2Qvw91og
         +xyA==
X-Gm-Message-State: APjAAAWzwQ9BbKQsiBYyn+KNEShL4sBZ0OxscjQ+62xiZ9SDXXloq0w8
        rgqFbZo81+INdSS19Fd4YXK6v6Xo6aA=
X-Google-Smtp-Source: APXvYqyn0vrg1t9TpcHtGc6JOdbOPNxy5H72dlUJYWeh0JnrZM9OcwFlP0BTYKqKhUr0VRdeEgEieQ==
X-Received: by 2002:a17:90a:19d:: with SMTP id 29mr6431572pjc.71.1565147443375;
        Tue, 06 Aug 2019 20:10:43 -0700 (PDT)
Received: from [172.27.227.229] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 65sm89878334pff.148.2019.08.06.20.10.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 20:10:42 -0700 (PDT)
Subject: Re: [RFC] implicit per-namespace devlink instance to set kernel
 resource limitations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
References: <20190806164036.GA2332@nanopsycho.orion>
 <c615dce5-9307-7640-2877-4e5c01e565c0@gmail.com>
 <20190806180346.GD17072@lunn.ch>
 <e0047c07-11a0-423c-9560-3806328a0d76@gmail.com>
 <20190807025933.GF20422@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <153eb34b-05dd-4a85-88d8-e5723f41bbe3@gmail.com>
Date:   Tue, 6 Aug 2019 21:10:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190807025933.GF20422@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/19 8:59 PM, Andrew Lunn wrote:
> However, zoom out a bit, from networking to the whole kernel. In
> general, across the kernel as a whole, resource management is done
> with cgroups. cgroups is the consistent operational model across the
> kernel as a whole.
> 
> So i think you need a second leg to your argument. You have said why
> devlink is the right way to do this. But you should also be able to
> say to Tejun Heo why cgroups is the wrong way to do this, going
> against the kernel as a whole model. Why is networking special?
> 

So you are saying mlxsw should be using a cgroups based API for its
resources? netdevsim is for testing kernel APIs sans hardware. Is that
not what the fib controller netdevsim is doing? It is from my perspective.

I am not the one arguing to change code and functionality that has
existed for 16 months. I am arguing that the existing resource
controller satisfies all existing goals (testing in kernel APIs) and
even satisfies additional ones - like a consistent user experience
managing networking resources. ie.., I see no reason to change what exists.

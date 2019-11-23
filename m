Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26F4F107BDF
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKWAHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:07:02 -0500
Received: from mail-qk1-f169.google.com ([209.85.222.169]:44961 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKWAHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:07:02 -0500
Received: by mail-qk1-f169.google.com with SMTP id m16so7842091qki.11
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=d0LEO3XeV6MFLda7YyDVyLuj8GwvIrV9Odh70xeazyY=;
        b=g9PMDW1pjaAWh3X7h72hw5x58cwa3v96jp6pilsrgVwS+zE/CWKc4RfsXHNiabXB5G
         pr9vS9CNn6umzMcWHv08W6ZvnJCTGkefjh1TUAh4THlFpevJfpfq2uNpvvQVbS+uA8Am
         cUOQRP2C+wNdwWRVf4CmwiaB4uE59o/S8cTbPuZuJAYpT52KdZDClnFMnR8y9f8MyWqC
         ZO9H668ZeZbD9XxQsIDxCEhVqUD1OLxrkM83bOkHMb/fI/o1L43pCEct/NMrJNir2vfK
         p5pFNZgTlC+OFfXCSgOQXNf0IvElLPppr9fYi5d8rxvzdNdVj3hFmqKpxe07ZFqOPITN
         mxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d0LEO3XeV6MFLda7YyDVyLuj8GwvIrV9Odh70xeazyY=;
        b=TZLflJ5+nfnbOa8xDaJYmhLJ2YgXu0amRfi8FJviiQfbgSTWSFcP1DTE/Dishr1T8A
         1aKkh7sXUtIME4/0p8uIiNcj7hD/HAIkwj2NM4AWMtsz/IeOyqcr3oHCS1nDk32xp3r9
         ow4a+TctDH8ksqjHnIHiQ0TniOBsq6b1pNyANrp574NwjS6hOyndB+yju6J2TgUWY8F2
         kln8L/J0QOx/x8CUt7LNF4ziK6HigOxc7KkEjZy6N1DR9EQBLTrnt0pbMD2iF5Go2Sse
         VFVKFQ40tyzrsWblFQggdNXT0If8hCJATAXLAPGVrAeYZGjst9peU20NCpUCHir0Sry4
         SyCA==
X-Gm-Message-State: APjAAAWBFfkg1uqqL98GNODm0zOqnhKBkenXIaSQRpKiK4zv7oWbeNty
        4o8G+tweN0d006V8stUS1VptrUKd
X-Google-Smtp-Source: APXvYqxAaCWvmEDlPAYGfYoHzbxLsZI2Q6TdyEf31R6fF7LVBI42762gmyuA59abvGUnDbpovG58Aw==
X-Received: by 2002:a05:620a:1223:: with SMTP id v3mr4541044qkj.302.1574467620798;
        Fri, 22 Nov 2019 16:07:00 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b0cf:5043:5811:efe3])
        by smtp.googlemail.com with ESMTPSA id l5sm4143436qth.23.2019.11.22.16.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 16:07:00 -0800 (PST)
Subject: Re: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
To:     Ben Greear <greearb@candelatech.com>,
        netdev <netdev@vger.kernel.org>
References: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <850a6d4e-3a67-a389-04a0-87032e0683d8@gmail.com>
Date:   Fri, 22 Nov 2019 17:06:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 5:03 PM, Ben Greear wrote:
> Hello,
> 
> We see a problem on a particular system when trying to run 'ip vrf exec
> _vrf1 ping 1.1.1.1'.
> This system reproduces the problem all the time, but other systems with
> exact same (as far as
> we can tell) software may fail occasionally, but then it will work again.
> 
> Here is an strace output.  I changed to the
> "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1"
> 
> directory as root user, and could view the files in that directory, so
> I'm not sure why the strace shows error 5.
> 
> Any idea what could be the problem and/or how to fix it or debug further?
> 
> 
> This command was run as root user.

check 'ulimit -l'. BPF is used to set the VRF and it requires locked memory.

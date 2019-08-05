Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF22B81FFC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfHEPUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:20:23 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38991 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbfHEPUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:20:23 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so63048493wmc.4
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=02cdqXKQu/Q6T+I9WKIOmPaDqvCBr7vjlsm/BBSxVnk=;
        b=CuHIIa9FQPIYbJjPXUY+yArIuOxPcc6cG86ZzCnX2hNIp6swDK9f/W19eUSz0Ee5Ba
         R0F1ZtTGJLkVPLOX0VaShFe1nAJoDTqrICEBIHVk3CnsICIPS4cYbqgrLjKacGVu4ARB
         PMrre7cOLe+/4fWb3bXfgZHx7HVMfcfeLodsoqwQo97xiIQATnU9uulQMm15lSd3Yrfb
         KMDul5JGL1PzTxFc9hnIxpl18DL7oyslqMEP1GPaVVllJpiiLTyNhzdQqytKZ4+Tm2Vz
         KavcOE+PZLl8mbE80CPV/iIruOAD4/6KpagLFLmUO6zE4ng6GDr4PLOSRsAJLrj2sd8F
         E5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=02cdqXKQu/Q6T+I9WKIOmPaDqvCBr7vjlsm/BBSxVnk=;
        b=Apx/Uja+YfM3G65rVx93k0rHAy0pwul5IilSARgM+7PdxON3Sn1PbFEDWX1JP2ufhB
         brySFJZkX0BI/js/tcKl6cbUJoDE3n62iWqbrjh6LdbbMxfR3WTcb7UKnRJDDeSU0F9l
         ZKh37MH4exVKiPlqCL/BPygL6/1UCvjG33rX3We6erw1d/DVVOPSoL6ziGMzjmL+o1gy
         6dPWE61ipfZiHTznWItgB2ktWmampFPoJ+9bvUdX7Sp/xWreVLT6EoyGHca8IEiyXrFY
         KbqwTEqu4Nuz7IJV9FJLkbdB6pGN5c34K/EqVYjvOaVm76QGZD6fO0CB2F2RBA+2RCTK
         BIgg==
X-Gm-Message-State: APjAAAU29Ycy0Pw8ItqAViQyJH6negVmZLRnHgTQuMCOMqXIIakELYKX
        9RPmxSG2y4nask30bVyUKtqqvwjcwZc=
X-Google-Smtp-Source: APXvYqxLCalHjvckkDll6iXsN5uWxDsrNBODPlrfKq1o2SNII34pbwMhvEzJL0WRCvall9M5RkHnQg==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr18662591wmj.71.1565018420932;
        Mon, 05 Aug 2019 08:20:20 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v5sm125568586wre.50.2019.08.05.08.20.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 08:20:20 -0700 (PDT)
Date:   Mon, 5 Aug 2019 17:20:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190805152019.GE2349@nanopsycho.orion>
References: <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
 <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
 <89dc6908-68b8-5b0d-0ef7-1eaf1e4e886b@gmail.com>
 <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
 <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 05, 2019 at 04:51:22PM CEST, dsahern@gmail.com wrote:
>On 8/5/19 8:49 AM, Jiri Pirko wrote:
>>> Your commit 5fc494225c1eb81309cc4c91f183cd30e4edb674 changed that from a
>>> per-namepace accounting to all namespaces managed by a single devlink
>>> instance in init_net - which is completely wrong.
>> No. Not "all namespaces". Only the one where the devlink is. And that is
>> always init_net, until this patchset.
>> 
>> 
>
>Jiri: your change to fib.c does not take into account namespace when
>doing rules and routes accounting. you broke it. fix it.

What do you mean by "account namespace"? It's a device resource, why to
tight it with namespace? What if you have 2 netdevsim-devlink instances
in one namespace? Why the setting should be per-namespace?


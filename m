Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237DC83865
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbfHFSHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:07:13 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:36157 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbfHFSHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:07:13 -0400
Received: by mail-wr1-f41.google.com with SMTP id n4so88873109wrs.3
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=b9ae5Pq/eGFQDXtzdPaS69LITV8GPZXSD6YjxONaXgU=;
        b=YTqrJUTLnpqHFZmcYA2169UvfgKEfIzGHLdZnEA4NuzU7bxD7FmRxr0Ayzvu5b7BJe
         bF/coJbcdInp8mE3266/nS/qBGpakiB+zSONng+AaTZoyz1xN/6LglI1Bl+PW+1QVcbA
         iZ8AS2XrUWP82TtVIv6g3JktWMu7IiGoG6Dv0LCZvZY/Y1QKv+vZcNg9v1MZBum1zDWP
         tDsjw47rjBiVx1cVwp/vXTJMAP8FmjVPL/Vi6CDkB+prj1EkryeRleyfvGTTt0MW8rXg
         kP47oT4uw8Z+Fob4Ih0xP8RL8eO0hBdUyTWHlydE3+X+3gVBbH8eEqyQdbKfYZgK1SFq
         7BdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=b9ae5Pq/eGFQDXtzdPaS69LITV8GPZXSD6YjxONaXgU=;
        b=sHmpjpmZ9M5nuYvPmURwdkfSdwbLVLkqEaVTMZ0SueHO6B2743ZJx9LgksobypMoqz
         LnCsd3O1SLNA5SjWrj/tVweHszMKzxlbEzk8LMhBPzP+mFkxTAqTq9zk7KOIHeIOPNEf
         E7BMvdxlOOUJP9L8V7VE/jAItNEBNF/CZ15BHJT06NXcWUsETZbMwSc7E0Ay0jJLPIpl
         /88+yHmxqrcWS/6NHbpaNou0sWjffRtgwvMyU8lOw3jJoLzezCc6rpUJmzgXdwxWZxc1
         hkyhTOGsYYs3jfpNf0kgisERe4oHZ4BmQ5LkosN6DuTVt1asEWP2TLu1+x985bi/5yVa
         fSvQ==
X-Gm-Message-State: APjAAAUhsgxpEvFyuUY5n6dJGQj827J4mIt0NhYsTpZm4pAfEvEXwxHq
        trk5i3BCXPPbE2GfIz71JOq9nA==
X-Google-Smtp-Source: APXvYqzp+TUzafzE20WvQNBKaOkaUAnaitBoR89XXkVymelhqQOLdZDRimgUqM8MHciMM9K282Q/QA==
X-Received: by 2002:adf:e708:: with SMTP id c8mr6031549wrm.25.1565114829387;
        Tue, 06 Aug 2019 11:07:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 5sm76017473wmg.42.2019.08.06.11.07.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:07:08 -0700 (PDT)
Date:   Tue, 6 Aug 2019 20:07:07 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
Message-ID: <20190806180707.GC2332@nanopsycho.orion>
References: <20190802074838.GC2203@nanopsycho>
 <6f05d200-49d4-4eb1-cd69-bd88cf8b0167@gmail.com>
 <20190805055422.GA2349@nanopsycho.orion>
 <796ba97c-9915-9a44-e933-4a7e22aaef2e@gmail.com>
 <20190805144927.GD2349@nanopsycho.orion>
 <566cdf6c-dafc-fb3e-bd94-b75eba3488b5@gmail.com>
 <20190805152019.GE2349@nanopsycho.orion>
 <7200bdbb-2a02-92c6-0251-1c59b159dde7@gmail.com>
 <20190806175323.GB2332@nanopsycho.orion>
 <fc6a7342-246c-2fe1-a7d1-c7be5bd0a3a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc6a7342-246c-2fe1-a7d1-c7be5bd0a3a3@gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 06, 2019 at 07:55:30PM CEST, dsahern@gmail.com wrote:
>On 8/6/19 11:53 AM, Jiri Pirko wrote:
>> Let's figure out the devlink-controlling-kernel-resources thread first.
>> What you describe here is exactly that.
>
>as I mentioned on the phone, any outcome of that thread will be in 5.4
>at best. Meanwhile this breakage in 5.2 and 5.3 needs to be fixed.

Why? netdevsim is a dummy device, the purpose of existence is to test
kernel api. No real harm breaking it.

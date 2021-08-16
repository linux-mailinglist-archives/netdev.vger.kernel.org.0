Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0A73EDA94
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhHPQL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:11:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhHPQLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 12:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629130280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iyO2WLAP+aQnJ1jyGofk+6UZ5GOhdTgCKqORoFevXSg=;
        b=HkwlXCVAs/+d26E9HohhiYxcyrfj4mysosjKJ5gbe8clAo9AxghYipFuit8hR+670n/qxj
        pG+9k2fKQBlf5Cd707uMJXetYBipeJnKXVm9letfh5YERZMRFM55pOnpaxQwNE4dRvB26D
        +B/17oGPjBllWRhnvvp9zsyEsrhX7zw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-Jgk41839Nt-tkLLezLC6ow-1; Mon, 16 Aug 2021 12:11:19 -0400
X-MC-Unique: Jgk41839Nt-tkLLezLC6ow-1
Received: by mail-ed1-f71.google.com with SMTP id dd25-20020a056402313900b003bed8169691so2827608edb.7
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 09:11:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iyO2WLAP+aQnJ1jyGofk+6UZ5GOhdTgCKqORoFevXSg=;
        b=foOhjGqsMxxHQZgJI0Pc1q0OBbfv+Z2Zsah4lOyCfnWtDdT3SPzRrMZheIjVX5HUsQ
         1GgBe2XNZ3M4oik/5+g9uOacLBp7FlXxM944OFQMKIUJmh867R2a0Tqv4OCW2JeayXgx
         500ftBiDxpAfj36sbOZ5LmMA0N6cLVY4eFdMN+iklTbH/jdxnjFZIdXOsBGB58kZZDws
         HaB4fs1njzciwtg00/ulL2T+zHvhrJMu8HEzry6ArvAS7fkncdjJPW9YMZn9VQhyoLxj
         Pm9gyyclSU0KxyYqAEtK9O1ongING497kHQrSt3YCPDaPkhylNMiXHeXIN1ouLrvn+Wv
         AgdQ==
X-Gm-Message-State: AOAM532OD/pLI1eIG3GSf41BAePd5tJis1sKcHaSOwQAOUjpmOcXRwWW
        /Qfa69DTLpv+rK8tEs04fZ1dUmOAIjpyHJ3XG/xOgnXWEsk7IfCLN7kfza0eFb6QllAL4X6Eri+
        a/C5KPHnwlXWO5L4z
X-Received: by 2002:a17:906:c342:: with SMTP id ci2mr17153541ejb.122.1629130277864;
        Mon, 16 Aug 2021 09:11:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxqpo77xg0kISTsqOyk/DTvpZ/I0UWK3WDlWTtA6AhJMw6abCgkq43hhVCX1d3SvC1mibOTg==
X-Received: by 2002:a17:906:c342:: with SMTP id ci2mr17153520ejb.122.1629130277663;
        Mon, 16 Aug 2021 09:11:17 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r7sm5144990edi.43.2021.08.16.09.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:11:16 -0700 (PDT)
Date:   Mon, 16 Aug 2021 18:11:14 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210816161114.GA3611@pc-32.home>
References: <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
 <20210812182645.GA10725@pc-23.home>
 <20210812190440.fknfthdk3mazm6px@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812190440.fknfthdk3mazm6px@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 09:04:40PM +0200, Pali Rohár wrote:
> The point here is that there is application (pppd) which allows
> specifying custom unit id as an option argument. Also it allows to call
> external applications (at some events) with sharing file descriptors.
> And it is one of the options how to touch part of ppp connection via
> external scripts / applications. You start pppd for /dev/ttyUSB<N> with
> unit id <N> and then in external script you use <N> for ioctls. And I do
> not know if there is a way how to retrieve unit id in those external
> scripts. There was already discussion about marking all file descriptors
> in pppd as close-on-exec and it was somehow rejected as it will broke
> custom scripts / applications which pppd invokes on events. So looks
> like that people are using these "features" of pppd.

Potential external pppd scripts, that depend on the unit id, may be a
valid use case for letting the netlink api define this identifier (if
pppd ever gets netlink support).

> Option "unit" in pppd specifies ppp unit id. And if new API (rtnl) would
> not provide equivalent for allowing to specify it then migrating pppd
> from ioctl to rtnl is not possible without breaking compatibility.
> 
> As you already described, we can simulate setting default interface name
> in pppd application. But above usage or any other which expose pppd API
> to other application is not possible to simulate.

If the pppd project is interested in adding support for the netlink
api, then I'm fine with adding this feature. I just want to make sure
that it'll have a real world use case.

> So I think we need to first decide or solve issue if rtnl ppp API should
> provide same functionality as ioctl ppp API. If answer is yes, then some
> kind of specifying custom ppp unit id is required. If answer is no (e.g.
> because we do not want ppp unit id in rtnl API as it looks legacy and
> has issues) then rtnl ppp API cannot be used by ppp as it cannot provide
> all existing / supported features without breaking legacy compatibility.
> 
> I see pros & cons for both answers. Not supporting legacy code paths in
> new code/API is the way how to clean up code and prevent repeating old
> historic issues. But if new code/API is not fully suitable for pppd --
> which is de-facto standard Linux userspace implementation -- does it
> make sense to have it? Or does it mean to also implement new userspace
> part of implementation (e.g. pppd2) to avoid these legacy / historic
> issues? Or... is not whole ppp protocol just legacy part of our history
> which should not be used in new modern setups? And for "legacy usage" is
> current implementation enough and it does not make sense to invest time
> into this area? I cannot answer to these questions, but I think it is
> something quite important as it can show what should be direction and
> future of ppp subsystem.

PPP isn't legacy, but very few people are interested in working on and
maintaining the code.

Do you have plans for adding netlink support to pppd? If so, is the
project ready to accept such code?

BTW, sorry for the delay.


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45BD1086
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 15:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbfJINsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 09:48:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60397 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731254AbfJINsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 09:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570628886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/HU3cSu5rgvfTDfmBZHdIGx+ENxaMRgaipBsDxR5icg=;
        b=YiHJPdjQOGiNFN3qD3OdAwqtvTkJwd/h/C+wxI/+SICMwzO3uudzvUrfpgEO5pKUfXWXAT
        2jrMQIIqriANmcNMWne49CezV4+f66ZqeuxgtYFaW1tRsRF7DZLlmDdM/23k2FNGSgbC91
        oYclNUUz3dPBrUorQ2FcAY2Myi+81Vo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-QFN3JiDVM9OLVY72-XWRBw-1; Wed, 09 Oct 2019 09:48:04 -0400
Received: by mail-wr1-f69.google.com with SMTP id v18so1136945wro.16
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 06:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=olJ6cbf9FWUjqIsOnDP4PBJSRF4Jjtav16we3N7wAeQ=;
        b=BNVsMRuaFkjam9HNHXcLQNlkMSta053yuHu/Z8HUJvviFQvOR4UpHQZOqWYNieJj/4
         i0jlyqblyjvzbk+1azmiNTeIpCvvPMHhH09k4pXz45H6TwJ/F3lerfGrWrqgoJq2Qhj2
         j0aXoHkhmuVNu2DejAYpZVmj0CVElpgCW8dmM9Ao/gjfHnN/hcEpPjXKwE4Fa4A0W53L
         /DVBRSlp27t3+xJijUhi3z/Cf/pMfykc5JS5J2FO3yZRqwgY+2DCdBr3AAXqEf6gnKsk
         V7Bk0c6YOcZyv7dxXZWxTef8DfISDJSMoWFNTzh6p+68rhUL69V6qZ0SerfvZRFlFDN6
         6r1A==
X-Gm-Message-State: APjAAAXXtoK56GZ1SZ5XtBUG0RipTfAwcXkgr6gNHbnypOl4HqQPE6Zy
        3ypFbnhqLvSGeACYoXk/yr+IgJkVWfCOqRjUGPiNuUHSyNhGOhb1qtgr2H2cWZbrZC2Oa8fZJsc
        aqSOsOZFV4oWupo/t
X-Received: by 2002:a7b:c25a:: with SMTP id b26mr2883234wmj.129.1570628883024;
        Wed, 09 Oct 2019 06:48:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxRpEfaDZ62phj/LzB4zpL92F0/sXfKQbdTZabamLEuP9a8FKzwnfyzWkOOW7RD993KHeV8ig==
X-Received: by 2002:a7b:c25a:: with SMTP id b26mr2883225wmj.129.1570628882829;
        Wed, 09 Oct 2019 06:48:02 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id a18sm3093563wrs.27.2019.10.09.06.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 06:48:02 -0700 (PDT)
Date:   Wed, 9 Oct 2019 15:48:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] netns: fix NLM_F_ECHO mechanism for RTM_NEWNSID
Message-ID: <20191009134800.GA17373@linux.home>
References: <20191003161940.GA31862@linux.home>
 <20191007115835.17882-1-nicolas.dichtel@6wind.com>
 <20191008231047.GB4779@linux.home>
 <6ff5601a-4352-7465-78be-c01a78b27c33@6wind.com>
MIME-Version: 1.0
In-Reply-To: <6ff5601a-4352-7465-78be-c01a78b27c33@6wind.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: QFN3JiDVM9OLVY72-XWRBw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 10:07:56AM +0200, Nicolas Dichtel wrote:
> Le 09/10/2019 =E0 01:10, Guillaume Nault a =E9crit=A0:
> [snip]
> > We also need to set .portid and .seq otherwise rtnl_net_fill() builds
> > a netlink message with invalid port id and sequence number (as you
> > noted in your previous message).
> >=20
> Yes you're right. I don't know why, I had in mind that nl msg sent by the=
 kernel
> should have the portid and seq number set to 0.
> Will send a v2.
>=20
I guess this idea comes from the fact that portid and seq don't carry
any meaningful information when the message is sent to a multicast
group.


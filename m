Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 177A91B911
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 16:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730701AbfEMOuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 10:50:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40503 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbfEMOuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 10:50:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so15640026wre.7
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 07:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRsiwlVwOPSBAWjnCxisvwPttK23yh/T0P20h9T04IQ=;
        b=jRLmtHJws94T0h3afLklbh/N4XJMd8wn9xnbTHcHKrv2EUkJf1bnYfMVJsYG6HyT7S
         GrkMe9F2id6BIIZTqdS+HZ2n8AClQcC23rgVwcFUsWVB7mLq7ZGYEtMTsta/XWIBNa06
         5ZaaOlIRnZMc7cXD3QwLa1jLhcp6Ms+A3U/oE+9kUTy80vYbq0f8qKBbNfoi+gB91qQ4
         peaHZxyYkXq/7ICMGmOg87CGdtugaCI2UmngMrijk/eyIJRKWnPM2YmM3rEDKBOLYguC
         g5X/3bMPsw4Rjf8CQEMlXckw9LdydYET7ZJDUIT8fJEGiuCDAgj4hNhfrHbl4PIjvP6G
         WdTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LRsiwlVwOPSBAWjnCxisvwPttK23yh/T0P20h9T04IQ=;
        b=srEE8qqerejfrrX9yM9JcLAXpxPmgOgzauMtEGLhBoXIEarCBE3rImJ7ZlzhGiKuJJ
         5ycgvO8HiBuD3ZYC5bb/+oDwNMzweUEbLAakda0hml4/7RLdpPFRHINuwkw3m9CWO5IP
         vmTIw3qrLuOhDpEP3Gt6a9wm6dTBQa/SJ7TGXX3pQs6ycZwmjTW8NRA3CbsbKVMKejRh
         r83CeRtpZwo1R3XSCD/SCPJPuOPAg435j5Go36FsyDW+iAJd8926pXDq4c2ojWhVY+to
         6b/2u2GD3Cq2m4ryuMYSc6xdrsUx9lNpIhNazc1TySkSn7uBmlgy/eGLCkm6PiCurmre
         fLUw==
X-Gm-Message-State: APjAAAXMPfPj5RaMt+siEaq1ovGRNQ+OFVBoYJz8Opt6IGPvD6qBja+b
        iGEBuiDjbcakMo3epYk13ZNgFw==
X-Google-Smtp-Source: APXvYqzqCvVbKHO3PO+J8IKSIqPRFXpTwsMNTNQ8D1yTwCDdQQrWrVxm4r3dwKSTFOXSs9QyijSUEQ==
X-Received: by 2002:adf:e845:: with SMTP id d5mr19574707wrn.154.1557759053283;
        Mon, 13 May 2019 07:50:53 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d07d:5e75:4e14:205c? ([2a01:e35:8b63:dc30:d07d:5e75:4e14:205c])
        by smtp.gmail.com with ESMTPSA id c20sm16856362wre.28.2019.05.13.07.50.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 07:50:52 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net v2] rtnetlink: always put ILFA_LINK for links with a
 link-netnsid
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Dan Winship <danw@redhat.com>
References: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b89367f0-18d5-61b2-2572-b1e5b4588d8d@6wind.com>
Date:   Mon, 13 May 2019 16:50:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <d5c4710117d390e0f204b7046483727daf452233.1557755096.git.sd@queasysnail.net>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/05/2019 à 15:47, Sabrina Dubroca a écrit :
> Currently, nla_put_iflink() doesn't put the IFLA_LINK attribute when
> iflink == ifindex.
> 
> In some cases, a device can be created in a different netns with the
> same ifindex as its parent. That device will not dump its IFLA_LINK
> attribute, which can confuse some userspace software that expects it.
> For example, if the last ifindex created in init_net and foo are both
> 8, these commands will trigger the issue:
> 
>     ip link add parent type dummy                   # ifindex 9
>     ip link add link parent netns foo type macvlan  # ifindex 9 in ns foo
> 
> So, in case a device puts the IFLA_LINK_NETNSID attribute in a dump,
> always put the IFLA_LINK attribute as well.
> 
> Thanks to Dan Winship for analyzing the original OpenShift bug down to
> the missing netlink attribute.
> 
> Analyzed-by: Dan Winship <danw@redhat.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
I would say:
Fixes: 5e6700b3bf98 ("sit: add support of x-netns")

Because before this patch, there was no device with an iflink that can be put in
another netns.


Regards,
Nicolas

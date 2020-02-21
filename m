Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902B8166D2C
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 03:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgBUCzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 21:55:04 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34651 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbgBUCzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 21:55:04 -0500
Received: by mail-qk1-f193.google.com with SMTP id c20so613500qkm.1
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 18:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hm5cZO5A5LlROhOZwVO/vlhdLha4EGFV0wsm23YI7GQ=;
        b=RkxzzLDrXtF7VIw+Kh+xc+oL8D5OYxDdIyj3dV2ncoMh9HzbuZtNrHNXUxxkWctyE+
         xdrOEnNGNkJ1PmMwzRqTgWa5+t2YENsSa1iOuQCe4eEzmrpjcUnywB+VX7eSzrZ9H4mT
         14rTLUBYVkVwiTm6G8SG8Qut0HnuDTNjRKUxiKoBvqMJ1puq7QhXsh9W+uthyhdylCBX
         eRX2aevxoy+nkXFfBuLIJUnvRpOjaob7WaCPCVNWFA1cUGz8IUxBxGMplkqFGMT6ognA
         4ZF4UC8v6EE3keunxNhldKR9BZNP23bBc7ioJQCYZuhaFg6KAT0PEa49RnPregJ4Hb5N
         gk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hm5cZO5A5LlROhOZwVO/vlhdLha4EGFV0wsm23YI7GQ=;
        b=Hq6oI/VQ03Q5kR7q4/bBjl0r6ufvvK4TVaqjAhK7IniwSVboCi0qo93LTeNIlPb8GT
         qwLF6/yccAhFG3iZheDrDvJZZqk1oboI8R6H2Wv+23xHMFxoBNzfuLnNOx+EyrZL1Un6
         RAMwwVE9gPD39ShEycEp1tziohNSJ33AKkqg5OHC71xy0C6dFufNVrg9V0bC/8sKrIKL
         CyRDcrGUcz256mIdAz2zccfdqTpFKE1GfyEKig9B/3PGHBxMYzQtzx64oQKMynmsqSLC
         tS7IGUSl2/OfJu6Ap/mBCXmx8rgI6+1hVPr22H+c61hbC69GzKQKzdYzBM5/2zo10j0a
         xGlA==
X-Gm-Message-State: APjAAAUvpxjgFsl1L9krBjBTDmAHS5bG7rIk5piDaiuUID/3Sw5y48hX
        GzYh2d/xhBl+dgM3XjDw1Yw=
X-Google-Smtp-Source: APXvYqx1l8NaWy8nFJ11DsH0LzR3da8GtaReymp0wnxk07PwQWBIqSEdEsgWQOYP3w3iGXfTKTzBEg==
X-Received: by 2002:a05:620a:cec:: with SMTP id c12mr30610213qkj.151.1582253703836;
        Thu, 20 Feb 2020 18:55:03 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:5475:f560:8951:8d4f? ([2601:282:803:7700:5475:f560:8951:8d4f])
        by smtp.googlemail.com with ESMTPSA id m17sm791093qki.128.2020.02.20.18.55.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 18:55:03 -0800 (PST)
Subject: Re: [PATCH net] net: netlink: cap max groups which will be considered
 in netlink_bind()
To:     David Miller <davem@davemloft.net>, nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, christophe.leroy@c-s.fr, rgb@redhat.com,
        erhard_f@mailbox.org
References: <20200220144213.860206-1-nikolay@cumulusnetworks.com>
 <20200220.160255.1955114765293599857.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <30fda8d9-0020-0fa7-d00d-42acdf44f245@gmail.com>
Date:   Thu, 20 Feb 2020 19:55:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200220.160255.1955114765293599857.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/20 5:02 PM, David Miller wrote:
> 
>> Dave it is not necessary to queue this fix for stable releases since
>> NETLINK_ROUTE is the first to reach more groups after I added the vlan
>> notification changes and I don't think we'll ever backport new groups. :)
>> Up to you of course.

RTNLGRP_NEXTHOP was the first to overflow; RTNLGRP_NEXTHOP = 32.

Apparently my comment about overflowing the groups was only in the
iproute2 commit (e7cd93e7afe1a0407ccb94b9124bbd56b87b8660)

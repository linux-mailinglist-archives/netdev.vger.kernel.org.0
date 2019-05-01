Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1574811062
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 01:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfEAXrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 19:47:47 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:36790 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfEAXrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 19:47:47 -0400
Received: by mail-pg1-f173.google.com with SMTP id 85so187156pgc.3
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 16:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l0kdonBr5QXfr5J7pNZDfcDs46NlLa+2b5Dw6Ru+1iY=;
        b=lXs4aBEmkgpYSTVzMA7R35VoO4DoDJ5R37KVv+44k5j4lB6eTwBmT5BOJwNCffdeC/
         XN6VY6pM3RYt4bhVTWDnGPHRz/XjHvZllT4N4L8EisbJ8tB7SD9jKZTK0oaNq/8PJuac
         IF5cdFD5e1tJ6xz2010SmQJkL6DQATNr9Lvf4bcIBmDUt3dravV6tKkux4x4PK+mkcUb
         b+MM2E2lyF+ZcNy6fL9cy4D0GvZIEh8zVxkZZkIlv71OdZfgXqlDDZpVtUzth6J6fhRf
         H5eaPxRPz+bjQUFPiiH8heGXYTML89KN7yhtBQS4DDsFo0V4bkcsuDMnUF3B1PYjuHV8
         tT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l0kdonBr5QXfr5J7pNZDfcDs46NlLa+2b5Dw6Ru+1iY=;
        b=aSzhf5KuwzMg2zq1ruFbp0IPG+WglAdRGLfOcXjmKeze6MuKYiWWaSj/xA4Zyt7XMg
         Yvb62VSfrn9YDY3e2gbBAhezeHKxYCeGnyKMm+4tDMP1zQ7TnZuJisvKBZWvJMvRXDZm
         PYQBSvfyisgGbiNBXnRQhIx7Gn4VfHJ70CXhV2jyYVSFjV9MXs51IGLNQVDtzaoarN2+
         NB2BIrSp2CTiNSVrHe028k+3v6clmK+DdCPEtQpLh9eNfh6SccdrVoY/j145aqK16Adi
         KA0hqU2cWhYC11T2m1eoSEWbQ01qR/5sAVVNro5B4v+9ZFo2DgwFJjCOLgNZW3+Y8L+n
         vcbA==
X-Gm-Message-State: APjAAAXtaj5YiiVTcGqNTwhBcZ029RujbcKLvV9FicYoStqV8ninOuUy
        IG/b6ps3h3k4lP1KQZDkUNE=
X-Google-Smtp-Source: APXvYqw0fGtqEjnvNtoPMcc8e/n7v9nwBOJYvSZVRO/1yDIAkpxmbahtg3IIeQxKw7smqmhlKa+slw==
X-Received: by 2002:a63:f115:: with SMTP id f21mr721193pgi.65.1556754466586;
        Wed, 01 May 2019 16:47:46 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:950d:299e:8124:b280? ([2601:282:800:fd80:950d:299e:8124:b280])
        by smtp.googlemail.com with ESMTPSA id j22sm27049934pfi.139.2019.05.01.16.47.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 16:47:45 -0700 (PDT)
Subject: Re: MPLS encapsulation and arp table overflow
To:     Alan Maguire <alan.maguire@oracle.com>, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, Ian Kumlien <ian.kumlien@gmail.com>
References: <alpine.LRH.2.20.1905011655100.1124@dhcp-10-175-212-223.vpn.oracle.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <876582ab-2b8c-7e46-7795-236c0ef6d90d@gmail.com>
Date:   Wed, 1 May 2019 17:47:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.20.1905011655100.1124@dhcp-10-175-212-223.vpn.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/19 10:03 AM, Alan Maguire wrote:
> I'm seeing the following repeated error
> 
> [  130.821362] neighbour: arp_cache: neighbor table overflow!
> 
> when using MPLSoverGRE or MPLSoverUDP tunnels on bits synced
> with bpf-next as of this morning. The test script below reliably
> reproduces the problem, while working fine on a 4.14 (I haven't
> bisected yet). It can be run with no arguments, or specifying
> gre or udp for the specific encap type.
> 
> It seems that every MPLS-encapsulated outbound packet is attempting
> to add  a neighbor entry, and as a result we hit the 
> net.ipv4.neigh.default.gc_thresh3 limit quickly.
> 
> When this failure occurs, the arp table doesn't show any of
> these additional entries. Existing arp table entries are
> disappearing too, so perhaps they are being recycled when the
> table becomes full?
> 

There are 2 bugs:
1. neigh_xmit fails to find a neighbor entry on every single Tx. This
was introduced by:

cd9ff4de010 ("ipv4: Make neigh lookup keys for loopback/point-to-point
devices be INADDR_ANY")

Basically, the primary_key is reset to 0 for tun's but the neigh_xmit
lookup was not corrected.

That caused a new neigh entry to be created on each packet Tx, but
before inserting the new one to the table the create function looks to
see if an entry already exists. The arp constructor had reset the key to
0 in the new neighbor entry so the second lookup finds a match and the
new one is dropped.

That exposed a second bug.

2. neigh_alloc bumps the gc_entries counter when a new one is allocated,
but ___neigh_create is not dropping the counter in the error path.

Ian reported a similar problem, but we were not able to isolate the cause.

Thanks for the script - very helpful in resolving the bugs. I made some
changes to it and I plan to submit it to selftests as a starter for mpls
tests.

Bug fix patches coming.

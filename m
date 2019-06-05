Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2497636091
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfFEPxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:53:10 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:42535 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFEPxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 11:53:10 -0400
Received: by mail-pl1-f171.google.com with SMTP id go2so9831736plb.9;
        Wed, 05 Jun 2019 08:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b/A6amxgGsaMi5e6lYvOcmDbkuB6qV1wDTVAsO9soAo=;
        b=HF0oX4GoizXaqFveRN0w+AdvmpoRPfcJEj2QWQPAAikUxO3E5MhSys+ftd+F4GdQnA
         C7N3z2QxGpOrM/vmTLJvjZ34g9cpScZcxD+7A2r96crKQo7jp7SiZLU/uvKA38yDBAvL
         TmrqIJuV+CMX/yYJY2yqNdIvrrCj/y0cH0O089lydcDg1OG8EkYMVB6NVwA5dts259O6
         VRtrgU0hINVN2WZ2/8YD6D8cdonMAjiolDKuyaQ3+tmpDzUF7ow5KeLJizbKWQVT4JM2
         MrA2itSy0bu4vhG1A4WDEKq/JTQwGSWlxSy34SNjBBE14zkCUQMPhbQIQrZclTV1yd4m
         Z3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/A6amxgGsaMi5e6lYvOcmDbkuB6qV1wDTVAsO9soAo=;
        b=rrml6b5L3XVN3VaBB4MUfltT630R4qw2jofukfl3LXAEtMWljiqQkB6OW+1TJOOmMN
         yKiaY/0j2/5NxqI+L2LXS6JUi8jh4XaZ8aMLneNsBocFC4Pi4+Hdro1Xp8OXmxSVHWHz
         sz2/Uw/8IrPDXOweEmnk/puIYN2Y/lcVLO5yJx899EgRHBR+r/ddk8VgLgiRdx7pbRNj
         aK8UYsrvfdb21UQXBq+S3j2DsbKFl05kkImj8Z+jepZm/uvkcs6xKOqyMoc4W6nABDaH
         sOpDj1JxJg7nYZZ+jGp5XAn5i9vHcIiwP0IOzlegcjxEpD/vaY0FSG1tJeceY+WyoDju
         vX6w==
X-Gm-Message-State: APjAAAVO06CbwMgThwhZFIptbvUe6YqjHoMwp4EYGSTLlKnp1UeycEtp
        bXUSGVlHxWYZ6tYkT3YUqrM=
X-Google-Smtp-Source: APXvYqxgWZ2/4dL8gag6+o+Uvf4y2RkFKHmnXsUUxDCJ5qeHofTWkkWqQtuN6I4poQZrn5o2ydx3tw==
X-Received: by 2002:a17:902:27a8:: with SMTP id d37mr44949235plb.150.1559749989277;
        Wed, 05 Jun 2019 08:53:09 -0700 (PDT)
Received: from [172.27.227.204] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id b8sm5919398pfr.93.2019.06.05.08.53.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 08:53:08 -0700 (PDT)
Subject: Re: general protection fault in fib6_nh_init
To:     syzbot <syzbot+1b2927fda48c5bf2e931@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <0000000000008ee293058a787e2d@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cfea6086-4416-7e3c-f456-26ff44bf55a5@gmail.com>
Date:   Wed, 5 Jun 2019 09:53:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <0000000000008ee293058a787e2d@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/19 11:10 PM, syzbot wrote:
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 4498 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #10
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:ipv6_addr_any include/net/ipv6.h:626 [inline]
> RIP: 0010:ip6_route_check_nh_onlink net/ipv6/route.c:2910 [inline]
> RIP: 0010:ip6_validate_gw net/ipv6/route.c:3013 [inline]
> RIP: 0010:fib6_nh_init+0x47e/0x1c80 net/ipv6/route.c:3121
> Code: 89 de e8 45 9f 4e fb 48 85 db 0f 84 fb 10 00 00 e8 97 9d 4e fb 48
> 8d 7b 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02
> 00 0f 85 bf 16 00 00 48 8d 7b 48 48 8b 4b 40 48 b8 00 00
> RSP: 0018:ffff888060e277c0 EFLAGS: 00010a02
> RAX: dffffc0000000000 RBX: ff8880a43d5cc000 RCX: ffffc90012a9f000
> RDX: 1ff1101487ab9808 RSI: ffffffff86220829 RDI: ff8880a43d5cc040

This one to me is falls into the corruption of the rt6_info in pcpu memory.

ip6_route_check_nh_onlink has already checked that 'from' is non-NULL
and fib6_dst falls within that memory.

RDI is the first input arg and appears to point to an invalid memory
address. In my tests all mallocs (f6i, nexthops, pcpu routesm etc) start
with 0xffff but RDI is 0xff88 which seems wrong.

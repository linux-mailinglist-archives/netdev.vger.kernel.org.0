Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFB5A788
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF1XVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:21:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45536 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfF1XVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 19:21:46 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so15905547ioc.12;
        Fri, 28 Jun 2019 16:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5imOLuCkEnTncHEfbSbR3RE3vi1mxjLFWo4/kKHfOWM=;
        b=fQ2RRgVqreR4oLT3k6wPGXZewVg3nSP4si8Q59Egw/7fmaIO+3PPY+z2w3hYy4Y4dc
         pgtF0rnUV6QfR5oIVDd/cuYBpXpbtxUoHsc42uA+9AdiDXlHdhkzor2lbeGy3WE/7jvV
         tsNkqK7ssvBpn5endTcGgpkrDTpYlCn19Djyw03eqz7XNrB5huc+CEccxpk9/pQNkcEX
         4Q+4u8p+sE2uw4EtyfR3oX5gC9lSbP/vKsCw3+rQzMovSUPCS/Jd4ipfdjH+1m7ux+Wy
         yyZuLk9VzXfqqiRRGItE6hK8wnaxV12Q2HQ+9EVIOSsEpB0f6toPP1TZwSU1lmGr/ilH
         mCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5imOLuCkEnTncHEfbSbR3RE3vi1mxjLFWo4/kKHfOWM=;
        b=EOtFPK8jrS+VrM4uTKuQVO7CDGTv1Nr+L/ebI+sLXgd/fnV2SKGawgM6jOiaSbL2TR
         PMQjBFrLwTtfPuU+Xpu6a4vUN3DxwJEKp5DcZo6HxSJjCF6XCWT3Hpu4MfWtkUxfZsbS
         k9YRUSt9I2B/CH11eWLpnfR8nYstcyDAAYOjEAoHbXh9xy1ixfa6tQJnbQKBiSC5StQ0
         Mi2/8Tk4lJv1HjoOmkTn+zhNSgHwPOvzXk2p2olm+yf/bf0RR31cxUsqqyC7tym9uvC8
         RIIu2MWrtIJ8YEKtX3KVO/mAYZZIQo8YEUqK2eI8Mpo2uX7qCjJAKudjgLcbD26ZCw8F
         5gSA==
X-Gm-Message-State: APjAAAVzbtC1qTYmITBIku3Qzb2B+xttqllXTKPpvAn9AcHFXPyQh2Zs
        bBKZ0bUdZrPiwO5xvRMqmQXM5nes
X-Google-Smtp-Source: APXvYqwn2Grerjkb9E2B5YxkN1qWXAiqOm4rqhAkh/9zFLxJ7tk8QhHdjShwQlP3XVw4YxbBW8bT5g==
X-Received: by 2002:a6b:ee15:: with SMTP id i21mr12858559ioh.281.1561764105701;
        Fri, 28 Jun 2019 16:21:45 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:a468:85d6:9e2b:8578? ([2601:282:800:fd80:a468:85d6:9e2b:8578])
        by smtp.googlemail.com with ESMTPSA id f4sm7577757iok.56.2019.06.28.16.21.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 16:21:45 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v4 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
To:     Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz
References: <20190628095426.2819-1-dkirjanov@suse.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <10ad5a7d-b539-4847-c588-4c1a647e3c29@gmail.com>
Date:   Fri, 28 Jun 2019 17:21:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190628095426.2819-1-dkirjanov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/19 3:54 AM, Denis Kirjanov wrote:
> Current code assumes that we print ethernet mac and
> that doesn't work in the IPoIB case with SRIOV-enabled hardware
> 
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state
> disable,
>     trust off, query_rss off
>     ...
> 
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
> 
> v1->v2: updated kernel headers to uapi commit
> v2->v3: fixed alignment
> v3->v4: aligned print statements as used through the source
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  ip/ipaddress.c | 40 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 5 deletions(-)
> 

Fixed the alignment issues and applied.


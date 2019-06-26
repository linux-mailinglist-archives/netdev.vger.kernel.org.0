Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E1256FA2
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 19:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfFZRgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 13:36:02 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45156 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfFZRgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 13:36:00 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so6796927ioc.12
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=xI9kO5dgOnKFqg+LMvakjxFmc7WydOT50rDlvYOxtDU=;
        b=Md5PqTWClNsY1OY4FEdrhXbsOltN/rnQqcb1HpUWMyHjYjod8fRtpkPfcgA1w1/eVA
         LsALnPQz/fZeKh9zRNCIoJANH4LfPcK6I0kNy6ftQg/COxB92AgHPzpd25YpDNVIoKjX
         phaiceE1rJvuuPRyNYy2P9JOjS/1M3CMKYJhM0tC/gT58sQZ37tZyWvzbqZIIZZv0pUu
         oChcPW97NDoXk7j17fe2x2+P0PuFYz8+X4q/eQJx8ptsXrT5B6eHQb6ByblneSfRoQGy
         ovygLB5hIxzQwI/CFaNIRUbtakIVPDimIRrmp7cfV7nFI+K1c6jp/k80Ej9efltLZzB8
         4geA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xI9kO5dgOnKFqg+LMvakjxFmc7WydOT50rDlvYOxtDU=;
        b=cvbUYUHN3HPz4U5ecYBjXuPhqgiaM7l2oh06GEWbz5/XG0/uNdyUGEAS0IhsBafLpt
         D7DBaIqg5LRpbWKAFjR5SqY6fkeqerVq+/iGGxxrCmK5Ku3oWhQcCtTCOyh65yNvqVPY
         Ml0pPX3gnwCAF85Ro7E22f+pT54qg+qIvaF4LhaDfpogSADDqle07UJpySL3aDfQO9+n
         0Y3GLp8sUoIHM+jpiLXA0PdZnfzfLXQaBXawQ21JQsAxBlUE+efJLc2D1sI4W6h8mvK7
         30tmYF6icVb3/IJNM4AwKaA06epkdknmZVZyC+X69s93wazfxhETW99ScGQqlqKwGXx9
         +iBg==
X-Gm-Message-State: APjAAAUxgvoYQRKyKmI5C5iTo8IkF2Y4G5lkURLd8s8hSoqDIrhCsTCy
        oytRDYs8AwjT/S949MT+iNheEIGG
X-Google-Smtp-Source: APXvYqzQqm8QIXbXjR80NrliwKf66I+nD5ZZ0cM/2fJfE+Yn4Mu4Mr54YwJC52fZ+D2UCAdW8+Wi/A==
X-Received: by 2002:a02:3308:: with SMTP id c8mr3523239jae.103.1561570125202;
        Wed, 26 Jun 2019 10:28:45 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:58cd:974:329e:796c? ([2601:282:800:fd80:58cd:974:329e:796c])
        by smtp.googlemail.com with ESMTPSA id b3sm14774347iot.23.2019.06.26.10.28.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 10:28:44 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv4: reset rt_iif for recirculated mcast/bcast
 out pkts
To:     Stephen Suryaputra <ssuryaextr@gmail.com>, netdev@vger.kernel.org
References: <20190626062116.4319-1-ssuryaextr@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ad55a4f7-aa10-0e23-f8c8-da4c10c41710@gmail.com>
Date:   Wed, 26 Jun 2019 11:28:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190626062116.4319-1-ssuryaextr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/19 12:21 AM, Stephen Suryaputra wrote:
> Multicast or broadcast egress packets have rt_iif set to the oif. These
> packets might be recirculated back as input and lookup to the raw
> sockets may fail because they are bound to the incoming interface
> (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
> returns rt_iif instead of skb_iif. Hence, the lookup fails.
> 
> v2: Make it non vrf specific (David Ahern). Reword the changelog to
>     reflect it.
> Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> ---
>  include/net/route.h  |  1 +
>  net/ipv4/ip_output.c | 12 ++++++++++++
>  net/ipv4/route.c     | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+)

Reviewed-by: David Ahern <dsahern@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B780DEB854
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729719AbfJaUUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:20:46 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:35052 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfJaUUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:20:46 -0400
Received: by mail-il1-f196.google.com with SMTP id p8so6631917ilp.2
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 13:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AfvOliBNKPVcBS8d+gzGvRtiKdDjstIOlrduy27/teg=;
        b=hs7z6FRS3KpYgpTcb3ZYH8iyN0wGsmEEuMyU7S8aT+tEDgZ+mQdkfxt4v+pQ8sFqXH
         HSXh8+OIS23ZK3XHPs0UDr9uMkHaJ+JfcqFXlSOt1dUpf7eU0bwy1OWFShtvl0MjPVVv
         ln4KivIoigmuk/c1E55I7bkfjxfv2u7mO9OVcOaDj0KoLpm2D+vu8Q59guTC25NZa7FA
         bTDMsxGFWYXRUShn+MEXiOcvQ/n4TFSyjCdVsIKvIUZ21aDSuDgJBzfIRTIiXsqrN2N1
         r/0euAEH4+mEhynf+pZdyEIr23rx4X1vjKoqz+prj79LboZUOEvMBmYeTm2w6a6NNWYv
         oRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AfvOliBNKPVcBS8d+gzGvRtiKdDjstIOlrduy27/teg=;
        b=bQFXXdn7bki/eW9e/dGhBbON8Wzyur4vmFQr0ImsSG2T3rKicoCyelZWt3qI1s/Wva
         rzb8sYiz6lz2Jpt5u7/cnQPwpQPcL1xi24kirDWEWVmUJftuNU5g/FqmVPd+FknG+34Y
         ghi1kImi+Yq+/eYoZLnGvmvzgL925ocM0xIe7R3T6CcAk+HmTTpFavcaM6MFFwcWjRK9
         4tPWzhQ8duasLxzcqixU9Xm+4JDS13/M7xusYkVztLw+NUBB5mB0H8Jn9DK+uAISrKY0
         rl0rMub6ZWq2w7P5Wseb7O8X1GJVhe4Cumnh28TpdENQIvX1ILrsaOcjvbABb0EvOqAR
         nbzQ==
X-Gm-Message-State: APjAAAVroll4qOO2SlxkYvHKCnrmpyFT0GqHOldlpMmjgmvSPEunKNd6
        CxVTeH6uZ9NAszZdXBWIvuA=
X-Google-Smtp-Source: APXvYqySLV+ivwzU3FALSyDKOyqilkSLviG6C9LlJ8v1wh+I+e0qMw1i21azbjkcgchp/rA7fWvmoA==
X-Received: by 2002:a92:5c5d:: with SMTP id q90mr8741435ilb.22.1572553245943;
        Thu, 31 Oct 2019 13:20:45 -0700 (PDT)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:e0f1:25db:d02a:8fc2])
        by smtp.googlemail.com with ESMTPSA id c14sm734603iln.52.2019.10.31.13.20.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2019 13:20:45 -0700 (PDT)
Subject: Re: [PATCH net-next v4 6/6] sfc: add XDP counters to ethtool stats
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Charles McLachlan <cmclachlan@solarflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com
References: <c0294a54-35d3-2001-a2b9-dd405d2b3501@solarflare.com>
 <1d36bf21-f9d0-c464-1886-ef4ac1ed7557@solarflare.com>
 <20191031211300.7e5c1e7c@carbon>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7c84e5ec-95c7-357c-fddf-1f74f86b62ab@gmail.com>
Date:   Thu, 31 Oct 2019 14:20:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191031211300.7e5c1e7c@carbon>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 2:13 PM, Jesper Dangaard Brouer wrote:
> On Thu, 31 Oct 2019 10:24:23 +0000
> Charles McLachlan <cmclachlan@solarflare.com> wrote:
> 
>> Count XDP packet drops, error drops, transmissions and redirects and
>> expose these counters via the ethtool stats command.
>>
>> Signed-off-by: Charles McLachlan <cmclachlan@solarflare.com>
> 
> I'm going to ACK this even-though I don't like these driver specific
> counters.  Given we have failed to standardize this, I really cannot
> complain.  Hopefully we will get this standardized later
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Left code below, if Ahern want to complain ;-)

testing the patches now.

As for the driver specific counters, I have the same opinion. I'd rather
have counters than wait for some alignment.



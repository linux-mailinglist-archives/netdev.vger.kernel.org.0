Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D556B4D04B
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbfFTOY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:24:29 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46720 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfFTOY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:24:28 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so1284934iol.13
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4fytpRCpwnQ40pGRF4IUJVazgNF48RqB4py4q3I0NwM=;
        b=b4EtsTtmUfg7/TzpRcFQdohRpTOkMrpAYW5lM3qTKPST/G58/svBZKlIU80DQVTIy/
         4de3IkEUyemY73nuXGhn1MeEiEpDEsk6zS/5zJbHmwf4i01wXCXCKHpaX0x7Iov2s11U
         SEmvaSDZNHizlgsEw919+UGvyANVzRCM3miXLx2eRo/AeKhymgSlNdmDIPvZba+mUNXh
         p0gD0rL0BiprSI3yMvLNF36grnexGkycqvfwsHZCCS6iBnB0HLjGeeyXCXrwdLXi+1DM
         OIdD5p7QeykN53fAzX3cXCILBjTAXTYPNgLQnPeb+oiCrwHHte5pvvYuCexyjl7Q7jy/
         /cKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4fytpRCpwnQ40pGRF4IUJVazgNF48RqB4py4q3I0NwM=;
        b=rFi4k32Kogh1cuYX/8mEccAApj1a5pvf262H+AkPVc0nwCyWG2w2eqnMZTOTASfOPN
         B1Ofm1hY4T4oW9S+CPsyecVuRrZ/bDEav5NtOasdBa3COMLCVTrM6KwekHJbXQc3OTyz
         x1rqghvsNDt28GYsRwdldN8HVbS5xAFNdCNr5YYaHnKwgXyVSufoTtD2brWhykaGwwY+
         wucyqb7Ybc4WryJW9EtXJXfC6Fxh3L2NuBiLjUv87JAiQ0E2lVBpibSa2ig6TftaruBh
         ivoeEixplPi/+a3pj5UjXzwDrSMxS/RSbgX9YzCKMXJcGk/oVzNbU/HYkFLEBknz2Tth
         vfTg==
X-Gm-Message-State: APjAAAUEn/LXisfBD5agDJcHtE1rOsGkXGAcNLmJ/6mg4+D77CKQ7OFl
        MbekEU2ouOxcwqI89SDHuc8OC+PI
X-Google-Smtp-Source: APXvYqxQElJc/iknOpPaEEUxjSOG4vHloe7BFu1wNABGAFhmh27luBr24gx7E2GX+9TspgU4XgpTQQ==
X-Received: by 2002:a02:a38d:: with SMTP id y13mr97903460jak.68.1561040667306;
        Thu, 20 Jun 2019 07:24:27 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id a8sm18239546ioh.29.2019.06.20.07.24.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 07:24:26 -0700 (PDT)
Subject: Re: [PATCH net-next v6 08/11] ipv6: Dump route exceptions if
 requested
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <13c143591fe786dc452ec6c99b8ff1414ef8929d.1560987611.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <26efcecf-5a96-330b-c315-5d9750c99766@gmail.com>
Date:   Thu, 20 Jun 2019 08:24:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <13c143591fe786dc452ec6c99b8ff1414ef8929d.1560987611.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 5:59 PM, Stefano Brivio wrote:
> +	if (filter->dump_exceptions) {
> +		struct fib6_nh_exception_dump_walker w = { .dump = arg,
> +							   .rt = rt,
> +							   .flags = flags,
> +							   .skip = skip,
> +							   .count = 0 };
> +		int err;
> +
> +		if (rt->nh) {
> +			err = nexthop_for_each_fib6_nh(rt->nh,
> +						       rt6_nh_dump_exceptions,
> +						       &w);

much like ipv4, the skb can fill in the middle of a fib6_nh bucket, so
you need to track which nexthop is in progress.

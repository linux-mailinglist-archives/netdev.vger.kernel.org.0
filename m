Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0754E2A5A30
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgKCWjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:39:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729342AbgKCWjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:39:54 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A08C0613D1;
        Tue,  3 Nov 2020 14:39:54 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j12so5578406iow.0;
        Tue, 03 Nov 2020 14:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q1fSjRxkdgdb3dJlgs3KGwewyjQPFNHGcFMIqXb2OR4=;
        b=FtZ8meo6Wv84NAh6ucBYC7C/wgd/hEk9mTHFtOuiif/RFtLceP/O8Njl5qH4GlaZK3
         mWUXMMu6Dxh7p/3wYZoSRnMtXvmj+412+q6EOPfZ9MTMhCLBG4L5QE+AA97muzLyC8Bn
         p+k4EEPAqpM01xqsvoAYknkFPJUDdneKW/qaPDoINySAeFtg2WPB8gMfmAhiYNtHaZ4W
         69kY8o6gmn0czqOkSVBTcVY3YQSl9FAPkXU6AMLSrK96WbH3Yo5xnm68XTILCjRj0I59
         vzqr58gktr/posU2xzosEWNt6mevU6FM5HUjC+hxWyR+tzuf8dKdYgolt8IPhnXXP4Wj
         IKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1fSjRxkdgdb3dJlgs3KGwewyjQPFNHGcFMIqXb2OR4=;
        b=bZk+BlJqR6Z7N/33CAsARUD9gi21cvTUq+E9EPti9BXDLF2C0/1Hu1a40Bqi5+GA2H
         mOS1PPzUhIC8SWRdcvtfYhMBo2vYEP+NIQgQOeEgCBiPJISXmPfMJna/da5gbhSV1eJm
         K6M8K/I3+x/FxQmoR5VDiTyFbKWN4q/t4AXtnM0sgNuBbl7jg6cd3MgNKHF+vz38P6RB
         2LsKg9qog2TG452upabOpHu7kppZqjq5zzb1okT5tFbThPPkuVtaiq219QM0Lf/IOjD8
         48V8+aQmkOXOvxHrYIp0H9JOD5inyWu3S7KWOQoF6md3r7bUfY+VTNU/So2G+oCjUoEO
         O7ig==
X-Gm-Message-State: AOAM530gKdF9vjh7NCN5rQWIjtbm8n82EYGSNQmcrvR/x1Xsiz1I81lp
        5GqMSFSfP9WdlzGsHJReOEw=
X-Google-Smtp-Source: ABdhPJwBfNahtlMkZcIhW0aghCVUqt9HwT/BxbSJ9uFwMnqZsMn3CrvvtI8CruKf+qXlR8xD6CMGkw==
X-Received: by 2002:a6b:6016:: with SMTP id r22mr14997218iog.93.1604443193936;
        Tue, 03 Nov 2020 14:39:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:def:1f9b:2059:ffac])
        by smtp.googlemail.com with ESMTPSA id u18sm78660iob.53.2020.11.03.14.39.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 14:39:53 -0800 (PST)
Subject: Re: [net-next,v1,1/5] vrf: add mac header for tunneled packets when
 sniffer is attached
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20201103125242.11468-1-andrea.mayer@uniroma2.it>
 <20201103125242.11468-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bf69c702-db2f-b9f2-148e-17a325a3cbda@gmail.com>
Date:   Tue, 3 Nov 2020 15:39:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103125242.11468-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/20 5:52 AM, Andrea Mayer wrote:
> Before this patch, a sniffer attached to a VRF used as the receiving
> interface of L3 tunneled packets detects them as malformed packets and
> it complains about that (i.e.: tcpdump shows bogus packets).
> 
> The reason is that a tunneled L3 packet does not carry any L2
> information and when the VRF is set as the receiving interface of a
> decapsulated L3 packet, no mac header is currently set or valid.
> Therefore, the purpose of this patch consists of adding a MAC header to
> any packet which is directly received on the VRF interface ONLY IF:
> 
>  i) a sniffer is attached on the VRF and ii) the mac header is not set.
> 
> In this case, the mac address of the VRF is copied in both the
> destination and the source address of the ethernet header. The protocol
> type is set either to IPv4 or IPv6, depending on which L3 packet is
> received.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  drivers/net/vrf.c | 78 +++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 72 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



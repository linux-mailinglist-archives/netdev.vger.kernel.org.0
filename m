Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C24103491
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 07:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfKTGtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 01:49:25 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34728 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKTGtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 01:49:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id e6so26769134wrw.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 22:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vTWC4l5/8BmKUCtlvX0E6ueB8Oxek0+xY29zNk8/1ug=;
        b=rmE//21oeeHYvGy8yX/0kFBgtdMlPf5nRG49f62thB+Gy6EPliGBc70fb756WXgvLM
         8U1M3zxgiX8F8iNpk/5pCTw0npTzzz4rqbzxRFGFKOegLK47yvK2ciahva/94XKwxig/
         d9SvMkm/T7wRGx4j+M833lfiVFmKGSibk1biLYtktYVIvzcTcYuZPY0cCXzlJXJzqki4
         /dfg4kjgEGDysaKL/8h/y1u/ePvNE0nWT4F1TlSvK2HRdmnIZBXSJnajEE6SvBR0jKBc
         WCTUYvtkih4rpozDZG4ZDCdsIWYZmEwSG6msvcy67wIShdyDztdNITE7/mFjyQgvq929
         DCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vTWC4l5/8BmKUCtlvX0E6ueB8Oxek0+xY29zNk8/1ug=;
        b=SAYujbe8Bgt1itZnZ3UfbvjVPL0EfECdfLdo4VgZSAX8aoBOWkX64IdeFMpcGnFN7+
         Em4zdEThoO4AOaaT2PiAUW0iN+dI2c5A9t2JPPqiJR+TMQWQny4GQEejm3uGUnIyyp0y
         Bo8FbDmzLZzBCDImwCHKYeFfy/cQmzNALTgxJtNzhyFayBB40KbvIPEdVFJFqnDFsdqA
         Jo6l0BGCEcwZBfGS7WjDLi7i2d0KqrgDad3p72pkLvJGcrH/Ni4l4fpzxnIe7J6QIOQr
         ULzXJmZbpCVwaZBF/ug5rraUC6WJguJoSEAu/Dy1fRvU7JRv8MLvOYKrbMU4ae0huec1
         Wgcg==
X-Gm-Message-State: APjAAAVY8ekRI0W8gj485jvzMqLapdyQBSsIxMMuHBzjxmAt3AeLlqgp
        bWAnXXChR82Br8yok4Lypis=
X-Google-Smtp-Source: APXvYqz2QcG7xQWL9kQVDdyLbdOl5pRmvR0f7ZrnAfl0GPMjPMcTOzPD1g64r8YOccq3lJbVOsqylQ==
X-Received: by 2002:a5d:6350:: with SMTP id b16mr1232848wrw.357.1574232562186;
        Tue, 19 Nov 2019 22:49:22 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:6952:84ea:52da:cb3b? (p200300EA8F2D7D00695284EA52DACB3B.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:6952:84ea:52da:cb3b])
        by smtp.googlemail.com with ESMTPSA id t133sm5609964wmb.1.2019.11.19.22.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 22:49:21 -0800 (PST)
Subject: Re: [PATCH net] r8169: disable TSO on a single version of RTL8168c to
 fix performance
To:     David Miller <davem@davemloft.net>, vinschen@redhat.com
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
 <20191119090939.29169-1-vinschen@redhat.com>
 <20191119.164257.971575741444657962.davem@davemloft.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6947347d-376e-ec13-a62c-5a67ed66c5aa@gmail.com>
Date:   Wed, 20 Nov 2019 07:49:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191119.164257.971575741444657962.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.11.2019 01:42, David Miller wrote:
> From: Corinna Vinschen <vinschen@redhat.com>
> Date: Tue, 19 Nov 2019 10:09:39 +0100
> 
>> During performance testing, I found that one of my r8169 NICs suffered
>> a major performance loss, a 8168c model.
>>
>> Running netperf's TCP_STREAM test didn't return the expected
>> throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
>> enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
>> throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I can
>> test (either one of 8169s, 8168e, 8168f).
>>
>> Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
>> "r8169: enable HW csum and TSO" as the culprit.
>>
>> I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
>> special-casing the 8168evl as per the patch below.  This fixed the
>> performance problem for me.
>>
>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
>> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> 
> Applied, but it would be really nice to know why this is happening
> instead of just turning it off completely.
> 
For RTL8168e-vl Realtek confirmed a HW issue, for this RTL8168c version
supposedly it's the same as other chip versions are working fine with TSO.

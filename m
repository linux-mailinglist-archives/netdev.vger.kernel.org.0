Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC8248526E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388461AbfHGRwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:52:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44068 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388204AbfHGRwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:52:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id t14so41872923plr.11;
        Wed, 07 Aug 2019 10:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qHK6kkB8Fi/Ds5btrUpUolBDHIuVi8oy4n1URIWSiyU=;
        b=anSBU7lkI6jqo7WOzTjaYq1+0A+m64e7/hXIVDv5Fx1uwnEmJMS8OsiHzb5tYrbNN8
         n9gvAzuNnR3OxlY1D7vaVmZIOgOByzCp1tdgKcivjkwmS37aCFXevl8xM0AJ3jDInZsV
         oZi0HNg9l7SoYVXfCb9J3LcumfPYKiLeQGBjr4cfO2nw0ezXWpvugcBleIUbVzTnNCDS
         +CWhzSHF55AApJ8IaeDN+3yf4RI8GmRvgjgPZgDq9O4os4SZNWMWbn7dxr6wEN5pf68l
         ly4xBMOfObvIbjzkth97usVs192spAP150JPmX9fIcsntqd6ogqxfmqpCV9+WjY7e62J
         A1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qHK6kkB8Fi/Ds5btrUpUolBDHIuVi8oy4n1URIWSiyU=;
        b=DuZfmcxeidqULxunyPJQ8pRBjVNhB/Qxh5OKBKWxE/af+cmGcGWH6A2JHEK45ZN1SR
         8008FU4Fw9XbAxBjV/OZzr2MhabMBOcN8M4gtXFZC7VCTZf/dS3VMFVRwH6AP6oCCsmm
         CRaKkxM1BCcO5xclYh4atBxpP9FndUvZiU1kLE82YeBfGaOeYcwcibjDVOKWQQ2j637f
         Mc7QIdXUQmJiQ0haEZ1Yes6bKrft0pybSCSiX4bLOvNnjtfNs5DNwGQnpumuDLWqceVM
         IbmjsAcFGRXzSgtpnvPUerO4w0xgTybaDgcADZAvnSyFzleGbMaV71Ld8nyHVpBaxC/x
         tTxA==
X-Gm-Message-State: APjAAAUAd+0KPui4mCBrToPv8noPHpVOSKh4SDQFYgWgT4ipo5U218W0
        ER+CpXyjtCgzaCp7KZbqhfE=
X-Google-Smtp-Source: APXvYqxbQkzFO65mQRqqMCvOhbvSIxlPAy+qCvqIBn4pQgumtMhPDApsYNlMQSX/75exl8ZVEwbsow==
X-Received: by 2002:a62:174a:: with SMTP id 71mr10909427pfx.140.1565200366414;
        Wed, 07 Aug 2019 10:52:46 -0700 (PDT)
Received: from [172.27.227.247] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id c35sm24900045pgl.72.2019.08.07.10.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:52:45 -0700 (PDT)
Subject: Re: [bpf-next PATCH 2/3] samples/bpf: make xdp_fwd more practically
 usable via devmap lookup
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     xdp-newbies@vger.kernel.org, a.s.protopopov@gmail.com
References: <156518133219.5636.728822418668658886.stgit@firesoul>
 <156518138310.5636.13064696265479533742.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2162ceb3-9c2d-1294-7083-ef80b8df139c@gmail.com>
Date:   Wed, 7 Aug 2019 11:52:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <156518138310.5636.13064696265479533742.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/7/19 6:36 AM, Jesper Dangaard Brouer wrote:
> This address the TODO in samples/bpf/xdp_fwd_kern.c, which points out
> that the chosen egress index should be checked for existence in the
> devmap. This can now be done via taking advantage of Toke's work in
> commit 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF").
> 
> This change makes xdp_fwd more practically usable, as this allows for
> a mixed environment, where IP-forwarding fallback to network stack, if
> the egress device isn't configured to use XDP.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  samples/bpf/xdp_fwd_kern.c |   20 ++++++++++++++------
>  samples/bpf/xdp_fwd_user.c |   36 +++++++++++++++++++++++++-----------
>  2 files changed, 39 insertions(+), 17 deletions(-)
> 
Reviewed-by: David Ahern <dsahern@gmail.com>



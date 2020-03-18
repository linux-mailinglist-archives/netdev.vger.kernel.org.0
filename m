Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14344189C00
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgCRMaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 08:30:15 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:35308 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgCRMaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 08:30:15 -0400
Received: by mail-vk1-f193.google.com with SMTP id g25so5587927vkl.2
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 05:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=S1laLumbdDac3ykHC0OQ+azF2fshSA3cZvg4LdZFzBg=;
        b=LPbqtdHhgDvosRUVnPqzzVLksA0gOVg155byLX7Nyk6gJQxRVmjVPaIfCWUZs+6X2+
         kVRvGjSZfvQSbTbUc8Wgw8e5E8GbKGWrei6OpHd798MRamEpXxuyGZA6cX+NUDideDCE
         22/Lh8SoTC6XQmNkAig7XztXRvWZoa1V6Oiyn7g77qHLblyiQujKkLhJdj68CGHeHtd7
         R2e25eWn1xQdPpXqovUTPXlAgkGLcQbtgcvs8GJbO/XUEdJwq4WsaLMwI5T/icqgb/PB
         7tViy5FYWE7di1xivzwt3Bkqg/AHzkXyDA0ILbU4I7ld20mzTMNIpgm1JYgmU4kGKCvC
         IZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=S1laLumbdDac3ykHC0OQ+azF2fshSA3cZvg4LdZFzBg=;
        b=r5vtM3rAPxSw1VLUU3d4Ph7ZkBcxvc9Rpkb6aUOrO/ztBr/cwq2vwMhL+8A12gvpfN
         8b7+WaaUsGYfB5mqV8O6TufOzmPu/Ekb5WxrMi+1kqIRVYKnDbbPMzB82XB16W6695f5
         dpu7j+oQE21FE9y611orup/h2CGZQzZOpYqwlbRAxUCMq2IZHmvv3WIlJrXpVilY9+F9
         wcB+OiEOJuwA9BPHOhM2znyEe1U0+h6cO8Op3nf+OXzORwlcfVqXedryd7Y03hDUKit1
         5N5TwKpzXtp8qP8g8Fz3qFTEmFemhgW0wBAetN4FvMiYlXfK710miO+YsNhrpBxm6fGo
         5Nfg==
X-Gm-Message-State: ANhLgQ2pg0z6HTplP3Z5tMYQm4LIFnys7gSyJcaDLV2HQaEr+EqJbBVU
        FTxFQhUVtVMzsB00d4F030j5xLGDkbuH9cHV6xnOm23d
X-Google-Smtp-Source: ADFU+vtNElDyRKS5X73vR98ltbswJ3SfFJebCw8VyeuLVa7e8s4lw3z+yG/tQkGhNUSLmvfu40lie7Bq4W/ZYh3o4WM=
X-Received: by 2002:a1f:264b:: with SMTP id m72mr2869517vkm.51.1584534613744;
 Wed, 18 Mar 2020 05:30:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9f:3b21:0:0:0:0:0 with HTTP; Wed, 18 Mar 2020 05:30:12
 -0700 (PDT)
X-Originating-IP: [5.35.35.59]
In-Reply-To: <20200316165215.1c9efb3b@carbon>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org> <20200316165215.1c9efb3b@carbon>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Wed, 18 Mar 2020 15:30:12 +0300
Message-ID: <CAOJe8K1DO8J-5HS9gq-em66H6rcmN40u65zdrVKYJqo_L4yj1A@mail.gmail.com>
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for xen-netfront
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org, wei.liu@kernel.org, paul@xen.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/20, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> On Mon, 16 Mar 2020 16:09:36 +0300
> Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
>> v3:
>> - added XDP_TX support (tested with xdping echoserver)
>> - added XDP_REDIRECT support (tested with modified xdp_redirect_kern)
>
> Please test XDP_REDIRECT with xdp_redirect_cpu from samples/bpf/.

./xdp_redirect_cpu --dev eth0 --prog xdp_cpu_map0 --cpu 1

Running XDP/eBPF prog_name:xdp_cpu_map0
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          0       5,964          0           0
XDP-RX          total   5,964          0
cpumap-enqueue    0:1   5,964          0           1.00       bulk-average
cpumap-enqueue  sum:1   5,964          0           1.00       bulk-average
cpumap_kthread  1       5,963          0           5,939      sched
cpumap_kthread  total   5,963          0           5,939      sched-sum
redirect_err    total   0              0
xdp_exception   total   0              0

I can see increase in RES:
RES:     129814     484285     198201     359270   Rescheduling interrupts


>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
>

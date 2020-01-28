Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67B114AE74
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 04:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgA1DnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 22:43:15 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:42209 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1DnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 22:43:14 -0500
Received: by mail-qk1-f196.google.com with SMTP id q15so12024039qke.9
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 19:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nrB//Vothdm9bhS+gReU21VgQM2ERZtPDXe64SwQNGs=;
        b=vMWeeDijYyMM/SS9gJJc3NNsvo6Nta7UHszPhr/1uR8OnLHFnPwtNQE8JLVLwh+2W0
         Kr17/JzRL+K0glp6u9ZmaRa3A0KextU9zA9cSL7km4LiEhS4LpQKOc9NKGutn49ddfiZ
         b540g/Ob1NGBHtH0mdQc9bs2JGkFK3H3/XMCAOW4tQgNu49VwSThTFPbb7B9rGg4eQcb
         4A6fowuXhKC/9IM8u+OfJJOZ52TFCsp0QMIzPB6T+1QFY37pr65AOdWQLfMdbS/6k/Dv
         PjjcoN/dMRTIoZVx9+B7QdlYwTVfIBg1JD/XKalyO0vg4uyaPX2mPUvKo8IPtFhcW3qK
         stlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nrB//Vothdm9bhS+gReU21VgQM2ERZtPDXe64SwQNGs=;
        b=WAduQ47QzhEXwCvkYyPRyzCv8PFfxfEY9/KKkRCRrkKFQbocSxu2fLaLTcsjhKqrXD
         vyvcEOfKoMNRMl8u/+ERkVZEhAX/TC3/ka1CvvUgaQr59BUdSYpx7cHtpu92Xd4bS4qV
         af28+boJD0Efi6gVjFyGhWtMfNj99kjky6eLVFCr5yGW8SbiY1YAugsJVVDYFGA/bz0C
         9yOBqFnYQeHbS2NogH3Sr3lYJxbkTok2Y9RdV36YoF0CyFNvFHeEIrP3Jrr0fBKl2o9Q
         Y94BhRQIVn6blbq8wKmBtLS8+1I219HtWC/rJZhiMViI0sMFh12euVibLueqL/yG5iIr
         34Bg==
X-Gm-Message-State: APjAAAX5zbD0ABSwKslvllkr2V++wEnRK4fQ7WJrHek29J4svG8F6Ttv
        pSB0A+P3GWT9jRWmB3kvr20=
X-Google-Smtp-Source: APXvYqyDUfeFnznzy3flWfa36EJZBsIrHzWFRj1tbwW3F6CyzCAXu3IyC11YNUQFcmEoFovl0DfCDg==
X-Received: by 2002:a37:91c2:: with SMTP id t185mr18525211qkd.284.1580182993112;
        Mon, 27 Jan 2020 19:43:13 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:58fc:9ee4:d099:9314? ([2601:282:803:7700:58fc:9ee4:d099:9314])
        by smtp.googlemail.com with ESMTPSA id h34sm12210799qtc.62.2020.01.27.19.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 19:43:12 -0800 (PST)
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs
 in the egress path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jbrouer@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200123014210.38412-1-dsahern@kernel.org>
 <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk>
 <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com>
 <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk>
 <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com>
 <20200126141141.0b773aba@cakuba>
 <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com>
 <20200127061623.1cf42cd0@cakuba>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com>
Date:   Mon, 27 Jan 2020 20:43:09 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127061623.1cf42cd0@cakuba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 7:16 AM, Jakub Kicinski wrote:
>> I want to run an ebpf program in the Tx path of the NIC regardless of
>> how the packet arrived at the device -- as an skb or an xdp_frame. There
>> are options for running programs on skb-based packets (e.g., tc). There
>> are *zero* options for manipulating/controlling/denying xdp_frames -
>> e.g., one REDIRECTED from an ingress device.
> 
> Okay - so no precise use case.  You can run the same program at the 

For the sake of this discussion, consider a per-VM, per-tap device ebpf
program for firewall / ACL / traffic verification (packet manipulation
is also a possibility). Small, singly focused ebpf programs - attached
at startup, driven by maps, cleaned up when the tap device is destroyed.
(Remember: Tx for tap device is ingress to a VM.)

Small, singly focused programs only run for traffic to be delivered to
the VM. Setup is easy; cleanup automatic. How the traffic got there
could vary - from a bridge (L2 forwarding), the host stack (L3 routing),
or an XDP program on the host's NICs. It could have arrived at the host
with an encap header which is removed and the inner packet forwarded to
the VM.

> end of whatever is doing the redirect (especially with Alexei's work 

There are use cases where they may make sense, but this is not one.

> on linking) and from cls_bpf 🤷‍♂️
> 

cls_bpf is tc based == skb, no? I want to handle any packet, regardless
of how it arrived at the device's xmit function.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B854325E5
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhJRSHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbhJRSHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:07:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95821C06161C;
        Mon, 18 Oct 2021 11:05:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id e5-20020a17090a804500b001a116ad95caso599144pjw.2;
        Mon, 18 Oct 2021 11:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vdhC1HAexnY/uJwgXxRHSQ+OEpMnJBTRxk6UlFSeg7c=;
        b=Rq/wDQNJ8Ox2ImWMRFavGTFvoAyse7euV5Qhi84NTqKgxfLU5U+EtOLHV+sEQVPHAP
         HwRfSpZNmz4ZhsTR1CKq4DuP+Bk0CPlbVm3m2S4LvzZeqM0h9nvAN1r/gvgs8sE5sYTX
         Vfs1YjI7+gYrDuLaZuZdf8v4NnHzZEG/F8EvnBRpIOj3Dac23JjKbUWX05s/sshy0FBt
         5XfO9riRZYBGdBmyMTYkjeUFchiBRihDXBv5wLmt0tl5tEuwutS7znWspQ5yBoctMNXz
         +Fy2mCaifxlSpVe7bAr1s6uZ9DzIrTnv2WXXP/LgN3AUlSMESaDpUSzQMSmc/0B9St8O
         tf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vdhC1HAexnY/uJwgXxRHSQ+OEpMnJBTRxk6UlFSeg7c=;
        b=xyyDy0p3qyjFEMTAnf599nHISCvLDAP0scDedp9ADPqq6MNUqxcGFKzpSyT1FAhODw
         IbRwhSFyvh9dob9rnk8Og98ieLzPIy+VbHYXI8+x1SWjTdIKhLcTQ3/eTmkvIhpCLTWU
         eguYtyBqP1i9nDWQpnBB5QwRHw9U3eEd9dckFhUnZvJ//XzFCy261ZFD/Hwf+0anhZ7j
         yecYbH91IUn05GPbyL5bzY9T7C8tFUSfI5MpKWY+/ocBEOnkS0ZHxl2R7Ori9PBy7epe
         PtT1taoOMO5B6aw8mFuiVu1uEkXliIidXAr1HLm8BcOV2nhZ6ys6+sFMQDvd9V6x03+i
         KqXQ==
X-Gm-Message-State: AOAM531YqMoVIj0Q29Kj6gYBmHeMs2PS4tMAyJBTXDjku70y1Fuv4S9J
        NoMiFE5pCayyhDdHA9U4NBhRsXSzQq4=
X-Google-Smtp-Source: ABdhPJzJpoXU86iVvVlwkVDPhinycBs05yMcw1KcHTR6IZH9eK4DFnljGA9mO/p0yN6Rt8HXs8btWg==
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr430903pjb.93.1634580326156;
        Mon, 18 Oct 2021 11:05:26 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id me12sm102469pjb.27.2021.10.18.11.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:05:25 -0700 (PDT)
Subject: Re: TCP/IP connections sometimes stop retransmitting packets (in
 nested virtualization case)
To:     Maxim Levitsky <mlevitsk@redhat.com>, netdev@vger.kernel.org
Cc:     "J. Bruce Fields" <bfields@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Tsirkin <mtsirkin@redhat.com>,
        David Gilbert <dgilbert@redhat.com>
References: <1054a24529be44e11d65e61d8760f7c59dfa073b.camel@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ed357c14-a795-3116-4db9-8486e4f71751@gmail.com>
Date:   Mon, 18 Oct 2021 11:05:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <1054a24529be44e11d65e61d8760f7c59dfa073b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/21 3:50 AM, Maxim Levitsky wrote:
> Hi!
>  
> This is a follow up mail to my mail about NFS client deadlock I was trying to debug last week:
> https://lore.kernel.org/all/e10b46b04fe4427fa50901dda71fb5f5a26af33e.camel@redhat.com/T/#u
>  
> I strongly believe now that this is not related to NFS, but rather to some issue in networking stack and maybe
> to somewhat non standard .config I was using for the kernels which has many advanced networking options disabled
> (to cut on compile time).
> This is why I choose to start a new thread about it.
>  
> Regarding the custom .config file, in particular I disabled CONFIG_NET_SCHED and CONFIG_TCP_CONG_ADVANCED. 
> Both host and the fedora32 VM run the same kernel with those options disabled.
> 
> 
> My setup is a VM (fedora32) which runs Win10 HyperV VM inside, nested, which in turn runs a fedora32 VM
> (but I was able to reproduce it with ordinary HyperV disabled VM running in the same fedora 32 VM)
>  
> The host is running a NFS server, and the fedora32 VM runs a NFS client which is used to read/write to a qcow2 file
> which contains the disk of the nested Win10 VM. The L3 VM which windows VM optionally
> runs, is contained in the same qcow2 file.
> 
> 
> I managed to capture (using wireshark) packets around the failure in both L0 and L1.
> The trace shows fair number of lost packets, a bit more than I would expect from communication that is running on the same host, 
> but they are retransmitted and don't cause any issues until the moment of failure.
> 
> 
> The failure happens when one packet which is sent from host to the guest,
> is not received by the guest (as evident by the L1 trace, and by the following SACKS from the guest which exclude this packet), 
> and then the host (on which the NFS server runs) never attempts to re-transmit it.
> 
> 
> The host keeps on sending further TCP packets with replies to previous RPC calls it received from the fedora32 VM,
> with an increasing sequence number, as evident from both traces, and the fedora32 VM keeps on SACK'ing those received packets, 
> patiently waiting for the retransmission.
>  
> After around 12 minutes (!), the host RSTs the connection.
> 
> It is worth mentioning that while all of this is happening, the fedora32 VM can become hung if one attempts to access the files 
> on the NFS share because effectively all NFS communication is blocked on TCP level.
> 
> I attached an extract from the two traces  (in L0 and L1) around the failure up to the RST packet.
> 
> In this trace the second packet with TCP sequence number 1736557331 (first one was empty without data) is not received by the guest
> and then never retransmitted by the host.
> 
> Also worth noting that to ease on storage I captured only 512 bytes of each packet, but wireshark
> notes how many bytes were in the actual packet.
>  
> Best regards,
> 	Maxim Levitsky

TCP has special logic not attempting a retransmit if it senses the prior
packet has not been consumed yet.

Usually, the consume part is done from NIC drivers at TC completion time,
when NIC signals packet has been sent to the wire.

It seems one skb is essentially leaked somewhere, and leaked (not freed)


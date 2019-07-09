Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C4F634D3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 13:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfGILT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 07:19:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40666 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfGILT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 07:19:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so14242414wrl.7
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 04:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qJfw9cUWuG0/eOP+PxgtdsXJN3ayomrqK3zeyU6QSSM=;
        b=Y1gkfJ+UuoXP40vyNRR43Qypogr+PO5jEkAmg65SjMfdu/fxlp0/mDVO6Coort6HVa
         vK8yMyVPwLfQtZm4RqNCa5EnoV9EDxrFhJDc4HA861GiRI2x/Krnxe6dp3ObEsX4p2nL
         fBwWm1DCVAWiRKIVaKCJNEczRRxH96vnqFcCkby2wl27GCSthepYQzm7Jynf+BEbvWCw
         4TZ/3yp+F0wtKMg168erQOeg8p22x5gm94gcpCoSnv4lpxkyai/EOEV2T9j7KgoiQLD/
         ll+XlVLuZtVuhhQMXE9VxEvDrQpp7KopW9DkZVEFzz5WUFoQuNVm4GuDGFsrdFO0bnn/
         Cfyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qJfw9cUWuG0/eOP+PxgtdsXJN3ayomrqK3zeyU6QSSM=;
        b=TpjEcSWQD1vRgAsb8uiIN/WeakXvTQnzipqKo/UxToD6nkE6URxss01pGpaQ7AN23s
         X9m1Ywr3ALzY4t7UwhOlS7M58c619FRIRVHfhzmUEqkI7sLw/MxTSPrW1xQeMzxH///T
         5eRg77iqMNNG6KwuzmapGdmS+s8F6q+hNePkilvij9JQGBogocBsWM2qAjMXkjQE8Smk
         HGlv68X5Q0PyuJNJtwFV/IdkSR393SupEFDE+6q2xxDYpBbimdk7Ke0L7JNEKwp0ecsb
         KMvYYBL+AZaCtT5UQSCUK7gBmgyn/PsJztpE03oXvnKMXou+1jSses5OBWegnN1mMr0Y
         vxlw==
X-Gm-Message-State: APjAAAX1QnjHoAFLimFHfcQLNtCDeYwAHgNsca+TZpYa6C9kzGWXCfsS
        8VE3bBnQ+uYYGnLgkV22fnm2NpbD
X-Google-Smtp-Source: APXvYqxJdvMMQlmsYxWLlPFYLU2w6FGlTjgxfVpS1z3csYvperiUfRKg2XCuZTbEbZvUO8b4kQe6Aw==
X-Received: by 2002:adf:ce07:: with SMTP id p7mr4098812wrn.129.1562671196564;
        Tue, 09 Jul 2019 04:19:56 -0700 (PDT)
Received: from [192.168.8.147] (179.162.185.81.rev.sfr.net. [81.185.162.179])
        by smtp.gmail.com with ESMTPSA id j33sm5166657wre.42.2019.07.09.04.19.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 04:19:55 -0700 (PDT)
Subject: Re: IPv6 flow label reflection behave for RST packets
To:     Marek Majkowski <marek@cloudflare.com>, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
References: <CAJPywT++ibhPSzL8pCS6Jpej9EeR3g9x89xssK8U=vi6FqLUUw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a854848f-9fb3-47b9-cb18-e76455e5e664@gmail.com>
Date:   Tue, 9 Jul 2019 13:19:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAJPywT++ibhPSzL8pCS6Jpej9EeR3g9x89xssK8U=vi6FqLUUw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/19 1:10 PM, Marek Majkowski wrote:
> Morning,
> 
> I'm experimenting with flow label reflection from a server point of
> view. I'm able to get it working in both supported ways:
> 
> (a) per-socket with flow manager IPV6_FL_F_REFLECT and flowlabel_consistency=0
> 
> (b) with global flowlabel_reflect sysctl
> 
> However, I was surprised to see that RST after the connection is torn
> down, doesn't have the correct flow label value:
> 
> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [S]
> IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [S.]
> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [.]
> IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [F.]
> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [P.]
> IP6 (flowlabel 0xdfc46) ::1.1235 > ::1.59276: Flags [R]
> 
> Notice, the last RST packet has inconsistent flow label. Perhaps we
> can argue this behaviour might be acceptable for a per-socket
> IPV6_FL_F_REFLECT option, but with global flowlabel_reflect, I would
> expect the RST to preserve the reflected flow label value.
> 
> I suspect the same behaviour is true for kernel-generated ICMPv6.
> 
> Prepared test case:
> https://gist.github.com/majek/139081b84f9b5b6187c8ccff802e3ab3
> 
> This behaviour is not necessarily a bug, more of a surprise. Flow
> label reflection is mostly useful in deployments where Linux servers
> stand behind ECMP router, which uses flow-label to compute the hash.
> Flow label reflection allows ICMP PTB message to be routed back to
> correct server.
> 
> It's hard to imagine a situation where generated RST or ICMP echo
> response would trigger a ICMP PTB. Flow label reflection is explained
> here:
> https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
> and:
> https://tools.ietf.org/html/rfc7098
> https://tools.ietf.org/html/rfc6438
> 
> Cheers,
>     Marek
> 
> 
> (Note: the unrelated "fwmark_reflect" toggle is about something
> different - flow marks, but also addresses RST and ICMP generated by
> the server)
> 

Please check the recent commits, scheduled for linux-5.3

a346abe051bd2bd0d5d0140b2da9ec95639acad7 ipv6: icmp: allow flowlabel reflection in echo replies
c67b85558ff20cb1ff20874461d12af456bee5d0 ipv6: tcp: send consistent autoflowlabel in TIME_WAIT state
392096736a06bc9d8f2b42fd4bb1a44b245b9fed ipv6: tcp: fix potential NULL deref in tcp_v6_send_reset()
50a8accf10627b343109a9c9d5c361751bf753b0 ipv6: tcp: send consistent flowlabel in TIME_WAIT state
323a53c41292a0d7efc8748856c623324c8d7c21 ipv6: tcp: enable flowlabel reflection in some RST packets


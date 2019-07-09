Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA076370D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGINhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:37:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38173 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGINhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 09:37:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so10933124wrr.5
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 06:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w4wK+Gx1XHpwJOL74pkdEQVdMEGMPiByt3kFn0MWhRI=;
        b=f5gvs6XxoSqykS7XN9ZC1PPucA+1660GD5364N5iPEYq0zaW8FhiNQOLu7zTtFc9gB
         f9jEEWW1GtQ87+wkeRP7tX6GJSFN8Hx6F8+GT/7rWVWPLH16Vr3HzlMMgi9/ux8Pwucj
         +GkcJHPuNv7SdI66I07QBUPzibQizBgulOcl8cpcGyy6ZWEXzGNAomF6RmakepCww+AR
         IVrsVH02zz/xUOvGCoCCB8WX38amc9Wm1hGmMvilLzLdoBUF354D2vPZBCRtOnKwq4zz
         QRshRFhfMAZ1NaV6yZ4RHQdHZqjhHzqdAQu7DVNvgqzxeDSImMRAZJrp3Xkqrv1d/ovA
         QIzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w4wK+Gx1XHpwJOL74pkdEQVdMEGMPiByt3kFn0MWhRI=;
        b=mptxzhEsknV/5/+o57iQcooCwMy9y4Yep3F5Lr/gLNhXSwhdulM1mF1Pao4ucKvStv
         HNLTasctYuUf4D5QfSzicJkpAw3b2N3M8haB4LULiTGqqXgSg7R60MxN3MWLnF70a+0p
         r/QCntWx8XYA2ZYxaS2bLCv8TfsqZl77SDuErGJ66zD6x7iVg7findpA/cTuJc8CVT8S
         UuFlqDA2eQvZZQ5MVOHBUECi/7qW+JrpdMu5Byh70fxqJUkZda1mT4B+gXpanTw0ec8x
         8b5VM7aiWbp2ucS6SMaBK32attvYHh+z2Ju9jVPC+5kYH68T+MOylz1U36VH46n+RX+M
         zSkw==
X-Gm-Message-State: APjAAAUFS59Zio/5ALLCKCrQmVP6LOvg3o+5uKjVBJRn+kLw2E7oo9/0
        lJIg2pleZFvIOBXxjeLWzBk=
X-Google-Smtp-Source: APXvYqy+C6n7WZ/DQDKEL72AGkfIzR/Qhq6POHSemhByjCIKvS9mruBXYSeA83bCHWJzoZSKHVhScA==
X-Received: by 2002:adf:e841:: with SMTP id d1mr25819407wrn.204.1562679422578;
        Tue, 09 Jul 2019 06:37:02 -0700 (PDT)
Received: from [192.168.8.147] (179.162.185.81.rev.sfr.net. [81.185.162.179])
        by smtp.gmail.com with ESMTPSA id o4sm2751843wmh.35.2019.07.09.06.37.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 06:37:02 -0700 (PDT)
Subject: Re: IPv6 flow label reflection behave for RST packets
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
References: <CAJPywT++ibhPSzL8pCS6Jpej9EeR3g9x89xssK8U=vi6FqLUUw@mail.gmail.com>
 <a854848f-9fb3-47b9-cb18-e76455e5e664@gmail.com>
 <CAJPywTKXL=_8h3aoC=n-c8o_Uo7P6RnKOgm6CpvrNsPQuw4C9A@mail.gmail.com>
 <8e2fca44-6fe7-42fc-8684-2cdd52c67103@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1cf380b3-843e-599a-105a-d1879852def1@gmail.com>
Date:   Tue, 9 Jul 2019 15:36:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <8e2fca44-6fe7-42fc-8684-2cdd52c67103@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/19 3:22 PM, Eric Dumazet wrote:
> 
> 
> On 7/9/19 2:33 PM, Marek Majkowski wrote:
>> Ha, thanks. I missed that.
>>
>> There is a caveat though. I don't think it's working as intended...
> 
> 
> Note that my commit really took a look at a fraction of the cases ;)
> 
> commit 323a53c41292a0d7efc8748856c623324c8d7c21
> 
>     ipv6: tcp: enable flowlabel reflection in some RST packets
>     
>     When RST packets are sent because no socket could be found,
>     it makes sense to use flowlabel_reflect sysctl to decide
>     if a reflection of the flowlabel is requested.
>     
> 
> In your case, a socket is found, most probably, and np->repflow seems to be ignored.
> 
> I'll take a look, thanks.

I guess a possible fix would be :

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index d56a9019a0feb5a34312ec353c555f44b8c09b3d..2a298835317c0f6b1d82fb118dc4ba9647a2a110 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -984,8 +984,13 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb)
 
        if (sk) {
                oif = sk->sk_bound_dev_if;
-               if (sk_fullsock(sk))
+               if (sk_fullsock(sk)) {
+                       struct ipv6_pinfo *np = tcp_inet6_sk(sk);
+
                        trace_tcp_send_reset(sk, skb);
+                       if (np->repflow)
+                               label = ip6_flowlabel(ipv6h);
+               }
                if (sk->sk_state == TCP_TIME_WAIT)
                        label = cpu_to_be32(inet_twsk(sk)->tw_flowlabel);
        } else {


> 
>> Running my script:
>>
>> $ sysctl -w net.ipv6.flowlabel_reflect=3
>>
>> $ tail reflect.py
>> cd2.close()
>> cd.send(b"a")
>>
>> $ python3 reflect.py
>> IP6 (flowlabel 0xf2927, hlim 64) ::1.1235 > ::1.60246: Flags [F.]
>> IP6 (flowlabel 0xf2927, hlim 64) ::1.60246 > ::1.1235: Flags [P.]
>> IP6 (flowlabel 0x58ecd, hlim 64) ::1.1235 > ::1.60246: Flags [R]
>>
>> Note. The RST is opportunistic, depending on timing I sometimes get a
>> proper FIN, without RST.
>>
>> If I change the script to introduce some delay:
>>
>> $ tail reflect.py
>> cd2.close()
>> time.sleep(0.1)
>> cd.send(b"a")
>>
>> $ python3 reflect.py
>> IP6 (flowlabel 0x2f60c, hlim 64) ::1.60326 > ::1.1235: Flags [.]
>> IP6 (flowlabel 0x2f60c, hlim 64) ::1.60326 > ::1.1235: Flags [P.]
>> IP6 (flowlabel 0x2f60c, hlim 64) ::1.1235 > ::1.60326: Flags [R]
>>
>> Now it seem to work reliably. Tested on net-next under virtme.
>>
>> Marek
>>
>> On Tue, Jul 9, 2019 at 1:19 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>
>>>
>>> On 7/9/19 1:10 PM, Marek Majkowski wrote:
>>>> Morning,
>>>>
>>>> I'm experimenting with flow label reflection from a server point of
>>>> view. I'm able to get it working in both supported ways:
>>>>
>>>> (a) per-socket with flow manager IPV6_FL_F_REFLECT and flowlabel_consistency=0
>>>>
>>>> (b) with global flowlabel_reflect sysctl
>>>>
>>>> However, I was surprised to see that RST after the connection is torn
>>>> down, doesn't have the correct flow label value:
>>>>
>>>> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [S]
>>>> IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [S.]
>>>> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [.]
>>>> IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [F.]
>>>> IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [P.]
>>>> IP6 (flowlabel 0xdfc46) ::1.1235 > ::1.59276: Flags [R]
>>>>
>>>> Notice, the last RST packet has inconsistent flow label. Perhaps we
>>>> can argue this behaviour might be acceptable for a per-socket
>>>> IPV6_FL_F_REFLECT option, but with global flowlabel_reflect, I would
>>>> expect the RST to preserve the reflected flow label value.
>>>>
>>>> I suspect the same behaviour is true for kernel-generated ICMPv6.
>>>>
>>>> Prepared test case:
>>>> https://gist.github.com/majek/139081b84f9b5b6187c8ccff802e3ab3
>>>>
>>>> This behaviour is not necessarily a bug, more of a surprise. Flow
>>>> label reflection is mostly useful in deployments where Linux servers
>>>> stand behind ECMP router, which uses flow-label to compute the hash.
>>>> Flow label reflection allows ICMP PTB message to be routed back to
>>>> correct server.
>>>>
>>>> It's hard to imagine a situation where generated RST or ICMP echo
>>>> response would trigger a ICMP PTB. Flow label reflection is explained
>>>> here:
>>>> https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
>>>> and:
>>>> https://tools.ietf.org/html/rfc7098
>>>> https://tools.ietf.org/html/rfc6438
>>>>
>>>> Cheers,
>>>>     Marek
>>>>
>>>>
>>>> (Note: the unrelated "fwmark_reflect" toggle is about something
>>>> different - flow marks, but also addresses RST and ICMP generated by
>>>> the server)
>>>>
>>>
>>> Please check the recent commits, scheduled for linux-5.3
>>>
>>> a346abe051bd2bd0d5d0140b2da9ec95639acad7 ipv6: icmp: allow flowlabel reflection in echo replies
>>> c67b85558ff20cb1ff20874461d12af456bee5d0 ipv6: tcp: send consistent autoflowlabel in TIME_WAIT state
>>> 392096736a06bc9d8f2b42fd4bb1a44b245b9fed ipv6: tcp: fix potential NULL deref in tcp_v6_send_reset()
>>> 50a8accf10627b343109a9c9d5c361751bf753b0 ipv6: tcp: send consistent flowlabel in TIME_WAIT state
>>> 323a53c41292a0d7efc8748856c623324c8d7c21 ipv6: tcp: enable flowlabel reflection in some RST packets
>>>

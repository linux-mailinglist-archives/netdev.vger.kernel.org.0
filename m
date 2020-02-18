Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2AA161E80
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 02:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 20:24:12 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52291 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgBRBYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 20:24:12 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep11so267719pjb.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 17:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5Gp0mNdCJWNTRMbZ8yffZ4IWHgBPbwvHtKX+Kp4TSCs=;
        b=vhJgd2VDKFOYNDg31fv6yWLk1S9JP5s/SsBUzSnoKNBuMp13EeJtJvAlwpbahW5N1u
         zXtJWs4xv8Vq3OXNP4bLnUexZSZ+3YKGyLameoTKeF7inqW/eCfnS9098iMHsUDlUjCR
         RCucU13tb8Ey3UMNZkW/6RIIPhvvU2K4tRQLmtndIJlhAlFey4TMbSwyejWYW/iYrsNb
         8JQKr+FGDGdgEl/bIr/zleOjOD+fyMm/KYxQj4gbFjCWPLac1l7SGW5CTYPZi++o5tQm
         ZfgquF6XV3ytBxHFOG1UgTOqfflQPFEL0NIlpwKdAmSthTm9tehF/0i+3ItnjNML9h5c
         dcPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5Gp0mNdCJWNTRMbZ8yffZ4IWHgBPbwvHtKX+Kp4TSCs=;
        b=MsHgJiVwzmvTJtbKV18tW565AKKTCWXuX+4u+/a1DLhuPC6O3Os68zkCx9EKHfRHMp
         4TCuGheDCKI1+Q47mi6h4Zm1OZg7XSwtc1m00anp/sKiH0i+Tih3FFF5wH1ixCvltRsR
         l7tNMXIHSAYvojPC2xrVJAyN8Z4aWJrKQmwLbjsRzlX0xalw/0+UVtsWeEeTmaocd891
         n6gsTxaSCLpOFKuomWu6jnIzfMwdy7oQEbDUpPLt8g66/GhirU1+BFYIA5eFL90cYF+y
         zok9cCNlXIOlZnbMD3xjP8VFrWE80TDD5JhQX/nW+mbUn5qMT/IDq3eAsMetHy53SztY
         mGNQ==
X-Gm-Message-State: APjAAAWYeBTjuKsxclJ+xejb2xOIK3XyKoqpmcc85P6DbyJp2qJT/bbp
        4wCPxVw9CUA7MX1sUVbYg6/0D5cb
X-Google-Smtp-Source: APXvYqyn4WhJVa2+5neGoW7S0B+i1QeW/2gwjFd/mQEvITkQurVWbdys9Z+RMf82lZIBlCuT4DSwCQ==
X-Received: by 2002:a17:902:321:: with SMTP id 30mr19471945pld.130.1581989050333;
        Mon, 17 Feb 2020 17:24:10 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y1sm2055606pgi.56.2020.02.17.17.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 17:24:09 -0800 (PST)
Subject: Re: [BISECTED] UDP socket bound to addr_any receives no data after
 disconnect
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavel Roskin <plroskin@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
References: <CAN_72e2m8ZYTu1wsqHabvHct8d0Ftf6VHrh-ZGJNR0-Bpa2cyw@mail.gmail.com>
 <CA+FuTSdB8nAohzbKKS3aGifRB4iJx_tFKTPaD_0MSAPLxRdrSg@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5e0fe3fd-5922-af43-2bbb-46d237858e89@gmail.com>
Date:   Mon, 17 Feb 2020 17:24:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdB8nAohzbKKS3aGifRB4iJx_tFKTPaD_0MSAPLxRdrSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/17/20 3:20 PM, Willem de Bruijn wrote:
> On Sun, Feb 16, 2020 at 10:53 AM Pavel Roskin <plroskin@gmail.com> wrote:
>>
>> Hello,
>>
>> I was debugging a program that uses UDP to serve one client at a time.
>> It stopped working on newer Linux versions. I was able to bisect the
>> issue to commit 4cdeeee9252af1ba50482f91d615f326365306bd, "net: udp:
>> prefer listeners bound to an address". The commit is present in Linux
>> 5.0 but not in 4.20. Linux 5.5.4 is still affected.
>>
>> From reading the commit description, it doesn't appear that the effect
>> is intended. However, I found that the issue goes away if I bind the
>> socket to the loopback address.
>>
>> I wrote a demo program that shows the problem:
>>
>> server binds to 0.0.0.0:1337
>> server connects to 127.0.0.1:80
>> server disconnects
>> client connects to 127.0.0.1:1337
>> client sends "hello"
>> server gets nothing
>>
>> Load a 4.x kernel, and the server would get "hello". Likewise, change
>> "0.0.0.0" to "127.0.0.1" and the problem goes away.
>>
>> IPv6 has the same issue. I'm attaching programs that demonstrate the
>> issue with IPv4 and IPv6. They print "hello" on success and hang
>> otherwise.
> 
> Thanks for the report with reproducers. That's very helpful.
> 
> Before the patch, __udp4_lib_lookup looks into the hslot table hashed
> only by destination port.
> 
> After the patch, it goes to hslot2, hashed by dport and daddr. Before
> the connect and disconnect calls, the server socket is hashed on
> INADDR_ANY.
> 
> The connect call changes inet_rcv_saddr and calls sk_prot->rehash to
> move the socket to the hslot hashed on its saddr matching the new
> destination.
> 
> The disconnect call reverts inet_rcv_saddr to INADDR_ANY, but lacks a
> rehash. The following makes your ipv4 test pass:
> 
> @@ -1828,8 +1828,11 @@ int __udp_disconnect(struct sock *sk, int flags)
>         inet->inet_dport = 0;
>         sock_rps_reset_rxhash(sk);
>         sk->sk_bound_dev_if = 0;

BTW, any idea why sk_bound_dev_if is cleared ?

This looks orthogonal to a disconnect.

> -       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +       if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
>                 inet_reset_saddr(sk);
> +               if (sk->sk_prot->rehash)
> +                       sk->sk_prot->rehash(sk);
> +       }

Note that we might call sk->sk_prot->unhash(sk) right after this point,
so maybe avoid a rehash unless really needed.

if (!(sk->sk_userlocks & SOCK_BINDPORT_LOCK)) {
        sk->sk_prot->unhash(sk);
        inet->inet_sport = 0;
}


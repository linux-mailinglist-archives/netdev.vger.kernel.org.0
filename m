Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53352231
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 06:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfFYEkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 00:40:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33642 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfFYEkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 00:40:11 -0400
Received: by mail-pf1-f195.google.com with SMTP id x15so8789337pfq.0
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 21:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=le7WO334hT4VkCM2URnTWxwFBKTdVFEc+iEv1d1vk2A=;
        b=JAQkq1NGXNgoU/m+tted0n1/w0R7yPxZaTLHi0+Scb0s1JshebDxVQUwK1ZQhA7RPI
         hgLkIXYHvMCKPZuGHg8kNz7dN5sm9shboEJ1FlyVd8nfKKYqKugS5eNYlJcX5U6ZZWPG
         pFIEtMYgbeZRq5OnXSnwGT5rWV9ZvlOlsA2gv8p82peGT05PKGemuy9DVuD+8Md7Tgt4
         P4nOBeEgslqB8w7+bIhLlGrX7o1lGF/1iYBrkPlPo1lR+5YgTKBIUZBgE4zQSRBbU5Js
         Bm0JXmxu9RB7YgbEWcTebbw13HkU2xjOupxlaPdr8CIK58pFYzlH0ntY3tuKLaDYFMN3
         OTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=le7WO334hT4VkCM2URnTWxwFBKTdVFEc+iEv1d1vk2A=;
        b=ODlUvgFU2RKYnG+8LKzfdY45hx3uZoLATY6Y7J18SQ3KxMkpIOM9wM2dnL2dFVtXzE
         rz/KByUL4ii6qS7qOhDRyAwHiiaIfMy3XIIt6S40h8fggKUZuilGr1nBR/xOCDj9F0ui
         hyIgfcjGZTbbBievq58rE6LOt8fDNcwn8A4JCYSsdghzErhEbhhviB+W0Z1TBeD8vcXU
         3ma/w0aBpv/G7TDgPkLJARRJmbJahi6le8FEjN+pmb8Kq7XssgZYkoUjO+543528TUab
         hQ+Uh+8FnhERCKkbzzZDsmPtdZ0HqFFx7H3vjFdCJeiseuMl92I80dwPuRXkNyTA+l18
         MJBA==
X-Gm-Message-State: APjAAAWaLPb5TnH2Gh77FMZvEb1PDjz1vurwwsBlQxsnm/soZN0z0XHw
        pRT39BYDu9rtl8y0xWQ3serVV8vKvCY=
X-Google-Smtp-Source: APXvYqyZQUq9dHLCBzwmz1HqLf5A//Jwv6j4pE/03LAfoB9d1aBR1o4aBwFUo047BNpt0ZKxVJuuCQ==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr29827494pja.104.1561437610254;
        Mon, 24 Jun 2019 21:40:10 -0700 (PDT)
Received: from etsukata.local (fs76eecbcd.tkyc008.ap.nuro.jp. [118.238.203.205])
        by smtp.gmail.com with ESMTPSA id t96sm1124663pjb.1.2019.06.24.21.40.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 21:40:09 -0700 (PDT)
Subject: Re: [PATCH 1/2] tty: ldisc: Fix misuse of proc_dointvec
 "ldisc_autoload"
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     jslaby@suse.com, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20190625030801.24538-1-devel@etsukata.com>
 <20190625033216.GA11902@kroah.com>
From:   Eiichi Tsukata <devel@etsukata.com>
Openpgp: preference=signencrypt
Autocrypt: addr=devel@etsukata.com; keydata=
 mQINBFydxe0BEAC2IUPqvxwzh0TS8DvqmjU+pycCq4xToLnCTy9gfmHd/mJWGykQJ7SXXFg2
 bTAp8XcITVEDvhMUc0G4l+RBYkArwkaMHO5iM4a7+Gnn6beV1CL/dk9Wu5gkThgL11bhyKmQ
 Ub1duuVkX3fN2cRW2DrHsTp+Bxd/pq5rrKAbA/LIFmF4Oipapgr69I5wUeYywpzPFuaVkoZc
 oLdAscwEvPImSOAAJN0sesBW9sBAH34P+xaW2/Mug5aNUm/K6whApeFV/qz2UuOGjzY4fbYw
 AjK1ALIK8rdeAPxvp2e1dXrj29YrIZ2DkzdR0Y9O8Lfz1Pp5aQ+pwUQzn2vWA3R45IItVtV5
 8v04N/F7rc/1OHFpgFtzgAO2M51XiIPdbSmF/WuWPsdEHWgpVW3H/I8amstfH519Xb/AOKYQ
 7a14/3EESVuqXyyfCdTVnBNRRY0qXJ7mA0oParMD8XKMOVLj6Nlvs2Zh2LjNJhUDsssKNBg+
 sMKiaeSV8dtcbH2XCc2GDKsYbrIKG3cu5nZl8xjlM3WdtdvqWpuHj6KTYBQgsXngBA7TDZWT
 /ccYyEQpUdtCqPwV0BPho6pr8Ug6J99b1KyZKd/z3iQNHYYh3Iy08wIfUHEXoFiYhMtbfKtW
 21B/27EABXMHYnvekhJkVA9E4sfGlDZypU7hWEoiGnAZLCkr2QARAQABtCNFaWljaGkgVHN1
 a2F0YSA8ZGV2ZWxAZXRzdWthdGEuY29tPokCVAQTAQgAPhYhBKeOigYiCRnByygZ7IOzEG5q
 Kr5hBQJcncXtAhsjBQkJZgGABQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEIOzEG5qKr5h
 UvMP/RIo3iIID+XjPPQOjX26wfLrAapgKkBF2KlenVXpEua8UUY0NV4l1l796TrMWtlRS0B1
 ikGKDcsbP4eQFLrmguaNMihr89YQzM2rwFlloSH8R3bTkub2if/5RCJj2kPXEjgwCb7tofDN
 Hz7hjZOQUYNo3yiyeED/mtJGR05+twMJzedehBHxoEFb3cWXT/aD2fsYdZzRqw74rBAdlTnD
 q0aaJJ/WOP7zSwodQLwTjTxF4WorDY31Q1EqqJun6jErHviWu7mYfSSRc4q8tzh8XfIP7WZV
 O9jB+gYTZxhbgXdxZurV3hiwHgKPgC6Q2bSP6vRgSbzNhvS+jc05JWCWMnpe8kdRyViHKIfm
 y0Kap32OwRP5x+t0y52jLryxvBfUF3xGI78Qx9f8L5l56GQlGkgBH5X2u109XvqD+aed5aPk
 mUSsvO94Mv6ABoGe3Im0nfI07oxwIp79etG1kBE9q4kGiWQ8/7Uhc2JR6a/vIceCVJDyagll
 D7UvNITbFvhsTh6KaDnZQYiGMja2FxXN6sCvjyr+hrya/sqBZPQqXzpvfBq5nLm1rAvJojqM
 7HA9742wG3GmdwogdbUrcAv6x3mpon12D0guT+4bz5LTCfFFTCBdPLv7OsQEhphsxChGsdt2
 +rFD48wXU6E8XNDcWxbGH0/tJ05ozhqyipAWNrImuQINBFydxe0BEAC6RXbHZqOo8+AL/smo
 2ft3vqoaE3Za3XHRzNEkLPXCDNjeUKq3/APd9/yVKN6pdkQHdwvOaTu7wwCyc/sgQn8toN1g
 tVTYltW9AbqluHDkzTpsQ+KQUTNVBFtcTM4sMQlEscVds4AcJFlc+LRpcKdVBWHD0BZiZEKM
 /yojmJNN9nr+rp1bkfTnSes8tquUU3JSKLJ01IUlxVMtHPRTT/RBRkujSOCk0wcXh1DmWmgs
 y9qxLtbV8dIh2e8TQIxb3wgTeOEJYhLkFcVoEYPUajHNyNork5fpHNEBoWGIY9VqsA38BNH6
 TZLQjA/6ERvjzDXm+lY7L11ErKpqbHkajliL/J/bYqIebKaQNCO14iT62qsYh/hWTPsEEK5S
 m8T92IDapRCge/hQMuWOzpVyp3ubN0M98PC9MF+tYXQg3kuNoEa/8isArhuv/kQWD0odW4aH
 3VaUufI+Gy5YmjRQckSHrG5sTTnh13EI5coVIo+HFLBSRBqTkrRjfcnPHvDamcteuzKFkk+m
 uGO4xa6/vacR8cZB/GJ7bLJqNdaJSVDDXc+UYXiN1AITMtUYQoP6fEtw1tKjVbv3gc52kHG6
 Q71FFJU0f08/S3VnyCCjQMy4alQVan3DSjykYNC8ND0lovMtgmSCf4PmGlxCbninP5OU+4y3
 MRo74kGnhqpc9/djiQARAQABiQI8BBgBCAAmFiEEp46KBiIJGcHLKBnsg7MQbmoqvmEFAlyd
 xe0CGwwFCQlmAYAACgkQg7MQbmoqvmGAUA/+P1OdZ6bAnodkAuFmR9h3Tyl+29X5tQ6CCQfp
 RRMqn9y7e1s2Sq5lBKS85YPZpLJ0mkk9CovJb6pVxU2fv5VfL1XMKGmnaD9RGTgsxSoRsRtc
 kB+sdbi5YDsjqOd4NfHvHDpPLcB6dW0BAC3tUOKClMmIFy2RZGz5r/6sWwoDWzJE0YTe63ig
 h64atJYiVqPo4Bt928xC/WEmgWiYoG+TqTFqaK3RbbgNCyyEEW6eJhmKQh1gP0Y9udnjFoaB
 oJGweB++KV1u6eDqjgCmrN603ZIg1Jo2cmJoQK59SNHy/C+g462NF5OTO/hGEYJMRMH+Fmi2
 LyGDIRHkhnZxS12suGxka1Gll0tNyOXA88T2Z9wjOsSHxenGTDv2kP5uNDw+gCZynBvKMnW4
 8rI3fWjNe5s1rK9a/z/K3Bhk/ojDEJHSeXEr3siS2/6E4UhDNXd/ZGZi5fRI2lo8Cp+oTS0Q
 m6FIxqnoPWVCsi1XJdSSQtTMxU0qesAjRXTPE76lMdUQkYZ/Ux1rbzYAgWFatvx4aUntR+1N
 2aCDuAIID8CNIhx40fGfdxVa4Rf7vfZ1e7/mK5lDZVnWwTOJFNouvlILKLcDPNO51R5XKsc1
 zxZwI+P1sTpSBI/KtFfphfaN93H3dLiy26D1P8ShFz6IEfTgK4OVWhqCaOe9oTXTwwNzBQ4=
X-Enigmail-Draft-Status: N11100
Message-ID: <ffef8850-7523-ad63-165d-2bde9a98e340@etsukata.com>
Date:   Tue, 25 Jun 2019 13:40:05 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190625033216.GA11902@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/06/25 12:32, Greg KH wrote:
> On Tue, Jun 25, 2019 at 12:08:00PM +0900, Eiichi Tsukata wrote:
>> /proc/sys/dev/tty/ldisc_autoload assumes given value to be 0 or 1. Use
>> proc_dointvec_minmax instead of proc_dointvec.
>>
>> Fixes: 7c0cca7c847e "(tty: ldisc: add sysctl to prevent autoloading of ldiscs)"
>> Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
>> ---
>>  drivers/tty/tty_ldisc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
>> index e38f104db174..a8ea7a35c94e 100644
>> --- a/drivers/tty/tty_ldisc.c
>> +++ b/drivers/tty/tty_ldisc.c
>> @@ -863,7 +863,7 @@ static struct ctl_table tty_table[] = {
>>  		.data		= &tty_ldisc_autoload,
>>  		.maxlen		= sizeof(tty_ldisc_autoload),
>>  		.mode		= 0644,
>> -		.proc_handler	= proc_dointvec,
>> +		.proc_handler	= proc_dointvec_minmax,
>>  		.extra1		= &zero,
>>  		.extra2		= &one,
> 
> Ah, nice catch.  But this really isn't an issue as if you use a bigger
> value, things will not "break", right?
> 

Someone may misuse -1 to disable ldisc autoload, but basically it does not
"break".

Thanks,

Eiichi

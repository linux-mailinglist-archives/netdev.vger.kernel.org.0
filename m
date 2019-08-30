Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D887A412A
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 01:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfH3Xwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 19:52:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36220 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbfH3Xwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 19:52:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id w2so5587945pfi.3;
        Fri, 30 Aug 2019 16:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i6gaqbbi0w9Z++fmZe4oJz8J46wOKMsCmh1oC55SfoI=;
        b=MvljkxaBF43NTZ2FCElFlaiQgzsh8rAvMKzTSjK4flR1I+rhaaXMO/FBb52lNwvh4V
         4XTb3PeUU+QH4f8//5wmErdI7CCNJb7Qws/81HutaocHB7oiLgGlBDQBnp5N1ZC6zAJw
         E1gI7h4/pV5rc/kxLT8Yw0tytHZPx4edFbIjesSdC4u77VUExaR2slHt0OoTl0cpNR4P
         EnjcZ72R0XOwg5oBUimB6e3hdd81GiM4XcucjKHzvh/u0kR2VzRuEXt15svqgNFbW+rK
         G3BAuaxvNhqeh564nYyHyE2YwP/uil8Su+bqLWqew7QDK3l1xUcR8H8qwxg7EtL+7iQR
         em3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=i6gaqbbi0w9Z++fmZe4oJz8J46wOKMsCmh1oC55SfoI=;
        b=tTT1cXNKXnQmXcRn2iteBcuKP0x7MHLDcm/HyQMP2R+uWEM+MnF2aLGdJLVsbZSNUp
         TxxuSep3ehWNv+sN/cHfsvd7/J/Dv3XJAMnLcMqrgfhHoStNag59I3yeQaLaYhaHM/aR
         vQtyuqagcqRDw5N1+4bQIaq/VLh4KPJNgsW+rTwVodU4mZh9T+MaiNvMHLUK3J/TriQo
         WJMfB9bIQOqcA7QkkzQp+mWg5v17qyEk7U1+szDS9gO2q0snr5qC6NN0iQm/rFBLDVz6
         5VAiC2BCMt0/xaFXdu0LILiO/Q2zsRSOsr7dQXuOJ6KkOOR4hjlF/Rue5QREFPswlV7Z
         RcCg==
X-Gm-Message-State: APjAAAXetIwBe3youK5dq7I0cBSUIk7NXZAadinGvkvVD//wCPfnNMcH
        C35NzlXHOeRMjhln1RJ6iIEE/MeG
X-Google-Smtp-Source: APXvYqzTKHefvHBlBNuWWhk6IlGSXzTLDiwN5GgA8fJqKVlAEsBr86UlDtZrBlYj1EAlxiPIEeEC6g==
X-Received: by 2002:aa7:8510:: with SMTP id v16mr5146877pfn.113.1567209149900;
        Fri, 30 Aug 2019 16:52:29 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9sm6415396pgp.75.2019.08.30.16.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Aug 2019 16:52:29 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: use ethtool_op_get_ts_info()
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "Ryan M. Collins" <rmc032@bucknell.edu>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190830184955.GA27521@pop-os.localdomain>
 <a7003b3c-4035-5d4f-43e7-a8a76dcea0fb@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 xsBNBFWUMnYBCADCqDWlxLrPaGxwJpK/JHR+3Lar1S3M3K98bCw5GjIKFmnrdW4pXlm1Hdk5
 vspF6aQKcjmgLt3oNtaJ8xTR/q9URQ1DrKX/7CgTwPe2dQdI7gNSAE2bbxo7/2umYBm/B7h2
 b0PMWgI0vGybu6UY1e8iGOBWs3haZK2M0eg2rPkdm2d6jkhYjD4w2tsbT08IBX/rA40uoo2B
 DHijLtRSYuNTY0pwfOrJ7BYeM0U82CRGBpqHFrj/o1ZFMPxLXkUT5V1GyDiY7I3vAuzo/prY
 m4sfbV6SHxJlreotbFufaWcYmRhY2e/bhIqsGjeHnALpNf1AE2r/KEhx390l2c+PrkrNABEB
 AAHNJkRvdWcgQmVyZ2VyIDxkb3VnLmJlcmdlckBicm9hZGNvbS5jb20+wsEHBBABAgCxBQJa
 sDPxFwoAAb9Iy/59LfFRBZrQ2vI+6hEaOwDdIBQAAAAAABYAAWtleS11c2FnZS1tYXNrQHBn
 cC5jb22OMBSAAAAAACAAB3ByZWZlcnJlZC1lbWFpbC1lbmNvZGluZ0BwZ3AuY29tcGdwbWlt
 ZQgLCQgHAwIBCgIZAQUXgAAAABkYbGRhcDovL2tleXMuYnJvYWRjb20uY29tBRsDAAAAAxYC
 AQUeAQAAAAQVCAkKAAoJEEv0cxXPMIiXDXMH/Aj4wrSvJTwDDz/pb4GQaiQrI1LSVG7vE+Yy
 IbLer+wB55nLQhLQbYVuCgH2XmccMxNm8jmDO4EJi60ji6x5GgBzHtHGsbM14l1mN52ONCjy
 2QiADohikzPjbygTBvtE7y1YK/WgGyau4CSCWUqybE/vFvEf3yNATBh+P7fhQUqKvMZsqVhO
 x3YIHs7rz8t4mo2Ttm8dxzGsVaJdo/Z7e9prNHKkRhArH5fi8GMp8OO5XCWGYrEPkZcwC4DC
 dBY5J8zRpGZjLlBa0WSv7wKKBjNvOzkbKeincsypBF6SqYVLxFoegaBrLqxzIHPsG7YurZxE
 i7UH1vG/1zEt8UPgggTOwE0EVZQydwEIAM90iYKjEH8SniKcOWDCUC2jF5CopHPhwVGgTWhS
 vvJsm8ZK7HOdq/OmA6BcwpVZiLU4jQh9d7y9JR1eSehX0dadDHld3+ERRH1/rzH+0XCK4JgP
 FGzw54oUVmoA9zma9DfPLB/Erp//6LzmmUipKKJC1896gN6ygVO9VHgqEXZJWcuGEEqTixm7
 kgaCb+HkitO7uy1XZarzL3l63qvy6s5rNqzJsoXE/vG/LWK5xqxU/FxSPZqFeWbX5kQN5XeJ
 F+I13twBRA84G+3HqOwlZ7yhYpBoQD+QFjj4LdUS9pBpedJ2iv4t7fmw2AGXVK7BRPs92gyE
 eINAQp3QTMenqvcAEQEAAcLBgQQYAQIBKwUCVZQyeAUbDAAAAMBdIAQZAQgABgUCVZQydwAK
 CRCmyye0zhoEDXXVCACjD34z8fRasq398eCHzh1RCRI8vRW1hKY+Ur8ET7gDswto369A3PYS
 38hK4Na3PQJ0kjB12p7EVA1rpYz/lpBCDMp6E2PyJ7ZyTgkYGHJvHfrj06pSPVP5EGDLIVOV
 F5RGUdA/rS1crcTmQ5r1RYye4wQu6z4pc4+IUNNF5K38iepMT/Z+F+oDTJiysWVrhpC2dila
 6VvTKipK1k75dvVkyT2u5ijGIqrKs2iwUJqr8RPUUYpZlqKLP+kiR+p+YI16zqb1OfBf5I6H
 F20s6kKSk145XoDAV9+h05X0NuG0W2q/eBcta+TChiV3i8/44C8vn4YBJxbpj2IxyJmGyq2J
 AAoJEEv0cxXPMIiXTeYH/AiKCOPHtvuVfW+mJbzHjghjGo3L1KxyRoHRfkqR6HPeW0C1fnDC
 xTuf+FHT8T/DRZyVqHqA/+jMSmumeUo6lEvJN4ZPNZnN3RUId8lo++MTXvtUgp/+1GBrJz0D
 /a73q4vHrm62qEWTIC3tV3c8oxvE7FqnpgGu/5HDG7t1XR3uzf43aANgRhe/v2bo3TvPVAq6
 K5B9EzoJonGc2mcDfeBmJpuvZbG4llhAbwTi2yyBFgM0tMRv/z8bMWfAq9Lrc2OIL24Pu5aw
 XfVsGdR1PerwUgHlCgFeWDMbxZWQk0tjt8NGP5cTUee4hT0z8a0EGIzUg/PjUnTrCKRjQmfc YVs=
Message-ID: <37108bf4-057a-f792-7461-397f530e3200@gmail.com>
Date:   Fri, 30 Aug 2019 16:52:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a7003b3c-4035-5d4f-43e7-a8a76dcea0fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 11:51 AM, Florian Fainelli wrote:
> On 8/30/19 11:49 AM, Ryan M. Collins wrote:
>> This change enables the use of SW timestamping on the Raspberry Pi 4.
> 
> Finally the first bcmgenet patch that was tested on the Pi 4!
> 
>>
>> bcmgenet's transmit function bcmgenet_xmit() implements software
>> timestamping. However the SOF_TIMESTAMPING_TX_SOFTWARE capability was
>> missing and only SOF_TIMESTAMPING_RX_SOFTWARE was announced. By using
>> ethtool_ops bcmgenet_ethtool_ops() as get_ts_info(), the
>> SOF_TIMESTAMPING_TX_SOFTWARE capability is announced.
>>
>> Similar to commit a8f5cb9e7991 ("smsc95xx: use ethtool_op_get_ts_info()")
>>
>> Signed-off-by: Ryan M. Collins <rmc032@bucknell.edu>
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
Thanks Ryan!

Acked-by: Doug Berger <opendmb@gmail.com>


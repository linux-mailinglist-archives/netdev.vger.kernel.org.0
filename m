Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E7C6D7F8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 02:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfGSAvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 20:51:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42816 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfGSAvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 20:51:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so14743341plb.9;
        Thu, 18 Jul 2019 17:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S45qd7gaDXikhWp3JAm28CCVCVAPb9P65aHBd8beHKU=;
        b=ckfiZo9HwxUFLq75+7WFC0KY/Cu2i6pUU61QBfZw+cFv7r5ZYUWxnIhH6LbM/zY2sb
         rgiLp9GE1NeExmPRsbK3EmjIDZFOrnqxO1GIiXEjrgRL/2s7xz5TCN+6C7NbR13k1lq0
         PW2VqsEpOWUdmWipe/ROnlTGot9gzsR0LBvTzhHxY4HQ9Hvk6T82vmMhYPWrfpK+LDFt
         6xuphE9nkl2113gUvgRzLtV3CkeEPg/oobz7HqfM32UOMwmmIJ2MvLydi6UixR3cnFrJ
         QcutKB9Oz1MLFGDF1KsH0HxfgYxHR3F8KYa6/qn3UfWYnMrOSIgGjj6GIpraG7yyEdwv
         9cqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S45qd7gaDXikhWp3JAm28CCVCVAPb9P65aHBd8beHKU=;
        b=iYiVoq5rW+FDqJoE+ks99xFNc44abH0M11rjzwgdZ1YGmoAPLYhTwI0p1tdHOBE16Z
         J2Dr7FnJLPah1gLdri7L2qx0cHRfR+9+TsWBMHxAwupno3K5I3EOfQQlTHN8hHBySPbJ
         vfD1ACt8mxXlnppOP/geDdhhnZ5s8P7mbLDsLkcMQXnKxqXpU+oIT10DTUDTOGfvbbSB
         9sl3x1tGQl52V89sCNWJhjTC8eRGjKcZTZQK1rYnbVU/xqtUHYDqYSpO9VtSrwA3ofO0
         ULIu/D0e3RAhMye0enAlFq/D+URLUGzNoyAijcLd5ZSbaokI+yc8XmlnmZZvWuIel9wf
         p40w==
X-Gm-Message-State: APjAAAUaJ0mUhd8qLA3a+yH2/cOACTdeqPRbur0rRkxYRY6FaK+8GCeW
        2dvaZRnoQvHp9Ro7XdOEVPNWjnIm
X-Google-Smtp-Source: APXvYqzvOE6KU+OpdMuoTYYbg5Hvkb8L75u+Rc31+XSe3vtIwNV36Djj8vN2RiyNdCBZH1JNeB0BWQ==
X-Received: by 2002:a17:902:694a:: with SMTP id k10mr52954272plt.255.1563497483071;
        Thu, 18 Jul 2019 17:51:23 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s15sm28526063pfd.183.2019.07.18.17.51.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 17:51:22 -0700 (PDT)
Subject: Re: [PATCH] net: bcmgenet: use promisc for unsupported filters
To:     justinpopo6@gmail.com, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        f.fainelli@gmail.com
References: <1563400733-39451-1-git-send-email-justinpopo6@gmail.com>
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
Message-ID: <f54b5a80-4ef2-b531-b247-05ff85d7f219@gmail.com>
Date:   Thu, 18 Jul 2019 17:51:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1563400733-39451-1-git-send-email-justinpopo6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 2:58 PM, justinpopo6@gmail.com wrote:
> From: Justin Chen <justinpopo6@gmail.com>
> 
> Currently we silently ignore filters if we cannot meet the filter
> requirements. This will lead to the MAC dropping packets that are
> expected to pass. A better solution would be to set the NIC to promisc
> mode when the required filters cannot be met.
> 
> Also correct the number of MDF filters supported. It should be 17,
> not 16.
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>

Acked-by: Doug Berger <opendmb@gmail.com>

Thanks Justin :)
    Doug

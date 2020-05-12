Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D210D1CEB8B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgELDfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:35:41 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB7CC061A0C;
        Mon, 11 May 2020 20:35:41 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b12so2873698plz.13;
        Mon, 11 May 2020 20:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lZD4Eiorgg2/SymlR4y976Vh1lspTTlRY2Lka37d2Yw=;
        b=sSH/RuBje6Kyd6IxW0tYaZ5VU/j38MDLPEtcZEQWj971kIJuIyWBc9iEMT5Hs5yFSU
         4QRNbcyZ5uh3hWisLgTRlpgkVcH7vN8HdOhP6v11qWVeP+rVnHklKaBdClpoi9YSVbH8
         NIs09shvpmrhRJRIPVmmjOiFaOAIU5gGJ0KEr/gfzzQf3slmtAPTC/1J/rHTxKq0YWTx
         qp+nnXnzHn1+ZuyaiGJzWQ4qMI1hdS4IvrBk7JVBgfmdj67xO+xwjt1B3FXiABuoUE3q
         zrn3NNBG2F8sFw0lYJYzwzqxtWQp2/jJKHFiScYHXrdiAH7CxCtt228rH8eiJgkLqmmO
         zA9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZD4Eiorgg2/SymlR4y976Vh1lspTTlRY2Lka37d2Yw=;
        b=fg0x2bsBoA6Q6lxAz2MrFf/0aOhR/mCVxaeetQB19Ijrap8xsJqvIC0dIuFPeqEvqS
         mfPKwOSYHSU5Td+QSl624HE1hxsGbL7Ff147SkW6OFF/6yjAfiBllQwECs6EaUfUY2C+
         CuF34VyERi3POq9Arf5+a9zUTHdiAONrmgzcnZ1PgboAotDf+3fWgv3qb1Mi6o8V7Taw
         ycPPJQtYdYEGwvYLV7B42yTkgyXKLcNo2cagvvkT9Gg3zdB+ojiKozTZaCj7wWKTzJ34
         qXB8HfMk6zwjJ28fHl9dQyJVv1FoPSzkTLeaMwRxRkYWoX9j2Elekik/AmKFJZ1OIeEf
         MaJw==
X-Gm-Message-State: AGi0PubQs2pppMyXgW1KWk/nqhQE7UhY8dOD9N+vMk1rs+0nsWTRvIPG
        CZEY6AARuzA/vLtBatXBtQUVqfHt
X-Google-Smtp-Source: APiQypLrbC8hhIw9VrJN02j185e+SH1tyVAD4EaKmDla54XuP02BV/thuBq04a8WwYLIBANehdghsA==
X-Received: by 2002:a17:90a:216b:: with SMTP id a98mr25392204pje.235.1589254540473;
        Mon, 11 May 2020 20:35:40 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b20sm10502715pff.8.2020.05.11.20.35.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:35:39 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 09/15] net: dsa: tag_8021q: support up to 8
 VLANs per port using sub-VLANs
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ebb3f4f8-0f71-094b-e997-ffcd769d6e48@gmail.com>
Date:   Mon, 11 May 2020 20:35:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> For switches that support VLAN retagging, such as sja1105, we extend
> dsa_8021q by encoding a "sub-VLAN" into the remaining 3 free bits in the
> dsa_8021q tag.
> 
> A sub-VLAN is nothing more than a number in the range 0-7, which serves
> as an index into a per-port driver lookup table. The sub-VLAN value of
> zero means that traffic is untagged (this is also backwards-compatible
> with dsa_8021q without retagging).
> 
> The switch should be configured to retag VLAN-tagged traffic that gets
> transmitted towards the CPU port (and towards the CPU only). Example:
> 
> bridge vlan add dev sw1p0 vid 100
> 
> The switch retags frames received on port 0, going to the CPU, and
> having VID 100, to the VID of 1104 (0x0450). In dsa_8021q language:
> 
>  | 11  | 10  |  9  |  8  |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
>  +-----------+-----+-----------------+-----------+-----------------------+
>  |    DIR    | SVL |    SWITCH_ID    |  SUBVLAN  |          PORT         |
>  +-----------+-----+-----------------+-----------+-----------------------+
> 
> 0x0450 means:
>  - DIR = 0b01: this is an RX VLAN
>  - SUBVLAN = 0b001: this is subvlan #1
>  - SWITCH_ID = 0b001: this is switch 1 (see the name "sw1p0")
>  - PORT = 0b0000: this is port 0 (see the name "sw1p0")
> 
> The driver also remembers the "1 -> 100" mapping. In the hotpath, if the
> sub-VLAN from the tag encodes a non-untagged frame, this mapping is used
> to create a VLAN hwaccel tag, with the value of 100.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

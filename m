Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7494255749
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgH1JOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 05:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728218AbgH1JO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 05:14:29 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAF8C061264;
        Fri, 28 Aug 2020 02:14:29 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l7so595120wrx.8;
        Fri, 28 Aug 2020 02:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bFeVd3y76f8JCnVoxv7uErhjRJ/Acf3IGCqwDe0vYzo=;
        b=ASAb4ZKP8q64pDUw994tv3+INDcE6zs3SLcXLuq022GJSwmDFTUIbp0r5/gUTHxImB
         AeTldyKDlHW8yA4Y4athGifCHZUW5eInuIS/dJI4KbZmYx5/1cwuGEp2ZtwkNJO1cUZG
         /79oGU/ew5dOOUT1MdppsyGCkaAQnNvvuQLyx32CONUDD6Gw+LgKMqTm/rvAnPtwWrc2
         lZ0VHi/rtBY99xPPqy+HvqxGeOzRXxXvM5YXd0SgvbDwpvZoz1xjmPc+bqG51UIBu+1i
         ijBorsf4YoOnyM+A1Y/H7B0m8z1s/UtBhuafPkhwTRpNjE2cpUI6btJfTpE/BwltRL+w
         MjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bFeVd3y76f8JCnVoxv7uErhjRJ/Acf3IGCqwDe0vYzo=;
        b=GKUTSGWRAUgprAZKvYAxWfJJ9vci1S+qXvGNAQIK4n88cHPKOXrzePvaaAZmXgRpBs
         CN0HIZgkIudSq/fJJmenHfvraCdhUt36vuBQJYbIdiWeiy9M5dUmVJNz79RcIejFulDy
         KfuA+2t6ANwavTHdpOcf+V4bNMNw1MAHHI7EkvWgoViL2PZ2Eu1PCZuw7tJ5ps2+5hr3
         DmXFC+buMOCgRDwJMm6lFNqYHErqPPGP/ThY4Jhi8X2VlJ8n68AP+tqf4SP4mx6LcncS
         nuSMGOiSYcqtCr3Gtn/si0be6ZWyUcG44aBGlwzKfDu2CYiGtF4zuYZbx6i8BtBs9trg
         pttg==
X-Gm-Message-State: AOAM531BwQAHCwG1B0nbkf5+D1g+BUYFeJPyWc64RQ9aZOLDFkWK1qAm
        p92gIGh7WBBMT/ftgnvmbUWSJZVVUtY=
X-Google-Smtp-Source: ABdhPJwptDnJe4CUd3jREwjgLVQaaP6WY676T+Tlsou+GFhr1kWQhjvUYUyk9XPHFR72Jg+REhSRdw==
X-Received: by 2002:a05:6000:1204:: with SMTP id e4mr613648wrx.95.1598606067682;
        Fri, 28 Aug 2020 02:14:27 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.241.197])
        by smtp.gmail.com with ESMTPSA id p1sm2713000wma.0.2020.08.28.02.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 02:14:27 -0700 (PDT)
Subject: Re: [PATCH nf-next v3 0/3] Netfilter egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Lukas Wunner <lukas@wunner.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
References: <cover.1598517739.git.lukas@wunner.de>
 <454130d7-7256-838d-515e-c7340892278c@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a9006cf7-f4ba-81b1-fca1-fd2e97939fdc@gmail.com>
Date:   Fri, 28 Aug 2020 11:14:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <454130d7-7256-838d-515e-c7340892278c@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/28/20 12:14 AM, Daniel Borkmann wrote:
> Hi Lukas,
> 
> On 8/27/20 10:55 AM, Lukas Wunner wrote:
>> Introduce a netfilter egress hook to allow filtering outbound AF_PACKETs
>> such as DHCP and to prepare for in-kernel NAT64/NAT46.
> 
> Thinking more about this, how will this allow to sufficiently filter AF_PACKET?
> It won't. Any AF_PACKET application can freely set PACKET_QDISC_BYPASS without
> additional privileges and then dev_queue_xmit() is being bypassed in the host ns.
> This is therefore ineffective and not sufficient. (From container side these can
> be caught w/ host veth on ingress, but not in host ns, of course, so hook won't
> be invoked.)


Presumably dev_direct_xmit() could be augmented to support the hook.

dev_direct_xmit() (packet_direct_xmit()) was introduced to bypass qdisc,
not to bypass everything.



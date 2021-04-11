Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65735B648
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 19:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235912AbhDKRKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 13:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhDKRKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 13:10:00 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F80C061574;
        Sun, 11 Apr 2021 10:09:43 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id g17so13615667ejp.8;
        Sun, 11 Apr 2021 10:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=j7eeW8Td9aQfzqbR8ADQIgvWqVyzKdJi0watzeQLsYs=;
        b=jAKcmJBYnhwYxlJ3k0oSym9GixbrzPT1rVgsai8E2ikmRhHBdEevWHI08Yy5SCusBs
         DTdUrVLTpWiIqlBgWMrq1bXA46y+UeHOF8O+Q13K869XEleTOWT2K9cIy6YBzlcMSBPY
         lD8yRv3hI1TmezNbJVHZtoFU2yWkwJqX47z3M3OdyH/bTpdnCwI0rxzeI/h+kJrDW0WZ
         Ni8AFli5VMN3HMQbIygfbqzEFz8ym01CwvcObByNLAFgHma0/0RV0fHr2OQijm+Cer/B
         HJsSwH+zK2sTj58RneHugy+jcM0f6MlkeubGJ2rg6jSp+Sn754ZQP2a9HCD4Y0YqN1PT
         Qj/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=j7eeW8Td9aQfzqbR8ADQIgvWqVyzKdJi0watzeQLsYs=;
        b=KvIYhgXSXMBTtWQ4Zs9WCJnlU0oL2xMZ87YU4EDoIpiHNDWbPKgoGBi778cjRkVZYD
         tBEYGM7X1C28XX5UBGg5JdN+rd6PG7BbI6D39h6s63rINVnHbnUNv3XR9HPMG/JU+kA/
         bil3G91AaYoQ4MgWd5RwjyL7rKurU45GzpXcTamkI8Y/Szvxo3k0akpZaB63JvvpNOty
         G4TQf5TLYYpK4kENWyMHvItwSEcn1xu91mpmGPzjtVfbH2HAnkddOJ0droM+2SkkFpHk
         FLfNBcJycNWMKEmaNno5mqGTKdcxH4Gxs21bvPjU5TEJFW2Uit093hX5tVDVn+n1JaaJ
         hW0w==
X-Gm-Message-State: AOAM5332bQ0UaIqF050s2QdX4qQVI1Sx7vw2Hl1MDwvITa5kjzYwfV/y
        fhITD51Lc3OYY3wCHVNqwic=
X-Google-Smtp-Source: ABdhPJxWECeNg+pZm8i/EDrIRFFuryTzm8M52GKn3iUu8WLfOUC2Q+Dlvv0Os5hkDMJtDU35MtOfVQ==
X-Received: by 2002:a17:906:9501:: with SMTP id u1mr23999655ejx.324.1618160982112;
        Sun, 11 Apr 2021 10:09:42 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id c89sm5093757edd.9.2021.04.11.10.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 10:09:41 -0700 (PDT)
Date:   Sun, 11 Apr 2021 20:09:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Di Zhu <zhudi21@huawei.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC iproute2-next] iplink: allow to change iplink value
Message-ID: <20210411170939.cxmva5vdcpqu4bmi@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210410133454.4768-5-ansuelsmth@gmail.com>
 <20210411100411.6d16e51d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210411100411.6d16e51d@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 10:04:11AM -0700, Stephen Hemminger wrote:
> On Sat, 10 Apr 2021 15:34:50 +0200
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Allow to change the interface to which a given interface is linked to.
> > This is useful in the case of multi-CPU port DSA, for changing the CPU
> > port of a given user port.
> > 
> > Signed-off-by: Marek Behún <marek.behun@nic.cz>
> > Cc: David Ahern <dsahern@gmail.com>
> > Cc: Stephen Hemminger <stephen@networkplumber.org>
> 
> This may work for DSA but it won't work for all the device types vlan/macsec/... that
> now use the link attribute.  It looks like the change link handling for those
> device types just ignores the link attribute (maybe ok). But before supporting this
> as an API, it would be better if all the other drivers that use IFLA_LINK
> had error checks in their change link handling.
> 
> Please add error checks in kernel first.

Would it be better to expose this as a netlink attribute specific to
DSA, instead of iflink which as you point out has uses for other virtual
interfaces like veth, and the semantics there are not quite the same?

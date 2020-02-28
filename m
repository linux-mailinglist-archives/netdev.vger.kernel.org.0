Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7324217419C
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgB1VrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:47:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35758 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgB1VrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:47:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id i19so2383179pfa.2
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okh/E+IxqroHYWUgG/V6OdIYz06xGNRkAT5AiFwava4=;
        b=zFG0VzEJFaXI8H8fHpLARNibvSF3lWx+TdvLB+e0ORyfyBn5EHd11N5FCfKQ1fybTp
         aUFCkqHAwsFkhkH+shlNwx4JMN1qU7a6MwgloTOo4RIlfwLzjONkE5H6pJvqh1PtIVPI
         r5n4BGYitO9vTJ1OPz0qGW4pj7KWojMJe+NfbLAihQk4zp5z92sHj2izXkpjW01QEdh7
         epmGqjFaegVMetZKLB2ZCqSm/mZALR27jccXTCdxUWxfdBCMZJqgMbk1ZOt29iH+ZZPK
         RV2UIUSk2iLwsHEFEor6DmkD83w+VGRMmiERl8+Xm0bjMGm3ib+a9N0yVjyExJL6it4j
         m9cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okh/E+IxqroHYWUgG/V6OdIYz06xGNRkAT5AiFwava4=;
        b=dupBsrPP4OaX7B9S+c5ADvGXO//IY4NFNWMOtpro0WlGKAcSYtruD1kxr2UOeoskFu
         Jb0wPVdsIxcivWklEf6q9jLjpAGk3SiPZg0zcM1C8pRD0vg2jfS/sBt6D580CaPn1wX0
         4+LYmjVqds7N/NBXnqnn+gpev1ajxfZjo5dh/Iz8Nd2ZZehopNGDuTB8QAITzx/rRuPI
         eF9gELPcfXtvuftMQ/oUJHvZni+m0BbiW2QgSCKn5oHFlwkJveUdbJsUuN3ar2YvpeMr
         CqeMSQyWOcBAuffW5zvdoVJRgLO1mor2fAz0P7Bmhe8u4P+Cj0g9TiMdPxNq3kg/pqOV
         iGsQ==
X-Gm-Message-State: APjAAAVmIYj3Pve5xqHoPBXu5XSd5Fv9Ot2CxbsPtnA5zjb9uZfWP0ym
        GHIlC6Oo6qwLz2O9S695ppKnXF5g2yw=
X-Google-Smtp-Source: APXvYqx6bf9PI70z+MlcbOA3cpNCY5tZRGQNJNFbdUmEhpE29jq+eFBV+5+uW3p0FJDZhmGh9Z3qig==
X-Received: by 2002:a63:4763:: with SMTP id w35mr6738863pgk.113.1582926430413;
        Fri, 28 Feb 2020 13:47:10 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w184sm10820737pgw.84.2020.02.28.13.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:47:10 -0800 (PST)
Date:   Fri, 28 Feb 2020 13:47:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Donald Sharp <sharpd@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH] ip route: Do not imply pref and ttl-propagate are per
 nexthop
Message-ID: <20200228134706.38c873cf@hermes.lan>
In-Reply-To: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
References: <20200225131213.2709230-1-sharpd@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 08:12:13 -0500
Donald Sharp <sharpd@cumulusnetworks.com> wrote:

> Currently `ip -6 route show` gives us this output:
> 
> sharpd@eva ~/i/ip (master)> ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1 pref medium
> 
> Displaying `pref medium` as the last bit of output implies
> that the RTA_PREF is a per nexthop value, when it is infact
> a per route piece of data.
> 
> Change the output to display RTA_PREF and RTA_TTL_PROPAGATE
> before the RTA_MULTIPATH data is shown:
> 
> sharpd@eva ~/i/ip (master)> ./ip -6 route show
> ::1 dev lo proto kernel metric 256 pref medium
> 4:5::6:7 nhid 18 proto static metric 20 pref medium
>         nexthop via fe80::99 dev enp39s0 weight 1
>         nexthop via fe80::44 dev enp39s0 weight 1
> 
> Signed-off-by: Donald Sharp <sharpd@cumulusnetworks.com>

Looks good applied

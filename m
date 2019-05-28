Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD552CF7B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfE1T21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:28:27 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41924 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfE1T21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:28:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id q17so7247826pfq.8
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 12:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BcED/+bBUPI/ra+tiG0FgPuHeGEZGzHs6gwwlQ/TpNM=;
        b=MUN0Z4jtA8BrMc4IQtpV7aFpeAc7M8L8+glvn8zgHJBLjoCRyxxbwivq8QeCDeyvZK
         dA12veMpYrF81dcP0q951um4qcnKmbJjxhxN8oQjdx4Tc6dKH+gjGmYRITIV8Lxp5IPx
         i5pCdp9EQp6Jr1sn0ePbcLwlAfbUfv96IFYwMKkLvB2llN8yvVhxAEdaHzzrxqFwiTwm
         uRaT0AAIctR4NSRzLaRPr0DXw1ghYTSaQ5Htp4j2Z4h9xCmYGWx0Lo6jibivWwXi3+Yf
         G0A+rmEOsFzHkefHSjiwvmF5+rHh7WiLDEVMhF4/hAxzZE1EbuO1mIXvPdOp1oMpLRju
         nziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BcED/+bBUPI/ra+tiG0FgPuHeGEZGzHs6gwwlQ/TpNM=;
        b=WPubiwGUJMxxZhDq/RWtl+3WX52P8vcPZtAq6HD4P/IV53oM1WMBG04r84a+7Xn1NM
         vl5nfCRCcN427tfKqHi+9RI8qWa2rFBKtbcmROqRjMpv0z5yXJ0BPjnApokETXxzuXEO
         vvjFk7VOjCZooX3xIRQXos3KlnYUda8ClqLeunGgM7D+M14i41BAyXUcwJpFjAkvZy6n
         QW8XFqMFcfzVobU7H61+2/77W74K54P25SzbE5/z7mhWxqWj9DUZoypBn23YLxtn6NXj
         CoLNmfRuxCpbeEapTSMdj1ChnGfZUYjuuBumafYkt/XhoSlTGBaEfo6agmPkI3/2ZFXw
         XbkQ==
X-Gm-Message-State: APjAAAUk1VUNAaN7dTHtaxKYATFVJBpcjqEC7qJzLdtHCQMm+LdVFHWg
        JpCc3p4cC1xKQrxsUZ0cpRV+wFgpSEI=
X-Google-Smtp-Source: APXvYqwOwVGUDdjLRn3MUVA1uf7BioQRC2/2OOnfYuIWb++oaSgb+gMn7rjcggS69jMXNfqdDpg8bA==
X-Received: by 2002:a65:654f:: with SMTP id a15mr117797018pgw.73.1559071706825;
        Tue, 28 May 2019 12:28:26 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id h71sm4135335pje.11.2019.05.28.12.28.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 May 2019 12:28:26 -0700 (PDT)
Date:   Tue, 28 May 2019 12:28:24 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Lukasz Czapnik <lukasz.czapnik@gmail.com>
Cc:     netdev@vger.kernel.org, Lukasz Czapnik <lukasz.czapnik@intel.com>
Subject: Re: [PATCH] tc: flower: fix port value truncation
Message-ID: <20190528122824.3ce628d3@hermes.lan>
In-Reply-To: <20190527210349.31833-1-lukasz.czapnik@gmail.com>
References: <20190527210349.31833-1-lukasz.czapnik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 23:03:49 +0200
Lukasz Czapnik <lukasz.czapnik@gmail.com> wrote:

> sscanf truncates read port values silently without any error. As sscanf
> man says:
> (...) sscanf() conform to C89 and C99 and POSIX.1-2001. These standards
> do not specify the ERANGE error.
> 
> Replace sscanf with safer get_be16 that returns error when value is out
> of range.
> 
> Example:
> tc filter add dev eth0 protocol ip parent ffff: prio 1 flower ip_proto
> tcp dst_port 70000 hw_tc 1
> 
> Would result in filter for port 4464 without any warning.
> 
> Fixes: 8930840e678b ("tc: flower: Classify packets based port ranges")
> Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>

Looks good, applied.



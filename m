Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3191BEFDD
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 07:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgD3Fke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 01:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726391AbgD3Fkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 01:40:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D034AC035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:40:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s10so1854021plr.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 22:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5J1OkvDsLr8Fy5vJwRUFdmJXDXHzem9KftSuzNmZBoU=;
        b=aeiOMw5WbcEonXjLVNUUrY8Vgx/nxD8MkoJ52+wxu2Ee8fIyedXheHJlPyqtd4NTcb
         ZFPrz+c9yLuTwtqFB6LABtFc6gl+f0wgftxjD2tOErqzZ0V7ExscIgOKJ+H+8vnm3NaX
         qwVJ9JEXyovOFoi0ViO82J7wzRw6abi4Q5IsMJy/lurvLjXWTrShHDxQ5cIVLWCTusN3
         7DceTGEYIjteGsTCTmfU59aEdHCDZXHTmm7aYs05oKcwLc6DFniowK8yldBjF8CUYm2w
         o4rzf9EnE/mNu2AWwhQ4DOpNoPWHUdDtseBSQQuoqxhze7dgudqrqHnTF2z1lGwTujgw
         4xIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5J1OkvDsLr8Fy5vJwRUFdmJXDXHzem9KftSuzNmZBoU=;
        b=SgLdnAv5tMXr0p12jlRxZuTXK/u5TTSSA4RIsaUZNltCypcQnb8+NavbCrJrY1ELwa
         EYbCAdFwy5h5h2+eCBRq1rvNoq5vZouhWft4IT+wP6ejALYNS/jNzW4LDiHkiz9EQHOl
         nFg1Py0bRsMXVL6+0IpMSIn/abgQ6sBjAu2lVT9qs0YDnQRb5ND5tmhiK72S3wcDZgNO
         piqAvqGhBJpmAY6MdBn1vcyC0zN3yroHOz97R0YH9lnRmytecB8ZmXzfG9wjHZxd3QKX
         nfP0/mkDqivqIr308T44pkGflbjQaFhxUEsJu1/yAMdQ0L4T6gVJWQqr8DH6nPE3iBpm
         mLyA==
X-Gm-Message-State: AGi0PuZreh+KYMRULMRJfaEyn0MBfrDawJXilr9z3XyVArhiWZa/yCbF
        jyRORjyVTr7IXYJnc400DCVn1g==
X-Google-Smtp-Source: APiQypKYFpOFIGSDtZCafLXQTmuY+9YK0xxMLnBnxb5A9Eu/4JGh6hWOCCH8uUD/YVTlD8S7e+tRRA==
X-Received: by 2002:a17:90b:3115:: with SMTP id gc21mr955483pjb.183.1588225233243;
        Wed, 29 Apr 2020 22:40:33 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q19sm2486345pfh.34.2020.04.29.22.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 22:40:32 -0700 (PDT)
Date:   Wed, 29 Apr 2020 22:40:30 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org,
        Jamal Hadi Salim <hadi@mojatatu.com>
Subject: Re: [PATCH iproute2 v2 0/2] bpf: memory access fixes
Message-ID: <20200429224030.736d655a@hermes.lan>
In-Reply-To: <20200422102808.9197-1-jhs@emojatatu.com>
References: <20200422102808.9197-1-jhs@emojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020 06:28:06 -0400
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> From: Jamal Hadi Salim <hadi@mojatatu.com>
> 
> Changes from V1:
>  1) use snprintf instead of sprintf and fix corresponding error message.
>  Caught-by: Dominique Martinet <asmadeus@codewreck.org>
>  2) Fix memory leak and extraneous free() in error path
> 
> Jamal Hadi Salim (2):
>   bpf: Fix segfault when custom pinning is used
>   bpf: Fix mem leak and extraneous free() in error path
> 
>  lib/bpf.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 

Would be good to see a v3 and ideally ACK's from of the
other BPF developers such as Daniel Borkmann
or Jakub Kiciniski


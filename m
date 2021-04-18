Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4401F363709
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 19:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhDRRlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 13:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhDRRlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 13:41:01 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65214C06174A
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:40:33 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id r186so5492816oif.8
        for <netdev@vger.kernel.org>; Sun, 18 Apr 2021 10:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xnNR9E7qt8VWICLomDSoy45n/IXm/mRs/1a14UIIcdY=;
        b=HU7gIdoLEqDGUdbPSz0noBR0aVD0cyzoIWFZ7H5CdmePAP0I/U8MpCwUIEjma/4Qhz
         FWX2WNKV/iPrQ5CIYYP1dKW+nXDRAecAiSgzGznHpZ1VKlLsJqipJctFbKGXeIcBObpC
         oCEuYV2SgJACcUYIWLVTpPZgcS6ug4YcTj8FMWjOGEKUYo+Y+37QKomClw6XUp4usc+s
         WYl+P68QzkUwXX9XpbRPxcVX3AgiPHlrhvCV1IgnDHRVVCVhUW9xX1xTUxkXnQDkjAkd
         ujGZikECmKhCs0sSPqZlsRWScWr+6icCzZUzyKhWg07BtwZQApCpTC7n9yHuEILQayre
         1wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xnNR9E7qt8VWICLomDSoy45n/IXm/mRs/1a14UIIcdY=;
        b=tjZW46jDOMZoncaRkdEAS+jUTKl55c4ohSzcCkntAPNrSUitW3I6gUqmP7MH6PfCk7
         ppIm/xYaVaI/r1ZT5XIQdug2pJaGOhXvYLVIW/GpYrul4creGYfkNLBdLhj8fi13gOhE
         +h5gdsNgGNHm4a6k5HzryqviRfu5rjAVDkSGNI1jszaqj6TEIMTO0twD4Q8htw0kK7wK
         VfEiKPPa/tmb8y2B3nG9MB5UAVbkad5eeNlWg1CH7nh2RwrGcFy5jaj1w/gtiatjYvTp
         ISYgMYz6KyGhxp8tojdpRVq2r2Ce02iHk/YHxCJrRax8S27+0Ad504PBoKqNpj2aJbo+
         Ov8Q==
X-Gm-Message-State: AOAM530Zha/FuGNKCqmiUcEskPxEwkaEisglwhn5/UAIJMq7KAqD55zi
        Ettghp1e7hvZ6Idh8wsYFeZS6Nh7HZI=
X-Google-Smtp-Source: ABdhPJxvim3LD/c4+MQxZ6ATQZwMr2V3VfKizMbl3rec00Jchkye9nec1J7pkXtkt1sBujCcsKuKXA==
X-Received: by 2002:aca:3788:: with SMTP id e130mr12902593oia.45.1618767632728;
        Sun, 18 Apr 2021 10:40:32 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.41.12])
        by smtp.googlemail.com with ESMTPSA id h17sm2832324otj.38.2021.04.18.10.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 10:40:32 -0700 (PDT)
Subject: Re: Different behavior wrt VRF and no VRF - packet Tx
To:     Bala Sajja <bssajja@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAE_QS3ccJB8GqVrJ_95P7K=NmXC0TP_NyoAiVbTqhk09JRodrA@mail.gmail.com>
 <e73269cc-1530-5749-0b62-f30b742217e1@gmail.com>
 <CAE_QS3fP_CysCvwtTxu=1PPRZevFwBPjFpyq6M+NtZ_CrOkZhw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <82104ae2-b687-94fb-80b5-5cd91f5fef41@gmail.com>
Date:   Sun, 18 Apr 2021 10:40:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <CAE_QS3fP_CysCvwtTxu=1PPRZevFwBPjFpyq6M+NtZ_CrOkZhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 8:57 PM, Bala Sajja wrote:
>        please find the ip link show output(for ifindex) and ping and
> its corresponding perf fib events output. OIF seems MGMT(ifindex 5)
> always, not enslaved  interfaces ?

that is the reason it does not work.

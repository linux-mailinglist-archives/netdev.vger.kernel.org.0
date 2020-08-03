Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134A823A780
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgHCNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHCNcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 09:32:52 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D828C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 06:32:52 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id w9so28135335qts.6
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 06:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TrzfKFWrqonVAodS9SHcefk8HofmhSvW71qt8kR88FA=;
        b=PwZ8mh2NvGUVvgYTYkJ1ZgFP7aMOSWf93VXYi07/AFssOSlfZHl3V+387uJVUE4mtN
         P4RZRSV2EbrpqvbIcLu4ZZWDj8LSUqZEjFwBFU0VwqSiVyKxQwWhYXXov7fy+nDQj/nP
         /U2bJHcA0fMk3/1E7YOVFoMvaXk5UKaqwZWKK8XZHI6qDdDak8Nbsh3/zMcc3ABVSh8D
         2TlBkZYGIBYZjXcMeX6aSx+/NST8gS0QB2Tsi7GNwdl20UnOUvVhY5qkHFRrxR+dNmq4
         6R2UoQ+nVIzChO64821fmEEBdjszs+U9w4tLNUQkxZBgljhiJw83lZprlWquW9YfdEmu
         hPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TrzfKFWrqonVAodS9SHcefk8HofmhSvW71qt8kR88FA=;
        b=kLtpPvcCLGDF86iNIRVP1sHL5fxSHhQVFGXBk/ai8DuytgIgweJWVtd+mT3Swk3VBb
         CxnLapD1cHGi+OmjAuNs3tucLUE/CSQTSP5q97cf8H1FOj19EdnRJBY+DtMqyzYJ3iAV
         3Mw5/4QjcpPLDWE4AD3BV63Qytxp/nKvKAuKL8xjvuRRf+87naDhEEXzpsZmKIuavT+2
         8NIDubDhhWCM9eh3yN8zNwdjyBXL0E4F95iNBmTBh0MvZKavvzdnyTDTFwK4DX10wJK8
         d1ZOlY94J3i4f8l5nUYziAnqcMp2WiAN3pOvPNca9Brj08aYazS8o9v0aUDu56eBkSRo
         fJsQ==
X-Gm-Message-State: AOAM5322VKT5rlB+8ULBmTMJ5fDw1WU2aCE1fS2Ln5uCPNDja8sqMFbX
        dl85QRFhP6B6IMafdgLWv+tbF8DI
X-Google-Smtp-Source: ABdhPJws3pFjuZQnabnelWM/Sx/yQcjddTNKabirVknl60qkP44K0IvsjNNPe1g9XhOVazhj2QODuQ==
X-Received: by 2002:ac8:47c8:: with SMTP id d8mr15494022qtr.32.1596461571003;
        Mon, 03 Aug 2020 06:32:51 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id q7sm4067965qkf.35.2020.08.03.06.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 06:32:49 -0700 (PDT)
Subject: Re: PMTUD broken inside network namespace with multipath routing
To:     mastertheknife <mastertheknife@gmail.com>, netdev@vger.kernel.org
References: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c508eeba-c62d-e4d9-98e2-333c76c90161@gmail.com>
Date:   Mon, 3 Aug 2020 07:32:48 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANXY5y+iuzMg+4UdkPJW_Efun30KAPL1+h2S7HeSPp4zOrVC7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/3/20 5:14 AM, mastertheknife wrote:
> What seems to be happening, is that when multipath routing is used
> inside LXC (or any network namespace), the kernel doesn't generate a
> routing exception to force the lower MTU.
> I believe this is a bug inside the kernel.
> 

Known problem. Original message can take path 1 and ICMP message can
path 2. The exception is then created on the wrong path.

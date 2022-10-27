Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7E060F2D3
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiJ0Ir1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiJ0IrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:47:17 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552896565;
        Thu, 27 Oct 2022 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Cc:To:From:Date:Message-ID;
        bh=c91ZA6UyAnjSnGuYSqvGMyiTSv2BODQBStlLpswDA3c=; b=Bc8wcLBbsL+7AsjKbKYU9RFCf8
        3bmrOjyZsvSr01/ZYcNvSei6sTHEkj3gjUCCnUUszPwgcxlbAhK+WJgAa8zpvq4UOcZMIj6MU4j0P
        0qckpKmYM+YieqAXeyCXAtayE+P2q8TwWYxcRwrOCAD+gbwYknzRFlQWBYdUAksRgSFUA3tnijTld
        GLw264FDPM9MrV9ZrknSUKJwwC7ZCx0vGfDMSMLOReaQAoF/cbLkxeouk4+wK8TMvjXLtVoYWKOfr
        Xb5gIW9vrCuuG5WBpi5H/iyiBp0M/EptiOrcUuoy1yl00JRZk6Ghnw+5O2Hrvt8Fm4q1i8eBPMVr7
        4s33Io+rQ5Np6G1krL44WBdDkrVZqouxGwlhtRRaDjwEklK4aWtA/RhZ8kOdrTm3/kkUrCbDItkSP
        XlmeOm9tEQ6sOVFqCn/66KSYyUCxHORACxTekETe12PVN+0IaS4uMTMJkY60Mx2p4rp7Dg/NZEMZu
        uSoz+Xu0htS9ffhjA9r9zelk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1onyXh-0060NS-Hw; Thu, 27 Oct 2022 08:47:13 +0000
Message-ID: <678e490a-e876-47d2-e308-5a8f140774f8@samba.org>
Date:   Thu, 27 Oct 2022 10:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
 <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
 <e87610a6-27a6-6175-1c66-a8dcdc4c14cb@samba.org>
 <c7505b91-16c3-8f83-9782-a520e8b0f484@gmail.com>
 <3e56c92b-567c-7bb4-2644-dc1ad1d8c3ae@samba.org>
 <273f154a-4cbd-2412-d056-a31fab5368d3@gmail.com>
 <11755fdb-4a28-0ea5-89a4-d51b2715f8c2@samba.org>
In-Reply-To: <11755fdb-4a28-0ea5-89a4-d51b2715f8c2@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pavel,

>> Ala a IORING_SEND_* flag? Yes please.
>>
>> *_REPORT_USAGE was fine but I'd make it IORING_SEND_ZC_REPORT_USAGE.
>> And can be extended if there is more info needed in the future.
>>
>> And I don't mind using a bit in cqe->res, makes cflags less polluted.
> 
> So no worries about the delayed/skip sendmsg completion anymore?
> 
> Should I define it like this, ok?
> 
> #define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
> 
> See the full patch below...

Apart from still having IORING_SEND_NOTIF_REPORT_USAGE
in the comment... (which I'll fix...)

Is this now fine for you? Then I would post a real patch.

Thanks!
metze


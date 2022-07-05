Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438DD5677A3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbiGETS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiGETSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:18:52 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0232D1EC47
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 12:18:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d2so23366030ejy.1
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 12:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0jeOfSGVmlpdobtAYmIqEz5JreQNzmFZc6feB0KVWgI=;
        b=aO3u4iXt41Ff/FLo/scWphT2iYOzus6ra2oHCcWVfrPYefkCWggF9vwUrJ+vV2J5Ut
         HwAFspjdm7IXTxWRT0sVPHy7ZJRRmzQMjFjdAxa80AnmyvzR4g2j+6bdeq/eKiJUhBKe
         FO1ZPB63PrtlZcZRqiqk/Kc1G80wagVirmyIYICPCvMPRWLYAJ+KOjdqs1rbLzRbI+9R
         v86WOPNRJul29jJxCDovoXWtIby4UHKa2I/x+zpOebIgD3ICBmOaey9W8OS6aGew5Vm0
         +LOmd5fiKq0ND6tnguwIlXZC3vNC/inMHAbJLCmOqZkuxSvhTrvX+J1EM5KVXwD8VFve
         3mUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0jeOfSGVmlpdobtAYmIqEz5JreQNzmFZc6feB0KVWgI=;
        b=wXK1mGxwchfdQgrcERyClKpVaUOlkg0GT3apbHjarKWULYoMDSLN1CHKHopMTarWKF
         T2C2p2XLiCDNP+wtcsjXD96tOAf0LrxmRWSJ92x5LVL4ovc9UxscojqqbU3rX8fmsTaW
         +ql5AOCuFY09v89Ey40eVXHjVj+p7zN7oXYvRBWcTFRvqvUza2p20Ix9I6PRu/WTAL92
         kckqD1ixSBOfYFWVJRABxJDlwdKBPypWq9GDl8psoqaDr1+ZO4FmsWzy3t9WOxFzZTsA
         JMam4gZIx5l1yy6bHDikZCZF3i04/aRmpp4ITBKXgn2XNajAOF6RJHIBzGgA2tQWjwU9
         6uzg==
X-Gm-Message-State: AJIora9snv8MH205PnAatv3d8gfYOLk4QeMEvQleX9zMIZqM/1i7jOW8
        s0p+z3Zlhb1hEvsp39zVCIVq+JHZ57I=
X-Google-Smtp-Source: AGRyM1tBhBDj7/pjdQsC7PE5GnJYx4SRqfUbMAlh7dSDpq5o4Yjeu9RzHJlu0E/nCabtm+KaZIkgeQ==
X-Received: by 2002:a17:906:9b93:b0:722:f3e8:3f5e with SMTP id dd19-20020a1709069b9300b00722f3e83f5emr35687927ejc.65.1657048729598;
        Tue, 05 Jul 2022 12:18:49 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b67:e500:f0a2:195e:b254:a6a7? (dynamic-2a01-0c22-7b67-e500-f0a2-195e-b254-a6a7.c22.pool.telefonica.de. [2a01:c22:7b67:e500:f0a2:195e:b254:a6a7])
        by smtp.googlemail.com with ESMTPSA id q14-20020a1709066ace00b00722e603c39asm16208189ejs.31.2022.07.05.12.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 12:18:49 -0700 (PDT)
Message-ID: <1ca36910-31c0-ead6-d19e-c200eff752b4@gmail.com>
Date:   Tue, 5 Jul 2022 21:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F.\"" <erhard_f@mailbox.org>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
 <1670430b92ef3cbda6647ce249a6bafb9d243432.camel@redhat.com>
 <20220705121230.69a4e0e8@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20220705121230.69a4e0e8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.07.2022 21:12, Jakub Kicinski wrote:
> On Tue, 05 Jul 2022 14:46:14 +0200 Paolo Abeni wrote:
>> On Mon, 2022-07-04 at 00:12 +0200, Heiner Kallweit wrote:
>>> 66e4c8d95008 ("net: warn if transport header was not set") added
>>> a check that triggers a warning in r8169, see [0].
>>>
>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=216157
>>>
>>> Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
>>> Reported-by: Erhard F. <erhard_f@mailbox.org>
>>> Tested-by: Erhard F. <erhard_f@mailbox.org>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>  
>>
>> The patch LGTM, but I think you could mention in the commit message
>> that the bug was [likely] introduced with commit bdfa4ed68187 ("r8169:
>> use Giant Send"), but this change applies only on top of the commit
>> specified by the fixes tag - just to help stable teams.
> 
> How about we put Eric's patch under Fixes? The patch is not really
> needed unless the warning is there.

This would also be an option. It just seemed a little illogical to me
to leave the impression a new (useful) warning needs to be fixed.
Just a few seconds ago I sent a v2 following Paolo's proposal.

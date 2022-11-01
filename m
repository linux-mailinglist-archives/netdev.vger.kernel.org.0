Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255C1614AD4
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbiKAMhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKAMhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:37:08 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8EC17E18;
        Tue,  1 Nov 2022 05:37:06 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d24so13434872pls.4;
        Tue, 01 Nov 2022 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8UQRCroGbZvbN/wuUnBp7fR9SFQ4noJrL6f95B344r4=;
        b=iUPjFvfRCMd9oZmwbhRbchTuwGz+6E4LppQmC0lCfLz0W+6p0HAQftLD46X+yagFjO
         xDWodmuRkU5H8sJPGVgw1lrPEmv2s9wvaBGVPgz3B3UWOg0G2s3VF5XDg0GyORvsOwWw
         PGMbX2GmfW77RO48f6hD9EelrjAejhtiSahHqZpJ8Lvm7mHsSh+GPUP2ODbryRJWcjmy
         NjI9mgiaT4s+oEQeuurZYZakyCuOGbBa37TyY6MWdfOLdVMXWQfVVPtwpTYZFzTxxQ/k
         SBZfj8ZaNFF+96QaY/fO1g6P/o6W7jouyb9ec4IZe12MrXbavJWSrMCv4hDBK+/adjW+
         sEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8UQRCroGbZvbN/wuUnBp7fR9SFQ4noJrL6f95B344r4=;
        b=owu5oQLWlYyxnaGH0oVCkC6kR/MDY1mXY0XHR5HmZT3S4b6v2Ykr3CVLtugtpI01fM
         tbdUQ8i67+pFGvL2glIlUCkwkWAsEXj9+Fk37pcA61Ckt63bzVg6MrjyiP66hPFdc1/o
         WrR0YQXlM3BjRQYyK3dvRI5hIoycjpEIu/06Dmrek4Po1qDMreeNiutxQ3ssgLrpU36/
         0YKGZDhWga5qJOEPtWUmcdETS9cP7lfE5fTXJbXlZ3NP9ZbfSDABAzF60gmjfZ0JPOjP
         7FtC6NM57o0Wa32JEgqc677ahFuhSJO6CVuhhMJUbmE7nRMK/aWOn6Yf2Mm2G7WuTGhc
         yOyA==
X-Gm-Message-State: ACrzQf3wQorivk8Xm4mGgo1Y3SzvdMeu3NoVYDwU8IKMQxPwE+/Jdo3I
        UTqM2d42Faa9TWIQCgmnptcDMwe89nMPhg==
X-Google-Smtp-Source: AMsMyM70cze/4h3TWE9CjuViil/KQGdba4o1DJXGYi+5hz++/FOHtA5sn+T4Brv7I4+qd79x+Ii8wg==
X-Received: by 2002:a17:90a:d586:b0:213:de8f:4d6 with SMTP id v6-20020a17090ad58600b00213de8f04d6mr11447129pju.31.1667306225915;
        Tue, 01 Nov 2022 05:37:05 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id x9-20020a628609000000b00563ce1905f4sm6451631pfd.5.2022.11.01.05.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 05:37:05 -0700 (PDT)
Message-ID: <83d70f8f-419c-2eb9-5130-782750772868@gmail.com>
Date:   Tue, 1 Nov 2022 19:36:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] can: rcar_canfd: rcar_canfd_handle_global_receive(): fix
 IRQ storm on global FIFO receive
Content-Language: en-US
To:     Biju Das <biju.das.jz@bp.renesas.com>, Pavel Machek <pavel@denx.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20221031143317.938785-1-biju.das.jz@bp.renesas.com>
 <20221101074351.GA8310@amd>
 <OS0PR01MB59222BA2B1CAA6CDA9B4137486369@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <OS0PR01MB59222BA2B1CAA6CDA9B4137486369@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/22 14:59, Biju Das wrote:
>> I got 7 or so copies of this, with slightly different Cc: lines.
> 
> I followed option 1 mentioned in [1]
> > [1] https://www.kernel.org/doc/html/v5.10/process/stable-kernel-rules.html
> 
> 
>>
>> AFAICT this is supposed to be stable kernel submission. In such case,
>> I'd expect [PATCH 4.14, 4.19, 5.10] in the subject line, and original
>> sign-off block from the mainline patch.
> 
> OK. Maybe [1] needs updating.

The documentation says (in this case the third option applies):

> Send the patch, after verifying that it follows the above rules, to> stable@vger.kernel.org. You must note the upstream commit ID in the
> changelog of your submission, as well as the kernel version you wish
> it to be applied to.

It doesn't specify how to mark desired target branch, unfortunately.

> 
>>
>> OTOH if it has Fixes tag (and it does) or Cc: stable (it has both),
>> normally there's no need to do separate submission to stable, as Greg
>> handles these automatically?
> 
> I got merge conflict mails for 4.9, 4.14, 4.19, 5.4, 5.10 and 5.15 stable.
> I thought, I need to fix the conflicts and resend. Am I missing anything?? Please let me know.
> 

The upstream commit didn't apply cleanly to *all* stable branches due
to conflicts, right?

Thanks.

-- 
An old man doll... just what I always wanted! - Clara


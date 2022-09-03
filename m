Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2DD5ABFF5
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 19:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiICREC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 13:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiICREA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 13:04:00 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3304DF10
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 10:03:59 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r22so4590816pgm.5
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=gmBCLQNG7WrGAKb/r16NLEtU0bKN3g8wVXlxVPmef98=;
        b=bsg21BnZpt545//L26woVNZcFkxL4ytmbVE+EfyfIV+Xg6Aje5ZYQ/lI+uXgi2x5Bi
         r5DyXnn0QZiuFR+p0+dX52SLVt+SbR+Mdhia2Ttz8oggti54s2WJw3V3OUrCGaDXNx3Y
         qaqqKKx5xZ8g7I7ahrIUHGKv+wOj4srbnyo/9duCcxpuvIRF3u87xsnaPti9aX71uvMZ
         DqyfBLdLGT0P80SbSRSJt6Swpmye1J/qtxfC2WrR6YD4Q+8O8gnuoPGUTPAjFEETLa/d
         N10XkhRuIw33DcCwCibDvZFNdctxSPk9CsEb6MvMn/EwXZaQNuxhDdhL1ObizeWtbQXt
         i8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=gmBCLQNG7WrGAKb/r16NLEtU0bKN3g8wVXlxVPmef98=;
        b=vm1hVlHGKE9OdfsisC3vg+bUYXyPmivE4VKRyO/p33bhYuxJeK3y2wDlS+Viau68Hm
         7M+7wigOexaVbKqmN3i1ckgvBpBVVU63jIhfdcQi8Mf7i3zMbizh3Dos+SDu8ziwgaIv
         QMN+P8CXwekr5FRPuf/Rdu5tuIaRspIxvctfYTXTsGinLV8MOSQR9Gz+WlOfMpYL4jIh
         /Y8eVGPSlWv7caQyOiQVaV2JBFi7GhdF/bjqIIuZslRukcA2CW8RQUKdXhqYgbtrGgPN
         AIL2duxRe/JkHRB/znY8e6jnm7CrQzKrpPeqGt6Mrnl5qstNnUrk9UWm2Rasei1L37ku
         HZfw==
X-Gm-Message-State: ACgBeo3fodhlUCUxJikBLx/n7O+NcHNV0URWxTgWzuVY0Iuob8+j1l23
        8MbQIQTnIYNx926RBsoj9X+Vmg2tUYg=
X-Google-Smtp-Source: AA6agR7FXCeTHza7W89WYqkk4+e3THqj1fsY0d+0sHVe4P+oUv99AvXntGJGOnEl1C0JoyoCen733Q==
X-Received: by 2002:a63:b03:0:b0:429:c549:d1f1 with SMTP id 3-20020a630b03000000b00429c549d1f1mr36019509pgl.131.1662224638457;
        Sat, 03 Sep 2022 10:03:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q23-20020a170902bd9700b0016dbaf3ff2esm3939037pls.22.2022.09.03.10.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 10:03:58 -0700 (PDT)
Message-ID: <aa581b7f-8dbc-5b62-dfc9-a21f439ab80c@gmail.com>
Date:   Sat, 3 Sep 2022 10:03:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] tcp: fix early ETIMEDOUT after spurious non-SACK RTO
Content-Language: en-US
To:     Neal Cardwell <ncardwell.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Nagaraj Arankal <nagaraj.p.arankal@hpe.com>,
        Yuchung Cheng <ycheng@google.com>
References: <20220903121023.866900-1-ncardwell.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220903121023.866900-1-ncardwell.kernel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/3/22 05:10, Neal Cardwell wrote:
> From: Neal Cardwell <ncardwell@google.com>
>
> Fix a bug reported and analyzed by Nagaraj Arankal, where the handling
> of a spurious non-SACK RTO could cause a connection to fail to clear
> retrans_stamp, causing a later RTO to very prematurely time out the
> connection with ETIMEDOUT.
>
> Here is the buggy scenario, expanding upon Nagaraj Arankal's excellent
> report:
>
> (*1) Send one data packet on a non-SACK connection
>
> (*2) Because no ACK packet is received, the packet is retransmitted
>       and we enter CA_Loss; but this retransmission is spurious.
>
> (*3) The ACK for the original data is received. The transmitted packet
>       is acknowledged.  The TCP timestamp is before the retrans_stamp,
>       so tcp_may_undo() returns true, and tcp_try_undo_loss() returns
>       true without changing state to Open (because tcp_is_sack() is
>       false), and tcp_process_loss() returns without calling
>       tcp_try_undo_recovery().  Normally after undoing a CA_Loss
>       episode, tcp_fastretrans_alert() would see that the connection
>       has returned to CA_Open and fall through and call
>       tcp_try_to_open(), which would set retrans_stamp to 0.  However,
>       for non-SACK connections we hold the connection in CA_Loss, so do
>       not fall through to call tcp_try_to_open() and do not set
>       retrans_stamp to 0. So retrans_stamp is (erroneously) still
>       non-zero.
>
>       At this point the first "retransmission event" has passed and
>       been recovered from. Any future retransmission is a completely
>       new "event". However, retrans_stamp is erroneously still
>       set. (And we are still in CA_Loss, which is correct.)
>
> (*4) After 16 minutes (to correspond with tcp_retries2=15), a new data
>       packet is sent. Note: No data is transmitted between (*3) and
>       (*4) and we disabled keep alives.
>
>       The socket's timeout SHOULD be calculated from this point in
>       time, but instead it's calculated from the prior "event" 16
>       minutes ago (step (*2)).
>
> (*5) Because no ACK packet is received, the packet is retransmitted.
>
> (*6) At the time of the 2nd retransmission, the socket returns
>       ETIMEDOUT, prematurely, because retrans_stamp is (erroneously)
>       too far in the past (set at the time of (*2)).
>
> This commit fixes this bug by ensuring that we reuse in
> tcp_try_undo_loss() the same careful logic for non-SACK connections
> that we have in tcp_try_undo_recovery(). To avoid duplicating logic,
> we factor out that logic into a new
> tcp_is_non_sack_preventing_reopen() helper and call that helper from
> both undo functions.
>
> Fixes: da34ac7626b5 ("tcp: only undo on partial ACKs in CA_Loss")
> Reported-by: Nagaraj Arankal <nagaraj.p.arankal@hpe.com>
> Link: https://lore.kernel.org/all/SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM/
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Yuchung Cheng <ycheng@google.com>


Reviewed-by: Eric Dumazet <edumazet@google.com>

Amazing that some folks still do not enable SACK...

Thanks !



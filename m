Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3A2521FAA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 17:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbiEJPwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 11:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347036AbiEJPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 11:51:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08621246429;
        Tue, 10 May 2022 08:46:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B49ACB81DF7;
        Tue, 10 May 2022 15:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28478C385CA;
        Tue, 10 May 2022 15:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652197603;
        bh=iM9Ex4unx0/YzERfc9oAu4GcZ0NigJ1gWR2pmH2XcN4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ugH3wpnRjsF//gSIuN9fHMI/WKoVizf/Amq9iWzK4O8ou91ZKo0frRWgc9hjM+/r6
         62fZGhJQZ+Joc0BhraKFFwBgEJC4FKphLYsHtA8NDwYwtUzcxpzFLgpu+zQnReKPZN
         80UlWWAJouLOe4h59E+gj0DexBH6ge8FIm+FN92F+dnnkXFWuDoM/KufOvb3wGU4K4
         z7myCNbDvZePjtBC8LBjlFIIWRuEmSiue3+7k5hsH4laWsiwSCz4IW8+mGRuP7DyOP
         +i1D4vh/hRB79srG4EyQq8td6r6rAh+108nDUGVeILP6qFiyezKfkRW4bbmZifDvjF
         6k55GIN2dApAw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Abhishek Kumar <kuabhs@chromium.org>
Cc:     netdev@vger.kernel.org, dianders@chromium.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3] ath10k: improve BDF search fallback strategy
References: <20220509022618.v3.1.Ibfd52b9f0890fffe87f276fa84deaf6f1fb0055c@changeid>
        <87a6bp8kfn.fsf@kernel.org>
Date:   Tue, 10 May 2022 18:46:39 +0300
In-Reply-To: <87a6bp8kfn.fsf@kernel.org> (Kalle Valo's message of "Tue, 10 May
        2022 18:41:00 +0300")
Message-ID: <875ymd8k68.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

>>  static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
>>  					      const char *boardname,
>> -					      const char *fallback_boardname1,
>> -					      const char *fallback_boardname2,
>>  					      const char *filename)
>>  {
>> -	size_t len, magic_len;
>> +	size_t len, magic_len, board_len;
>>  	const u8 *data;
>>  	int ret;
>> +	char temp_boardname[100];
>> +
>> +	board_len = 100 * sizeof(temp_boardname[0]);
>
> Why not:
>
> board_len = sizeof(temp_board-name);
>
> That way number 100 is used only once.

BTW I'm not sure if it makes sense to CC David, Eric, Jakub and Paolo.
I'm sure they get a lot of email already. And I would also drop netdev.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

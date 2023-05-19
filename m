Return-Path: <netdev+bounces-3890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB1A7096BE
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 167AA1C2127B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A3B8C12;
	Fri, 19 May 2023 11:46:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A5C6ABF
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 11:46:58 +0000 (UTC)
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB3AE7;
	Fri, 19 May 2023 04:46:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-2536e522e47so1269731a91.1;
        Fri, 19 May 2023 04:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684496817; x=1687088817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSGGoVzH3JswzdDl5XE4PxxK2PV3ZgCuC8Lu9xCFt+I=;
        b=hG5hfdsttvTBHK/1SPB5ySPawmWk7IwRjf93Cbet3kH5Z/w+IcDTEOWBw/1oGK8Cpm
         +F9C/6fC9arjQy62Bk/M9dvXe5qhPLqj+DDlEf8XQ5Ym73dvErhgeX6NjbJCcvcctM/j
         YQIr0zh+ssZoGSeSLgUHDPonGzRc+j25MXUh+hh5LHgTzH/Jo70gEdx2/K2ub7jcufEZ
         IYyuz94mJBfnPTorzx+BZrAtO2hmyZzIuY35md5jgZyvQvYVIqW17Y9nolpesMbkJ5fp
         M4TNEVNiXb5B2a75L2UqWaVYuRZR6xI8nzoET02YHAlECrFb3lTk9Z1Sw6hZ2iYxj9/i
         QV0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684496817; x=1687088817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSGGoVzH3JswzdDl5XE4PxxK2PV3ZgCuC8Lu9xCFt+I=;
        b=Iiwq0AZauzlYvNwurWUxNC0vKKVCKbl7MabAHqISrNpUuxEgvf3ZjsS0bVcCcorx3o
         9vuEViANfBdSO1E29xjIZvzj0SjUWBSyBJCjP+KAma4UcNtAjELxMckZOw+JP53OHCgx
         sOxBnvXGhvIG8s9jqqcPO0aurEUkqZJXcWl4SFJMLMK5TC0Xuc/nezXYMjQEkl8TR0HO
         KKM4+HYvhMuZIHT4TfyeKn6egHJanlaPkcVnAVCSo+WSRZxZLraxEelsaRoQDHBRXPoV
         duO4wtOSWz3Im1jNKKUO0gtkxupeXcBlBZGpDktPIC7wiyrUbaGeJu04dZuFzEGwNft4
         4Qqw==
X-Gm-Message-State: AC+VfDzuf7dI4gQsRVLpbTa4vmJNkR0Kzv+4xVnrslwqJmI52q3P1nsi
	jFuUVxpoQ+RURZheLnNwnOiqroVDfbl78Q==
X-Google-Smtp-Source: ACHHUZ5eTDIvMi0ryM3825Op83HjK9I5LxXQOyeBPd3sVk+yQdTZsUAg5zhYuHpz5dml/S1Xt1JOIA==
X-Received: by 2002:a17:902:da90:b0:1ad:d500:19ce with SMTP id j16-20020a170902da9000b001add50019cemr2006451plx.41.1684496817179;
        Fri, 19 May 2023 04:46:57 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id jb15-20020a170903258f00b001ae626d051bsm3268919plb.70.2023.05.19.04.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 04:46:56 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: simon.horman@corigine.com
Cc: alexandre.torgue@foss.st.com,
	davem@davemloft.net,
	edumazet@google.com,
	joabreu@synopsys.com,
	kuba@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	mcoquelin.stm32@gmail.com,
	minhuadotchen@gmail.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	peppe.cavallaro@st.com
Subject: Re: [PATCH v2] net: stmmac: compare p->des0 and p->des1 with __le32
Date: Fri, 19 May 2023 19:46:52 +0800
Message-Id: <20230519114652.70372-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ZGdgA9jMLJOi1W1+@corigine.com>
References: <ZGdgA9jMLJOi1W1+@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>On Fri, May 19, 2023 at 07:25:08PM +0800, Min-Hua Chen wrote:
>> Use cpu_to_le32 to convert the constants to __le32 type
>> before comparing them with p->des0 and p->des1 (they are __le32 type)
>> and to fix following sparse warnings:
>> 
>> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:23: sparse: warning: restricted __le32 degrades to integer
>> drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c:110:50: sparse: warning: restricted __le32 degrades to integer
>> 
>> Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
>
>Reviewed-by: Simon Horman <simon.horman@corigine.com>
>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
>> index 13c347ee8be9..eefbeea04964 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
>> @@ -107,7 +107,8 @@ static int dwxgmac2_rx_check_timestamp(void *desc)
>>  	ts_valid = !(rdes3 & XGMAC_RDES3_TSD) && (rdes3 & XGMAC_RDES3_TSA);
>>  
>>  	if (likely(desc_valid && ts_valid)) {
>> -		if ((p->des0 == 0xffffffff) && (p->des1 == 0xffffffff))
>> +		if ((p->des0 == cpu_to_le32(0xffffffff)) &&
>> +		    (p->des1 == cpu_to_le32(0xffffffff)))
>
>nit: Sorry for not noticing this in v1.
>     There are unnecessary parentheses (both before and after this change).
>
Thanks, I noticed this before submitting v2 (by checkpath.pl) but I keep
the original parentheses.

I will do v3 with your Reviewed-by tag. :-)

thanks,
Min-Hua


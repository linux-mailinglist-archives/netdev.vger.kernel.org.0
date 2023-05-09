Return-Path: <netdev+bounces-1067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3A3D6FC0C6
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E11C81C20AED
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 07:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BCBC171CD;
	Tue,  9 May 2023 07:52:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8105F6121
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 07:52:48 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1633D1FC2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 00:52:47 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so56213189a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 00:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1683618765; x=1686210765;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vg6Z+9RzVIUKdCCBH5JNTY0AWar8rLGI5wuC5oLd2aI=;
        b=4s9fFKZnWfwt3R8lWVcozIClMrEOD2sSWftWeWWOS+fcqBs6kwvSYRLu6J4XfkoznX
         M/3c4EtyeGvwob+MlBfqxGruSTY5oKuL1x+DbUkcngLgL3sqvU6iP6P1NQLlcAdTCD1d
         w6P3YCY3hL68ITX8SHUAjWG9VTrOdEnOHk4/3k+tgXrcmqdaV/6wj/CB60EeGpxVlrgv
         7G4pIM++fmqbJJyVXeZDxyZjx2LTofTHyxrELbYycMUfttbJj3NHeBCrX9/LJoSfNz9n
         i5kW1EPW3UcRjiJoq9Xdj4pl8RCDqUnwuWH6Sgh/VltDZ+AtoCfhGhcWCTnY1wd1zNn6
         F6XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683618765; x=1686210765;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vg6Z+9RzVIUKdCCBH5JNTY0AWar8rLGI5wuC5oLd2aI=;
        b=UD6mdL/IPQN6wIyTU8fqP0G0posTqkewK7piW61SFA8RmsXx7hsuqT1KNN05jE1UAf
         CgkaCHIbl37jtBmM83QSOMHi9DtvnJyYtnfi80RpV3QShhmWXgNZ61vatBjOBQpYDWdg
         F+n9S7/Aky5icBkHt3nhQYBXeYiVcjaGfvbFfGttV5q4/1xhTwEhq5edvY/cEZw/r+aC
         w+oDFNOBGRm3+rrRH04n6JWIesXIubX2MbNDd5QNNzWeIkKXI/wYD+0pTcTSsp0E6qZ8
         0oLZ9PLfNqNrALfSlL3+J+b8uGIuzyRwWB/cyePsJbpDIBEY0jpaiTL9XQGmuYLtUpOx
         zSmA==
X-Gm-Message-State: AC+VfDz1Bkr5+NQOXK1s+IJ1TnCHKeLUFEmztH8Z2kqtPIbUEMjt9wcK
	chuzomd0NNTJMpK7ED4lhaOXcA==
X-Google-Smtp-Source: ACHHUZ60EXoRsJTa/aH8o9rzQDw4gxkquDoJjm/Sxey//GnG4RKyvoOt6A/v9d1DA+pJTomqznnVDw==
X-Received: by 2002:a17:907:1622:b0:965:aa65:233f with SMTP id hb34-20020a170907162200b00965aa65233fmr11808357ejc.2.1683618765345;
        Tue, 09 May 2023 00:52:45 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id pk25-20020a170906d7b900b00965d9892bafsm990542ejb.111.2023.05.09.00.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 00:52:44 -0700 (PDT)
Message-ID: <155bbdb3-0d74-f279-3c22-e62e06332c4e@blackwall.org>
Date: Tue, 9 May 2023 10:52:43 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCHv2 net] selftests: bonding: delete unnecessary line.
Content-Language: en-US
To: Liang Li <liali@redhat.com>, netdev@vger.kernel.org
Cc: j.vosburgh@gmail.com, Hangbin Liu <liuhangbin@gmail.com>
References: <20230509075025.952650-1-liali@redhat.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230509075025.952650-1-liali@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/05/2023 10:50, Liang Li wrote:
> "ip link set dev "$devbond1" nomaster"
> This line code in bond-eth-type-change.sh is unnecessary.
> Because $devbond1 was not added to any master device.
> 
> Fixes: 222c94ec0ad4("selftests: bonding: add tests for ether type changes")

It doesn't fix anything because there really isn't a bug. The test still runs
as expected with the line below.

> Signed-off-by: Liang Li <liali@redhat.com>
> Acked-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../selftests/drivers/net/bonding/bond-eth-type-change.sh        | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> index 5cdd22048ba7..862e947e17c7 100755
> --- a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> +++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> @@ -53,7 +53,6 @@ bond_test_enslave_type_change()
>  	# restore ARPHRD_ETHER type by enslaving such device
>  	ip link set dev "$devbond2" master "$devbond0"
>  	check_err $? "could not enslave $devbond2 to $devbond0"
> -	ip link set dev "$devbond1" nomaster
>  
>  	bond_check_flags "$devbond0"
>  

I still think this patch should be targeted at net-next instead, the test
runs as expected with or without that line.


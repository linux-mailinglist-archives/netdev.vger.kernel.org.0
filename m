Return-Path: <netdev+bounces-1094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 672536FC26C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F224281208
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FBBA8BE5;
	Tue,  9 May 2023 09:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C5120F7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:10:22 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD96DC4B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:10:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-965fc25f009so712701966b.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 02:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1683623414; x=1686215414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w4Zk74hjBT6v0imLj1sfYAkS3a8Ir/RO/VSV1ECIliI=;
        b=lrCyEa4ONssqtnmPakGYoSTfu7fE0P7RDjw2X7XRa6fU6WEOeRsQc2oh6uFGo2Et3V
         cmubgx7mA4vjGicPMhIt2yjuWjmMy1DBaZrT7q2H+TcGmoCQYEm4wecpWkVE4iwYOLw5
         Y8laYs33a4j/IHyc0ZTbCoBjyTSM+EFgp2ttoSo3W5YPLVtQY/GLQUOrUP0epGMOwqGa
         mWhyMJ7ULE4QOEzb+4YJ9XRpMQJmWt/WraM8LoxKYOk5hUj2w37Dc1OsFPwb2fEAygQq
         ArSBYfusPoSBZe37Hfw40pzoiX+vF5VJvrMIF5xv4dgiYy1otegzlG4U5tfvzfFAuaD1
         +MEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683623414; x=1686215414;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w4Zk74hjBT6v0imLj1sfYAkS3a8Ir/RO/VSV1ECIliI=;
        b=MRFMLY5OZusHvCQbjj+Wrn5uiJysSRc50QLAOAn0h/CwadnxKABLQlPMab9ZMnqfAz
         65wR4fjFvLfwDcHOuDa78syfVz1T/dFY96ddWWvmwuciLaySSY9V2BqqcgFXs6wMyJOe
         SWGuHOPpRiokzCNjnNY4e+OuW3As93amH1zMAEqxDbo45k5PrI2+zI6P6qjm6T2n3vAI
         7ILqm+CgMbrt9Xfi4W3ISr++RD/OAlubK26K3ivAxPONYBknLxWcr8ErUzJq4T+OCXpY
         pqoF/+EGPmBlFK/u5pyZ9j8eOky4qkevs/tbDHFafmq4p/xJs0a7ng2VXAkjnU8IehF5
         va2A==
X-Gm-Message-State: AC+VfDzqSpWxZ6AOSfqGCsv1H/dR2TiqN6D80RA5HZWEMdREjImbH28i
	p0OAKiA/d88oKGfyIoJWo5N1bQ==
X-Google-Smtp-Source: ACHHUZ5eongex6OkWW1j+D9LEdQZdXVp7ZzFhlWLgsvTVHNYNMYCuTAPaWIvsSkZ4/viSL+PhBSiUA==
X-Received: by 2002:a17:907:1c14:b0:95e:d74d:c4e6 with SMTP id nc20-20020a1709071c1400b0095ed74dc4e6mr14682616ejc.25.1683623414061;
        Tue, 09 May 2023 02:10:14 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id bu2-20020a170906a14200b0096654fdbe34sm1072955ejb.142.2023.05.09.02.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 02:10:13 -0700 (PDT)
Message-ID: <c87d19c1-51c3-deee-39e4-cd7a90f26436@blackwall.org>
Date: Tue, 9 May 2023 12:10:12 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] selftests: bonding: delete unnecessary line
Content-Language: en-US
To: Liang Li <liali@redhat.com>, netdev@vger.kernel.org
Cc: j.vosburgh@gmail.com, Hangbin Liu <liuhangbin@gmail.com>
References: <20230509090919.1100329-1-liali@redhat.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230509090919.1100329-1-liali@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/05/2023 12:09, Liang Li wrote:
> "ip link set dev "$devbond1" nomaster"
> This line code in bond-eth-type-change.sh is unnecessary.
> Because $devbond1 was not added to any master device.
> 
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


Thanks,
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



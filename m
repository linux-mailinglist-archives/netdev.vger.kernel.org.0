Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618BF4EA160
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbiC1UWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343736AbiC1UW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:22:27 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BF54349B
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 13:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648498844; x=1680034844;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pA9YTXhmyg8q3Iks/n8jCFydCQM4wqAoMli5Fw9S1Ew=;
  b=D3gbEgblZ/F2OOJNkV9CvSoNmVAUQH4op2gqCTR8iNT3Wv1h7MwYsH5M
   D6sxX51FA03ddiv2lm8dbmrbyNHs+j0iVWBlwyNrhcw7S1wARqZOtzzdB
   scqulPTGCnx01Tdiz9BmwHNlP49zsEvrqXL2cq2jyTk3zWbB4I4jOio6J
   GLco/REYYUr6m5wLKswfMaPSKfDeigPbc09YHn0xu64IBOgaUcrALT+sG
   IfSU+ktESPqqvP2tj71+cltTngG2X5D5YqSaSrFsFXOUDgUGs1Gs09him
   43QqFH69WtxsKT3qXrrtFwFzl9fWwdqJSQeTi4E2RB8i/lR/TtrgBYfH+
   A==;
X-IronPort-AV: E=Sophos;i="5.90,218,1643644800"; 
   d="scan'208";a="196480934"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 29 Mar 2022 04:20:42 +0800
IronPort-SDR: kHBADTqXWRfJ2lLHU7zxWO2wQQtfbblsyuwsq/7AAopLB3R/hBLB0SDUEYhNcjxqBFiae49YIT
 hnPufbYWwC3mj5gPkEOFbPDlX4AYImy29Rzemp1UQ8fqlCL5ms1kjKS61b6IbaFb9Lf9wCu/qE
 R2k4raXFdLnb6bZK4Vdo3u4dRA2y8dQp3dcOlis3LyEa3A+AOblZ7E+49wxtlk9d92kyJng3CG
 0TADe2bFlSrInag6oNH0KEXUhojJxSLStS9Rtq8JKabP9HucKOd/Y1XuRcqlTkuhI0DyhjUp/M
 wQTNHQhKd1zUMhvUF/iL4ae0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 12:52:28 -0700
IronPort-SDR: hCDkR1H/pr8mFreoBsZHfPrLjvqvHj8E6YO58iRHUXMgrCv/TvsgOjM1H1TAUohReM/DGmeFar
 hY0CJ7zQRBBNkGD1AIIkNxIMyDGSjcsVLvEmldaBqYZiNqvBB7S462xL6S1zQVqOLcRItn+18Z
 SOh9tEDUUFzvfD6b7dlo/CGdw4boR6ljJoVjIbB/h1PaA038Si0cfb+1LRpzASvivbVEmq2Q7u
 JLx/6KjrnL+NBG3EBuQhGBfScRUb1cy8p7zOqXMnrVbJhCI7Do3Kvt+4zEyCdyCe8sZmp3Ac47
 xdw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Mar 2022 13:20:43 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KS3wq42nQz1SVny
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 13:20:43 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1648498842; x=1651090843; bh=pA9YTXhmyg8q3Iks/n8jCFydCQM4wqAoMli
        5Fw9S1Ew=; b=jdvArbN8lPfKhu8N353FWpAGVsniobyHeNVVxykR/0132CTKpfM
        t6gATCIfKxXQlaV4/MP0hkZMYOr29e6p5Ac9gTXGjG42lBQgYMtp7wA4FVs8qSuR
        KPqQe222PpnMNdagEpg3tveZnQUQlxvbp7E4SuwrSQ6HFbJFSA7d/v+7L/JU6jTD
        UV/s+HgRFraZ6aQNFIyPfT4wMLdufCAp3pnEjGFgja9Ygp0I6Y8KdFecNtYWPxqI
        8mPCfiM22f3fSkw0u5myj8E7nfo7GU6HGhngh+QlAycQLRu9FGqrNiLag8MAH6Sj
        79FtRhMD6VTEeecqGT/mmbrmrTSEmBulkhg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UM0QLIQXEeEn for <netdev@vger.kernel.org>;
        Mon, 28 Mar 2022 13:20:42 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KS3wn60Xgz1Rvlx;
        Mon, 28 Mar 2022 13:20:41 -0700 (PDT)
Message-ID: <a0e7d211-44d9-e0ca-8493-96dcaf0a57e1@opensource.wdc.com>
Date:   Tue, 29 Mar 2022 05:20:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: bnxt_ptp: fix compilation error
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>
References: <20220328033540.189778-1-damien.lemoal@opensource.wdc.com>
 <CACKFLi=+5NpbeHDkDdKLg9uyfiDw4NL0=q0=shfrAYhqP+z2=w@mail.gmail.com>
 <2bc8f270-e402-5e34-8d87-6b02fe8ef777@opensource.wdc.com>
 <YkGuQXL5cRQveSlZ@lunn.ch>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YkGuQXL5cRQveSlZ@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/22 21:46, Andrew Lunn wrote:
>> The call to bnxt_ptp_cfg_pin() after the swith will return -ENOTSUPP for
>> invalid pin IDs. So I did not feel like adding more changes was necessary.
>>
>> We can return an error if you insist, but what should it be ? -EINVAL ?
>> -ENODEV ? -ENOTSUPP ? Given that bnxt_ptp_cfg_pin() return -ENOTSUPP, we
>> could use that code.
> 
> https://elixir.bootlin.com/linux/v5.17.1/source/include/linux/errno.h#L23
> 
> ENOTSUPP is an NFS only error code. It should not be used anywhere
> else. EOPNOTSUPP is the generic error that should be used. However,
> don't replace an ENOTSUPP with an EOPNOTSUPP without considering ABI.

Typo... the current error for invalid pin IDs is EOPNOTSUPP, not ENOTSUPP.
So I reused EOPNOTSUPP in the patch.

> 
>     Andrew


-- 
Damien Le Moal
Western Digital Research

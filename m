Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD0C51A1FF
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351203AbiEDOS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351197AbiEDOS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:18:27 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95EE242A1A
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651673691; x=1683209691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3gz1SvToUvc61rP9gSGLK3Q0CP+ks8gO3XkKncVaLcU=;
  b=fMT45tmFde2XzHg81790fsE6CNTWmrjFAlj8cgBBXEyjV1sSZdP7iKns
   TVlSubFd3DJo/0nZAWM34pXF88ndgw2ixIERaX1xcBaM7Yggas2GtAd8y
   p+fjeQFYhejAJUEdd4l7LiZDxQ0/+LBdp0AEKEo2i2oa4EDLxI66A3WpG
   u+wveCngn4HFypEsh2Jv+TvG8natzwuCgFQB+sD6sGnogP1i6QPIBKUp5
   Oa2ZcnDh/jKiOctkJ5k/7uNO0psTJ0krjpaeCgWbLRTemSCpDrfei2y9C
   fAvfvUfNTG9KvGIdRwPvHBtW/0giextkmiKwKW04pmlgzObJiJwqCC7tQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,198,1647273600"; 
   d="scan'208";a="198343926"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 May 2022 22:14:48 +0800
IronPort-SDR: V9EA91iSVbwrA0UlYsDgKcQ6weeijMuCrkZRmawr002ZsvrYVUddbaOZZgcKRNKYMqdJuisZY3
 6rWy9W+h4o+gDnkv1hzxb+Jc781iyUN3hxMRobk9IHs53I3m+M0Q+2+nHxYXY39R0gR+ffnAq6
 rH606Nc00LcN7M7CpAyIKSh8uu2ny3yUOzBB2WdCFf/BXJMU8YMp5aqliySNgrmrts2wqOIuR+
 T4woRrX6IkVpp9PfmF8DzNGOnS3kXsmyYabFkJwCFreVQMjQYgPQomMYvseohOI+ECSl662ULa
 tA9SPb5xC90yhOF4GVaHdv8l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 May 2022 06:45:30 -0700
IronPort-SDR: XdE0uweV0ufe04WEqBxKwGpgctN8hpwnYxcgT6S0WHIaXpKjpCKOOi3QAGSFlhdIHlq1QSm+p2
 TGhlpi27y7DJEmjr4epxYvHhYHXrKaJakqFjPUyAVzMfOLw6D/9i0NFl0ePwcKd4IOLkxqN5qA
 ZxzlJJkpSF2VpwR7u6YvH21Wf/RYD870EZU1wHNUUbaAh4y1Zl5BYYKBQQH2rtYwuX49GySi4V
 GRfnT1wfY2yIO+jRVTBEsKnYPWQXza1814uw/bCIDqFqMTFlMCgOaUUtfnJexkK18y8eUFr6H+
 QZM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 May 2022 07:14:49 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Ktf3W5Z9Pz1SVp3
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 07:14:47 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651673686; x=1654265687; bh=3gz1SvToUvc61rP9gSGLK3Q0CP+ks8gO3Xk
        KncVaLcU=; b=Irb3PekokvtqFuHO2x930y5RXWVryj/RHb7TPBz8hyKjQQGiEZS
        PNlDM4PBOewSd6GF6QqDO6PMCeng/9fFLxdgUo2KnanoesyieOuJq7vgIy5+qpxw
        37+IgA4VWZihtrROBbzcaUPUO/1emO4SxozHORu/HDrxTdhpZr13EOxk5Ls2EfcV
        /KiQamg4sm9jTZI9nmoP0HkKDzR49F0X1N8WiDmHBLdwWy+qovjqnq5+A1piy09q
        sFZWZpyq0sV2yJfo6NNJ7PY1KHDv2FMcro0qaeTbOCc//hkT7yDUI4wcYnREho+7
        1IyVSmCp4iio3QoJKV7OXxGBhwctFUqKhpQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TN5-VmKFktfM for <netdev@vger.kernel.org>;
        Wed,  4 May 2022 07:14:46 -0700 (PDT)
Received: from [10.225.81.200] (unknown [10.225.81.200])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Ktf3S0q49z1Rvlc;
        Wed,  4 May 2022 07:14:44 -0700 (PDT)
Message-ID: <a3d58159-292d-70e2-d811-e54c9b49c9c8@opensource.wdc.com>
Date:   Wed, 4 May 2022 23:14:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v1 2/4] powerpc/mpc5xxx: Switch
 mpc5xxx_get_bus_frequency() to use fwnode
Content-Language: en-US
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wolfram Sang <wsa@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
 <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220504134449.64473-2-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/05/04 22:44, Andy Shevchenko wrote:
> Switch mpc5xxx_get_bus_frequency() to use fwnode in order to help
> cleaning up other parts of the kernel from OF specific code.
> 
> No functional change intended.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

For the pata bits,

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

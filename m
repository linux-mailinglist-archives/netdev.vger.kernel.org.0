Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A08B54E802
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378399AbiFPQrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378332AbiFPQq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:46:56 -0400
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8108354023
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:45:51 -0700 (PDT)
Received: from webmail.uniroma2.it (webmail.uniroma2.it [160.80.1.162])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 25GGjAIr014523
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Jun 2022 18:45:15 +0200
Received: from host-95-238-25-28.retail.telecomitalia.it
 (host-95-238-25-28.retail.telecomitalia.it [95.238.25.28]) by
 webmail.uniroma2.it (Horde Framework) with HTTPS; Thu, 16 Jun 2022 18:45:06
 +0200
Date:   Thu, 16 Jun 2022 18:45:06 +0200
Message-ID: <20220616184506.Horde.7w03-P-A-1f4D_CFSrrRzEi@webmail.uniroma2.it>
From:   Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [iproute2-next v1] seg6: add support for flavors in SRv6 End*
 behaviors
References: <20220611110645.29434-1-paolo.lungaroni@uniroma2.it>
 <20220612091019.6223bf9a@hermes.local>
In-Reply-To: <20220612091019.6223bf9a@hermes.local>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,
Thanks for your review. Please see my answers inline.

Stephen Hemminger <stephen@networkplumber.org> ha scritto:

> On Sat, 11 Jun 2022 13:06:45 +0200
> Paolo Lungaroni <paolo.lungaroni@uniroma2.it> wrote:
>
>> +	strlcpy(wbuf, buf, SEG6_LOCAL_FLV_BUF_SIZE);
>> +	wbuf[SEG6_LOCAL_FLV_BUF_SIZE - 1] = 0;
>> +
>> +	if (strlen(wbuf) == 0)
>> +		return -1;
>
> If you use strdupa() then you don't have to worry about buffer sizes.

Yes sure, I will use it in the v2.

>
> +			else {
> +				if (fnumber++ == 0)
> +					fprintf(fp, "%s", flv_name);
> +				else
> +					fprintf(fp, ",%s", flv_name);
> +			}
>
> Minor nits. I am trying to get rid of use of passing fp around
> and just use print_string() everywhere. That way can do quick scan
> for places still using 'fprintf(fp' as indicator of old code
> that was never updated to use JSON.

Ok, substituting 'fprintf(fp' with print_string() is not a problem.

>
> Also, it looks the output of multiple flavors does not match
> the input command line for multiple flavors.

If you refer to the order, this is intentional as the user can add
flavors in any order, but they will be printed in a "canonical" order.

If it's not the order, can you clarify which is the problem?

Thanks for your suggestions,

Paolo.



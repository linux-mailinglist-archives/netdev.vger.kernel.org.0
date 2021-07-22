Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF2D3D2BB2
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhGVRZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:25:58 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:41133 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGVRZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:25:57 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 225B5200E7A8;
        Thu, 22 Jul 2021 20:06:30 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 225B5200E7A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626977190;
        bh=SO9oFomjqErx+ohHDl15s16qYEhfI6xMGpoUqzohLZY=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=cOiN7nV+WAu4gciNjiAj4SHOGfMMJBOw/mU8dEZ7ne6nsv1UEMHQuHfphTMWWTvN4
         FADtI8cQ73718J6FGbqumVEMKKJnby6nGxgBz+IttZ2w2ENR5aK6dFJOQtBzpvZrqh
         59BrU4HuS5wyGdtyWZNpufH7kbf5NejrDdddwc9uycrDMJrA/RJPiI761FqWv6h2K9
         aBnqGUIjb4rUzlSnnfaBIcqgMzhq0eNqdcKiMxdYA+1mEGczm4CwFe84y7PUCZmYD0
         d1jNCI3yx7iy3XXm2W9moJeelmOCxzS0Xj5uT1EtjaHRxKksdy3dxibxKklry0/OkE
         vQ3Xa8sNhVRFg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 175B6602255BB;
        Thu, 22 Jul 2021 20:06:30 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UEDa5z5teHFE; Thu, 22 Jul 2021 20:06:30 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id F11546008D842;
        Thu, 22 Jul 2021 20:06:29 +0200 (CEST)
Date:   Thu, 22 Jul 2021 20:06:29 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com
Message-ID: <439468627.25014964.1626977189905.JavaMail.zimbra@uliege.be>
In-Reply-To: <3801e3ce-089a-2252-ebdf-558b43824459@gmail.com>
References: <20210720194301.23243-1-justin.iurman@uliege.be> <20210720194301.23243-3-justin.iurman@uliege.be> <3801e3ce-089a-2252-ebdf-558b43824459@gmail.com>
Subject: Re: [PATCH net-next v5 2/6] ipv6: ioam: Data plane support for
 Pre-allocated Trace
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Data plane support for Pre-allocated Trace
Thread-Index: /tkQdeYkgMFyTAalbvvyxJY5mRfnPg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
>> index 5ad396a57eb3..c4c53a9ab959 100644
>> --- a/include/uapi/linux/in6.h
>> +++ b/include/uapi/linux/in6.h
>> @@ -145,6 +145,7 @@ struct in6_flowlabel_req {
>>  #define IPV6_TLV_PADN		1
>>  #define IPV6_TLV_ROUTERALERT	5
>>  #define IPV6_TLV_CALIPSO	7	/* RFC 5570 */
>> +#define IPV6_TLV_IOAM		49	/* TEMPORARY IANA allocation for IOAM */
> 
> why temporary and what is the risk the value changes between now and the
> final version?

David,

On the "why": it was initially requested by Tom Herbert to clarify that it was not standardized yet (at that time). And this is also the mention ("temporary") next to the allocated code by IANA (see [1]). So it's more about semantic here, nothing that important.

On the risk of change: short answer, there is none. Long answer, once the code is (temporarily) allocated, either the draft make it through and the current code allocation is kept by removing the "temporary" mention, or it is considered as deprecated and removed. Note that extension requests are possible (already made it once). Again, there are two related drafts: draft-ietf-ippm-ioam-data [2] is about to be standardized (see the current process status [3]), while draft-ietf-ippm-ioam-ipv6-options [4] (where the IANA code we're talking about is defined) will follow the same path shortly.

  [1] https://www.iana.org/assignments/ipv6-parameters/ipv6-parameters.xhtml#ipv6-parameters-2
  [2] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data
  [3] https://datatracker.ietf.org/doc/search/?name=draft-ietf-ippm-ioam-data&activedrafts=on&rfcs=on
  [4] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-ipv6-options

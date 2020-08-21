Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3AA24E269
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgHUVJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 17:09:16 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17565 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgHUVJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 17:09:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4037be0000>; Fri, 21 Aug 2020 14:08:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 21 Aug 2020 14:09:14 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 21 Aug 2020 14:09:14 -0700
Received: from [10.2.81.42] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 21 Aug
 2020 21:09:14 +0000
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
From:   Roopa Prabhu <roopa@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     <dsahern@gmail.com>, <netdev@vger.kernel.org>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
 <20200820213649.7cd6aa3f@hermes.lan>
 <1ad9fc74-db30-fee7-53c8-d1c208b8f9ec@nvidia.com>
Message-ID: <78abb0f7-7043-2612-58de-e64ecefd7ac5@nvidia.com>
Date:   Fri, 21 Aug 2020 14:09:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ad9fc74-db30-fee7-53c8-d1c208b8f9ec@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598044094; bh=p+S2U54uz9z91Az0uXuRvAJOPd4XmGz4xTTZ8Kqqpi0=;
        h=X-PGP-Universal:Subject:From:To:CC:References:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=D8X8DnWRUpkqU6cBheU/cDpOfzrLArhelwqFMyuiMEO1YubW9zwXqt1Wvsxn+XTgr
         WjI70IVM/Iy2sufn1zpTCWRPbydtNlHhxZo9Ea9EQFf63J+PmwuFahUMccs4IonLOv
         aAR9GAeJNQYdD15leuDK3I2Ezy3/AmlXBa8FSt0317QvX63dLE7HT9s8at20yCS+Pv
         0PLz22Wiiec3k/nJxFDy22ilMQgv6j9QReyUCIODejskfG1YtVb6scZfu+X/f7Ds/m
         vqRwf05uVJl8dEhbjH+TWT8FaT05Xu0ClruG/7I6lv6hkArMgDsbfRzuO/oArPud19
         D7Ru2NBwyZYZg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/20/20 10:18 PM, Roopa Prabhu wrote:
>
> On 8/20/20 9:36 PM, Stephen Hemminger wrote:
>>
>>
>> On Thu, 20 Aug 2020 20:52:02 -0700
>> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>>
>>> +=C2=A0=C2=A0=C2=A0=C2=A0 if (tb[IFLA_PROTO_DOWN]) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_bool(PRINT_ANY,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "proto_down", " protodown on ", =
true);
>> In general my preference is to use print_null() for presence flags.
>> Otherwise you have to handle the false case in JSON as a special case.
>
>
> ok, i will look. But this is existing code moved into a new function and
> has been
>
> working fine for years.


looked at print_null and switching to that results in a change in output=20
for existing protodown

attribute, so I plan to leave it as is for now.


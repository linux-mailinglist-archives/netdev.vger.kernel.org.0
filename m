Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5019A25648B
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 05:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgH2Djm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 23:39:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2736 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgH2Djl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 23:39:41 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f49cdd00001>; Fri, 28 Aug 2020 20:38:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 20:39:40 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 28 Aug 2020 20:39:40 -0700
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 29 Aug
 2020 03:39:40 +0000
Received: from [10.2.63.130] (172.20.13.39) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 29 Aug
 2020 03:39:40 +0000
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Roopa Prabhu <roopa@cumulusnetworks.com>, <dsahern@gmail.com>,
        <netdev@vger.kernel.org>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
 <20200820213649.7cd6aa3f@hermes.lan>
 <1ad9fc74-db30-fee7-53c8-d1c208b8f9ec@nvidia.com>
 <78abb0f7-7043-2612-58de-e64ecefd7ac5@nvidia.com>
 <20200821183002.7bfc7aa0@hermes.lan>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <5bec52a4-fcbd-4efa-3d7e-9462017d61c3@nvidia.com>
Date:   Fri, 28 Aug 2020 20:39:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200821183002.7bfc7aa0@hermes.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598672337; bh=O5HgWtUssS6JGzO7NL0P9D20NEEEK1aWeY2YVnG7ZN8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=BRuB1pZG2X0LIIy9lYs5ZRvX2TJgWUruGHC7EF7WgEHN/kRsdqofRA0F+GfTeeOWL
         xuLRKe8e1bVA2Kn9DHhiVv5plULxc/sd1I2/OTBHzjp53Tq+S/isphCBYTWXg4Ec6N
         HB/ib2W0jh6JPJpN9NZdF1SVXCBmuda1ylR7kmtDZdn2KN1JywiyhOIIt5gB3A3xQO
         u6W5GFnkaQ69e7HefmTl0vaEyUFHt7Wvk9aOCiD64ekkx8wgW4ez5T1Ae0fxbLYX+h
         7CCDdjZpDnrf9FjvX+gMND+j8AnPpXXJUmQNWequHRpMedzPVfs09aNSqwkRAm8pp6
         r6NcNdCNVmfgw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/21/20 6:30 PM, Stephen Hemminger wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, 21 Aug 2020 14:09:14 -0700
> Roopa Prabhu <roopa@nvidia.com> wrote:
>
>> On 8/20/20 10:18 PM, Roopa Prabhu wrote:
>>> On 8/20/20 9:36 PM, Stephen Hemminger wrote:
>>>>
>>>> On Thu, 20 Aug 2020 20:52:02 -0700
>>>> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>>>>
>>>>> +     if (tb[IFLA_PROTO_DOWN]) {
>>>>> +             if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
>>>>> +                     print_bool(PRINT_ANY,
>>>>> +                                "proto_down", " protodown on ", true=
);
>>>> In general my preference is to use print_null() for presence flags.
>>>> Otherwise you have to handle the false case in JSON as a special case.
>>>
>>> ok, i will look. But this is existing code moved into a new function an=
d
>>> has been
>>>
>>> working fine for years.
>>
>> looked at print_null and switching to that results in a change in output
>> for existing protodown
>>
>> attribute, so I plan to leave it as is for now.
>>
> Sure we should really try and have some consistency in the JSON output.
> Maybe a JSON style guide is needed, I wonder if some heavy JSON user alre=
ady
> has one?

yes, agreed. I think we need to checkin a guide for coders and=20
reviewers. specifically for the iproute2 json library.

Its hard to catch these at review time otherwise and most of iproute2=20
bugs are propagated due to copy-paste.

I checked if the FRR project had one as they have a lot of json routing=20
operational data. They don't and=C2=A0 rely on reviewers.

In the least i think the json library api documentation and a few best=20
practices will help.

thanks for the review.


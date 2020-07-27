Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30FD22FC57
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgG0Wnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:43:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3115 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0Wnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:43:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f1f583e0000>; Mon, 27 Jul 2020 15:42:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 27 Jul 2020 15:43:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 27 Jul 2020 15:43:36 -0700
Received: from [10.2.53.54] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 27 Jul
 2020 22:43:36 +0000
Subject: Re: [PATCH net-next] rtnetlink: add support for protodown reason
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <nikolay@cumulusnetworks.com>
References: <1595877677-45849-1-git-send-email-roopa@cumulusnetworks.com>
 <20200727134703.4243db74@hermes.lan>
From:   Roopa Prabhu <roopa@nvidia.com>
Message-ID: <82245748-d0b6-92c7-bb43-b6d006795d74@nvidia.com>
Date:   Mon, 27 Jul 2020 15:43:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200727134703.4243db74@hermes.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1595889726; bh=6OZG2R9HiqhWC5Tr4JunWcU2LmDMugElvrk9wVLu/04=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=eiFN5dUYTz+aUG3mWmV8hAf3lttHGSskUUpGpIZlH4lj9px4YUO6i3INiHlZ7tTxv
         dY1zIq+GOqnHnW2Zr5OUUQjSdrHWpANM3B3WKm20TTKLwPFN1ioqpsKjTb7yBFkW6S
         Q+a9Le1sOhi1toZH953fzTkOJe+LMxmdi7GJGFgwazZzhgrjBEHH9StiNFgGLJVwny
         WNDnVYgKWaaFn05g1lktKttmMDplOKJg32RdkUbWK3vx+FSdbl03ZTgwTYwcDYC64f
         Eww2gsfwryHhs7JimJegkAT6T8q+KM1I1EMov7Gu4+wpg1ZN1SpM9jQbAcIytAl63l
         Q5LGAZXy5TASg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/27/20 1:47 PM, Stephen Hemminger wrote:
> External email: Use caution opening links or attachments
>
>
> On Mon, 27 Jul 2020 12:21:17 -0700
> Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
>> -            + nla_total_size(1)  /* IFLA_PROTO_DOWN */
>> +            + rtnl_proto_down_size(dev)  /* proto down */
> Changing the size of a netlink field is an ABI change in the kernel.
> This has the potential to break existing programs.
>
> Wouldn't it be safer to add a new link attribute for the reason
> rather than overloading the existing attribute?


yes, It does add a new attribute. Its just that I moved all protodown 
attribute handling to a separate function

